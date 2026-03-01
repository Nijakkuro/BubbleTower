(() => {
    "use strict";
    class e {
        sdkReady;
        _nativeData;
        constructor(e) {
            this.sdkReady = false;
            this._nativeData = {};
            (this.gp = e),
                this.gp.player.ready.then(() => {
                    this.trigger("CallSDKReady"), this.trigger("CallPlayerReady"), this.sdkReady = true;
                }),
                this.gp.player.on("change", () => this.trigger("CallPlayerChange")),
                this.gp.player.on("field:maximum", ({ e }) => { this.trigger("CallPlayerFieldMaximum", e) }),
                this.gp.player.on("field:minimum", ({ e }) => { this.trigger("CallPlayerFieldMinimum", e) }),
                this.gp.player.on("field:increment", ({ field, oldValue, newValue }) => {
                    this.trigger("CallPlayerFieldIncrement", {
                        field: field,
                        oldValue: oldValue,
                        newValue: newValue,
                    })
                }),
                this.gp.player.on("sync", (e) => {
                    this.trigger(e ? "CallPlayerSyncComplete" : "CallPlayerSyncError");
                }),
                this.gp.player.on("load", (e) => {
                    this.trigger(e ? "CallPlayerLoadComplete" : "CallPlayerLoadError");
                }),
                this.gp.player.on("login", (e) => {
                    this.trigger(e ? "CallPlayerLoginComplete" : "CallPlayerLoginError");
                }),
                this.gp.player.on("logout", (e) => {
                    this.trigger(e ? "CallPlayerLogoutComplete" : "CallPlayerLogoutError");
                }),
                this.gp.player.on("fetchFields", (e) => {
                    e ? this.trigger("CallPlayerFetchFieldsComplete",
                        JSON.stringify(this.gp.player.fields.map((e) => ({ ...e, defaultValue: e.default })))) : this.trigger("CallPlayerFetchFieldsError");
                }),
                this.gp.leaderboard.on("open", () => this.trigger("CallLeaderboardOpen")),
                this.gp.leaderboard.on("close", () => this.trigger("CallLeaderboardClose")),
                this.gp.achievements.on("open", () => this.trigger("CallAchievementsOpen")),
                this.gp.achievements.on("close", () => {
                    this.trigger("CallAchievementsClose"), window.focus();
                }),
                this.gp.gamesCollections.on("open", () => this.trigger("CallGamesCollectionsOpen")),
                this.gp.gamesCollections.on("close", () => {
                    this.trigger("CallGamesCollectionsClose"), window.focus();
                }),
                this.gp.fullscreen.on("open", () => this.trigger("CallFullscreenOpen")),
                this.gp.fullscreen.on("close", () => this.trigger("CallFullscreenClose")),
                this.gp.fullscreen.on("change", () => this.trigger("CallFullscreenChange")),
                this.gp.ads.on("start", () => this.trigger("CallAdsStart")),
                this.gp.ads.on("close", (e) => {
                    this.trigger("CallAdsClose", e), window.focus();
                }),
                this.gp.ads.on("fullscreen:start", () => this.trigger("CallAdsFullscreenStart")),
                this.gp.ads.on("fullscreen:close", (e) => this.trigger("CallAdsFullscreenClose", e)),
                this.gp.ads.on("preloader:start", () => this.trigger("CallAdsPreloaderStart")),
                this.gp.ads.on("preloader:close", (e) => this.trigger("CallAdsPreloaderClose", e)),
                this.gp.ads.on("rewarded:start", () => this.trigger("CallAdsRewardedStart")),
                this.gp.ads.on("rewarded:close", (e) => this.trigger("CallAdsRewardedClose", e)),
                this.gp.ads.on("rewarded:reward", () => this.trigger("CallAdsRewardedReward", this.lastRewardedTag)),
                this.gp.ads.on("sticky:start", () => this.trigger("CallAdsStickyStart")),
                this.gp.ads.on("sticky:close", () => this.trigger("CallAdsStickyClose")),
                this.gp.ads.on("sticky:refresh", () => this.trigger("CallAdsStickyRefresh")),
                this.gp.ads.on("sticky:render", () => this.trigger("CallAdsStickyRender")),
                this.gp.socials.on("share", (e) => {
                    this.trigger("CallSocialsShare", e), window.focus();
                }),
                this.gp.socials.on("post", (e) => {
                    this.trigger("CallSocialsPost", e), window.focus();
                }),
                this.gp.socials.on("invite", (e) => {
                    this.trigger("CallSocialsInvite", e), window.focus();
                }),
                this.gp.socials.on("joinCommunity", (e) => {
                    this.trigger("CallSocialsJoinCommunity", e), window.focus();
                }),
                this.gp.on("change:language", (e) => this.trigger("CallChangeLanguage", e)),
                this.gp.on("change:avatarGenerator", (e) => this.trigger("CallChangeAvatarGenerator", e)),
                this.gp.on("change:orientation", (e) => this.trigger("CallChangeOrientation", e)),
                this.gp.on("change:platformDay", () => this.trigger("CallChangePlatformDay")),
                this.gp.on("pause", () => this.trigger("CallOnPause")),
                this.gp.on("resume", () => this.trigger("CallOnResume")),
                this.gp.on("event:connect", () => this.trigger("CallEventConnect")),
                this.gp.documents.on("open", () => this.trigger("CallDocumentsOpen")),
                this.gp.documents.on("close", () => {
                    this.trigger("CallDocumentsClose"), window.focus();
                }),
                this.gp.documents.on("fetch", (e) => this.trigger("CallDocumentsFetchSuccess", e.content)),
                this.gp.documents.on("error:fetch", () => this.trigger("CallDocumentsFetchError")),
                this.gp.rewards.on("give", (e) => this.trigger("CallOnRewardsGive", e)),
                this.gp.rewards.on("error:give", (e) => this.trigger("CallOnRewardsGiveError", e)),
                this.gp.rewards.on("accept", (e) => this.trigger("CallOnRewardsAccept", e)),
                this.gp.rewards.on("error:accept", (e) => this.trigger("CallOnRewardsAcceptError", e)),
                this.gp.triggers.on("activate", (e) => this.trigger("CallOnTriggersActivate", e.trigger)),
                this.gp.triggers.on("claim", (e) => this.trigger("CallOnTriggersClaim", e.trigger)),
                this.gp.triggers.on("error:claim", (e) => this.trigger("CallOnTriggersClaimError", e)),
                this.gp.events.on("join", (e) => this.trigger("CallOnEventsJoin", e)),
                this.gp.events.on("error:join", (e) => this.trigger("CallOnEventsJoinError", e)),
                this.gp.segments.on("enter", (e) => this.trigger("CallOnSegmentsEnter", e)),
                this.gp.segments.on("leave", (e) => this.trigger("CallOnSegmentsLeave", e)),
                this.gp.schedulers.on("register", (e) => this.trigger("CallOnSchedulersRegister", e)),
                this.gp.schedulers.on("error:register", (e) => this.trigger("CallOnSchedulersRegisterError", e)),
                this.gp.schedulers.on("claimDay", (e) => this.trigger("CallOnSchedulersClaimDay", e)),
                this.gp.schedulers.on("error:claimDay", (e) => this.trigger("CallOnSchedulersClaimDayError", e)),
                this.gp.schedulers.on("claimDayAdditional", (e) => this.trigger("CallOnSchedulersClaimDayAdditional", e)),
                this.gp.schedulers.on("error:claimDayAdditional", (e) => this.trigger("CallOnSchedulersClaimDayAdditionalError", e)),
                this.gp.schedulers.on("claimAllDay", (e) => this.trigger("CallOnSchedulersClaimAllDay", e)),
                this.gp.schedulers.on("error:claimAllDay", (e) => this.trigger("CallOnSchedulersClaimAllDayError", e)),
                this.gp.schedulers.on("claimAllDays", (e) => this.trigger("CallOnSchedulersClaimAllDays", e)),
                this.gp.schedulers.on("error:claimAllDays", (e) => this.trigger("CallOnSchedulersClaimAllDaysError", e)),
                this.gp.schedulers.on("join", (e) => this.trigger("CallOnSchedulersJoin", e)),
                this.gp.schedulers.on("error:join", (e) => this.trigger("CallOnSchedulersJoinError", e)),
                this.gp.sounds.on("mute", () => this.trigger("CallSoundsMute")),
                this.gp.sounds.on("mute:sfx", () => this.trigger("CallSoundsMuteSFX")),
                this.gp.sounds.on("mute:music", () => this.trigger("CallSoundsMuteMusic")),
                this.gp.sounds.on("unmute", () => this.trigger("CallSoundsUnmute")),
                this.gp.sounds.on("unmute:sfx", () => this.trigger("CallSoundsUnmuteSFX")),
                this.gp.sounds.on("unmute:music", () => this.trigger("CallSoundsUnmuteMusic")),
                this.gp.feedbacks.on('openFeedbacksList', (e) => this.trigger("CallOnFeedbacksOpenList", e)),
                this.gp.feedbacks.on('error:openFeedbacksList', (e) => this.trigger("CallOnFeedbacksOpenListError", e)),
                this.gp.feedbacks.on('event:feedbackMessage', (e) => this.trigger("CallOnFeedbackMessageEvent", e)),
                this.gp.feedbacks.on('event:feedbackCreated', (e) => this.trigger("CallOnFeedbackCreatedEvent", e)),
                this.gp.feedbacks.on('event:feedbackStatusUpdated', (e) => this.trigger("CallOnFeedbackStatusUpdatedEvent", e)),
                this.gp.feedbacks.on('event:feedbackPlatformStatusUpdated', (e) => this.trigger("CallOnFeedbackPlatformStatusUpdatedEvent", e)),
                // Channels
                this.gp.channels.on('openChat', () => this.trigger("CallOnOpenChat")),
                this.gp.channels.on('closeChat', () => {
                    this.trigger("CallOnCloseChat"), window.focus();
                }),
                this.gp.channels.on('error:openChat', (e) => this.trigger("CallOnOpenChatError", e)),
                this.gp.channels.on("event:deleteChannel", (e) => this.trigger("CallOnDeleteChannelEvent", e.id)),
                this.gp.channels.on("event:join", (e) => {
                    this.trigger("CallOnJoinEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:joinRequest", (e) => {
                    this.trigger("CallOnJoinRequestEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:cancelJoin", (e) => {
                    this.trigger("CallOnCancelJoinEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:leave", (e) => {
                    this.trigger("CallOnLeaveEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:mute", (e) => {
                    this.trigger("CallOnMuteEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:unmute", (e) => {
                    this.trigger("CallOnUnmuteEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:invite", (e) => {
                    this.trigger("CallOnInviteEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:cancelInvite", (e) => {
                    this.trigger("CallOnCancelInviteEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:rejectInvite", (e) => {
                    this.trigger("CallOnRejectInviteEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:rejectJoinRequest", (e) => {
                    this.trigger("CallOnRejectJoinRequestEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:message", (e) => {
                    this.trigger("CallOnMessageEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:editMessage", (e) => {
                    this.trigger("CallOnEditMessageEvent", JSON.stringify(e));
                }),
                this.gp.channels.on("event:deleteMessage", (e) => {
                    this.trigger("CallOnDeleteMessageEvent", JSON.stringify(e));
                });
        }
        trigger(e, t) {
            try {
                GamePushGMS.browserConsoleLog(e, t);
                if (GamePushGMS.sdkReady) {
                    // Send async event to GMS
                    let map = {};
                    map["type"] = GamePushGMS._mapTypeDesc;
                    map["event"] = this.toGMS(e);
                    if (typeof t !== "undefined") map["value"] = this.toGMS(t);

                    GMS_API.send_async_event_social(map);
                }
            } catch (err) {
                console.error("Trigger error:", e, t, err);
            }
        }
        toGMS(e) {
            return GamePushGMS.toString(e);
        }
        triggerErr(err) {
            console.warn(err);

            let map = {};
            if ("code" in err) map["code"] = err.code + "";
            if ("name" in err) map["name"] = err.name + "";
            if ("message" in err) {
                map["message"] = err.message + "";
            }
            else {
                map["message"] = JSON.stringify(err);
            }

            this.trigger("RuntimeError", map)
        }
        // Debug
        LoggerError(...t) {
            try {
                return this.gp.logger.error(...t);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        LoggerInfo(...t) {
            try {
                return this.gp.logger.info(...t);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        LoggerWarn(...t) {
            try {
                return this.gp.logger.warn(...t);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        LoggerLog(...t) {
            try {
                return this.gp.logger.log(...t);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // App & Platform
        Language() {
            try {
                return this.gp.language;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AvatarGenerator() {
            try {
                return this.gp.avatarGenerator;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlatformType() {
            try {
                return this.gp.platform.type;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlatformHasIntegratedAuth() {
            try {
                return this.toGMS(this.gp.platform.hasIntegratedAuth);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PlatformIsLogoutAvailable() {
            try {
                return this.toGMS(this.gp.platform.isLogoutAvailable);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PlatformIsSecretCodeAuthAvailable() {
            try {
                return this.toGMS(this.gp.platform.isSecretCodeAuthAvailable);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PlatformIsExternalLinksAllowed() {
            try {
                return this.toGMS(this.gp.platform.isExternalLinksAllowed);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        ProjectId() {
            try {
                return this.toGMS(this.gp.projectId);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AppTitle() {
            try {
                return this.gp.app.title;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AppDescription() {
            try {
                return this.gp.app.description;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AppImage() {
            try {
                return this.gp.app.image;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AppUrl() {
            try {
                return this.gp.app.url;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        IsMobile() {
            try {
                return this.toGMS(this.gp.isMobile);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        IsDev() {
            try {
                return this.toGMS(this.gp.isDev);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        IsAllowedOrigin() {
            try {
                return this.toGMS(this.gp.isAllowedOrigin);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        IsPortrait() {
            try {
                return this.toGMS(this.gp.isPortrait);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        ServerTime() {
            try {
                return this.toGMS(this.gp.serverTime);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ServerTime_UnixTime() {
            try {
                var dt = new Date(this.gp.serverTime);
                return Math.floor(dt.getTime() / 1000);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        ChangeLanguage(e) {
            try {
                this.gp.changeLanguage(e);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChangeLanguageByCode(e = "") {
            try {
                this.gp.changeLanguage(e.toLowerCase());
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChangeAvatarGenerator(e) {
            try {
                this.gp.changeAvatarGenerator(e.toLowerCase());
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        LoadOverlay() {
            try {
                this.gp.loadOverlay();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        IsPaused() {
            try {
                return this.toGMS(this.gp.isPaused);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        Pause() {
            try {
                this.gp.pause();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        Resume() {
            try {
                this.gp.resume();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SetBackground(e, t, r) {
            try {
                var p = {};
                if (e) p.url = e;
                if (t && (t > 0)) p.blur = t;
                if (r && (r > 0)) p.fade = r;
                this.gp.setBackground(p);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        GameStart() {
            try {
                this.gp.gameStart();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        GameplayStart() {
            try {
                this.gp.gameplayStart();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        GameplayStop() {
            try {
                this.gp.gameplayStop();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FullscreenOpen() {
            try {
                this.gp.fullscreen.open();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FullscreenClose() {
            try {
                this.gp.fullscreen.close();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FullscreenToggle() {
            try {
                this.gp.fullscreen.toggle();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FullscreenIsEnabled() {
            try {
                return this.toGMS(this.gp.fullscreen.isEnabled);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AppRequestReview() {
            try {
                this.gp.app.requestReview()
                    .then((r) => {
                        if (r.success) {
                            this.trigger("CallAppRequestReview", r.rating);
                        }
                        else {
                            this.trigger("CallAppRequestReviewError", r.error ?? "unsuccessful");
                        }
                        void window.focus();
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallAppRequestReviewError", e), window.focus();
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AppCanRequestReview() {
            try {
                return this.toGMS(this.gp.app.canRequestReview);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AppIsAlreadyReviewed() {
            try {
                return this.toGMS(this.gp.app.isAlreadyReviewed);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AppAddShortcut() {
            try {
                this.gp.app.addShortcut()
                    .then((e) => {
                        if (e) {
                            this.trigger("CallAppAddShortcut");
                        }
                        else {
                            this.trigger("CallAppAddShortcutError", "cancelled");
                        }
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallAppAddShortcutError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AppCanAddShortcut() {
            try {
                return this.toGMS(this.gp.app.canAddShortcut);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        // Player
        PlayerGetID() {
            try {
                return (this.gp.player.id + "");
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerReset() {
            try {
                this.gp.player.reset();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerRemove() {
            try {
                this.gp.player.remove();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerLoad() {
            try {
                this.gp.player.load();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerSync(e = !1, s = "preferred") {
            try {
                this.gp.player.sync({
                    override: Boolean(e),
                    storage: s,
                });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerEnableAutoSync(e, s) {
            try {
                this.gp.player.enableAutoSync({ interval: e, storage: s });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerDisableAutoSync(s) {
            try {
                this.gp.player.disableAutoSync({ storage: s });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerIsLoggedIn() {
            try {
                return this.toGMS(this.gp.player.isLoggedIn);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PlayerHasAnyCredentials() {
            try {
                return this.toGMS(this.gp.player.hasAnyCredentials);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PlayerIsStub() {
            try {
                return this.toGMS(this.gp.player.isStub);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PlayerLogin() {
            try {
                this.gp.player.login();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerLogout() {
            try {
                this.gp.player.logout();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerGetScore() {
            try {
                return this.gp.player.score;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PlayerSetScore(e) {
            try {
                this.gp.player.score = Number(e);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerAddScore(e) {
            try {
                this.gp.player.score += Number(e);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerGetName() {
            try {
                return this.gp.player.name;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerSetName(e) {
            try {
                this.gp.player.name = e;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerGetAvatar() {
            try {
                return this.gp.player.avatar;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerSetAvatar(e) {
            try {
                this.gp.player.avatar = e;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerGet(e) {
            try {
                return this.toGMS(this.gp.player.get(e));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerGetMinValue(e) {
            try {
                return this.toGMS(this.gp.player.getMinValue(e));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerGetMaxValue(e) {
            try {
                return this.toGMS(this.gp.player.getMaxValue(e));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerSet(e, t) {
            try {
                this.gp.player.set(e, t);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerAdd(e, t) {
            try {
                this.gp.player.add(e, Number(t));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerHas(e) {
            try {
                return this.toGMS(this.gp.player.has(e));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PlayerSetFlag(e, t) {
            try {
                this.gp.player.set(e, ((t != null) && (t > 0)));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerToggle(e) {
            try {
                this.gp.player.toggle(e);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerFields() {
            try {
                return JSON.stringify(this.gp.player.fields.map((e) => ({ ...e, defaultValue: e.default })));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerFetchFields() {
            try {
                this.gp.player.fetchFields();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerGetField(e) {
            try {
                return this.gp.player.getField(e);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerGetFieldName(e) {
            try {
                return this.gp.player.getFieldName(e);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerGetFieldVariantName(e, t) {
            try {
                return this.gp.player.getFieldVariantName(e, t);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerGetFieldVariantAt(e, t) {
            try {
                var r = this.gp.player.getField(e).variants[t];
                return r ? r.value : "";
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerGetFieldVariantIndex(e, t) {
            try {
                return this.gp.player.getField(e).variants.findIndex((e) => e.value === t);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerToJSON() {
            try {
                return this.toGMS(this.gp.player.toJSON());
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerFromJSON(e) {
            try {
                var obj = JSON.parse(e);
                return this.gp.player.fromJSON(obj);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayersFetch(e) {
            try {
                let s = e.split(",").map((e) => e.trim()).filter((e) => Number(e));
                this.gp.players.fetch({ ids: s })
                    .then((e) => {
                        this.trigger("CallPlayersFetchSuccess", JSON.stringify(e.players));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallPlayersFetchError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerFetch() {
            try {
                var p = { ids: [], };
                for (var i = 0; i < arguments.length; i++) {
                    var l = arguments[i];
                    if (l) p.ids.push(Number(l));
                }

                this.gp.players.fetch(p)
                    .then((e) => {
                        this.trigger("CallPlayersFetchSuccess", JSON.stringify(e.players));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallPlayersFetchError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlayerStatsActiveDays() {
            try {
                return this.gp.player.stats.activeDays;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PlayerStatsActiveDaysConsecutive() {
            try {
                return this.gp.player.stats.activeDaysConsecutive;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PlayerStatsPlaytimeToday() {
            try {
                return this.gp.player.stats.playtimeToday;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PlayerStatsPlaytimeAll() {
            try {
                return this.gp.player.stats.playtimeAll;
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        // Leaderboard
        LeaderboardOpen(e, s, i, a, l, n) {
            try {
                var p = new LeaderboardClass();
                if (e) p.setOrderBy(e);
                if (s) p.setOrder(s);
                if (i) p.setLimit(i);
                if (a) p.setIncludeFields(a);
                if (l) p.setDisplayFields(l);
                if (n) p.setWithMe(n);

                this.gp.leaderboard.open(p)
                    .catch(console.warn);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        LeaderboardFetch(e, s, i, a, n) {
            try {
                var p = new LeaderboardClass();
                if (e) p.setOrderBy(e);
                if (s) p.setOrder(s);
                if (i) p.setLimit(i);
                if (a) p.setIncludeFields(a);
                if (n) p.setWithMe(n);

                this.gp.leaderboard.fetch(p)
                    .then((t) => {
                        this.trigger("CallLeaderboardFetchTag", e), this.trigger("CallLeaderboardFetch", JSON.stringify(t.players));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallLeaderboardFetchError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        LeaderboardFetchPlayerRating(e, s, a) {
            try {
                var p = new LeaderboardClass();
                if (e) p.setOrderBy(e);
                if (s) p.setOrder(s);
                if (a) p.setIncludeFields(a);

                this.gp.leaderboard.fetchPlayerRating(p)
                    .then((t) => {
                        this.trigger("CallLeaderboardFetchPlayerTag", e), this.trigger("CallLeaderboardFetchPlayer", t.player.position);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallLeaderboardFetchPlayerError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        LeaderboardScopedOpen(t, r, s, i, a, l, n) {
            try {
                var p = new LeaderboardClass();
                if (t) p.setIdOrTag(t);
                if (r) p.setVariant(r);
                if (s) p.setOrder(s);
                if (i) p.setLimit(i);
                if (a) p.setIncludeFields(a);
                if (l) p.setDisplayFields(l);
                if (n) p.setWithMe(n);

                this.gp.leaderboard.openScoped(p)
                    .catch(console.warn);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        LeaderboardScopedFetch(t, r, s, i, a, n) {
            try {
                var p = new LeaderboardClass();
                if (t) p.setIdOrTag(t);
                if (r) p.setVariant(r);
                if (s) p.setOrder(s);
                if (i) p.setLimit(i);
                if (a) p.setIncludeFields(a);
                if (n) p.setWithMe(n);

                this.gp.leaderboard.fetchScoped(p)
                    .then((e) => {
                        this.trigger("CallLeaderboardScopedFetchTag", t), this.trigger("CallLeaderboardScopedFetchVariant", r),
                            this.trigger("CallLeaderboardScopedFetch", JSON.stringify(e.players));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallLeaderboardScopedFetchError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        LeaderboardScopedPublishRecord(t, r, g, i, a, l, n, o, s) {
            try {
                var p = new LeaderboardClass();
                if (t) p.setIdOrTag(t);
                if (r) p.setVariant(r);
                if (g) p.setOverride(Number(g) > 0);
                if (i && a) p.addRecord(i, a);
                if (l && n) p.addRecord(l, n);
                if (o && s) p.addRecord(o, s);

                this.gp.leaderboard.publishRecord(p)
                    .then(() => {
                        this.trigger("CallLeaderboardScopedPublishRecordComplete");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallLeaderboardScopedPublishRecordError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        LeaderboardScopedFetchPlayerRating(t, r, a) {
            try {
                var p = new LeaderboardClass();
                if (t) p.setIdOrTag(t);
                if (r) p.setVariant(r);
                if (a) p.setIncludeFields(a);

                this.gp.leaderboard.fetchPlayerRatingScoped(p)
                    .then((e) => {
                        this.trigger("CallLeaderboardScopedFetchPlayerTag", t), this.trigger("CallLeaderboardScopedFetchPlayerVariant", r),
                            this.trigger("CallLeaderboardScopedFetchPlayer", e.player.position);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallLeaderboardScopedFetchPlayerError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Achievements
        AchievementsOpen() {
            try {
                this.gp.achievements.open().catch(console.warn);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AchievementsFetch() {
            try {
                this.gp.achievements.fetch()
                    .then((e) => {
                        this.trigger("CallAchievementsFetch", JSON.stringify(e.achievements)),
                            this.trigger("CallAchievementsFetchGroups", JSON.stringify(e.achievementsGroups)),
                            this.trigger("CallPlayerAchievementsFetch", JSON.stringify(e.playerAchievements));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallAchievementsFetchError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AchievementsUnlock(e) {
            try {
                var t = parseInt(e, 10) || 0,
                    r = t > 0 ? { id: t } : { tag: e };
                this.gp.achievements.unlock(r)
                    .then((t) => {
                        if (t.success) {
                            this.trigger("CallAchievementsUnlock", e);
                        }
                        else {
                            this.trigger("CallAchievementsUnlockError", t.error ?? "unsuccessful");
                        }
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallAchievementsUnlockError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AchievementsHas(e) {
            try {
                return this.toGMS(this.gp.achievements.has(e));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AchievementsList() {
            try {
                return this.toGMS(this.gp.achievements.list);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AchievementsPlayerAchievementsList() {
            try {
                return this.toGMS(this.gp.achievements.playerAchievementsList);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AchievementsGroupsList() {
            try {
                return this.toGMS(this.gp.achievements.groupsList);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AchievementsGetProgress(e) {
            try {
                return this.toGMS(this.gp.achievements.getProgress(e));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AchievementsSetProgress(e, p) {
            try {
                var t = parseInt(e, 10) || 0,
                    r = t > 0 ? { id: t } : { tag: e };
                r.progress = Number(p);
                this.gp.achievements.setProgress(r)
                    .then((t) => {
                        if (t.success) {
                            this.trigger("CallAchievementsProgress", e);
                        }
                        else {
                            this.trigger("CallAchievementsProgressError", t.error ?? "unsuccessful");
                        }
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallAchievementsProgressError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Purchases
        PaymentsProducts() {
            try {
                return this.toGMS(JSON.stringify(this.gp.payments.products));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PaymentsPurchases() {
            try {
                return this.toGMS(JSON.stringify(this.gp.payments.purchases));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PaymentsFetchProducts() {
            try {
                this.gp.payments.fetchProducts()
                    .then((e) => {
                        this.trigger("CallPaymentsFetchProducts", JSON.stringify(e.products)), this.trigger("CallPaymentsFetchPlayerPurcahses",
                            JSON.stringify(e.playerPurchases));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallPaymentsFetchProductsError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PaymentsPurchase(e) {
            try {
                var t = parseInt(e, 10) || 0,
                    r = t > 0 ? { id: t } : { tag: e };
                this.gp.payments.purchase(r)
                    .then((t) => {
                        if (t.success) {
                            this.trigger("CallPaymentsPurchase", e);
                        }
                        else {
                            this.trigger("CallPaymentsPurchaseError", t.error ?? "unsuccessful");
                        }
                        void window.focus();
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallPaymentsPurchaseError", e), window.focus();
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PaymentsConsume(e) {
            try {
                var t = parseInt(e, 10) || 0,
                    r = t > 0 ? { id: t } : { tag: e };
                this.gp.payments.consume(r)
                    .then((t) => {
                        if (t.success) {
                            this.trigger("CallPaymentsConsume", t), void window.focus();
                        }
                        else {
                            this.trigger("CallPaymentsConsumeError", t.error ?? "unsuccessful");
                        }
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallPaymentsConsumeError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PaymentsConsumeByPurchaseId(e) {
            try {
                this.gp.payments.consume({ purchaseId: e })
                    .then((t) => {
                        if (t.success) {
                            this.trigger("CallPaymentsConsume", t), void window.focus();
                        }
                        else {
                            this.trigger("CallPaymentsConsumeError", t.error ?? "unsuccessful");
                        }
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallPaymentsConsumeError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PaymentsHas(e) {
            try {
                return this.toGMS(this.gp.payments.has(e));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PaymentsIsAvailable() {
            try {
                return this.toGMS(this.gp.payments.isAvailable);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        PaymentsGetPurchase(e) {
            try {
                var p = this.gp.payments.getPurchase(e);
                return (p == null ? "" : this.toGMS(p));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PaymentsSubscribe(e) {
            try {
                var t = parseInt(e, 10) || 0,
                    r = t > 0 ? { id: t } : { tag: e };
                this.gp.payments.subscribe(r)
                    .then((t) => {
                        if (t.success) {
                            this.trigger("CallPaymentsSubscribeSuccess", e);
                        }
                        else {
                            this.trigger("CallPaymentsSubscribeError", t.error ?? "unsuccessful");
                        }
                        void window.focus();
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallPaymentsSubscribeError", e), window.focus();
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PaymentsUnsubscribe(e) {
            try {
                var t = parseInt(e, 10) || 0,
                    r = t > 0 ? { id: t } : { tag: e };
                this.gp.payments.unsubscribe(r)
                    .then((t) => {
                        if (t.success) {
                            this.trigger("CallPaymentsUnsubscribeSuccess", e), void window.focus();
                        }
                        else {
                            this.trigger("CallPaymentsUnsubscribeError", t.error ?? "unsuccessful");
                        }
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallPaymentsUnsubscribeError", e), window.focus();
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PaymentsIsSubscriptionsAvailable() {
            try {
                return this.toGMS(this.gp.payments.isSubscriptionsAvailable);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        // Ads
        AdsShowFullscreen(e = -1) {
            try {
                var c = undefined;
                if (e >= 0) {
                    c = { showCountdownOverlay: (e == 1) };
                }
                this.gp.ads.showFullscreen(c);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AdsShowRewarded(t, e = -1) {
            try {
                this.lastRewardedTag = t ?? "";
                var c = undefined;
                if (e >= 0) {
                    c = { showRewardedFailedOverlay: (e == 1) };
                }
                this.gp.ads.showRewardedVideo(c);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AdsShowPreloader() {
            try {
                this.gp.ads.showPreloader();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AdsShowSticky() {
            try {
                this.gp.ads.showSticky();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AdsCloseSticky() {
            try {
                this.gp.ads.closeSticky();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AdsRefreshSticky() {
            try {
                this.gp.ads.refreshSticky();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AdsIsAdblockEnabled() {
            try {
                return this.toGMS(this.gp.ads.isAdblockEnabled);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AdsIsStickyAvailable() {
            try {
                return this.toGMS(this.gp.ads.isStickyAvailable);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AdsIsFullscreenAvailable() {
            try {
                return this.toGMS(this.gp.ads.isFullscreenAvailable);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AdsIsRewardedAvailable() {
            try {
                return this.toGMS(this.gp.ads.isRewardedAvailable);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AdsIsPreloaderAvailable() {
            try {
                return this.toGMS(this.gp.ads.isPreloaderAvailable);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AdsIsStickyPlaying() {
            try {
                return this.toGMS(this.gp.ads.isStickyPlaying);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AdsIsFullscreenPlaying() {
            try {
                return this.toGMS(this.gp.ads.isFullscreenPlaying);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AdsIsRewardedPlaying() {
            try {
                return this.toGMS(this.gp.ads.isRewardedPlaying);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AdsIsPreloaderPlaying() {
            try {
                return this.toGMS(this.gp.ads.isPreloaderPlaying);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AdsIsCountdownOverlayEnabled() {
            try {
                return this.toGMS(this.gp.ads.isCountdownOverlayEnabled);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AdsIsRewardedFailedOverlayEnabled() {
            try {
                return this.toGMS(this.gp.ads.isRewardedFailedOverlayEnabled);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        AdsCanShowFullscreenBeforeGamePlay() {
            try {
                return this.toGMS(this.gp.ads.canShowFullscreenBeforeGamePlay);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        // Analytics
        AnalyticsHit(e) {
            try {
                return this.gp.analytics.hit(e);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        AnalyticsGoal(e, t) {
            try {
                return this.gp.analytics.goal(e, t);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Socials
        SocialsShare(e, t, r) {
            try {
                var p = {};
                if (e) p.text = e;
                if (t) p.url = t;
                if (r) p.image = r;
                this.gp.socials.share(p);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SocialsPost(e, t, r) {
            try {
                var p = {};
                if (e) p.text = e;
                if (t) p.url = t;
                if (r) p.image = r;
                this.gp.socials.post(p);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SocialsInvite(e, t, r) {
            try {
                var p = {};
                if (e) p.text = e;
                if (t) p.url = t;
                if (r) p.image = r;
                this.gp.socials.invite(p);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SocialsJoinCommunity() {
            try {
                this.gp.socials.joinCommunity();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SocialsCommunityLink() {
            try {
                return this.toGMS(this.gp.socials.communityLink);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SocialsIsSupportsShare() {
            try {
                return this.toGMS(this.gp.socials.isSupportsShare);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SocialsIsSupportsNativeShare() {
            try {
                return this.toGMS(this.gp.socials.isSupportsNativeShare);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SocialsIsSupportsNativePosts() {
            try {
                return this.toGMS(this.gp.socials.isSupportsNativePosts);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SocialsIsSupportsNativeInvite() {
            try {
                return this.toGMS(this.gp.socials.isSupportsNativeInvite);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SocialsCanJoinCommunity() {
            try {
                return this.toGMS(this.gp.socials.canJoinCommunity);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SocialsIsSupportsNativeCommunityJoin() {
            try {
                return this.toGMS(this.gp.socials.isSupportsNativeCommunityJoin);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SocialsMakeShareUrl(e) {
            try {
                var p = JSON.parse(e);
                return this.gp.socials.makeShareUrl(p);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SocialsGetShareParam(e) {
            try {
                return this.toGMS(this.gp.socials.getShareParam(e));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Games collections
        GamesCollectionsOpen(e) {
            try {
                var t = parseInt(e, 10) || 0,
                    r = t > 0 ? { id: t } : { tag: e || "ANY" };
                this.gp.gamesCollections.open(r);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        GamesCollectionsFetch(e) {
            try {
                var t = parseInt(e, 10) || 0,
                    r = t > 0 ? { id: t } : { tag: e };
                this.gp.gamesCollections.fetch(r)
                    .then((t) => {
                        this.trigger("CallGamesCollectionsFetchTag", e), this.trigger("CallGamesCollectionsFetch", JSON.stringify(t));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallGamesCollectionsFetchError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Variables
        VariablesFetch() {
            try {
                this.gp.variables.fetch()
                    .then((e) => {
                        this.trigger("CallVariablesFetchSuccess", e);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallVariablesFetchError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        VariablesGet(e) {
            try {
                var t = this.gp.variables.get(e);
                return this.toGMS(t ? t : "");
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        VariablesHas(e) {
            try {
                var t = this.gp.variables.has(e);
                return this.toGMS(t ? t : 0);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        VariablesType(e) {
            try {
                if (this.VariablesHas(e)) {
                    var t = this.gp.variables.type(e);
                    if (t) return this.toGMS(t);
                }
                return this.toGMS("empty");
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        VariablesIsPlatformVariablesAvailable() {
            try {
                return this.toGMS(this.gp.variables.isPlatformVariablesAvailable);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        VariablesFetchPlatformVariables(c) {
            try {
                var p = {};
                if (c) {
                    p.clientParams = JSON.parse(c);
                }
                this.gp.variables.fetchPlatformVariables(p)
                    .then((e) => {
                        this.trigger("CallVariablesFetchPlatformVariablesSuccess", e);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallVariablesFetchPlatformVariablesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Uniques
        UniquesRegister(t, v) {
            try {
                this.gp.uniques.register({ tag: t, value: v })
                    .then((e) => {
                        this.trigger("CallUniquesRegisterSuccess", e);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallUniquesRegisterError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        UniquesGet(e) {
            try {
                return this.toGMS(this.gp.uniques.get(e));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        UniquesCheck(t, v) {
            try {
                this.gp.uniques.check({ tag: t, value: v })
                    .then((e) => {
                        this.trigger("CallUniquesCheckSuccess", e);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallUniquesCheckError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        UniquesList() {
            try {
                return this.toGMS(this.gp.uniques.list);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        UniquesDelete(t) {
            try {
                this.gp.uniques.delete({ tag: t })
                    .then((e) => {
                        this.trigger("CallUniquesDeleteSuccess", e);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallUniquesDeleteError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Documents
        DocumentsOpen(t) {
            try {
                this.gp.documents.open({ type: t });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        DocumentsFetch(t, f) {
            try {
                this.gp.documents.fetch({ type: t, format: f });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Files
        FilesUpload(t, a) {
            try {
                var p = new FileClass();
                if (t) p.setTags(t);
                if (a) p.setAccept(a);
                this.gp.files.upload(p)
                    .then((e) => {
                        this.trigger("CallFilesUploadSuccess", JSON.stringify(e));
                    })
                    .catch((e) => {
                        this.trigger("CallFilesUploadError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FilesUploadUrl(u, f, t) {
            try {
                var p = new FileClass();
                if (u) p.setUrl(u);
                if (f) p.setFilename(f);
                if (t) p.setTags(t);
                this.gp.files.uploadUrl(p)
                    .then((e) => {
                        this.trigger("CallFilesUploadUrlSuccess", JSON.stringify(e));
                    })
                    .catch((e) => {
                        this.trigger("CallFilesUploadUrlError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FilesUploadContent(c, f, t) {
            try {
                var p = new FileClass();
                if (c) p.setContent(c);
                if (f) p.setFilename(f);
                if (t) p.setTags(t);
                this.gp.files.uploadContent(p)
                    .then((e) => {
                        this.trigger("CallFilesUploadContentSuccess", JSON.stringify(e));
                    })
                    .catch((e) => {
                        this.trigger("CallFilesUploadContentError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FilesLoadContent(e) {
            try {
                this.gp.files.loadContent(e)
                    .then((e) => {
                        this.trigger("CallFilesLoadContentSuccess", e);
                    })
                    .catch((e) => {
                        this.trigger("CallFilesLoadContentError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FilesChooseFile(e) {
            try {
                this.gp.files.chooseFile(e)
                    .then((e) => {
                        this.trigger("CallFilesChooseFileSuccess", e.tempUrl);
                    })
                    .catch((e) => {
                        this.trigger("CallFilesChooseFileError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FilesFetch(t, i, l, o) {
            try {
                var p = new FileClass();
                if (o) p.setOffset(o);
                if (l) p.setLimit(l);
                if (i) p.setPlayerId(i);
                if (t) p.setTags(t);
                this.gp.files.fetch(p)
                    .then((e) => {
                        this.trigger("CallFilesFetchCanLoadMore", e.canLoadMore), this.trigger("CallFilesFetchSuccess", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        this.trigger("CallFilesFetchError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FilesFetchMore(t, i, l) {
            try {
                var p = new FileClass();
                if (l) p.setLimit(l);
                if (i) p.setPlayerId(i);
                if (t) p.setTags(t);
                this.gp.files.fetchMore(p)
                    .then((e) => {
                        this.trigger("CallFilesFetchMoreCanLoadMore", e.canLoadMore), this.trigger("CallFilesFetchMoreSuccess", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        this.trigger("CallFilesFetchMoreError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Images
        ImagesUpload(t) {
            try {
                var p = new FileClass();
                if (t) p.setTags(t);
                this.gp.images.upload(p)
                    .then((e) => {
                        this.trigger("CallImagesUploadSuccess", JSON.stringify(e));
                    })
                    .catch((e) => {
                        this.trigger("CallImagesUploadError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ImagesUploadUrl(u, f, t) {
            try {
                var p = new FileClass();
                if (u) p.setUrl(u);
                if (f) p.setFilename(f);
                if (t) p.setTags(t);
                this.gp.images.uploadUrl(p)
                    .then((e) => {
                        this.trigger("CallImagesUploadUrlSuccess", JSON.stringify(e));
                    })
                    .catch((e) => {
                        this.trigger("CallImagesUploadUrlError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ImagesChooseFile() {
            try {
                this.gp.images.chooseFile()
                    .then((e) => {
                        this.trigger("CallImagesChooseFileSuccess", e.tempUrl);
                    })
                    .catch((e) => {
                        this.trigger("CallImagesChooseFileError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ImagesFetch(t, i, l, o) {
            try {
                var p = new FileClass();
                if (o) p.setOffset(o);
                if (l) p.setLimit(l);
                if (i) p.setPlayerId(i);
                if (t) p.setTags(t);
                this.gp.images.fetch(p)
                    .then((e) => {
                        this.trigger("CallImagesFetchCanLoadMore", e.canLoadMore), this.trigger("CallImagesFetchSuccess", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        this.trigger("CallImagesFetchError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ImagesFetchMore(t, i, l) {
            try {
                var p = new FileClass();
                if (l) p.setLimit(l);
                if (i) p.setPlayerId(i);
                if (t) p.setTags(t);
                this.gp.images.fetchMore(p)
                    .then((e) => {
                        this.trigger("CallImagesFetchMoreCanLoadMore", e.canLoadMore), this.trigger("CallImagesFetchMoreSuccess", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        this.trigger("CallImagesFetchMoreError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ImagesResize(u, w, h, c = !1) {
            try {
                return this.gp.images.resize(u, w, h, Boolean(c));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Rewards
        RewardsGive(e, l) {
            try {
                var p = {};
                if ((parseInt(e, 10) || 0) > 0) {
                    p.id = Number(e);
                }
                else p.tag = String(e);
                if (l) p.lazy = l == 1;
                this.gp.rewards.give(p);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        RewardsAccept(e) {
            try {
                var p = {};
                if ((parseInt(e, 10) || 0) > 0) {
                    p.id = Number(e);
                }
                else p.tag = String(e);
                this.gp.rewards.accept(p);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        RewardsList() {
            try {
                return this.toGMS(this.gp.rewards.list);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        RewardsGivenList() {
            try {
                return this.toGMS(this.gp.rewards.givenList);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        RewardsGetReward(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                var l = this.gp.rewards.getReward(p);
                if (l.reward) {
                    return this.toGMS(l);
                }
                else {
                    return "";
                }
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        RewardsHas(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                return this.toGMS(this.gp.rewards.has(p));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        RewardsHasAccepted(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                return this.toGMS(this.gp.rewards.hasAccepted(p));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        RewardsHasUnaccepted(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                return this.toGMS(this.gp.rewards.hasUnaccepted(p));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        // Triggers
        TriggersClaim(i, t) {
            try {
                var p = {};
                if (i) {
                    p.id = String(i);
                }
                else if (t) {
                    p.tag = String(t);
                }
                else {
                    throw new SyntaxError("trigger_id_or_tag_not_found");
                }
                this.gp.triggers.claim(p);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        TriggersList() {
            try {
                return this.toGMS(this.gp.triggers.list);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        TriggersActivatedList() {
            try {
                return this.toGMS(this.gp.triggers.activatedList);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        TriggersGetTrigger(e) {
            try {
                var l = this.gp.triggers.getTrigger(e);
                if (l.trigger) {
                    return this.toGMS(l);
                }
                else {
                    return "";
                }
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        TriggersIsActivated(e) {
            try {
                return this.toGMS(this.gp.triggers.isActivated(e));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        TriggersIsClaimed(e) {
            try {
                return this.toGMS(this.gp.triggers.isClaimed(e));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        // Events
        EventsJoin(e) {
            try {
                var p = {};
                if ((parseInt(e, 10) || 0) > 0) {
                    p.id = Number(e);
                }
                else p.tag = String(e);
                this.gp.events.join(p);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        EventsList() {
            try {
                return this.toGMS(this.gp.events.list);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        EventsActiveList() {
            try {
                return this.toGMS(this.gp.events.activeList);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        EventsGetEvent(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                var l = this.gp.events.getEvent(p);
                if (l.event) {
                    return this.toGMS(l);
                }
                else {
                    return "";
                }
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        EventsHas(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                return this.toGMS(this.gp.events.has(p));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        EventsIsJoined(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                return this.toGMS(this.gp.events.isJoined(p));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        // Experiments
        ExperimentsMap() {
            try {
                return this.toGMS(this.gp.experiments.map);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ExperimentsHas(t, c) {
            try {
                return this.toGMS(this.gp.experiments.has(t, c));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        // Segments
        SegmentsList() {
            try {
                return this.toGMS(this.gp.segments.list);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SegmentsHas(t) {
            try {
                return this.toGMS(this.gp.segments.has(t));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        // Schedulers
        SchedulersRegister(e) {
            try {
                var p = {};
                if ((parseInt(e, 10) || 0) > 0) {
                    p.id = Number(e);
                }
                else p.tag = String(e);
                this.gp.schedulers.register(p);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SchedulersClaimDay(e, d) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                this.gp.schedulers.claimDay(p, Number(d));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SchedulersClaimDayAdditional(e, d, t) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);;
                this.gp.schedulers.claimDayAdditional(p, Number(d), t);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SchedulersClaimAllDay(e, d) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                this.gp.schedulers.claimAllDay(p, Number(d));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SchedulersClaimAllDays(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                this.gp.schedulers.claimAllDays(p);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SchedulersList() {
            try {
                return this.toGMS(this.gp.schedulers.list);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SchedulersActiveList() {
            try {
                return this.toGMS(this.gp.schedulers.activeList);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SchedulersGetScheduler(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                var l = this.gp.schedulers.getScheduler(p);
                if (l.scheduler) {
                    return this.toGMS(l);
                }
                else {
                    return "";
                }
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SchedulersGetSchedulerDay(e, d) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                var l = this.gp.schedulers.getSchedulerDay(p, Number(d));
                if (l.scheduler) {
                    return this.toGMS(l);
                }
                else {
                    return "";
                }
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SchedulersGetSchedulerCurrentDay(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                var l = this.gp.schedulers.getSchedulerCurrentDay(p);
                if (l.scheduler) {
                    return this.toGMS(l);
                }
                else {
                    return "";
                }
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SchedulersIsRegistered(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                return this.toGMS(this.gp.schedulers.isRegistered(p));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SchedulersIsTodayRewardClaimed(e) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                return this.toGMS(this.gp.schedulers.isTodayRewardClaimed(p));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SchedulersCanClaimDay(e, d) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                return this.toGMS(this.gp.schedulers.canClaimDay(p, Number(d)));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SchedulersCanClaimDayAdditional(e, d, t) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                return this.toGMS(this.gp.schedulers.canClaimDayAdditional(p, Number(d), t));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SchedulersCanClaimAllDay(e, d) {
            try {
                var p = ((parseInt(e, 10) || 0) > 0) ? Number(e) : String(e);
                return this.toGMS(this.gp.schedulers.canClaimAllDay(p, Number(d)));
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        // Storage
        StorageSetStorage(e) {
            try {
                this.gp.storage.setStorage(e);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        StorageSet(e, t) {
            try {
                this.gp.storage.set(e, t)
                    .then(() => {
                        var o = { key: e, value: t };
                        this.trigger("CallStorageSetSuccess", JSON.stringify(o));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallStorageSetError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        StorageGet(e) {
            try {
                this.gp.storage.get(e)
                    .then((v) => {
                        var o = { key: e, value: v };
                        this.trigger("CallStorageGetSuccess", JSON.stringify(o));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallStorageGetError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        StorageSetGlobal(e, t) {
            try {
                this.gp.storage.setGlobal(e, t)
                    .then((k, v) => {
                        var o = { key: k, value: v };
                        this.trigger("CallStorageSetGlobalSuccess", JSON.stringify(o));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallStorageSetGlobalError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        StorageGetGlobal(e) {
            try {
                this.gp.storage.getGlobal(e)
                    .then((v) => {
                        var o = { key: e, value: v };
                        this.trigger("CallStorageGetGlobalSuccess", JSON.stringify(o));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallStorageGetGlobalError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Overlay
        WindowsShowConfirm(t, d, y, n, i = -1) {
            try {
                var o = undefined;
                if (t && t != '') {
                    if (!o) o = {};
                    o.title = t;
                }
                if (d && d != '') {
                    if (!o) o = {};
                    o.description = d;
                }
                if (y && y != '') {
                    if (!o) o = {};
                    o.textConfirm = y;
                }
                if (n && n != '') {
                    if (!o) o = {};
                    o.textCancel = n;
                }
                if (i && i >= 0) {
                    if (!o) o = {};
                    o.invertButtonColors = i > 0;
                }
                return this.gp.windows.showConfirm(o)
                    .then((isConfirmed) => {
                        this.trigger("CallWindowsShowConfirm", isConfirmed);
                        void window.focus();
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallWindowsShowConfirmError", e), window.focus();
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Sounds
        SoundsIsMuted() {
            try {
                return this.toGMS(this.gp.sounds.isMuted);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SoundsIsSFXMuted() {
            try {
                return this.toGMS(this.gp.sounds.isSFXMuted);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SoundsIsMusicMuted() {
            try {
                return this.toGMS(this.gp.sounds.isMusicMuted);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        SoundsMute() {
            try {
                this.gp.sounds.mute();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SoundsUnmute() {
            try {
                this.gp.sounds.unmute();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SoundsMuteSFX() {
            try {
                this.gp.sounds.muteSFX();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SoundsUnmuteSFX() {
            try {
                this.gp.sounds.unmuteSFX();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SoundsMuteMusic() {
            try {
                this.gp.sounds.muteMusic();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        SoundsUnmuteMusic() {
            try {
                this.gp.sounds.unmuteMusic();
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Feedbacks
        FeedbacksSend() {
            try {
                var p = {
                    type: arguments[0].trim().toUpperCase(),
                    text: arguments[1]
                }
                if (arguments.length > 2) {
                    var _f = [];
                    for (var i = 2; i < arguments.length; i++) {
                        var l = arguments[i].trim();
                        if (l) _f.push(l.trim());
                    }
                    if (_f.length > 0) {
                        p.files = _f;
                    }
                }
                this.gp.feedbacks.send(p)
                    .then((o) => {
                        this.trigger("CallOnFeedbackCreate", JSON.stringify(o));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFeedbackCreateError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FeedbacksOpen(t, s) {
            try {
                var o = undefined;
                if (t && t != '') {
                    if (!o) o = {};
                    o.type = t.trim().toUpperCase();
                }
                if (s && s != '') {
                    if (!o) o = {};
                    o.status = s.trim().toUpperCase();
                }
                this.gp.feedbacks.open(o);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FeedbacksOpenFeedback(f) {
            try {
                this.gp.feedbacks.openFeedback({ feedbackId: f.trim() });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FeedbacksFetch(l, t, s) {
            try {
                var o = undefined;
                if (l && l != '' && l != 0) {
                    if (!o) o = {};
                    o.limit = parseInt(l, 10);
                }
                if (t && t != '') {
                    if (!o) o = {};
                    o.type = t.trim().toUpperCase();
                }
                if (s && s != '') {
                    if (!o) o = {};
                    o.status = s.trim().toUpperCase();
                }
                this.gp.feedbacks.fetch(o)
                    .then((r) => {
                        this.trigger("CallOnFeedbacksFetch", JSON.stringify(r));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFeedbacksFetchError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FeedbacksFetchMore(l, t, s) {
            try {
                var o = undefined;
                if (l && l != '' && l != 0) {
                    if (!o) o = {};
                    o.limit = parseInt(l, 10);
                }
                if (t && t != '') {
                    if (!o) o = {};
                    o.type = t.trim().toUpperCase();
                }
                if (s && s != '') {
                    if (!o) o = {};
                    o.status = s.trim().toUpperCase();
                }
                this.gp.feedbacks.fetchMore(o)
                    .then((r) => {
                        this.trigger("CallOnFeedbacksFetchMore", JSON.stringify(r));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFeedbacksFetchMoreError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        FeedbacksSendMessage() {
            try {
                var p = {
                    feedbackId: arguments[0],
                    text: arguments[1]
                }
                if (arguments.length > 2) {
                    var _f = [];
                    for (var i = 2; i < arguments.length; i++) {
                        var l = arguments[i].trim();
                        if (l) _f.push(l.trim());
                    }
                    if (_f.length > 0) {
                        p.files = _f;
                    }
                }
                this.gp.feedbacks.sendMessage(p)
                    .then((o) => {
                        this.trigger("CallOnFeedbacksSendMessage", JSON.stringify(o));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFeedbacksSendMessageError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Channels
        ChannelsOpenChat(e, t) {
            try {
                var o = undefined;
                if (e && e != '') {
                    if (!o) o = {};
                    o.id = parseInt(e, 10);
                }
                if (t && t != '') {
                    if (!o) o = {};
                    o.tags = t.split(",").map((e) => e.trim()).filter((e) => e);
                }
                this.gp.channels.openChat(o);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsOpenPersonalChat(e, t) {
            try {
                var o = {};
                o.playerId = parseInt(e, 10);
                if (t && t != '') {
                    o.tags = t.split(",").map((e) => e.trim()).filter((e) => e);
                }
                this.gp.channels.openPersonalChat(o);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsOpenFeed(e, t) {
            try {
                var o = {};
                o.playerId = parseInt(e, 10);
                if (t && t != '') {
                    o.tags = t.split(",").map((e) => e.trim()).filter((e) => e);
                }
                this.gp.channels.openFeed(o);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsIsMainChatEnabled() {
            try {
                return this.toGMS(this.gp.channels.isMainChatEnabled);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        ChannelsMainChatId() {
            try {
                return this.toGMS(this.gp.channels.mainChatId);
            }
            catch (err) {
                this.triggerErr(err);
            }
            return 0;
        }
        ChannelsJoin(e, t) {
            try {
                var p = t || "";
                this.gp.channels.join({ channelId: e, password: p })
                    .then(() => {
                        this.trigger("CallOnJoinSuccess");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnJoinError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsCancelJoin(e) {
            try {
                this.gp.channels.cancelJoin({ channelId: e })
                    .then(() => {
                        this.trigger("CallOnCancelJoinSuccess");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnCancelJoinError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsLeave(e) {
            try {
                this.gp.channels.leave({ channelId: e })
                    .then(() => {
                        this.trigger("CallOnLeaveSuccess");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnLeaveError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsKick(e, t) {
            try {
                this.gp.channels.kick({ channelId: e, playerId: t })
                    .then(() => {
                        this.trigger("CallOnKick");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnKickError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsMuteUnmuteAt(e, t, s) {
            try {
                this.gp.channels.mute({ channelId: e, playerId: t, unmuteAt: s })
                    .then(() => {
                        this.trigger("CallOnMuteSuccess");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnMuteError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsMuteSeconds(e, t, s) {
            try {
                this.gp.channels.mute({ channelId: e, playerId: t, seconds: Number(s) })
                    .then(() => {
                        this.trigger("CallOnMuteSuccess");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnMuteError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsUnMute(e, t) {
            try {
                this.gp.channels.unmute({ channelId: e, playerId: t })
                    .then(() => {
                        this.trigger("CallOnUnmuteSuccess");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnUnmuteError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsSendInvite(e, t) {
            try {
                this.gp.channels.sendInvite({ channelId: e, playerId: t })
                    .then(() => {
                        this.trigger("CallOnSendInvite");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnSendInviteError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsCancelInvite(e, t) {
            try {
                this.gp.channels.cancelInvite({ channelId: e, playerId: t })
                    .then(() => {
                        this.trigger("CallOnCancelInviteSuccess");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnCancelInviteError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsAcceptInvite(e) {
            try {
                this.gp.channels.acceptInvite({ channelId: e })
                    .then(() => {
                        this.trigger("CallOnAcceptInvite");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnAcceptInviteError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsRejectInvite(e) {
            try {
                this.gp.channels.rejectInvite({ channelId: e })
                    .then(() => {
                        this.trigger("CallOnRejectInviteSuccess");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnRejectInviteError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchInvites(e, t) {
            try {
                var l = parseInt(e, 10) || 50;
                var o = parseInt(t, 10) || 0;
                this.gp.channels.fetchInvites({ limit: l, offset: o })
                    .then((e) => {
                        this.trigger("CallOnFetchInvitesCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchInvites", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchInvitesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMoreInvites(e) {
            try {
                var l = parseInt(e, 10) || 50;
                this.gp.channels.fetchMoreInvites({ limit: l })
                    .then((e) => {
                        this.trigger("CallOnFetchMoreInvitesCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchMoreInvites", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMoreInvitesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchChannelInvites(e, t, s) {
            try {
                var l = parseInt(t, 10) || 50;
                var o = parseInt(s, 10) || 0;
                this.gp.channels.fetchChannelInvites({ channelId: e, limit: l, offset: o })
                    .then((e) => {
                        this.trigger("CallOnFetchChannelInvitesCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchChannelInvites", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchChannelInvitesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMoreChannelInvites(e, t) {
            try {
                var l = parseInt(t, 10) || 50;
                this.gp.channels.fetchMoreChannelInvites({ channelId: e, limit: l })
                    .then((e) => {
                        this.trigger("CallOnFetchMoreChannelInvitesCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchMoreChannelInvites", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMoreChannelInvitesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchSentInvites(t, s) {
            try {
                var l = parseInt(t, 10) || 50;
                var o = parseInt(s, 10) || 0;
                this.gp.channels.fetchSentInvites({ limit: l, offset: o })
                    .then((e) => {
                        this.trigger("CallOnFetchSentInvitesCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchSentInvites", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchSentInvitesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMoreSentInvites(t) {
            try {
                var l = parseInt(t, 10) || 50;
                this.gp.channels.fetchMoreSentInvites({ limit: l })
                    .then((e) => {
                        this.trigger("CallOnFetchMoreSentInvitesCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchMoreSentInvites", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMoreSentInvitesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsAcceptJoinRequest(e, t) {
            try {
                this.gp.channels.acceptJoinRequest({ channelId: e, playerId: t })
                    .then(() => {
                        this.trigger("CallOnAcceptJoinRequest");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnAcceptJoinRequestError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsRejectJoinRequest(e, t) {
            try {
                this.gp.channels.rejectJoinRequest({ channelId: e, playerId: t })
                    .then(() => {
                        this.trigger("CallOnRejectJoinRequestSuccess");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnRejectJoinRequestError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchJoinRequests(e, t, s) {
            try {
                var l = parseInt(t, 10) || 50;
                var o = parseInt(s, 10) || 0;
                this.gp.channels.fetchJoinRequests({ channelId: e, limit: l, offset: o })
                    .then((e) => {
                        this.trigger("CallOnFetchJoinRequestsCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchJoinRequests", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchJoinRequestsError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMoreJoinRequests(e, t) {
            try {
                var l = parseInt(t, 10) || 50;
                this.gp.channels.fetchMoreJoinRequests({ channelId: e, limit: l })
                    .then((e) => {
                        this.trigger("CallOnFetchMoreJoinRequestsCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchMoreJoinRequests", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMoreJoinRequestsError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchSentJoinRequests(t, s) {
            try {
                var l = parseInt(t, 10) || 50;
                var o = parseInt(s, 10) || 0;
                this.gp.channels.fetchSentJoinRequests({ limit: l, offset: o })
                    .then((e) => {
                        this.trigger("CallOnFetchSentJoinRequestsCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchSentJoinRequests", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchSentJoinRequestsError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMoreSentJoinRequests(t) {
            try {
                var l = parseInt(t, 10) || 50;
                this.gp.channels.fetchMoreSentJoinRequests({ limit: l })
                    .then((e) => {
                        this.trigger("CallOnFetchMoreSentJoinRequestsCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchMoreSentJoinRequests", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMoreSentJoinRequestsError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsSendMessage(e, t, s) {
            try {
                var tags = s || "";
                this.gp.channels.sendMessage({
                    channelId: e,
                    text: t,
                    tags: tags
                        .split(",")
                        .map((e) => e.trim())
                        .filter((e) => e),
                })
                    .then((e) => {
                        this.trigger("CallOnSendMessage", JSON.stringify(e));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnSendMessageError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsSendPersonalMessage(e, t, s) {
            try {
                var tags = s || "";
                this.gp.channels.sendPersonalMessage({
                    playerId: e,
                    text: t,
                    tags: tags
                        .split(",")
                        .map((e) => e.trim())
                        .filter((e) => e),
                })
                    .then((e) => {
                        this.trigger("CallOnSendPersonalMessage", JSON.stringify(e));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnSendPersonalMessageError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsSendFeedMessage(e, t, s) {
            try {
                var tags = s || "";
                this.gp.channels.sendFeedMessage({
                    playerId: e,
                    text: t,
                    tags: tags
                        .split(",")
                        .map((e) => e.trim())
                        .filter((e) => e),
                })
                    .then((e) => {
                        this.trigger("CallOnSendFeedMessage", JSON.stringify(e));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnSendFeedMessageError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsEditMessage(e, t) {
            try {
                this.gp.channels.editMessage({ messageId: e, text: t })
                    .then((e) => {
                        this.trigger("CallOnEditMessageSuccess", JSON.stringify(e));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnEditMessageError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsDeleteMessage(e) {
            try {
                this.gp.channels.deleteMessage({ messageId: e })
                    .then(() => {
                        this.trigger("CallOnDeleteMessageSuccess");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnDeleteMessageError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMessages(e, t, s, r) {
            try {
                var l = parseInt(s, 10) || 50;
                var o = parseInt(r, 10) || 0;
                var tags = t || "";
                this.gp.channels.fetchMessages({
                        channelId: e,
                        tags: tags.split(",").map((e) => e.trim()).filter((e) => e),
                        limit: l,
                        offset: o,
                    })
                    .then((e) => {
                        this.trigger("CallOnFetchMessagesCanLoadMore", JSON.stringify(e.canLoadMore)),
                            this.trigger("CallOnFetchMessages", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMessagesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchPersonalMessages(e, t, s, r) {
            try {
                var l = parseInt(s, 10) || 50;
                var o = parseInt(r, 10) || 0;
                var tags = t || "";
                this.gp.channels.fetchPersonalMessages({
                        playerId: e,
                        tags: tags.split(",").map((e) => e.trim()).filter((e) => e),
                        limit: l,
                        offset: o,
                    })
                    .then((e) => {
                        this.trigger("CallOnFetchPersonalMessagesCanLoadMore", JSON.stringify(e.canLoadMore)),
                            this.trigger("CallOnFetchPersonalMessages", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchPersonalMessagesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchFeedMessages(e, t, s, r) {
            try {
                var l = parseInt(s, 10) || 50;
                var o = parseInt(r, 10) || 0;
                var tags = t || "";
                this.gp.channels.fetchFeedMessages({
                        playerId: e,
                        tags: tags.split(",").map((e) => e.trim()).filter((e) => e),
                        limit: l,
                        offset: o,
                    })
                    .then((e) => {
                        this.trigger("CallOnFetchFeedMessagesCanLoadMore", JSON.stringify(e.canLoadMore)),
                            this.trigger("CallOnFetchFeedMessages", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchFeedMessagesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMoreMessages(e, t, s) {
            try {
                var l = parseInt(s, 10) || 50;
                var tags = t || "";
                this.gp.channels.fetchMoreMessages({
                        channelId: e,
                        tags: tags.split(",").map((e) => e.trim()).filter((e) => e),
                        limit: l,
                    })
                    .then((e) => {
                        this.trigger("CallOnFetchMoreMessagesCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchMoreMessages", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMoreMessagesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMorePersonalMessages(e, t, s) {
            try {
                var l = parseInt(s, 10) || 50;
                var tags = t || "";
                this.gp.channels.fetchMorePersonalMessages({
                        playerId: e,
                        tags: tags.split(",").map((e) => e.trim()).filter((e) => e),
                        limit: l,
                    })
                    .then((e) => {
                        this.trigger("CallOnFetchMorePersonalMessagesCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchMorePersonalMessages", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMorePersonalMessagesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMoreFeedMessages(e, t, s) {
            try {
                var l = parseInt(s, 10) || 50;
                var tags = t || "";
                this.gp.channels.fetchMoreFeedMessages({
                        playerId: e,
                        tags: tags.split(",").map((e) => e.trim()).filter((e) => e),
                        limit: l,
                    })
                    .then((e) => {
                        this.trigger("CallOnFetchMoreFeedMessagesCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchMoreFeedMessages", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMoreFeedMessagesError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsCreateChannel(e) {
            try {
                var t = JSON.parse(e);
                if ((parseInt(t.template, 10) || 0) > 0) {
                    t.template = Number(t.template);
                }
                else t.template = String(t.template);
                this.gp.channels.createChannel(t)
                    .then((e) => {
                        this.trigger("CallOnCreateChannel", e);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnCreateChannelError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsUpdateChannel(e) {
            try {
                var t = JSON.parse(e);
                this.gp.channels.updateChannel(t)
                    .then((e) => {
                        this.trigger("CallOnUpdateChannel", e);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnUpdateChannelError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsDeleteChannel(e) {
            try {
                this.gp.channels.deleteChannel({ channelId: e })
                    .then(() => {
                        this.trigger("CallOnDeleteChannelSuccess");
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnDeleteChannelError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchChannel(e) {
            try {
                this.gp.channels.fetchChannel({ channelId: e })
                    .then((e) => {
                        this.trigger("CallOnFetchChannel", e);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchChannelError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchChannels(e) {
            try {
                var t = JSON.parse(e);
                this.gp.channels.fetchChannels(t)
                    .then((e) => {
                        this.trigger("CallOnFetchChannelsCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchChannels", e.items);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchChannelsError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMoreChannels(e) {
            try {
                var t = JSON.parse(e);
                this.gp.channels.fetchMoreChannels(t)
                    .then((e) => {
                        this.trigger("CallOnFetchMoreChannelsCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchMoreChannels", e.items);
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMoreChannelsError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMembers(e, s, o, l, f) {
            try {
                var p = {};
                p.channelId = Number(e);
                if (s) p.search = s || "";
                if (o) p.onlyOnline = Boolean(o);
                if (l) p.limit = parseInt(s, 10) || 100;
                if (f) p.offset = parseInt(f, 10) || 0;
                this.gp.channels.fetchMembers(p)
                    .then((e) => {
                        this.trigger("CallOnFetchMembersCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchMembers", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMembersError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        ChannelsFetchMoreMembers(e, s, o, l) {
            try {
                var p = {};
                p.channelId = Number(e);
                if (s) p.search = s || "";
                if (o) p.onlyOnline = Boolean(o);
                if (l) p.limit = parseInt(s, 10) || 100;
                this.gp.channels.fetchMoreMembers(p)
                    .then((e) => {
                        this.trigger("CallOnFetchMoreMembersCanLoadMore", e.canLoadMore),
                            this.trigger("CallOnFetchMoreMembers", JSON.stringify(e.items));
                    })
                    .catch((e) => {
                        console.warn(e), this.trigger("CallOnFetchMoreMembersError", e);
                    });
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        // Native SDK or implementation GamePush
        PlatformCallSDK(is_native, method_name, callback_id, array_parameters = []) {
            try {
                let call_error_event_id = is_native ? "CallPlatformGetNativeSDKError" : "CallPlatformGetSDKError";
                let save_as_var = null;
                let saved_object = null;
                let method_parse = method_name.split("=");
                if (method_parse[1]) {
                    save_as_var = method_parse[0];
                    method_name = method_parse[1];
                }
                method_parse = method_name.split(":");
                if (method_parse[1]) {
                    saved_object = this._nativeData[method_parse[0]];
                    if (!saved_object) {
                        this.trigger(call_error_event_id, `The "${method_parse[0]}" object has not been previously saved!`);
                        return "";
                    }
                    method_name = method_parse[1];
                }
                let path = method_name.split(".");
                let parent_object = saved_object ? saved_object : (is_native ? this.gp.platform.getNativeSDK() : this.gp.platform.getSDK());
                let result_object = parent_object;
                let last_index = path.length - 1
                for (let index = 0; index < path.length; index++) {
                    let item = path[index];
                    if (parent_object[item]) {
                        if (index === last_index) {
                            result_object = parent_object[item];
                        } else {
                            parent_object = parent_object[item];
                        }
                    } else {
                        this.trigger(call_error_event_id, `Field or function "${method_name}" not found!`);
                        return "";
                    }
                }
                switch (typeof result_object) {
                    case "string":
                        return result_object;
                    case "number":
                        return this.toGMS(result_object);
                    case "boolean":
                        return this.toGMS(result_object);
                    case "object":
                        return this.toGMS(result_object);
                    case "function":
                        try {
                            let called_function = result_object.bind(parent_object);
                            let result = (array_parameters && (array_parameters.length > 0)) ? called_function(...array_parameters) : called_function();
                            if ((callback_id && (callback_id != 0) ? String(callback_id) : "").length > 0) {
                                result.then((e) => {
                                    if (save_as_var) {
                                        this._nativeData[save_as_var] = e;
                                    }
                                    this.trigger(callback_id, e);
                                }).catch((err) => {
                                    console.warn(err), this.trigger(callback_id, { error: err });
                                });
                            } else {
                                switch (typeof result) {
                                    case "string":
                                        return result;
                                    case "number":
                                        return this.toGMS(result);
                                    case "boolean":
                                        return this.toGMS(result);
                                    case "object":
                                        return this.toGMS(result);
                                }
                                return "";
                            }
                        } catch (err) {
                            this.trigger(call_error_event_id, err);
                        }
                        return "";
                    default:
                        this.trigger(call_error_event_id, `"${typeof result_object}" type not supported!`);
                }
            }
            catch (err) {
                this.triggerErr(err);
            }
            return "";
        }
        PlatformGetNativeSDK(method_name, callback_id) {
            let parameters = [];
            for (var i = 2; i < arguments.length; i++) {
                try {
                    parameters.push(JSON.parse(arguments[i]));
                } catch (e) {
                    parameters.push(arguments[i]);
                }
            }
            return this.PlatformCallSDK(true, method_name, callback_id, parameters);
        }
        PlatformGetSDK(method_name, callback_id) {
            let parameters = [];
            for (var i = 2; i < arguments.length; i++) {
                try {
                    parameters.push(JSON.parse(arguments[i]));
                } catch (e) {
                    parameters.push(arguments[i]);
                }
            }
            return this.PlatformCallSDK(false, method_name, callback_id, parameters);
        }
    }
    (window.GamePushClass = e), (window.GamePushClass = e);
    //
    class LeaderboardClass {
        order;
        withMe;
        orderBy;
        includeFields;
        displayFields;

        constructor() {
            this.order = "DESC";
            this.withMe = "last";
            this.orderBy = ["score"];
            this.includeFields = [];
            this.displayFields = [];
        }

        setIdOrTag(e) {
            if ((parseInt(e, 10) || 0) > 0) {
                this.id = Number(e);
            }
            else this.tag = String(e);
        }
        setVariant(r) {
            this.variant = r ? r : "";
        }
        setOrder(s) {
            this.order = String(s).toUpperCase() == "ASC" ? "ASC" : "DESC";
        }
        setLimit(i) {
            this.limit = Number(i) > 0 ? Number(i) : 10;
        }
        setWithMe(n) {
            n = String(n).toLowerCase();
            if (n == "none") {
                this.withMe = "none";
            }
            else if (n == "first") {
                this.withMe = "first";
            }
            else {
                this.withMe = "last";
            }
        }
        setOrderBy(o) {
            this.orderBy = (String(o)).split(",").map((e) => e.trim()).filter((e) => e);
        }
        setIncludeFields(a) {
            this.includeFields = (String(a)).split(",").map((e) => e.trim()).filter((e) => e);
        }
        setDisplayFields(l) {
            this.displayFields = (String(l)).split(",").map((e) => e.trim()).filter((e) => e);
        }
        setOverride(g) {
            this.override = !!g;
        }
        addRecord(k, v) {
            if (k && v) {
                if (this.record == null) {
                    this.record = {};
                }
                this.record[k] = Number(v);
            }
        }
    }
    //
    class FileClass {
        setUrl(u) {
            this.url = u;
        }
        setContent(c) {
            this.content = c;
        }
        setTags(e) {
            this.tags = (String(e)).split(",").map((e) => e.trim()).filter((e) => e);
        }
        setAccept(e) {
            this.accept = (String(e)).split(",").map((e) => e.trim()).filter((e) => e);
        }
        setFilename(f) {
            this.filename = f;
        }
        setPlayerId(p) {
            this.playerId = p;
        }
        setOffset(o) {
            var e = Number(o);
            if (e > 0) this.offset = e;
        }
        setLimit(l) {
            var e = Number(l);
            if (e > 0) this.limit = e;
        }
    }
})();