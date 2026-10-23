<#import "footer.ftl" as loginFooter>
<#import "theme-resources.ftl" as themeResourceTags>
<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}" lang="${lang}"<#if realm.internationalizationEnabled> dir="${(locale.rtl)?then('rtl','ltr')}"</#if>>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" type="image/png" href="${url.resourcesPath}/img/favicon.png" />
    <link rel="apple-touch-icon" href="${url.resourcesPath}/img/apple-touch-icon.png" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Caveat:wght@500;700&family=Geist:wght@400;500;600&family=Noto+Sans+Georgian:wght@400;500;600&family=Noto+Serif+Georgian:wght@500;600&display=swap">

    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <script type="importmap">
        {
            "imports": {
                "rfc4648": "${url.resourcesCommonPath}/vendor/rfc4648/rfc4648.js"
            }
        }
    </script>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <script type="module">
        <#outputformat "JavaScript">
        import { startSessionPolling } from ${(url.resourcesPath + "/js/authChecker.js")?c};

        startSessionPolling(
            ${url.ssoLoginInOtherTabsUrl?c}
        );
        </#outputformat>
    </script>
    <script type="module">
        document.addEventListener("click", (event) => {
            const link = event.target.closest("a[data-once-link]");

            if (!link) {
                return;
            }

            if (link.getAttribute("aria-disabled") === "true") {
                event.preventDefault();
                return;
            }

            const { disabledClass } = link.dataset;

            if (disabledClass) {
                link.classList.add(...disabledClass.trim().split(/\s+/));
            }

            link.setAttribute("role", "link");
            link.setAttribute("aria-disabled", "true");
        });
    </script>
    <#if authenticationSession??>
        <script type="module">
            <#outputformat "JavaScript">
            import { checkAuthSession } from ${(url.resourcesPath + "/js/authChecker.js")?c};

            checkAuthSession(
                ${authenticationSession.authSessionIdHash?c}
            );
            </#outputformat>
        </script>
    </#if>
</head>

<body class="${properties.kcBodyClass!} ${bodyClass}" data-page-id="login-${pageId}">
<div class="nb-page">

    <aside class="nb-aside">
        <div class="nb-brand">
            <img class="nb-logo" src="${url.resourcesPath}/img/logo.png" width="464" height="273" alt="${msg("nbUniversityName")}">
            <p class="nb-brand-text">
                <span class="nb-brand-name">${msg("nbAppName")}</span>
                <span class="nb-brand-tag">${msg("nbAppTagline")}</span>
            </p>
        </div>

        <#-- Margin doodles: decoration only, hidden from screen readers -->
        <div class="nb-doodles" aria-hidden="true">
            <div class="nb-sticky">
                <span class="nb-tape nb-tape--sticky"></span>
                <p class="nb-sticky-title">${msg("nbNoteTitle")}</p>
                <ul class="nb-sticky-list">
                    <li class="is-done"><svg class="nb-check" viewBox="0 0 18 18"><rect class="nb-box" x="1.5" y="2" width="14" height="14" rx="2"/><path class="nb-ink-path" pathLength="1" d="M4 9.5l3.5 3.5L16.5 1.5"/></svg>${msg("nbNoteItem1")}</li>
                    <li class="is-done"><svg class="nb-check" viewBox="0 0 18 18"><rect class="nb-box" x="1.5" y="2" width="14" height="14" rx="2"/><path class="nb-ink-path" pathLength="1" d="M4 9.5l3.5 3.5L16.5 1.5"/></svg>${msg("nbNoteItem2")}</li>
                    <li class="is-todo"><svg class="nb-check" viewBox="0 0 18 18"><rect class="nb-box" x="1.5" y="2" width="14" height="14" rx="2"/><path class="nb-ink-path" pathLength="1" d="M4 9.5l3.5 3.5L16.5 1.5"/></svg>${msg("nbNoteItem3")}</li>
                </ul>
            </div>

            <svg class="nb-doodle nb-doodle--bulb" viewBox="0 0 80 92">
                <path pathLength="1" d="M40 18c-12 0-21 9-21 20 0 8 4 12 8 17 3 3 4 6 4 10h18c0-4 1-7 4-10 4-5 8-9 8-17 0-11-9-20-21-20z"/>
                <path pathLength="1" d="M32 72h17M33 79h14M37 86h7"/>
                <path pathLength="1" d="M40 64V48m-6-7 6 7 6-7"/>
                <path pathLength="1" d="M40 3v8M12 14l6 6M68 14l-6 6M3 40h8M69 40h8"/>
            </svg>

            <p class="nb-doodle nb-formula"><span>a² + b² = c²</span><span>π ≈ 3.14</span></p>

            <svg class="nb-doodle nb-doodle--star" viewBox="0 0 44 44">
                <path pathLength="1" d="M22 3l5.5 12.5L41 17l-10 9 3 14-12-7-12 7 3-14-10-9 13.5-1.5z"/>
            </svg>

            <#-- points from the last to-do on the sticky note over to the form -->
            <svg class="nb-doodle nb-doodle--arrow" viewBox="0 0 200 120">
                <path pathLength="1" d="M8 4c-4 34 10 66 46 84 36 18 86 16 136 0"/>
                <path pathLength="1" d="M174 76l17 12-15 14"/>
            </svg>
        </div>

        <figure class="nb-motto">
            <blockquote class="nb-motto-text">${msg("nbMottoLine1")} <br><mark class="nb-highlight">${msg("nbMottoLine2")}</mark></blockquote>
            <figcaption class="nb-motto-source"><span lang="la">Nosce te ipsum</span></figcaption>
        </figure>

        <p class="nb-aside-note">${msg("nbAsideNote")}</p>
    </aside>

    <main class="nb-main">
        <#if realm.internationalizationEnabled && locale.supported?size gt 1>
            <nav class="nb-topbar" aria-label="${msg("languages")}">
                <ul class="nb-locale">
                    <#list locale.supported as l>
                        <li><a href="${l.url}" lang="${l.languageTag}"<#if l.languageTag == locale.currentLanguageTag> aria-current="true"</#if>>${l.label}</a></li>
                    </#list>
                </ul>
            </nav>
        </#if>

        <div class="nb-sheet">
            <div class="nb-card">
                <span class="nb-tape nb-tape--left" aria-hidden="true"></span>
                <span class="nb-tape nb-tape--right" aria-hidden="true"></span>
                <header class="nb-head">
                    <h1 class="nb-title"><span class="nb-title-text"><#nested "header"><svg class="nb-underline" viewBox="0 0 200 14" preserveAspectRatio="none" aria-hidden="true"><path pathLength="1" d="M3 9c30-5 70-7 110-5 30 1.5 55 4 84-1"/></svg></span></h1>
                    <#nested "subtitle">
                    <#if auth?has_content && auth.showUsername() && !auth.showResetCredentials()>
                        <#nested "show-username">
                        <div id="kc-username" class="nb-user">
                            <span class="nb-user-name" id="kc-attempted-username" dir="ltr">${auth.attemptedUsername}</span>
                            <a id="reset-login" href="${url.loginRestartFlowUrl}" aria-label="${msg("restartLoginTooltip")}">${msg("nbChangeUser")}</a>
                        </div>
                    </#if>
                    <#if displayRequiredFields>
                        <p class="nb-required-note"><span class="required" aria-hidden="true">*</span> ${msg("requiredFields")}</p>
                    </#if>
                </header>

                <div id="kc-content">
                    <#-- App-initiated actions should not see warning messages about the need to complete the action during login. -->
                    <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                        <div class="nb-alert alert-${message.type}" role="<#if message.type = 'error'>alert<#else>status</#if>">
                            <span class="nb-alert-text">${kcSanitize(message.summary)?no_esc}</span>
                        </div>
                    </#if>

                    <#nested "form">

                    <#if auth?has_content && auth.showTryAnotherWayLink()>
                        <form id="kc-select-try-another-way-form" class="nb-aside-form" action="${url.loginAction}" method="post">
                            <input type="hidden" name="tryAnotherWay" value="on"/>
                            <button type="submit" class="nb-link-btn" id="try-another-way">${msg("doTryAnotherWay")}</button>
                        </form>
                    </#if>

                    <#if switchOrganizationEnabled?? && switchOrganizationEnabled>
                        <form id="kc-switch-organization-form" class="nb-aside-form" action="${url.loginAction}" method="post">
                            <input type="hidden" name="switchOrganization" value="true"/>
                            <button type="submit" class="nb-link-btn" id="switch-organization">${msg("doSwitchOrganization")}</button>
                        </form>
                    </#if>

                    <#nested "socialProviders">

                    <#if displayInfo>
                        <div id="kc-info" class="nb-info">
                            <#nested "info">
                        </div>
                    </#if>
                </div>

                <@loginFooter.content/>
            </div>
        </div>

        <footer class="nb-foot">
            <span>${msg("nbUniversityName")}</span>
            <span class="nb-foot-year">© ${.now?string('yyyy')}</span>
        </footer>
    </main>

</div>
<script>
    // Tick the last to-do on the sticky note when a form is sent
    document.addEventListener("submit", function () {
        var todo = document.querySelector(".nb-sticky .is-todo");
        if (todo) todo.classList.add("is-done");
    });
</script>
</body>
</html>
</#macro>
