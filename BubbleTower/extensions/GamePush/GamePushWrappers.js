/**
 * WASM helper
 */
function __GamePush_Tools_GenerateWrappers() {
    const proto = GamePushGMS.gp.constructor.prototype;
    const blacklist = new Set(["constructor"]);

    Object.getOwnPropertyNames(proto)
        .filter(name => typeof proto[name] === "function")
        .filter(name => !blacklist.has(name))
        .forEach(name => {
            console.log(`function __GamePush_${name}() { return GamePushGMS.gp.${name}.apply(GamePushGMS.gp, arguments); }`);
        });
}

function __GamePush_Tools_toString(t) { return GamePushGMS.toString(t); }

function __GamePush_Tools_browserConsoleLog(message) { return GamePushGMS.browserConsoleLog(message); }

function __GamePush_Tools_pageReload() { return GamePushGMS.pageReload(); }

function __GamePush_Tools_getInitStatus() { return GamePushGMS.getInitStatus(); }

function __GamePush_Tools_setDebugMode(debugStatus) { return GamePushGMS.setDebugMode(debugStatus); }

function __GamePush_Tools_getDebugMode() { return GamePushGMS.getDebugMode(); }

function __GamePush_Tools_getBrowserLang() { return GamePushGMS.getBrowserLang(); }

function __GamePush_Tools_getBrowserEnvironment() { return GamePushGMS.getBrowserEnvironment(); }

function __GamePush_Tools_copyTextToClipboard(text) { return copyTextToClipboard(text); }

// Generated

function __GamePush_trigger() { return GamePushGMS.gp.trigger.apply(GamePushGMS.gp, arguments); }
function __GamePush_toGMS() { return GamePushGMS.gp.toGMS.apply(GamePushGMS.gp, arguments); }
function __GamePush_triggerErr() { return GamePushGMS.gp.triggerErr.apply(GamePushGMS.gp, arguments); }
function __GamePush_LoggerError() { return GamePushGMS.gp.LoggerError.apply(GamePushGMS.gp, arguments); }
function __GamePush_LoggerInfo() { return GamePushGMS.gp.LoggerInfo.apply(GamePushGMS.gp, arguments); }
function __GamePush_LoggerWarn() { return GamePushGMS.gp.LoggerWarn.apply(GamePushGMS.gp, arguments); }
function __GamePush_LoggerLog() { return GamePushGMS.gp.LoggerLog.apply(GamePushGMS.gp, arguments); }
function __GamePush_Language() { return GamePushGMS.gp.Language.apply(GamePushGMS.gp, arguments); }
function __GamePush_AvatarGenerator() { return GamePushGMS.gp.AvatarGenerator.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlatformType() { return GamePushGMS.gp.PlatformType.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlatformHasIntegratedAuth() { return GamePushGMS.gp.PlatformHasIntegratedAuth.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlatformIsLogoutAvailable() { return GamePushGMS.gp.PlatformIsLogoutAvailable.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlatformIsSecretCodeAuthAvailable() { return GamePushGMS.gp.PlatformIsSecretCodeAuthAvailable.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlatformIsExternalLinksAllowed() { return GamePushGMS.gp.PlatformIsExternalLinksAllowed.apply(GamePushGMS.gp, arguments); }
function __GamePush_ProjectId() { return GamePushGMS.gp.ProjectId.apply(GamePushGMS.gp, arguments); }
function __GamePush_AppTitle() { return GamePushGMS.gp.AppTitle.apply(GamePushGMS.gp, arguments); }
function __GamePush_AppDescription() { return GamePushGMS.gp.AppDescription.apply(GamePushGMS.gp, arguments); }
function __GamePush_AppImage() { return GamePushGMS.gp.AppImage.apply(GamePushGMS.gp, arguments); }
function __GamePush_AppUrl() { return GamePushGMS.gp.AppUrl.apply(GamePushGMS.gp, arguments); }
function __GamePush_IsMobile() { return GamePushGMS.gp.IsMobile.apply(GamePushGMS.gp, arguments); }
function __GamePush_IsDev() { return GamePushGMS.gp.IsDev.apply(GamePushGMS.gp, arguments); }
function __GamePush_IsAllowedOrigin() { return GamePushGMS.gp.IsAllowedOrigin.apply(GamePushGMS.gp, arguments); }
function __GamePush_IsPortrait() { return GamePushGMS.gp.IsPortrait.apply(GamePushGMS.gp, arguments); }
function __GamePush_ServerTime() { return GamePushGMS.gp.ServerTime.apply(GamePushGMS.gp, arguments); }
function __GamePush_ServerTime_UnixTime() { return GamePushGMS.gp.ServerTime_UnixTime.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChangeLanguage() { return GamePushGMS.gp.ChangeLanguage.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChangeLanguageByCode() { return GamePushGMS.gp.ChangeLanguageByCode.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChangeAvatarGenerator() { return GamePushGMS.gp.ChangeAvatarGenerator.apply(GamePushGMS.gp, arguments); }
function __GamePush_LoadOverlay() { return GamePushGMS.gp.LoadOverlay.apply(GamePushGMS.gp, arguments); }
function __GamePush_IsPaused() { return GamePushGMS.gp.IsPaused.apply(GamePushGMS.gp, arguments); }
function __GamePush_Pause() { return GamePushGMS.gp.Pause.apply(GamePushGMS.gp, arguments); }
function __GamePush_Resume() { return GamePushGMS.gp.Resume.apply(GamePushGMS.gp, arguments); }
function __GamePush_SetBackground() { return GamePushGMS.gp.SetBackground.apply(GamePushGMS.gp, arguments); }
function __GamePush_GameStart() { return GamePushGMS.gp.GameStart.apply(GamePushGMS.gp, arguments); }
function __GamePush_GameplayStart() { return GamePushGMS.gp.GameplayStart.apply(GamePushGMS.gp, arguments); }
function __GamePush_GameplayStop() { return GamePushGMS.gp.GameplayStop.apply(GamePushGMS.gp, arguments); }
function __GamePush_FullscreenOpen() { return GamePushGMS.gp.FullscreenOpen.apply(GamePushGMS.gp, arguments); }
function __GamePush_FullscreenClose() { return GamePushGMS.gp.FullscreenClose.apply(GamePushGMS.gp, arguments); }
function __GamePush_FullscreenToggle() { return GamePushGMS.gp.FullscreenToggle.apply(GamePushGMS.gp, arguments); }
function __GamePush_FullscreenIsEnabled() { return GamePushGMS.gp.FullscreenIsEnabled.apply(GamePushGMS.gp, arguments); }
function __GamePush_AppRequestReview() { return GamePushGMS.gp.AppRequestReview.apply(GamePushGMS.gp, arguments); }
function __GamePush_AppCanRequestReview() { return GamePushGMS.gp.AppCanRequestReview.apply(GamePushGMS.gp, arguments); }
function __GamePush_AppIsAlreadyReviewed() { return GamePushGMS.gp.AppIsAlreadyReviewed.apply(GamePushGMS.gp, arguments); }
function __GamePush_AppAddShortcut() { return GamePushGMS.gp.AppAddShortcut.apply(GamePushGMS.gp, arguments); }
function __GamePush_AppCanAddShortcut() { return GamePushGMS.gp.AppCanAddShortcut.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGetID() { return GamePushGMS.gp.PlayerGetID.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerReset() { return GamePushGMS.gp.PlayerReset.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerRemove() { return GamePushGMS.gp.PlayerRemove.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerLoad() { return GamePushGMS.gp.PlayerLoad.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerSync() { return GamePushGMS.gp.PlayerSync.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerEnableAutoSync() { return GamePushGMS.gp.PlayerEnableAutoSync.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerDisableAutoSync() { return GamePushGMS.gp.PlayerDisableAutoSync.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerIsLoggedIn() { return GamePushGMS.gp.PlayerIsLoggedIn.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerHasAnyCredentials() { return GamePushGMS.gp.PlayerHasAnyCredentials.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerIsStub() { return GamePushGMS.gp.PlayerIsStub.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerLogin() { return GamePushGMS.gp.PlayerLogin.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerLogout() { return GamePushGMS.gp.PlayerLogout.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGetScore() { return GamePushGMS.gp.PlayerGetScore.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerSetScore() { return GamePushGMS.gp.PlayerSetScore.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerAddScore() { return GamePushGMS.gp.PlayerAddScore.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGetName() { return GamePushGMS.gp.PlayerGetName.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerSetName() { return GamePushGMS.gp.PlayerSetName.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGetAvatar() { return GamePushGMS.gp.PlayerGetAvatar.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerSetAvatar() { return GamePushGMS.gp.PlayerSetAvatar.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGet() { return GamePushGMS.gp.PlayerGet.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGetMinValue() { return GamePushGMS.gp.PlayerGetMinValue.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGetMaxValue() { return GamePushGMS.gp.PlayerGetMaxValue.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerSet() { return GamePushGMS.gp.PlayerSet.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerAdd() { return GamePushGMS.gp.PlayerAdd.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerHas() { return GamePushGMS.gp.PlayerHas.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerSetFlag() { return GamePushGMS.gp.PlayerSetFlag.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerToggle() { return GamePushGMS.gp.PlayerToggle.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerFields() { return GamePushGMS.gp.PlayerFields.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerFetchFields() { return GamePushGMS.gp.PlayerFetchFields.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGetField() { return GamePushGMS.gp.PlayerGetField.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGetFieldName() { return GamePushGMS.gp.PlayerGetFieldName.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGetFieldVariantName() { return GamePushGMS.gp.PlayerGetFieldVariantName.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGetFieldVariantAt() { return GamePushGMS.gp.PlayerGetFieldVariantAt.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerGetFieldVariantIndex() { return GamePushGMS.gp.PlayerGetFieldVariantIndex.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerToJSON() { return GamePushGMS.gp.PlayerToJSON.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerFromJSON() { return GamePushGMS.gp.PlayerFromJSON.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayersFetch() { return GamePushGMS.gp.PlayersFetch.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerFetch() { return GamePushGMS.gp.PlayerFetch.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerStatsActiveDays() { return GamePushGMS.gp.PlayerStatsActiveDays.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerStatsActiveDaysConsecutive() { return GamePushGMS.gp.PlayerStatsActiveDaysConsecutive.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerStatsPlaytimeToday() { return GamePushGMS.gp.PlayerStatsPlaytimeToday.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlayerStatsPlaytimeAll() { return GamePushGMS.gp.PlayerStatsPlaytimeAll.apply(GamePushGMS.gp, arguments); }
function __GamePush_LeaderboardOpen() { return GamePushGMS.gp.LeaderboardOpen.apply(GamePushGMS.gp, arguments); }
function __GamePush_LeaderboardFetch() { return GamePushGMS.gp.LeaderboardFetch.apply(GamePushGMS.gp, arguments); }
function __GamePush_LeaderboardFetchPlayerRating() { return GamePushGMS.gp.LeaderboardFetchPlayerRating.apply(GamePushGMS.gp, arguments); }
function __GamePush_LeaderboardScopedOpen() { return GamePushGMS.gp.LeaderboardScopedOpen.apply(GamePushGMS.gp, arguments); }
function __GamePush_LeaderboardScopedFetch() { return GamePushGMS.gp.LeaderboardScopedFetch.apply(GamePushGMS.gp, arguments); }
function __GamePush_LeaderboardScopedPublishRecord() { return GamePushGMS.gp.LeaderboardScopedPublishRecord.apply(GamePushGMS.gp, arguments); }
function __GamePush_LeaderboardScopedFetchPlayerRating() { return GamePushGMS.gp.LeaderboardScopedFetchPlayerRating.apply(GamePushGMS.gp, arguments); }
function __GamePush_AchievementsOpen() { return GamePushGMS.gp.AchievementsOpen.apply(GamePushGMS.gp, arguments); }
function __GamePush_AchievementsFetch() { return GamePushGMS.gp.AchievementsFetch.apply(GamePushGMS.gp, arguments); }
function __GamePush_AchievementsUnlock() { return GamePushGMS.gp.AchievementsUnlock.apply(GamePushGMS.gp, arguments); }
function __GamePush_AchievementsHas() { return GamePushGMS.gp.AchievementsHas.apply(GamePushGMS.gp, arguments); }
function __GamePush_AchievementsList() { return GamePushGMS.gp.AchievementsList.apply(GamePushGMS.gp, arguments); }
function __GamePush_AchievementsPlayerAchievementsList() { return GamePushGMS.gp.AchievementsPlayerAchievementsList.apply(GamePushGMS.gp, arguments); }
function __GamePush_AchievementsGroupsList() { return GamePushGMS.gp.AchievementsGroupsList.apply(GamePushGMS.gp, arguments); }
function __GamePush_AchievementsGetProgress() { return GamePushGMS.gp.AchievementsGetProgress.apply(GamePushGMS.gp, arguments); }
function __GamePush_AchievementsSetProgress() { return GamePushGMS.gp.AchievementsSetProgress.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsProducts() { return GamePushGMS.gp.PaymentsProducts.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsPurchases() { return GamePushGMS.gp.PaymentsPurchases.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsFetchProducts() { return GamePushGMS.gp.PaymentsFetchProducts.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsPurchase() { return GamePushGMS.gp.PaymentsPurchase.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsConsume() { return GamePushGMS.gp.PaymentsConsume.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsConsumeByPurchaseId() { return GamePushGMS.gp.PaymentsConsumeByPurchaseId.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsHas() { return GamePushGMS.gp.PaymentsHas.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsIsAvailable() { return GamePushGMS.gp.PaymentsIsAvailable.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsGetPurchase() { return GamePushGMS.gp.PaymentsGetPurchase.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsSubscribe() { return GamePushGMS.gp.PaymentsSubscribe.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsUnsubscribe() { return GamePushGMS.gp.PaymentsUnsubscribe.apply(GamePushGMS.gp, arguments); }
function __GamePush_PaymentsIsSubscriptionsAvailable() { return GamePushGMS.gp.PaymentsIsSubscriptionsAvailable.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsShowFullscreen() { return GamePushGMS.gp.AdsShowFullscreen.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsShowRewarded() { return GamePushGMS.gp.AdsShowRewarded.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsShowPreloader() { return GamePushGMS.gp.AdsShowPreloader.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsShowSticky() { return GamePushGMS.gp.AdsShowSticky.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsCloseSticky() { return GamePushGMS.gp.AdsCloseSticky.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsRefreshSticky() { return GamePushGMS.gp.AdsRefreshSticky.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsIsAdblockEnabled() { return GamePushGMS.gp.AdsIsAdblockEnabled.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsIsStickyAvailable() { return GamePushGMS.gp.AdsIsStickyAvailable.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsIsFullscreenAvailable() { return GamePushGMS.gp.AdsIsFullscreenAvailable.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsIsRewardedAvailable() { return GamePushGMS.gp.AdsIsRewardedAvailable.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsIsPreloaderAvailable() { return GamePushGMS.gp.AdsIsPreloaderAvailable.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsIsStickyPlaying() { return GamePushGMS.gp.AdsIsStickyPlaying.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsIsFullscreenPlaying() { return GamePushGMS.gp.AdsIsFullscreenPlaying.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsIsRewardedPlaying() { return GamePushGMS.gp.AdsIsRewardedPlaying.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsIsPreloaderPlaying() { return GamePushGMS.gp.AdsIsPreloaderPlaying.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsIsCountdownOverlayEnabled() { return GamePushGMS.gp.AdsIsCountdownOverlayEnabled.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsIsRewardedFailedOverlayEnabled() { return GamePushGMS.gp.AdsIsRewardedFailedOverlayEnabled.apply(GamePushGMS.gp, arguments); }
function __GamePush_AdsCanShowFullscreenBeforeGamePlay() { return GamePushGMS.gp.AdsCanShowFullscreenBeforeGamePlay.apply(GamePushGMS.gp, arguments); }
function __GamePush_AnalyticsHit() { return GamePushGMS.gp.AnalyticsHit.apply(GamePushGMS.gp, arguments); }
function __GamePush_AnalyticsGoal() { return GamePushGMS.gp.AnalyticsGoal.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsShare() { return GamePushGMS.gp.SocialsShare.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsPost() { return GamePushGMS.gp.SocialsPost.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsInvite() { return GamePushGMS.gp.SocialsInvite.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsJoinCommunity() { return GamePushGMS.gp.SocialsJoinCommunity.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsCommunityLink() { return GamePushGMS.gp.SocialsCommunityLink.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsIsSupportsShare() { return GamePushGMS.gp.SocialsIsSupportsShare.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsIsSupportsNativeShare() { return GamePushGMS.gp.SocialsIsSupportsNativeShare.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsIsSupportsNativePosts() { return GamePushGMS.gp.SocialsIsSupportsNativePosts.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsIsSupportsNativeInvite() { return GamePushGMS.gp.SocialsIsSupportsNativeInvite.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsCanJoinCommunity() { return GamePushGMS.gp.SocialsCanJoinCommunity.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsIsSupportsNativeCommunityJoin() { return GamePushGMS.gp.SocialsIsSupportsNativeCommunityJoin.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsMakeShareUrl() { return GamePushGMS.gp.SocialsMakeShareUrl.apply(GamePushGMS.gp, arguments); }
function __GamePush_SocialsGetShareParam() { return GamePushGMS.gp.SocialsGetShareParam.apply(GamePushGMS.gp, arguments); }
function __GamePush_GamesCollectionsOpen() { return GamePushGMS.gp.GamesCollectionsOpen.apply(GamePushGMS.gp, arguments); }
function __GamePush_GamesCollectionsFetch() { return GamePushGMS.gp.GamesCollectionsFetch.apply(GamePushGMS.gp, arguments); }
function __GamePush_VariablesFetch() { return GamePushGMS.gp.VariablesFetch.apply(GamePushGMS.gp, arguments); }
function __GamePush_VariablesGet() { return GamePushGMS.gp.VariablesGet.apply(GamePushGMS.gp, arguments); }
function __GamePush_VariablesHas() { return GamePushGMS.gp.VariablesHas.apply(GamePushGMS.gp, arguments); }
function __GamePush_VariablesType() { return GamePushGMS.gp.VariablesType.apply(GamePushGMS.gp, arguments); }
function __GamePush_VariablesIsPlatformVariablesAvailable() { return GamePushGMS.gp.VariablesIsPlatformVariablesAvailable.apply(GamePushGMS.gp, arguments); }
function __GamePush_VariablesFetchPlatformVariables() { return GamePushGMS.gp.VariablesFetchPlatformVariables.apply(GamePushGMS.gp, arguments); }
function __GamePush_UniquesRegister() { return GamePushGMS.gp.UniquesRegister.apply(GamePushGMS.gp, arguments); }
function __GamePush_UniquesGet() { return GamePushGMS.gp.UniquesGet.apply(GamePushGMS.gp, arguments); }
function __GamePush_UniquesCheck() { return GamePushGMS.gp.UniquesCheck.apply(GamePushGMS.gp, arguments); }
function __GamePush_UniquesList() { return GamePushGMS.gp.UniquesList.apply(GamePushGMS.gp, arguments); }
function __GamePush_UniquesDelete() { return GamePushGMS.gp.UniquesDelete.apply(GamePushGMS.gp, arguments); }
function __GamePush_DocumentsOpen() { return GamePushGMS.gp.DocumentsOpen.apply(GamePushGMS.gp, arguments); }
function __GamePush_DocumentsFetch() { return GamePushGMS.gp.DocumentsFetch.apply(GamePushGMS.gp, arguments); }
function __GamePush_FilesUpload() { return GamePushGMS.gp.FilesUpload.apply(GamePushGMS.gp, arguments); }
function __GamePush_FilesUploadUrl() { return GamePushGMS.gp.FilesUploadUrl.apply(GamePushGMS.gp, arguments); }
function __GamePush_FilesUploadContent() { return GamePushGMS.gp.FilesUploadContent.apply(GamePushGMS.gp, arguments); }
function __GamePush_FilesLoadContent() { return GamePushGMS.gp.FilesLoadContent.apply(GamePushGMS.gp, arguments); }
function __GamePush_FilesChooseFile() { return GamePushGMS.gp.FilesChooseFile.apply(GamePushGMS.gp, arguments); }
function __GamePush_FilesFetch() { return GamePushGMS.gp.FilesFetch.apply(GamePushGMS.gp, arguments); }
function __GamePush_FilesFetchMore() { return GamePushGMS.gp.FilesFetchMore.apply(GamePushGMS.gp, arguments); }
function __GamePush_ImagesUpload() { return GamePushGMS.gp.ImagesUpload.apply(GamePushGMS.gp, arguments); }
function __GamePush_ImagesUploadUrl() { return GamePushGMS.gp.ImagesUploadUrl.apply(GamePushGMS.gp, arguments); }
function __GamePush_ImagesChooseFile() { return GamePushGMS.gp.ImagesChooseFile.apply(GamePushGMS.gp, arguments); }
function __GamePush_ImagesFetch() { return GamePushGMS.gp.ImagesFetch.apply(GamePushGMS.gp, arguments); }
function __GamePush_ImagesFetchMore() { return GamePushGMS.gp.ImagesFetchMore.apply(GamePushGMS.gp, arguments); }
function __GamePush_ImagesResize() { return GamePushGMS.gp.ImagesResize.apply(GamePushGMS.gp, arguments); }
function __GamePush_RewardsGive() { return GamePushGMS.gp.RewardsGive.apply(GamePushGMS.gp, arguments); }
function __GamePush_RewardsAccept() { return GamePushGMS.gp.RewardsAccept.apply(GamePushGMS.gp, arguments); }
function __GamePush_RewardsList() { return GamePushGMS.gp.RewardsList.apply(GamePushGMS.gp, arguments); }
function __GamePush_RewardsGivenList() { return GamePushGMS.gp.RewardsGivenList.apply(GamePushGMS.gp, arguments); }
function __GamePush_RewardsGetReward() { return GamePushGMS.gp.RewardsGetReward.apply(GamePushGMS.gp, arguments); }
function __GamePush_RewardsHas() { return GamePushGMS.gp.RewardsHas.apply(GamePushGMS.gp, arguments); }
function __GamePush_RewardsHasAccepted() { return GamePushGMS.gp.RewardsHasAccepted.apply(GamePushGMS.gp, arguments); }
function __GamePush_RewardsHasUnaccepted() { return GamePushGMS.gp.RewardsHasUnaccepted.apply(GamePushGMS.gp, arguments); }
function __GamePush_TriggersClaim() { return GamePushGMS.gp.TriggersClaim.apply(GamePushGMS.gp, arguments); }
function __GamePush_TriggersList() { return GamePushGMS.gp.TriggersList.apply(GamePushGMS.gp, arguments); }
function __GamePush_TriggersActivatedList() { return GamePushGMS.gp.TriggersActivatedList.apply(GamePushGMS.gp, arguments); }
function __GamePush_TriggersGetTrigger() { return GamePushGMS.gp.TriggersGetTrigger.apply(GamePushGMS.gp, arguments); }
function __GamePush_TriggersIsActivated() { return GamePushGMS.gp.TriggersIsActivated.apply(GamePushGMS.gp, arguments); }
function __GamePush_TriggersIsClaimed() { return GamePushGMS.gp.TriggersIsClaimed.apply(GamePushGMS.gp, arguments); }
function __GamePush_EventsJoin() { return GamePushGMS.gp.EventsJoin.apply(GamePushGMS.gp, arguments); }
function __GamePush_EventsList() { return GamePushGMS.gp.EventsList.apply(GamePushGMS.gp, arguments); }
function __GamePush_EventsActiveList() { return GamePushGMS.gp.EventsActiveList.apply(GamePushGMS.gp, arguments); }
function __GamePush_EventsGetEvent() { return GamePushGMS.gp.EventsGetEvent.apply(GamePushGMS.gp, arguments); }
function __GamePush_EventsHas() { return GamePushGMS.gp.EventsHas.apply(GamePushGMS.gp, arguments); }
function __GamePush_EventsIsJoined() { return GamePushGMS.gp.EventsIsJoined.apply(GamePushGMS.gp, arguments); }
function __GamePush_ExperimentsMap() { return GamePushGMS.gp.ExperimentsMap.apply(GamePushGMS.gp, arguments); }
function __GamePush_ExperimentsHas() { return GamePushGMS.gp.ExperimentsHas.apply(GamePushGMS.gp, arguments); }
function __GamePush_SegmentsList() { return GamePushGMS.gp.SegmentsList.apply(GamePushGMS.gp, arguments); }
function __GamePush_SegmentsHas() { return GamePushGMS.gp.SegmentsHas.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersRegister() { return GamePushGMS.gp.SchedulersRegister.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersClaimDay() { return GamePushGMS.gp.SchedulersClaimDay.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersClaimDayAdditional() { return GamePushGMS.gp.SchedulersClaimDayAdditional.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersClaimAllDay() { return GamePushGMS.gp.SchedulersClaimAllDay.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersClaimAllDays() { return GamePushGMS.gp.SchedulersClaimAllDays.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersList() { return GamePushGMS.gp.SchedulersList.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersActiveList() { return GamePushGMS.gp.SchedulersActiveList.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersGetScheduler() { return GamePushGMS.gp.SchedulersGetScheduler.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersGetSchedulerDay() { return GamePushGMS.gp.SchedulersGetSchedulerDay.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersGetSchedulerCurrentDay() { return GamePushGMS.gp.SchedulersGetSchedulerCurrentDay.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersIsRegistered() { return GamePushGMS.gp.SchedulersIsRegistered.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersIsTodayRewardClaimed() { return GamePushGMS.gp.SchedulersIsTodayRewardClaimed.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersCanClaimDay() { return GamePushGMS.gp.SchedulersCanClaimDay.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersCanClaimDayAdditional() { return GamePushGMS.gp.SchedulersCanClaimDayAdditional.apply(GamePushGMS.gp, arguments); }
function __GamePush_SchedulersCanClaimAllDay() { return GamePushGMS.gp.SchedulersCanClaimAllDay.apply(GamePushGMS.gp, arguments); }
function __GamePush_StorageSetStorage() { return GamePushGMS.gp.StorageSetStorage.apply(GamePushGMS.gp, arguments); }
function __GamePush_StorageSet() { return GamePushGMS.gp.StorageSet.apply(GamePushGMS.gp, arguments); }
function __GamePush_StorageGet() { return GamePushGMS.gp.StorageGet.apply(GamePushGMS.gp, arguments); }
function __GamePush_StorageSetGlobal() { return GamePushGMS.gp.StorageSetGlobal.apply(GamePushGMS.gp, arguments); }
function __GamePush_StorageGetGlobal() { return GamePushGMS.gp.StorageGetGlobal.apply(GamePushGMS.gp, arguments); }
function __GamePush_WindowsShowConfirm() { return GamePushGMS.gp.WindowsShowConfirm.apply(GamePushGMS.gp, arguments); }
function __GamePush_SoundsIsMuted() { return GamePushGMS.gp.SoundsIsMuted.apply(GamePushGMS.gp, arguments); }
function __GamePush_SoundsIsSFXMuted() { return GamePushGMS.gp.SoundsIsSFXMuted.apply(GamePushGMS.gp, arguments); }
function __GamePush_SoundsIsMusicMuted() { return GamePushGMS.gp.SoundsIsMusicMuted.apply(GamePushGMS.gp, arguments); }
function __GamePush_SoundsMute() { return GamePushGMS.gp.SoundsMute.apply(GamePushGMS.gp, arguments); }
function __GamePush_SoundsUnmute() { return GamePushGMS.gp.SoundsUnmute.apply(GamePushGMS.gp, arguments); }
function __GamePush_SoundsMuteSFX() { return GamePushGMS.gp.SoundsMuteSFX.apply(GamePushGMS.gp, arguments); }
function __GamePush_SoundsUnmuteSFX() { return GamePushGMS.gp.SoundsUnmuteSFX.apply(GamePushGMS.gp, arguments); }
function __GamePush_SoundsMuteMusic() { return GamePushGMS.gp.SoundsMuteMusic.apply(GamePushGMS.gp, arguments); }
function __GamePush_SoundsUnmuteMusic() { return GamePushGMS.gp.SoundsUnmuteMusic.apply(GamePushGMS.gp, arguments); }
function __GamePush_FeedbacksSend() { return GamePushGMS.gp.FeedbacksSend.apply(GamePushGMS.gp, arguments); }
function __GamePush_FeedbacksOpen() { return GamePushGMS.gp.FeedbacksOpen.apply(GamePushGMS.gp, arguments); }
function __GamePush_FeedbacksOpenFeedback() { return GamePushGMS.gp.FeedbacksOpenFeedback.apply(GamePushGMS.gp, arguments); }
function __GamePush_FeedbacksFetch() { return GamePushGMS.gp.FeedbacksFetch.apply(GamePushGMS.gp, arguments); }
function __GamePush_FeedbacksFetchMore() { return GamePushGMS.gp.FeedbacksFetchMore.apply(GamePushGMS.gp, arguments); }
function __GamePush_FeedbacksSendMessage() { return GamePushGMS.gp.FeedbacksSendMessage.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsOpenChat() { return GamePushGMS.gp.ChannelsOpenChat.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsOpenPersonalChat() { return GamePushGMS.gp.ChannelsOpenPersonalChat.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsOpenFeed() { return GamePushGMS.gp.ChannelsOpenFeed.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsIsMainChatEnabled() { return GamePushGMS.gp.ChannelsIsMainChatEnabled.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsMainChatId() { return GamePushGMS.gp.ChannelsMainChatId.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsJoin() { return GamePushGMS.gp.ChannelsJoin.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsCancelJoin() { return GamePushGMS.gp.ChannelsCancelJoin.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsLeave() { return GamePushGMS.gp.ChannelsLeave.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsKick() { return GamePushGMS.gp.ChannelsKick.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsMuteUnmuteAt() { return GamePushGMS.gp.ChannelsMuteUnmuteAt.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsMuteSeconds() { return GamePushGMS.gp.ChannelsMuteSeconds.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsUnMute() { return GamePushGMS.gp.ChannelsUnMute.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsSendInvite() { return GamePushGMS.gp.ChannelsSendInvite.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsCancelInvite() { return GamePushGMS.gp.ChannelsCancelInvite.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsAcceptInvite() { return GamePushGMS.gp.ChannelsAcceptInvite.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsRejectInvite() { return GamePushGMS.gp.ChannelsRejectInvite.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchInvites() { return GamePushGMS.gp.ChannelsFetchInvites.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMoreInvites() { return GamePushGMS.gp.ChannelsFetchMoreInvites.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchChannelInvites() { return GamePushGMS.gp.ChannelsFetchChannelInvites.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMoreChannelInvites() { return GamePushGMS.gp.ChannelsFetchMoreChannelInvites.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchSentInvites() { return GamePushGMS.gp.ChannelsFetchSentInvites.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMoreSentInvites() { return GamePushGMS.gp.ChannelsFetchMoreSentInvites.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsAcceptJoinRequest() { return GamePushGMS.gp.ChannelsAcceptJoinRequest.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsRejectJoinRequest() { return GamePushGMS.gp.ChannelsRejectJoinRequest.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchJoinRequests() { return GamePushGMS.gp.ChannelsFetchJoinRequests.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMoreJoinRequests() { return GamePushGMS.gp.ChannelsFetchMoreJoinRequests.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchSentJoinRequests() { return GamePushGMS.gp.ChannelsFetchSentJoinRequests.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMoreSentJoinRequests() { return GamePushGMS.gp.ChannelsFetchMoreSentJoinRequests.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsSendMessage() { return GamePushGMS.gp.ChannelsSendMessage.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsSendPersonalMessage() { return GamePushGMS.gp.ChannelsSendPersonalMessage.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsSendFeedMessage() { return GamePushGMS.gp.ChannelsSendFeedMessage.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsEditMessage() { return GamePushGMS.gp.ChannelsEditMessage.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsDeleteMessage() { return GamePushGMS.gp.ChannelsDeleteMessage.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMessages() { return GamePushGMS.gp.ChannelsFetchMessages.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchPersonalMessages() { return GamePushGMS.gp.ChannelsFetchPersonalMessages.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchFeedMessages() { return GamePushGMS.gp.ChannelsFetchFeedMessages.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMoreMessages() { return GamePushGMS.gp.ChannelsFetchMoreMessages.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMorePersonalMessages() { return GamePushGMS.gp.ChannelsFetchMorePersonalMessages.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMoreFeedMessages() { return GamePushGMS.gp.ChannelsFetchMoreFeedMessages.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsCreateChannel() { return GamePushGMS.gp.ChannelsCreateChannel.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsUpdateChannel() { return GamePushGMS.gp.ChannelsUpdateChannel.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsDeleteChannel() { return GamePushGMS.gp.ChannelsDeleteChannel.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchChannel() { return GamePushGMS.gp.ChannelsFetchChannel.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchChannels() { return GamePushGMS.gp.ChannelsFetchChannels.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMoreChannels() { return GamePushGMS.gp.ChannelsFetchMoreChannels.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMembers() { return GamePushGMS.gp.ChannelsFetchMembers.apply(GamePushGMS.gp, arguments); }
function __GamePush_ChannelsFetchMoreMembers() { return GamePushGMS.gp.ChannelsFetchMoreMembers.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlatformCallSDK() { return GamePushGMS.gp.PlatformCallSDK.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlatformGetNativeSDK() { return GamePushGMS.gp.PlatformGetNativeSDK.apply(GamePushGMS.gp, arguments); }
function __GamePush_PlatformGetSDK() { return GamePushGMS.gp.PlatformGetSDK.apply(GamePushGMS.gp, arguments); }
