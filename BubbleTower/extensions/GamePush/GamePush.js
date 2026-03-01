(function(d) {
	if (window.gp == null) {
		console.log('GamePush SDK start load script');
		if (GamePush_Project_ID === null) {
			console.error('GamePush Project ID not found!');
		}
		else if (GamePush_Public_token === null) {
			console.error('GamePush Public token not found!');
		}
		else {
			let t = d.getElementsByTagName('script')[0];
			let s = d.createElement('script');
			s.src = '//gs.eponesh.com/sdk/game-score.js?projectId=' + GamePush_Project_ID + '&publicToken='
				+ GamePush_Public_token + '&callback=onGPInit';
			s.async = true;
			t.parentNode.insertBefore(s, t);
		}
	}
})(document);

var GamePushGMS = {
	_mapTypeDesc: "GamePush",
	_allowConsoleDebug: false,
	gp: null,
	sdkReady: false,

	/**
	 * Translating the object into a string
	 * @param e
	 * @returns {string}
	 */
	toString: function (e) {
		try {
			switch (typeof e) {
				case "number":
					return String(e);
				case "boolean":
					return String(e ? 1 : 0);
				case "string":
					return e;
			}
			return JSON.stringify(e);
		} catch (error) {
			return JSON.stringify({error: error});
		}
	},

	/**
	 * Output data to the browser console (only if debugging is enabled)
	 * @param {String} message
	 * @param {any} data
	 * @returns {Number} 1
	 */
	browserConsoleLog: function (message, data = null) {
		let self = GamePushGMS;
		if (self._allowConsoleDebug) {
			if (data) {
				message += " | " + self.toString(data);
			}
			console.log(message);
		}
		return 1;
	},

	/**
	 * Page reload function
	 * @returns {Number} 1
	 */
	pageReload: function() {
		GamePushGMS.browserConsoleLog( "Reloading the browser page");
		setTimeout(() => {
			window.location.reload();
		}, 0);
		return 1;
	},

	/**
	 * Get the SDK initialization status
	 * @returns {Number} 1 0
	 */
	getInitStatus: function() {
		let self = GamePushGMS;
		if (self.gp != null) {
			if ((self.gp) && (self.gp.sdkReady)) {
				self.browserConsoleLog("SDK is Initiated");
				return 1;
			}
		}
		self.browserConsoleLog("SDK not Initiated");
		return 0;
	},

	/**
	 * Allow log output to the browser console
	 * @param debugStatus {Number} Enable (1) / Disable (0)
	 * @returns {Number} Enabled (1) / Disabled (0)
	 */
	setDebugMode: function(debugStatus) {
		let self = GamePushGMS;
		if (debugStatus > 0) {
			if (!self._allowConsoleDebug) {
				console.log("Browser debug mode enabled");
				self._allowConsoleDebug = true;
			}
		}
		else {
			if (self._allowConsoleDebug) {
				console.log("Browser debug mode disabled");
				self._allowConsoleDebug = false;
			}
		}
		return (self._allowConsoleDebug ? 1 : 0);
	},

	/**
	 * Get is allow log output to the browser console
	 * @returns {Number} Enabled (1) / Disabled (0)
	 */
	getDebugMode: function() {
		return (GamePushGMS._allowConsoleDebug ? 1 : 0);
	},

	/**
	 * Get Browser priority language
	 * @returns {String}
	 */
	getBrowserLang: function() {
		let brLang = navigator.language || navigator.userLanguage;
		GamePushGMS.browserConsoleLog( "Browser priority language: " + brLang);
		return brLang;
	},

	/**
	 * Get Browser priority language
	 * @returns {String}
	 */
	getBrowserEnvironment: function () {
		let self = GamePushGMS;
		let env = {};
		try {
			// URL
			let params = {};

			try {
				let sp = new URLSearchParams(window.location.search);
				for (let [key, raw] of sp.entries()) {
					let value = raw.trim();

					if (value === "") {
						params[key] = null;
					}
					else if (value === "true" || value === "false") {
						params[key] = value === "true";
					}
					else if (/^-?\d+(\.\d+)?$/.test(value)) {
						params[key] = Number(value);
					}
					else {
						params[key] = value;
					}
				}
			} catch (e) { }

			env.url = {
				href: window.location.href,
				origin: window.location.origin,
				path: window.location.pathname,
				hash: window.location.hash,
				params
			};

			// Embed / Sandbox
			let isEmbedded = false;
			let isSandboxed = "unknown";

			try {
				isEmbedded = window.self !== window.top;
			}
			catch (e) {
				isEmbedded = true;
				isSandboxed = true;
			}

			try {
				if (window.frameElement && window.frameElement.hasAttribute("sandbox")) {
					isSandboxed = true;
				}
				else if (isSandboxed !== true) {
					isSandboxed = false;
				}
			}
			catch (e) {
				isSandboxed = true;
			}

			env.embed = {
				isEmbedded,
				isSandboxed,
				referrer: document.referrer || null
			};

			// Viewport
			env.viewport = {
				width: window.innerWidth,
				height: window.innerHeight,
				dpr: window.devicePixelRatio || 1
			};

			// Feature detection
			let touch = false;
			try {
				touch = ("ontouchstart" in window) || navigator.maxTouchPoints > 0;
			} catch (e) { }

			let coarsePointer = false;
			let finePointer = false;
			try {
				coarsePointer = window.matchMedia("(pointer: coarse)").matches;
				finePointer = window.matchMedia("(pointer: fine)").matches;
			} catch (e) { }

			env.features = {
				touch,
				coarsePointer,
				finePointer
			};

			// Time
			env.time = {
				timezoneOffset: new Date().getTimezoneOffset(),
				now: Date.now()
			};

		}
		catch (err) {
			console.error(err);
		}

		self.browserConsoleLog(env);
		return self.toString(env);
	},

}

/**
 * Waiting for the SDK to be ready from GameMaker.
 * @returns {number}
 */
function GP_SDK_Init() {
	try {
		if (GamePushGMS.getInitStatus) {
			GamePushGMS.sdkReady = true;
		}
		else {
			setTimeout(GP_SDK_Init, 200);
		}
	} catch (err) {
		console.error(err);
	}
	return 1;
}

/**
 * Copy text to the clipboard in modern browsers
 * https://github.com/sindresorhus/copy-text-to-clipboard
 * @param text
 * @param target
 * @returns {number}
 */
function copyTextToClipboard(text, { target = document.body } = {}) {
	const element = document.createElement('textarea');
	const previouslyFocusedElement = document.activeElement;

	element.value = text;

	// Prevent keyboard from showing on mobile
	element.setAttribute('readonly', '');

	// Reset all inherited styles to prevent CSS interference
	element.style.all = 'unset';

	// Apply minimal required styles
	element.style.contain = 'strict';
	element.style.position = 'absolute';
	element.style.left = '-9999px';
	element.style.width = '2em';
	element.style.height = '2em';
	element.style.padding = '0';
	element.style.border = 'none';
	element.style.outline = 'none';
	element.style.boxShadow = 'none';
	element.style.background = 'transparent';
	element.style.fontSize = '12pt'; // Prevent zooming on iOS
	element.style.whiteSpace = 'pre'; // Preserve whitespace (tabs, spaces, newlines)

	const selection = document.getSelection();
	const originalRange = selection.rangeCount > 0 && selection.getRangeAt(0);

	target.append(element);
	element.select();

	// Explicit selection workaround for iOS
	element.selectionStart = 0;
	element.selectionEnd = text.length;

	let isSuccess = false;
	try {
		isSuccess = document.execCommand('copy');
	} catch {}

	element.remove();

	if (originalRange) {
		selection.removeAllRanges();
		selection.addRange(originalRange);
	}

	// Get the focus back on the previously focused element, if any
	if (previouslyFocusedElement) {
		previouslyFocusedElement.focus();
	}

	return (isSuccess ? 1 : 0);
}

/**
 * Starting is GamePush ready
 * @param gp
 * @returns {Promise<void>}
 */
window.onGPInit = async (gp) => {
	try {
		if (gp) window.gp = gp;
		if (window.gp) {
			GamePushGMS.gp = new GamePushClass(window.gp);
			window.gp = null;
			// Show Ads
			try {
				if (typeof GamePush_Send_game_start === 'boolean' && GamePush_Send_game_start === true) {
					GamePushGMS.gp.GameStart();
				}
				if (typeof GamePush_Show_preloader_ad === 'boolean' && GamePush_Show_preloader_ad === true) {
					GamePushGMS.gp.AdsShowPreloader();
				}
				if (typeof GamePush_Show_sticky_ad === 'boolean' && GamePush_Show_sticky_ad === true) {
					GamePushGMS.gp.AdsShowSticky();
				}
			} catch (err) {
				console.error(err);
			}
		}
	} catch (err) {
		console.error(err);
	}
};

/**
 * Waiting for the Class to be ready
 */
initWait = function() {
	setTimeout(() => {
		let is_defined = false;
		try {
			if (typeof GamePushClass !== 'undefined') {
				is_defined = true;
				window.onGPInit();
			}
		}
		catch (err) {
			console.error(err);
		}
		if (!is_defined) {
			initWait();
		}
	}, 100);
}
initWait();