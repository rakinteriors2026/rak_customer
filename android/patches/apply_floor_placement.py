#!/usr/bin/env python3
"""Sit furniture on the detected floor and place it when that floor is found.

The AR plugin scales a model but leaves its origin in the middle, and it only
places a model after a tap the Flutter view often swallows. This matches the
floor-anchor behaviour: the base of the model rests on the plane, and a ray
from the middle of the screen drops the piece in as soon as the floor is tracked.
"""

from pathlib import Path

MARKER = "rak-floor-origin"
CONSTRUCTOR = """                object : ModelNode(
                    modelInstance = modelInstance,
                    scaleToUnits = transformation.first().toFloat(),
                ) {"""
CONSTRUCTOR_PATCH = """                object : ModelNode(
                    modelInstance = modelInstance,
                    scaleToUnits = kotlin.math.abs(transformation.first().toFloat()),
                    // rak-floor-origin: base of the model rests on the plane
                    centerOrigin = Position(x = 0f, y = 0.5f, z = 0f),
                ) {"""
FIELD = "    private var showFeaturePoints = false\n"
FIELD_PATCH = (
    "    private var showFeaturePoints = false\n"
    "    private var placedFromFloor = false\n"
)
RAY = """                                frame.getUpdatedTrackables(Plane::class.java).forEach { plane ->
                                    if (plane.trackingState == TrackingState.TRACKING &&
                                        !detectedPlanes.contains(plane)
                                    ) {
                                        detectedPlanes.add(plane)
                                        mainScope.launch {
                                            sessionChannel.invokeMethod("onPlaneDetected", detectedPlanes.size)
                                        }
                                    }
                                }
"""
RAY_PATCH = """                                frame.getUpdatedTrackables(Plane::class.java).forEach { plane ->
                                    if (plane.trackingState == TrackingState.TRACKING &&
                                        !detectedPlanes.contains(plane)
                                    ) {
                                        detectedPlanes.add(plane)
                                        mainScope.launch {
                                            sessionChannel.invokeMethod("onPlaneDetected", detectedPlanes.size)
                                        }
                                    }
                                }

                                if (!placedFromFloor && sceneView.width > 0 && sceneView.height > 0) {
                                    val floorHits =
                                        frame.hitTest(
                                            sceneView.width / 2f,
                                            sceneView.height * 0.58f,
                                        ).filter { hit ->
                                            val trackable = hit.trackable
                                            trackable is Plane &&
                                                trackable.trackingState == TrackingState.TRACKING &&
                                                trackable.type == Plane.Type.HORIZONTAL_UPWARD_FACING
                                        }.map { hit ->
                                            mapOf(
                                                "type" to 1,
                                                "distance" to hit.distance.toDouble(),
                                                "position" to
                                                    mapOf(
                                                        "x" to hit.hitPose.tx().toDouble(),
                                                        "y" to hit.hitPose.ty().toDouble(),
                                                        "z" to hit.hitPose.tz().toDouble(),
                                                    ),
                                            )
                                        }
                                    if (floorHits.isNotEmpty()) {
                                        placedFromFloor = true
                                        notifyPlaneOrPointTap(floorHits)
                                    }
                                }
"""


def plugin_view() -> Path | None:
    roots = []
    pub_cache = Path.home() / ".pub-cache" / "hosted"
    if pub_cache.exists():
        roots.extend(pub_cache.iterdir())
    extra = Path.cwd()
    for env in ("PUB_CACHE",):
        import os

        raw = os.environ.get(env)
        if raw:
            roots.append(Path(raw) / "hosted")
    for root in roots:
        if not root.exists():
            continue
        matches = sorted(root.glob("*/ar_flutter_plugin_2-*/android/src/main/kotlin/com/uhg0/ar_flutter_plugin_2/ArView.kt"))
        if not matches:
            matches = sorted(root.glob("ar_flutter_plugin_2-*/android/src/main/kotlin/com/uhg0/ar_flutter_plugin_2/ArView.kt"))
        if matches:
            return matches[-1]
    return None


CONTROL_FROM = """        if (handlePans || handleRotation) {
            val name = call.argument<String>("name")"""
CONTROL_TO = """        // rak-floor-controls: turn and slide buttons apply even when gestures are off
        run {
            val name = call.argument<String>("name")"""
AXES_FROM = """                            rotation = SceneRotation(
                                x = kotlin.math.atan2(transform[6].toFloat(), transform[10].toFloat()),
                                y = kotlin.math.atan2(-transform[2].toFloat(), 
                                    kotlin.math.sqrt(transform[6].toFloat() * transform[6].toFloat() + 
                                    transform[10].toFloat() * transform[10].toFloat())),
                                z = kotlin.math.atan2(transform[1].toFloat(), transform[0].toFloat())
                            ),
                            scale = SceneScale(
                                x = kotlin.math.sqrt((transform[0] * transform[0] + transform[1] * transform[1] + transform[2] * transform[2]).toFloat()),
                                y = kotlin.math.sqrt((transform[4] * transform[4] + transform[5] * transform[5] + transform[6] * transform[6]).toFloat()),
                                z = kotlin.math.sqrt((transform[8] * transform[8] + transform[9] * transform[9] + transform[10] * transform[10]).toFloat())
                            )"""
AXES_TO = """                            // rak-floor-axes: ignore scale so X, Y and Z turns stay true
                            rotation = SceneRotation(
                                x = kotlin.math.atan2(transform[6].toFloat() / sy, transform[10].toFloat() / sz),
                                y = kotlin.math.atan2(-transform[2].toFloat() / sx,
                                    kotlin.math.sqrt((transform[6].toFloat() / sy) * (transform[6].toFloat() / sy) +
                                    (transform[10].toFloat() / sz) * (transform[10].toFloat() / sz))),
                                z = kotlin.math.atan2(transform[1].toFloat() / sx, transform[0].toFloat() / sx)
                            ),
                            scale = SceneScale(
                                x = sx,
                                y = sy,
                                z = sz
                            )"""
AXES_SCALE = """                    node.apply {
                        transform("""
AXES_SCALE_TO = """                    node.apply {
                        val sx = kotlin.math.sqrt((transform[0] * transform[0] + transform[1] * transform[1] + transform[2] * transform[2]).toFloat()).coerceAtLeast(1e-6f)
                        val sy = kotlin.math.sqrt((transform[4] * transform[4] + transform[5] * transform[5] + transform[6] * transform[6]).toFloat()).coerceAtLeast(1e-6f)
                        val sz = kotlin.math.sqrt((transform[8] * transform[8] + transform[9] * transform[9] + transform[10] * transform[10]).toFloat()).coerceAtLeast(1e-6f)
                        transform("""


def main() -> int:
    view = plugin_view()
    if view is None:
        print("AR floor patch: plugin source not in the pub cache yet")
        return 0
    text = view.read_text()
    changed = False
    if MARKER not in text:
        if CONSTRUCTOR not in text or FIELD not in text or RAY not in text:
            print(f"AR floor patch: {view} no longer matches, left unchanged")
        else:
            text = text.replace(CONSTRUCTOR, CONSTRUCTOR_PATCH, 1)
            text = text.replace(FIELD, FIELD_PATCH, 1)
            text = text.replace(RAY, RAY_PATCH, 1)
            changed = True
    if "rak-floor-controls" not in text and CONTROL_FROM in text:
        text = text.replace(CONTROL_FROM, CONTROL_TO, 1)
        changed = True
    if "rak-floor-axes" not in text and AXES_FROM in text and AXES_SCALE in text:
        text = text.replace(AXES_SCALE, AXES_SCALE_TO, 1)
        text = text.replace(AXES_FROM, AXES_TO, 1)
        changed = True
    if "rak-floor-lowest" not in text and "private fun notifyPlaneOrPointTap" in text:
        print(f"AR floor patch: {view} is missing the lowest-floor placement")
    if changed:
        view.write_text(text)
        print(f"AR floor patch applied to {view}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
