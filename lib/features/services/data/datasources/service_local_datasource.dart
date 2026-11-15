import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/services/domain/entities/interior_service.dart';

/// Curated demo list of RAK interior services.
///
/// Static reference content kept in code. Swapping to a network or database
/// source later only means implementing [ServiceRepository] against it.
class ServiceLocalDatasource {
  const ServiceLocalDatasource();

  static const String _pathPrefix = 'assets/services/';

  List<InteriorService> services() => const [
    InteriorService(
      id: 'svc_consultation',
      name: 'Design Consultation',
      tagline: 'Start with a plan',
      heroAsset: '${_pathPrefix}svc_consultation.jpg',
      summary: 'A guided first step to shape your home with our designers.',
      description:
          'We sit with you to understand how you live, measure the space '
          'and agree a direction and budget. You leave with a clear moodboard '
          'and a realistic plan before any work begins.',
      durationLabel: '1–2 weeks',
      startingPriceLabel: 'Free first visit',
      highlights: [
        'Home visit and measurement',
        'Style and budget discussion',
        'Moodboard and concept direction',
        'Transparent estimate',
      ],
      steps: [
        ServiceStep(
          title: 'Book a visit',
          detail: 'Tell us about your home and pick a convenient time.',
        ),
        ServiceStep(
          title: 'On-site discovery',
          detail: 'We measure the space and understand how you want to live.',
        ),
        ServiceStep(
          title: 'Concept direction',
          detail: 'You receive a moodboard, layout options and a clear budget.',
        ),
      ],
    ),
    InteriorService(
      id: 'svc_kitchen',
      name: 'Modular Kitchens',
      tagline: 'Cook, store and gather',
      heroAsset: '${_pathPrefix}svc_kitchen.jpg',
      summary: 'Hard-working modular kitchens built around how you cook.',
      description:
          'From compact galley layouts to large islands, we design kitchens '
          'that store more and work harder. Moisture-safe carcasses, soft-close '
          'hardware and durable tops are standard across every build.',
      durationLabel: '4–6 weeks',
      startingPriceLabel: 'From ₹1.5L',
      highlights: [
        'Custom layout and storage plan',
        'Moisture-resistant cabinetry',
        'Soft-close drawers and hinges',
        'Quartz or granite worktops',
      ],
      steps: [
        ServiceStep(
          title: 'Layout and storage',
          detail: 'We plan the work triangle and the storage you actually use.',
        ),
        ServiceStep(
          title: 'Finishes and appliances',
          detail: 'Pick shutters, tops and appliance cut-outs with our team.',
        ),
        ServiceStep(
          title: 'Build and install',
          detail: 'Factory-finished modules are fitted and quality checked.',
        ),
      ],
    ),
    InteriorService(
      id: 'svc_wardrobe',
      name: 'Custom Wardrobes',
      tagline: 'Storage that fits',
      heroAsset: '${_pathPrefix}svc_wardrobe.jpg',
      summary: 'Made-to-measure wardrobes that use every inch of the wall.',
      description:
          'Sliding or hinged, floor to ceiling, we build wardrobes around your '
          'clothes and your room. Internal organisers, soft lighting and quiet '
          'runners make them a pleasure to use every day.',
      durationLabel: '3–4 weeks',
      startingPriceLabel: 'From ₹80k',
      highlights: [
        'Floor-to-ceiling made to measure',
        'Sliding or hinged shutters',
        'Internal organisers and drawers',
        'Integrated profile lighting',
      ],
      steps: [
        ServiceStep(
          title: 'Measure and plan',
          detail: 'We map your storage needs against the available wall.',
        ),
        ServiceStep(
          title: 'Choose finishes',
          detail: 'Select shutter finishes, handles and internal fittings.',
        ),
        ServiceStep(
          title: 'Fit and finish',
          detail: 'The wardrobe is installed, aligned and handed over clean.',
        ),
      ],
    ),
    InteriorService(
      id: 'svc_ceiling',
      name: 'False Ceiling & Lighting',
      tagline: 'Set the mood',
      heroAsset: '${_pathPrefix}svc_ceiling.jpg',
      summary: 'Ceilings and lighting layers that quietly lift every room.',
      description:
          'We design ceilings that hide services and carry light well — cove '
          'lighting, recessed spots and a warm layer for the evening. The aim '
          'is a room that feels right at any time of day.',
      durationLabel: '2–3 weeks',
      startingPriceLabel: 'From ₹60k',
      highlights: [
        'Gypsum and cove ceiling design',
        'Layered recessed and accent lighting',
        'Concealed wiring and services',
        'Dimmable warm-white scheme',
      ],
      steps: [
        ServiceStep(
          title: 'Ceiling design',
          detail: 'We plan levels, coves and where the light should fall.',
        ),
        ServiceStep(
          title: 'Lighting layers',
          detail: 'Ambient, task and accent circuits are set out and wired.',
        ),
        ServiceStep(
          title: 'Finish and commission',
          detail: 'Ceilings are painted and the scene lighting is tuned.',
        ),
      ],
    ),
    InteriorService(
      id: 'svc_painting',
      name: 'Painting & Feature Walls',
      tagline: 'Colour and texture',
      heroAsset: 'assets/showcase/show_minimal_cover.jpg',
      summary: 'Clean paintwork and statement walls that set the tone.',
      description:
          'From full repaints to a single textured feature wall, we prep well '
          'and finish cleanly. Lime plaster, micro-cement and textured finishes '
          'are available where you want a room to stand out.',
      durationLabel: '1–2 weeks',
      startingPriceLabel: 'From ₹35k',
      highlights: [
        'Surface prep and premium emulsion',
        'Textured and lime-plaster finishes',
        'Feature-wall accents',
        'Clean, dust-controlled execution',
      ],
      steps: [
        ServiceStep(
          title: 'Colour and finish',
          detail: 'We agree the palette and where a feature wall adds most.',
        ),
        ServiceStep(
          title: 'Prep and protect',
          detail: 'Surfaces are repaired and masked for a clean result.',
        ),
        ServiceStep(
          title: 'Paint and reveal',
          detail: 'Finishes are applied in coats and the room is cleaned up.',
        ),
      ],
    ),
    InteriorService(
      id: 'svc_furniture',
      name: 'Furniture & Decor Styling',
      tagline: 'The finishing layer',
      heroAsset: '${_pathPrefix}svc_furniture.jpg',
      summary: 'Loose furniture, soft goods and decor that pull a room together.',
      description:
          'Once the shell is ready, we style it — sofas, rugs, lighting, art '
          'and the small pieces that make a house feel like home. Many items '
          'are available to order directly from the RAK shop.',
      durationLabel: '1–3 weeks',
      startingPriceLabel: 'From ₹50k',
      highlights: [
        'Furniture selection and layout',
        'Rugs, cushions and soft goods',
        'Decorative lighting and art',
        'Shop-ready piece recommendations',
      ],
      steps: [
        ServiceStep(
          title: 'Style direction',
          detail: 'We build a styling scheme that matches your interiors.',
        ),
        ServiceStep(
          title: 'Source and curate',
          detail: 'Pieces are selected, many shoppable in the RAK store.',
        ),
        ServiceStep(
          title: 'Style and place',
          detail: 'We place and style everything for the final reveal.',
        ),
      ],
    ),
  ];

  InteriorService service(String id) {
    for (final service in services()) {
      if (service.id == id) return service;
    }
    throw const NotFoundFailure('This service is not available.');
  }
}
