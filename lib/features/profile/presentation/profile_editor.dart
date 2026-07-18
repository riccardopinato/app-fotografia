import 'package:flutter/material.dart';

import '../../../core/design/frame_lab_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/domain/catalog_models.dart';
import '../domain/user_profile.dart';

class ProfileEditor extends StatefulWidget {
  const ProfileEditor({required this.profile, required this.onSave, super.key});

  final UserProfile? profile;
  final Future<void> Function(UserProfile profile) onSave;

  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  late SkillLevel _skillLevel;
  late LanguageMode _languageMode;
  LocaleCode? _selectedLocale;
  late Set<String> _topics;
  late Set<String> _goals;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _skillLevel = profile?.skillLevel ?? SkillLevel.beginner;
    _languageMode = profile?.languageMode ?? LanguageMode.device;
    _selectedLocale = profile?.selectedLocale ?? const LocaleCode('en');
    _topics = {...?profile?.preferredTopics};
    _goals = {...?profile?.learningGoals};
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(FrameLabSpacing.medium),
      children: [
        Text(
          widget.profile == null ? l10n.onboardingTitle : l10n.profileTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: FrameLabSpacing.small),
        Text(
          widget.profile == null
              ? l10n.onboardingDescription
              : l10n.profileDescription,
        ),
        const SizedBox(height: FrameLabSpacing.large),
        _section(l10n.profileSkillLevel, _skillChoices(l10n)),
        _section(l10n.profileTopics, _choiceSet(_topics, _topicsFor(l10n))),
        _section(
          l10n.profileLearningGoals,
          _choiceSet(_goals, _goalsFor(l10n)),
        ),
        _section(l10n.profileLanguage, _languageChoices(l10n)),
        const SizedBox(height: FrameLabSpacing.medium),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: Text(
            widget.profile == null ? l10n.onboardingContinue : l10n.profileSave,
          ),
        ),
      ],
    );
  }

  Widget _section(String title, Widget child) => Padding(
    padding: const EdgeInsets.only(bottom: FrameLabSpacing.large),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: FrameLabSpacing.small),
        child,
      ],
    ),
  );

  Widget _skillChoices(AppLocalizations l10n) => Wrap(
    spacing: FrameLabSpacing.small,
    runSpacing: FrameLabSpacing.small,
    children: SkillLevel.values
        .map(
          (level) => ChoiceChip(
            label: Text(switch (level) {
              SkillLevel.beginner => l10n.skillBeginner,
              SkillLevel.intermediate => l10n.skillIntermediate,
              SkillLevel.advanced => l10n.skillAdvanced,
            }),
            selected: _skillLevel == level,
            onSelected: (_) => setState(() => _skillLevel = level),
          ),
        )
        .toList(),
  );

  Widget _choiceSet(Set<String> selected, Map<String, String> labels) => Wrap(
    spacing: FrameLabSpacing.small,
    runSpacing: FrameLabSpacing.small,
    children: labels.entries
        .map(
          (entry) => FilterChip(
            label: Text(entry.value),
            selected: selected.contains(entry.key),
            onSelected: (value) => setState(
              () =>
                  value ? selected.add(entry.key) : selected.remove(entry.key),
            ),
          ),
        )
        .toList(),
  );

  Widget _languageChoices(AppLocalizations l10n) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SegmentedButton<LanguageMode>(
        segments: [
          ButtonSegment(
            value: LanguageMode.device,
            label: Text(l10n.languageDevice),
          ),
          ButtonSegment(
            value: LanguageMode.manual,
            label: Text(l10n.languageManual),
          ),
        ],
        selected: {_languageMode},
        onSelectionChanged: (value) =>
            setState(() => _languageMode = value.single),
      ),
      if (_languageMode == LanguageMode.manual)
        DropdownButtonFormField<LocaleCode>(
          initialValue: _selectedLocale,
          decoration: InputDecoration(labelText: l10n.languageSelectionLabel),
          items: _localeLabels(l10n).entries
              .map(
                (entry) => DropdownMenuItem(
                  value: LocaleCode(entry.key),
                  child: Text(entry.value),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedLocale = value),
        ),
    ],
  );

  Map<String, String> _topicsFor(AppLocalizations l10n) => {
    'portrait': l10n.topicPortrait,
    'landscape': l10n.topicLandscape,
    'street': l10n.topicStreet,
    'macro': l10n.topicMacro,
    'night': l10n.topicNight,
    'smartphone': l10n.topicSmartphone,
  };
  Map<String, String> _goalsFor(AppLocalizations l10n) => {
    'composition': l10n.goalComposition,
    'light': l10n.goalLight,
    'technique': l10n.goalTechnique,
    'editing': l10n.goalEditing,
  };
  Map<String, String> _localeLabels(AppLocalizations l10n) => {
    'en': l10n.languageEnglish,
    'it': l10n.languageItalian,
    'es': l10n.languageSpanish,
    'fr': l10n.languageFrench,
    'de': l10n.languageGerman,
    'pt-BR': l10n.languageBrazilianPortuguese,
  };

  Future<void> _save() async {
    final existing = widget.profile;
    final now = DateTime.now().toUtc();
    final profile = UserProfile(
      id: existing?.id ?? 'local-profile',
      skillLevel: _skillLevel,
      languageMode: _languageMode,
      selectedLocale: _languageMode == LanguageMode.manual
          ? _selectedLocale
          : null,
      preferredTopics: _topics.toList()..sort(),
      learningGoals: _goals.toList()..sort(),
      cameraBodies: existing?.cameraBodies ?? const [],
      lenses: existing?.lenses ?? const [],
      smartphones: existing?.smartphones ?? const [],
      themePreference: existing?.themePreference ?? ThemePreference.system,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    setState(() => _isSaving = true);
    try {
      await widget.onSave(profile);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileSaveError)),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
