[#ftl/]
[#-- @ftlvariable name="activationComplete" type="boolean" --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="currentUser" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="devicePendingIdPLink" type="io.fusionauth.domain.provider.PendingIdPLink" --]
[#-- @ftlvariable name="theme" type="io.fusionauth.domain.Theme" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="userCodeLength" type="int" --]
[#-- @ftlvariable name="version" type="java.lang.String" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head title=theme.message("device-title")]
    <script src="${request.contextPath}/js/oauth2/Device.js?version=${version}"></script>
    <script>
      Prime.Document.onReady(function() {
        var form = Prime.Document.queryById('device-form');
        new FusionAuth.OAuth2.Device(form, ${userCodeLength});

        /**
         * Auto-fill user code from URL parameter.
         * When the user scans a QR code with verification_uri_complete,
         * the URL will contain the user_code parameter which we auto-fill.
         */
        (function() {
          try {
            var urlParams = new URLSearchParams(window.location.search);
            var userCode = urlParams.get('user_code');

            if (userCode) {
              // Remove any dashes or spaces from the code
              var cleanCode = userCode.replace(/[-\s]/g, '').toUpperCase();

              // Fill each input field with a character from the code
              for (var i = 0; i < cleanCode.length && i < ${userCodeLength}; i++) {
                var input = document.getElementById('user_code_' + i);
                if (input) {
                  input.value = cleanCode[i];
                }
              }

              // Update the hidden field with the full code
              var hiddenField = document.getElementById('interactive_user_code');
              if (hiddenField) {
                hiddenField.value = cleanCode;
              }

              // Focus on the submit button since code is already filled
              var submitBtn = form.querySelector('button[type="submit"]');
              if (submitBtn) {
                submitBtn.focus();
              }
            }
          } catch (e) {
            // Silently fail - user can still enter code manually
          }
        })();
      });
    </script>
    <style>
      [#-- VDB: Device code input styling --]
      #user_code_container {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 8px;
      }

      #user_code_container > div {
        display: flex;
        align-items: center;
      }

      #user_code_container input[type="text"] {
        font-size: 28px;
        padding: 12px 0;
        text-align: center;
        width: 44px;
        height: 56px;
        border: 2px solid rgba(255, 255, 255, 0.3);
        border-radius: 8px;
        background: rgba(255, 255, 255, 0.1);
        color: white;
        font-family: 'SuisseIntl-SemiBold', sans-serif;
        text-transform: uppercase;
      }

      #user_code_container input[type="text"]:focus {
        outline: none;
        border-color: var(--vdb-brand-color, #FFDD00);
        background: rgba(255, 255, 255, 0.15);
      }

      #user_code_container input[type="text"] + span {
        font-size: 32px;
        color: rgba(255, 255, 255, 0.5);
        margin: 0 4px;
      }
    </style>
  [/@helpers.head]
  [@helpers.body]
    [#-- VDB: Device login uses mainBoost with full background image --]
    [@helpers.mainBoost title="" subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass=""]

      [#-- VDB: Custom title --]
      <div class="w-full text-left mb-6">
        <h2 class="font-degular-black vdb-title-white">${theme.message("device-title-line1")!"CONNECT YOUR"}</h2>
        <h2 class="font-degular-black vdb-title-brand">${theme.message("device-title-line2")!"DEVICE"}</h2>
      </div>

      [#setting url_escaping_charset='UTF-8']

      [#-- If a pending link will cause us to exceed our linking limit, the next step will be to logout. --]
      [#assign logoutToContinue = devicePendingIdPLink?? && devicePendingIdPLink.linkLimitExceeded /]

      [#-- During a linking work flow, optionally indicate to the user which IdP is being linked. --]
      [#if devicePendingIdPLink?? && !logoutToContinue]
        <p class="mt-0 mb-6 font-suisseintl-regular text-white/80">
          ${theme.message('pending-device-link', devicePendingIdPLink.identityProviderName)}
        </p>
      [/#if]

      [#-- If there is an active SSO session, give the user the option to logout of the SSO session
           that does not belong to them. If a link count has been exceeded provide a logout button.
      --]
      [#if currentUser??]
        <div class="w-full mb-6">
          [#assign currentLoginId = currentUser.login /]
          [#if logoutToContinue]
            [#-- The user must logout before continuing because the currently logged in user has exceeded the number of allowed links to this IdP. --]
            <p class="font-suisseintl-regular text-white/80 mb-4">${theme.message('device-link-count-exceeded-pending-logout', currentLoginId, devicePendingIdPLink.identityProviderName)}</p>
            <p class="font-suisseintl-regular text-white/80 mb-6">${theme.message("device-link-count-exceeded-next-step")}</p>
            [@helpers.logoutLink redirectURI="/oauth2/device"]
              <button type="button" class="w-full vdb-btn-primary rounded-lg h-12 font-suisseintl-semibold">
                ${theme.message("logout-and-continue")}
              </button>
            [/@helpers.logoutLink]
          [#else]
            <p class="font-suisseintl-regular text-white/80 mb-4">${theme.message('device-logged-in-as-not-you', currentLoginId)}</p>
            [@helpers.logoutLink redirectURI="/oauth2/device"]
              <button type="button" class="w-full vdb-btn-secondary rounded-lg h-12 font-suisseintl-semibold text-white border border-white/30">
                ${theme.message("logout-and-continue")}
              </button>
            [/@helpers.logoutLink]
          [/#if]
        </div>
      [/#if]

      [#-- Not showing the form if the user must logout first. --]
      [#if !logoutToContinue]
        <form action="${request.contextPath}/oauth2/device" method="POST" id="device-form" class="w-full">
          [@helpers.oauthHiddenFields/]

          [#-- Description --]
          <p class="mt-0 mb-6 font-suisseintl-regular text-white/80">
            ${theme.message("{description}device-form")!"Enter the code shown on your device to connect it to your Centr account."}
          </p>

          <fieldset class="space-y-6">
            <div id="user_code_container">
              [#list 0..<userCodeLength as i]
                <div>
                  <label for="user_code_${i}" class="sr-only">Code digit ${i + 1}</label>
                  <input type="text" id="user_code_${i}" maxlength="1" [#if i == 0]autofocus[/#if] autocomplete="off"/>
                  [#if i == (userCodeLength/2)?floor - 1]<span>-</span>[/#if]
                </div>
              [/#list]
              <input type="hidden" name="interactive_user_code" id="interactive_user_code" />
            </div>

            [#-- Error messages --]
            [@helpers.errors field="user_code" /]

            [#-- Spacer for fixed footer --]
            <div class="h-24"></div>
          </fieldset>

          [#-- VDB: Fixed footer button --]
          <div class="vdb-fixed-footer">
            [@helpers.button text=theme.message('submit')/]
          </div>
        </form>
      [/#if]

    [/@helpers.mainBoost]

    [@helpers.footer]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]