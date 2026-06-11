import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

/// Localized strings accessor. Usage: `S.of(context).someKey`
class S {
  S(this.locale);

  final Locale locale;

  static S of(BuildContext context) {
    final localizations = Localizations.of<S>(context, S);
    assert(localizations != null, 'No S found in context');
    return localizations!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('zh'),
  ];

  late final Map<String, String> _strings = _loadStrings();

  Map<String, String> _loadStrings() {
    switch (locale.languageCode) {
      case 'zh':
        return appLocalizationsZh;
      case 'en':
      default:
        return appLocalizationsEn;
    }
  }

  String _t(String key, [Map<String, Object>? args]) {
    var value = _strings[key] ?? key;
    if (args != null) {
      for (final entry in args.entries) {
        value = value.replaceAll('{${entry.key}}', entry.value.toString());
      }
    }
    return value;
  }

  // ─── General ────────────────────────────────────────────
  String get appTitle => _t('appTitle');
  String get hermesBrand => _t('hermesBrand');

  // ─── Common buttons ─────────────────────────────────────
  String get updateApiKey => _t('updateApiKey');
  String get apiKeyLabel => _t('apiKeyLabel');
  String get apiKeyHint => _t('apiKeyHint');
  String get cancel => _t('cancel');
  String get save => _t('save');
  String get connect => _t('connect');
  String get retry => _t('retry');
  String get delete => _t('delete');
  String get edit => _t('edit');
  String get add => _t('add');
  String get send => _t('send');
  String get refresh => _t('refresh');
  String get close => _t('close');

  // ─── Home / Connections ─────────────────────────────────
  String get noConnections => _t('noConnections');
  String get noConnectionsHint => _t('noConnectionsHint');
  String get addConnection => _t('addConnection');
  String get addGatewayConnection => _t('addGatewayConnection');
  String get labelField => _t('label');
  String get hostField => _t('host');
  String get hostHint => _t('hostHint');
  String get portField => _t('port');
  String get portHint => _t('portHint');
  String get invalidApiKey => _t('invalidApiKey');
  String cannotReachHost(String host, int port) =>
      _t('cannotReachHost', {'host': host, 'port': port});
  String cannotReachHostCheck(String host, int port) =>
      _t('cannotReachHostCheck', {'host': host, 'port': port});
  String get serverRequiresApiKey => _t('serverRequiresApiKey');
  String get keyLabel => _t('key');
  String get keyCheckmark => _t('keyCheckmark');
  String get keyCrossmark => _t('keyCrossmark');

  // ─── Session List / Drawer ──────────────────────────────
  String get newChat => _t('newChat');
  String get memory => _t('memory');
  String get cronJobs => _t('cronJobs');
  String get skills => _t('skills');
  String get settings => _t('settings');
  String connectingTo(String url) => _t('connectingTo', {'url': url});
  String get gatewayRunningHint => _t('gatewayRunningHint');
  String get connectionIssue => _t('connectionIssue');
  String get noSessionsYet => _t('noSessionsYet');
  String get tapPlusNewChat => _t('tapPlusNewChat');

  // ─── Chat ───────────────────────────────────────────────
  String get responding => _t('responding');
  String get typeMessage => _t('typeMessage');
  String get failedToLoadMessages => _t('failedToLoadMessages');
  String sendFailed(String error) => _t('sendFailed', {'error': error});
  String get copied => _t('copied');
  String get copy => _t('copy');

  // ─── Settings ───────────────────────────────────────────
  String get settingsTitle => _t('settingsTitle');
  String get failedToLoadSettings => _t('failedToLoadSettings');
  String get modelSelection => _t('modelSelection');
  String get currentModel => _t('currentModel');
  String contextTokens(int count) => _t('contextTokens', {'count': count});
  String get providerField => _t('provider');
  String get modelField => _t('model');
  String get applyModel => _t('applyModel');
  String modelSetSuccess(String model) =>
      _t('modelSetSuccess', {'model': model});
  String get appearance => _t('appearance');
  String get connectionSection => _t('connection');
  String get baseUrl => _t('baseUrl');
  String get about => _t('about');
  String get aboutTitle => _t('aboutTitle');
  String aboutVersion(String version) => _t('aboutVersion', {'version': version});
  String get aboutDescription => _t('aboutDescription');
  String get verboseMode => _t('verboseMode');
  String get verboseModeSubtitle => _t('verboseModeSubtitle');
  String get themeSystem => _t('themeSystem');
  String get themeDark => _t('themeDark');
  String get themeLight => _t('themeLight');

  // ─── Memory ─────────────────────────────────────────────
  String get memoryTitle => _t('memoryTitle');
  String memorySource(String source) => _t('memorySource', {'source': source});
  String get failedToLoadMemory => _t('failedToLoadMemory');
  String get noMemoryEntries => _t('noMemoryEntries');
  String get memoryDescription => _t('memoryDescription');

  // ─── Skills ─────────────────────────────────────────────
  String skillsCount(int count) => _t('skillsCount', {'count': count});
  String get failedToLoadSkills => _t('failedToLoadSkills');
  String get noSkillsFound => _t('noSkillsFound');

  // ─── Cron ───────────────────────────────────────────────
  String get cronJobUntitled => _t('cronJobUntitled');
  String get jobResumed => _t('jobResumed');
  String get jobPaused => _t('jobPaused');
  String operationFailed(String error) =>
      _t('operationFailed', {'error': error});
  String get deleteCronJob => _t('deleteCronJob');
  String deleteConfirm(String name) => _t('deleteConfirm', {'name': name});
  String deletedConfirm(String name) => _t('deletedConfirm', {'name': name});
  String deleteFailed(String error) => _t('deleteFailed', {'error': error});
  String get jobTriggered => _t('jobTriggered');
  String get addCronJob => _t('addCronJob');
  String get cronJobAdded => _t('cronJobAdded');
  String failedToAddJob(String error) =>
      _t('failedToAddJob', {'error': error});
  String get editCronJob => _t('editCronJob');
  String get cronJobUpdated => _t('cronJobUpdated');
  String failedToUpdateJob(String error) =>
      _t('failedToUpdateJob', {'error': error});
  String get nameLabel => _t('nameLabel');
  String get nameHint => _t('nameHint');
  String get promptLabel => _t('promptLabel');
  String get promptHint => _t('promptHint');
  String get scheduleLabel => _t('scheduleLabel');
  String get scheduleHint => _t('scheduleHint');
  String get scriptOnly => _t('scriptOnly');
  String get scriptOnlySubtitle => _t('scriptOnlySubtitle');
  String get requiredFields => _t('requiredFields');
  String get addNewCronJob => _t('addNewCronJob');
  String get failedToLoadCronJobs => _t('failedToLoadCronJobs');
  String get noCronJobs => _t('noCronJobs');
  String get scriptBadge => _t('script');
  String get triggerNow => _t('triggerNow');
  String get resumeAction => _t('resume');
  String get pauseAction => _t('pause');
  String lastRun(String time) => _t('lastRun', {'time': time});
  String nextRun(String time) => _t('nextRun', {'time': time});

  // ─── Language ───────────────────────────────────────────
  String get language => _t('language');
  String get languageEnglish => _t('languageEnglish');
  String get languageChinese => _t('languageChinese');

  // ─── Thinking ──────────────────────────────────────────
  String get thinking => _t('thinking');
  String get thinkingEllipsis => _t('thinkingEllipsis');
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<S> load(Locale locale) async => S(locale);

  @override
  bool shouldReload(_SDelegate old) => false;
}
