import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/catalog_models.dart';

const catalogSeedVersion = 1;
const catalogSeedContentIds = <String>[
  'seed-exposure-triangle-basics',
  'seed-golden-hour-portraits',
  'seed-leading-lines-composition',
  'seed-low-light-stability',
  'seed-white-balance-color',
  'seed-background-separation',
  'seed-histogram-check',
  'seed-rule-of-thirds-practice',
  'seed-motion-shutter-speed',
  'seed-lens-cleaning-checklist',
];
const localizedCatalogSeedContentIds = catalogSeedContentIds;
const catalogSeedLocales = <String>[
  'en',
  'it',
  'es',
  'fr',
  'de',
  'pt',
  'pt-BR',
];
const catalogSeedLocalizedLocales = <String>[
  'it',
  'es',
  'fr',
  'de',
  'pt',
  'pt-BR',
];

const _seedTimestampUtcMs = 1735689600000;

class CatalogSeedInstaller {
  CatalogSeedInstaller(this._database);

  final AppDatabase _database;

  Future<void> install() async {
    await _database.transaction(() async {
      await _upsertSource();
      await _upsertTags();
      for (final seed in _catalogSeeds) {
        await _database
            .into(_database.contentItems)
            .insertOnConflictUpdate(
              ContentItemsCompanion.insert(
                id: seed.id,
                type: seed.type.name,
                primaryCategory: seed.primaryCategory,
                difficulty: seed.difficulty.name,
                premium: seed.premium,
                canonicalLocale: 'en',
                editorialStatus: EditorialStatus.published.name,
                version: catalogSeedVersion,
                createdAtUtcMs: _seedTimestampUtcMs,
                updatedAtUtcMs: _seedTimestampUtcMs,
                publishedAtUtcMs: const Value(_seedTimestampUtcMs),
              ),
            );
        await _database
            .into(_database.contentItemSources)
            .insert(
              ContentItemSourcesCompanion.insert(
                contentId: seed.id,
                sourceId: _seedSourceId,
              ),
              mode: InsertMode.insertOrIgnore,
            );
        for (final tagCode in seed.tagCodes) {
          await _database
              .into(_database.contentItemTags)
              .insert(
                ContentItemTagsCompanion.insert(
                  contentId: seed.id,
                  tagId: _tagId(tagCode),
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }
        for (final translation in seed.translations) {
          await _database
              .into(_database.contentTranslations)
              .insertOnConflictUpdate(
                ContentTranslationsCompanion.insert(
                  id: '${seed.id}-${translation.locale}',
                  contentId: seed.id,
                  locale: translation.locale,
                  title: translation.title,
                  summary: translation.summary,
                  body: translation.body,
                  translationStatus: TranslationStatus.published.name,
                  translationMethod: translation.locale == 'en'
                      ? TranslationMethod.original.name
                      : TranslationMethod.machine.name,
                  sourceVersion: catalogSeedVersion,
                  reviewedAtUtcMs: const Value.absent(),
                  createdAtUtcMs: _seedTimestampUtcMs,
                  updatedAtUtcMs: _seedTimestampUtcMs,
                ),
              );
        }
      }
    });
  }

  Future<void> _upsertSource() async {
    await _database
        .into(_database.contentSources)
        .insertOnConflictUpdate(
          ContentSourcesCompanion.insert(
            id: _seedSourceId,
            title: 'FrameLab editorial seed set',
            author: const Value('FrameLab'),
            originalLocale: 'en',
            licenseType: 'CC-BY-4.0',
            attributionText: const Value('FrameLab editorial seed'),
            rightsStatus: RightsStatus.publishable.name,
            createdAtUtcMs: _seedTimestampUtcMs,
            updatedAtUtcMs: _seedTimestampUtcMs,
          ),
        );
  }

  Future<void> _upsertTags() async {
    for (final entry in _tagLabels.entries) {
      await _database
          .into(_database.tags)
          .insertOnConflictUpdate(
            TagsCompanion.insert(id: _tagId(entry.key), code: entry.key),
          );
      for (final label in entry.value.entries) {
        await _database
            .into(_database.tagTranslations)
            .insertOnConflictUpdate(
              TagTranslationsCompanion.insert(
                tagId: _tagId(entry.key),
                locale: label.key,
                label: label.value,
              ),
            );
      }
    }
  }
}

const _seedSourceId = 'source-framelab-editorial-seed';
String _tagId(String code) => 'tag-$code';

class _SeedContent {
  const _SeedContent({
    required this.id,
    required this.type,
    required this.primaryCategory,
    required this.difficulty,
    required this.premium,
    required this.tagCodes,
    required this.translations,
  });

  final String id;
  final ContentType type;
  final String primaryCategory;
  final Difficulty difficulty;
  final bool premium;
  final List<String> tagCodes;
  final List<_SeedTranslation> translations;
}

class _SeedTranslation {
  const _SeedTranslation({
    required this.locale,
    required this.title,
    required this.summary,
    required this.body,
  });

  final String locale;
  final String title;
  final String summary;
  final String body;
}

const _tagLabels = <String, Map<String, String>>{
  'exposure': {
    'en': 'Exposure',
    'it': 'Esposizione',
    'es': 'Exposición',
    'fr': 'Exposition',
    'de': 'Belichtung',
    'pt': 'Exposição',
    'pt-BR': 'Exposição',
  },
  'light': {
    'en': 'Light',
    'it': 'Luce',
    'es': 'Luz',
    'fr': 'Lumière',
    'de': 'Licht',
    'pt': 'Luz',
    'pt-BR': 'Luz',
  },
  'composition': {
    'en': 'Composition',
    'it': 'Composizione',
    'es': 'Composición',
    'fr': 'Composition',
    'de': 'Bildgestaltung',
    'pt': 'Composição',
    'pt-BR': 'Composição',
  },
  'stability': {
    'en': 'Stability',
    'it': 'Stabilità',
    'es': 'Estabilidad',
    'fr': 'Stabilité',
    'de': 'Stabilität',
    'pt': 'Estabilidade',
    'pt-BR': 'Estabilidade',
  },
  'color': {
    'en': 'Color',
    'it': 'Colore',
    'es': 'Color',
    'fr': 'Couleur',
    'de': 'Farbe',
    'pt': 'Cor',
    'pt-BR': 'Cor',
  },
  'focus': {
    'en': 'Focus',
    'it': 'Messa a fuoco',
    'es': 'Enfoque',
    'fr': 'Mise au point',
    'de': 'Fokus',
    'pt': 'Focagem',
    'pt-BR': 'Foco',
  },
  'metering': {
    'en': 'Metering',
    'it': 'Misurazione',
    'es': 'Medición',
    'fr': 'Mesure',
    'de': 'Belichtungsmessung',
    'pt': 'Medição',
    'pt-BR': 'Medição',
  },
  'practice': {
    'en': 'Practice',
    'it': 'Pratica',
    'es': 'Práctica',
    'fr': 'Pratique',
    'de': 'Übung',
    'pt': 'Prática',
    'pt-BR': 'Prática',
  },
  'motion': {
    'en': 'Motion',
    'it': 'Movimento',
    'es': 'Movimiento',
    'fr': 'Mouvement',
    'de': 'Bewegung',
    'pt': 'Movimento',
    'pt-BR': 'Movimento',
  },
  'maintenance': {
    'en': 'Maintenance',
    'it': 'Manutenzione',
    'es': 'Mantenimiento',
    'fr': 'Entretien',
    'de': 'Pflege',
    'pt': 'Manutenção',
    'pt-BR': 'Manutenção',
  },
};

const _catalogSeeds = <_SeedContent>[
  _SeedContent(
    id: 'seed-exposure-triangle-basics',
    type: ContentType.guide,
    primaryCategory: 'exposure',
    difficulty: Difficulty.beginner,
    premium: false,
    tagCodes: ['exposure'],
    translations: [
      _SeedTranslation(
        locale: 'en',
        title: 'Exposure triangle basics',
        summary:
            'Balance aperture, shutter speed and ISO before chasing style.',
        body:
            'Start with the effect you need most: aperture controls depth of field, shutter speed controls motion, and ISO controls how much the signal is amplified. Change one value at a time and compensate with another so the meter stays close to your intent. If the image is blurry, raise shutter speed before raising ISO. If the background distracts, open the aperture only as far as focus remains reliable.',
      ),
      _SeedTranslation(
        locale: 'it',
        title: 'Basi del triangolo dell’esposizione',
        summary:
            'Bilancia diaframma, tempo di scatto e ISO prima di cercare uno stile.',
        body:
            'Parti dall’effetto più importante: il diaframma controlla la profondità di campo, il tempo di scatto controlla il movimento e gli ISO regolano l’amplificazione del segnale. Cambia un valore alla volta e compensa con un altro, così l’esposimetro resta vicino alla tua intenzione. Se l’immagine è mossa, aumenta prima il tempo di scatto. Se lo sfondo distrae, apri il diaframma solo finché la messa a fuoco resta affidabile.',
      ),
      _SeedTranslation(
        locale: 'es',
        title: 'Bases del triángulo de exposición',
        summary:
            'Equilibra apertura, velocidad de obturación e ISO antes de buscar estilo.',
        body:
            'Empieza por el efecto que más necesitas: la apertura controla la profundidad de campo, la velocidad de obturación controla el movimiento y el ISO controla cuánto se amplifica la señal. Cambia un valor cada vez y compensa con otro para que el exposímetro se mantenga cerca de tu intención. Si la imagen sale trepidada, sube primero la velocidad. Si el fondo distrae, abre el diafragma solo hasta donde el enfoque siga siendo fiable.',
      ),
      _SeedTranslation(
        locale: 'fr',
        title: 'Bases du triangle d’exposition',
        summary:
            'Équilibre ouverture, vitesse d’obturation et ISO avant de chercher un style.',
        body:
            'Commence par l’effet le plus important : l’ouverture contrôle la profondeur de champ, la vitesse d’obturation contrôle le mouvement et l’ISO contrôle l’amplification du signal. Modifie une valeur à la fois et compense avec une autre pour garder la mesure proche de ton intention. Si l’image est floue de bougé, augmente d’abord la vitesse. Si l’arrière-plan distrait, ouvre le diaphragme seulement tant que la mise au point reste fiable.',
      ),
      _SeedTranslation(
        locale: 'de',
        title: 'Grundlagen des Belichtungsdreiecks',
        summary:
            'Stimme Blende, Verschlusszeit und ISO ab, bevor du nach Stil suchst.',
        body:
            'Beginne mit der Wirkung, die am wichtigsten ist: Die Blende steuert die Schärfentiefe, die Verschlusszeit steuert Bewegung, und ISO bestimmt, wie stark das Signal verstärkt wird. Ändere jeweils nur einen Wert und gleiche ihn mit einem anderen aus, damit die Messung deiner Absicht nahe bleibt. Ist das Bild verwackelt, verkürze zuerst die Verschlusszeit. Lenkt der Hintergrund ab, öffne die Blende nur so weit, wie der Fokus zuverlässig bleibt.',
      ),
      _SeedTranslation(
        locale: 'pt',
        title: 'Noções do triângulo de exposição',
        summary:
            'Equilibra abertura, velocidade do obturador e ISO antes de procurares estilo.',
        body:
            'Começa pelo efeito de que mais precisas: a abertura controla a profundidade de campo, a velocidade do obturador controla o movimento e o ISO controla a amplificação do sinal. Altera um valor de cada vez e compensa com outro para que o fotómetro se mantenha próximo da tua intenção. Se a imagem ficar tremida, aumenta primeiro a velocidade. Se o fundo distrair, abre o diafragma apenas enquanto a focagem continuar fiável.',
      ),
      _SeedTranslation(
        locale: 'pt-BR',
        title: 'Noções do triângulo de exposição',
        summary:
            'Equilibre abertura, velocidade do obturador e ISO antes de buscar estilo.',
        body:
            'Comece pelo efeito mais importante: a abertura controla a profundidade de campo, a velocidade do obturador controla o movimento e o ISO controla a amplificação do sinal. Altere um valor por vez e compense com outro para manter o fotômetro perto da sua intenção. Se a imagem ficar tremida, aumente primeiro a velocidade. Se o fundo distrair, abra o diafragma só até onde o foco continuar confiável.',
      ),
    ],
  ),
  _SeedContent(
    id: 'seed-golden-hour-portraits',
    type: ContentType.tip,
    primaryCategory: 'portrait',
    difficulty: Difficulty.beginner,
    premium: false,
    tagCodes: ['light'],
    translations: [
      _SeedTranslation(
        locale: 'en',
        title: 'Use golden hour for gentle portraits',
        summary:
            'Place the sun to the side or behind the subject for softer skin tones.',
        body:
            'During golden hour the sun is low, warmer and easier to shape. Ask the person to turn slowly until the light skims the face instead of hitting it straight on. If the background is much brighter, expose for the face and let highlights become gentle accents. A small step into open shade can keep the same warm colour while reducing squinting and contrast.',
      ),
      _SeedTranslation(
        locale: 'it',
        title: 'Usa l’ora dorata per ritratti morbidi',
        summary:
            'Metti il sole di lato o dietro al soggetto per toni della pelle più delicati.',
        body:
            'Durante l’ora dorata il sole è basso, più caldo e facile da modellare. Chiedi alla persona di ruotare lentamente finché la luce sfiora il viso invece di colpirlo frontalmente. Se lo sfondo è molto più luminoso, esponi per il volto e lascia che le alte luci diventino accenti leggeri. Un piccolo passo in ombra aperta mantiene lo stesso colore caldo riducendo occhi socchiusi e contrasto.',
      ),
      _SeedTranslation(
        locale: 'es',
        title: 'Usa la hora dorada para retratos suaves',
        summary:
            'Coloca el sol de lado o detrás del sujeto para tonos de piel más delicados.',
        body:
            'Durante la hora dorada el sol está bajo, es más cálido y resulta más fácil de moldear. Pide a la persona que gire despacio hasta que la luz roce el rostro en lugar de golpearlo de frente. Si el fondo es mucho más brillante, expón para la cara y deja que las luces altas sean acentos suaves. Un pequeño paso hacia sombra abierta conserva el color cálido y reduce entrecerrar los ojos y el contraste.',
      ),
      _SeedTranslation(
        locale: 'fr',
        title: 'Utilise l’heure dorée pour des portraits doux',
        summary:
            'Place le soleil de côté ou derrière le sujet pour des tons de peau plus doux.',
        body:
            'Pendant l’heure dorée, le soleil est bas, plus chaud et plus facile à modeler. Demande à la personne de tourner lentement jusqu’à ce que la lumière effleure le visage au lieu de le frapper de face. Si l’arrière-plan est beaucoup plus lumineux, expose pour le visage et laisse les hautes lumières devenir des accents doux. Un petit pas dans une ombre ouverte garde la même couleur chaude tout en réduisant plissements des yeux et contraste.',
      ),
      _SeedTranslation(
        locale: 'de',
        title: 'Nutze die goldene Stunde für sanfte Porträts',
        summary:
            'Setze die Sonne seitlich oder hinter das Motiv, damit Hauttöne weicher wirken.',
        body:
            'In der goldenen Stunde steht die Sonne tief, wirkt wärmer und lässt sich leichter formen. Bitte die Person, sich langsam zu drehen, bis das Licht das Gesicht streift statt frontal daraufzufallen. Ist der Hintergrund deutlich heller, belichte auf das Gesicht und lass Spitzlichter zu sanften Akzenten werden. Ein kleiner Schritt in offenen Schatten erhält die warme Farbe und reduziert Blinzeln sowie harten Kontrast.',
      ),
      _SeedTranslation(
        locale: 'pt',
        title: 'Usa a hora dourada para retratos suaves',
        summary:
            'Coloca o sol de lado ou atrás do motivo para tons de pele mais delicados.',
        body:
            'Durante a hora dourada, o sol está baixo, mais quente e é mais fácil de moldar. Pede à pessoa que rode devagar até a luz aflorar o rosto em vez de o atingir de frente. Se o fundo estiver muito mais claro, expõe para o rosto e deixa que as altas luzes se tornem apontamentos suaves. Um pequeno passo para sombra aberta mantém a cor quente e reduz olhos semicerrados e contraste.',
      ),
      _SeedTranslation(
        locale: 'pt-BR',
        title: 'Use a hora dourada para retratos suaves',
        summary:
            'Posicione o sol de lado ou atrás da pessoa para tons de pele mais delicados.',
        body:
            'Durante a hora dourada, o sol está baixo, mais quente e mais fácil de modelar. Peça para a pessoa girar devagar até a luz tocar o rosto de lado em vez de bater de frente. Se o fundo estiver muito mais claro, exponha para o rosto e deixe os realces virarem acentos suaves. Um pequeno passo para a sombra aberta mantém a cor quente e reduz olhos semicerrados e contraste.',
      ),
    ],
  ),
  _SeedContent(
    id: 'seed-leading-lines-composition',
    type: ContentType.technique,
    primaryCategory: 'composition',
    difficulty: Difficulty.beginner,
    premium: false,
    tagCodes: ['composition'],
    translations: [
      _SeedTranslation(
        locale: 'en',
        title: 'Guide the eye with leading lines',
        summary:
            'Use roads, rails, shadows or edges to point toward the subject.',
        body:
            'Leading lines work best when they begin near the edge of the frame and carry attention toward a clear subject. Move your feet until the line has a clean start and does not cut awkwardly through the person or object. Wide lenses exaggerate convergence, while longer lenses make the line feel calmer. Check the corners before shooting so the line supports the story instead of becoming clutter.',
      ),
      _SeedTranslation(
        locale: 'it',
        title: 'Guida lo sguardo con le linee guida',
        summary:
            'Usa strade, binari, ombre o bordi per puntare verso il soggetto.',
        body:
            'Le linee guida funzionano meglio quando iniziano vicino al bordo dell’inquadratura e portano l’attenzione verso un soggetto chiaro. Spostati finché la linea ha un inizio pulito e non taglia in modo scomodo la persona o l’oggetto. I grandangoli accentuano la convergenza, mentre le focali più lunghe rendono la linea più calma. Controlla gli angoli prima di scattare, così la linea sostiene la storia invece di creare confusione.',
      ),
      _SeedTranslation(
        locale: 'es',
        title: 'Guía la mirada con líneas de dirección',
        summary:
            'Usa caminos, raíles, sombras o bordes para dirigir la atención al sujeto.',
        body:
            'Las líneas de dirección funcionan mejor cuando empiezan cerca del borde del encuadre y llevan la atención hacia un sujeto claro. Muévete hasta que la línea tenga un inicio limpio y no corte de forma incómoda a la persona u objeto. Los angulares exageran la convergencia, mientras que las focales largas hacen que la línea resulte más tranquila. Revisa las esquinas antes de disparar para que la línea apoye la historia y no añada desorden.',
      ),
      _SeedTranslation(
        locale: 'fr',
        title: 'Guide le regard avec des lignes directrices',
        summary:
            'Utilise routes, rails, ombres ou bords pour diriger l’œil vers le sujet.',
        body:
            'Les lignes directrices fonctionnent mieux lorsqu’elles commencent près du bord du cadre et conduisent l’attention vers un sujet clair. Déplace-toi jusqu’à ce que la ligne ait un départ net et ne coupe pas maladroitement la personne ou l’objet. Les grands-angles accentuent la convergence, tandis que les focales plus longues rendent la ligne plus calme. Vérifie les coins avant de déclencher pour que la ligne serve le récit au lieu d’ajouter du désordre.',
      ),
      _SeedTranslation(
        locale: 'de',
        title: 'Lenke den Blick mit führenden Linien',
        summary:
            'Nutze Straßen, Schienen, Schatten oder Kanten, um zum Motiv zu führen.',
        body:
            'Führende Linien wirken am besten, wenn sie nahe am Bildrand beginnen und die Aufmerksamkeit zu einem klaren Motiv tragen. Verändere deinen Standpunkt, bis die Linie sauber startet und Person oder Objekt nicht ungünstig schneidet. Weitwinkel verstärken die Konvergenz, längere Brennweiten lassen die Linie ruhiger wirken. Prüfe vor dem Auslösen die Ecken, damit die Linie die Geschichte unterstützt statt Unruhe zu erzeugen.',
      ),
      _SeedTranslation(
        locale: 'pt',
        title: 'Guia o olhar com linhas de condução',
        summary:
            'Usa estradas, carris, sombras ou margens para apontar para o motivo.',
        body:
            'As linhas de condução funcionam melhor quando começam perto da margem do enquadramento e levam a atenção até um motivo claro. Move-te até a linha ter um início limpo e não cortar a pessoa ou o objeto de forma estranha. As grande-angulares exageram a convergência, enquanto distâncias focais maiores tornam a linha mais calma. Verifica os cantos antes de disparar para que a linha apoie a história em vez de criar confusão.',
      ),
      _SeedTranslation(
        locale: 'pt-BR',
        title: 'Guie o olhar com linhas de condução',
        summary:
            'Use ruas, trilhos, sombras ou bordas para apontar para o assunto.',
        body:
            'As linhas de condução funcionam melhor quando começam perto da borda do enquadramento e levam a atenção até um assunto claro. Mude sua posição até a linha ter um começo limpo e não cortar a pessoa ou o objeto de maneira estranha. Lentes grande-angulares exageram a convergência, enquanto distâncias focais maiores deixam a linha mais calma. Verifique os cantos antes de fotografar para que a linha apoie a história em vez de gerar poluição visual.',
      ),
    ],
  ),
  _SeedContent(
    id: 'seed-low-light-stability',
    type: ContentType.checklist,
    primaryCategory: 'low-light',
    difficulty: Difficulty.intermediate,
    premium: false,
    tagCodes: ['stability'],
    translations: [
      _SeedTranslation(
        locale: 'en',
        title: 'Keep low-light shots stable',
        summary: 'Stabilise your body before raising ISO or accepting blur.',
        body:
            'In low light, first remove movement you can control. Hold the camera with elbows close to the body, lean against a wall or table, and press the shutter smoothly instead of stabbing it. If the subject is still, try a slower shutter only after you are stable. For moving subjects, protect shutter speed first and raise ISO deliberately rather than hoping software will rescue motion blur.',
      ),
      _SeedTranslation(
        locale: 'it',
        title: 'Mantieni stabili gli scatti in poca luce',
        summary:
            'Stabilizza il corpo prima di alzare gli ISO o accettare il mosso.',
        body:
            'In poca luce, elimina prima i movimenti che puoi controllare. Tieni la fotocamera con i gomiti vicini al corpo, appoggiati a una parete o a un tavolo e premi il pulsante di scatto in modo fluido invece di colpirlo. Se il soggetto è fermo, prova un tempo più lento solo dopo esserti stabilizzato. Per soggetti in movimento, proteggi prima il tempo di scatto e alza gli ISO in modo consapevole, senza sperare che il software salvi il mosso.',
      ),
      _SeedTranslation(
        locale: 'es',
        title: 'Mantén estables las fotos con poca luz',
        summary:
            'Estabiliza el cuerpo antes de subir el ISO o aceptar trepidación.',
        body:
            'Con poca luz, elimina primero el movimiento que puedes controlar. Sujeta la cámara con los codos cerca del cuerpo, apóyate en una pared o mesa y pulsa el disparador con suavidad en lugar de golpearlo. Si el sujeto está quieto, prueba una velocidad más lenta solo cuando estés estable. Para sujetos en movimiento, protege primero la velocidad de obturación y sube el ISO de forma deliberada, sin esperar que el software arregle el desenfoque por movimiento.',
      ),
      _SeedTranslation(
        locale: 'fr',
        title: 'Garde les photos en basse lumière stables',
        summary:
            'Stabilise ton corps avant de monter l’ISO ou d’accepter le flou.',
        body:
            'En basse lumière, commence par supprimer les mouvements que tu peux contrôler. Tiens l’appareil avec les coudes près du corps, appuie-toi contre un mur ou une table et presse le déclencheur doucement au lieu de le frapper. Si le sujet est immobile, essaie une vitesse plus lente seulement une fois stable. Pour les sujets en mouvement, protège d’abord la vitesse d’obturation et augmente l’ISO volontairement plutôt que d’espérer qu’un logiciel sauve le flou de mouvement.',
      ),
      _SeedTranslation(
        locale: 'de',
        title: 'Halte Aufnahmen bei wenig Licht stabil',
        summary:
            'Stabilisiere deinen Körper, bevor du ISO erhöhst oder Unschärfe akzeptierst.',
        body:
            'Bei wenig Licht entferne zuerst die Bewegung, die du kontrollieren kannst. Halte die Kamera mit den Ellbogen nah am Körper, lehne dich an eine Wand oder einen Tisch und drücke den Auslöser ruhig statt ruckartig. Ist das Motiv unbewegt, versuche eine längere Verschlusszeit erst, wenn du stabil stehst. Bei bewegten Motiven sichere zuerst die Verschlusszeit und erhöhe ISO bewusst, statt darauf zu hoffen, dass Software Bewegungsunschärfe rettet.',
      ),
      _SeedTranslation(
        locale: 'pt',
        title: 'Mantém estáveis as fotografias com pouca luz',
        summary:
            'Estabiliza o corpo antes de aumentar o ISO ou aceitar arrastamento.',
        body:
            'Com pouca luz, elimina primeiro o movimento que consegues controlar. Segura a câmara com os cotovelos junto ao corpo, apoia-te numa parede ou numa mesa e prime o obturador suavemente em vez de o carregar de forma brusca. Se o motivo estiver parado, tenta uma velocidade mais lenta só depois de estares estável. Para motivos em movimento, protege primeiro a velocidade do obturador e aumenta o ISO de forma deliberada, sem esperar que o software salve o arrastamento.',
      ),
      _SeedTranslation(
        locale: 'pt-BR',
        title: 'Mantenha estáveis as fotos com pouca luz',
        summary:
            'Estabilize o corpo antes de aumentar o ISO ou aceitar tremido.',
        body:
            'Com pouca luz, elimine primeiro o movimento que você consegue controlar. Segure a câmera com os cotovelos perto do corpo, apoie-se em uma parede ou mesa e pressione o obturador suavemente em vez de dar um toque brusco. Se o assunto estiver parado, tente uma velocidade mais lenta só depois de estar estável. Para assuntos em movimento, proteja primeiro a velocidade do obturador e aumente o ISO de propósito, sem esperar que o software salve o borrão de movimento.',
      ),
    ],
  ),
  _SeedContent(
    id: 'seed-white-balance-color',
    type: ContentType.tip,
    primaryCategory: 'color',
    difficulty: Difficulty.beginner,
    premium: false,
    tagCodes: ['color'],
    translations: [
      _SeedTranslation(
        locale: 'en',
        title: 'Set white balance for believable colour',
        summary:
            'Match white balance to the light before judging exposure or skin tones.',
        body:
            'White balance does not change the amount of light, but it changes how the scene feels. Daylight, shade, tungsten and auto settings can all be useful when they match the story. If skin looks too orange under indoor lamps, try tungsten or a lower Kelvin value. If snow or shade looks too blue, warm the white balance slightly and check that whites still keep detail.',
      ),
      _SeedTranslation(
        locale: 'it',
        title: 'Imposta il bilanciamento del bianco per colori credibili',
        summary:
            'Adatta il bilanciamento del bianco alla luce prima di giudicare esposizione o incarnato.',
        body:
            'Il bilanciamento del bianco non cambia la quantità di luce, ma cambia la sensazione della scena. Luce diurna, ombra, tungsteno e automatico possono essere utili quando corrispondono al racconto. Se la pelle sembra troppo arancione sotto lampade interne, prova tungsteno o un valore Kelvin più basso. Se neve o ombra appaiono troppo blu, scalda leggermente il bilanciamento e controlla che i bianchi mantengano dettaglio.',
      ),
      _SeedTranslation(
        locale: 'es',
        title: 'Ajusta el balance de blancos para colores creíbles',
        summary:
            'Adapta el balance de blancos a la luz antes de juzgar exposición o tonos de piel.',
        body:
            'El balance de blancos no cambia la cantidad de luz, pero sí cambia cómo se siente la escena. Luz de día, sombra, tungsteno y automático pueden ser útiles cuando encajan con la historia. Si la piel se ve demasiado naranja bajo lámparas interiores, prueba tungsteno o un valor Kelvin más bajo. Si la nieve o la sombra se ven demasiado azules, calienta ligeramente el balance y comprueba que los blancos conserven detalle.',
      ),
      _SeedTranslation(
        locale: 'fr',
        title: 'Règle la balance des blancs pour des couleurs crédibles',
        summary:
            'Adapte la balance des blancs à la lumière avant de juger exposition ou tons de peau.',
        body:
            'La balance des blancs ne change pas la quantité de lumière, mais elle change la sensation de la scène. Lumière du jour, ombre, tungstène et mode automatique peuvent tous être utiles lorsqu’ils servent le récit. Si la peau paraît trop orange sous des lampes d’intérieur, essaie tungstène ou une valeur Kelvin plus basse. Si la neige ou l’ombre semble trop bleue, réchauffe légèrement la balance et vérifie que les blancs gardent du détail.',
      ),
      _SeedTranslation(
        locale: 'de',
        title: 'Stelle den Weißabgleich für glaubwürdige Farben ein',
        summary:
            'Passe den Weißabgleich ans Licht an, bevor du Belichtung oder Hauttöne beurteilst.',
        body:
            'Der Weißabgleich verändert nicht die Lichtmenge, aber er verändert die Wirkung der Szene. Tageslicht, Schatten, Kunstlicht und Automatik können nützlich sein, wenn sie zur Geschichte passen. Wirkt Haut unter Innenlampen zu orange, probiere Kunstlicht oder einen niedrigeren Kelvin-Wert. Wirken Schnee oder Schatten zu blau, wärme den Weißabgleich leicht an und prüfe, dass Weiß noch Zeichnung behält.',
      ),
      _SeedTranslation(
        locale: 'pt',
        title: 'Define o balanço de brancos para cores credíveis',
        summary:
            'Ajusta o balanço de brancos à luz antes de avaliares exposição ou tons de pele.',
        body:
            'O balanço de brancos não altera a quantidade de luz, mas muda a sensação da cena. Luz do dia, sombra, tungsténio e automático podem ser úteis quando combinam com a história. Se a pele parecer demasiado laranja sob lâmpadas interiores, experimenta tungsténio ou um valor Kelvin mais baixo. Se a neve ou a sombra parecerem demasiado azuis, aquece ligeiramente o balanço e confirma que os brancos ainda têm detalhe.',
      ),
      _SeedTranslation(
        locale: 'pt-BR',
        title: 'Defina o balanço de branco para cores convincentes',
        summary:
            'Ajuste o balanço de branco à luz antes de avaliar exposição ou tons de pele.',
        body:
            'O balanço de branco não muda a quantidade de luz, mas muda a sensação da cena. Luz do dia, sombra, tungstênio e automático podem ser úteis quando combinam com a história. Se a pele ficar muito laranja sob lâmpadas internas, teste tungstênio ou um valor Kelvin mais baixo. Se neve ou sombra parecerem azuis demais, aqueça levemente o balanço e confirme que os brancos ainda mantêm detalhe.',
      ),
    ],
  ),
  _SeedContent(
    id: 'seed-background-separation',
    type: ContentType.tip,
    primaryCategory: 'portrait',
    difficulty: Difficulty.beginner,
    premium: false,
    tagCodes: ['focus'],
    translations: [
      _SeedTranslation(
        locale: 'en',
        title: 'Separate the subject from the background',
        summary:
            'Use distance, focus and contrast to make the subject easier to read.',
        body:
            'Before changing lenses, look for ways to separate the subject. Ask the person to step away from the background, focus carefully on the nearest eye, and avoid bright distractions behind the head. A wider aperture can help, but distance and clean edges often matter more than the lowest f-number.',
      ),
      _SeedTranslation(
        locale: 'it',
        title: 'Separa il soggetto dallo sfondo',
        summary:
            'Usa distanza, messa a fuoco e contrasto per rendere il soggetto più leggibile.',
        body:
            'Prima di cambiare obiettivo, cerca modi per separare il soggetto. Chiedi alla persona di allontanarsi dallo sfondo, metti a fuoco con cura l’occhio più vicino ed evita distrazioni luminose dietro la testa. Un diaframma più aperto può aiutare, ma distanza e bordi puliti spesso contano più del numero f più basso.',
      ),
      _SeedTranslation(
        locale: 'es',
        title: 'Separa el sujeto del fondo',
        summary:
            'Usa distancia, enfoque y contraste para que el sujeto se lea mejor.',
        body:
            'Antes de cambiar de objetivo, busca formas de separar el sujeto. Pide a la persona que se aleje del fondo, enfoca con cuidado el ojo más cercano y evita distracciones brillantes detrás de la cabeza. Una apertura mayor puede ayudar, pero la distancia y los bordes limpios suelen importar más que el número f más bajo.',
      ),
      _SeedTranslation(
        locale: 'fr',
        title: 'Sépare le sujet de l’arrière-plan',
        summary:
            'Utilise distance, mise au point et contraste pour rendre le sujet plus lisible.',
        body:
            'Avant de changer d’objectif, cherche des moyens de séparer le sujet. Demande à la personne de s’éloigner de l’arrière-plan, fais soigneusement la mise au point sur l’œil le plus proche et évite les distractions lumineuses derrière la tête. Une ouverture plus grande peut aider, mais la distance et des contours propres comptent souvent davantage que le plus petit nombre f.',
      ),
      _SeedTranslation(
        locale: 'de',
        title: 'Trenne das Motiv vom Hintergrund',
        summary:
            'Nutze Abstand, Fokus und Kontrast, damit das Motiv leichter lesbar wird.',
        body:
            'Bevor du das Objektiv wechselst, suche nach Möglichkeiten, das Motiv zu trennen. Bitte die Person, Abstand zum Hintergrund zu nehmen, fokussiere sorgfältig auf das nächstgelegene Auge und vermeide helle Ablenkungen hinter dem Kopf. Eine größere Blende kann helfen, doch Abstand und klare Kanten sind oft wichtiger als die kleinste f-Zahl.',
      ),
      _SeedTranslation(
        locale: 'pt',
        title: 'Separa o motivo do fundo',
        summary:
            'Usa distância, focagem e contraste para tornar o motivo mais fácil de ler.',
        body:
            'Antes de mudares de objetiva, procura formas de separar o motivo. Pede à pessoa que se afaste do fundo, foca com cuidado o olho mais próximo e evita distrações luminosas atrás da cabeça. Uma abertura maior pode ajudar, mas a distância e contornos limpos muitas vezes importam mais do que o menor número f.',
      ),
      _SeedTranslation(
        locale: 'pt-BR',
        title: 'Separe o assunto do fundo',
        summary:
            'Use distância, foco e contraste para deixar o assunto mais fácil de ler.',
        body:
            'Antes de trocar de lente, procure formas de separar o assunto. Peça para a pessoa se afastar do fundo, foque com cuidado no olho mais próximo e evite distrações brilhantes atrás da cabeça. Uma abertura maior pode ajudar, mas distância e bordas limpas muitas vezes importam mais do que o menor número f.',
      ),
    ],
  ),
  _SeedContent(
    id: 'seed-histogram-check',
    type: ContentType.checklist,
    primaryCategory: 'exposure',
    difficulty: Difficulty.intermediate,
    premium: false,
    tagCodes: ['metering'],
    translations: [
      _SeedTranslation(
        locale: 'en',
        title: 'Check the histogram after difficult light',
        summary:
            'Use the histogram to confirm whether important highlights or shadows are clipped.',
        body:
            'The preview can lie in bright sun or at night, but the histogram gives a better warning. After a difficult frame, check whether the graph is pressed hard against the left or right edge. Some clipping is acceptable in tiny reflections or deep shadows, but protect faces, skies and product details when they matter to the story.',
      ),
      _SeedTranslation(
        locale: 'it',
        title: 'Controlla l’istogramma dopo una luce difficile',
        summary:
            'Usa l’istogramma per verificare se alte luci o ombre importanti sono tagliate.',
        body:
            'L’anteprima può ingannare sotto il sole forte o di notte, ma l’istogramma offre un avviso più affidabile. Dopo uno scatto difficile, controlla se il grafico è schiacciato contro il bordo sinistro o destro. Un po’ di clipping è accettabile in piccoli riflessi o ombre profonde, ma proteggi volti, cieli e dettagli di prodotto quando sono importanti per la storia.',
      ),
      _SeedTranslation(
        locale: 'es',
        title: 'Revisa el histograma tras una luz difícil',
        summary:
            'Usa el histograma para confirmar si luces o sombras importantes están recortadas.',
        body:
            'La previsualización puede engañar con sol fuerte o de noche, pero el histograma da una advertencia mejor. Después de una toma difícil, comprueba si el gráfico está pegado al borde izquierdo o derecho. Algo de recorte es aceptable en reflejos pequeños o sombras profundas, pero protege rostros, cielos y detalles de producto cuando importan a la historia.',
      ),
      _SeedTranslation(
        locale: 'fr',
        title: 'Vérifie l’histogramme après une lumière difficile',
        summary:
            'Utilise l’histogramme pour confirmer si des hautes lumières ou ombres importantes sont écrêtées.',
        body:
            'L’aperçu peut mentir en plein soleil ou la nuit, mais l’histogramme donne un meilleur avertissement. Après une image difficile, vérifie si le graphique est collé au bord gauche ou droit. Un peu d’écrêtage est acceptable dans de petits reflets ou des ombres profondes, mais protège les visages, les ciels et les détails de produit lorsqu’ils comptent pour le récit.',
      ),
      _SeedTranslation(
        locale: 'de',
        title: 'Prüfe nach schwierigem Licht das Histogramm',
        summary:
            'Nutze das Histogramm, um abgeschnittene wichtige Lichter oder Schatten zu erkennen.',
        body:
            'Die Vorschau kann in greller Sonne oder bei Nacht täuschen, doch das Histogramm warnt zuverlässiger. Prüfe nach einer schwierigen Aufnahme, ob die Kurve hart am linken oder rechten Rand liegt. Etwas Clipping ist in kleinen Reflexen oder tiefen Schatten akzeptabel, aber schütze Gesichter, Himmel und Produktdetails, wenn sie für die Geschichte wichtig sind.',
      ),
      _SeedTranslation(
        locale: 'pt',
        title: 'Verifica o histograma após luz difícil',
        summary:
            'Usa o histograma para confirmar se altas luzes ou sombras importantes ficaram cortadas.',
        body:
            'A pré-visualização pode enganar sob sol forte ou à noite, mas o histograma dá um aviso melhor. Depois de uma fotografia difícil, verifica se o gráfico está encostado ao limite esquerdo ou direito. Algum corte é aceitável em pequenos reflexos ou sombras profundas, mas protege rostos, céus e detalhes de produto quando forem importantes para a história.',
      ),
      _SeedTranslation(
        locale: 'pt-BR',
        title: 'Confira o histograma depois de luz difícil',
        summary:
            'Use o histograma para confirmar se realces ou sombras importantes foram cortados.',
        body:
            'A prévia pode enganar sob sol forte ou à noite, mas o histograma dá um alerta melhor. Depois de uma foto difícil, confira se o gráfico está colado na borda esquerda ou direita. Um pouco de corte é aceitável em pequenos reflexos ou sombras profundas, mas proteja rostos, céus e detalhes de produto quando eles forem importantes para a história.',
      ),
    ],
  ),
  _SeedContent(
    id: 'seed-rule-of-thirds-practice',
    type: ContentType.challenge,
    primaryCategory: 'composition',
    difficulty: Difficulty.beginner,
    premium: false,
    tagCodes: ['practice'],
    translations: [
      _SeedTranslation(
        locale: 'en',
        title: 'Practise the rule of thirds without obeying it blindly',
        summary:
            'Place the subject off-centre, then decide whether the frame actually improves.',
        body:
            'Turn on the grid and make three versions: subject centred, subject on a third, and subject near the edge. Compare how the background, empty space and direction of movement change. The rule of thirds is a useful prompt, not a law. Keep the version that gives the subject the clearest visual reason to be there.',
      ),
      _SeedTranslation(
        locale: 'it',
        title: 'Esercitati con la regola dei terzi senza seguirla alla cieca',
        summary:
            'Metti il soggetto decentrato, poi decidi se l’inquadratura migliora davvero.',
        body:
            'Attiva la griglia e realizza tre versioni: soggetto al centro, soggetto su un terzo e soggetto vicino al bordo. Confronta come cambiano sfondo, spazio vuoto e direzione del movimento. La regola dei terzi è uno stimolo utile, non una legge. Tieni la versione che dà al soggetto la ragione visiva più chiara per trovarsi lì.',
      ),
      _SeedTranslation(
        locale: 'es',
        title: 'Practica la regla de los tercios sin obedecerla a ciegas',
        summary:
            'Coloca el sujeto descentrado y decide si el encuadre realmente mejora.',
        body:
            'Activa la cuadrícula y haz tres versiones: sujeto centrado, sujeto en un tercio y sujeto cerca del borde. Compara cómo cambian el fondo, el espacio vacío y la dirección del movimiento. La regla de los tercios es una guía útil, no una ley. Conserva la versión que dé al sujeto la razón visual más clara para estar ahí.',
      ),
      _SeedTranslation(
        locale: 'fr',
        title: 'Pratique la règle des tiers sans lui obéir aveuglément',
        summary:
            'Place le sujet hors centre, puis décide si le cadrage s’améliore vraiment.',
        body:
            'Active la grille et fais trois versions : sujet centré, sujet sur un tiers et sujet près du bord. Compare comment l’arrière-plan, l’espace vide et la direction du mouvement changent. La règle des tiers est une incitation utile, pas une loi. Garde la version qui donne au sujet la raison visuelle la plus claire d’être là.',
      ),
      _SeedTranslation(
        locale: 'de',
        title: 'Übe die Drittelregel, ohne ihr blind zu folgen',
        summary:
            'Platziere das Motiv außerhalb der Mitte und entscheide dann, ob das Bild wirklich besser wird.',
        body:
            'Schalte das Raster ein und mache drei Versionen: Motiv in der Mitte, Motiv auf einem Drittel und Motiv nahe am Rand. Vergleiche, wie sich Hintergrund, Leerraum und Bewegungsrichtung verändern. Die Drittelregel ist ein hilfreicher Impuls, kein Gesetz. Behalte die Version, die dem Motiv den klarsten visuellen Grund gibt, dort zu sein.',
      ),
      _SeedTranslation(
        locale: 'pt',
        title: 'Pratica a regra dos terços sem a obedecer cegamente',
        summary:
            'Coloca o motivo fora do centro e decide se o enquadramento melhora mesmo.',
        body:
            'Ativa a grelha e faz três versões: motivo centrado, motivo num terço e motivo perto da margem. Compara como mudam o fundo, o espaço vazio e a direção do movimento. A regra dos terços é um estímulo útil, não uma lei. Mantém a versão que dá ao motivo a razão visual mais clara para estar ali.',
      ),
      _SeedTranslation(
        locale: 'pt-BR',
        title: 'Pratique a regra dos terços sem obedecer cegamente',
        summary:
            'Coloque o assunto fora do centro e decida se o enquadramento realmente melhora.',
        body:
            'Ative a grade e faça três versões: assunto centralizado, assunto em um terço e assunto perto da borda. Compare como mudam o fundo, o espaço vazio e a direção do movimento. A regra dos terços é um estímulo útil, não uma lei. Fique com a versão que dá ao assunto a razão visual mais clara para estar ali.',
      ),
    ],
  ),
  _SeedContent(
    id: 'seed-motion-shutter-speed',
    type: ContentType.technique,
    primaryCategory: 'motion',
    difficulty: Difficulty.intermediate,
    premium: false,
    tagCodes: ['motion'],
    translations: [
      _SeedTranslation(
        locale: 'en',
        title: 'Choose shutter speed for motion, not only brightness',
        summary:
            'Decide whether movement should freeze, blur or show a controlled pan.',
        body:
            'Shutter speed is a creative decision. Fast speeds freeze gestures, splashes and jumps. Slower speeds can show flow in water, traffic or dancers, but they also reveal camera shake. If you pan with a moving subject, keep your feet stable, rotate from the waist and follow through after pressing the shutter.',
      ),
      _SeedTranslation(
        locale: 'it',
        title:
            'Scegli il tempo di scatto per il movimento, non solo per la luminosità',
        summary:
            'Decidi se il movimento deve congelarsi, sfocare o mostrare un panning controllato.',
        body:
            'Il tempo di scatto è una scelta creativa. Tempi rapidi congelano gesti, schizzi e salti. Tempi più lenti possono mostrare il flusso di acqua, traffico o danzatori, ma rivelano anche il micromosso della fotocamera. Se fai panning con un soggetto in movimento, tieni i piedi stabili, ruota dal busto e continua il movimento dopo aver premuto il pulsante di scatto.',
      ),
      _SeedTranslation(
        locale: 'es',
        title:
            'Elige la velocidad de obturación por el movimiento, no solo por la luz',
        summary:
            'Decide si el movimiento debe congelarse, difuminarse o mostrar un barrido controlado.',
        body:
            'La velocidad de obturación es una decisión creativa. Las velocidades rápidas congelan gestos, salpicaduras y saltos. Las velocidades más lentas pueden mostrar el flujo del agua, el tráfico o bailarines, pero también revelan trepidación de la cámara. Si haces un barrido con un sujeto en movimiento, mantén los pies estables, gira desde la cintura y continúa el movimiento después de pulsar el disparador.',
      ),
      _SeedTranslation(
        locale: 'fr',
        title:
            'Choisis la vitesse d’obturation pour le mouvement, pas seulement la luminosité',
        summary:
            'Décide si le mouvement doit être figé, flou ou montré par un filé contrôlé.',
        body:
            'La vitesse d’obturation est une décision créative. Les vitesses rapides figent gestes, éclaboussures et sauts. Des vitesses plus lentes peuvent montrer le flux de l’eau, du trafic ou des danseurs, mais elles révèlent aussi le bougé de l’appareil. Si tu fais un filé avec un sujet en mouvement, garde les pieds stables, tourne depuis la taille et poursuis le mouvement après avoir pressé le déclencheur.',
      ),
      _SeedTranslation(
        locale: 'de',
        title:
            'Wähle die Verschlusszeit für Bewegung, nicht nur für Helligkeit',
        summary:
            'Entscheide, ob Bewegung einfrieren, verwischen oder als kontrollierter Mitzieher erscheinen soll.',
        body:
            'Die Verschlusszeit ist eine kreative Entscheidung. Kurze Zeiten frieren Gesten, Spritzer und Sprünge ein. Längere Zeiten können Fluss in Wasser, Verkehr oder Tänzern zeigen, offenbaren aber auch Kamerawackler. Wenn du ein bewegtes Motiv mitziehst, halte die Füße stabil, drehe aus der Taille und führe die Bewegung nach dem Auslösen weiter.',
      ),
      _SeedTranslation(
        locale: 'pt',
        title:
            'Escolhe a velocidade do obturador pelo movimento, não apenas pela luz',
        summary:
            'Decide se o movimento deve congelar, arrastar ou mostrar um panning controlado.',
        body:
            'A velocidade do obturador é uma decisão criativa. Velocidades rápidas congelam gestos, salpicos e saltos. Velocidades mais lentas podem mostrar fluxo na água, no trânsito ou em bailarinos, mas também revelam trepidação da câmara. Se fizeres panning com um motivo em movimento, mantém os pés estáveis, roda a partir da cintura e continua o movimento depois de premir o obturador.',
      ),
      _SeedTranslation(
        locale: 'pt-BR',
        title:
            'Escolha a velocidade do obturador pelo movimento, não só pela luz',
        summary:
            'Decida se o movimento deve congelar, borrar ou mostrar um panning controlado.',
        body:
            'A velocidade do obturador é uma decisão criativa. Velocidades rápidas congelam gestos, respingos e saltos. Velocidades mais lentas podem mostrar fluxo na água, no trânsito ou em dançarinos, mas também revelam tremido da câmera. Se fizer panning com um assunto em movimento, mantenha os pés estáveis, gire pela cintura e continue o movimento depois de apertar o obturador.',
      ),
    ],
  ),
  _SeedContent(
    id: 'seed-lens-cleaning-checklist',
    type: ContentType.checklist,
    primaryCategory: 'gear',
    difficulty: Difficulty.beginner,
    premium: false,
    tagCodes: ['maintenance'],
    translations: [
      _SeedTranslation(
        locale: 'en',
        title: 'Clean the lens safely before important photos',
        summary:
            'Remove dust gently and avoid grinding particles into the glass.',
        body:
            'Use a blower first, then a clean microfibre cloth or lens tissue if marks remain. Do not breathe heavily onto the glass or use household cleaners. Work from the centre outward with light pressure. If a filter or front element has grit on it, remove the grit before wiping so you do not scratch the coating.',
      ),
      _SeedTranslation(
        locale: 'it',
        title: 'Pulisci l’obiettivo in sicurezza prima delle foto importanti',
        summary:
            'Rimuovi la polvere con delicatezza ed evita di trascinare particelle sul vetro.',
        body:
            'Usa prima una pompetta, poi un panno in microfibra pulito o una cartina per lenti se restano segni. Non alitare pesantemente sul vetro e non usare detergenti domestici. Procedi dal centro verso l’esterno con pressione leggera. Se un filtro o la lente frontale ha granelli, rimuovili prima di passare il panno per non graffiare il trattamento.',
      ),
      _SeedTranslation(
        locale: 'es',
        title: 'Limpia el objetivo con seguridad antes de fotos importantes',
        summary:
            'Retira el polvo con suavidad y evita arrastrar partículas sobre el cristal.',
        body:
            'Usa primero una pera de aire y después un paño de microfibra limpio o papel para lentes si quedan marcas. No eches mucho aliento sobre el cristal ni uses limpiadores domésticos. Trabaja desde el centro hacia fuera con poca presión. Si un filtro o el elemento frontal tiene arenilla, retírala antes de frotar para no rayar el recubrimiento.',
      ),
      _SeedTranslation(
        locale: 'fr',
        title: 'Nettoie l’objectif en sécurité avant les photos importantes',
        summary:
            'Retire la poussière doucement et évite de frotter des particules sur le verre.',
        body:
            'Utilise d’abord une poire soufflante, puis un chiffon microfibre propre ou un papier optique s’il reste des traces. Ne souffle pas fortement sur le verre et n’utilise pas de nettoyants ménagers. Travaille du centre vers l’extérieur avec une pression légère. Si un filtre ou la lentille frontale contient des grains, enlève-les avant d’essuyer pour ne pas rayer le traitement.',
      ),
      _SeedTranslation(
        locale: 'de',
        title: 'Reinige das Objektiv vor wichtigen Fotos sicher',
        summary:
            'Entferne Staub vorsichtig und reibe keine Partikel über das Glas.',
        body:
            'Nutze zuerst einen Blasebalg und danach ein sauberes Mikrofasertuch oder Linsenpapier, falls Flecken bleiben. Hauche das Glas nicht stark an und verwende keine Haushaltsreiniger. Arbeite mit leichtem Druck von der Mitte nach außen. Wenn ein Filter oder die Frontlinse Körnchen trägt, entferne sie vor dem Wischen, damit du die Vergütung nicht zerkratzt.',
      ),
      _SeedTranslation(
        locale: 'pt',
        title: 'Limpa a objetiva em segurança antes de fotografias importantes',
        summary:
            'Remove o pó com cuidado e evita arrastar partículas sobre o vidro.',
        body:
            'Usa primeiro uma pera de ar e depois um pano de microfibra limpo ou papel para lentes se ainda houver marcas. Não sopres intensamente para o vidro nem uses produtos domésticos. Trabalha do centro para fora com pressão leve. Se um filtro ou o elemento frontal tiver grãos, remove-os antes de limpar para não riscares o revestimento.',
      ),
      _SeedTranslation(
        locale: 'pt-BR',
        title: 'Limpe a lente com segurança antes de fotos importantes',
        summary:
            'Remova a poeira com cuidado e evite arrastar partículas sobre o vidro.',
        body:
            'Use primeiro uma bombinha de ar e depois um pano de microfibra limpo ou papel para lentes se ainda houver marcas. Não sopre forte no vidro nem use produtos domésticos. Trabalhe do centro para fora com pouca pressão. Se um filtro ou o elemento frontal tiver grãos, remova-os antes de limpar para não riscar o revestimento.',
      ),
    ],
  ),
];
