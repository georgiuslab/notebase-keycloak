<#import "template.ftl" as layout>
<#import "passkeys.ftl" as passkeys>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        ${msg("loginAccountTitle")}
    <#elseif section = "subtitle">
        <p class="nb-subtitle">${msg("nbLoginSubtitle")}</p>
    <#elseif section = "form">
        <#if realm.password>
            <form id="kc-form-login" class="nb-form" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post" novalidate>
                <#if !usernameHidden??>
                    <div class="nb-field">
                        <div class="nb-label-row">
                            <label for="username" class="nb-label"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                        </div>
                        <input id="username" class="nb-input" name="username" value="${(login.username!'')}" type="text"
                               autofocus autocapitalize="none" spellcheck="false"
                               autocomplete="${(enableWebAuthnConditionalUI?has_content)?then('username webauthn', 'username')}"
                               aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                               <#if messagesPerField.existsError('username','password')>aria-describedby="input-error"</#if>
                               dir="ltr"
                        />
                    </div>
                </#if>

                <div class="nb-field">
                    <div class="nb-label-row">
                        <label for="password" class="nb-label">${msg("password")}</label>
                        <#if realm.resetPasswordAllowed>
                            <a class="nb-label-link" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
                        </#if>
                    </div>
                    <div class="nb-input-group" dir="ltr">
                        <input id="password" class="nb-input" name="password" type="password" autocomplete="current-password"
                               <#if usernameHidden??>autofocus</#if>
                               aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                               <#if messagesPerField.existsError('username','password')>aria-describedby="input-error"</#if>
                        />
                        <button class="nb-reveal" type="button" aria-label="${msg("showPassword")}"
                                aria-controls="password" data-password-toggle
                                data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                                data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                            <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
                        </button>
                    </div>
                    <#if messagesPerField.existsError('username','password')>
                        <span id="input-error" class="nb-error" aria-live="polite">
                            ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                        </span>
                    </#if>
                </div>

                <#if realm.rememberMe && !usernameHidden??>
                    <div class="nb-field nb-field--tight">
                        <label class="nb-choice">
                            <input class="nb-choice-input" id="rememberMe" name="rememberMe" type="checkbox"<#if login.rememberMe??> checked</#if>>
                            <span class="nb-choice-label">${msg("rememberMe")}</span>
                        </label>
                    </div>
                </#if>

                <div id="kc-form-buttons" class="nb-actions">
                    <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                    <button class="nb-btn nb-btn--primary nb-btn--block" name="login" id="kc-login" type="submit">${msg("doLogIn")}</button>
                </div>
            </form>
        </#if>
        <@passkeys.conditionalUIData />
        <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
    <#elseif section = "info">
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <p id="kc-registration">${msg("noAccount")} <a href="${url.registrationUrl}">${msg("doRegister")}</a></p>
        </#if>
    <#elseif section = "socialProviders">
        <#if realm.password && social?? && social.providers?has_content>
            <div id="kc-social-providers" class="nb-social">
                <p class="nb-divider"><span>${msg("identity-provider-login-label")}</span></p>
                <ul class="nb-social-list">
                    <#list social.providers as p>
                        <li>
                            <a data-once-link data-disabled-class="nb-btn--disabled" id="social-${p.alias}"
                               class="nb-btn nb-btn--secondary nb-btn--block" href="${p.loginUrl}">
                                <span class="nb-social-name">${p.displayName!}</span>
                            </a>
                        </li>
                    </#list>
                </ul>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>
