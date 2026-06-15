[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head title="Centr | Registration Complete"]
    [#-- Custom <head> code goes here --]
  [/@helpers.head]
  [@helpers.body]
    [#-- Rebranded auth card: single-column layout --]
    [@helpers.authCard mode="single"]
      <h1 class="authcard-heading">${theme.message('registration-complete-title')}</h1>
      <p class="authcard-description">
        ${theme.message('registration-complete-description')}
      </p>

      <a href="${request.contextPath}/oauth2/authorize" class="btn btn-primary btn-lg w-full flex items-center justify-center gap-2 uppercase font-bold tracking-wide btn-border-custom">
        ${theme.message('registration-complete-sign-in-now')}
      </a>
    [/@helpers.authCard]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]