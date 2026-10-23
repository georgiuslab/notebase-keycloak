<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username'); section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "subtitle">
        <p class="nb-subtitle">
            <#if realm.duplicateEmailsAllowed>
                ${msg("emailInstructionUsername")}
            <#else>
                ${msg("emailInstruction")}
            </#if>
        </p>
    <#elseif section = "form">
        <form id="kc-reset-password-form" class="nb-form" action="${url.loginAction}" method="post" novalidate>
            <div class="nb-field">
                <div class="nb-label-row">
                    <label for="username" class="nb-label"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                </div>
                <input type="text" id="username" name="username" class="nb-input" autofocus autocapitalize="none" spellcheck="false"
                       autocomplete="username" value="${(auth.attemptedUsername!'')}" dir="ltr"
                       aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                       <#if messagesPerField.existsError('username')>aria-describedby="input-error-username"</#if>
                />
                <#if messagesPerField.existsError('username')>
                    <span id="input-error-username" class="nb-error" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('username'))?no_esc}
                    </span>
                </#if>
            </div>

            <div id="kc-form-buttons" class="nb-actions">
                <button class="nb-btn nb-btn--primary nb-btn--block" type="submit">${msg("nbSendResetLink")}</button>
            </div>
        </form>
    <#elseif section = "info">
        <p><a class="nb-back" href="${url.loginUrl}">${msg("backToLogin")}</a></p>
    </#if>
</@layout.registrationLayout>
