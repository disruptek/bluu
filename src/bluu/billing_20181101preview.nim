
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BillingManagementClient
## version: 2018-11-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Billing client provides access to billing resources for Azure subscriptions.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_574467 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574467](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574467): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "billing"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BillingAccountsList_574689 = ref object of OpenApiRestCall_574467
proc url_BillingAccountsList_574691(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BillingAccountsList_574690(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists all billing accounts for which a user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections and billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574851 = query.getOrDefault("api-version")
  valid_574851 = validateParameter(valid_574851, JString, required = true,
                                 default = nil)
  if valid_574851 != nil:
    section.add "api-version", valid_574851
  var valid_574852 = query.getOrDefault("$expand")
  valid_574852 = validateParameter(valid_574852, JString, required = false,
                                 default = nil)
  if valid_574852 != nil:
    section.add "$expand", valid_574852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574875: Call_BillingAccountsList_574689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all billing accounts for which a user has access.
  ## 
  let valid = call_574875.validator(path, query, header, formData, body)
  let scheme = call_574875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574875.url(scheme.get, call_574875.host, call_574875.base,
                         call_574875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574875, url, valid)

proc call*(call_574946: Call_BillingAccountsList_574689; apiVersion: string;
          Expand: string = ""): Recallable =
  ## billingAccountsList
  ## Lists all billing accounts for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections and billingProfiles.
  var query_574947 = newJObject()
  add(query_574947, "api-version", newJString(apiVersion))
  add(query_574947, "$expand", newJString(Expand))
  result = call_574946.call(nil, query_574947, nil, nil, nil)

var billingAccountsList* = Call_BillingAccountsList_574689(
    name: "billingAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts",
    validator: validate_BillingAccountsList_574690, base: "",
    url: url_BillingAccountsList_574691, schemes: {Scheme.Https})
type
  Call_BillingAccountsGet_574987 = ref object of OpenApiRestCall_574467
proc url_BillingAccountsGet_574989(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingAccountsGet_574988(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the billing account by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575004 = path.getOrDefault("billingAccountName")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "billingAccountName", valid_575004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections and billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575005 = query.getOrDefault("api-version")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "api-version", valid_575005
  var valid_575006 = query.getOrDefault("$expand")
  valid_575006 = validateParameter(valid_575006, JString, required = false,
                                 default = nil)
  if valid_575006 != nil:
    section.add "$expand", valid_575006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575007: Call_BillingAccountsGet_574987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the billing account by id.
  ## 
  let valid = call_575007.validator(path, query, header, formData, body)
  let scheme = call_575007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575007.url(scheme.get, call_575007.host, call_575007.base,
                         call_575007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575007, url, valid)

proc call*(call_575008: Call_BillingAccountsGet_574987; apiVersion: string;
          billingAccountName: string; Expand: string = ""): Recallable =
  ## billingAccountsGet
  ## Get the billing account by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections and billingProfiles.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575009 = newJObject()
  var query_575010 = newJObject()
  add(query_575010, "api-version", newJString(apiVersion))
  add(query_575010, "$expand", newJString(Expand))
  add(path_575009, "billingAccountName", newJString(billingAccountName))
  result = call_575008.call(path_575009, query_575010, nil, nil, nil)

var billingAccountsGet* = Call_BillingAccountsGet_574987(
    name: "billingAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}",
    validator: validate_BillingAccountsGet_574988, base: "",
    url: url_BillingAccountsGet_574989, schemes: {Scheme.Https})
type
  Call_BillingAccountsUpdate_575011 = ref object of OpenApiRestCall_574467
proc url_BillingAccountsUpdate_575013(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingAccountsUpdate_575012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575031 = path.getOrDefault("billingAccountName")
  valid_575031 = validateParameter(valid_575031, JString, required = true,
                                 default = nil)
  if valid_575031 != nil:
    section.add "billingAccountName", valid_575031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575032 = query.getOrDefault("api-version")
  valid_575032 = validateParameter(valid_575032, JString, required = true,
                                 default = nil)
  if valid_575032 != nil:
    section.add "api-version", valid_575032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update billing account operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575034: Call_BillingAccountsUpdate_575011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a billing account.
  ## 
  let valid = call_575034.validator(path, query, header, formData, body)
  let scheme = call_575034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575034.url(scheme.get, call_575034.host, call_575034.base,
                         call_575034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575034, url, valid)

proc call*(call_575035: Call_BillingAccountsUpdate_575011; apiVersion: string;
          billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingAccountsUpdate
  ## The operation to update a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update billing account operation.
  var path_575036 = newJObject()
  var query_575037 = newJObject()
  var body_575038 = newJObject()
  add(query_575037, "api-version", newJString(apiVersion))
  add(path_575036, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_575038 = parameters
  result = call_575035.call(path_575036, query_575037, nil, nil, body_575038)

var billingAccountsUpdate* = Call_BillingAccountsUpdate_575011(
    name: "billingAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}",
    validator: validate_BillingAccountsUpdate_575012, base: "",
    url: url_BillingAccountsUpdate_575013, schemes: {Scheme.Https})
type
  Call_AgreementsListByBillingAccountName_575039 = ref object of OpenApiRestCall_574467
proc url_AgreementsListByBillingAccountName_575041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/agreements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgreementsListByBillingAccountName_575040(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all agreements for a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575042 = path.getOrDefault("billingAccountName")
  valid_575042 = validateParameter(valid_575042, JString, required = true,
                                 default = nil)
  if valid_575042 != nil:
    section.add "billingAccountName", valid_575042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the participants.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575043 = query.getOrDefault("api-version")
  valid_575043 = validateParameter(valid_575043, JString, required = true,
                                 default = nil)
  if valid_575043 != nil:
    section.add "api-version", valid_575043
  var valid_575044 = query.getOrDefault("$expand")
  valid_575044 = validateParameter(valid_575044, JString, required = false,
                                 default = nil)
  if valid_575044 != nil:
    section.add "$expand", valid_575044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575045: Call_AgreementsListByBillingAccountName_575039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all agreements for a billing account.
  ## 
  let valid = call_575045.validator(path, query, header, formData, body)
  let scheme = call_575045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575045.url(scheme.get, call_575045.host, call_575045.base,
                         call_575045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575045, url, valid)

proc call*(call_575046: Call_AgreementsListByBillingAccountName_575039;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## agreementsListByBillingAccountName
  ## Lists all agreements for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the participants.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575047 = newJObject()
  var query_575048 = newJObject()
  add(query_575048, "api-version", newJString(apiVersion))
  add(query_575048, "$expand", newJString(Expand))
  add(path_575047, "billingAccountName", newJString(billingAccountName))
  result = call_575046.call(path_575047, query_575048, nil, nil, nil)

var agreementsListByBillingAccountName* = Call_AgreementsListByBillingAccountName_575039(
    name: "agreementsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/agreements",
    validator: validate_AgreementsListByBillingAccountName_575040, base: "",
    url: url_AgreementsListByBillingAccountName_575041, schemes: {Scheme.Https})
type
  Call_AgreementsGet_575049 = ref object of OpenApiRestCall_574467
proc url_AgreementsGet_575051(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "agreementName" in path, "`agreementName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/agreements/"),
               (kind: VariableSegment, value: "agreementName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgreementsGet_575050(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the agreement by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   agreementName: JString (required)
  ##                : Agreement Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575052 = path.getOrDefault("billingAccountName")
  valid_575052 = validateParameter(valid_575052, JString, required = true,
                                 default = nil)
  if valid_575052 != nil:
    section.add "billingAccountName", valid_575052
  var valid_575053 = path.getOrDefault("agreementName")
  valid_575053 = validateParameter(valid_575053, JString, required = true,
                                 default = nil)
  if valid_575053 != nil:
    section.add "agreementName", valid_575053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the participants.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575054 = query.getOrDefault("api-version")
  valid_575054 = validateParameter(valid_575054, JString, required = true,
                                 default = nil)
  if valid_575054 != nil:
    section.add "api-version", valid_575054
  var valid_575055 = query.getOrDefault("$expand")
  valid_575055 = validateParameter(valid_575055, JString, required = false,
                                 default = nil)
  if valid_575055 != nil:
    section.add "$expand", valid_575055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575056: Call_AgreementsGet_575049; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the agreement by name.
  ## 
  let valid = call_575056.validator(path, query, header, formData, body)
  let scheme = call_575056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575056.url(scheme.get, call_575056.host, call_575056.base,
                         call_575056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575056, url, valid)

proc call*(call_575057: Call_AgreementsGet_575049; apiVersion: string;
          billingAccountName: string; agreementName: string; Expand: string = ""): Recallable =
  ## agreementsGet
  ## Get the agreement by name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the participants.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   agreementName: string (required)
  ##                : Agreement Id.
  var path_575058 = newJObject()
  var query_575059 = newJObject()
  add(query_575059, "api-version", newJString(apiVersion))
  add(query_575059, "$expand", newJString(Expand))
  add(path_575058, "billingAccountName", newJString(billingAccountName))
  add(path_575058, "agreementName", newJString(agreementName))
  result = call_575057.call(path_575058, query_575059, nil, nil, nil)

var agreementsGet* = Call_AgreementsGet_575049(name: "agreementsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsGet_575050, base: "", url: url_AgreementsGet_575051,
    schemes: {Scheme.Https})
type
  Call_BillingProfilesCreate_575070 = ref object of OpenApiRestCall_574467
proc url_BillingProfilesCreate_575072(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingProfilesCreate_575071(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a BillingProfile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575073 = path.getOrDefault("billingAccountName")
  valid_575073 = validateParameter(valid_575073, JString, required = true,
                                 default = nil)
  if valid_575073 != nil:
    section.add "billingAccountName", valid_575073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575074 = query.getOrDefault("api-version")
  valid_575074 = validateParameter(valid_575074, JString, required = true,
                                 default = nil)
  if valid_575074 != nil:
    section.add "api-version", valid_575074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create BillingProfile operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575076: Call_BillingProfilesCreate_575070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a BillingProfile.
  ## 
  let valid = call_575076.validator(path, query, header, formData, body)
  let scheme = call_575076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575076.url(scheme.get, call_575076.host, call_575076.base,
                         call_575076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575076, url, valid)

proc call*(call_575077: Call_BillingProfilesCreate_575070; apiVersion: string;
          billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingProfilesCreate
  ## The operation to create a BillingProfile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create BillingProfile operation.
  var path_575078 = newJObject()
  var query_575079 = newJObject()
  var body_575080 = newJObject()
  add(query_575079, "api-version", newJString(apiVersion))
  add(path_575078, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_575080 = parameters
  result = call_575077.call(path_575078, query_575079, nil, nil, body_575080)

var billingProfilesCreate* = Call_BillingProfilesCreate_575070(
    name: "billingProfilesCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles",
    validator: validate_BillingProfilesCreate_575071, base: "",
    url: url_BillingProfilesCreate_575072, schemes: {Scheme.Https})
type
  Call_BillingProfilesListByBillingAccountName_575060 = ref object of OpenApiRestCall_574467
proc url_BillingProfilesListByBillingAccountName_575062(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingProfilesListByBillingAccountName_575061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing profiles for a user which that user has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575063 = path.getOrDefault("billingAccountName")
  valid_575063 = validateParameter(valid_575063, JString, required = true,
                                 default = nil)
  if valid_575063 != nil:
    section.add "billingAccountName", valid_575063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575064 = query.getOrDefault("api-version")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "api-version", valid_575064
  var valid_575065 = query.getOrDefault("$expand")
  valid_575065 = validateParameter(valid_575065, JString, required = false,
                                 default = nil)
  if valid_575065 != nil:
    section.add "$expand", valid_575065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575066: Call_BillingProfilesListByBillingAccountName_575060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing profiles for a user which that user has access to.
  ## 
  let valid = call_575066.validator(path, query, header, formData, body)
  let scheme = call_575066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575066.url(scheme.get, call_575066.host, call_575066.base,
                         call_575066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575066, url, valid)

proc call*(call_575067: Call_BillingProfilesListByBillingAccountName_575060;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## billingProfilesListByBillingAccountName
  ## Lists all billing profiles for a user which that user has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575068 = newJObject()
  var query_575069 = newJObject()
  add(query_575069, "api-version", newJString(apiVersion))
  add(query_575069, "$expand", newJString(Expand))
  add(path_575068, "billingAccountName", newJString(billingAccountName))
  result = call_575067.call(path_575068, query_575069, nil, nil, nil)

var billingProfilesListByBillingAccountName* = Call_BillingProfilesListByBillingAccountName_575060(
    name: "billingProfilesListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles",
    validator: validate_BillingProfilesListByBillingAccountName_575061, base: "",
    url: url_BillingProfilesListByBillingAccountName_575062,
    schemes: {Scheme.Https})
type
  Call_BillingProfilesUpdate_575092 = ref object of OpenApiRestCall_574467
proc url_BillingProfilesUpdate_575094(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingProfilesUpdate_575093(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a billing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575095 = path.getOrDefault("billingAccountName")
  valid_575095 = validateParameter(valid_575095, JString, required = true,
                                 default = nil)
  if valid_575095 != nil:
    section.add "billingAccountName", valid_575095
  var valid_575096 = path.getOrDefault("billingProfileName")
  valid_575096 = validateParameter(valid_575096, JString, required = true,
                                 default = nil)
  if valid_575096 != nil:
    section.add "billingProfileName", valid_575096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575097 = query.getOrDefault("api-version")
  valid_575097 = validateParameter(valid_575097, JString, required = true,
                                 default = nil)
  if valid_575097 != nil:
    section.add "api-version", valid_575097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update billing profile operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575099: Call_BillingProfilesUpdate_575092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a billing profile.
  ## 
  let valid = call_575099.validator(path, query, header, formData, body)
  let scheme = call_575099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575099.url(scheme.get, call_575099.host, call_575099.base,
                         call_575099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575099, url, valid)

proc call*(call_575100: Call_BillingProfilesUpdate_575092; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## billingProfilesUpdate
  ## The operation to update a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update billing profile operation.
  var path_575101 = newJObject()
  var query_575102 = newJObject()
  var body_575103 = newJObject()
  add(query_575102, "api-version", newJString(apiVersion))
  add(path_575101, "billingAccountName", newJString(billingAccountName))
  add(path_575101, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_575103 = parameters
  result = call_575100.call(path_575101, query_575102, nil, nil, body_575103)

var billingProfilesUpdate* = Call_BillingProfilesUpdate_575092(
    name: "billingProfilesUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesUpdate_575093, base: "",
    url: url_BillingProfilesUpdate_575094, schemes: {Scheme.Https})
type
  Call_BillingProfilesGet_575081 = ref object of OpenApiRestCall_574467
proc url_BillingProfilesGet_575083(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingProfilesGet_575082(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the billing profile by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575084 = path.getOrDefault("billingAccountName")
  valid_575084 = validateParameter(valid_575084, JString, required = true,
                                 default = nil)
  if valid_575084 != nil:
    section.add "billingAccountName", valid_575084
  var valid_575085 = path.getOrDefault("billingProfileName")
  valid_575085 = validateParameter(valid_575085, JString, required = true,
                                 default = nil)
  if valid_575085 != nil:
    section.add "billingProfileName", valid_575085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575086 = query.getOrDefault("api-version")
  valid_575086 = validateParameter(valid_575086, JString, required = true,
                                 default = nil)
  if valid_575086 != nil:
    section.add "api-version", valid_575086
  var valid_575087 = query.getOrDefault("$expand")
  valid_575087 = validateParameter(valid_575087, JString, required = false,
                                 default = nil)
  if valid_575087 != nil:
    section.add "$expand", valid_575087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575088: Call_BillingProfilesGet_575081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the billing profile by id.
  ## 
  let valid = call_575088.validator(path, query, header, formData, body)
  let scheme = call_575088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575088.url(scheme.get, call_575088.host, call_575088.base,
                         call_575088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575088, url, valid)

proc call*(call_575089: Call_BillingProfilesGet_575081; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          Expand: string = ""): Recallable =
  ## billingProfilesGet
  ## Get the billing profile by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575090 = newJObject()
  var query_575091 = newJObject()
  add(query_575091, "api-version", newJString(apiVersion))
  add(query_575091, "$expand", newJString(Expand))
  add(path_575090, "billingAccountName", newJString(billingAccountName))
  add(path_575090, "billingProfileName", newJString(billingProfileName))
  result = call_575089.call(path_575090, query_575091, nil, nil, nil)

var billingProfilesGet* = Call_BillingProfilesGet_575081(
    name: "billingProfilesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesGet_575082, base: "",
    url: url_BillingProfilesGet_575083, schemes: {Scheme.Https})
type
  Call_AvailableBalancesGetByBillingProfile_575104 = ref object of OpenApiRestCall_574467
proc url_AvailableBalancesGetByBillingProfile_575106(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/availableBalance/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailableBalancesGetByBillingProfile_575105(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575107 = path.getOrDefault("billingAccountName")
  valid_575107 = validateParameter(valid_575107, JString, required = true,
                                 default = nil)
  if valid_575107 != nil:
    section.add "billingAccountName", valid_575107
  var valid_575108 = path.getOrDefault("billingProfileName")
  valid_575108 = validateParameter(valid_575108, JString, required = true,
                                 default = nil)
  if valid_575108 != nil:
    section.add "billingProfileName", valid_575108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575109 = query.getOrDefault("api-version")
  valid_575109 = validateParameter(valid_575109, JString, required = true,
                                 default = nil)
  if valid_575109 != nil:
    section.add "api-version", valid_575109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575110: Call_AvailableBalancesGetByBillingProfile_575104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ## 
  let valid = call_575110.validator(path, query, header, formData, body)
  let scheme = call_575110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575110.url(scheme.get, call_575110.host, call_575110.base,
                         call_575110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575110, url, valid)

proc call*(call_575111: Call_AvailableBalancesGetByBillingProfile_575104;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## availableBalancesGetByBillingProfile
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575112 = newJObject()
  var query_575113 = newJObject()
  add(query_575113, "api-version", newJString(apiVersion))
  add(path_575112, "billingAccountName", newJString(billingAccountName))
  add(path_575112, "billingProfileName", newJString(billingProfileName))
  result = call_575111.call(path_575112, query_575113, nil, nil, nil)

var availableBalancesGetByBillingProfile* = Call_AvailableBalancesGetByBillingProfile_575104(
    name: "availableBalancesGetByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/availableBalance/default",
    validator: validate_AvailableBalancesGetByBillingProfile_575105, base: "",
    url: url_AvailableBalancesGetByBillingProfile_575106, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByBillingProfileName_575114 = ref object of OpenApiRestCall_574467
proc url_BillingSubscriptionsListByBillingProfileName_575116(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/billingSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsListByBillingProfileName_575115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscriptions by billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575117 = path.getOrDefault("billingAccountName")
  valid_575117 = validateParameter(valid_575117, JString, required = true,
                                 default = nil)
  if valid_575117 != nil:
    section.add "billingAccountName", valid_575117
  var valid_575118 = path.getOrDefault("billingProfileName")
  valid_575118 = validateParameter(valid_575118, JString, required = true,
                                 default = nil)
  if valid_575118 != nil:
    section.add "billingProfileName", valid_575118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575119 = query.getOrDefault("api-version")
  valid_575119 = validateParameter(valid_575119, JString, required = true,
                                 default = nil)
  if valid_575119 != nil:
    section.add "api-version", valid_575119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575120: Call_BillingSubscriptionsListByBillingProfileName_575114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscriptions by billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575120.validator(path, query, header, formData, body)
  let scheme = call_575120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575120.url(scheme.get, call_575120.host, call_575120.base,
                         call_575120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575120, url, valid)

proc call*(call_575121: Call_BillingSubscriptionsListByBillingProfileName_575114;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingSubscriptionsListByBillingProfileName
  ## Lists billing subscriptions by billing profile name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575122 = newJObject()
  var query_575123 = newJObject()
  add(query_575123, "api-version", newJString(apiVersion))
  add(path_575122, "billingAccountName", newJString(billingAccountName))
  add(path_575122, "billingProfileName", newJString(billingProfileName))
  result = call_575121.call(path_575122, query_575123, nil, nil, nil)

var billingSubscriptionsListByBillingProfileName* = Call_BillingSubscriptionsListByBillingProfileName_575114(
    name: "billingSubscriptionsListByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByBillingProfileName_575115,
    base: "", url: url_BillingSubscriptionsListByBillingProfileName_575116,
    schemes: {Scheme.Https})
type
  Call_InvoiceSectionsListByBillingProfileName_575124 = ref object of OpenApiRestCall_574467
proc url_InvoiceSectionsListByBillingProfileName_575126(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsListByBillingProfileName_575125(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all invoice sections under a billing profile for which a user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575127 = path.getOrDefault("billingAccountName")
  valid_575127 = validateParameter(valid_575127, JString, required = true,
                                 default = nil)
  if valid_575127 != nil:
    section.add "billingAccountName", valid_575127
  var valid_575128 = path.getOrDefault("billingProfileName")
  valid_575128 = validateParameter(valid_575128, JString, required = true,
                                 default = nil)
  if valid_575128 != nil:
    section.add "billingProfileName", valid_575128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575129 = query.getOrDefault("api-version")
  valid_575129 = validateParameter(valid_575129, JString, required = true,
                                 default = nil)
  if valid_575129 != nil:
    section.add "api-version", valid_575129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575130: Call_InvoiceSectionsListByBillingProfileName_575124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoice sections under a billing profile for which a user has access.
  ## 
  let valid = call_575130.validator(path, query, header, formData, body)
  let scheme = call_575130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575130.url(scheme.get, call_575130.host, call_575130.base,
                         call_575130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575130, url, valid)

proc call*(call_575131: Call_InvoiceSectionsListByBillingProfileName_575124;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## invoiceSectionsListByBillingProfileName
  ## Lists all invoice sections under a billing profile for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575132 = newJObject()
  var query_575133 = newJObject()
  add(query_575133, "api-version", newJString(apiVersion))
  add(path_575132, "billingAccountName", newJString(billingAccountName))
  add(path_575132, "billingProfileName", newJString(billingProfileName))
  result = call_575131.call(path_575132, query_575133, nil, nil, nil)

var invoiceSectionsListByBillingProfileName* = Call_InvoiceSectionsListByBillingProfileName_575124(
    name: "invoiceSectionsListByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections",
    validator: validate_InvoiceSectionsListByBillingProfileName_575125, base: "",
    url: url_InvoiceSectionsListByBillingProfileName_575126,
    schemes: {Scheme.Https})
type
  Call_InvoicesListByBillingProfile_575134 = ref object of OpenApiRestCall_574467
proc url_InvoicesListByBillingProfile_575136(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoicesListByBillingProfile_575135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of invoices for a billing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575137 = path.getOrDefault("billingAccountName")
  valid_575137 = validateParameter(valid_575137, JString, required = true,
                                 default = nil)
  if valid_575137 != nil:
    section.add "billingAccountName", valid_575137
  var valid_575138 = path.getOrDefault("billingProfileName")
  valid_575138 = validateParameter(valid_575138, JString, required = true,
                                 default = nil)
  if valid_575138 != nil:
    section.add "billingProfileName", valid_575138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   periodEndDate: JString (required)
  ##                : Invoice period end date.
  ##   periodStartDate: JString (required)
  ##                  : Invoice period start date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575139 = query.getOrDefault("api-version")
  valid_575139 = validateParameter(valid_575139, JString, required = true,
                                 default = nil)
  if valid_575139 != nil:
    section.add "api-version", valid_575139
  var valid_575140 = query.getOrDefault("periodEndDate")
  valid_575140 = validateParameter(valid_575140, JString, required = true,
                                 default = nil)
  if valid_575140 != nil:
    section.add "periodEndDate", valid_575140
  var valid_575141 = query.getOrDefault("periodStartDate")
  valid_575141 = validateParameter(valid_575141, JString, required = true,
                                 default = nil)
  if valid_575141 != nil:
    section.add "periodStartDate", valid_575141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575142: Call_InvoicesListByBillingProfile_575134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of invoices for a billing profile.
  ## 
  let valid = call_575142.validator(path, query, header, formData, body)
  let scheme = call_575142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575142.url(scheme.get, call_575142.host, call_575142.base,
                         call_575142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575142, url, valid)

proc call*(call_575143: Call_InvoicesListByBillingProfile_575134;
          apiVersion: string; billingAccountName: string; periodEndDate: string;
          periodStartDate: string; billingProfileName: string): Recallable =
  ## invoicesListByBillingProfile
  ## List of invoices for a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   periodEndDate: string (required)
  ##                : Invoice period end date.
  ##   periodStartDate: string (required)
  ##                  : Invoice period start date.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575144 = newJObject()
  var query_575145 = newJObject()
  add(query_575145, "api-version", newJString(apiVersion))
  add(path_575144, "billingAccountName", newJString(billingAccountName))
  add(query_575145, "periodEndDate", newJString(periodEndDate))
  add(query_575145, "periodStartDate", newJString(periodStartDate))
  add(path_575144, "billingProfileName", newJString(billingProfileName))
  result = call_575143.call(path_575144, query_575145, nil, nil, nil)

var invoicesListByBillingProfile* = Call_InvoicesListByBillingProfile_575134(
    name: "invoicesListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices",
    validator: validate_InvoicesListByBillingProfile_575135, base: "",
    url: url_InvoicesListByBillingProfile_575136, schemes: {Scheme.Https})
type
  Call_InvoicesGet_575146 = ref object of OpenApiRestCall_574467
proc url_InvoicesGet_575148(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceName" in path, "`invoiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoices/"),
               (kind: VariableSegment, value: "invoiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoicesGet_575147(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the invoice by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceName: JString (required)
  ##              : Invoice Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575149 = path.getOrDefault("billingAccountName")
  valid_575149 = validateParameter(valid_575149, JString, required = true,
                                 default = nil)
  if valid_575149 != nil:
    section.add "billingAccountName", valid_575149
  var valid_575150 = path.getOrDefault("invoiceName")
  valid_575150 = validateParameter(valid_575150, JString, required = true,
                                 default = nil)
  if valid_575150 != nil:
    section.add "invoiceName", valid_575150
  var valid_575151 = path.getOrDefault("billingProfileName")
  valid_575151 = validateParameter(valid_575151, JString, required = true,
                                 default = nil)
  if valid_575151 != nil:
    section.add "billingProfileName", valid_575151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575152 = query.getOrDefault("api-version")
  valid_575152 = validateParameter(valid_575152, JString, required = true,
                                 default = nil)
  if valid_575152 != nil:
    section.add "api-version", valid_575152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575153: Call_InvoicesGet_575146; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the invoice by name.
  ## 
  let valid = call_575153.validator(path, query, header, formData, body)
  let scheme = call_575153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575153.url(scheme.get, call_575153.host, call_575153.base,
                         call_575153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575153, url, valid)

proc call*(call_575154: Call_InvoicesGet_575146; apiVersion: string;
          billingAccountName: string; invoiceName: string;
          billingProfileName: string): Recallable =
  ## invoicesGet
  ## Get the invoice by name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceName: string (required)
  ##              : Invoice Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575155 = newJObject()
  var query_575156 = newJObject()
  add(query_575156, "api-version", newJString(apiVersion))
  add(path_575155, "billingAccountName", newJString(billingAccountName))
  add(path_575155, "invoiceName", newJString(invoiceName))
  add(path_575155, "billingProfileName", newJString(billingProfileName))
  result = call_575154.call(path_575155, query_575156, nil, nil, nil)

var invoicesGet* = Call_InvoicesGet_575146(name: "invoicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices/{invoiceName}",
                                        validator: validate_InvoicesGet_575147,
                                        base: "", url: url_InvoicesGet_575148,
                                        schemes: {Scheme.Https})
type
  Call_PaymentMethodsListByBillingProfileName_575157 = ref object of OpenApiRestCall_574467
proc url_PaymentMethodsListByBillingProfileName_575159(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/paymentMethods")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PaymentMethodsListByBillingProfileName_575158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Payment Methods by billing profile Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575160 = path.getOrDefault("billingAccountName")
  valid_575160 = validateParameter(valid_575160, JString, required = true,
                                 default = nil)
  if valid_575160 != nil:
    section.add "billingAccountName", valid_575160
  var valid_575161 = path.getOrDefault("billingProfileName")
  valid_575161 = validateParameter(valid_575161, JString, required = true,
                                 default = nil)
  if valid_575161 != nil:
    section.add "billingProfileName", valid_575161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575162 = query.getOrDefault("api-version")
  valid_575162 = validateParameter(valid_575162, JString, required = true,
                                 default = nil)
  if valid_575162 != nil:
    section.add "api-version", valid_575162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575163: Call_PaymentMethodsListByBillingProfileName_575157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Payment Methods by billing profile Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575163.validator(path, query, header, formData, body)
  let scheme = call_575163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575163.url(scheme.get, call_575163.host, call_575163.base,
                         call_575163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575163, url, valid)

proc call*(call_575164: Call_PaymentMethodsListByBillingProfileName_575157;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## paymentMethodsListByBillingProfileName
  ## Lists the Payment Methods by billing profile Id.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575165 = newJObject()
  var query_575166 = newJObject()
  add(query_575166, "api-version", newJString(apiVersion))
  add(path_575165, "billingAccountName", newJString(billingAccountName))
  add(path_575165, "billingProfileName", newJString(billingProfileName))
  result = call_575164.call(path_575165, query_575166, nil, nil, nil)

var paymentMethodsListByBillingProfileName* = Call_PaymentMethodsListByBillingProfileName_575157(
    name: "paymentMethodsListByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/paymentMethods",
    validator: validate_PaymentMethodsListByBillingProfileName_575158, base: "",
    url: url_PaymentMethodsListByBillingProfileName_575159,
    schemes: {Scheme.Https})
type
  Call_PoliciesUpdate_575177 = ref object of OpenApiRestCall_574467
proc url_PoliciesUpdate_575179(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/policies/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesUpdate_575178(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The operation to update a policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575180 = path.getOrDefault("billingAccountName")
  valid_575180 = validateParameter(valid_575180, JString, required = true,
                                 default = nil)
  if valid_575180 != nil:
    section.add "billingAccountName", valid_575180
  var valid_575181 = path.getOrDefault("billingProfileName")
  valid_575181 = validateParameter(valid_575181, JString, required = true,
                                 default = nil)
  if valid_575181 != nil:
    section.add "billingProfileName", valid_575181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575182 = query.getOrDefault("api-version")
  valid_575182 = validateParameter(valid_575182, JString, required = true,
                                 default = nil)
  if valid_575182 != nil:
    section.add "api-version", valid_575182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575184: Call_PoliciesUpdate_575177; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a policy.
  ## 
  let valid = call_575184.validator(path, query, header, formData, body)
  let scheme = call_575184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575184.url(scheme.get, call_575184.host, call_575184.base,
                         call_575184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575184, url, valid)

proc call*(call_575185: Call_PoliciesUpdate_575177; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## policiesUpdate
  ## The operation to update a policy.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update policy operation.
  var path_575186 = newJObject()
  var query_575187 = newJObject()
  var body_575188 = newJObject()
  add(query_575187, "api-version", newJString(apiVersion))
  add(path_575186, "billingAccountName", newJString(billingAccountName))
  add(path_575186, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_575188 = parameters
  result = call_575185.call(path_575186, query_575187, nil, nil, body_575188)

var policiesUpdate* = Call_PoliciesUpdate_575177(name: "policiesUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/policies/default",
    validator: validate_PoliciesUpdate_575178, base: "", url: url_PoliciesUpdate_575179,
    schemes: {Scheme.Https})
type
  Call_PoliciesGetByBillingProfileName_575167 = ref object of OpenApiRestCall_574467
proc url_PoliciesGetByBillingProfileName_575169(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/policies/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesGetByBillingProfileName_575168(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The policy for a given billing account name and billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575170 = path.getOrDefault("billingAccountName")
  valid_575170 = validateParameter(valid_575170, JString, required = true,
                                 default = nil)
  if valid_575170 != nil:
    section.add "billingAccountName", valid_575170
  var valid_575171 = path.getOrDefault("billingProfileName")
  valid_575171 = validateParameter(valid_575171, JString, required = true,
                                 default = nil)
  if valid_575171 != nil:
    section.add "billingProfileName", valid_575171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575172 = query.getOrDefault("api-version")
  valid_575172 = validateParameter(valid_575172, JString, required = true,
                                 default = nil)
  if valid_575172 != nil:
    section.add "api-version", valid_575172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575173: Call_PoliciesGetByBillingProfileName_575167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The policy for a given billing account name and billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575173.validator(path, query, header, formData, body)
  let scheme = call_575173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575173.url(scheme.get, call_575173.host, call_575173.base,
                         call_575173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575173, url, valid)

proc call*(call_575174: Call_PoliciesGetByBillingProfileName_575167;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## policiesGetByBillingProfileName
  ## The policy for a given billing account name and billing profile name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575175 = newJObject()
  var query_575176 = newJObject()
  add(query_575176, "api-version", newJString(apiVersion))
  add(path_575175, "billingAccountName", newJString(billingAccountName))
  add(path_575175, "billingProfileName", newJString(billingProfileName))
  result = call_575174.call(path_575175, query_575176, nil, nil, nil)

var policiesGetByBillingProfileName* = Call_PoliciesGetByBillingProfileName_575167(
    name: "policiesGetByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/policies/default",
    validator: validate_PoliciesGetByBillingProfileName_575168, base: "",
    url: url_PoliciesGetByBillingProfileName_575169, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByBillingProfile_575189 = ref object of OpenApiRestCall_574467
proc url_BillingPermissionsListByBillingProfile_575191(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByBillingProfile_575190(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billingPermissions for the caller has for a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575192 = path.getOrDefault("billingAccountName")
  valid_575192 = validateParameter(valid_575192, JString, required = true,
                                 default = nil)
  if valid_575192 != nil:
    section.add "billingAccountName", valid_575192
  var valid_575193 = path.getOrDefault("billingProfileName")
  valid_575193 = validateParameter(valid_575193, JString, required = true,
                                 default = nil)
  if valid_575193 != nil:
    section.add "billingProfileName", valid_575193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575194 = query.getOrDefault("api-version")
  valid_575194 = validateParameter(valid_575194, JString, required = true,
                                 default = nil)
  if valid_575194 != nil:
    section.add "api-version", valid_575194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575195: Call_BillingPermissionsListByBillingProfile_575189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billingPermissions for the caller has for a billing account.
  ## 
  let valid = call_575195.validator(path, query, header, formData, body)
  let scheme = call_575195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575195.url(scheme.get, call_575195.host, call_575195.base,
                         call_575195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575195, url, valid)

proc call*(call_575196: Call_BillingPermissionsListByBillingProfile_575189;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingPermissionsListByBillingProfile
  ## Lists all billingPermissions for the caller has for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575197 = newJObject()
  var query_575198 = newJObject()
  add(query_575198, "api-version", newJString(apiVersion))
  add(path_575197, "billingAccountName", newJString(billingAccountName))
  add(path_575197, "billingProfileName", newJString(billingProfileName))
  result = call_575196.call(path_575197, query_575198, nil, nil, nil)

var billingPermissionsListByBillingProfile* = Call_BillingPermissionsListByBillingProfile_575189(
    name: "billingPermissionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByBillingProfile_575190, base: "",
    url: url_BillingPermissionsListByBillingProfile_575191,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByBillingProfileName_575199 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsListByBillingProfileName_575201(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsListByBillingProfileName_575200(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignments on the Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575202 = path.getOrDefault("billingAccountName")
  valid_575202 = validateParameter(valid_575202, JString, required = true,
                                 default = nil)
  if valid_575202 != nil:
    section.add "billingAccountName", valid_575202
  var valid_575203 = path.getOrDefault("billingProfileName")
  valid_575203 = validateParameter(valid_575203, JString, required = true,
                                 default = nil)
  if valid_575203 != nil:
    section.add "billingProfileName", valid_575203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575204 = query.getOrDefault("api-version")
  valid_575204 = validateParameter(valid_575204, JString, required = true,
                                 default = nil)
  if valid_575204 != nil:
    section.add "api-version", valid_575204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575205: Call_BillingRoleAssignmentsListByBillingProfileName_575199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the Billing Profile
  ## 
  let valid = call_575205.validator(path, query, header, formData, body)
  let scheme = call_575205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575205.url(scheme.get, call_575205.host, call_575205.base,
                         call_575205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575205, url, valid)

proc call*(call_575206: Call_BillingRoleAssignmentsListByBillingProfileName_575199;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsListByBillingProfileName
  ## Get the role assignments on the Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575207 = newJObject()
  var query_575208 = newJObject()
  add(query_575208, "api-version", newJString(apiVersion))
  add(path_575207, "billingAccountName", newJString(billingAccountName))
  add(path_575207, "billingProfileName", newJString(billingProfileName))
  result = call_575206.call(path_575207, query_575208, nil, nil, nil)

var billingRoleAssignmentsListByBillingProfileName* = Call_BillingRoleAssignmentsListByBillingProfileName_575199(
    name: "billingRoleAssignmentsListByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByBillingProfileName_575200,
    base: "", url: url_BillingRoleAssignmentsListByBillingProfileName_575201,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByBillingProfileName_575209 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsGetByBillingProfileName_575211(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsGetByBillingProfileName_575210(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignment for the caller on the Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_575212 = path.getOrDefault("billingRoleAssignmentName")
  valid_575212 = validateParameter(valid_575212, JString, required = true,
                                 default = nil)
  if valid_575212 != nil:
    section.add "billingRoleAssignmentName", valid_575212
  var valid_575213 = path.getOrDefault("billingAccountName")
  valid_575213 = validateParameter(valid_575213, JString, required = true,
                                 default = nil)
  if valid_575213 != nil:
    section.add "billingAccountName", valid_575213
  var valid_575214 = path.getOrDefault("billingProfileName")
  valid_575214 = validateParameter(valid_575214, JString, required = true,
                                 default = nil)
  if valid_575214 != nil:
    section.add "billingProfileName", valid_575214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575215 = query.getOrDefault("api-version")
  valid_575215 = validateParameter(valid_575215, JString, required = true,
                                 default = nil)
  if valid_575215 != nil:
    section.add "api-version", valid_575215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575216: Call_BillingRoleAssignmentsGetByBillingProfileName_575209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller on the Billing Profile
  ## 
  let valid = call_575216.validator(path, query, header, formData, body)
  let scheme = call_575216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575216.url(scheme.get, call_575216.host, call_575216.base,
                         call_575216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575216, url, valid)

proc call*(call_575217: Call_BillingRoleAssignmentsGetByBillingProfileName_575209;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsGetByBillingProfileName
  ## Get the role assignment for the caller on the Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575218 = newJObject()
  var query_575219 = newJObject()
  add(query_575219, "api-version", newJString(apiVersion))
  add(path_575218, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_575218, "billingAccountName", newJString(billingAccountName))
  add(path_575218, "billingProfileName", newJString(billingProfileName))
  result = call_575217.call(path_575218, query_575219, nil, nil, nil)

var billingRoleAssignmentsGetByBillingProfileName* = Call_BillingRoleAssignmentsGetByBillingProfileName_575209(
    name: "billingRoleAssignmentsGetByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByBillingProfileName_575210,
    base: "", url: url_BillingRoleAssignmentsGetByBillingProfileName_575211,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByBillingProfileName_575220 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsDeleteByBillingProfileName_575222(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsDeleteByBillingProfileName_575221(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete the role assignment on this Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_575223 = path.getOrDefault("billingRoleAssignmentName")
  valid_575223 = validateParameter(valid_575223, JString, required = true,
                                 default = nil)
  if valid_575223 != nil:
    section.add "billingRoleAssignmentName", valid_575223
  var valid_575224 = path.getOrDefault("billingAccountName")
  valid_575224 = validateParameter(valid_575224, JString, required = true,
                                 default = nil)
  if valid_575224 != nil:
    section.add "billingAccountName", valid_575224
  var valid_575225 = path.getOrDefault("billingProfileName")
  valid_575225 = validateParameter(valid_575225, JString, required = true,
                                 default = nil)
  if valid_575225 != nil:
    section.add "billingProfileName", valid_575225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575226 = query.getOrDefault("api-version")
  valid_575226 = validateParameter(valid_575226, JString, required = true,
                                 default = nil)
  if valid_575226 != nil:
    section.add "api-version", valid_575226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575227: Call_BillingRoleAssignmentsDeleteByBillingProfileName_575220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on this Billing Profile
  ## 
  let valid = call_575227.validator(path, query, header, formData, body)
  let scheme = call_575227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575227.url(scheme.get, call_575227.host, call_575227.base,
                         call_575227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575227, url, valid)

proc call*(call_575228: Call_BillingRoleAssignmentsDeleteByBillingProfileName_575220;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsDeleteByBillingProfileName
  ## Delete the role assignment on this Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575229 = newJObject()
  var query_575230 = newJObject()
  add(query_575230, "api-version", newJString(apiVersion))
  add(path_575229, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_575229, "billingAccountName", newJString(billingAccountName))
  add(path_575229, "billingProfileName", newJString(billingProfileName))
  result = call_575228.call(path_575229, query_575230, nil, nil, nil)

var billingRoleAssignmentsDeleteByBillingProfileName* = Call_BillingRoleAssignmentsDeleteByBillingProfileName_575220(
    name: "billingRoleAssignmentsDeleteByBillingProfileName",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByBillingProfileName_575221,
    base: "", url: url_BillingRoleAssignmentsDeleteByBillingProfileName_575222,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByBillingProfileName_575231 = ref object of OpenApiRestCall_574467
proc url_BillingRoleDefinitionsListByBillingProfileName_575233(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsListByBillingProfileName_575232(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the role definition for a Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575234 = path.getOrDefault("billingAccountName")
  valid_575234 = validateParameter(valid_575234, JString, required = true,
                                 default = nil)
  if valid_575234 != nil:
    section.add "billingAccountName", valid_575234
  var valid_575235 = path.getOrDefault("billingProfileName")
  valid_575235 = validateParameter(valid_575235, JString, required = true,
                                 default = nil)
  if valid_575235 != nil:
    section.add "billingProfileName", valid_575235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575236 = query.getOrDefault("api-version")
  valid_575236 = validateParameter(valid_575236, JString, required = true,
                                 default = nil)
  if valid_575236 != nil:
    section.add "api-version", valid_575236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575237: Call_BillingRoleDefinitionsListByBillingProfileName_575231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for a Billing Profile
  ## 
  let valid = call_575237.validator(path, query, header, formData, body)
  let scheme = call_575237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575237.url(scheme.get, call_575237.host, call_575237.base,
                         call_575237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575237, url, valid)

proc call*(call_575238: Call_BillingRoleDefinitionsListByBillingProfileName_575231;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleDefinitionsListByBillingProfileName
  ## Lists the role definition for a Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575239 = newJObject()
  var query_575240 = newJObject()
  add(query_575240, "api-version", newJString(apiVersion))
  add(path_575239, "billingAccountName", newJString(billingAccountName))
  add(path_575239, "billingProfileName", newJString(billingProfileName))
  result = call_575238.call(path_575239, query_575240, nil, nil, nil)

var billingRoleDefinitionsListByBillingProfileName* = Call_BillingRoleDefinitionsListByBillingProfileName_575231(
    name: "billingRoleDefinitionsListByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByBillingProfileName_575232,
    base: "", url: url_BillingRoleDefinitionsListByBillingProfileName_575233,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByBillingProfileName_575241 = ref object of OpenApiRestCall_574467
proc url_BillingRoleDefinitionsGetByBillingProfileName_575243(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "billingRoleDefinitionName" in path,
        "`billingRoleDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleDefinitions/"),
               (kind: VariableSegment, value: "billingRoleDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsGetByBillingProfileName_575242(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the role definition for a role
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingRoleDefinitionName: JString (required)
  ##                            : role definition id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575244 = path.getOrDefault("billingAccountName")
  valid_575244 = validateParameter(valid_575244, JString, required = true,
                                 default = nil)
  if valid_575244 != nil:
    section.add "billingAccountName", valid_575244
  var valid_575245 = path.getOrDefault("billingRoleDefinitionName")
  valid_575245 = validateParameter(valid_575245, JString, required = true,
                                 default = nil)
  if valid_575245 != nil:
    section.add "billingRoleDefinitionName", valid_575245
  var valid_575246 = path.getOrDefault("billingProfileName")
  valid_575246 = validateParameter(valid_575246, JString, required = true,
                                 default = nil)
  if valid_575246 != nil:
    section.add "billingProfileName", valid_575246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575247 = query.getOrDefault("api-version")
  valid_575247 = validateParameter(valid_575247, JString, required = true,
                                 default = nil)
  if valid_575247 != nil:
    section.add "api-version", valid_575247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575248: Call_BillingRoleDefinitionsGetByBillingProfileName_575241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_575248.validator(path, query, header, formData, body)
  let scheme = call_575248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575248.url(scheme.get, call_575248.host, call_575248.base,
                         call_575248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575248, url, valid)

proc call*(call_575249: Call_BillingRoleDefinitionsGetByBillingProfileName_575241;
          apiVersion: string; billingAccountName: string;
          billingRoleDefinitionName: string; billingProfileName: string): Recallable =
  ## billingRoleDefinitionsGetByBillingProfileName
  ## Gets the role definition for a role
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingRoleDefinitionName: string (required)
  ##                            : role definition id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_575250 = newJObject()
  var query_575251 = newJObject()
  add(query_575251, "api-version", newJString(apiVersion))
  add(path_575250, "billingAccountName", newJString(billingAccountName))
  add(path_575250, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  add(path_575250, "billingProfileName", newJString(billingProfileName))
  result = call_575249.call(path_575250, query_575251, nil, nil, nil)

var billingRoleDefinitionsGetByBillingProfileName* = Call_BillingRoleDefinitionsGetByBillingProfileName_575241(
    name: "billingRoleDefinitionsGetByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByBillingProfileName_575242,
    base: "", url: url_BillingRoleDefinitionsGetByBillingProfileName_575243,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByBillingProfileName_575252 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsAddByBillingProfileName_575254(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/createBillingRoleAssignment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsAddByBillingProfileName_575253(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to add a role assignment to a billing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575255 = path.getOrDefault("billingAccountName")
  valid_575255 = validateParameter(valid_575255, JString, required = true,
                                 default = nil)
  if valid_575255 != nil:
    section.add "billingAccountName", valid_575255
  var valid_575256 = path.getOrDefault("billingProfileName")
  valid_575256 = validateParameter(valid_575256, JString, required = true,
                                 default = nil)
  if valid_575256 != nil:
    section.add "billingProfileName", valid_575256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575257 = query.getOrDefault("api-version")
  valid_575257 = validateParameter(valid_575257, JString, required = true,
                                 default = nil)
  if valid_575257 != nil:
    section.add "api-version", valid_575257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575259: Call_BillingRoleAssignmentsAddByBillingProfileName_575252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a billing profile.
  ## 
  let valid = call_575259.validator(path, query, header, formData, body)
  let scheme = call_575259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575259.url(scheme.get, call_575259.host, call_575259.base,
                         call_575259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575259, url, valid)

proc call*(call_575260: Call_BillingRoleAssignmentsAddByBillingProfileName_575252;
          apiVersion: string; billingAccountName: string;
          billingProfileName: string; parameters: JsonNode): Recallable =
  ## billingRoleAssignmentsAddByBillingProfileName
  ## The operation to add a role assignment to a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  var path_575261 = newJObject()
  var query_575262 = newJObject()
  var body_575263 = newJObject()
  add(query_575262, "api-version", newJString(apiVersion))
  add(path_575261, "billingAccountName", newJString(billingAccountName))
  add(path_575261, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_575263 = parameters
  result = call_575260.call(path_575261, query_575262, nil, nil, body_575263)

var billingRoleAssignmentsAddByBillingProfileName* = Call_BillingRoleAssignmentsAddByBillingProfileName_575252(
    name: "billingRoleAssignmentsAddByBillingProfileName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByBillingProfileName_575253,
    base: "", url: url_BillingRoleAssignmentsAddByBillingProfileName_575254,
    schemes: {Scheme.Https})
type
  Call_TransactionsListByBillingProfileName_575264 = ref object of OpenApiRestCall_574467
proc url_TransactionsListByBillingProfileName_575266(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsListByBillingProfileName_575265(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by billing profile name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575267 = path.getOrDefault("billingAccountName")
  valid_575267 = validateParameter(valid_575267, JString, required = true,
                                 default = nil)
  if valid_575267 != nil:
    section.add "billingAccountName", valid_575267
  var valid_575268 = path.getOrDefault("billingProfileName")
  valid_575268 = validateParameter(valid_575268, JString, required = true,
                                 default = nil)
  if valid_575268 != nil:
    section.add "billingProfileName", valid_575268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575269 = query.getOrDefault("api-version")
  valid_575269 = validateParameter(valid_575269, JString, required = true,
                                 default = nil)
  if valid_575269 != nil:
    section.add "api-version", valid_575269
  var valid_575270 = query.getOrDefault("endDate")
  valid_575270 = validateParameter(valid_575270, JString, required = true,
                                 default = nil)
  if valid_575270 != nil:
    section.add "endDate", valid_575270
  var valid_575271 = query.getOrDefault("startDate")
  valid_575271 = validateParameter(valid_575271, JString, required = true,
                                 default = nil)
  if valid_575271 != nil:
    section.add "startDate", valid_575271
  var valid_575272 = query.getOrDefault("$filter")
  valid_575272 = validateParameter(valid_575272, JString, required = false,
                                 default = nil)
  if valid_575272 != nil:
    section.add "$filter", valid_575272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575273: Call_TransactionsListByBillingProfileName_575264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by billing profile name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575273.validator(path, query, header, formData, body)
  let scheme = call_575273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575273.url(scheme.get, call_575273.host, call_575273.base,
                         call_575273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575273, url, valid)

proc call*(call_575274: Call_TransactionsListByBillingProfileName_575264;
          apiVersion: string; endDate: string; billingAccountName: string;
          startDate: string; billingProfileName: string; Filter: string = ""): Recallable =
  ## transactionsListByBillingProfileName
  ## Lists the transactions by billing profile name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575275 = newJObject()
  var query_575276 = newJObject()
  add(query_575276, "api-version", newJString(apiVersion))
  add(query_575276, "endDate", newJString(endDate))
  add(path_575275, "billingAccountName", newJString(billingAccountName))
  add(query_575276, "startDate", newJString(startDate))
  add(path_575275, "billingProfileName", newJString(billingProfileName))
  add(query_575276, "$filter", newJString(Filter))
  result = call_575274.call(path_575275, query_575276, nil, nil, nil)

var transactionsListByBillingProfileName* = Call_TransactionsListByBillingProfileName_575264(
    name: "transactionsListByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/transactions",
    validator: validate_TransactionsListByBillingProfileName_575265, base: "",
    url: url_TransactionsListByBillingProfileName_575266, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByBillingAccountName_575277 = ref object of OpenApiRestCall_574467
proc url_BillingSubscriptionsListByBillingAccountName_575279(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsListByBillingAccountName_575278(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscriptions by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575280 = path.getOrDefault("billingAccountName")
  valid_575280 = validateParameter(valid_575280, JString, required = true,
                                 default = nil)
  if valid_575280 != nil:
    section.add "billingAccountName", valid_575280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575281 = query.getOrDefault("api-version")
  valid_575281 = validateParameter(valid_575281, JString, required = true,
                                 default = nil)
  if valid_575281 != nil:
    section.add "api-version", valid_575281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575282: Call_BillingSubscriptionsListByBillingAccountName_575277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscriptions by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575282.validator(path, query, header, formData, body)
  let scheme = call_575282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575282.url(scheme.get, call_575282.host, call_575282.base,
                         call_575282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575282, url, valid)

proc call*(call_575283: Call_BillingSubscriptionsListByBillingAccountName_575277;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingSubscriptionsListByBillingAccountName
  ## Lists billing subscriptions by billing account name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575284 = newJObject()
  var query_575285 = newJObject()
  add(query_575285, "api-version", newJString(apiVersion))
  add(path_575284, "billingAccountName", newJString(billingAccountName))
  result = call_575283.call(path_575284, query_575285, nil, nil, nil)

var billingSubscriptionsListByBillingAccountName* = Call_BillingSubscriptionsListByBillingAccountName_575277(
    name: "billingSubscriptionsListByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByBillingAccountName_575278,
    base: "", url: url_BillingSubscriptionsListByBillingAccountName_575279,
    schemes: {Scheme.Https})
type
  Call_CustomersListByBillingAccountName_575286 = ref object of OpenApiRestCall_574467
proc url_CustomersListByBillingAccountName_575288(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomersListByBillingAccountName_575287(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all customers which the current user can work with on-behalf of a partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575289 = path.getOrDefault("billingAccountName")
  valid_575289 = validateParameter(valid_575289, JString, required = true,
                                 default = nil)
  if valid_575289 != nil:
    section.add "billingAccountName", valid_575289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter using hasPermission('{permissionId}') to only return customers for which the caller has the specified permission.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575290 = query.getOrDefault("api-version")
  valid_575290 = validateParameter(valid_575290, JString, required = true,
                                 default = nil)
  if valid_575290 != nil:
    section.add "api-version", valid_575290
  var valid_575291 = query.getOrDefault("$skiptoken")
  valid_575291 = validateParameter(valid_575291, JString, required = false,
                                 default = nil)
  if valid_575291 != nil:
    section.add "$skiptoken", valid_575291
  var valid_575292 = query.getOrDefault("$filter")
  valid_575292 = validateParameter(valid_575292, JString, required = false,
                                 default = nil)
  if valid_575292 != nil:
    section.add "$filter", valid_575292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575293: Call_CustomersListByBillingAccountName_575286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all customers which the current user can work with on-behalf of a partner.
  ## 
  let valid = call_575293.validator(path, query, header, formData, body)
  let scheme = call_575293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575293.url(scheme.get, call_575293.host, call_575293.base,
                         call_575293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575293, url, valid)

proc call*(call_575294: Call_CustomersListByBillingAccountName_575286;
          apiVersion: string; billingAccountName: string; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## customersListByBillingAccountName
  ## Lists all customers which the current user can work with on-behalf of a partner.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter using hasPermission('{permissionId}') to only return customers for which the caller has the specified permission.
  var path_575295 = newJObject()
  var query_575296 = newJObject()
  add(query_575296, "api-version", newJString(apiVersion))
  add(path_575295, "billingAccountName", newJString(billingAccountName))
  add(query_575296, "$skiptoken", newJString(Skiptoken))
  add(query_575296, "$filter", newJString(Filter))
  result = call_575294.call(path_575295, query_575296, nil, nil, nil)

var customersListByBillingAccountName* = Call_CustomersListByBillingAccountName_575286(
    name: "customersListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers",
    validator: validate_CustomersListByBillingAccountName_575287, base: "",
    url: url_CustomersListByBillingAccountName_575288, schemes: {Scheme.Https})
type
  Call_CustomersGet_575297 = ref object of OpenApiRestCall_574467
proc url_CustomersGet_575299(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomersGet_575298(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the customer by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575300 = path.getOrDefault("billingAccountName")
  valid_575300 = validateParameter(valid_575300, JString, required = true,
                                 default = nil)
  if valid_575300 != nil:
    section.add "billingAccountName", valid_575300
  var valid_575301 = path.getOrDefault("customerName")
  valid_575301 = validateParameter(valid_575301, JString, required = true,
                                 default = nil)
  if valid_575301 != nil:
    section.add "customerName", valid_575301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand enabledAzureSkus, resellers.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575302 = query.getOrDefault("api-version")
  valid_575302 = validateParameter(valid_575302, JString, required = true,
                                 default = nil)
  if valid_575302 != nil:
    section.add "api-version", valid_575302
  var valid_575303 = query.getOrDefault("$expand")
  valid_575303 = validateParameter(valid_575303, JString, required = false,
                                 default = nil)
  if valid_575303 != nil:
    section.add "$expand", valid_575303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575304: Call_CustomersGet_575297; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the customer by id.
  ## 
  let valid = call_575304.validator(path, query, header, formData, body)
  let scheme = call_575304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575304.url(scheme.get, call_575304.host, call_575304.base,
                         call_575304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575304, url, valid)

proc call*(call_575305: Call_CustomersGet_575297; apiVersion: string;
          billingAccountName: string; customerName: string; Expand: string = ""): Recallable =
  ## customersGet
  ## Get the customer by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand enabledAzureSkus, resellers.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  var path_575306 = newJObject()
  var query_575307 = newJObject()
  add(query_575307, "api-version", newJString(apiVersion))
  add(query_575307, "$expand", newJString(Expand))
  add(path_575306, "billingAccountName", newJString(billingAccountName))
  add(path_575306, "customerName", newJString(customerName))
  result = call_575305.call(path_575306, query_575307, nil, nil, nil)

var customersGet* = Call_CustomersGet_575297(name: "customersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}",
    validator: validate_CustomersGet_575298, base: "", url: url_CustomersGet_575299,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByCustomerName_575308 = ref object of OpenApiRestCall_574467
proc url_BillingSubscriptionsListByCustomerName_575310(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/billingSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsListByCustomerName_575309(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscription by customer name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575311 = path.getOrDefault("billingAccountName")
  valid_575311 = validateParameter(valid_575311, JString, required = true,
                                 default = nil)
  if valid_575311 != nil:
    section.add "billingAccountName", valid_575311
  var valid_575312 = path.getOrDefault("customerName")
  valid_575312 = validateParameter(valid_575312, JString, required = true,
                                 default = nil)
  if valid_575312 != nil:
    section.add "customerName", valid_575312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575313 = query.getOrDefault("api-version")
  valid_575313 = validateParameter(valid_575313, JString, required = true,
                                 default = nil)
  if valid_575313 != nil:
    section.add "api-version", valid_575313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575314: Call_BillingSubscriptionsListByCustomerName_575308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscription by customer name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575314.validator(path, query, header, formData, body)
  let scheme = call_575314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575314.url(scheme.get, call_575314.host, call_575314.base,
                         call_575314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575314, url, valid)

proc call*(call_575315: Call_BillingSubscriptionsListByCustomerName_575308;
          apiVersion: string; billingAccountName: string; customerName: string): Recallable =
  ## billingSubscriptionsListByCustomerName
  ## Lists billing subscription by customer name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  var path_575316 = newJObject()
  var query_575317 = newJObject()
  add(query_575317, "api-version", newJString(apiVersion))
  add(path_575316, "billingAccountName", newJString(billingAccountName))
  add(path_575316, "customerName", newJString(customerName))
  result = call_575315.call(path_575316, query_575317, nil, nil, nil)

var billingSubscriptionsListByCustomerName* = Call_BillingSubscriptionsListByCustomerName_575308(
    name: "billingSubscriptionsListByCustomerName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByCustomerName_575309, base: "",
    url: url_BillingSubscriptionsListByCustomerName_575310,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsGetByCustomerName_575318 = ref object of OpenApiRestCall_574467
proc url_BillingSubscriptionsGetByCustomerName_575320(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  assert "billingSubscriptionName" in path,
        "`billingSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/billingSubscriptions/"),
               (kind: VariableSegment, value: "billingSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsGetByCustomerName_575319(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   customerName: JString (required)
  ##               : Customer Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575321 = path.getOrDefault("billingAccountName")
  valid_575321 = validateParameter(valid_575321, JString, required = true,
                                 default = nil)
  if valid_575321 != nil:
    section.add "billingAccountName", valid_575321
  var valid_575322 = path.getOrDefault("billingSubscriptionName")
  valid_575322 = validateParameter(valid_575322, JString, required = true,
                                 default = nil)
  if valid_575322 != nil:
    section.add "billingSubscriptionName", valid_575322
  var valid_575323 = path.getOrDefault("customerName")
  valid_575323 = validateParameter(valid_575323, JString, required = true,
                                 default = nil)
  if valid_575323 != nil:
    section.add "customerName", valid_575323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575324 = query.getOrDefault("api-version")
  valid_575324 = validateParameter(valid_575324, JString, required = true,
                                 default = nil)
  if valid_575324 != nil:
    section.add "api-version", valid_575324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575325: Call_BillingSubscriptionsGetByCustomerName_575318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575325.validator(path, query, header, formData, body)
  let scheme = call_575325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575325.url(scheme.get, call_575325.host, call_575325.base,
                         call_575325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575325, url, valid)

proc call*(call_575326: Call_BillingSubscriptionsGetByCustomerName_575318;
          apiVersion: string; billingAccountName: string;
          billingSubscriptionName: string; customerName: string): Recallable =
  ## billingSubscriptionsGetByCustomerName
  ## Get a single billing subscription by name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  var path_575327 = newJObject()
  var query_575328 = newJObject()
  add(query_575328, "api-version", newJString(apiVersion))
  add(path_575327, "billingAccountName", newJString(billingAccountName))
  add(path_575327, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_575327, "customerName", newJString(customerName))
  result = call_575326.call(path_575327, query_575328, nil, nil, nil)

var billingSubscriptionsGetByCustomerName* = Call_BillingSubscriptionsGetByCustomerName_575318(
    name: "billingSubscriptionsGetByCustomerName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingSubscriptions/{billingSubscriptionName}",
    validator: validate_BillingSubscriptionsGetByCustomerName_575319, base: "",
    url: url_BillingSubscriptionsGetByCustomerName_575320, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByCustomers_575329 = ref object of OpenApiRestCall_574467
proc url_BillingPermissionsListByCustomers_575331(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByCustomers_575330(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing permissions for the caller under customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575332 = path.getOrDefault("billingAccountName")
  valid_575332 = validateParameter(valid_575332, JString, required = true,
                                 default = nil)
  if valid_575332 != nil:
    section.add "billingAccountName", valid_575332
  var valid_575333 = path.getOrDefault("customerName")
  valid_575333 = validateParameter(valid_575333, JString, required = true,
                                 default = nil)
  if valid_575333 != nil:
    section.add "customerName", valid_575333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575334 = query.getOrDefault("api-version")
  valid_575334 = validateParameter(valid_575334, JString, required = true,
                                 default = nil)
  if valid_575334 != nil:
    section.add "api-version", valid_575334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575335: Call_BillingPermissionsListByCustomers_575329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under customer.
  ## 
  let valid = call_575335.validator(path, query, header, formData, body)
  let scheme = call_575335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575335.url(scheme.get, call_575335.host, call_575335.base,
                         call_575335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575335, url, valid)

proc call*(call_575336: Call_BillingPermissionsListByCustomers_575329;
          apiVersion: string; billingAccountName: string; customerName: string): Recallable =
  ## billingPermissionsListByCustomers
  ## Lists all billing permissions for the caller under customer.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  var path_575337 = newJObject()
  var query_575338 = newJObject()
  add(query_575338, "api-version", newJString(apiVersion))
  add(path_575337, "billingAccountName", newJString(billingAccountName))
  add(path_575337, "customerName", newJString(customerName))
  result = call_575336.call(path_575337, query_575338, nil, nil, nil)

var billingPermissionsListByCustomers* = Call_BillingPermissionsListByCustomers_575329(
    name: "billingPermissionsListByCustomers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByCustomers_575330, base: "",
    url: url_BillingPermissionsListByCustomers_575331, schemes: {Scheme.Https})
type
  Call_TransactionsListByCustomerName_575339 = ref object of OpenApiRestCall_574467
proc url_TransactionsListByCustomerName_575341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsListByCustomerName_575340(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575342 = path.getOrDefault("billingAccountName")
  valid_575342 = validateParameter(valid_575342, JString, required = true,
                                 default = nil)
  if valid_575342 != nil:
    section.add "billingAccountName", valid_575342
  var valid_575343 = path.getOrDefault("customerName")
  valid_575343 = validateParameter(valid_575343, JString, required = true,
                                 default = nil)
  if valid_575343 != nil:
    section.add "customerName", valid_575343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575344 = query.getOrDefault("api-version")
  valid_575344 = validateParameter(valid_575344, JString, required = true,
                                 default = nil)
  if valid_575344 != nil:
    section.add "api-version", valid_575344
  var valid_575345 = query.getOrDefault("endDate")
  valid_575345 = validateParameter(valid_575345, JString, required = true,
                                 default = nil)
  if valid_575345 != nil:
    section.add "endDate", valid_575345
  var valid_575346 = query.getOrDefault("startDate")
  valid_575346 = validateParameter(valid_575346, JString, required = true,
                                 default = nil)
  if valid_575346 != nil:
    section.add "startDate", valid_575346
  var valid_575347 = query.getOrDefault("$filter")
  valid_575347 = validateParameter(valid_575347, JString, required = false,
                                 default = nil)
  if valid_575347 != nil:
    section.add "$filter", valid_575347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575348: Call_TransactionsListByCustomerName_575339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575348.validator(path, query, header, formData, body)
  let scheme = call_575348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575348.url(scheme.get, call_575348.host, call_575348.base,
                         call_575348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575348, url, valid)

proc call*(call_575349: Call_TransactionsListByCustomerName_575339;
          apiVersion: string; endDate: string; billingAccountName: string;
          startDate: string; customerName: string; Filter: string = ""): Recallable =
  ## transactionsListByCustomerName
  ## Lists the transactions by invoice section name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   customerName: string (required)
  ##               : Customer Id.
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575350 = newJObject()
  var query_575351 = newJObject()
  add(query_575351, "api-version", newJString(apiVersion))
  add(query_575351, "endDate", newJString(endDate))
  add(path_575350, "billingAccountName", newJString(billingAccountName))
  add(query_575351, "startDate", newJString(startDate))
  add(path_575350, "customerName", newJString(customerName))
  add(query_575351, "$filter", newJString(Filter))
  result = call_575349.call(path_575350, query_575351, nil, nil, nil)

var transactionsListByCustomerName* = Call_TransactionsListByCustomerName_575339(
    name: "transactionsListByCustomerName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/transactions",
    validator: validate_TransactionsListByCustomerName_575340, base: "",
    url: url_TransactionsListByCustomerName_575341, schemes: {Scheme.Https})
type
  Call_DepartmentsListByBillingAccountName_575352 = ref object of OpenApiRestCall_574467
proc url_DepartmentsListByBillingAccountName_575354(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/departments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DepartmentsListByBillingAccountName_575353(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all departments for which a user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575355 = path.getOrDefault("billingAccountName")
  valid_575355 = validateParameter(valid_575355, JString, required = true,
                                 default = nil)
  if valid_575355 != nil:
    section.add "billingAccountName", valid_575355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the enrollmentAccounts.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575356 = query.getOrDefault("api-version")
  valid_575356 = validateParameter(valid_575356, JString, required = true,
                                 default = nil)
  if valid_575356 != nil:
    section.add "api-version", valid_575356
  var valid_575357 = query.getOrDefault("$expand")
  valid_575357 = validateParameter(valid_575357, JString, required = false,
                                 default = nil)
  if valid_575357 != nil:
    section.add "$expand", valid_575357
  var valid_575358 = query.getOrDefault("$filter")
  valid_575358 = validateParameter(valid_575358, JString, required = false,
                                 default = nil)
  if valid_575358 != nil:
    section.add "$filter", valid_575358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575359: Call_DepartmentsListByBillingAccountName_575352;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all departments for which a user has access.
  ## 
  let valid = call_575359.validator(path, query, header, formData, body)
  let scheme = call_575359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575359.url(scheme.get, call_575359.host, call_575359.base,
                         call_575359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575359, url, valid)

proc call*(call_575360: Call_DepartmentsListByBillingAccountName_575352;
          apiVersion: string; billingAccountName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## departmentsListByBillingAccountName
  ## Lists all departments for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the enrollmentAccounts.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575361 = newJObject()
  var query_575362 = newJObject()
  add(query_575362, "api-version", newJString(apiVersion))
  add(query_575362, "$expand", newJString(Expand))
  add(path_575361, "billingAccountName", newJString(billingAccountName))
  add(query_575362, "$filter", newJString(Filter))
  result = call_575360.call(path_575361, query_575362, nil, nil, nil)

var departmentsListByBillingAccountName* = Call_DepartmentsListByBillingAccountName_575352(
    name: "departmentsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/departments",
    validator: validate_DepartmentsListByBillingAccountName_575353, base: "",
    url: url_DepartmentsListByBillingAccountName_575354, schemes: {Scheme.Https})
type
  Call_DepartmentsGet_575363 = ref object of OpenApiRestCall_574467
proc url_DepartmentsGet_575365(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "departmentName" in path, "`departmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/departments/"),
               (kind: VariableSegment, value: "departmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DepartmentsGet_575364(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get the department by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   departmentName: JString (required)
  ##                 : Department Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575366 = path.getOrDefault("billingAccountName")
  valid_575366 = validateParameter(valid_575366, JString, required = true,
                                 default = nil)
  if valid_575366 != nil:
    section.add "billingAccountName", valid_575366
  var valid_575367 = path.getOrDefault("departmentName")
  valid_575367 = validateParameter(valid_575367, JString, required = true,
                                 default = nil)
  if valid_575367 != nil:
    section.add "departmentName", valid_575367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the enrollmentAccounts.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575368 = query.getOrDefault("api-version")
  valid_575368 = validateParameter(valid_575368, JString, required = true,
                                 default = nil)
  if valid_575368 != nil:
    section.add "api-version", valid_575368
  var valid_575369 = query.getOrDefault("$expand")
  valid_575369 = validateParameter(valid_575369, JString, required = false,
                                 default = nil)
  if valid_575369 != nil:
    section.add "$expand", valid_575369
  var valid_575370 = query.getOrDefault("$filter")
  valid_575370 = validateParameter(valid_575370, JString, required = false,
                                 default = nil)
  if valid_575370 != nil:
    section.add "$filter", valid_575370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575371: Call_DepartmentsGet_575363; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the department by id.
  ## 
  let valid = call_575371.validator(path, query, header, formData, body)
  let scheme = call_575371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575371.url(scheme.get, call_575371.host, call_575371.base,
                         call_575371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575371, url, valid)

proc call*(call_575372: Call_DepartmentsGet_575363; apiVersion: string;
          billingAccountName: string; departmentName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## departmentsGet
  ## Get the department by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the enrollmentAccounts.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   departmentName: string (required)
  ##                 : Department Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575373 = newJObject()
  var query_575374 = newJObject()
  add(query_575374, "api-version", newJString(apiVersion))
  add(query_575374, "$expand", newJString(Expand))
  add(path_575373, "billingAccountName", newJString(billingAccountName))
  add(path_575373, "departmentName", newJString(departmentName))
  add(query_575374, "$filter", newJString(Filter))
  result = call_575372.call(path_575373, query_575374, nil, nil, nil)

var departmentsGet* = Call_DepartmentsGet_575363(name: "departmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/departments/{departmentName}",
    validator: validate_DepartmentsGet_575364, base: "", url: url_DepartmentsGet_575365,
    schemes: {Scheme.Https})
type
  Call_EnrollmentAccountsListByBillingAccountName_575375 = ref object of OpenApiRestCall_574467
proc url_EnrollmentAccountsListByBillingAccountName_575377(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/enrollmentAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnrollmentAccountsListByBillingAccountName_575376(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Enrollment Accounts for which a user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575378 = path.getOrDefault("billingAccountName")
  valid_575378 = validateParameter(valid_575378, JString, required = true,
                                 default = nil)
  if valid_575378 != nil:
    section.add "billingAccountName", valid_575378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the department.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575379 = query.getOrDefault("api-version")
  valid_575379 = validateParameter(valid_575379, JString, required = true,
                                 default = nil)
  if valid_575379 != nil:
    section.add "api-version", valid_575379
  var valid_575380 = query.getOrDefault("$expand")
  valid_575380 = validateParameter(valid_575380, JString, required = false,
                                 default = nil)
  if valid_575380 != nil:
    section.add "$expand", valid_575380
  var valid_575381 = query.getOrDefault("$filter")
  valid_575381 = validateParameter(valid_575381, JString, required = false,
                                 default = nil)
  if valid_575381 != nil:
    section.add "$filter", valid_575381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575382: Call_EnrollmentAccountsListByBillingAccountName_575375;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Enrollment Accounts for which a user has access.
  ## 
  let valid = call_575382.validator(path, query, header, formData, body)
  let scheme = call_575382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575382.url(scheme.get, call_575382.host, call_575382.base,
                         call_575382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575382, url, valid)

proc call*(call_575383: Call_EnrollmentAccountsListByBillingAccountName_575375;
          apiVersion: string; billingAccountName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## enrollmentAccountsListByBillingAccountName
  ## Lists all Enrollment Accounts for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the department.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575384 = newJObject()
  var query_575385 = newJObject()
  add(query_575385, "api-version", newJString(apiVersion))
  add(query_575385, "$expand", newJString(Expand))
  add(path_575384, "billingAccountName", newJString(billingAccountName))
  add(query_575385, "$filter", newJString(Filter))
  result = call_575383.call(path_575384, query_575385, nil, nil, nil)

var enrollmentAccountsListByBillingAccountName* = Call_EnrollmentAccountsListByBillingAccountName_575375(
    name: "enrollmentAccountsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts",
    validator: validate_EnrollmentAccountsListByBillingAccountName_575376,
    base: "", url: url_EnrollmentAccountsListByBillingAccountName_575377,
    schemes: {Scheme.Https})
type
  Call_EnrollmentAccountsGetByEnrollmentAccountId_575386 = ref object of OpenApiRestCall_574467
proc url_EnrollmentAccountsGetByEnrollmentAccountId_575388(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "enrollmentAccountName" in path,
        "`enrollmentAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnrollmentAccountsGetByEnrollmentAccountId_575387(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the enrollment account by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   enrollmentAccountName: JString (required)
  ##                        : Enrollment Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575389 = path.getOrDefault("billingAccountName")
  valid_575389 = validateParameter(valid_575389, JString, required = true,
                                 default = nil)
  if valid_575389 != nil:
    section.add "billingAccountName", valid_575389
  var valid_575390 = path.getOrDefault("enrollmentAccountName")
  valid_575390 = validateParameter(valid_575390, JString, required = true,
                                 default = nil)
  if valid_575390 != nil:
    section.add "enrollmentAccountName", valid_575390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the Department.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575391 = query.getOrDefault("api-version")
  valid_575391 = validateParameter(valid_575391, JString, required = true,
                                 default = nil)
  if valid_575391 != nil:
    section.add "api-version", valid_575391
  var valid_575392 = query.getOrDefault("$expand")
  valid_575392 = validateParameter(valid_575392, JString, required = false,
                                 default = nil)
  if valid_575392 != nil:
    section.add "$expand", valid_575392
  var valid_575393 = query.getOrDefault("$filter")
  valid_575393 = validateParameter(valid_575393, JString, required = false,
                                 default = nil)
  if valid_575393 != nil:
    section.add "$filter", valid_575393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575394: Call_EnrollmentAccountsGetByEnrollmentAccountId_575386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the enrollment account by id.
  ## 
  let valid = call_575394.validator(path, query, header, formData, body)
  let scheme = call_575394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575394.url(scheme.get, call_575394.host, call_575394.base,
                         call_575394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575394, url, valid)

proc call*(call_575395: Call_EnrollmentAccountsGetByEnrollmentAccountId_575386;
          apiVersion: string; billingAccountName: string;
          enrollmentAccountName: string; Expand: string = ""; Filter: string = ""): Recallable =
  ## enrollmentAccountsGetByEnrollmentAccountId
  ## Get the enrollment account by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the Department.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   enrollmentAccountName: string (required)
  ##                        : Enrollment Account Id.
  var path_575396 = newJObject()
  var query_575397 = newJObject()
  add(query_575397, "api-version", newJString(apiVersion))
  add(query_575397, "$expand", newJString(Expand))
  add(path_575396, "billingAccountName", newJString(billingAccountName))
  add(query_575397, "$filter", newJString(Filter))
  add(path_575396, "enrollmentAccountName", newJString(enrollmentAccountName))
  result = call_575395.call(path_575396, query_575397, nil, nil, nil)

var enrollmentAccountsGetByEnrollmentAccountId* = Call_EnrollmentAccountsGetByEnrollmentAccountId_575386(
    name: "enrollmentAccountsGetByEnrollmentAccountId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName}",
    validator: validate_EnrollmentAccountsGetByEnrollmentAccountId_575387,
    base: "", url: url_EnrollmentAccountsGetByEnrollmentAccountId_575388,
    schemes: {Scheme.Https})
type
  Call_InvoiceSectionsCreate_575408 = ref object of OpenApiRestCall_574467
proc url_InvoiceSectionsCreate_575410(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsCreate_575409(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a InvoiceSection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575411 = path.getOrDefault("billingAccountName")
  valid_575411 = validateParameter(valid_575411, JString, required = true,
                                 default = nil)
  if valid_575411 != nil:
    section.add "billingAccountName", valid_575411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575412 = query.getOrDefault("api-version")
  valid_575412 = validateParameter(valid_575412, JString, required = true,
                                 default = nil)
  if valid_575412 != nil:
    section.add "api-version", valid_575412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create InvoiceSection operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575414: Call_InvoiceSectionsCreate_575408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a InvoiceSection.
  ## 
  let valid = call_575414.validator(path, query, header, formData, body)
  let scheme = call_575414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575414.url(scheme.get, call_575414.host, call_575414.base,
                         call_575414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575414, url, valid)

proc call*(call_575415: Call_InvoiceSectionsCreate_575408; apiVersion: string;
          billingAccountName: string; parameters: JsonNode): Recallable =
  ## invoiceSectionsCreate
  ## The operation to create a InvoiceSection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create InvoiceSection operation.
  var path_575416 = newJObject()
  var query_575417 = newJObject()
  var body_575418 = newJObject()
  add(query_575417, "api-version", newJString(apiVersion))
  add(path_575416, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_575418 = parameters
  result = call_575415.call(path_575416, query_575417, nil, nil, body_575418)

var invoiceSectionsCreate* = Call_InvoiceSectionsCreate_575408(
    name: "invoiceSectionsCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections",
    validator: validate_InvoiceSectionsCreate_575409, base: "",
    url: url_InvoiceSectionsCreate_575410, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsListByBillingAccountName_575398 = ref object of OpenApiRestCall_574467
proc url_InvoiceSectionsListByBillingAccountName_575400(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsListByBillingAccountName_575399(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all invoice sections for which a user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575401 = path.getOrDefault("billingAccountName")
  valid_575401 = validateParameter(valid_575401, JString, required = true,
                                 default = nil)
  if valid_575401 != nil:
    section.add "billingAccountName", valid_575401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575402 = query.getOrDefault("api-version")
  valid_575402 = validateParameter(valid_575402, JString, required = true,
                                 default = nil)
  if valid_575402 != nil:
    section.add "api-version", valid_575402
  var valid_575403 = query.getOrDefault("$expand")
  valid_575403 = validateParameter(valid_575403, JString, required = false,
                                 default = nil)
  if valid_575403 != nil:
    section.add "$expand", valid_575403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575404: Call_InvoiceSectionsListByBillingAccountName_575398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoice sections for which a user has access.
  ## 
  let valid = call_575404.validator(path, query, header, formData, body)
  let scheme = call_575404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575404.url(scheme.get, call_575404.host, call_575404.base,
                         call_575404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575404, url, valid)

proc call*(call_575405: Call_InvoiceSectionsListByBillingAccountName_575398;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## invoiceSectionsListByBillingAccountName
  ## Lists all invoice sections for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the billingProfiles.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575406 = newJObject()
  var query_575407 = newJObject()
  add(query_575407, "api-version", newJString(apiVersion))
  add(query_575407, "$expand", newJString(Expand))
  add(path_575406, "billingAccountName", newJString(billingAccountName))
  result = call_575405.call(path_575406, query_575407, nil, nil, nil)

var invoiceSectionsListByBillingAccountName* = Call_InvoiceSectionsListByBillingAccountName_575398(
    name: "invoiceSectionsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections",
    validator: validate_InvoiceSectionsListByBillingAccountName_575399, base: "",
    url: url_InvoiceSectionsListByBillingAccountName_575400,
    schemes: {Scheme.Https})
type
  Call_InvoiceSectionsUpdate_575430 = ref object of OpenApiRestCall_574467
proc url_InvoiceSectionsUpdate_575432(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsUpdate_575431(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a InvoiceSection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575433 = path.getOrDefault("billingAccountName")
  valid_575433 = validateParameter(valid_575433, JString, required = true,
                                 default = nil)
  if valid_575433 != nil:
    section.add "billingAccountName", valid_575433
  var valid_575434 = path.getOrDefault("invoiceSectionName")
  valid_575434 = validateParameter(valid_575434, JString, required = true,
                                 default = nil)
  if valid_575434 != nil:
    section.add "invoiceSectionName", valid_575434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575435 = query.getOrDefault("api-version")
  valid_575435 = validateParameter(valid_575435, JString, required = true,
                                 default = nil)
  if valid_575435 != nil:
    section.add "api-version", valid_575435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create InvoiceSection operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575437: Call_InvoiceSectionsUpdate_575430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a InvoiceSection.
  ## 
  let valid = call_575437.validator(path, query, header, formData, body)
  let scheme = call_575437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575437.url(scheme.get, call_575437.host, call_575437.base,
                         call_575437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575437, url, valid)

proc call*(call_575438: Call_InvoiceSectionsUpdate_575430; apiVersion: string;
          billingAccountName: string; invoiceSectionName: string;
          parameters: JsonNode): Recallable =
  ## invoiceSectionsUpdate
  ## The operation to update a InvoiceSection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create InvoiceSection operation.
  var path_575439 = newJObject()
  var query_575440 = newJObject()
  var body_575441 = newJObject()
  add(query_575440, "api-version", newJString(apiVersion))
  add(path_575439, "billingAccountName", newJString(billingAccountName))
  add(path_575439, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_575441 = parameters
  result = call_575438.call(path_575439, query_575440, nil, nil, body_575441)

var invoiceSectionsUpdate* = Call_InvoiceSectionsUpdate_575430(
    name: "invoiceSectionsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsUpdate_575431, base: "",
    url: url_InvoiceSectionsUpdate_575432, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsGet_575419 = ref object of OpenApiRestCall_574467
proc url_InvoiceSectionsGet_575421(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsGet_575420(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the InvoiceSection by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575422 = path.getOrDefault("billingAccountName")
  valid_575422 = validateParameter(valid_575422, JString, required = true,
                                 default = nil)
  if valid_575422 != nil:
    section.add "billingAccountName", valid_575422
  var valid_575423 = path.getOrDefault("invoiceSectionName")
  valid_575423 = validateParameter(valid_575423, JString, required = true,
                                 default = nil)
  if valid_575423 != nil:
    section.add "invoiceSectionName", valid_575423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575424 = query.getOrDefault("api-version")
  valid_575424 = validateParameter(valid_575424, JString, required = true,
                                 default = nil)
  if valid_575424 != nil:
    section.add "api-version", valid_575424
  var valid_575425 = query.getOrDefault("$expand")
  valid_575425 = validateParameter(valid_575425, JString, required = false,
                                 default = nil)
  if valid_575425 != nil:
    section.add "$expand", valid_575425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575426: Call_InvoiceSectionsGet_575419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the InvoiceSection by id.
  ## 
  let valid = call_575426.validator(path, query, header, formData, body)
  let scheme = call_575426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575426.url(scheme.get, call_575426.host, call_575426.base,
                         call_575426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575426, url, valid)

proc call*(call_575427: Call_InvoiceSectionsGet_575419; apiVersion: string;
          billingAccountName: string; invoiceSectionName: string;
          Expand: string = ""): Recallable =
  ## invoiceSectionsGet
  ## Get the InvoiceSection by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the billingProfiles.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_575428 = newJObject()
  var query_575429 = newJObject()
  add(query_575429, "api-version", newJString(apiVersion))
  add(query_575429, "$expand", newJString(Expand))
  add(path_575428, "billingAccountName", newJString(billingAccountName))
  add(path_575428, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_575427.call(path_575428, query_575429, nil, nil, nil)

var invoiceSectionsGet* = Call_InvoiceSectionsGet_575419(
    name: "invoiceSectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsGet_575420, base: "",
    url: url_InvoiceSectionsGet_575421, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByInvoiceSectionName_575442 = ref object of OpenApiRestCall_574467
proc url_BillingSubscriptionsListByInvoiceSectionName_575444(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsListByInvoiceSectionName_575443(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscription by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575445 = path.getOrDefault("billingAccountName")
  valid_575445 = validateParameter(valid_575445, JString, required = true,
                                 default = nil)
  if valid_575445 != nil:
    section.add "billingAccountName", valid_575445
  var valid_575446 = path.getOrDefault("invoiceSectionName")
  valid_575446 = validateParameter(valid_575446, JString, required = true,
                                 default = nil)
  if valid_575446 != nil:
    section.add "invoiceSectionName", valid_575446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575447 = query.getOrDefault("api-version")
  valid_575447 = validateParameter(valid_575447, JString, required = true,
                                 default = nil)
  if valid_575447 != nil:
    section.add "api-version", valid_575447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575448: Call_BillingSubscriptionsListByInvoiceSectionName_575442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscription by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575448.validator(path, query, header, formData, body)
  let scheme = call_575448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575448.url(scheme.get, call_575448.host, call_575448.base,
                         call_575448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575448, url, valid)

proc call*(call_575449: Call_BillingSubscriptionsListByInvoiceSectionName_575442;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingSubscriptionsListByInvoiceSectionName
  ## Lists billing subscription by invoice section name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_575450 = newJObject()
  var query_575451 = newJObject()
  add(query_575451, "api-version", newJString(apiVersion))
  add(path_575450, "billingAccountName", newJString(billingAccountName))
  add(path_575450, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_575449.call(path_575450, query_575451, nil, nil, nil)

var billingSubscriptionsListByInvoiceSectionName* = Call_BillingSubscriptionsListByInvoiceSectionName_575442(
    name: "billingSubscriptionsListByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByInvoiceSectionName_575443,
    base: "", url: url_BillingSubscriptionsListByInvoiceSectionName_575444,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsGet_575452 = ref object of OpenApiRestCall_574467
proc url_BillingSubscriptionsGet_575454(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingSubscriptionName" in path,
        "`billingSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions/"),
               (kind: VariableSegment, value: "billingSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsGet_575453(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575455 = path.getOrDefault("billingAccountName")
  valid_575455 = validateParameter(valid_575455, JString, required = true,
                                 default = nil)
  if valid_575455 != nil:
    section.add "billingAccountName", valid_575455
  var valid_575456 = path.getOrDefault("billingSubscriptionName")
  valid_575456 = validateParameter(valid_575456, JString, required = true,
                                 default = nil)
  if valid_575456 != nil:
    section.add "billingSubscriptionName", valid_575456
  var valid_575457 = path.getOrDefault("invoiceSectionName")
  valid_575457 = validateParameter(valid_575457, JString, required = true,
                                 default = nil)
  if valid_575457 != nil:
    section.add "invoiceSectionName", valid_575457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575458 = query.getOrDefault("api-version")
  valid_575458 = validateParameter(valid_575458, JString, required = true,
                                 default = nil)
  if valid_575458 != nil:
    section.add "api-version", valid_575458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575459: Call_BillingSubscriptionsGet_575452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575459.validator(path, query, header, formData, body)
  let scheme = call_575459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575459.url(scheme.get, call_575459.host, call_575459.base,
                         call_575459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575459, url, valid)

proc call*(call_575460: Call_BillingSubscriptionsGet_575452; apiVersion: string;
          billingAccountName: string; billingSubscriptionName: string;
          invoiceSectionName: string): Recallable =
  ## billingSubscriptionsGet
  ## Get a single billing subscription by name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_575461 = newJObject()
  var query_575462 = newJObject()
  add(query_575462, "api-version", newJString(apiVersion))
  add(path_575461, "billingAccountName", newJString(billingAccountName))
  add(path_575461, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_575461, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_575460.call(path_575461, query_575462, nil, nil, nil)

var billingSubscriptionsGet* = Call_BillingSubscriptionsGet_575452(
    name: "billingSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}",
    validator: validate_BillingSubscriptionsGet_575453, base: "",
    url: url_BillingSubscriptionsGet_575454, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsTransfer_575463 = ref object of OpenApiRestCall_574467
proc url_BillingSubscriptionsTransfer_575465(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingSubscriptionName" in path,
        "`billingSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions/"),
               (kind: VariableSegment, value: "billingSubscriptionName"),
               (kind: ConstantSegment, value: "/transfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsTransfer_575464(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Transfers the subscription from one invoice section to another within a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575466 = path.getOrDefault("billingAccountName")
  valid_575466 = validateParameter(valid_575466, JString, required = true,
                                 default = nil)
  if valid_575466 != nil:
    section.add "billingAccountName", valid_575466
  var valid_575467 = path.getOrDefault("billingSubscriptionName")
  valid_575467 = validateParameter(valid_575467, JString, required = true,
                                 default = nil)
  if valid_575467 != nil:
    section.add "billingSubscriptionName", valid_575467
  var valid_575468 = path.getOrDefault("invoiceSectionName")
  valid_575468 = validateParameter(valid_575468, JString, required = true,
                                 default = nil)
  if valid_575468 != nil:
    section.add "invoiceSectionName", valid_575468
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575470: Call_BillingSubscriptionsTransfer_575463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Transfers the subscription from one invoice section to another within a billing account.
  ## 
  let valid = call_575470.validator(path, query, header, formData, body)
  let scheme = call_575470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575470.url(scheme.get, call_575470.host, call_575470.base,
                         call_575470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575470, url, valid)

proc call*(call_575471: Call_BillingSubscriptionsTransfer_575463;
          billingAccountName: string; billingSubscriptionName: string;
          invoiceSectionName: string; parameters: JsonNode): Recallable =
  ## billingSubscriptionsTransfer
  ## Transfers the subscription from one invoice section to another within a billing account.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  var path_575472 = newJObject()
  var body_575473 = newJObject()
  add(path_575472, "billingAccountName", newJString(billingAccountName))
  add(path_575472, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_575472, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_575473 = parameters
  result = call_575471.call(path_575472, nil, nil, nil, body_575473)

var billingSubscriptionsTransfer* = Call_BillingSubscriptionsTransfer_575463(
    name: "billingSubscriptionsTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}/transfer",
    validator: validate_BillingSubscriptionsTransfer_575464, base: "",
    url: url_BillingSubscriptionsTransfer_575465, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsValidateTransfer_575474 = ref object of OpenApiRestCall_574467
proc url_BillingSubscriptionsValidateTransfer_575476(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingSubscriptionName" in path,
        "`billingSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions/"),
               (kind: VariableSegment, value: "billingSubscriptionName"),
               (kind: ConstantSegment, value: "/validateTransferEligibility")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsValidateTransfer_575475(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the transfer of billing subscriptions across invoice sections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575477 = path.getOrDefault("billingAccountName")
  valid_575477 = validateParameter(valid_575477, JString, required = true,
                                 default = nil)
  if valid_575477 != nil:
    section.add "billingAccountName", valid_575477
  var valid_575478 = path.getOrDefault("billingSubscriptionName")
  valid_575478 = validateParameter(valid_575478, JString, required = true,
                                 default = nil)
  if valid_575478 != nil:
    section.add "billingSubscriptionName", valid_575478
  var valid_575479 = path.getOrDefault("invoiceSectionName")
  valid_575479 = validateParameter(valid_575479, JString, required = true,
                                 default = nil)
  if valid_575479 != nil:
    section.add "invoiceSectionName", valid_575479
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575481: Call_BillingSubscriptionsValidateTransfer_575474;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates the transfer of billing subscriptions across invoice sections.
  ## 
  let valid = call_575481.validator(path, query, header, formData, body)
  let scheme = call_575481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575481.url(scheme.get, call_575481.host, call_575481.base,
                         call_575481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575481, url, valid)

proc call*(call_575482: Call_BillingSubscriptionsValidateTransfer_575474;
          billingAccountName: string; billingSubscriptionName: string;
          invoiceSectionName: string; parameters: JsonNode): Recallable =
  ## billingSubscriptionsValidateTransfer
  ## Validates the transfer of billing subscriptions across invoice sections.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  var path_575483 = newJObject()
  var body_575484 = newJObject()
  add(path_575483, "billingAccountName", newJString(billingAccountName))
  add(path_575483, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_575483, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_575484 = parameters
  result = call_575482.call(path_575483, nil, nil, nil, body_575484)

var billingSubscriptionsValidateTransfer* = Call_BillingSubscriptionsValidateTransfer_575474(
    name: "billingSubscriptionsValidateTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}/validateTransferEligibility",
    validator: validate_BillingSubscriptionsValidateTransfer_575475, base: "",
    url: url_BillingSubscriptionsValidateTransfer_575476, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsElevateToBillingProfile_575485 = ref object of OpenApiRestCall_574467
proc url_InvoiceSectionsElevateToBillingProfile_575487(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/elevate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsElevateToBillingProfile_575486(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Elevates the caller's access to match their billing profile access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575488 = path.getOrDefault("billingAccountName")
  valid_575488 = validateParameter(valid_575488, JString, required = true,
                                 default = nil)
  if valid_575488 != nil:
    section.add "billingAccountName", valid_575488
  var valid_575489 = path.getOrDefault("invoiceSectionName")
  valid_575489 = validateParameter(valid_575489, JString, required = true,
                                 default = nil)
  if valid_575489 != nil:
    section.add "invoiceSectionName", valid_575489
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575490: Call_InvoiceSectionsElevateToBillingProfile_575485;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Elevates the caller's access to match their billing profile access.
  ## 
  let valid = call_575490.validator(path, query, header, formData, body)
  let scheme = call_575490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575490.url(scheme.get, call_575490.host, call_575490.base,
                         call_575490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575490, url, valid)

proc call*(call_575491: Call_InvoiceSectionsElevateToBillingProfile_575485;
          billingAccountName: string; invoiceSectionName: string): Recallable =
  ## invoiceSectionsElevateToBillingProfile
  ## Elevates the caller's access to match their billing profile access.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_575492 = newJObject()
  add(path_575492, "billingAccountName", newJString(billingAccountName))
  add(path_575492, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_575491.call(path_575492, nil, nil, nil, nil)

var invoiceSectionsElevateToBillingProfile* = Call_InvoiceSectionsElevateToBillingProfile_575485(
    name: "invoiceSectionsElevateToBillingProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/elevate",
    validator: validate_InvoiceSectionsElevateToBillingProfile_575486, base: "",
    url: url_InvoiceSectionsElevateToBillingProfile_575487,
    schemes: {Scheme.Https})
type
  Call_TransfersInitiate_575493 = ref object of OpenApiRestCall_574467
proc url_TransfersInitiate_575495(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/initiateTransfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersInitiate_575494(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575496 = path.getOrDefault("billingAccountName")
  valid_575496 = validateParameter(valid_575496, JString, required = true,
                                 default = nil)
  if valid_575496 != nil:
    section.add "billingAccountName", valid_575496
  var valid_575497 = path.getOrDefault("invoiceSectionName")
  valid_575497 = validateParameter(valid_575497, JString, required = true,
                                 default = nil)
  if valid_575497 != nil:
    section.add "invoiceSectionName", valid_575497
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Initiate transfer parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575499: Call_TransfersInitiate_575493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  let valid = call_575499.validator(path, query, header, formData, body)
  let scheme = call_575499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575499.url(scheme.get, call_575499.host, call_575499.base,
                         call_575499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575499, url, valid)

proc call*(call_575500: Call_TransfersInitiate_575493; billingAccountName: string;
          invoiceSectionName: string; body: JsonNode): Recallable =
  ## transfersInitiate
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   body: JObject (required)
  ##       : Initiate transfer parameters.
  var path_575501 = newJObject()
  var body_575502 = newJObject()
  add(path_575501, "billingAccountName", newJString(billingAccountName))
  add(path_575501, "invoiceSectionName", newJString(invoiceSectionName))
  if body != nil:
    body_575502 = body
  result = call_575500.call(path_575501, nil, nil, nil, body_575502)

var transfersInitiate* = Call_TransfersInitiate_575493(name: "transfersInitiate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/initiateTransfer",
    validator: validate_TransfersInitiate_575494, base: "",
    url: url_TransfersInitiate_575495, schemes: {Scheme.Https})
type
  Call_ProductsListByInvoiceSectionName_575503 = ref object of OpenApiRestCall_574467
proc url_ProductsListByInvoiceSectionName_575505(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsListByInvoiceSectionName_575504(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists products by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575506 = path.getOrDefault("billingAccountName")
  valid_575506 = validateParameter(valid_575506, JString, required = true,
                                 default = nil)
  if valid_575506 != nil:
    section.add "billingAccountName", valid_575506
  var valid_575507 = path.getOrDefault("invoiceSectionName")
  valid_575507 = validateParameter(valid_575507, JString, required = true,
                                 default = nil)
  if valid_575507 != nil:
    section.add "invoiceSectionName", valid_575507
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575508 = query.getOrDefault("api-version")
  valid_575508 = validateParameter(valid_575508, JString, required = true,
                                 default = nil)
  if valid_575508 != nil:
    section.add "api-version", valid_575508
  var valid_575509 = query.getOrDefault("$filter")
  valid_575509 = validateParameter(valid_575509, JString, required = false,
                                 default = nil)
  if valid_575509 != nil:
    section.add "$filter", valid_575509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575510: Call_ProductsListByInvoiceSectionName_575503;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists products by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575510.validator(path, query, header, formData, body)
  let scheme = call_575510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575510.url(scheme.get, call_575510.host, call_575510.base,
                         call_575510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575510, url, valid)

proc call*(call_575511: Call_ProductsListByInvoiceSectionName_575503;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; Filter: string = ""): Recallable =
  ## productsListByInvoiceSectionName
  ## Lists products by invoice section name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   Filter: string
  ##         : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575512 = newJObject()
  var query_575513 = newJObject()
  add(query_575513, "api-version", newJString(apiVersion))
  add(path_575512, "billingAccountName", newJString(billingAccountName))
  add(path_575512, "invoiceSectionName", newJString(invoiceSectionName))
  add(query_575513, "$filter", newJString(Filter))
  result = call_575511.call(path_575512, query_575513, nil, nil, nil)

var productsListByInvoiceSectionName* = Call_ProductsListByInvoiceSectionName_575503(
    name: "productsListByInvoiceSectionName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products",
    validator: validate_ProductsListByInvoiceSectionName_575504, base: "",
    url: url_ProductsListByInvoiceSectionName_575505, schemes: {Scheme.Https})
type
  Call_ProductsGet_575514 = ref object of OpenApiRestCall_574467
proc url_ProductsGet_575516(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsGet_575515(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_575517 = path.getOrDefault("productName")
  valid_575517 = validateParameter(valid_575517, JString, required = true,
                                 default = nil)
  if valid_575517 != nil:
    section.add "productName", valid_575517
  var valid_575518 = path.getOrDefault("billingAccountName")
  valid_575518 = validateParameter(valid_575518, JString, required = true,
                                 default = nil)
  if valid_575518 != nil:
    section.add "billingAccountName", valid_575518
  var valid_575519 = path.getOrDefault("invoiceSectionName")
  valid_575519 = validateParameter(valid_575519, JString, required = true,
                                 default = nil)
  if valid_575519 != nil:
    section.add "invoiceSectionName", valid_575519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575520 = query.getOrDefault("api-version")
  valid_575520 = validateParameter(valid_575520, JString, required = true,
                                 default = nil)
  if valid_575520 != nil:
    section.add "api-version", valid_575520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575521: Call_ProductsGet_575514; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575521.validator(path, query, header, formData, body)
  let scheme = call_575521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575521.url(scheme.get, call_575521.host, call_575521.base,
                         call_575521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575521, url, valid)

proc call*(call_575522: Call_ProductsGet_575514; productName: string;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## productsGet
  ## Get a single product by name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_575523 = newJObject()
  var query_575524 = newJObject()
  add(path_575523, "productName", newJString(productName))
  add(query_575524, "api-version", newJString(apiVersion))
  add(path_575523, "billingAccountName", newJString(billingAccountName))
  add(path_575523, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_575522.call(path_575523, query_575524, nil, nil, nil)

var productsGet* = Call_ProductsGet_575514(name: "productsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}",
                                        validator: validate_ProductsGet_575515,
                                        base: "", url: url_ProductsGet_575516,
                                        schemes: {Scheme.Https})
type
  Call_ProductsTransfer_575525 = ref object of OpenApiRestCall_574467
proc url_ProductsTransfer_575527(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/transfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsTransfer_575526(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The operation to transfer a Product to another invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_575528 = path.getOrDefault("productName")
  valid_575528 = validateParameter(valid_575528, JString, required = true,
                                 default = nil)
  if valid_575528 != nil:
    section.add "productName", valid_575528
  var valid_575529 = path.getOrDefault("billingAccountName")
  valid_575529 = validateParameter(valid_575529, JString, required = true,
                                 default = nil)
  if valid_575529 != nil:
    section.add "billingAccountName", valid_575529
  var valid_575530 = path.getOrDefault("invoiceSectionName")
  valid_575530 = validateParameter(valid_575530, JString, required = true,
                                 default = nil)
  if valid_575530 != nil:
    section.add "invoiceSectionName", valid_575530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575531 = query.getOrDefault("api-version")
  valid_575531 = validateParameter(valid_575531, JString, required = true,
                                 default = nil)
  if valid_575531 != nil:
    section.add "api-version", valid_575531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Product operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575533: Call_ProductsTransfer_575525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to transfer a Product to another invoice section.
  ## 
  let valid = call_575533.validator(path, query, header, formData, body)
  let scheme = call_575533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575533.url(scheme.get, call_575533.host, call_575533.base,
                         call_575533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575533, url, valid)

proc call*(call_575534: Call_ProductsTransfer_575525; productName: string;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; parameters: JsonNode): Recallable =
  ## productsTransfer
  ## The operation to transfer a Product to another invoice section.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Product operation.
  var path_575535 = newJObject()
  var query_575536 = newJObject()
  var body_575537 = newJObject()
  add(path_575535, "productName", newJString(productName))
  add(query_575536, "api-version", newJString(apiVersion))
  add(path_575535, "billingAccountName", newJString(billingAccountName))
  add(path_575535, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_575537 = parameters
  result = call_575534.call(path_575535, query_575536, nil, nil, body_575537)

var productsTransfer* = Call_ProductsTransfer_575525(name: "productsTransfer",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}/transfer",
    validator: validate_ProductsTransfer_575526, base: "",
    url: url_ProductsTransfer_575527, schemes: {Scheme.Https})
type
  Call_ProductsUpdateAutoRenewByInvoiceSectionName_575538 = ref object of OpenApiRestCall_574467
proc url_ProductsUpdateAutoRenewByInvoiceSectionName_575540(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/updateAutoRenew")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsUpdateAutoRenewByInvoiceSectionName_575539(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel auto renew for product by product id and invoice section name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_575541 = path.getOrDefault("productName")
  valid_575541 = validateParameter(valid_575541, JString, required = true,
                                 default = nil)
  if valid_575541 != nil:
    section.add "productName", valid_575541
  var valid_575542 = path.getOrDefault("billingAccountName")
  valid_575542 = validateParameter(valid_575542, JString, required = true,
                                 default = nil)
  if valid_575542 != nil:
    section.add "billingAccountName", valid_575542
  var valid_575543 = path.getOrDefault("invoiceSectionName")
  valid_575543 = validateParameter(valid_575543, JString, required = true,
                                 default = nil)
  if valid_575543 != nil:
    section.add "invoiceSectionName", valid_575543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575544 = query.getOrDefault("api-version")
  valid_575544 = validateParameter(valid_575544, JString, required = true,
                                 default = nil)
  if valid_575544 != nil:
    section.add "api-version", valid_575544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575546: Call_ProductsUpdateAutoRenewByInvoiceSectionName_575538;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancel auto renew for product by product id and invoice section name
  ## 
  let valid = call_575546.validator(path, query, header, formData, body)
  let scheme = call_575546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575546.url(scheme.get, call_575546.host, call_575546.base,
                         call_575546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575546, url, valid)

proc call*(call_575547: Call_ProductsUpdateAutoRenewByInvoiceSectionName_575538;
          productName: string; apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; body: JsonNode): Recallable =
  ## productsUpdateAutoRenewByInvoiceSectionName
  ## Cancel auto renew for product by product id and invoice section name
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  var path_575548 = newJObject()
  var query_575549 = newJObject()
  var body_575550 = newJObject()
  add(path_575548, "productName", newJString(productName))
  add(query_575549, "api-version", newJString(apiVersion))
  add(path_575548, "billingAccountName", newJString(billingAccountName))
  add(path_575548, "invoiceSectionName", newJString(invoiceSectionName))
  if body != nil:
    body_575550 = body
  result = call_575547.call(path_575548, query_575549, nil, nil, body_575550)

var productsUpdateAutoRenewByInvoiceSectionName* = Call_ProductsUpdateAutoRenewByInvoiceSectionName_575538(
    name: "productsUpdateAutoRenewByInvoiceSectionName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}/updateAutoRenew",
    validator: validate_ProductsUpdateAutoRenewByInvoiceSectionName_575539,
    base: "", url: url_ProductsUpdateAutoRenewByInvoiceSectionName_575540,
    schemes: {Scheme.Https})
type
  Call_ProductsValidateTransfer_575551 = ref object of OpenApiRestCall_574467
proc url_ProductsValidateTransfer_575553(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/validateTransferEligibility")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsValidateTransfer_575552(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the transfer of products across invoice sections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_575554 = path.getOrDefault("productName")
  valid_575554 = validateParameter(valid_575554, JString, required = true,
                                 default = nil)
  if valid_575554 != nil:
    section.add "productName", valid_575554
  var valid_575555 = path.getOrDefault("billingAccountName")
  valid_575555 = validateParameter(valid_575555, JString, required = true,
                                 default = nil)
  if valid_575555 != nil:
    section.add "billingAccountName", valid_575555
  var valid_575556 = path.getOrDefault("invoiceSectionName")
  valid_575556 = validateParameter(valid_575556, JString, required = true,
                                 default = nil)
  if valid_575556 != nil:
    section.add "invoiceSectionName", valid_575556
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Products operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575558: Call_ProductsValidateTransfer_575551; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the transfer of products across invoice sections.
  ## 
  let valid = call_575558.validator(path, query, header, formData, body)
  let scheme = call_575558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575558.url(scheme.get, call_575558.host, call_575558.base,
                         call_575558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575558, url, valid)

proc call*(call_575559: Call_ProductsValidateTransfer_575551; productName: string;
          billingAccountName: string; invoiceSectionName: string;
          parameters: JsonNode): Recallable =
  ## productsValidateTransfer
  ## Validates the transfer of products across invoice sections.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Products operation.
  var path_575560 = newJObject()
  var body_575561 = newJObject()
  add(path_575560, "productName", newJString(productName))
  add(path_575560, "billingAccountName", newJString(billingAccountName))
  add(path_575560, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_575561 = parameters
  result = call_575559.call(path_575560, nil, nil, nil, body_575561)

var productsValidateTransfer* = Call_ProductsValidateTransfer_575551(
    name: "productsValidateTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}/validateTransferEligibility",
    validator: validate_ProductsValidateTransfer_575552, base: "",
    url: url_ProductsValidateTransfer_575553, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByInvoiceSections_575562 = ref object of OpenApiRestCall_574467
proc url_BillingPermissionsListByInvoiceSections_575564(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByInvoiceSections_575563(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing permissions for the caller under invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575565 = path.getOrDefault("billingAccountName")
  valid_575565 = validateParameter(valid_575565, JString, required = true,
                                 default = nil)
  if valid_575565 != nil:
    section.add "billingAccountName", valid_575565
  var valid_575566 = path.getOrDefault("invoiceSectionName")
  valid_575566 = validateParameter(valid_575566, JString, required = true,
                                 default = nil)
  if valid_575566 != nil:
    section.add "invoiceSectionName", valid_575566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575567 = query.getOrDefault("api-version")
  valid_575567 = validateParameter(valid_575567, JString, required = true,
                                 default = nil)
  if valid_575567 != nil:
    section.add "api-version", valid_575567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575568: Call_BillingPermissionsListByInvoiceSections_575562;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under invoice section.
  ## 
  let valid = call_575568.validator(path, query, header, formData, body)
  let scheme = call_575568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575568.url(scheme.get, call_575568.host, call_575568.base,
                         call_575568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575568, url, valid)

proc call*(call_575569: Call_BillingPermissionsListByInvoiceSections_575562;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingPermissionsListByInvoiceSections
  ## Lists all billing permissions for the caller under invoice section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_575570 = newJObject()
  var query_575571 = newJObject()
  add(query_575571, "api-version", newJString(apiVersion))
  add(path_575570, "billingAccountName", newJString(billingAccountName))
  add(path_575570, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_575569.call(path_575570, query_575571, nil, nil, nil)

var billingPermissionsListByInvoiceSections* = Call_BillingPermissionsListByInvoiceSections_575562(
    name: "billingPermissionsListByInvoiceSections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByInvoiceSections_575563, base: "",
    url: url_BillingPermissionsListByInvoiceSections_575564,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByInvoiceSectionName_575572 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsListByInvoiceSectionName_575574(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsListByInvoiceSectionName_575573(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignments on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575575 = path.getOrDefault("billingAccountName")
  valid_575575 = validateParameter(valid_575575, JString, required = true,
                                 default = nil)
  if valid_575575 != nil:
    section.add "billingAccountName", valid_575575
  var valid_575576 = path.getOrDefault("invoiceSectionName")
  valid_575576 = validateParameter(valid_575576, JString, required = true,
                                 default = nil)
  if valid_575576 != nil:
    section.add "invoiceSectionName", valid_575576
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575577 = query.getOrDefault("api-version")
  valid_575577 = validateParameter(valid_575577, JString, required = true,
                                 default = nil)
  if valid_575577 != nil:
    section.add "api-version", valid_575577
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575578: Call_BillingRoleAssignmentsListByInvoiceSectionName_575572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the invoice Section
  ## 
  let valid = call_575578.validator(path, query, header, formData, body)
  let scheme = call_575578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575578.url(scheme.get, call_575578.host, call_575578.base,
                         call_575578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575578, url, valid)

proc call*(call_575579: Call_BillingRoleAssignmentsListByInvoiceSectionName_575572;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsListByInvoiceSectionName
  ## Get the role assignments on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_575580 = newJObject()
  var query_575581 = newJObject()
  add(query_575581, "api-version", newJString(apiVersion))
  add(path_575580, "billingAccountName", newJString(billingAccountName))
  add(path_575580, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_575579.call(path_575580, query_575581, nil, nil, nil)

var billingRoleAssignmentsListByInvoiceSectionName* = Call_BillingRoleAssignmentsListByInvoiceSectionName_575572(
    name: "billingRoleAssignmentsListByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByInvoiceSectionName_575573,
    base: "", url: url_BillingRoleAssignmentsListByInvoiceSectionName_575574,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByInvoiceSectionName_575582 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsGetByInvoiceSectionName_575584(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsGetByInvoiceSectionName_575583(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignment for the caller on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_575585 = path.getOrDefault("billingRoleAssignmentName")
  valid_575585 = validateParameter(valid_575585, JString, required = true,
                                 default = nil)
  if valid_575585 != nil:
    section.add "billingRoleAssignmentName", valid_575585
  var valid_575586 = path.getOrDefault("billingAccountName")
  valid_575586 = validateParameter(valid_575586, JString, required = true,
                                 default = nil)
  if valid_575586 != nil:
    section.add "billingAccountName", valid_575586
  var valid_575587 = path.getOrDefault("invoiceSectionName")
  valid_575587 = validateParameter(valid_575587, JString, required = true,
                                 default = nil)
  if valid_575587 != nil:
    section.add "invoiceSectionName", valid_575587
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575588 = query.getOrDefault("api-version")
  valid_575588 = validateParameter(valid_575588, JString, required = true,
                                 default = nil)
  if valid_575588 != nil:
    section.add "api-version", valid_575588
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575589: Call_BillingRoleAssignmentsGetByInvoiceSectionName_575582;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller on the invoice Section
  ## 
  let valid = call_575589.validator(path, query, header, formData, body)
  let scheme = call_575589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575589.url(scheme.get, call_575589.host, call_575589.base,
                         call_575589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575589, url, valid)

proc call*(call_575590: Call_BillingRoleAssignmentsGetByInvoiceSectionName_575582;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsGetByInvoiceSectionName
  ## Get the role assignment for the caller on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_575591 = newJObject()
  var query_575592 = newJObject()
  add(query_575592, "api-version", newJString(apiVersion))
  add(path_575591, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_575591, "billingAccountName", newJString(billingAccountName))
  add(path_575591, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_575590.call(path_575591, query_575592, nil, nil, nil)

var billingRoleAssignmentsGetByInvoiceSectionName* = Call_BillingRoleAssignmentsGetByInvoiceSectionName_575582(
    name: "billingRoleAssignmentsGetByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByInvoiceSectionName_575583,
    base: "", url: url_BillingRoleAssignmentsGetByInvoiceSectionName_575584,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_575593 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsDeleteByInvoiceSectionName_575595(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsDeleteByInvoiceSectionName_575594(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete the role assignment on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_575596 = path.getOrDefault("billingRoleAssignmentName")
  valid_575596 = validateParameter(valid_575596, JString, required = true,
                                 default = nil)
  if valid_575596 != nil:
    section.add "billingRoleAssignmentName", valid_575596
  var valid_575597 = path.getOrDefault("billingAccountName")
  valid_575597 = validateParameter(valid_575597, JString, required = true,
                                 default = nil)
  if valid_575597 != nil:
    section.add "billingAccountName", valid_575597
  var valid_575598 = path.getOrDefault("invoiceSectionName")
  valid_575598 = validateParameter(valid_575598, JString, required = true,
                                 default = nil)
  if valid_575598 != nil:
    section.add "invoiceSectionName", valid_575598
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575599 = query.getOrDefault("api-version")
  valid_575599 = validateParameter(valid_575599, JString, required = true,
                                 default = nil)
  if valid_575599 != nil:
    section.add "api-version", valid_575599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575600: Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_575593;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on the invoice Section
  ## 
  let valid = call_575600.validator(path, query, header, formData, body)
  let scheme = call_575600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575600.url(scheme.get, call_575600.host, call_575600.base,
                         call_575600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575600, url, valid)

proc call*(call_575601: Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_575593;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsDeleteByInvoiceSectionName
  ## Delete the role assignment on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_575602 = newJObject()
  var query_575603 = newJObject()
  add(query_575603, "api-version", newJString(apiVersion))
  add(path_575602, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_575602, "billingAccountName", newJString(billingAccountName))
  add(path_575602, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_575601.call(path_575602, query_575603, nil, nil, nil)

var billingRoleAssignmentsDeleteByInvoiceSectionName* = Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_575593(
    name: "billingRoleAssignmentsDeleteByInvoiceSectionName",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByInvoiceSectionName_575594,
    base: "", url: url_BillingRoleAssignmentsDeleteByInvoiceSectionName_575595,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByInvoiceSectionName_575604 = ref object of OpenApiRestCall_574467
proc url_BillingRoleDefinitionsListByInvoiceSectionName_575606(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsListByInvoiceSectionName_575605(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the role definition for an invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575607 = path.getOrDefault("billingAccountName")
  valid_575607 = validateParameter(valid_575607, JString, required = true,
                                 default = nil)
  if valid_575607 != nil:
    section.add "billingAccountName", valid_575607
  var valid_575608 = path.getOrDefault("invoiceSectionName")
  valid_575608 = validateParameter(valid_575608, JString, required = true,
                                 default = nil)
  if valid_575608 != nil:
    section.add "invoiceSectionName", valid_575608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575609 = query.getOrDefault("api-version")
  valid_575609 = validateParameter(valid_575609, JString, required = true,
                                 default = nil)
  if valid_575609 != nil:
    section.add "api-version", valid_575609
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575610: Call_BillingRoleDefinitionsListByInvoiceSectionName_575604;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for an invoice Section
  ## 
  let valid = call_575610.validator(path, query, header, formData, body)
  let scheme = call_575610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575610.url(scheme.get, call_575610.host, call_575610.base,
                         call_575610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575610, url, valid)

proc call*(call_575611: Call_BillingRoleDefinitionsListByInvoiceSectionName_575604;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingRoleDefinitionsListByInvoiceSectionName
  ## Lists the role definition for an invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_575612 = newJObject()
  var query_575613 = newJObject()
  add(query_575613, "api-version", newJString(apiVersion))
  add(path_575612, "billingAccountName", newJString(billingAccountName))
  add(path_575612, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_575611.call(path_575612, query_575613, nil, nil, nil)

var billingRoleDefinitionsListByInvoiceSectionName* = Call_BillingRoleDefinitionsListByInvoiceSectionName_575604(
    name: "billingRoleDefinitionsListByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByInvoiceSectionName_575605,
    base: "", url: url_BillingRoleDefinitionsListByInvoiceSectionName_575606,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByInvoiceSectionName_575614 = ref object of OpenApiRestCall_574467
proc url_BillingRoleDefinitionsGetByInvoiceSectionName_575616(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingRoleDefinitionName" in path,
        "`billingRoleDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleDefinitions/"),
               (kind: VariableSegment, value: "billingRoleDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsGetByInvoiceSectionName_575615(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the role definition for a role
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingRoleDefinitionName: JString (required)
  ##                            : role definition id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575617 = path.getOrDefault("billingAccountName")
  valid_575617 = validateParameter(valid_575617, JString, required = true,
                                 default = nil)
  if valid_575617 != nil:
    section.add "billingAccountName", valid_575617
  var valid_575618 = path.getOrDefault("invoiceSectionName")
  valid_575618 = validateParameter(valid_575618, JString, required = true,
                                 default = nil)
  if valid_575618 != nil:
    section.add "invoiceSectionName", valid_575618
  var valid_575619 = path.getOrDefault("billingRoleDefinitionName")
  valid_575619 = validateParameter(valid_575619, JString, required = true,
                                 default = nil)
  if valid_575619 != nil:
    section.add "billingRoleDefinitionName", valid_575619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575620 = query.getOrDefault("api-version")
  valid_575620 = validateParameter(valid_575620, JString, required = true,
                                 default = nil)
  if valid_575620 != nil:
    section.add "api-version", valid_575620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575621: Call_BillingRoleDefinitionsGetByInvoiceSectionName_575614;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_575621.validator(path, query, header, formData, body)
  let scheme = call_575621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575621.url(scheme.get, call_575621.host, call_575621.base,
                         call_575621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575621, url, valid)

proc call*(call_575622: Call_BillingRoleDefinitionsGetByInvoiceSectionName_575614;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingRoleDefinitionName: string): Recallable =
  ## billingRoleDefinitionsGetByInvoiceSectionName
  ## Gets the role definition for a role
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingRoleDefinitionName: string (required)
  ##                            : role definition id.
  var path_575623 = newJObject()
  var query_575624 = newJObject()
  add(query_575624, "api-version", newJString(apiVersion))
  add(path_575623, "billingAccountName", newJString(billingAccountName))
  add(path_575623, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_575623, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  result = call_575622.call(path_575623, query_575624, nil, nil, nil)

var billingRoleDefinitionsGetByInvoiceSectionName* = Call_BillingRoleDefinitionsGetByInvoiceSectionName_575614(
    name: "billingRoleDefinitionsGetByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByInvoiceSectionName_575615,
    base: "", url: url_BillingRoleDefinitionsGetByInvoiceSectionName_575616,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByInvoiceSectionName_575625 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsAddByInvoiceSectionName_575627(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/createBillingRoleAssignment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsAddByInvoiceSectionName_575626(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to add a role assignment to a invoice Section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575628 = path.getOrDefault("billingAccountName")
  valid_575628 = validateParameter(valid_575628, JString, required = true,
                                 default = nil)
  if valid_575628 != nil:
    section.add "billingAccountName", valid_575628
  var valid_575629 = path.getOrDefault("invoiceSectionName")
  valid_575629 = validateParameter(valid_575629, JString, required = true,
                                 default = nil)
  if valid_575629 != nil:
    section.add "invoiceSectionName", valid_575629
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575630 = query.getOrDefault("api-version")
  valid_575630 = validateParameter(valid_575630, JString, required = true,
                                 default = nil)
  if valid_575630 != nil:
    section.add "api-version", valid_575630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575632: Call_BillingRoleAssignmentsAddByInvoiceSectionName_575625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a invoice Section.
  ## 
  let valid = call_575632.validator(path, query, header, formData, body)
  let scheme = call_575632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575632.url(scheme.get, call_575632.host, call_575632.base,
                         call_575632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575632, url, valid)

proc call*(call_575633: Call_BillingRoleAssignmentsAddByInvoiceSectionName_575625;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; parameters: JsonNode): Recallable =
  ## billingRoleAssignmentsAddByInvoiceSectionName
  ## The operation to add a role assignment to a invoice Section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  var path_575634 = newJObject()
  var query_575635 = newJObject()
  var body_575636 = newJObject()
  add(query_575635, "api-version", newJString(apiVersion))
  add(path_575634, "billingAccountName", newJString(billingAccountName))
  add(path_575634, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_575636 = parameters
  result = call_575633.call(path_575634, query_575635, nil, nil, body_575636)

var billingRoleAssignmentsAddByInvoiceSectionName* = Call_BillingRoleAssignmentsAddByInvoiceSectionName_575625(
    name: "billingRoleAssignmentsAddByInvoiceSectionName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByInvoiceSectionName_575626,
    base: "", url: url_BillingRoleAssignmentsAddByInvoiceSectionName_575627,
    schemes: {Scheme.Https})
type
  Call_TransactionsListByInvoiceSectionName_575637 = ref object of OpenApiRestCall_574467
proc url_TransactionsListByInvoiceSectionName_575639(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsListByInvoiceSectionName_575638(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575640 = path.getOrDefault("billingAccountName")
  valid_575640 = validateParameter(valid_575640, JString, required = true,
                                 default = nil)
  if valid_575640 != nil:
    section.add "billingAccountName", valid_575640
  var valid_575641 = path.getOrDefault("invoiceSectionName")
  valid_575641 = validateParameter(valid_575641, JString, required = true,
                                 default = nil)
  if valid_575641 != nil:
    section.add "invoiceSectionName", valid_575641
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575642 = query.getOrDefault("api-version")
  valid_575642 = validateParameter(valid_575642, JString, required = true,
                                 default = nil)
  if valid_575642 != nil:
    section.add "api-version", valid_575642
  var valid_575643 = query.getOrDefault("endDate")
  valid_575643 = validateParameter(valid_575643, JString, required = true,
                                 default = nil)
  if valid_575643 != nil:
    section.add "endDate", valid_575643
  var valid_575644 = query.getOrDefault("startDate")
  valid_575644 = validateParameter(valid_575644, JString, required = true,
                                 default = nil)
  if valid_575644 != nil:
    section.add "startDate", valid_575644
  var valid_575645 = query.getOrDefault("$filter")
  valid_575645 = validateParameter(valid_575645, JString, required = false,
                                 default = nil)
  if valid_575645 != nil:
    section.add "$filter", valid_575645
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575646: Call_TransactionsListByInvoiceSectionName_575637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575646.validator(path, query, header, formData, body)
  let scheme = call_575646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575646.url(scheme.get, call_575646.host, call_575646.base,
                         call_575646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575646, url, valid)

proc call*(call_575647: Call_TransactionsListByInvoiceSectionName_575637;
          apiVersion: string; endDate: string; billingAccountName: string;
          startDate: string; invoiceSectionName: string; Filter: string = ""): Recallable =
  ## transactionsListByInvoiceSectionName
  ## Lists the transactions by invoice section name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575648 = newJObject()
  var query_575649 = newJObject()
  add(query_575649, "api-version", newJString(apiVersion))
  add(query_575649, "endDate", newJString(endDate))
  add(path_575648, "billingAccountName", newJString(billingAccountName))
  add(query_575649, "startDate", newJString(startDate))
  add(path_575648, "invoiceSectionName", newJString(invoiceSectionName))
  add(query_575649, "$filter", newJString(Filter))
  result = call_575647.call(path_575648, query_575649, nil, nil, nil)

var transactionsListByInvoiceSectionName* = Call_TransactionsListByInvoiceSectionName_575637(
    name: "transactionsListByInvoiceSectionName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transactions",
    validator: validate_TransactionsListByInvoiceSectionName_575638, base: "",
    url: url_TransactionsListByInvoiceSectionName_575639, schemes: {Scheme.Https})
type
  Call_TransfersList_575650 = ref object of OpenApiRestCall_574467
proc url_TransfersList_575652(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transfers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersList_575651(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575653 = path.getOrDefault("billingAccountName")
  valid_575653 = validateParameter(valid_575653, JString, required = true,
                                 default = nil)
  if valid_575653 != nil:
    section.add "billingAccountName", valid_575653
  var valid_575654 = path.getOrDefault("invoiceSectionName")
  valid_575654 = validateParameter(valid_575654, JString, required = true,
                                 default = nil)
  if valid_575654 != nil:
    section.add "invoiceSectionName", valid_575654
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575655: Call_TransfersList_575650; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  let valid = call_575655.validator(path, query, header, formData, body)
  let scheme = call_575655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575655.url(scheme.get, call_575655.host, call_575655.base,
                         call_575655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575655, url, valid)

proc call*(call_575656: Call_TransfersList_575650; billingAccountName: string;
          invoiceSectionName: string): Recallable =
  ## transfersList
  ## Lists all transfer's details initiated from given invoice section.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_575657 = newJObject()
  add(path_575657, "billingAccountName", newJString(billingAccountName))
  add(path_575657, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_575656.call(path_575657, nil, nil, nil, nil)

var transfersList* = Call_TransfersList_575650(name: "transfersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transfers",
    validator: validate_TransfersList_575651, base: "", url: url_TransfersList_575652,
    schemes: {Scheme.Https})
type
  Call_TransfersGet_575658 = ref object of OpenApiRestCall_574467
proc url_TransfersGet_575660(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transfers/"),
               (kind: VariableSegment, value: "transferName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersGet_575659(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the transfer details for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575661 = path.getOrDefault("billingAccountName")
  valid_575661 = validateParameter(valid_575661, JString, required = true,
                                 default = nil)
  if valid_575661 != nil:
    section.add "billingAccountName", valid_575661
  var valid_575662 = path.getOrDefault("invoiceSectionName")
  valid_575662 = validateParameter(valid_575662, JString, required = true,
                                 default = nil)
  if valid_575662 != nil:
    section.add "invoiceSectionName", valid_575662
  var valid_575663 = path.getOrDefault("transferName")
  valid_575663 = validateParameter(valid_575663, JString, required = true,
                                 default = nil)
  if valid_575663 != nil:
    section.add "transferName", valid_575663
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575664: Call_TransfersGet_575658; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the transfer details for given transfer Id.
  ## 
  let valid = call_575664.validator(path, query, header, formData, body)
  let scheme = call_575664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575664.url(scheme.get, call_575664.host, call_575664.base,
                         call_575664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575664, url, valid)

proc call*(call_575665: Call_TransfersGet_575658; billingAccountName: string;
          invoiceSectionName: string; transferName: string): Recallable =
  ## transfersGet
  ## Gets the transfer details for given transfer Id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_575666 = newJObject()
  add(path_575666, "billingAccountName", newJString(billingAccountName))
  add(path_575666, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_575666, "transferName", newJString(transferName))
  result = call_575665.call(path_575666, nil, nil, nil, nil)

var transfersGet* = Call_TransfersGet_575658(name: "transfersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transfers/{transferName}",
    validator: validate_TransfersGet_575659, base: "", url: url_TransfersGet_575660,
    schemes: {Scheme.Https})
type
  Call_TransfersCancel_575667 = ref object of OpenApiRestCall_574467
proc url_TransfersCancel_575669(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transfers/"),
               (kind: VariableSegment, value: "transferName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersCancel_575668(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Cancels the transfer for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575670 = path.getOrDefault("billingAccountName")
  valid_575670 = validateParameter(valid_575670, JString, required = true,
                                 default = nil)
  if valid_575670 != nil:
    section.add "billingAccountName", valid_575670
  var valid_575671 = path.getOrDefault("invoiceSectionName")
  valid_575671 = validateParameter(valid_575671, JString, required = true,
                                 default = nil)
  if valid_575671 != nil:
    section.add "invoiceSectionName", valid_575671
  var valid_575672 = path.getOrDefault("transferName")
  valid_575672 = validateParameter(valid_575672, JString, required = true,
                                 default = nil)
  if valid_575672 != nil:
    section.add "transferName", valid_575672
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575673: Call_TransfersCancel_575667; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the transfer for given transfer Id.
  ## 
  let valid = call_575673.validator(path, query, header, formData, body)
  let scheme = call_575673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575673.url(scheme.get, call_575673.host, call_575673.base,
                         call_575673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575673, url, valid)

proc call*(call_575674: Call_TransfersCancel_575667; billingAccountName: string;
          invoiceSectionName: string; transferName: string): Recallable =
  ## transfersCancel
  ## Cancels the transfer for given transfer Id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_575675 = newJObject()
  add(path_575675, "billingAccountName", newJString(billingAccountName))
  add(path_575675, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_575675, "transferName", newJString(transferName))
  result = call_575674.call(path_575675, nil, nil, nil, nil)

var transfersCancel* = Call_TransfersCancel_575667(name: "transfersCancel",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transfers/{transferName}",
    validator: validate_TransfersCancel_575668, base: "", url: url_TransfersCancel_575669,
    schemes: {Scheme.Https})
type
  Call_InvoicesListByBillingAccountName_575676 = ref object of OpenApiRestCall_574467
proc url_InvoicesListByBillingAccountName_575678(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoicesListByBillingAccountName_575677(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of invoices for a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575679 = path.getOrDefault("billingAccountName")
  valid_575679 = validateParameter(valid_575679, JString, required = true,
                                 default = nil)
  if valid_575679 != nil:
    section.add "billingAccountName", valid_575679
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   periodEndDate: JString (required)
  ##                : Invoice period end date.
  ##   periodStartDate: JString (required)
  ##                  : Invoice period start date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575680 = query.getOrDefault("api-version")
  valid_575680 = validateParameter(valid_575680, JString, required = true,
                                 default = nil)
  if valid_575680 != nil:
    section.add "api-version", valid_575680
  var valid_575681 = query.getOrDefault("periodEndDate")
  valid_575681 = validateParameter(valid_575681, JString, required = true,
                                 default = nil)
  if valid_575681 != nil:
    section.add "periodEndDate", valid_575681
  var valid_575682 = query.getOrDefault("periodStartDate")
  valid_575682 = validateParameter(valid_575682, JString, required = true,
                                 default = nil)
  if valid_575682 != nil:
    section.add "periodStartDate", valid_575682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575683: Call_InvoicesListByBillingAccountName_575676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of invoices for a billing account.
  ## 
  let valid = call_575683.validator(path, query, header, formData, body)
  let scheme = call_575683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575683.url(scheme.get, call_575683.host, call_575683.base,
                         call_575683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575683, url, valid)

proc call*(call_575684: Call_InvoicesListByBillingAccountName_575676;
          apiVersion: string; billingAccountName: string; periodEndDate: string;
          periodStartDate: string): Recallable =
  ## invoicesListByBillingAccountName
  ## List of invoices for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   periodEndDate: string (required)
  ##                : Invoice period end date.
  ##   periodStartDate: string (required)
  ##                  : Invoice period start date.
  var path_575685 = newJObject()
  var query_575686 = newJObject()
  add(query_575686, "api-version", newJString(apiVersion))
  add(path_575685, "billingAccountName", newJString(billingAccountName))
  add(query_575686, "periodEndDate", newJString(periodEndDate))
  add(query_575686, "periodStartDate", newJString(periodStartDate))
  result = call_575684.call(path_575685, query_575686, nil, nil, nil)

var invoicesListByBillingAccountName* = Call_InvoicesListByBillingAccountName_575676(
    name: "invoicesListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoices",
    validator: validate_InvoicesListByBillingAccountName_575677, base: "",
    url: url_InvoicesListByBillingAccountName_575678, schemes: {Scheme.Https})
type
  Call_PriceSheetDownload_575687 = ref object of OpenApiRestCall_574467
proc url_PriceSheetDownload_575689(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceName" in path, "`invoiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoices/"),
               (kind: VariableSegment, value: "invoiceName"),
               (kind: ConstantSegment, value: "/pricesheet/default/download")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PriceSheetDownload_575688(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Download price sheet for an invoice.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Azure Billing Account ID.
  ##   invoiceName: JString (required)
  ##              : The name of an invoice resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575690 = path.getOrDefault("billingAccountName")
  valid_575690 = validateParameter(valid_575690, JString, required = true,
                                 default = nil)
  if valid_575690 != nil:
    section.add "billingAccountName", valid_575690
  var valid_575691 = path.getOrDefault("invoiceName")
  valid_575691 = validateParameter(valid_575691, JString, required = true,
                                 default = nil)
  if valid_575691 != nil:
    section.add "invoiceName", valid_575691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575692 = query.getOrDefault("api-version")
  valid_575692 = validateParameter(valid_575692, JString, required = true,
                                 default = nil)
  if valid_575692 != nil:
    section.add "api-version", valid_575692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575693: Call_PriceSheetDownload_575687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Download price sheet for an invoice.
  ## 
  let valid = call_575693.validator(path, query, header, formData, body)
  let scheme = call_575693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575693.url(scheme.get, call_575693.host, call_575693.base,
                         call_575693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575693, url, valid)

proc call*(call_575694: Call_PriceSheetDownload_575687; apiVersion: string;
          billingAccountName: string; invoiceName: string): Recallable =
  ## priceSheetDownload
  ## Download price sheet for an invoice.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Azure Billing Account ID.
  ##   invoiceName: string (required)
  ##              : The name of an invoice resource.
  var path_575695 = newJObject()
  var query_575696 = newJObject()
  add(query_575696, "api-version", newJString(apiVersion))
  add(path_575695, "billingAccountName", newJString(billingAccountName))
  add(path_575695, "invoiceName", newJString(invoiceName))
  result = call_575694.call(path_575695, query_575696, nil, nil, nil)

var priceSheetDownload* = Call_PriceSheetDownload_575687(
    name: "priceSheetDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoices/{invoiceName}/pricesheet/default/download",
    validator: validate_PriceSheetDownload_575688, base: "",
    url: url_PriceSheetDownload_575689, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsListByCreateSubscriptionPermission_575697 = ref object of OpenApiRestCall_574467
proc url_InvoiceSectionsListByCreateSubscriptionPermission_575699(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/listInvoiceSectionsWithCreateSubscriptionPermission")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsListByCreateSubscriptionPermission_575698(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all invoiceSections with create subscription permission for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575700 = path.getOrDefault("billingAccountName")
  valid_575700 = validateParameter(valid_575700, JString, required = true,
                                 default = nil)
  if valid_575700 != nil:
    section.add "billingAccountName", valid_575700
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575701 = query.getOrDefault("api-version")
  valid_575701 = validateParameter(valid_575701, JString, required = true,
                                 default = nil)
  if valid_575701 != nil:
    section.add "api-version", valid_575701
  var valid_575702 = query.getOrDefault("$expand")
  valid_575702 = validateParameter(valid_575702, JString, required = false,
                                 default = nil)
  if valid_575702 != nil:
    section.add "$expand", valid_575702
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575703: Call_InvoiceSectionsListByCreateSubscriptionPermission_575697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoiceSections with create subscription permission for a user.
  ## 
  let valid = call_575703.validator(path, query, header, formData, body)
  let scheme = call_575703.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575703.url(scheme.get, call_575703.host, call_575703.base,
                         call_575703.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575703, url, valid)

proc call*(call_575704: Call_InvoiceSectionsListByCreateSubscriptionPermission_575697;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## invoiceSectionsListByCreateSubscriptionPermission
  ## Lists all invoiceSections with create subscription permission for a user.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the billingProfiles.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575705 = newJObject()
  var query_575706 = newJObject()
  add(query_575706, "api-version", newJString(apiVersion))
  add(query_575706, "$expand", newJString(Expand))
  add(path_575705, "billingAccountName", newJString(billingAccountName))
  result = call_575704.call(path_575705, query_575706, nil, nil, nil)

var invoiceSectionsListByCreateSubscriptionPermission* = Call_InvoiceSectionsListByCreateSubscriptionPermission_575697(
    name: "invoiceSectionsListByCreateSubscriptionPermission",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/listInvoiceSectionsWithCreateSubscriptionPermission",
    validator: validate_InvoiceSectionsListByCreateSubscriptionPermission_575698,
    base: "", url: url_InvoiceSectionsListByCreateSubscriptionPermission_575699,
    schemes: {Scheme.Https})
type
  Call_PaymentMethodsListByBillingAccountName_575707 = ref object of OpenApiRestCall_574467
proc url_PaymentMethodsListByBillingAccountName_575709(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/paymentMethods")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PaymentMethodsListByBillingAccountName_575708(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Payment Methods by billing account Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/2018-11-01-preview/paymentmethods
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575710 = path.getOrDefault("billingAccountName")
  valid_575710 = validateParameter(valid_575710, JString, required = true,
                                 default = nil)
  if valid_575710 != nil:
    section.add "billingAccountName", valid_575710
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575711 = query.getOrDefault("api-version")
  valid_575711 = validateParameter(valid_575711, JString, required = true,
                                 default = nil)
  if valid_575711 != nil:
    section.add "api-version", valid_575711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575712: Call_PaymentMethodsListByBillingAccountName_575707;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Payment Methods by billing account Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/2018-11-01-preview/paymentmethods
  let valid = call_575712.validator(path, query, header, formData, body)
  let scheme = call_575712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575712.url(scheme.get, call_575712.host, call_575712.base,
                         call_575712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575712, url, valid)

proc call*(call_575713: Call_PaymentMethodsListByBillingAccountName_575707;
          apiVersion: string; billingAccountName: string): Recallable =
  ## paymentMethodsListByBillingAccountName
  ## Lists the Payment Methods by billing account Id.
  ## https://docs.microsoft.com/en-us/rest/api/billing/2018-11-01-preview/paymentmethods
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575714 = newJObject()
  var query_575715 = newJObject()
  add(query_575715, "api-version", newJString(apiVersion))
  add(path_575714, "billingAccountName", newJString(billingAccountName))
  result = call_575713.call(path_575714, query_575715, nil, nil, nil)

var paymentMethodsListByBillingAccountName* = Call_PaymentMethodsListByBillingAccountName_575707(
    name: "paymentMethodsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/paymentMethods",
    validator: validate_PaymentMethodsListByBillingAccountName_575708, base: "",
    url: url_PaymentMethodsListByBillingAccountName_575709,
    schemes: {Scheme.Https})
type
  Call_ProductsListByBillingAccountName_575716 = ref object of OpenApiRestCall_574467
proc url_ProductsListByBillingAccountName_575718(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsListByBillingAccountName_575717(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists products by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575719 = path.getOrDefault("billingAccountName")
  valid_575719 = validateParameter(valid_575719, JString, required = true,
                                 default = nil)
  if valid_575719 != nil:
    section.add "billingAccountName", valid_575719
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575720 = query.getOrDefault("api-version")
  valid_575720 = validateParameter(valid_575720, JString, required = true,
                                 default = nil)
  if valid_575720 != nil:
    section.add "api-version", valid_575720
  var valid_575721 = query.getOrDefault("$filter")
  valid_575721 = validateParameter(valid_575721, JString, required = false,
                                 default = nil)
  if valid_575721 != nil:
    section.add "$filter", valid_575721
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575722: Call_ProductsListByBillingAccountName_575716;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists products by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575722.validator(path, query, header, formData, body)
  let scheme = call_575722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575722.url(scheme.get, call_575722.host, call_575722.base,
                         call_575722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575722, url, valid)

proc call*(call_575723: Call_ProductsListByBillingAccountName_575716;
          apiVersion: string; billingAccountName: string; Filter: string = ""): Recallable =
  ## productsListByBillingAccountName
  ## Lists products by billing account name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Filter: string
  ##         : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575724 = newJObject()
  var query_575725 = newJObject()
  add(query_575725, "api-version", newJString(apiVersion))
  add(path_575724, "billingAccountName", newJString(billingAccountName))
  add(query_575725, "$filter", newJString(Filter))
  result = call_575723.call(path_575724, query_575725, nil, nil, nil)

var productsListByBillingAccountName* = Call_ProductsListByBillingAccountName_575716(
    name: "productsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/products",
    validator: validate_ProductsListByBillingAccountName_575717, base: "",
    url: url_ProductsListByBillingAccountName_575718, schemes: {Scheme.Https})
type
  Call_ProductsUpdateAutoRenewByBillingAccountName_575726 = ref object of OpenApiRestCall_574467
proc url_ProductsUpdateAutoRenewByBillingAccountName_575728(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/updateAutoRenew")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsUpdateAutoRenewByBillingAccountName_575727(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel auto renew for product by product id and billing account name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_575729 = path.getOrDefault("productName")
  valid_575729 = validateParameter(valid_575729, JString, required = true,
                                 default = nil)
  if valid_575729 != nil:
    section.add "productName", valid_575729
  var valid_575730 = path.getOrDefault("billingAccountName")
  valid_575730 = validateParameter(valid_575730, JString, required = true,
                                 default = nil)
  if valid_575730 != nil:
    section.add "billingAccountName", valid_575730
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575731 = query.getOrDefault("api-version")
  valid_575731 = validateParameter(valid_575731, JString, required = true,
                                 default = nil)
  if valid_575731 != nil:
    section.add "api-version", valid_575731
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575733: Call_ProductsUpdateAutoRenewByBillingAccountName_575726;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancel auto renew for product by product id and billing account name
  ## 
  let valid = call_575733.validator(path, query, header, formData, body)
  let scheme = call_575733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575733.url(scheme.get, call_575733.host, call_575733.base,
                         call_575733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575733, url, valid)

proc call*(call_575734: Call_ProductsUpdateAutoRenewByBillingAccountName_575726;
          productName: string; apiVersion: string; billingAccountName: string;
          body: JsonNode): Recallable =
  ## productsUpdateAutoRenewByBillingAccountName
  ## Cancel auto renew for product by product id and billing account name
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  var path_575735 = newJObject()
  var query_575736 = newJObject()
  var body_575737 = newJObject()
  add(path_575735, "productName", newJString(productName))
  add(query_575736, "api-version", newJString(apiVersion))
  add(path_575735, "billingAccountName", newJString(billingAccountName))
  if body != nil:
    body_575737 = body
  result = call_575734.call(path_575735, query_575736, nil, nil, body_575737)

var productsUpdateAutoRenewByBillingAccountName* = Call_ProductsUpdateAutoRenewByBillingAccountName_575726(
    name: "productsUpdateAutoRenewByBillingAccountName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/products/{productName}/updateAutoRenew",
    validator: validate_ProductsUpdateAutoRenewByBillingAccountName_575727,
    base: "", url: url_ProductsUpdateAutoRenewByBillingAccountName_575728,
    schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByBillingAccount_575738 = ref object of OpenApiRestCall_574467
proc url_BillingPermissionsListByBillingAccount_575740(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByBillingAccount_575739(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing permissions for the caller under a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575741 = path.getOrDefault("billingAccountName")
  valid_575741 = validateParameter(valid_575741, JString, required = true,
                                 default = nil)
  if valid_575741 != nil:
    section.add "billingAccountName", valid_575741
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575742 = query.getOrDefault("api-version")
  valid_575742 = validateParameter(valid_575742, JString, required = true,
                                 default = nil)
  if valid_575742 != nil:
    section.add "api-version", valid_575742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575743: Call_BillingPermissionsListByBillingAccount_575738;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under a billing account.
  ## 
  let valid = call_575743.validator(path, query, header, formData, body)
  let scheme = call_575743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575743.url(scheme.get, call_575743.host, call_575743.base,
                         call_575743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575743, url, valid)

proc call*(call_575744: Call_BillingPermissionsListByBillingAccount_575738;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingPermissionsListByBillingAccount
  ## Lists all billing permissions for the caller under a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575745 = newJObject()
  var query_575746 = newJObject()
  add(query_575746, "api-version", newJString(apiVersion))
  add(path_575745, "billingAccountName", newJString(billingAccountName))
  result = call_575744.call(path_575745, query_575746, nil, nil, nil)

var billingPermissionsListByBillingAccount* = Call_BillingPermissionsListByBillingAccount_575738(
    name: "billingPermissionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByBillingAccount_575739, base: "",
    url: url_BillingPermissionsListByBillingAccount_575740,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByBillingAccountName_575747 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsListByBillingAccountName_575749(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsListByBillingAccountName_575748(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignments on the Billing Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575750 = path.getOrDefault("billingAccountName")
  valid_575750 = validateParameter(valid_575750, JString, required = true,
                                 default = nil)
  if valid_575750 != nil:
    section.add "billingAccountName", valid_575750
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575751 = query.getOrDefault("api-version")
  valid_575751 = validateParameter(valid_575751, JString, required = true,
                                 default = nil)
  if valid_575751 != nil:
    section.add "api-version", valid_575751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575752: Call_BillingRoleAssignmentsListByBillingAccountName_575747;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the Billing Account
  ## 
  let valid = call_575752.validator(path, query, header, formData, body)
  let scheme = call_575752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575752.url(scheme.get, call_575752.host, call_575752.base,
                         call_575752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575752, url, valid)

proc call*(call_575753: Call_BillingRoleAssignmentsListByBillingAccountName_575747;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingRoleAssignmentsListByBillingAccountName
  ## Get the role assignments on the Billing Account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575754 = newJObject()
  var query_575755 = newJObject()
  add(query_575755, "api-version", newJString(apiVersion))
  add(path_575754, "billingAccountName", newJString(billingAccountName))
  result = call_575753.call(path_575754, query_575755, nil, nil, nil)

var billingRoleAssignmentsListByBillingAccountName* = Call_BillingRoleAssignmentsListByBillingAccountName_575747(
    name: "billingRoleAssignmentsListByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByBillingAccountName_575748,
    base: "", url: url_BillingRoleAssignmentsListByBillingAccountName_575749,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByBillingAccount_575756 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsGetByBillingAccount_575758(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsGetByBillingAccount_575757(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignment for the caller
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_575759 = path.getOrDefault("billingRoleAssignmentName")
  valid_575759 = validateParameter(valid_575759, JString, required = true,
                                 default = nil)
  if valid_575759 != nil:
    section.add "billingRoleAssignmentName", valid_575759
  var valid_575760 = path.getOrDefault("billingAccountName")
  valid_575760 = validateParameter(valid_575760, JString, required = true,
                                 default = nil)
  if valid_575760 != nil:
    section.add "billingAccountName", valid_575760
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575761 = query.getOrDefault("api-version")
  valid_575761 = validateParameter(valid_575761, JString, required = true,
                                 default = nil)
  if valid_575761 != nil:
    section.add "api-version", valid_575761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575762: Call_BillingRoleAssignmentsGetByBillingAccount_575756;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller
  ## 
  let valid = call_575762.validator(path, query, header, formData, body)
  let scheme = call_575762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575762.url(scheme.get, call_575762.host, call_575762.base,
                         call_575762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575762, url, valid)

proc call*(call_575763: Call_BillingRoleAssignmentsGetByBillingAccount_575756;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string): Recallable =
  ## billingRoleAssignmentsGetByBillingAccount
  ## Get the role assignment for the caller
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575764 = newJObject()
  var query_575765 = newJObject()
  add(query_575765, "api-version", newJString(apiVersion))
  add(path_575764, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_575764, "billingAccountName", newJString(billingAccountName))
  result = call_575763.call(path_575764, query_575765, nil, nil, nil)

var billingRoleAssignmentsGetByBillingAccount* = Call_BillingRoleAssignmentsGetByBillingAccount_575756(
    name: "billingRoleAssignmentsGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByBillingAccount_575757,
    base: "", url: url_BillingRoleAssignmentsGetByBillingAccount_575758,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByBillingAccountName_575766 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsDeleteByBillingAccountName_575768(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsDeleteByBillingAccountName_575767(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete the role assignment on this billing account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_575769 = path.getOrDefault("billingRoleAssignmentName")
  valid_575769 = validateParameter(valid_575769, JString, required = true,
                                 default = nil)
  if valid_575769 != nil:
    section.add "billingRoleAssignmentName", valid_575769
  var valid_575770 = path.getOrDefault("billingAccountName")
  valid_575770 = validateParameter(valid_575770, JString, required = true,
                                 default = nil)
  if valid_575770 != nil:
    section.add "billingAccountName", valid_575770
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575771 = query.getOrDefault("api-version")
  valid_575771 = validateParameter(valid_575771, JString, required = true,
                                 default = nil)
  if valid_575771 != nil:
    section.add "api-version", valid_575771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575772: Call_BillingRoleAssignmentsDeleteByBillingAccountName_575766;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on this billing account
  ## 
  let valid = call_575772.validator(path, query, header, formData, body)
  let scheme = call_575772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575772.url(scheme.get, call_575772.host, call_575772.base,
                         call_575772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575772, url, valid)

proc call*(call_575773: Call_BillingRoleAssignmentsDeleteByBillingAccountName_575766;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string): Recallable =
  ## billingRoleAssignmentsDeleteByBillingAccountName
  ## Delete the role assignment on this billing account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575774 = newJObject()
  var query_575775 = newJObject()
  add(query_575775, "api-version", newJString(apiVersion))
  add(path_575774, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_575774, "billingAccountName", newJString(billingAccountName))
  result = call_575773.call(path_575774, query_575775, nil, nil, nil)

var billingRoleAssignmentsDeleteByBillingAccountName* = Call_BillingRoleAssignmentsDeleteByBillingAccountName_575766(
    name: "billingRoleAssignmentsDeleteByBillingAccountName",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByBillingAccountName_575767,
    base: "", url: url_BillingRoleAssignmentsDeleteByBillingAccountName_575768,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByBillingAccountName_575776 = ref object of OpenApiRestCall_574467
proc url_BillingRoleDefinitionsListByBillingAccountName_575778(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsListByBillingAccountName_575777(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the role definition for a billing account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575779 = path.getOrDefault("billingAccountName")
  valid_575779 = validateParameter(valid_575779, JString, required = true,
                                 default = nil)
  if valid_575779 != nil:
    section.add "billingAccountName", valid_575779
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575780 = query.getOrDefault("api-version")
  valid_575780 = validateParameter(valid_575780, JString, required = true,
                                 default = nil)
  if valid_575780 != nil:
    section.add "api-version", valid_575780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575781: Call_BillingRoleDefinitionsListByBillingAccountName_575776;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for a billing account
  ## 
  let valid = call_575781.validator(path, query, header, formData, body)
  let scheme = call_575781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575781.url(scheme.get, call_575781.host, call_575781.base,
                         call_575781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575781, url, valid)

proc call*(call_575782: Call_BillingRoleDefinitionsListByBillingAccountName_575776;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingRoleDefinitionsListByBillingAccountName
  ## Lists the role definition for a billing account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_575783 = newJObject()
  var query_575784 = newJObject()
  add(query_575784, "api-version", newJString(apiVersion))
  add(path_575783, "billingAccountName", newJString(billingAccountName))
  result = call_575782.call(path_575783, query_575784, nil, nil, nil)

var billingRoleDefinitionsListByBillingAccountName* = Call_BillingRoleDefinitionsListByBillingAccountName_575776(
    name: "billingRoleDefinitionsListByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByBillingAccountName_575777,
    base: "", url: url_BillingRoleDefinitionsListByBillingAccountName_575778,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByBillingAccountName_575785 = ref object of OpenApiRestCall_574467
proc url_BillingRoleDefinitionsGetByBillingAccountName_575787(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingRoleDefinitionName" in path,
        "`billingRoleDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleDefinitions/"),
               (kind: VariableSegment, value: "billingRoleDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsGetByBillingAccountName_575786(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the role definition for a role
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingRoleDefinitionName: JString (required)
  ##                            : role definition id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575788 = path.getOrDefault("billingAccountName")
  valid_575788 = validateParameter(valid_575788, JString, required = true,
                                 default = nil)
  if valid_575788 != nil:
    section.add "billingAccountName", valid_575788
  var valid_575789 = path.getOrDefault("billingRoleDefinitionName")
  valid_575789 = validateParameter(valid_575789, JString, required = true,
                                 default = nil)
  if valid_575789 != nil:
    section.add "billingRoleDefinitionName", valid_575789
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575790 = query.getOrDefault("api-version")
  valid_575790 = validateParameter(valid_575790, JString, required = true,
                                 default = nil)
  if valid_575790 != nil:
    section.add "api-version", valid_575790
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575791: Call_BillingRoleDefinitionsGetByBillingAccountName_575785;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_575791.validator(path, query, header, formData, body)
  let scheme = call_575791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575791.url(scheme.get, call_575791.host, call_575791.base,
                         call_575791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575791, url, valid)

proc call*(call_575792: Call_BillingRoleDefinitionsGetByBillingAccountName_575785;
          apiVersion: string; billingAccountName: string;
          billingRoleDefinitionName: string): Recallable =
  ## billingRoleDefinitionsGetByBillingAccountName
  ## Gets the role definition for a role
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingRoleDefinitionName: string (required)
  ##                            : role definition id.
  var path_575793 = newJObject()
  var query_575794 = newJObject()
  add(query_575794, "api-version", newJString(apiVersion))
  add(path_575793, "billingAccountName", newJString(billingAccountName))
  add(path_575793, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  result = call_575792.call(path_575793, query_575794, nil, nil, nil)

var billingRoleDefinitionsGetByBillingAccountName* = Call_BillingRoleDefinitionsGetByBillingAccountName_575785(
    name: "billingRoleDefinitionsGetByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByBillingAccountName_575786,
    base: "", url: url_BillingRoleDefinitionsGetByBillingAccountName_575787,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByBillingAccountName_575795 = ref object of OpenApiRestCall_574467
proc url_BillingRoleAssignmentsAddByBillingAccountName_575797(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/createBillingRoleAssignment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsAddByBillingAccountName_575796(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to add a role assignment to a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575798 = path.getOrDefault("billingAccountName")
  valid_575798 = validateParameter(valid_575798, JString, required = true,
                                 default = nil)
  if valid_575798 != nil:
    section.add "billingAccountName", valid_575798
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575799 = query.getOrDefault("api-version")
  valid_575799 = validateParameter(valid_575799, JString, required = true,
                                 default = nil)
  if valid_575799 != nil:
    section.add "api-version", valid_575799
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575801: Call_BillingRoleAssignmentsAddByBillingAccountName_575795;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a billing account.
  ## 
  let valid = call_575801.validator(path, query, header, formData, body)
  let scheme = call_575801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575801.url(scheme.get, call_575801.host, call_575801.base,
                         call_575801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575801, url, valid)

proc call*(call_575802: Call_BillingRoleAssignmentsAddByBillingAccountName_575795;
          apiVersion: string; billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingRoleAssignmentsAddByBillingAccountName
  ## The operation to add a role assignment to a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  var path_575803 = newJObject()
  var query_575804 = newJObject()
  var body_575805 = newJObject()
  add(query_575804, "api-version", newJString(apiVersion))
  add(path_575803, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_575805 = parameters
  result = call_575802.call(path_575803, query_575804, nil, nil, body_575805)

var billingRoleAssignmentsAddByBillingAccountName* = Call_BillingRoleAssignmentsAddByBillingAccountName_575795(
    name: "billingRoleAssignmentsAddByBillingAccountName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByBillingAccountName_575796,
    base: "", url: url_BillingRoleAssignmentsAddByBillingAccountName_575797,
    schemes: {Scheme.Https})
type
  Call_TransactionsListByBillingAccountName_575806 = ref object of OpenApiRestCall_574467
proc url_TransactionsListByBillingAccountName_575808(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsListByBillingAccountName_575807(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by billing account name for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575809 = path.getOrDefault("billingAccountName")
  valid_575809 = validateParameter(valid_575809, JString, required = true,
                                 default = nil)
  if valid_575809 != nil:
    section.add "billingAccountName", valid_575809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575810 = query.getOrDefault("api-version")
  valid_575810 = validateParameter(valid_575810, JString, required = true,
                                 default = nil)
  if valid_575810 != nil:
    section.add "api-version", valid_575810
  var valid_575811 = query.getOrDefault("endDate")
  valid_575811 = validateParameter(valid_575811, JString, required = true,
                                 default = nil)
  if valid_575811 != nil:
    section.add "endDate", valid_575811
  var valid_575812 = query.getOrDefault("startDate")
  valid_575812 = validateParameter(valid_575812, JString, required = true,
                                 default = nil)
  if valid_575812 != nil:
    section.add "startDate", valid_575812
  var valid_575813 = query.getOrDefault("$filter")
  valid_575813 = validateParameter(valid_575813, JString, required = false,
                                 default = nil)
  if valid_575813 != nil:
    section.add "$filter", valid_575813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575814: Call_TransactionsListByBillingAccountName_575806;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by billing account name for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575814.validator(path, query, header, formData, body)
  let scheme = call_575814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575814.url(scheme.get, call_575814.host, call_575814.base,
                         call_575814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575814, url, valid)

proc call*(call_575815: Call_TransactionsListByBillingAccountName_575806;
          apiVersion: string; endDate: string; billingAccountName: string;
          startDate: string; Filter: string = ""): Recallable =
  ## transactionsListByBillingAccountName
  ## Lists the transactions by billing account name for given start and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575816 = newJObject()
  var query_575817 = newJObject()
  add(query_575817, "api-version", newJString(apiVersion))
  add(query_575817, "endDate", newJString(endDate))
  add(path_575816, "billingAccountName", newJString(billingAccountName))
  add(query_575817, "startDate", newJString(startDate))
  add(query_575817, "$filter", newJString(Filter))
  result = call_575815.call(path_575816, query_575817, nil, nil, nil)

var transactionsListByBillingAccountName* = Call_TransactionsListByBillingAccountName_575806(
    name: "transactionsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/transactions",
    validator: validate_TransactionsListByBillingAccountName_575807, base: "",
    url: url_TransactionsListByBillingAccountName_575808, schemes: {Scheme.Https})
type
  Call_OperationsList_575818 = ref object of OpenApiRestCall_574467
proc url_OperationsList_575820(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_575819(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available billing REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575821 = query.getOrDefault("api-version")
  valid_575821 = validateParameter(valid_575821, JString, required = true,
                                 default = nil)
  if valid_575821 != nil:
    section.add "api-version", valid_575821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575822: Call_OperationsList_575818; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available billing REST API operations.
  ## 
  let valid = call_575822.validator(path, query, header, formData, body)
  let scheme = call_575822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575822.url(scheme.get, call_575822.host, call_575822.base,
                         call_575822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575822, url, valid)

proc call*(call_575823: Call_OperationsList_575818; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available billing REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  var query_575824 = newJObject()
  add(query_575824, "api-version", newJString(apiVersion))
  result = call_575823.call(nil, query_575824, nil, nil, nil)

var operationsList* = Call_OperationsList_575818(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/operations",
    validator: validate_OperationsList_575819, base: "", url: url_OperationsList_575820,
    schemes: {Scheme.Https})
type
  Call_RecipientTransfersList_575825 = ref object of OpenApiRestCall_574467
proc url_RecipientTransfersList_575827(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecipientTransfersList_575826(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575828: Call_RecipientTransfersList_575825; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575828.validator(path, query, header, formData, body)
  let scheme = call_575828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575828.url(scheme.get, call_575828.host, call_575828.base,
                         call_575828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575828, url, valid)

proc call*(call_575829: Call_RecipientTransfersList_575825): Recallable =
  ## recipientTransfersList
  result = call_575829.call(nil, nil, nil, nil, nil)

var recipientTransfersList* = Call_RecipientTransfersList_575825(
    name: "recipientTransfersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers",
    validator: validate_RecipientTransfersList_575826, base: "",
    url: url_RecipientTransfersList_575827, schemes: {Scheme.Https})
type
  Call_RecipientTransfersGet_575830 = ref object of OpenApiRestCall_574467
proc url_RecipientTransfersGet_575832(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/transfers/"),
               (kind: VariableSegment, value: "transferName"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecipientTransfersGet_575831(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_575833 = path.getOrDefault("transferName")
  valid_575833 = validateParameter(valid_575833, JString, required = true,
                                 default = nil)
  if valid_575833 != nil:
    section.add "transferName", valid_575833
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575834: Call_RecipientTransfersGet_575830; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575834.validator(path, query, header, formData, body)
  let scheme = call_575834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575834.url(scheme.get, call_575834.host, call_575834.base,
                         call_575834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575834, url, valid)

proc call*(call_575835: Call_RecipientTransfersGet_575830; transferName: string): Recallable =
  ## recipientTransfersGet
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_575836 = newJObject()
  add(path_575836, "transferName", newJString(transferName))
  result = call_575835.call(path_575836, nil, nil, nil, nil)

var recipientTransfersGet* = Call_RecipientTransfersGet_575830(
    name: "recipientTransfersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/transfers/{transferName}/",
    validator: validate_RecipientTransfersGet_575831, base: "",
    url: url_RecipientTransfersGet_575832, schemes: {Scheme.Https})
type
  Call_RecipientTransfersAccept_575837 = ref object of OpenApiRestCall_574467
proc url_RecipientTransfersAccept_575839(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/transfers/"),
               (kind: VariableSegment, value: "transferName"),
               (kind: ConstantSegment, value: "/acceptTransfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecipientTransfersAccept_575838(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_575840 = path.getOrDefault("transferName")
  valid_575840 = validateParameter(valid_575840, JString, required = true,
                                 default = nil)
  if valid_575840 != nil:
    section.add "transferName", valid_575840
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Accept transfer parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575842: Call_RecipientTransfersAccept_575837; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575842.validator(path, query, header, formData, body)
  let scheme = call_575842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575842.url(scheme.get, call_575842.host, call_575842.base,
                         call_575842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575842, url, valid)

proc call*(call_575843: Call_RecipientTransfersAccept_575837; body: JsonNode;
          transferName: string): Recallable =
  ## recipientTransfersAccept
  ##   body: JObject (required)
  ##       : Accept transfer parameters.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_575844 = newJObject()
  var body_575845 = newJObject()
  if body != nil:
    body_575845 = body
  add(path_575844, "transferName", newJString(transferName))
  result = call_575843.call(path_575844, nil, nil, nil, body_575845)

var recipientTransfersAccept* = Call_RecipientTransfersAccept_575837(
    name: "recipientTransfersAccept", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/acceptTransfer",
    validator: validate_RecipientTransfersAccept_575838, base: "",
    url: url_RecipientTransfersAccept_575839, schemes: {Scheme.Https})
type
  Call_RecipientTransfersDecline_575846 = ref object of OpenApiRestCall_574467
proc url_RecipientTransfersDecline_575848(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/transfers/"),
               (kind: VariableSegment, value: "transferName"),
               (kind: ConstantSegment, value: "/declineTransfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecipientTransfersDecline_575847(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_575849 = path.getOrDefault("transferName")
  valid_575849 = validateParameter(valid_575849, JString, required = true,
                                 default = nil)
  if valid_575849 != nil:
    section.add "transferName", valid_575849
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575850: Call_RecipientTransfersDecline_575846; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575850.validator(path, query, header, formData, body)
  let scheme = call_575850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575850.url(scheme.get, call_575850.host, call_575850.base,
                         call_575850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575850, url, valid)

proc call*(call_575851: Call_RecipientTransfersDecline_575846; transferName: string): Recallable =
  ## recipientTransfersDecline
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_575852 = newJObject()
  add(path_575852, "transferName", newJString(transferName))
  result = call_575851.call(path_575852, nil, nil, nil, nil)

var recipientTransfersDecline* = Call_RecipientTransfersDecline_575846(
    name: "recipientTransfersDecline", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/declineTransfer",
    validator: validate_RecipientTransfersDecline_575847, base: "",
    url: url_RecipientTransfersDecline_575848, schemes: {Scheme.Https})
type
  Call_AddressesValidate_575853 = ref object of OpenApiRestCall_574467
proc url_AddressesValidate_575855(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AddressesValidate_575854(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Validates the address.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575856 = query.getOrDefault("api-version")
  valid_575856 = validateParameter(valid_575856, JString, required = true,
                                 default = nil)
  if valid_575856 != nil:
    section.add "api-version", valid_575856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   address: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575858: Call_AddressesValidate_575853; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the address.
  ## 
  let valid = call_575858.validator(path, query, header, formData, body)
  let scheme = call_575858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575858.url(scheme.get, call_575858.host, call_575858.base,
                         call_575858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575858, url, valid)

proc call*(call_575859: Call_AddressesValidate_575853; apiVersion: string;
          address: JsonNode): Recallable =
  ## addressesValidate
  ## Validates the address.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   address: JObject (required)
  var query_575860 = newJObject()
  var body_575861 = newJObject()
  add(query_575860, "api-version", newJString(apiVersion))
  if address != nil:
    body_575861 = address
  result = call_575859.call(nil, query_575860, nil, nil, body_575861)

var addressesValidate* = Call_AddressesValidate_575853(name: "addressesValidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/validateAddress",
    validator: validate_AddressesValidate_575854, base: "",
    url: url_AddressesValidate_575855, schemes: {Scheme.Https})
type
  Call_LineOfCreditsUpdate_575871 = ref object of OpenApiRestCall_574467
proc url_LineOfCreditsUpdate_575873(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LineOfCreditsUpdate_575872(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Increase the current line of credit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575874 = path.getOrDefault("subscriptionId")
  valid_575874 = validateParameter(valid_575874, JString, required = true,
                                 default = nil)
  if valid_575874 != nil:
    section.add "subscriptionId", valid_575874
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575875 = query.getOrDefault("api-version")
  valid_575875 = validateParameter(valid_575875, JString, required = true,
                                 default = nil)
  if valid_575875 != nil:
    section.add "api-version", valid_575875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the increase line of credit operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575877: Call_LineOfCreditsUpdate_575871; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Increase the current line of credit.
  ## 
  let valid = call_575877.validator(path, query, header, formData, body)
  let scheme = call_575877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575877.url(scheme.get, call_575877.host, call_575877.base,
                         call_575877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575877, url, valid)

proc call*(call_575878: Call_LineOfCreditsUpdate_575871; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## lineOfCreditsUpdate
  ## Increase the current line of credit.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the increase line of credit operation.
  var path_575879 = newJObject()
  var query_575880 = newJObject()
  var body_575881 = newJObject()
  add(query_575880, "api-version", newJString(apiVersion))
  add(path_575879, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575881 = parameters
  result = call_575878.call(path_575879, query_575880, nil, nil, body_575881)

var lineOfCreditsUpdate* = Call_LineOfCreditsUpdate_575871(
    name: "lineOfCreditsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default",
    validator: validate_LineOfCreditsUpdate_575872, base: "",
    url: url_LineOfCreditsUpdate_575873, schemes: {Scheme.Https})
type
  Call_LineOfCreditsGet_575862 = ref object of OpenApiRestCall_574467
proc url_LineOfCreditsGet_575864(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LineOfCreditsGet_575863(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the current line of credit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575865 = path.getOrDefault("subscriptionId")
  valid_575865 = validateParameter(valid_575865, JString, required = true,
                                 default = nil)
  if valid_575865 != nil:
    section.add "subscriptionId", valid_575865
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575866 = query.getOrDefault("api-version")
  valid_575866 = validateParameter(valid_575866, JString, required = true,
                                 default = nil)
  if valid_575866 != nil:
    section.add "api-version", valid_575866
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575867: Call_LineOfCreditsGet_575862; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the current line of credit.
  ## 
  let valid = call_575867.validator(path, query, header, formData, body)
  let scheme = call_575867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575867.url(scheme.get, call_575867.host, call_575867.base,
                         call_575867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575867, url, valid)

proc call*(call_575868: Call_LineOfCreditsGet_575862; apiVersion: string;
          subscriptionId: string): Recallable =
  ## lineOfCreditsGet
  ## Get the current line of credit.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id.
  var path_575869 = newJObject()
  var query_575870 = newJObject()
  add(query_575870, "api-version", newJString(apiVersion))
  add(path_575869, "subscriptionId", newJString(subscriptionId))
  result = call_575868.call(path_575869, query_575870, nil, nil, nil)

var lineOfCreditsGet* = Call_LineOfCreditsGet_575862(name: "lineOfCreditsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default",
    validator: validate_LineOfCreditsGet_575863, base: "",
    url: url_LineOfCreditsGet_575864, schemes: {Scheme.Https})
type
  Call_BillingPropertyGet_575882 = ref object of OpenApiRestCall_574467
proc url_BillingPropertyGet_575884(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingProperty")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPropertyGet_575883(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get billing property by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575885 = path.getOrDefault("subscriptionId")
  valid_575885 = validateParameter(valid_575885, JString, required = true,
                                 default = nil)
  if valid_575885 != nil:
    section.add "subscriptionId", valid_575885
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575886 = query.getOrDefault("api-version")
  valid_575886 = validateParameter(valid_575886, JString, required = true,
                                 default = nil)
  if valid_575886 != nil:
    section.add "api-version", valid_575886
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575887: Call_BillingPropertyGet_575882; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get billing property by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575887.validator(path, query, header, formData, body)
  let scheme = call_575887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575887.url(scheme.get, call_575887.host, call_575887.base,
                         call_575887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575887, url, valid)

proc call*(call_575888: Call_BillingPropertyGet_575882; apiVersion: string;
          subscriptionId: string): Recallable =
  ## billingPropertyGet
  ## Get billing property by subscription Id.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id.
  var path_575889 = newJObject()
  var query_575890 = newJObject()
  add(query_575890, "api-version", newJString(apiVersion))
  add(path_575889, "subscriptionId", newJString(subscriptionId))
  result = call_575888.call(path_575889, query_575890, nil, nil, nil)

var billingPropertyGet* = Call_BillingPropertyGet_575882(
    name: "billingPropertyGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingProperty",
    validator: validate_BillingPropertyGet_575883, base: "",
    url: url_BillingPropertyGet_575884, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
