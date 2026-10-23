<#import "template.ftl" as layout>
<#import "user-profile-commons.ftl" as userProfileCommons>
<#import "register-commons.ftl" as registerCommons>
<@layout.registrationLayout bodyClass="nb--wide" displayMessage=messagesPerField.exists('global') displayRequiredFields=true displayInfo=true; section>
    <#if section = "header">
        <#if messageHeader??>
            ${kcSanitize(msg("${messageHeader}"))?no_esc}
        <#else>
            ${msg("registerTitle")}
        </#if>
    <#elseif section = "subtitle">
        <p class="nb-subtitle">${msg("nbRegisterSubtitle")}</p>
    <#elseif section = "form">
        <form id="kc-register-form" class="nb-form nb-form--grid" action="${url.registrationAction}" method="post" novalidate>

            <@userProfileCommons.userProfileFormFields; callback, attribute>
                <#if callback = "afterField">
                <#-- render password fields just under the username or email (if used as username) -->
                    <#if passwordRequired?? && (attribute.name == 'username' || (attribute.name == 'email' && realm.registrationEmailAsUsername))>
                        <div class="nb-field">
                            <div class="nb-label-row">
                                <label for="password" class="nb-label">${msg("password")}</label>
                                <span class="required" aria-hidden="true">*</span>
                            </div>
                            <div class="nb-input-wrap">
                                <div class="nb-input-group" dir="ltr">
                                    <input type="password" id="password" class="nb-input" name="password"
                                           autocomplete="new-password"
                                           aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                                    />
                                    <button class="nb-reveal" type="button" aria-label="${msg('showPassword')}"
                                            aria-controls="password" data-password-toggle
                                            data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                                            data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                                        <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
                                    </button>
                                </div>
                                <#if messagesPerField.existsError('password')>
                                    <span id="input-error-password" class="nb-error" aria-live="polite">
                                        ${kcSanitize(messagesPerField.get('password'))?no_esc}
                                    </span>
                                </#if>
                            </div>
                        </div>

                        <div class="nb-field">
                            <div class="nb-label-row">
                                <label for="password-confirm" class="nb-label">${msg("passwordConfirm")}</label>
                                <span class="required" aria-hidden="true">*</span>
                            </div>
                            <div class="nb-input-wrap">
                                <div class="nb-input-group" dir="ltr">
                                    <input type="password" id="password-confirm" class="nb-input"
                                           name="password-confirm" autocomplete="new-password"
                                           aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                                    />
                                    <button class="nb-reveal" type="button" aria-label="${msg('showPassword')}"
                                            aria-controls="password-confirm" data-password-toggle
                                            data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                                            data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                                        <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
                                    </button>
                                </div>
                                <#if messagesPerField.existsError('password-confirm')>
                                    <span id="input-error-password-confirm" class="nb-error" aria-live="polite">
                                        ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                                    </span>
                                </#if>
                            </div>
                        </div>
                    </#if>
                </#if>
            </@userProfileCommons.userProfileFormFields>

            <@registerCommons.termsAcceptance/>

            <#if recaptchaRequired?? && (recaptchaVisible!false)>
                <div class="nb-field">
                    <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}" data-action="${recaptchaAction}"></div>
                </div>
            </#if>

            <#if recaptchaRequired?? && !(recaptchaVisible!false)>
                <script>
                    function onSubmitRecaptcha(token) {
                        document.getElementById("kc-register-form").requestSubmit();
                    }
                </script>
                <div id="kc-form-buttons" class="nb-actions">
                    <button class="nb-btn nb-btn--primary nb-btn--block g-recaptcha"
                        data-sitekey="${recaptchaSiteKey}" data-callback='onSubmitRecaptcha' data-action='${recaptchaAction}' type="submit">
                        ${msg("doRegister")}
                    </button>
                </div>
            <#else>
                <div id="kc-form-buttons" class="nb-actions">
                    <button class="nb-btn nb-btn--primary nb-btn--block" type="submit">${msg("doRegister")}</button>
                </div>
            </#if>
        </form>
        <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
    <#elseif section = "info">
        <p>${msg("nbHaveAccount")} <a href="${url.loginUrl}">${msg("doLogIn")}</a></p>
    </#if>
</@layout.registrationLayout>
