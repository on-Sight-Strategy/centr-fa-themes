[#ftl/]
[#-- @ftlvariable name="allowEmailChange" type="boolean" --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="currentUser" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="collectVerificationCode" type="boolean" --]
[#-- @ftlvariable name="email" type="java.lang.String" --]
[#-- @ftlvariable name="showCaptcha" type="boolean" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="verificationId" type="java.lang.String" --]
[#import "../_helpers.ftl" as helpers/]

[#-- If the user attempted "changeEmail" and got validation errors, keep the section visible on reload --]
[#assign showChangeEmail = false/]
[#if request?? && request.getParameter("action")?? && request.getParameter("action") == "changeEmail"]
  [#assign showChangeEmail = true/]
[/#if]
[#if fieldMessages?? && fieldMessages["email"]??]
  [#assign showChangeEmail = true/]
[/#if]

[@helpers.html]
  [@helpers.head title="Centr | Email Verification Required"]
    [@helpers.captchaScripts showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
    [#-- Custom <head> code goes here --]
  [/@helpers.head]
  [@helpers.body]
    [#-- VDB: Email verification uses mainBoost with full background image --]
    [@helpers.mainBoost title="" subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass=""]
      [#-- VDB: Custom title --]
      <div class="w-full text-left mb-6">
        <h2 class="font-degular-black vdb-title-white">${theme.message("email-verification-required-title")!"VERIFICATION REQUIRED"}</h2>
      </div>

      [#-- The user does not have a verified email. Add optional messaging here with instruction to the user. --]
      [#-- Let the user know why they ended up here --]
      <p class="font-suisseintl-regular text-white mt-0 mb-3">
        ${theme.message("{description}email-verification-required")}
      </p>

      [#-- If configured, collect the verification code on this form, this means the user sits here until they verify their email. --]
      [#if collectVerificationCode]
        <form id="verification-required-enter-code" action="${request.contextPath}/email/verification-required" method="POST" class="flex flex-col justify-start w-full gap-y-4">
          [@helpers.oauthHiddenFields/]
          [@helpers.hidden name="action" value="verify"/]
          [@helpers.hidden name="allowEmailChange"/]
          [@helpers.hidden name="collectVerificationCode"/]
          [@helpers.hidden name="email"/]
          [@helpers.hidden name="verificationId"/]
          <fieldset class="flex flex-col justify-start w-full gap-y-2">
            [@helpers.input type="text" name="oneTimeCode" id="otp" autocapitalize="none" autofocus=true autocomplete="one-time-code" autocorrect="off" placeholder="${theme.message('code')}" label=theme.message('code')/]
            [@helpers.captchaBadge showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
          </fieldset>
          [#-- Spacer for fixed footer --]
          <div class="h-24"></div>
          [#-- VDB: Fixed footer button --]
          <div class="vdb-fixed-footer">
            [@helpers.button text=theme.message("submit")/]
          </div>
        </form>
      [#else]
        <p class="font-suisseintl-regular text-white mb-3">${theme.message("{description}email-verification-required-non-interactive")}</p>
      [/#if]

      [#-- Resend a verification email --]
      <form id="verification-required-resend-code" action="${request.contextPath}/email/verification-required" method="POST" class="full">
        [@helpers.oauthHiddenFields/]
        [@helpers.hidden name="action" value="resend"/]
        [@helpers.hidden name="allowEmailChange"/]
        [@helpers.hidden name="collectVerificationCode"/]
        [@helpers.hidden name="email"/]
        <div class="mt-4">
          <button style="background: transparent; border: none; cursor: pointer;" class="link text-white underline">
            ${theme.message("email-verification-required-send-another")}
          </button>
        </div>

        [#-- Toggle link to update email address --]
        [#if allowEmailChange]
          <div class="mt-2">
            <button
              id="toggle-change-email"
              type="button"
              style="background: transparent; border: none; cursor: pointer; ${showChangeEmail?string('display:none;','')}"
              class="link text-white underline"
              aria-controls="change-email-container"
              aria-expanded="${showChangeEmail?string('true','false')}">
              Update my email address
            </button>
          </div>
          <noscript>
            <div class="mt-2">
              <p class="font-suisseintl-regular text-white mb-0">JavaScript is required to update your email address on this page.</p>
            </div>
          </noscript>
        [/#if]
      </form>

      [#-- If configured to allow an email change, present the user with a form. This is intended to assist the user if they mis-typed their email address previously. --]
      [#if allowEmailChange]
        [#-- Hidden-by-default container, shown when link is clicked (or after failed submit) --]
        <div id="change-email-container" style="${showChangeEmail?string('display:block;','display:none;')}">
          [@helpers.dividerOr/]
          <form id="verification-required-change-email" action="${request.contextPath}/email/verification-required" method="POST" class="flex flex-col flex-grow justify-start w-full gap-y-4">
            [@helpers.oauthHiddenFields/]
            [@helpers.hidden name="action" value="changeEmail"/]
            [@helpers.hidden name="allowEmailChange"/]
            [@helpers.hidden name="collectVerificationCode"/]
            <p class="font-suisseintl-regular text-white mb-3">
              Confirm your email address is correct and update it if you mis-typed it during registration. Updating your address will also send you a new email to the new address.
            </p>
            <fieldset class="flex flex-col justify-start w-full gap-y-2">
              [@helpers.input type="text" name="email" id="email" autocapitalize="none" autocomplete="on" autocorrect="off" placeholder="${theme.message('email')}" label="${theme.message('email')}"/]
            </fieldset>
            <div>
              <button type="submit" style="background: transparent; border: none; cursor: pointer;" class="link text-white underline">
                ${theme.message("submit")}
              </button>
            </div>
          </form>
        </div>

        <script>
          (function () {
            function ready(fn) {
              if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', fn);
              else fn();
            }

            ready(function () {
              var toggleBtn = document.getElementById('toggle-change-email');
              var container = document.getElementById('change-email-container');
              if (!toggleBtn || !container) return;

              toggleBtn.addEventListener('click', function () {
                container.style.display = 'block';
                toggleBtn.style.display = 'none';
                toggleBtn.setAttribute('aria-expanded', 'true');

                var emailInput = document.getElementById('email');
                if (emailInput && typeof emailInput.focus === 'function') emailInput.focus();
              });
            });
          })();
        </script>
      [/#if]

    [/@helpers.mainBoost]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]