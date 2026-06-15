[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head]
  [/@helpers.head]
  [@helpers.body]
    [#-- VDB: Phone complete uses mainBoost with full background image --]
    [@helpers.mainBoost title="" subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass=""]

      [#-- VDB: Custom title --]
      <div class="w-full text-left mb-6">
        <h2 class="font-degular-black vdb-title-white">${theme.message("phone-verification-complete-title-line1")!"VERIFICATION"}</h2>
        <h2 class="font-degular-black vdb-title-brand">${theme.message("phone-verification-complete-title-line2")!"COMPLETE"}</h2>
      </div>

      [#-- Success message --]
      <div class="w-full">
        <p class="font-suisseintl-regular text-white/80 text-lg">
          ${theme.message("phone-verification-complete")}
        </p>
      </div>

    [/@helpers.mainBoost]

    [@helpers.footer]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]