import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/showcase/domain/entities/showcase_project.dart';

/// Curated demo portfolio of finished RAK interiors.
///
/// This is static reference content rather than user data, so it lives in
/// code instead of the Drift seed. Swapping to a network or database source
/// later only means implementing [ShowcaseRepository] against a new source.
class ShowcaseLocalDatasource {
  const ShowcaseLocalDatasource();

  static const String _pathPrefix = 'assets/showcase/';

  // Shoppable pieces reused across projects. These map to real catalogue
  // products so a tap on the showcase detail opens the shop.
  static const ShowcasePiece _linenSofa = ShowcasePiece(
    name: 'Linen three-seat sofa',
    categoryLabel: 'Furniture',
    imageAsset: '${_pathPrefix}piece_linen_sofa.jpg',
    productId: 'prod_linen_sofa',
  );
  static const ShowcasePiece _brassPendant = ShowcasePiece(
    name: 'Brass dome pendant',
    categoryLabel: 'Lighting',
    imageAsset: '${_pathPrefix}piece_brass_pendant.jpg',
    productId: 'prod_brass_pendant',
  );
  static const ShowcasePiece _oakTable = ShowcasePiece(
    name: 'Oak dining table',
    categoryLabel: 'Furniture',
    imageAsset: '${_pathPrefix}piece_oak_table.jpg',
    productId: 'prod_oak_table',
  );
  static const ShowcasePiece _woolRug = ShowcasePiece(
    name: 'Hand-knotted wool rug',
    categoryLabel: 'Decor',
    imageAsset: '${_pathPrefix}piece_wool_rug.jpg',
    productId: 'prod_rug',
  );
  static const ShowcasePiece _wardrobe = ShowcasePiece(
    name: 'Walk-in wardrobe',
    categoryLabel: 'Storage',
    imageAsset: '${_pathPrefix}piece_wardrobe.jpg',
    productId: 'prod_wardrobe',
  );

  List<ShowcaseProject> projects() => const [
    ShowcaseProject(
      id: 'show_backwater',
      title: 'Backwater Villa',
      styleLabel: 'Warm contemporary',
      locationLabel: 'Kumarakom, Kerala',
      homeType: '4 BHK villa',
      summary: 'A warm, grounded home that opens to the backwaters.',
      story:
          'Oak runs through the living spaces to tie the rooms together, '
          'with storage built into the walls so the centre stays open. '
          'Natural linen and brass keep the palette soft and calm.',
      scopeLabel: 'Living, kitchen and bedrooms',
      coverAsset: '${_pathPrefix}showcase_backwater_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}showcase_backwater_cover.jpg',
          caption: 'Living room',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}showcase_backwater_bedroom.jpg',
          caption: 'Master bedroom',
        ),
      ],
      pieces: [
        _linenSofa,
        _brassPendant,
        _woolRug,
        ShowcasePiece(
          name: 'Oak-look laminate',
          categoryLabel: 'Finish',
          imageAsset: '${_pathPrefix}piece_oak_table.jpg',
          note: 'Specified throughout the living spaces.',
        ),
      ],
    ),
    ShowcaseProject(
      id: 'show_marine',
      title: 'Marine Drive Apartment',
      styleLabel: 'Modern minimal',
      locationLabel: 'Marine Drive, Kochi',
      homeType: '3 BHK apartment',
      summary: 'A bright, pared-back apartment with a sea view.',
      story:
          'Light oak and white stone keep the apartment airy, with '
          'handleless joinery and a few considered pieces. Brass accents '
          'add warmth without crowding the space.',
      scopeLabel: 'Living, dining and kitchen',
      coverAsset: '${_pathPrefix}showcase_marine_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}showcase_marine_cover.jpg',
          caption: 'Living room',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}showcase_marine_kitchen.jpg',
          caption: 'Kitchen and dining',
        ),
      ],
      pieces: [_oakTable, _brassPendant, _linenSofa],
    ),
    ShowcaseProject(
      id: 'show_hillview',
      title: 'Hill View Residence',
      styleLabel: 'Earthy contemporary',
      locationLabel: 'Munnar, Kerala',
      homeType: '5 BHK bungalow',
      summary: 'A cosy hill home built around stone, wood and the view.',
      story:
          'A stone feature wall and warm wood ceiling anchor the living '
          'areas, with textured plaster in earthy tones. Deep seating and '
          'a solid oak table make the home feel settled and generous.',
      scopeLabel: 'Living, dining and bedrooms',
      coverAsset: '${_pathPrefix}showcase_hillview_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}showcase_hillview_cover.jpg',
          caption: 'Living room',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}showcase_hillview_dining.jpg',
          caption: 'Dining room',
        ),
      ],
      pieces: [_oakTable, _linenSofa, _wardrobe, _woolRug],
    ),
    ShowcaseProject(
      id: 'show_lakeside',
      title: 'Lakeside Retreat',
      styleLabel: 'Warm contemporary',
      locationLabel: 'Alappuzha, Kerala',
      homeType: '3 BHK lake house',
      summary: 'An easy, open home that lives towards the water.',
      story:
          'Sliding glass opens the living room to a timber deck, so the '
          'lake becomes the back wall. Warm oak floors, a low linen sofa '
          'and brass lighting keep the mood restful through the day.',
      scopeLabel: 'Living, dining and deck',
      coverAsset: '${_pathPrefix}show_lakeside_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_lakeside_cover.jpg',
          caption: 'Living room',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_lakeside_room.jpg',
          caption: 'Lake-facing deck',
        ),
      ],
      pieces: [_linenSofa, _brassPendant, _woolRug],
    ),
    ShowcaseProject(
      id: 'show_heritage',
      title: 'Nalukettu Heritage Home',
      styleLabel: 'Traditional Kerala',
      locationLabel: 'Thrissur, Kerala',
      homeType: '6 BHK nalukettu',
      summary: 'A restored courtyard home where old timber meets new comfort.',
      story:
          'We kept the original rosewood columns and the open nadumuttam, '
          'then layered in quiet modern comfort — concealed lighting, a '
          'warm oak dining table and soft seating around the courtyard.',
      scopeLabel: 'Courtyard, living and dining',
      coverAsset: '${_pathPrefix}show_heritage_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_heritage_cover.jpg',
          caption: 'Central courtyard',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_heritage_room.jpg',
          caption: 'Living hall',
        ),
      ],
      pieces: [
        _oakTable,
        _woolRug,
        ShowcasePiece(
          name: 'Reclaimed teak panelling',
          categoryLabel: 'Finish',
          imageAsset: '${_pathPrefix}piece_oak_table.jpg',
          note: 'Restored from the original structure.',
        ),
      ],
    ),
    ShowcaseProject(
      id: 'show_studio',
      title: 'City Studio',
      styleLabel: 'Compact modern',
      locationLabel: 'Thiruvananthapuram, Kerala',
      homeType: 'Studio apartment',
      summary: 'One smart room that works as living, sleeping and work.',
      story:
          'A single joinery wall holds the bed, wardrobe and a fold-away '
          'desk, freeing the floor for a compact sofa and rug. Light tones '
          'and a tall mirror make the studio read far larger than it is.',
      scopeLabel: 'Full studio fit-out',
      coverAsset: '${_pathPrefix}show_studio_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_studio_cover.jpg',
          caption: 'Living and sleeping',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_studio_room.jpg',
          caption: 'Work nook',
        ),
      ],
      pieces: [_linenSofa, _woolRug, _wardrobe],
    ),
    ShowcaseProject(
      id: 'show_garden',
      title: 'Garden Court Villa',
      styleLabel: 'Biophilic contemporary',
      locationLabel: 'Kottayam, Kerala',
      homeType: '4 BHK villa',
      summary: 'A green, breathable home wrapped around an indoor garden.',
      story:
          'An indoor planter runs the length of the living room, with a '
          'skylight above it. Natural stone, oak and plenty of plants make '
          'the villa feel cool and alive even at midday.',
      scopeLabel: 'Living, dining and garden court',
      coverAsset: '${_pathPrefix}show_garden_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_garden_cover.jpg',
          caption: 'Garden court',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_garden_room.jpg',
          caption: 'Living room',
        ),
      ],
      pieces: [_linenSofa, _oakTable, _woolRug],
    ),
    ShowcaseProject(
      id: 'show_japandi',
      title: 'Japandi Apartment',
      styleLabel: 'Japandi minimal',
      locationLabel: 'Kakkanad, Kochi',
      homeType: '2 BHK apartment',
      summary: 'Calm, low-slung interiors with warm wood and soft light.',
      story:
          'Low furniture, paper-toned walls and oak joinery give the home '
          'a quiet, grounded feel. Everything has its place behind flush '
          'cabinetry, so the rooms stay uncluttered and serene.',
      scopeLabel: 'Living, dining and bedroom',
      coverAsset: '${_pathPrefix}show_japandi_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_japandi_cover.jpg',
          caption: 'Living room',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_japandi_room.jpg',
          caption: 'Bedroom',
        ),
      ],
      pieces: [_linenSofa, _oakTable, _wardrobe],
    ),
    ShowcaseProject(
      id: 'show_riverfront',
      title: 'Riverfront Penthouse',
      styleLabel: 'Luxe modern',
      locationLabel: 'Kozhikode, Kerala',
      homeType: '4 BHK penthouse',
      summary: 'A generous penthouse that trades on light and long views.',
      story:
          'Full-height glazing frames the river, so finishes stay muted — '
          'pale stone floors, walnut accents and brass. A sculptural sofa '
          'and layered lighting make the evenings feel like a hotel suite.',
      scopeLabel: 'Living, dining, kitchen and bedrooms',
      coverAsset: '${_pathPrefix}show_riverfront_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_riverfront_cover.jpg',
          caption: 'Living room',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_riverfront_room.jpg',
          caption: 'Dining',
        ),
      ],
      pieces: [_linenSofa, _brassPendant, _oakTable, _woolRug],
    ),
    ShowcaseProject(
      id: 'show_cottage',
      title: 'Misty Hill Cottage',
      styleLabel: 'Rustic cosy',
      locationLabel: 'Wayanad, Kerala',
      homeType: '2 BHK cottage',
      summary: 'A snug hill cottage made for cold mornings and slow coffee.',
      story:
          'Exposed rafters, a stone fireplace and deep wool textures make '
          'the cottage feel warm against the mist. Oak furniture and amber '
          'lighting keep the small rooms welcoming.',
      scopeLabel: 'Living and bedroom',
      coverAsset: '${_pathPrefix}show_cottage_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_cottage_cover.jpg',
          caption: 'Living room',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_cottage_room.jpg',
          caption: 'Bedroom',
        ),
      ],
      pieces: [_linenSofa, _woolRug, _brassPendant],
    ),
    ShowcaseProject(
      id: 'show_loft',
      title: 'Urban Loft',
      styleLabel: 'Industrial chic',
      locationLabel: 'Ernakulam, Kochi',
      homeType: 'Loft apartment',
      summary: 'A double-height loft balancing raw concrete with warm wood.',
      story:
          'We left the concrete ceiling and ducts exposed, then softened '
          'them with oak flooring, a leather-linen sofa and warm pendants. '
          'A steel-and-oak mezzanine adds a quiet study above the living.',
      scopeLabel: 'Living, mezzanine and kitchen',
      coverAsset: '${_pathPrefix}show_loft_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_loft_cover.jpg',
          caption: 'Living room',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_loft_room.jpg',
          caption: 'Mezzanine study',
        ),
      ],
      pieces: [_linenSofa, _brassPendant, _oakTable],
    ),
    ShowcaseProject(
      id: 'show_duplex',
      title: 'Sky Duplex',
      styleLabel: 'Contemporary luxe',
      locationLabel: 'Marine Drive, Kochi',
      homeType: '4 BHK duplex',
      summary: 'Two floors joined by a sculptural staircase and a light well.',
      story:
          'A timber-and-steel stair becomes the centrepiece, lit from a '
          'skylight above. Warm neutrals, oak joinery and layered lighting '
          'give both levels a calm, cohesive feel.',
      scopeLabel: 'Living, dining and bedrooms over two floors',
      coverAsset: '${_pathPrefix}show_duplex_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_duplex_cover.jpg',
          caption: 'Living and stair',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_duplex_room.jpg',
          caption: 'Upper landing',
        ),
      ],
      pieces: [_linenSofa, _oakTable, _wardrobe, _brassPendant],
    ),
    ShowcaseProject(
      id: 'show_minimal',
      title: 'Scandi Minimal Flat',
      styleLabel: 'Scandinavian minimal',
      locationLabel: 'Thiruvananthapuram, Kerala',
      homeType: '2 BHK apartment',
      summary: 'A bright, uncluttered flat built on light wood and white.',
      story:
          'Pale oak floors, white walls and a few soft textiles keep the '
          'flat calm and roomy. Hidden storage runs along one wall so the '
          'living space stays open and easy to live in.',
      scopeLabel: 'Living, dining and bedroom',
      coverAsset: '${_pathPrefix}show_minimal_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_minimal_cover.jpg',
          caption: 'Living room',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_minimal_room.jpg',
          caption: 'Bedroom',
        ),
      ],
      pieces: [_linenSofa, _woolRug, _wardrobe],
    ),
    ShowcaseProject(
      id: 'show_courtyard',
      title: 'Courtyard House',
      styleLabel: 'Tropical modern',
      locationLabel: 'Palakkad, Kerala',
      homeType: '4 BHK house',
      summary: 'A breezy home planned around a shaded central courtyard.',
      story:
          'The courtyard draws light and air into every room. Terracotta '
          'floors, lime-plastered walls and oak furniture keep the house '
          'cool, while a long veranda links the living and dining.',
      scopeLabel: 'Courtyard, living and dining',
      coverAsset: '${_pathPrefix}show_courtyard_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_courtyard_cover.jpg',
          caption: 'Courtyard',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_courtyard_room.jpg',
          caption: 'Living room',
        ),
      ],
      pieces: [_linenSofa, _oakTable, _woolRug],
    ),
    ShowcaseProject(
      id: 'show_seabreeze',
      title: 'Sea Breeze Villa',
      styleLabel: 'Coastal contemporary',
      locationLabel: 'Varkala, Kerala',
      homeType: '3 BHK villa',
      summary: 'A relaxed coastal home in whites, sand and driftwood tones.',
      story:
          'Lime-washed walls, rattan and bleached oak carry the sea into '
          'the house. Open shelving and a breezy layout keep the villa '
          'light, with brass fittings for a little warmth.',
      scopeLabel: 'Living, dining and bedrooms',
      coverAsset: '${_pathPrefix}show_seabreeze_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_seabreeze_cover.jpg',
          caption: 'Living room',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_seabreeze_room.jpg',
          caption: 'Bedroom',
        ),
      ],
      pieces: [_linenSofa, _brassPendant, _woolRug],
    ),
    ShowcaseProject(
      id: 'show_office',
      title: 'Boutique Design Office',
      styleLabel: 'Warm workspace',
      locationLabel: 'Infopark, Kochi',
      homeType: 'Commercial office',
      summary: 'A calm studio office that feels nothing like a cubicle farm.',
      story:
          'Oak desks, acoustic felt and warm lighting make the office feel '
          'like a home studio. A lounge corner with a linen sofa gives the '
          'team a softer place to meet and think.',
      scopeLabel: 'Workstations, cabins and lounge',
      coverAsset: '${_pathPrefix}show_office_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_office_cover.jpg',
          caption: 'Open workspace',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_office_room.jpg',
          caption: 'Lounge corner',
        ),
      ],
      pieces: [_linenSofa, _brassPendant, _oakTable],
    ),
    ShowcaseProject(
      id: 'show_cafe',
      title: 'Artisan Cafe',
      styleLabel: 'Hospitality',
      locationLabel: 'Fort Kochi, Kerala',
      homeType: 'Cafe fit-out',
      summary: 'A cosy neighbourhood cafe with warm wood and soft lighting.',
      story:
          'We built the cafe around a long oak communal table and a brass '
          'pendant run over the counter. Textured walls, plants and warm '
          'light make it an easy place to linger.',
      scopeLabel: 'Seating, counter and facade',
      coverAsset: '${_pathPrefix}show_cafe_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_cafe_cover.jpg',
          caption: 'Seating area',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_cafe_room.jpg',
          caption: 'Counter',
        ),
      ],
      pieces: [_oakTable, _brassPendant, _woolRug],
    ),
    ShowcaseProject(
      id: 'show_compact',
      title: 'Smart Compact 2BHK',
      styleLabel: 'Space-smart modern',
      locationLabel: 'Aluva, Kochi',
      homeType: '2 BHK apartment',
      summary: 'A small apartment that earns every inch through joinery.',
      story:
          'A fold-out dining table, a sofa-cum-bed and full-height storage '
          'let the flat flex through the day. Light oak and mirror keep it '
          'feeling open despite the compact footprint.',
      scopeLabel: 'Living, dining and bedroom',
      coverAsset: '${_pathPrefix}show_compact_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_compact_cover.jpg',
          caption: 'Living and dining',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_compact_room.jpg',
          caption: 'Bedroom',
        ),
      ],
      pieces: [_linenSofa, _wardrobe, _oakTable],
    ),
    ShowcaseProject(
      id: 'show_suite',
      title: 'Backwater Resort Suite',
      styleLabel: 'Luxury hospitality',
      locationLabel: 'Thekkady, Kerala',
      homeType: 'Resort suite',
      summary: 'A boutique suite that blends local craft with quiet luxury.',
      story:
          'Handwoven textiles, a carved headboard and warm teak give the '
          'suite a strong sense of place. A freestanding tub and layered '
          'lighting round out the resort feel.',
      scopeLabel: 'Bedroom, lounge and bath',
      coverAsset: '${_pathPrefix}show_suite_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_suite_cover.jpg',
          caption: 'Suite bedroom',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_suite_room.jpg',
          caption: 'Lounge',
        ),
      ],
      pieces: [_linenSofa, _brassPendant, _woolRug],
    ),
    ShowcaseProject(
      id: 'show_kitchenhome',
      title: 'Family Kitchen Home',
      styleLabel: 'Family contemporary',
      locationLabel: 'Kannur, Kerala',
      homeType: '3 BHK home',
      summary: 'A family home built around a hard-working modular kitchen.',
      story:
          'The kitchen is the heart of this home — a large island, deep '
          'pantry storage and a breakfast counter that opens to the living '
          'room. Warm oak and a durable quartz top keep it practical.',
      scopeLabel: 'Kitchen, dining and living',
      coverAsset: '${_pathPrefix}show_kitchenhome_cover.jpg',
      gallery: [
        ShowcaseImage(
          asset: '${_pathPrefix}show_kitchenhome_cover.jpg',
          caption: 'Modular kitchen',
        ),
        ShowcaseImage(
          asset: '${_pathPrefix}show_kitchenhome_room.jpg',
          caption: 'Dining and living',
        ),
      ],
      pieces: [_oakTable, _wardrobe, _brassPendant, _linenSofa],
    ),
  ];

  ShowcaseProject project(String id) {
    for (final project in projects()) {
      if (project.id == id) return project;
    }
    throw const NotFoundFailure('This project is not available.');
  }
}
