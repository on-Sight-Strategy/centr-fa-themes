[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="showCaptcha" type="boolean" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="verificationId" type="java.lang.String" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head]
  [/@helpers.head]
  [@helpers.body]
    [#-- VDB: Phone verification uses mainBoost with full background image --]
    [@helpers.mainBoost title="" subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass=""]

      [#-- VDB: Custom title --]
      <div class="w-full text-left mb-6">
        <h2 class="font-degular-black vdb-title-white">${theme.message("phone-verification-form-title-line1")!"VERIFY YOUR"}</h2>
        <h2 class="font-degular-black vdb-title-brand">${theme.message("phone-verification-form-title-line2")!"PHONE NUMBER"}</h2>
      </div>

      [#-- Description --]
      <p class="mt-0 mb-6 font-suisseintl-regular text-white/80">
        ${theme.message("phone-verification-form")}
      </p>

      <form action="${request.contextPath}/phone/verify" method="POST" class="w-full">
        [@helpers.hidden name="client_id"/]
        [@helpers.hidden name="tenantId"/]

        <fieldset class="space-y-6">
          [@helpers.input type="tel" name="phoneNumber" id="phone" autocapitalize="none" autofocus=true autocomplete="tel" autocorrect="off" label=theme.message('phone') placeholder="" required=true/]

          [#-- Spacer for fixed footer --]
          <div class="h-24"></div>
        </fieldset>

        [#-- VDB: Fixed footer button --]
        <div class="vdb-fixed-footer">
          [@helpers.button text=theme.message("submit")/]
        </div>
      </form>

    [/@helpers.mainBoost]

    [@helpers.footer]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]