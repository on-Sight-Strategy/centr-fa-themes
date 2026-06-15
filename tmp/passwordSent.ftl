[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="email" type="java.lang.String" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head title="Centr | Forgot Password Email Sent"]
  [/@helpers.head]
  [@helpers.body]
    [#-- VDB: Password sent confirmation uses mainBoost with full background image --]
    [@helpers.mainBoost title=theme.message('forgot-password-email-sent-title')!"CHECK YOUR EMAIL." subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass="text-white"]
      <p class="font-suisseintl-regular text-white">
        ${theme.message('forgot-password-email-sent', email)}
      </p>
    [/@helpers.mainBoost]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]