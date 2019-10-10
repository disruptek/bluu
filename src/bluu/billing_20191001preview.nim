
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: BillingManagementClient
## version: 2019-10-01-preview
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

  OpenApiRestCall_573667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573667): Option[Scheme] {.used.} =
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
  Call_BillingAccountsList_573889 = ref object of OpenApiRestCall_573667
proc url_BillingAccountsList_573891(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BillingAccountsList_573890(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists all billing accounts for a user which he has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the address, invoiceSections and billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574051 = query.getOrDefault("api-version")
  valid_574051 = validateParameter(valid_574051, JString, required = true,
                                 default = nil)
  if valid_574051 != nil:
    section.add "api-version", valid_574051
  var valid_574052 = query.getOrDefault("$expand")
  valid_574052 = validateParameter(valid_574052, JString, required = false,
                                 default = nil)
  if valid_574052 != nil:
    section.add "$expand", valid_574052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574075: Call_BillingAccountsList_573889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all billing accounts for a user which he has access to.
  ## 
  let valid = call_574075.validator(path, query, header, formData, body)
  let scheme = call_574075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574075.url(scheme.get, call_574075.host, call_574075.base,
                         call_574075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574075, url, valid)

proc call*(call_574146: Call_BillingAccountsList_573889; apiVersion: string;
          Expand: string = ""): Recallable =
  ## billingAccountsList
  ## Lists all billing accounts for a user which he has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand the address, invoiceSections and billingProfiles.
  var query_574147 = newJObject()
  add(query_574147, "api-version", newJString(apiVersion))
  add(query_574147, "$expand", newJString(Expand))
  result = call_574146.call(nil, query_574147, nil, nil, nil)

var billingAccountsList* = Call_BillingAccountsList_573889(
    name: "billingAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts",
    validator: validate_BillingAccountsList_573890, base: "",
    url: url_BillingAccountsList_573891, schemes: {Scheme.Https})
type
  Call_BillingAccountsGet_574187 = ref object of OpenApiRestCall_573667
proc url_BillingAccountsGet_574189(protocol: Scheme; host: string; base: string;
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

proc validate_BillingAccountsGet_574188(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the billing account by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574204 = path.getOrDefault("billingAccountName")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "billingAccountName", valid_574204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the address, invoiceSections and billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574205 = query.getOrDefault("api-version")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "api-version", valid_574205
  var valid_574206 = query.getOrDefault("$expand")
  valid_574206 = validateParameter(valid_574206, JString, required = false,
                                 default = nil)
  if valid_574206 != nil:
    section.add "$expand", valid_574206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574207: Call_BillingAccountsGet_574187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the billing account by id.
  ## 
  let valid = call_574207.validator(path, query, header, formData, body)
  let scheme = call_574207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574207.url(scheme.get, call_574207.host, call_574207.base,
                         call_574207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574207, url, valid)

proc call*(call_574208: Call_BillingAccountsGet_574187; apiVersion: string;
          billingAccountName: string; Expand: string = ""): Recallable =
  ## billingAccountsGet
  ## Get the billing account by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand the address, invoiceSections and billingProfiles.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_574209 = newJObject()
  var query_574210 = newJObject()
  add(query_574210, "api-version", newJString(apiVersion))
  add(query_574210, "$expand", newJString(Expand))
  add(path_574209, "billingAccountName", newJString(billingAccountName))
  result = call_574208.call(path_574209, query_574210, nil, nil, nil)

var billingAccountsGet* = Call_BillingAccountsGet_574187(
    name: "billingAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}",
    validator: validate_BillingAccountsGet_574188, base: "",
    url: url_BillingAccountsGet_574189, schemes: {Scheme.Https})
type
  Call_BillingAccountsUpdate_574211 = ref object of OpenApiRestCall_573667
proc url_BillingAccountsUpdate_574213(protocol: Scheme; host: string; base: string;
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

proc validate_BillingAccountsUpdate_574212(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574231 = path.getOrDefault("billingAccountName")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "billingAccountName", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574232 = query.getOrDefault("api-version")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "api-version", valid_574232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the update billing account operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574234: Call_BillingAccountsUpdate_574211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a billing account.
  ## 
  let valid = call_574234.validator(path, query, header, formData, body)
  let scheme = call_574234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574234.url(scheme.get, call_574234.host, call_574234.base,
                         call_574234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574234, url, valid)

proc call*(call_574235: Call_BillingAccountsUpdate_574211; apiVersion: string;
          billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingAccountsUpdate
  ## The operation to update a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the update billing account operation.
  var path_574236 = newJObject()
  var query_574237 = newJObject()
  var body_574238 = newJObject()
  add(query_574237, "api-version", newJString(apiVersion))
  add(path_574236, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_574238 = parameters
  result = call_574235.call(path_574236, query_574237, nil, nil, body_574238)

var billingAccountsUpdate* = Call_BillingAccountsUpdate_574211(
    name: "billingAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}",
    validator: validate_BillingAccountsUpdate_574212, base: "",
    url: url_BillingAccountsUpdate_574213, schemes: {Scheme.Https})
type
  Call_AgreementsListByBillingAccount_574239 = ref object of OpenApiRestCall_573667
proc url_AgreementsListByBillingAccount_574241(protocol: Scheme; host: string;
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

proc validate_AgreementsListByBillingAccount_574240(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all agreements for a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574242 = path.getOrDefault("billingAccountName")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "billingAccountName", valid_574242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the participants.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574243 = query.getOrDefault("api-version")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "api-version", valid_574243
  var valid_574244 = query.getOrDefault("$expand")
  valid_574244 = validateParameter(valid_574244, JString, required = false,
                                 default = nil)
  if valid_574244 != nil:
    section.add "$expand", valid_574244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574245: Call_AgreementsListByBillingAccount_574239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all agreements for a billing account.
  ## 
  let valid = call_574245.validator(path, query, header, formData, body)
  let scheme = call_574245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574245.url(scheme.get, call_574245.host, call_574245.base,
                         call_574245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574245, url, valid)

proc call*(call_574246: Call_AgreementsListByBillingAccount_574239;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## agreementsListByBillingAccount
  ## Lists all agreements for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand the participants.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_574247 = newJObject()
  var query_574248 = newJObject()
  add(query_574248, "api-version", newJString(apiVersion))
  add(query_574248, "$expand", newJString(Expand))
  add(path_574247, "billingAccountName", newJString(billingAccountName))
  result = call_574246.call(path_574247, query_574248, nil, nil, nil)

var agreementsListByBillingAccount* = Call_AgreementsListByBillingAccount_574239(
    name: "agreementsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/agreements",
    validator: validate_AgreementsListByBillingAccount_574240, base: "",
    url: url_AgreementsListByBillingAccount_574241, schemes: {Scheme.Https})
type
  Call_AgreementsGet_574249 = ref object of OpenApiRestCall_573667
proc url_AgreementsGet_574251(protocol: Scheme; host: string; base: string;
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

proc validate_AgreementsGet_574250(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the agreement by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   agreementName: JString (required)
  ##                : Agreement Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574252 = path.getOrDefault("billingAccountName")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "billingAccountName", valid_574252
  var valid_574253 = path.getOrDefault("agreementName")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "agreementName", valid_574253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the participants.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574254 = query.getOrDefault("api-version")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "api-version", valid_574254
  var valid_574255 = query.getOrDefault("$expand")
  valid_574255 = validateParameter(valid_574255, JString, required = false,
                                 default = nil)
  if valid_574255 != nil:
    section.add "$expand", valid_574255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574256: Call_AgreementsGet_574249; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the agreement by name.
  ## 
  let valid = call_574256.validator(path, query, header, formData, body)
  let scheme = call_574256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574256.url(scheme.get, call_574256.host, call_574256.base,
                         call_574256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574256, url, valid)

proc call*(call_574257: Call_AgreementsGet_574249; apiVersion: string;
          billingAccountName: string; agreementName: string; Expand: string = ""): Recallable =
  ## agreementsGet
  ## Get the agreement by name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand the participants.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   agreementName: string (required)
  ##                : Agreement Id.
  var path_574258 = newJObject()
  var query_574259 = newJObject()
  add(query_574259, "api-version", newJString(apiVersion))
  add(query_574259, "$expand", newJString(Expand))
  add(path_574258, "billingAccountName", newJString(billingAccountName))
  add(path_574258, "agreementName", newJString(agreementName))
  result = call_574257.call(path_574258, query_574259, nil, nil, nil)

var agreementsGet* = Call_AgreementsGet_574249(name: "agreementsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsGet_574250, base: "", url: url_AgreementsGet_574251,
    schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByBillingAccount_574260 = ref object of OpenApiRestCall_573667
proc url_BillingPermissionsListByBillingAccount_574262(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByBillingAccount_574261(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing permissions for the caller under a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574263 = path.getOrDefault("billingAccountName")
  valid_574263 = validateParameter(valid_574263, JString, required = true,
                                 default = nil)
  if valid_574263 != nil:
    section.add "billingAccountName", valid_574263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574264 = query.getOrDefault("api-version")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "api-version", valid_574264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574265: Call_BillingPermissionsListByBillingAccount_574260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under a billing account.
  ## 
  let valid = call_574265.validator(path, query, header, formData, body)
  let scheme = call_574265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574265.url(scheme.get, call_574265.host, call_574265.base,
                         call_574265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574265, url, valid)

proc call*(call_574266: Call_BillingPermissionsListByBillingAccount_574260;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingPermissionsListByBillingAccount
  ## Lists all billing permissions for the caller under a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_574267 = newJObject()
  var query_574268 = newJObject()
  add(query_574268, "api-version", newJString(apiVersion))
  add(path_574267, "billingAccountName", newJString(billingAccountName))
  result = call_574266.call(path_574267, query_574268, nil, nil, nil)

var billingPermissionsListByBillingAccount* = Call_BillingPermissionsListByBillingAccount_574260(
    name: "billingPermissionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingPermissions",
    validator: validate_BillingPermissionsListByBillingAccount_574261, base: "",
    url: url_BillingPermissionsListByBillingAccount_574262,
    schemes: {Scheme.Https})
type
  Call_BillingProfilesListByBillingAccount_574269 = ref object of OpenApiRestCall_573667
proc url_BillingProfilesListByBillingAccount_574271(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/billingProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingProfilesListByBillingAccount_574270(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing profiles for a user which that user has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574272 = path.getOrDefault("billingAccountName")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "billingAccountName", valid_574272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574273 = query.getOrDefault("api-version")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "api-version", valid_574273
  var valid_574274 = query.getOrDefault("$expand")
  valid_574274 = validateParameter(valid_574274, JString, required = false,
                                 default = nil)
  if valid_574274 != nil:
    section.add "$expand", valid_574274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574275: Call_BillingProfilesListByBillingAccount_574269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing profiles for a user which that user has access to.
  ## 
  let valid = call_574275.validator(path, query, header, formData, body)
  let scheme = call_574275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574275.url(scheme.get, call_574275.host, call_574275.base,
                         call_574275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574275, url, valid)

proc call*(call_574276: Call_BillingProfilesListByBillingAccount_574269;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## billingProfilesListByBillingAccount
  ## Lists all billing profiles for a user which that user has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_574277 = newJObject()
  var query_574278 = newJObject()
  add(query_574278, "api-version", newJString(apiVersion))
  add(query_574278, "$expand", newJString(Expand))
  add(path_574277, "billingAccountName", newJString(billingAccountName))
  result = call_574276.call(path_574277, query_574278, nil, nil, nil)

var billingProfilesListByBillingAccount* = Call_BillingProfilesListByBillingAccount_574269(
    name: "billingProfilesListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles",
    validator: validate_BillingProfilesListByBillingAccount_574270, base: "",
    url: url_BillingProfilesListByBillingAccount_574271, schemes: {Scheme.Https})
type
  Call_BillingProfilesCreate_574290 = ref object of OpenApiRestCall_573667
proc url_BillingProfilesCreate_574292(protocol: Scheme; host: string; base: string;
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

proc validate_BillingProfilesCreate_574291(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a BillingProfile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574293 = path.getOrDefault("billingAccountName")
  valid_574293 = validateParameter(valid_574293, JString, required = true,
                                 default = nil)
  if valid_574293 != nil:
    section.add "billingAccountName", valid_574293
  var valid_574294 = path.getOrDefault("billingProfileName")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "billingProfileName", valid_574294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574295 = query.getOrDefault("api-version")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "api-version", valid_574295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the Create BillingProfile operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574297: Call_BillingProfilesCreate_574290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a BillingProfile.
  ## 
  let valid = call_574297.validator(path, query, header, formData, body)
  let scheme = call_574297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574297.url(scheme.get, call_574297.host, call_574297.base,
                         call_574297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574297, url, valid)

proc call*(call_574298: Call_BillingProfilesCreate_574290; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## billingProfilesCreate
  ## The operation to create a BillingProfile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the Create BillingProfile operation.
  var path_574299 = newJObject()
  var query_574300 = newJObject()
  var body_574301 = newJObject()
  add(query_574300, "api-version", newJString(apiVersion))
  add(path_574299, "billingAccountName", newJString(billingAccountName))
  add(path_574299, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574301 = parameters
  result = call_574298.call(path_574299, query_574300, nil, nil, body_574301)

var billingProfilesCreate* = Call_BillingProfilesCreate_574290(
    name: "billingProfilesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesCreate_574291, base: "",
    url: url_BillingProfilesCreate_574292, schemes: {Scheme.Https})
type
  Call_BillingProfilesGet_574279 = ref object of OpenApiRestCall_573667
proc url_BillingProfilesGet_574281(protocol: Scheme; host: string; base: string;
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

proc validate_BillingProfilesGet_574280(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the billing profile by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574282 = path.getOrDefault("billingAccountName")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "billingAccountName", valid_574282
  var valid_574283 = path.getOrDefault("billingProfileName")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "billingProfileName", valid_574283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574284 = query.getOrDefault("api-version")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "api-version", valid_574284
  var valid_574285 = query.getOrDefault("$expand")
  valid_574285 = validateParameter(valid_574285, JString, required = false,
                                 default = nil)
  if valid_574285 != nil:
    section.add "$expand", valid_574285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574286: Call_BillingProfilesGet_574279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the billing profile by id.
  ## 
  let valid = call_574286.validator(path, query, header, formData, body)
  let scheme = call_574286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574286.url(scheme.get, call_574286.host, call_574286.base,
                         call_574286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574286, url, valid)

proc call*(call_574287: Call_BillingProfilesGet_574279; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          Expand: string = ""): Recallable =
  ## billingProfilesGet
  ## Get the billing profile by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574288 = newJObject()
  var query_574289 = newJObject()
  add(query_574289, "api-version", newJString(apiVersion))
  add(query_574289, "$expand", newJString(Expand))
  add(path_574288, "billingAccountName", newJString(billingAccountName))
  add(path_574288, "billingProfileName", newJString(billingProfileName))
  result = call_574287.call(path_574288, query_574289, nil, nil, nil)

var billingProfilesGet* = Call_BillingProfilesGet_574279(
    name: "billingProfilesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesGet_574280, base: "",
    url: url_BillingProfilesGet_574281, schemes: {Scheme.Https})
type
  Call_BillingProfilesUpdate_574302 = ref object of OpenApiRestCall_573667
proc url_BillingProfilesUpdate_574304(protocol: Scheme; host: string; base: string;
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

proc validate_BillingProfilesUpdate_574303(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a billing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574305 = path.getOrDefault("billingAccountName")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "billingAccountName", valid_574305
  var valid_574306 = path.getOrDefault("billingProfileName")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "billingProfileName", valid_574306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574307 = query.getOrDefault("api-version")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "api-version", valid_574307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the update billing profile operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574309: Call_BillingProfilesUpdate_574302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a billing profile.
  ## 
  let valid = call_574309.validator(path, query, header, formData, body)
  let scheme = call_574309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574309.url(scheme.get, call_574309.host, call_574309.base,
                         call_574309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574309, url, valid)

proc call*(call_574310: Call_BillingProfilesUpdate_574302; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## billingProfilesUpdate
  ## The operation to update a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the update billing profile operation.
  var path_574311 = newJObject()
  var query_574312 = newJObject()
  var body_574313 = newJObject()
  add(query_574312, "api-version", newJString(apiVersion))
  add(path_574311, "billingAccountName", newJString(billingAccountName))
  add(path_574311, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574313 = parameters
  result = call_574310.call(path_574311, query_574312, nil, nil, body_574313)

var billingProfilesUpdate* = Call_BillingProfilesUpdate_574302(
    name: "billingProfilesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesUpdate_574303, base: "",
    url: url_BillingProfilesUpdate_574304, schemes: {Scheme.Https})
type
  Call_AvailableBalancesGetByBillingProfile_574314 = ref object of OpenApiRestCall_573667
proc url_AvailableBalancesGetByBillingProfile_574316(protocol: Scheme;
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

proc validate_AvailableBalancesGetByBillingProfile_574315(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574317 = path.getOrDefault("billingAccountName")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "billingAccountName", valid_574317
  var valid_574318 = path.getOrDefault("billingProfileName")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "billingProfileName", valid_574318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574319 = query.getOrDefault("api-version")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "api-version", valid_574319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574320: Call_AvailableBalancesGetByBillingProfile_574314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ## 
  let valid = call_574320.validator(path, query, header, formData, body)
  let scheme = call_574320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574320.url(scheme.get, call_574320.host, call_574320.base,
                         call_574320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574320, url, valid)

proc call*(call_574321: Call_AvailableBalancesGetByBillingProfile_574314;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## availableBalancesGetByBillingProfile
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574322 = newJObject()
  var query_574323 = newJObject()
  add(query_574323, "api-version", newJString(apiVersion))
  add(path_574322, "billingAccountName", newJString(billingAccountName))
  add(path_574322, "billingProfileName", newJString(billingProfileName))
  result = call_574321.call(path_574322, query_574323, nil, nil, nil)

var availableBalancesGetByBillingProfile* = Call_AvailableBalancesGetByBillingProfile_574314(
    name: "availableBalancesGetByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/availableBalance/default",
    validator: validate_AvailableBalancesGetByBillingProfile_574315, base: "",
    url: url_AvailableBalancesGetByBillingProfile_574316, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByBillingProfile_574324 = ref object of OpenApiRestCall_573667
proc url_BillingPermissionsListByBillingProfile_574326(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByBillingProfile_574325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing permissions the caller has for a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574327 = path.getOrDefault("billingAccountName")
  valid_574327 = validateParameter(valid_574327, JString, required = true,
                                 default = nil)
  if valid_574327 != nil:
    section.add "billingAccountName", valid_574327
  var valid_574328 = path.getOrDefault("billingProfileName")
  valid_574328 = validateParameter(valid_574328, JString, required = true,
                                 default = nil)
  if valid_574328 != nil:
    section.add "billingProfileName", valid_574328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574329 = query.getOrDefault("api-version")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "api-version", valid_574329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574330: Call_BillingPermissionsListByBillingProfile_574324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions the caller has for a billing account.
  ## 
  let valid = call_574330.validator(path, query, header, formData, body)
  let scheme = call_574330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574330.url(scheme.get, call_574330.host, call_574330.base,
                         call_574330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574330, url, valid)

proc call*(call_574331: Call_BillingPermissionsListByBillingProfile_574324;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingPermissionsListByBillingProfile
  ## Lists all billing permissions the caller has for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574332 = newJObject()
  var query_574333 = newJObject()
  add(query_574333, "api-version", newJString(apiVersion))
  add(path_574332, "billingAccountName", newJString(billingAccountName))
  add(path_574332, "billingProfileName", newJString(billingProfileName))
  result = call_574331.call(path_574332, query_574333, nil, nil, nil)

var billingPermissionsListByBillingProfile* = Call_BillingPermissionsListByBillingProfile_574324(
    name: "billingPermissionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingPermissions",
    validator: validate_BillingPermissionsListByBillingProfile_574325, base: "",
    url: url_BillingPermissionsListByBillingProfile_574326,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByBillingProfile_574334 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsListByBillingProfile_574336(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/billingRoleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsListByBillingProfile_574335(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignments on the Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574337 = path.getOrDefault("billingAccountName")
  valid_574337 = validateParameter(valid_574337, JString, required = true,
                                 default = nil)
  if valid_574337 != nil:
    section.add "billingAccountName", valid_574337
  var valid_574338 = path.getOrDefault("billingProfileName")
  valid_574338 = validateParameter(valid_574338, JString, required = true,
                                 default = nil)
  if valid_574338 != nil:
    section.add "billingProfileName", valid_574338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574339 = query.getOrDefault("api-version")
  valid_574339 = validateParameter(valid_574339, JString, required = true,
                                 default = nil)
  if valid_574339 != nil:
    section.add "api-version", valid_574339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574340: Call_BillingRoleAssignmentsListByBillingProfile_574334;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the Billing Profile
  ## 
  let valid = call_574340.validator(path, query, header, formData, body)
  let scheme = call_574340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574340.url(scheme.get, call_574340.host, call_574340.base,
                         call_574340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574340, url, valid)

proc call*(call_574341: Call_BillingRoleAssignmentsListByBillingProfile_574334;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsListByBillingProfile
  ## Get the role assignments on the Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574342 = newJObject()
  var query_574343 = newJObject()
  add(query_574343, "api-version", newJString(apiVersion))
  add(path_574342, "billingAccountName", newJString(billingAccountName))
  add(path_574342, "billingProfileName", newJString(billingProfileName))
  result = call_574341.call(path_574342, query_574343, nil, nil, nil)

var billingRoleAssignmentsListByBillingProfile* = Call_BillingRoleAssignmentsListByBillingProfile_574334(
    name: "billingRoleAssignmentsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByBillingProfile_574335,
    base: "", url: url_BillingRoleAssignmentsListByBillingProfile_574336,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByBillingProfile_574344 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsGetByBillingProfile_574346(protocol: Scheme;
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
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsGetByBillingProfile_574345(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignment for the caller on the Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_574347 = path.getOrDefault("billingRoleAssignmentName")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "billingRoleAssignmentName", valid_574347
  var valid_574348 = path.getOrDefault("billingAccountName")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "billingAccountName", valid_574348
  var valid_574349 = path.getOrDefault("billingProfileName")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "billingProfileName", valid_574349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574350 = query.getOrDefault("api-version")
  valid_574350 = validateParameter(valid_574350, JString, required = true,
                                 default = nil)
  if valid_574350 != nil:
    section.add "api-version", valid_574350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574351: Call_BillingRoleAssignmentsGetByBillingProfile_574344;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller on the Billing Profile
  ## 
  let valid = call_574351.validator(path, query, header, formData, body)
  let scheme = call_574351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574351.url(scheme.get, call_574351.host, call_574351.base,
                         call_574351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574351, url, valid)

proc call*(call_574352: Call_BillingRoleAssignmentsGetByBillingProfile_574344;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsGetByBillingProfile
  ## Get the role assignment for the caller on the Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574353 = newJObject()
  var query_574354 = newJObject()
  add(query_574354, "api-version", newJString(apiVersion))
  add(path_574353, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_574353, "billingAccountName", newJString(billingAccountName))
  add(path_574353, "billingProfileName", newJString(billingProfileName))
  result = call_574352.call(path_574353, query_574354, nil, nil, nil)

var billingRoleAssignmentsGetByBillingProfile* = Call_BillingRoleAssignmentsGetByBillingProfile_574344(
    name: "billingRoleAssignmentsGetByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByBillingProfile_574345,
    base: "", url: url_BillingRoleAssignmentsGetByBillingProfile_574346,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByBillingProfile_574355 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsDeleteByBillingProfile_574357(protocol: Scheme;
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
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsDeleteByBillingProfile_574356(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the role assignment on this Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_574358 = path.getOrDefault("billingRoleAssignmentName")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "billingRoleAssignmentName", valid_574358
  var valid_574359 = path.getOrDefault("billingAccountName")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "billingAccountName", valid_574359
  var valid_574360 = path.getOrDefault("billingProfileName")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "billingProfileName", valid_574360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574361 = query.getOrDefault("api-version")
  valid_574361 = validateParameter(valid_574361, JString, required = true,
                                 default = nil)
  if valid_574361 != nil:
    section.add "api-version", valid_574361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574362: Call_BillingRoleAssignmentsDeleteByBillingProfile_574355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on this Billing Profile
  ## 
  let valid = call_574362.validator(path, query, header, formData, body)
  let scheme = call_574362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574362.url(scheme.get, call_574362.host, call_574362.base,
                         call_574362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574362, url, valid)

proc call*(call_574363: Call_BillingRoleAssignmentsDeleteByBillingProfile_574355;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsDeleteByBillingProfile
  ## Delete the role assignment on this Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574364 = newJObject()
  var query_574365 = newJObject()
  add(query_574365, "api-version", newJString(apiVersion))
  add(path_574364, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_574364, "billingAccountName", newJString(billingAccountName))
  add(path_574364, "billingProfileName", newJString(billingProfileName))
  result = call_574363.call(path_574364, query_574365, nil, nil, nil)

var billingRoleAssignmentsDeleteByBillingProfile* = Call_BillingRoleAssignmentsDeleteByBillingProfile_574355(
    name: "billingRoleAssignmentsDeleteByBillingProfile",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByBillingProfile_574356,
    base: "", url: url_BillingRoleAssignmentsDeleteByBillingProfile_574357,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByBillingProfile_574366 = ref object of OpenApiRestCall_573667
proc url_BillingRoleDefinitionsListByBillingProfile_574368(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/billingRoleDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsListByBillingProfile_574367(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the role definition for a Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574369 = path.getOrDefault("billingAccountName")
  valid_574369 = validateParameter(valid_574369, JString, required = true,
                                 default = nil)
  if valid_574369 != nil:
    section.add "billingAccountName", valid_574369
  var valid_574370 = path.getOrDefault("billingProfileName")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "billingProfileName", valid_574370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574371 = query.getOrDefault("api-version")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "api-version", valid_574371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574372: Call_BillingRoleDefinitionsListByBillingProfile_574366;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for a Billing Profile
  ## 
  let valid = call_574372.validator(path, query, header, formData, body)
  let scheme = call_574372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574372.url(scheme.get, call_574372.host, call_574372.base,
                         call_574372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574372, url, valid)

proc call*(call_574373: Call_BillingRoleDefinitionsListByBillingProfile_574366;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleDefinitionsListByBillingProfile
  ## Lists the role definition for a Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574374 = newJObject()
  var query_574375 = newJObject()
  add(query_574375, "api-version", newJString(apiVersion))
  add(path_574374, "billingAccountName", newJString(billingAccountName))
  add(path_574374, "billingProfileName", newJString(billingProfileName))
  result = call_574373.call(path_574374, query_574375, nil, nil, nil)

var billingRoleDefinitionsListByBillingProfile* = Call_BillingRoleDefinitionsListByBillingProfile_574366(
    name: "billingRoleDefinitionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByBillingProfile_574367,
    base: "", url: url_BillingRoleDefinitionsListByBillingProfile_574368,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByBillingProfile_574376 = ref object of OpenApiRestCall_573667
proc url_BillingRoleDefinitionsGetByBillingProfile_574378(protocol: Scheme;
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
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/billingRoleDefinitions/"),
               (kind: VariableSegment, value: "billingRoleDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsGetByBillingProfile_574377(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the role definition for a role
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingRoleDefinitionName: JString (required)
  ##                            : role definition id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574379 = path.getOrDefault("billingAccountName")
  valid_574379 = validateParameter(valid_574379, JString, required = true,
                                 default = nil)
  if valid_574379 != nil:
    section.add "billingAccountName", valid_574379
  var valid_574380 = path.getOrDefault("billingRoleDefinitionName")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "billingRoleDefinitionName", valid_574380
  var valid_574381 = path.getOrDefault("billingProfileName")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "billingProfileName", valid_574381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574382 = query.getOrDefault("api-version")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "api-version", valid_574382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574383: Call_BillingRoleDefinitionsGetByBillingProfile_574376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_574383.validator(path, query, header, formData, body)
  let scheme = call_574383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574383.url(scheme.get, call_574383.host, call_574383.base,
                         call_574383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574383, url, valid)

proc call*(call_574384: Call_BillingRoleDefinitionsGetByBillingProfile_574376;
          apiVersion: string; billingAccountName: string;
          billingRoleDefinitionName: string; billingProfileName: string): Recallable =
  ## billingRoleDefinitionsGetByBillingProfile
  ## Gets the role definition for a role
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingRoleDefinitionName: string (required)
  ##                            : role definition id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574385 = newJObject()
  var query_574386 = newJObject()
  add(query_574386, "api-version", newJString(apiVersion))
  add(path_574385, "billingAccountName", newJString(billingAccountName))
  add(path_574385, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  add(path_574385, "billingProfileName", newJString(billingProfileName))
  result = call_574384.call(path_574385, query_574386, nil, nil, nil)

var billingRoleDefinitionsGetByBillingProfile* = Call_BillingRoleDefinitionsGetByBillingProfile_574376(
    name: "billingRoleDefinitionsGetByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByBillingProfile_574377,
    base: "", url: url_BillingRoleDefinitionsGetByBillingProfile_574378,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByBillingProfile_574387 = ref object of OpenApiRestCall_573667
proc url_BillingSubscriptionsListByBillingProfile_574389(protocol: Scheme;
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

proc validate_BillingSubscriptionsListByBillingProfile_574388(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscriptions by billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574390 = path.getOrDefault("billingAccountName")
  valid_574390 = validateParameter(valid_574390, JString, required = true,
                                 default = nil)
  if valid_574390 != nil:
    section.add "billingAccountName", valid_574390
  var valid_574391 = path.getOrDefault("billingProfileName")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "billingProfileName", valid_574391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574392 = query.getOrDefault("api-version")
  valid_574392 = validateParameter(valid_574392, JString, required = true,
                                 default = nil)
  if valid_574392 != nil:
    section.add "api-version", valid_574392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574393: Call_BillingSubscriptionsListByBillingProfile_574387;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscriptions by billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574393.validator(path, query, header, formData, body)
  let scheme = call_574393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574393.url(scheme.get, call_574393.host, call_574393.base,
                         call_574393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574393, url, valid)

proc call*(call_574394: Call_BillingSubscriptionsListByBillingProfile_574387;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingSubscriptionsListByBillingProfile
  ## Lists billing subscriptions by billing profile name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574395 = newJObject()
  var query_574396 = newJObject()
  add(query_574396, "api-version", newJString(apiVersion))
  add(path_574395, "billingAccountName", newJString(billingAccountName))
  add(path_574395, "billingProfileName", newJString(billingProfileName))
  result = call_574394.call(path_574395, query_574396, nil, nil, nil)

var billingSubscriptionsListByBillingProfile* = Call_BillingSubscriptionsListByBillingProfile_574387(
    name: "billingSubscriptionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByBillingProfile_574388, base: "",
    url: url_BillingSubscriptionsListByBillingProfile_574389,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByBillingProfile_574397 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsAddByBillingProfile_574399(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/createBillingRoleAssignment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsAddByBillingProfile_574398(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to add a role assignment to a billing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574400 = path.getOrDefault("billingAccountName")
  valid_574400 = validateParameter(valid_574400, JString, required = true,
                                 default = nil)
  if valid_574400 != nil:
    section.add "billingAccountName", valid_574400
  var valid_574401 = path.getOrDefault("billingProfileName")
  valid_574401 = validateParameter(valid_574401, JString, required = true,
                                 default = nil)
  if valid_574401 != nil:
    section.add "billingProfileName", valid_574401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574402 = query.getOrDefault("api-version")
  valid_574402 = validateParameter(valid_574402, JString, required = true,
                                 default = nil)
  if valid_574402 != nil:
    section.add "api-version", valid_574402
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

proc call*(call_574404: Call_BillingRoleAssignmentsAddByBillingProfile_574397;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a billing profile.
  ## 
  let valid = call_574404.validator(path, query, header, formData, body)
  let scheme = call_574404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574404.url(scheme.get, call_574404.host, call_574404.base,
                         call_574404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574404, url, valid)

proc call*(call_574405: Call_BillingRoleAssignmentsAddByBillingProfile_574397;
          apiVersion: string; billingAccountName: string;
          billingProfileName: string; parameters: JsonNode): Recallable =
  ## billingRoleAssignmentsAddByBillingProfile
  ## The operation to add a role assignment to a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  var path_574406 = newJObject()
  var query_574407 = newJObject()
  var body_574408 = newJObject()
  add(query_574407, "api-version", newJString(apiVersion))
  add(path_574406, "billingAccountName", newJString(billingAccountName))
  add(path_574406, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574408 = parameters
  result = call_574405.call(path_574406, query_574407, nil, nil, body_574408)

var billingRoleAssignmentsAddByBillingProfile* = Call_BillingRoleAssignmentsAddByBillingProfile_574397(
    name: "billingRoleAssignmentsAddByBillingProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByBillingProfile_574398,
    base: "", url: url_BillingRoleAssignmentsAddByBillingProfile_574399,
    schemes: {Scheme.Https})
type
  Call_CustomersListByBillingProfile_574409 = ref object of OpenApiRestCall_573667
proc url_CustomersListByBillingProfile_574411(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/customers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomersListByBillingProfile_574410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists customers by billing profile which the current user can work with on-behalf of a partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574412 = path.getOrDefault("billingAccountName")
  valid_574412 = validateParameter(valid_574412, JString, required = true,
                                 default = nil)
  if valid_574412 != nil:
    section.add "billingAccountName", valid_574412
  var valid_574413 = path.getOrDefault("billingProfileName")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "billingProfileName", valid_574413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter the list of customers.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574414 = query.getOrDefault("api-version")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = nil)
  if valid_574414 != nil:
    section.add "api-version", valid_574414
  var valid_574415 = query.getOrDefault("$skiptoken")
  valid_574415 = validateParameter(valid_574415, JString, required = false,
                                 default = nil)
  if valid_574415 != nil:
    section.add "$skiptoken", valid_574415
  var valid_574416 = query.getOrDefault("$filter")
  valid_574416 = validateParameter(valid_574416, JString, required = false,
                                 default = nil)
  if valid_574416 != nil:
    section.add "$filter", valid_574416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574417: Call_CustomersListByBillingProfile_574409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists customers by billing profile which the current user can work with on-behalf of a partner.
  ## 
  let valid = call_574417.validator(path, query, header, formData, body)
  let scheme = call_574417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574417.url(scheme.get, call_574417.host, call_574417.base,
                         call_574417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574417, url, valid)

proc call*(call_574418: Call_CustomersListByBillingProfile_574409;
          apiVersion: string; billingAccountName: string;
          billingProfileName: string; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## customersListByBillingProfile
  ## Lists customers by billing profile which the current user can work with on-behalf of a partner.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   Filter: string
  ##         : May be used to filter the list of customers.
  var path_574419 = newJObject()
  var query_574420 = newJObject()
  add(query_574420, "api-version", newJString(apiVersion))
  add(path_574419, "billingAccountName", newJString(billingAccountName))
  add(query_574420, "$skiptoken", newJString(Skiptoken))
  add(path_574419, "billingProfileName", newJString(billingProfileName))
  add(query_574420, "$filter", newJString(Filter))
  result = call_574418.call(path_574419, query_574420, nil, nil, nil)

var customersListByBillingProfile* = Call_CustomersListByBillingProfile_574409(
    name: "customersListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/customers",
    validator: validate_CustomersListByBillingProfile_574410, base: "",
    url: url_CustomersListByBillingProfile_574411, schemes: {Scheme.Https})
type
  Call_PartnerTransfersInitiate_574421 = ref object of OpenApiRestCall_573667
proc url_PartnerTransfersInitiate_574423(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/initiateTransfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerTransfersInitiate_574422(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574424 = path.getOrDefault("billingAccountName")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "billingAccountName", valid_574424
  var valid_574425 = path.getOrDefault("billingProfileName")
  valid_574425 = validateParameter(valid_574425, JString, required = true,
                                 default = nil)
  if valid_574425 != nil:
    section.add "billingProfileName", valid_574425
  var valid_574426 = path.getOrDefault("customerName")
  valid_574426 = validateParameter(valid_574426, JString, required = true,
                                 default = nil)
  if valid_574426 != nil:
    section.add "customerName", valid_574426
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to initiate the transfer.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574428: Call_PartnerTransfersInitiate_574421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  let valid = call_574428.validator(path, query, header, formData, body)
  let scheme = call_574428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574428.url(scheme.get, call_574428.host, call_574428.base,
                         call_574428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574428, url, valid)

proc call*(call_574429: Call_PartnerTransfersInitiate_574421;
          billingAccountName: string; billingProfileName: string;
          parameters: JsonNode; customerName: string): Recallable =
  ## partnerTransfersInitiate
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to initiate the transfer.
  ##   customerName: string (required)
  ##               : Customer name.
  var path_574430 = newJObject()
  var body_574431 = newJObject()
  add(path_574430, "billingAccountName", newJString(billingAccountName))
  add(path_574430, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574431 = parameters
  add(path_574430, "customerName", newJString(customerName))
  result = call_574429.call(path_574430, nil, nil, nil, body_574431)

var partnerTransfersInitiate* = Call_PartnerTransfersInitiate_574421(
    name: "partnerTransfersInitiate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/customers/{customerName}/initiateTransfer",
    validator: validate_PartnerTransfersInitiate_574422, base: "",
    url: url_PartnerTransfersInitiate_574423, schemes: {Scheme.Https})
type
  Call_PartnerTransfersTransfersList_574432 = ref object of OpenApiRestCall_573667
proc url_PartnerTransfersTransfersList_574434(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/transfers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerTransfersTransfersList_574433(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574435 = path.getOrDefault("billingAccountName")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "billingAccountName", valid_574435
  var valid_574436 = path.getOrDefault("billingProfileName")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "billingProfileName", valid_574436
  var valid_574437 = path.getOrDefault("customerName")
  valid_574437 = validateParameter(valid_574437, JString, required = true,
                                 default = nil)
  if valid_574437 != nil:
    section.add "customerName", valid_574437
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574438: Call_PartnerTransfersTransfersList_574432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  let valid = call_574438.validator(path, query, header, formData, body)
  let scheme = call_574438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574438.url(scheme.get, call_574438.host, call_574438.base,
                         call_574438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574438, url, valid)

proc call*(call_574439: Call_PartnerTransfersTransfersList_574432;
          billingAccountName: string; billingProfileName: string;
          customerName: string): Recallable =
  ## partnerTransfersTransfersList
  ## Lists all transfer's details initiated from given invoice section.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   customerName: string (required)
  ##               : Customer name.
  var path_574440 = newJObject()
  add(path_574440, "billingAccountName", newJString(billingAccountName))
  add(path_574440, "billingProfileName", newJString(billingProfileName))
  add(path_574440, "customerName", newJString(customerName))
  result = call_574439.call(path_574440, nil, nil, nil, nil)

var partnerTransfersTransfersList* = Call_PartnerTransfersTransfersList_574432(
    name: "partnerTransfersTransfersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/customers/{customerName}/transfers",
    validator: validate_PartnerTransfersTransfersList_574433, base: "",
    url: url_PartnerTransfersTransfersList_574434, schemes: {Scheme.Https})
type
  Call_PartnerTransfersGet_574441 = ref object of OpenApiRestCall_573667
proc url_PartnerTransfersGet_574443(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/transfers/"),
               (kind: VariableSegment, value: "transferName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerTransfersGet_574442(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the transfer details for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574444 = path.getOrDefault("billingAccountName")
  valid_574444 = validateParameter(valid_574444, JString, required = true,
                                 default = nil)
  if valid_574444 != nil:
    section.add "billingAccountName", valid_574444
  var valid_574445 = path.getOrDefault("billingProfileName")
  valid_574445 = validateParameter(valid_574445, JString, required = true,
                                 default = nil)
  if valid_574445 != nil:
    section.add "billingProfileName", valid_574445
  var valid_574446 = path.getOrDefault("customerName")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "customerName", valid_574446
  var valid_574447 = path.getOrDefault("transferName")
  valid_574447 = validateParameter(valid_574447, JString, required = true,
                                 default = nil)
  if valid_574447 != nil:
    section.add "transferName", valid_574447
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574448: Call_PartnerTransfersGet_574441; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the transfer details for given transfer Id.
  ## 
  let valid = call_574448.validator(path, query, header, formData, body)
  let scheme = call_574448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574448.url(scheme.get, call_574448.host, call_574448.base,
                         call_574448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574448, url, valid)

proc call*(call_574449: Call_PartnerTransfersGet_574441;
          billingAccountName: string; billingProfileName: string;
          customerName: string; transferName: string): Recallable =
  ## partnerTransfersGet
  ## Gets the transfer details for given transfer Id.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_574450 = newJObject()
  add(path_574450, "billingAccountName", newJString(billingAccountName))
  add(path_574450, "billingProfileName", newJString(billingProfileName))
  add(path_574450, "customerName", newJString(customerName))
  add(path_574450, "transferName", newJString(transferName))
  result = call_574449.call(path_574450, nil, nil, nil, nil)

var partnerTransfersGet* = Call_PartnerTransfersGet_574441(
    name: "partnerTransfersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/customers/{customerName}/transfers/{transferName}",
    validator: validate_PartnerTransfersGet_574442, base: "",
    url: url_PartnerTransfersGet_574443, schemes: {Scheme.Https})
type
  Call_PartnerTransfersCancel_574451 = ref object of OpenApiRestCall_573667
proc url_PartnerTransfersCancel_574453(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/transfers/"),
               (kind: VariableSegment, value: "transferName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerTransfersCancel_574452(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the transfer for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574454 = path.getOrDefault("billingAccountName")
  valid_574454 = validateParameter(valid_574454, JString, required = true,
                                 default = nil)
  if valid_574454 != nil:
    section.add "billingAccountName", valid_574454
  var valid_574455 = path.getOrDefault("billingProfileName")
  valid_574455 = validateParameter(valid_574455, JString, required = true,
                                 default = nil)
  if valid_574455 != nil:
    section.add "billingProfileName", valid_574455
  var valid_574456 = path.getOrDefault("customerName")
  valid_574456 = validateParameter(valid_574456, JString, required = true,
                                 default = nil)
  if valid_574456 != nil:
    section.add "customerName", valid_574456
  var valid_574457 = path.getOrDefault("transferName")
  valid_574457 = validateParameter(valid_574457, JString, required = true,
                                 default = nil)
  if valid_574457 != nil:
    section.add "transferName", valid_574457
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574458: Call_PartnerTransfersCancel_574451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the transfer for given transfer Id.
  ## 
  let valid = call_574458.validator(path, query, header, formData, body)
  let scheme = call_574458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574458.url(scheme.get, call_574458.host, call_574458.base,
                         call_574458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574458, url, valid)

proc call*(call_574459: Call_PartnerTransfersCancel_574451;
          billingAccountName: string; billingProfileName: string;
          customerName: string; transferName: string): Recallable =
  ## partnerTransfersCancel
  ## Cancels the transfer for given transfer Id.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_574460 = newJObject()
  add(path_574460, "billingAccountName", newJString(billingAccountName))
  add(path_574460, "billingProfileName", newJString(billingProfileName))
  add(path_574460, "customerName", newJString(customerName))
  add(path_574460, "transferName", newJString(transferName))
  result = call_574459.call(path_574460, nil, nil, nil, nil)

var partnerTransfersCancel* = Call_PartnerTransfersCancel_574451(
    name: "partnerTransfersCancel", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/customers/{customerName}/transfers/{transferName}",
    validator: validate_PartnerTransfersCancel_574452, base: "",
    url: url_PartnerTransfersCancel_574453, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsListByBillingProfile_574461 = ref object of OpenApiRestCall_573667
proc url_InvoiceSectionsListByBillingProfile_574463(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/invoiceSections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsListByBillingProfile_574462(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all invoice sections for a user which he has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574464 = path.getOrDefault("billingAccountName")
  valid_574464 = validateParameter(valid_574464, JString, required = true,
                                 default = nil)
  if valid_574464 != nil:
    section.add "billingAccountName", valid_574464
  var valid_574465 = path.getOrDefault("billingProfileName")
  valid_574465 = validateParameter(valid_574465, JString, required = true,
                                 default = nil)
  if valid_574465 != nil:
    section.add "billingProfileName", valid_574465
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574466 = query.getOrDefault("api-version")
  valid_574466 = validateParameter(valid_574466, JString, required = true,
                                 default = nil)
  if valid_574466 != nil:
    section.add "api-version", valid_574466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574467: Call_InvoiceSectionsListByBillingProfile_574461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoice sections for a user which he has access to.
  ## 
  let valid = call_574467.validator(path, query, header, formData, body)
  let scheme = call_574467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574467.url(scheme.get, call_574467.host, call_574467.base,
                         call_574467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574467, url, valid)

proc call*(call_574468: Call_InvoiceSectionsListByBillingProfile_574461;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## invoiceSectionsListByBillingProfile
  ## Lists all invoice sections for a user which he has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574469 = newJObject()
  var query_574470 = newJObject()
  add(query_574470, "api-version", newJString(apiVersion))
  add(path_574469, "billingAccountName", newJString(billingAccountName))
  add(path_574469, "billingProfileName", newJString(billingProfileName))
  result = call_574468.call(path_574469, query_574470, nil, nil, nil)

var invoiceSectionsListByBillingProfile* = Call_InvoiceSectionsListByBillingProfile_574461(
    name: "invoiceSectionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections",
    validator: validate_InvoiceSectionsListByBillingProfile_574462, base: "",
    url: url_InvoiceSectionsListByBillingProfile_574463, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsCreate_574482 = ref object of OpenApiRestCall_573667
proc url_InvoiceSectionsCreate_574484(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsCreate_574483(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574485 = path.getOrDefault("billingAccountName")
  valid_574485 = validateParameter(valid_574485, JString, required = true,
                                 default = nil)
  if valid_574485 != nil:
    section.add "billingAccountName", valid_574485
  var valid_574486 = path.getOrDefault("invoiceSectionName")
  valid_574486 = validateParameter(valid_574486, JString, required = true,
                                 default = nil)
  if valid_574486 != nil:
    section.add "invoiceSectionName", valid_574486
  var valid_574487 = path.getOrDefault("billingProfileName")
  valid_574487 = validateParameter(valid_574487, JString, required = true,
                                 default = nil)
  if valid_574487 != nil:
    section.add "billingProfileName", valid_574487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574488 = query.getOrDefault("api-version")
  valid_574488 = validateParameter(valid_574488, JString, required = true,
                                 default = nil)
  if valid_574488 != nil:
    section.add "api-version", valid_574488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the Create InvoiceSection operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574490: Call_InvoiceSectionsCreate_574482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create an invoice section.
  ## 
  let valid = call_574490.validator(path, query, header, formData, body)
  let scheme = call_574490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574490.url(scheme.get, call_574490.host, call_574490.base,
                         call_574490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574490, url, valid)

proc call*(call_574491: Call_InvoiceSectionsCreate_574482; apiVersion: string;
          billingAccountName: string; invoiceSectionName: string;
          billingProfileName: string; parameters: JsonNode): Recallable =
  ## invoiceSectionsCreate
  ## The operation to create an invoice section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the Create InvoiceSection operation.
  var path_574492 = newJObject()
  var query_574493 = newJObject()
  var body_574494 = newJObject()
  add(query_574493, "api-version", newJString(apiVersion))
  add(path_574492, "billingAccountName", newJString(billingAccountName))
  add(path_574492, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574492, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574494 = parameters
  result = call_574491.call(path_574492, query_574493, nil, nil, body_574494)

var invoiceSectionsCreate* = Call_InvoiceSectionsCreate_574482(
    name: "invoiceSectionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsCreate_574483, base: "",
    url: url_InvoiceSectionsCreate_574484, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsGet_574471 = ref object of OpenApiRestCall_573667
proc url_InvoiceSectionsGet_574473(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsGet_574472(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the InvoiceSection by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574474 = path.getOrDefault("billingAccountName")
  valid_574474 = validateParameter(valid_574474, JString, required = true,
                                 default = nil)
  if valid_574474 != nil:
    section.add "billingAccountName", valid_574474
  var valid_574475 = path.getOrDefault("invoiceSectionName")
  valid_574475 = validateParameter(valid_574475, JString, required = true,
                                 default = nil)
  if valid_574475 != nil:
    section.add "invoiceSectionName", valid_574475
  var valid_574476 = path.getOrDefault("billingProfileName")
  valid_574476 = validateParameter(valid_574476, JString, required = true,
                                 default = nil)
  if valid_574476 != nil:
    section.add "billingProfileName", valid_574476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574477 = query.getOrDefault("api-version")
  valid_574477 = validateParameter(valid_574477, JString, required = true,
                                 default = nil)
  if valid_574477 != nil:
    section.add "api-version", valid_574477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574478: Call_InvoiceSectionsGet_574471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the InvoiceSection by id.
  ## 
  let valid = call_574478.validator(path, query, header, formData, body)
  let scheme = call_574478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574478.url(scheme.get, call_574478.host, call_574478.base,
                         call_574478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574478, url, valid)

proc call*(call_574479: Call_InvoiceSectionsGet_574471; apiVersion: string;
          billingAccountName: string; invoiceSectionName: string;
          billingProfileName: string): Recallable =
  ## invoiceSectionsGet
  ## Get the InvoiceSection by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574480 = newJObject()
  var query_574481 = newJObject()
  add(query_574481, "api-version", newJString(apiVersion))
  add(path_574480, "billingAccountName", newJString(billingAccountName))
  add(path_574480, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574480, "billingProfileName", newJString(billingProfileName))
  result = call_574479.call(path_574480, query_574481, nil, nil, nil)

var invoiceSectionsGet* = Call_InvoiceSectionsGet_574471(
    name: "invoiceSectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsGet_574472, base: "",
    url: url_InvoiceSectionsGet_574473, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsUpdate_574495 = ref object of OpenApiRestCall_573667
proc url_InvoiceSectionsUpdate_574497(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsUpdate_574496(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a InvoiceSection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574498 = path.getOrDefault("billingAccountName")
  valid_574498 = validateParameter(valid_574498, JString, required = true,
                                 default = nil)
  if valid_574498 != nil:
    section.add "billingAccountName", valid_574498
  var valid_574499 = path.getOrDefault("invoiceSectionName")
  valid_574499 = validateParameter(valid_574499, JString, required = true,
                                 default = nil)
  if valid_574499 != nil:
    section.add "invoiceSectionName", valid_574499
  var valid_574500 = path.getOrDefault("billingProfileName")
  valid_574500 = validateParameter(valid_574500, JString, required = true,
                                 default = nil)
  if valid_574500 != nil:
    section.add "billingProfileName", valid_574500
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574501 = query.getOrDefault("api-version")
  valid_574501 = validateParameter(valid_574501, JString, required = true,
                                 default = nil)
  if valid_574501 != nil:
    section.add "api-version", valid_574501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the Create InvoiceSection operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574503: Call_InvoiceSectionsUpdate_574495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a InvoiceSection.
  ## 
  let valid = call_574503.validator(path, query, header, formData, body)
  let scheme = call_574503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574503.url(scheme.get, call_574503.host, call_574503.base,
                         call_574503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574503, url, valid)

proc call*(call_574504: Call_InvoiceSectionsUpdate_574495; apiVersion: string;
          billingAccountName: string; invoiceSectionName: string;
          billingProfileName: string; parameters: JsonNode): Recallable =
  ## invoiceSectionsUpdate
  ## The operation to update a InvoiceSection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the Create InvoiceSection operation.
  var path_574505 = newJObject()
  var query_574506 = newJObject()
  var body_574507 = newJObject()
  add(query_574506, "api-version", newJString(apiVersion))
  add(path_574505, "billingAccountName", newJString(billingAccountName))
  add(path_574505, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574505, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574507 = parameters
  result = call_574504.call(path_574505, query_574506, nil, nil, body_574507)

var invoiceSectionsUpdate* = Call_InvoiceSectionsUpdate_574495(
    name: "invoiceSectionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsUpdate_574496, base: "",
    url: url_InvoiceSectionsUpdate_574497, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByInvoiceSections_574508 = ref object of OpenApiRestCall_573667
proc url_BillingPermissionsListByInvoiceSections_574510(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByInvoiceSections_574509(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing permissions for the caller under invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574511 = path.getOrDefault("billingAccountName")
  valid_574511 = validateParameter(valid_574511, JString, required = true,
                                 default = nil)
  if valid_574511 != nil:
    section.add "billingAccountName", valid_574511
  var valid_574512 = path.getOrDefault("invoiceSectionName")
  valid_574512 = validateParameter(valid_574512, JString, required = true,
                                 default = nil)
  if valid_574512 != nil:
    section.add "invoiceSectionName", valid_574512
  var valid_574513 = path.getOrDefault("billingProfileName")
  valid_574513 = validateParameter(valid_574513, JString, required = true,
                                 default = nil)
  if valid_574513 != nil:
    section.add "billingProfileName", valid_574513
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574514 = query.getOrDefault("api-version")
  valid_574514 = validateParameter(valid_574514, JString, required = true,
                                 default = nil)
  if valid_574514 != nil:
    section.add "api-version", valid_574514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574515: Call_BillingPermissionsListByInvoiceSections_574508;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under invoice section.
  ## 
  let valid = call_574515.validator(path, query, header, formData, body)
  let scheme = call_574515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574515.url(scheme.get, call_574515.host, call_574515.base,
                         call_574515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574515, url, valid)

proc call*(call_574516: Call_BillingPermissionsListByInvoiceSections_574508;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string): Recallable =
  ## billingPermissionsListByInvoiceSections
  ## Lists all billing permissions for the caller under invoice section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574517 = newJObject()
  var query_574518 = newJObject()
  add(query_574518, "api-version", newJString(apiVersion))
  add(path_574517, "billingAccountName", newJString(billingAccountName))
  add(path_574517, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574517, "billingProfileName", newJString(billingProfileName))
  result = call_574516.call(path_574517, query_574518, nil, nil, nil)

var billingPermissionsListByInvoiceSections* = Call_BillingPermissionsListByInvoiceSections_574508(
    name: "billingPermissionsListByInvoiceSections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingPermissions",
    validator: validate_BillingPermissionsListByInvoiceSections_574509, base: "",
    url: url_BillingPermissionsListByInvoiceSections_574510,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByInvoiceSection_574519 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsListByInvoiceSection_574521(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingRoleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsListByInvoiceSection_574520(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignments on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574522 = path.getOrDefault("billingAccountName")
  valid_574522 = validateParameter(valid_574522, JString, required = true,
                                 default = nil)
  if valid_574522 != nil:
    section.add "billingAccountName", valid_574522
  var valid_574523 = path.getOrDefault("invoiceSectionName")
  valid_574523 = validateParameter(valid_574523, JString, required = true,
                                 default = nil)
  if valid_574523 != nil:
    section.add "invoiceSectionName", valid_574523
  var valid_574524 = path.getOrDefault("billingProfileName")
  valid_574524 = validateParameter(valid_574524, JString, required = true,
                                 default = nil)
  if valid_574524 != nil:
    section.add "billingProfileName", valid_574524
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574525 = query.getOrDefault("api-version")
  valid_574525 = validateParameter(valid_574525, JString, required = true,
                                 default = nil)
  if valid_574525 != nil:
    section.add "api-version", valid_574525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574526: Call_BillingRoleAssignmentsListByInvoiceSection_574519;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the invoice Section
  ## 
  let valid = call_574526.validator(path, query, header, formData, body)
  let scheme = call_574526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574526.url(scheme.get, call_574526.host, call_574526.base,
                         call_574526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574526, url, valid)

proc call*(call_574527: Call_BillingRoleAssignmentsListByInvoiceSection_574519;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsListByInvoiceSection
  ## Get the role assignments on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574528 = newJObject()
  var query_574529 = newJObject()
  add(query_574529, "api-version", newJString(apiVersion))
  add(path_574528, "billingAccountName", newJString(billingAccountName))
  add(path_574528, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574528, "billingProfileName", newJString(billingProfileName))
  result = call_574527.call(path_574528, query_574529, nil, nil, nil)

var billingRoleAssignmentsListByInvoiceSection* = Call_BillingRoleAssignmentsListByInvoiceSection_574519(
    name: "billingRoleAssignmentsListByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByInvoiceSection_574520,
    base: "", url: url_BillingRoleAssignmentsListByInvoiceSection_574521,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByInvoiceSection_574530 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsGetByInvoiceSection_574532(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsGetByInvoiceSection_574531(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignment for the caller on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_574533 = path.getOrDefault("billingRoleAssignmentName")
  valid_574533 = validateParameter(valid_574533, JString, required = true,
                                 default = nil)
  if valid_574533 != nil:
    section.add "billingRoleAssignmentName", valid_574533
  var valid_574534 = path.getOrDefault("billingAccountName")
  valid_574534 = validateParameter(valid_574534, JString, required = true,
                                 default = nil)
  if valid_574534 != nil:
    section.add "billingAccountName", valid_574534
  var valid_574535 = path.getOrDefault("invoiceSectionName")
  valid_574535 = validateParameter(valid_574535, JString, required = true,
                                 default = nil)
  if valid_574535 != nil:
    section.add "invoiceSectionName", valid_574535
  var valid_574536 = path.getOrDefault("billingProfileName")
  valid_574536 = validateParameter(valid_574536, JString, required = true,
                                 default = nil)
  if valid_574536 != nil:
    section.add "billingProfileName", valid_574536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574537 = query.getOrDefault("api-version")
  valid_574537 = validateParameter(valid_574537, JString, required = true,
                                 default = nil)
  if valid_574537 != nil:
    section.add "api-version", valid_574537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574538: Call_BillingRoleAssignmentsGetByInvoiceSection_574530;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller on the invoice Section
  ## 
  let valid = call_574538.validator(path, query, header, formData, body)
  let scheme = call_574538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574538.url(scheme.get, call_574538.host, call_574538.base,
                         call_574538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574538, url, valid)

proc call*(call_574539: Call_BillingRoleAssignmentsGetByInvoiceSection_574530;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; invoiceSectionName: string;
          billingProfileName: string): Recallable =
  ## billingRoleAssignmentsGetByInvoiceSection
  ## Get the role assignment for the caller on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574540 = newJObject()
  var query_574541 = newJObject()
  add(query_574541, "api-version", newJString(apiVersion))
  add(path_574540, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_574540, "billingAccountName", newJString(billingAccountName))
  add(path_574540, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574540, "billingProfileName", newJString(billingProfileName))
  result = call_574539.call(path_574540, query_574541, nil, nil, nil)

var billingRoleAssignmentsGetByInvoiceSection* = Call_BillingRoleAssignmentsGetByInvoiceSection_574530(
    name: "billingRoleAssignmentsGetByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByInvoiceSection_574531,
    base: "", url: url_BillingRoleAssignmentsGetByInvoiceSection_574532,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByInvoiceSection_574542 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsDeleteByInvoiceSection_574544(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsDeleteByInvoiceSection_574543(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the role assignment on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_574545 = path.getOrDefault("billingRoleAssignmentName")
  valid_574545 = validateParameter(valid_574545, JString, required = true,
                                 default = nil)
  if valid_574545 != nil:
    section.add "billingRoleAssignmentName", valid_574545
  var valid_574546 = path.getOrDefault("billingAccountName")
  valid_574546 = validateParameter(valid_574546, JString, required = true,
                                 default = nil)
  if valid_574546 != nil:
    section.add "billingAccountName", valid_574546
  var valid_574547 = path.getOrDefault("invoiceSectionName")
  valid_574547 = validateParameter(valid_574547, JString, required = true,
                                 default = nil)
  if valid_574547 != nil:
    section.add "invoiceSectionName", valid_574547
  var valid_574548 = path.getOrDefault("billingProfileName")
  valid_574548 = validateParameter(valid_574548, JString, required = true,
                                 default = nil)
  if valid_574548 != nil:
    section.add "billingProfileName", valid_574548
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574549 = query.getOrDefault("api-version")
  valid_574549 = validateParameter(valid_574549, JString, required = true,
                                 default = nil)
  if valid_574549 != nil:
    section.add "api-version", valid_574549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574550: Call_BillingRoleAssignmentsDeleteByInvoiceSection_574542;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on the invoice Section
  ## 
  let valid = call_574550.validator(path, query, header, formData, body)
  let scheme = call_574550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574550.url(scheme.get, call_574550.host, call_574550.base,
                         call_574550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574550, url, valid)

proc call*(call_574551: Call_BillingRoleAssignmentsDeleteByInvoiceSection_574542;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; invoiceSectionName: string;
          billingProfileName: string): Recallable =
  ## billingRoleAssignmentsDeleteByInvoiceSection
  ## Delete the role assignment on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574552 = newJObject()
  var query_574553 = newJObject()
  add(query_574553, "api-version", newJString(apiVersion))
  add(path_574552, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_574552, "billingAccountName", newJString(billingAccountName))
  add(path_574552, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574552, "billingProfileName", newJString(billingProfileName))
  result = call_574551.call(path_574552, query_574553, nil, nil, nil)

var billingRoleAssignmentsDeleteByInvoiceSection* = Call_BillingRoleAssignmentsDeleteByInvoiceSection_574542(
    name: "billingRoleAssignmentsDeleteByInvoiceSection",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByInvoiceSection_574543,
    base: "", url: url_BillingRoleAssignmentsDeleteByInvoiceSection_574544,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByInvoiceSection_574554 = ref object of OpenApiRestCall_573667
proc url_BillingRoleDefinitionsListByInvoiceSection_574556(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingRoleDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsListByInvoiceSection_574555(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the role definition for an invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574557 = path.getOrDefault("billingAccountName")
  valid_574557 = validateParameter(valid_574557, JString, required = true,
                                 default = nil)
  if valid_574557 != nil:
    section.add "billingAccountName", valid_574557
  var valid_574558 = path.getOrDefault("invoiceSectionName")
  valid_574558 = validateParameter(valid_574558, JString, required = true,
                                 default = nil)
  if valid_574558 != nil:
    section.add "invoiceSectionName", valid_574558
  var valid_574559 = path.getOrDefault("billingProfileName")
  valid_574559 = validateParameter(valid_574559, JString, required = true,
                                 default = nil)
  if valid_574559 != nil:
    section.add "billingProfileName", valid_574559
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574560 = query.getOrDefault("api-version")
  valid_574560 = validateParameter(valid_574560, JString, required = true,
                                 default = nil)
  if valid_574560 != nil:
    section.add "api-version", valid_574560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574561: Call_BillingRoleDefinitionsListByInvoiceSection_574554;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for an invoice Section
  ## 
  let valid = call_574561.validator(path, query, header, formData, body)
  let scheme = call_574561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574561.url(scheme.get, call_574561.host, call_574561.base,
                         call_574561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574561, url, valid)

proc call*(call_574562: Call_BillingRoleDefinitionsListByInvoiceSection_574554;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string): Recallable =
  ## billingRoleDefinitionsListByInvoiceSection
  ## Lists the role definition for an invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574563 = newJObject()
  var query_574564 = newJObject()
  add(query_574564, "api-version", newJString(apiVersion))
  add(path_574563, "billingAccountName", newJString(billingAccountName))
  add(path_574563, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574563, "billingProfileName", newJString(billingProfileName))
  result = call_574562.call(path_574563, query_574564, nil, nil, nil)

var billingRoleDefinitionsListByInvoiceSection* = Call_BillingRoleDefinitionsListByInvoiceSection_574554(
    name: "billingRoleDefinitionsListByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByInvoiceSection_574555,
    base: "", url: url_BillingRoleDefinitionsListByInvoiceSection_574556,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByInvoiceSection_574565 = ref object of OpenApiRestCall_573667
proc url_BillingRoleDefinitionsGetByInvoiceSection_574567(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingRoleDefinitionName" in path,
        "`billingRoleDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingRoleDefinitions/"),
               (kind: VariableSegment, value: "billingRoleDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsGetByInvoiceSection_574566(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the role definition for a role
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingRoleDefinitionName: JString (required)
  ##                            : role definition id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574568 = path.getOrDefault("billingAccountName")
  valid_574568 = validateParameter(valid_574568, JString, required = true,
                                 default = nil)
  if valid_574568 != nil:
    section.add "billingAccountName", valid_574568
  var valid_574569 = path.getOrDefault("invoiceSectionName")
  valid_574569 = validateParameter(valid_574569, JString, required = true,
                                 default = nil)
  if valid_574569 != nil:
    section.add "invoiceSectionName", valid_574569
  var valid_574570 = path.getOrDefault("billingRoleDefinitionName")
  valid_574570 = validateParameter(valid_574570, JString, required = true,
                                 default = nil)
  if valid_574570 != nil:
    section.add "billingRoleDefinitionName", valid_574570
  var valid_574571 = path.getOrDefault("billingProfileName")
  valid_574571 = validateParameter(valid_574571, JString, required = true,
                                 default = nil)
  if valid_574571 != nil:
    section.add "billingProfileName", valid_574571
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574572 = query.getOrDefault("api-version")
  valid_574572 = validateParameter(valid_574572, JString, required = true,
                                 default = nil)
  if valid_574572 != nil:
    section.add "api-version", valid_574572
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574573: Call_BillingRoleDefinitionsGetByInvoiceSection_574565;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_574573.validator(path, query, header, formData, body)
  let scheme = call_574573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574573.url(scheme.get, call_574573.host, call_574573.base,
                         call_574573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574573, url, valid)

proc call*(call_574574: Call_BillingRoleDefinitionsGetByInvoiceSection_574565;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingRoleDefinitionName: string;
          billingProfileName: string): Recallable =
  ## billingRoleDefinitionsGetByInvoiceSection
  ## Gets the role definition for a role
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingRoleDefinitionName: string (required)
  ##                            : role definition id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574575 = newJObject()
  var query_574576 = newJObject()
  add(query_574576, "api-version", newJString(apiVersion))
  add(path_574575, "billingAccountName", newJString(billingAccountName))
  add(path_574575, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574575, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  add(path_574575, "billingProfileName", newJString(billingProfileName))
  result = call_574574.call(path_574575, query_574576, nil, nil, nil)

var billingRoleDefinitionsGetByInvoiceSection* = Call_BillingRoleDefinitionsGetByInvoiceSection_574565(
    name: "billingRoleDefinitionsGetByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByInvoiceSection_574566,
    base: "", url: url_BillingRoleDefinitionsGetByInvoiceSection_574567,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByInvoiceSection_574577 = ref object of OpenApiRestCall_573667
proc url_BillingSubscriptionsListByInvoiceSection_574579(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsListByInvoiceSection_574578(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscription by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574580 = path.getOrDefault("billingAccountName")
  valid_574580 = validateParameter(valid_574580, JString, required = true,
                                 default = nil)
  if valid_574580 != nil:
    section.add "billingAccountName", valid_574580
  var valid_574581 = path.getOrDefault("invoiceSectionName")
  valid_574581 = validateParameter(valid_574581, JString, required = true,
                                 default = nil)
  if valid_574581 != nil:
    section.add "invoiceSectionName", valid_574581
  var valid_574582 = path.getOrDefault("billingProfileName")
  valid_574582 = validateParameter(valid_574582, JString, required = true,
                                 default = nil)
  if valid_574582 != nil:
    section.add "billingProfileName", valid_574582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574583 = query.getOrDefault("api-version")
  valid_574583 = validateParameter(valid_574583, JString, required = true,
                                 default = nil)
  if valid_574583 != nil:
    section.add "api-version", valid_574583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574584: Call_BillingSubscriptionsListByInvoiceSection_574577;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscription by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574584.validator(path, query, header, formData, body)
  let scheme = call_574584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574584.url(scheme.get, call_574584.host, call_574584.base,
                         call_574584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574584, url, valid)

proc call*(call_574585: Call_BillingSubscriptionsListByInvoiceSection_574577;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string): Recallable =
  ## billingSubscriptionsListByInvoiceSection
  ## Lists billing subscription by invoice section name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574586 = newJObject()
  var query_574587 = newJObject()
  add(query_574587, "api-version", newJString(apiVersion))
  add(path_574586, "billingAccountName", newJString(billingAccountName))
  add(path_574586, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574586, "billingProfileName", newJString(billingProfileName))
  result = call_574585.call(path_574586, query_574587, nil, nil, nil)

var billingSubscriptionsListByInvoiceSection* = Call_BillingSubscriptionsListByInvoiceSection_574577(
    name: "billingSubscriptionsListByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByInvoiceSection_574578, base: "",
    url: url_BillingSubscriptionsListByInvoiceSection_574579,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsGet_574588 = ref object of OpenApiRestCall_573667
proc url_BillingSubscriptionsGet_574590(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingSubscriptionName" in path,
        "`billingSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions/"),
               (kind: VariableSegment, value: "billingSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsGet_574589(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574591 = path.getOrDefault("billingAccountName")
  valid_574591 = validateParameter(valid_574591, JString, required = true,
                                 default = nil)
  if valid_574591 != nil:
    section.add "billingAccountName", valid_574591
  var valid_574592 = path.getOrDefault("billingSubscriptionName")
  valid_574592 = validateParameter(valid_574592, JString, required = true,
                                 default = nil)
  if valid_574592 != nil:
    section.add "billingSubscriptionName", valid_574592
  var valid_574593 = path.getOrDefault("invoiceSectionName")
  valid_574593 = validateParameter(valid_574593, JString, required = true,
                                 default = nil)
  if valid_574593 != nil:
    section.add "invoiceSectionName", valid_574593
  var valid_574594 = path.getOrDefault("billingProfileName")
  valid_574594 = validateParameter(valid_574594, JString, required = true,
                                 default = nil)
  if valid_574594 != nil:
    section.add "billingProfileName", valid_574594
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574595 = query.getOrDefault("api-version")
  valid_574595 = validateParameter(valid_574595, JString, required = true,
                                 default = nil)
  if valid_574595 != nil:
    section.add "api-version", valid_574595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574596: Call_BillingSubscriptionsGet_574588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574596.validator(path, query, header, formData, body)
  let scheme = call_574596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574596.url(scheme.get, call_574596.host, call_574596.base,
                         call_574596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574596, url, valid)

proc call*(call_574597: Call_BillingSubscriptionsGet_574588; apiVersion: string;
          billingAccountName: string; billingSubscriptionName: string;
          invoiceSectionName: string; billingProfileName: string): Recallable =
  ## billingSubscriptionsGet
  ## Get a single billing subscription by name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574598 = newJObject()
  var query_574599 = newJObject()
  add(query_574599, "api-version", newJString(apiVersion))
  add(path_574598, "billingAccountName", newJString(billingAccountName))
  add(path_574598, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_574598, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574598, "billingProfileName", newJString(billingProfileName))
  result = call_574597.call(path_574598, query_574599, nil, nil, nil)

var billingSubscriptionsGet* = Call_BillingSubscriptionsGet_574588(
    name: "billingSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}",
    validator: validate_BillingSubscriptionsGet_574589, base: "",
    url: url_BillingSubscriptionsGet_574590, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsTransfer_574600 = ref object of OpenApiRestCall_573667
proc url_BillingSubscriptionsTransfer_574602(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingSubscriptionName" in path,
        "`billingSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions/"),
               (kind: VariableSegment, value: "billingSubscriptionName"),
               (kind: ConstantSegment, value: "/transfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsTransfer_574601(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Transfers the subscription from one invoice section to another within a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574603 = path.getOrDefault("billingAccountName")
  valid_574603 = validateParameter(valid_574603, JString, required = true,
                                 default = nil)
  if valid_574603 != nil:
    section.add "billingAccountName", valid_574603
  var valid_574604 = path.getOrDefault("billingSubscriptionName")
  valid_574604 = validateParameter(valid_574604, JString, required = true,
                                 default = nil)
  if valid_574604 != nil:
    section.add "billingSubscriptionName", valid_574604
  var valid_574605 = path.getOrDefault("invoiceSectionName")
  valid_574605 = validateParameter(valid_574605, JString, required = true,
                                 default = nil)
  if valid_574605 != nil:
    section.add "invoiceSectionName", valid_574605
  var valid_574606 = path.getOrDefault("billingProfileName")
  valid_574606 = validateParameter(valid_574606, JString, required = true,
                                 default = nil)
  if valid_574606 != nil:
    section.add "billingProfileName", valid_574606
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the Transfer Billing Subscription operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574608: Call_BillingSubscriptionsTransfer_574600; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Transfers the subscription from one invoice section to another within a billing account.
  ## 
  let valid = call_574608.validator(path, query, header, formData, body)
  let scheme = call_574608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574608.url(scheme.get, call_574608.host, call_574608.base,
                         call_574608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574608, url, valid)

proc call*(call_574609: Call_BillingSubscriptionsTransfer_574600;
          billingAccountName: string; billingSubscriptionName: string;
          invoiceSectionName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## billingSubscriptionsTransfer
  ## Transfers the subscription from one invoice section to another within a billing account.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the Transfer Billing Subscription operation.
  var path_574610 = newJObject()
  var body_574611 = newJObject()
  add(path_574610, "billingAccountName", newJString(billingAccountName))
  add(path_574610, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_574610, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574610, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574611 = parameters
  result = call_574609.call(path_574610, nil, nil, nil, body_574611)

var billingSubscriptionsTransfer* = Call_BillingSubscriptionsTransfer_574600(
    name: "billingSubscriptionsTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}/transfer",
    validator: validate_BillingSubscriptionsTransfer_574601, base: "",
    url: url_BillingSubscriptionsTransfer_574602, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsValidateTransfer_574612 = ref object of OpenApiRestCall_573667
proc url_BillingSubscriptionsValidateTransfer_574614(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingSubscriptionName" in path,
        "`billingSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions/"),
               (kind: VariableSegment, value: "billingSubscriptionName"),
               (kind: ConstantSegment, value: "/validateTransferEligibility")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsValidateTransfer_574613(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the transfer of billing subscriptions across invoice sections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574615 = path.getOrDefault("billingAccountName")
  valid_574615 = validateParameter(valid_574615, JString, required = true,
                                 default = nil)
  if valid_574615 != nil:
    section.add "billingAccountName", valid_574615
  var valid_574616 = path.getOrDefault("billingSubscriptionName")
  valid_574616 = validateParameter(valid_574616, JString, required = true,
                                 default = nil)
  if valid_574616 != nil:
    section.add "billingSubscriptionName", valid_574616
  var valid_574617 = path.getOrDefault("invoiceSectionName")
  valid_574617 = validateParameter(valid_574617, JString, required = true,
                                 default = nil)
  if valid_574617 != nil:
    section.add "invoiceSectionName", valid_574617
  var valid_574618 = path.getOrDefault("billingProfileName")
  valid_574618 = validateParameter(valid_574618, JString, required = true,
                                 default = nil)
  if valid_574618 != nil:
    section.add "billingProfileName", valid_574618
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

proc call*(call_574620: Call_BillingSubscriptionsValidateTransfer_574612;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates the transfer of billing subscriptions across invoice sections.
  ## 
  let valid = call_574620.validator(path, query, header, formData, body)
  let scheme = call_574620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574620.url(scheme.get, call_574620.host, call_574620.base,
                         call_574620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574620, url, valid)

proc call*(call_574621: Call_BillingSubscriptionsValidateTransfer_574612;
          billingAccountName: string; billingSubscriptionName: string;
          invoiceSectionName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## billingSubscriptionsValidateTransfer
  ## Validates the transfer of billing subscriptions across invoice sections.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  var path_574622 = newJObject()
  var body_574623 = newJObject()
  add(path_574622, "billingAccountName", newJString(billingAccountName))
  add(path_574622, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_574622, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574622, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574623 = parameters
  result = call_574621.call(path_574622, nil, nil, nil, body_574623)

var billingSubscriptionsValidateTransfer* = Call_BillingSubscriptionsValidateTransfer_574612(
    name: "billingSubscriptionsValidateTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}/validateTransferEligibility",
    validator: validate_BillingSubscriptionsValidateTransfer_574613, base: "",
    url: url_BillingSubscriptionsValidateTransfer_574614, schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByInvoiceSection_574624 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsAddByInvoiceSection_574626(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/createBillingRoleAssignment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsAddByInvoiceSection_574625(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to add a role assignment to a invoice Section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574627 = path.getOrDefault("billingAccountName")
  valid_574627 = validateParameter(valid_574627, JString, required = true,
                                 default = nil)
  if valid_574627 != nil:
    section.add "billingAccountName", valid_574627
  var valid_574628 = path.getOrDefault("invoiceSectionName")
  valid_574628 = validateParameter(valid_574628, JString, required = true,
                                 default = nil)
  if valid_574628 != nil:
    section.add "invoiceSectionName", valid_574628
  var valid_574629 = path.getOrDefault("billingProfileName")
  valid_574629 = validateParameter(valid_574629, JString, required = true,
                                 default = nil)
  if valid_574629 != nil:
    section.add "billingProfileName", valid_574629
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574630 = query.getOrDefault("api-version")
  valid_574630 = validateParameter(valid_574630, JString, required = true,
                                 default = nil)
  if valid_574630 != nil:
    section.add "api-version", valid_574630
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

proc call*(call_574632: Call_BillingRoleAssignmentsAddByInvoiceSection_574624;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a invoice Section.
  ## 
  let valid = call_574632.validator(path, query, header, formData, body)
  let scheme = call_574632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574632.url(scheme.get, call_574632.host, call_574632.base,
                         call_574632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574632, url, valid)

proc call*(call_574633: Call_BillingRoleAssignmentsAddByInvoiceSection_574624;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## billingRoleAssignmentsAddByInvoiceSection
  ## The operation to add a role assignment to a invoice Section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  var path_574634 = newJObject()
  var query_574635 = newJObject()
  var body_574636 = newJObject()
  add(query_574635, "api-version", newJString(apiVersion))
  add(path_574634, "billingAccountName", newJString(billingAccountName))
  add(path_574634, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574634, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574636 = parameters
  result = call_574633.call(path_574634, query_574635, nil, nil, body_574636)

var billingRoleAssignmentsAddByInvoiceSection* = Call_BillingRoleAssignmentsAddByInvoiceSection_574624(
    name: "billingRoleAssignmentsAddByInvoiceSection", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByInvoiceSection_574625,
    base: "", url: url_BillingRoleAssignmentsAddByInvoiceSection_574626,
    schemes: {Scheme.Https})
type
  Call_InvoiceSectionsElevateToBillingProfile_574637 = ref object of OpenApiRestCall_573667
proc url_InvoiceSectionsElevateToBillingProfile_574639(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/elevate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsElevateToBillingProfile_574638(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Elevates the caller's access to match their billing profile access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574640 = path.getOrDefault("billingAccountName")
  valid_574640 = validateParameter(valid_574640, JString, required = true,
                                 default = nil)
  if valid_574640 != nil:
    section.add "billingAccountName", valid_574640
  var valid_574641 = path.getOrDefault("invoiceSectionName")
  valid_574641 = validateParameter(valid_574641, JString, required = true,
                                 default = nil)
  if valid_574641 != nil:
    section.add "invoiceSectionName", valid_574641
  var valid_574642 = path.getOrDefault("billingProfileName")
  valid_574642 = validateParameter(valid_574642, JString, required = true,
                                 default = nil)
  if valid_574642 != nil:
    section.add "billingProfileName", valid_574642
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574643: Call_InvoiceSectionsElevateToBillingProfile_574637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Elevates the caller's access to match their billing profile access.
  ## 
  let valid = call_574643.validator(path, query, header, formData, body)
  let scheme = call_574643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574643.url(scheme.get, call_574643.host, call_574643.base,
                         call_574643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574643, url, valid)

proc call*(call_574644: Call_InvoiceSectionsElevateToBillingProfile_574637;
          billingAccountName: string; invoiceSectionName: string;
          billingProfileName: string): Recallable =
  ## invoiceSectionsElevateToBillingProfile
  ## Elevates the caller's access to match their billing profile access.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574645 = newJObject()
  add(path_574645, "billingAccountName", newJString(billingAccountName))
  add(path_574645, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574645, "billingProfileName", newJString(billingProfileName))
  result = call_574644.call(path_574645, nil, nil, nil, nil)

var invoiceSectionsElevateToBillingProfile* = Call_InvoiceSectionsElevateToBillingProfile_574637(
    name: "invoiceSectionsElevateToBillingProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/elevate",
    validator: validate_InvoiceSectionsElevateToBillingProfile_574638, base: "",
    url: url_InvoiceSectionsElevateToBillingProfile_574639,
    schemes: {Scheme.Https})
type
  Call_TransfersInitiate_574646 = ref object of OpenApiRestCall_573667
proc url_TransfersInitiate_574648(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/initiateTransfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersInitiate_574647(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574649 = path.getOrDefault("billingAccountName")
  valid_574649 = validateParameter(valid_574649, JString, required = true,
                                 default = nil)
  if valid_574649 != nil:
    section.add "billingAccountName", valid_574649
  var valid_574650 = path.getOrDefault("invoiceSectionName")
  valid_574650 = validateParameter(valid_574650, JString, required = true,
                                 default = nil)
  if valid_574650 != nil:
    section.add "invoiceSectionName", valid_574650
  var valid_574651 = path.getOrDefault("billingProfileName")
  valid_574651 = validateParameter(valid_574651, JString, required = true,
                                 default = nil)
  if valid_574651 != nil:
    section.add "billingProfileName", valid_574651
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to initiate the transfer.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574653: Call_TransfersInitiate_574646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  let valid = call_574653.validator(path, query, header, formData, body)
  let scheme = call_574653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574653.url(scheme.get, call_574653.host, call_574653.base,
                         call_574653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574653, url, valid)

proc call*(call_574654: Call_TransfersInitiate_574646; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## transfersInitiate
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to initiate the transfer.
  var path_574655 = newJObject()
  var body_574656 = newJObject()
  add(path_574655, "billingAccountName", newJString(billingAccountName))
  add(path_574655, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574655, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574656 = parameters
  result = call_574654.call(path_574655, nil, nil, nil, body_574656)

var transfersInitiate* = Call_TransfersInitiate_574646(name: "transfersInitiate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/initiateTransfer",
    validator: validate_TransfersInitiate_574647, base: "",
    url: url_TransfersInitiate_574648, schemes: {Scheme.Https})
type
  Call_ProductsListByInvoiceSection_574657 = ref object of OpenApiRestCall_573667
proc url_ProductsListByInvoiceSection_574659(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsListByInvoiceSection_574658(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists products by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574660 = path.getOrDefault("billingAccountName")
  valid_574660 = validateParameter(valid_574660, JString, required = true,
                                 default = nil)
  if valid_574660 != nil:
    section.add "billingAccountName", valid_574660
  var valid_574661 = path.getOrDefault("invoiceSectionName")
  valid_574661 = validateParameter(valid_574661, JString, required = true,
                                 default = nil)
  if valid_574661 != nil:
    section.add "invoiceSectionName", valid_574661
  var valid_574662 = path.getOrDefault("billingProfileName")
  valid_574662 = validateParameter(valid_574662, JString, required = true,
                                 default = nil)
  if valid_574662 != nil:
    section.add "billingProfileName", valid_574662
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574663 = query.getOrDefault("api-version")
  valid_574663 = validateParameter(valid_574663, JString, required = true,
                                 default = nil)
  if valid_574663 != nil:
    section.add "api-version", valid_574663
  var valid_574664 = query.getOrDefault("$filter")
  valid_574664 = validateParameter(valid_574664, JString, required = false,
                                 default = nil)
  if valid_574664 != nil:
    section.add "$filter", valid_574664
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574665: Call_ProductsListByInvoiceSection_574657; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists products by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574665.validator(path, query, header, formData, body)
  let scheme = call_574665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574665.url(scheme.get, call_574665.host, call_574665.base,
                         call_574665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574665, url, valid)

proc call*(call_574666: Call_ProductsListByInvoiceSection_574657;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string;
          Filter: string = ""): Recallable =
  ## productsListByInvoiceSection
  ## Lists products by invoice section name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   Filter: string
  ##         : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_574667 = newJObject()
  var query_574668 = newJObject()
  add(query_574668, "api-version", newJString(apiVersion))
  add(path_574667, "billingAccountName", newJString(billingAccountName))
  add(path_574667, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574667, "billingProfileName", newJString(billingProfileName))
  add(query_574668, "$filter", newJString(Filter))
  result = call_574666.call(path_574667, query_574668, nil, nil, nil)

var productsListByInvoiceSection* = Call_ProductsListByInvoiceSection_574657(
    name: "productsListByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/products",
    validator: validate_ProductsListByInvoiceSection_574658, base: "",
    url: url_ProductsListByInvoiceSection_574659, schemes: {Scheme.Https})
type
  Call_ProductsGet_574669 = ref object of OpenApiRestCall_573667
proc url_ProductsGet_574671(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsGet_574670(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_574672 = path.getOrDefault("productName")
  valid_574672 = validateParameter(valid_574672, JString, required = true,
                                 default = nil)
  if valid_574672 != nil:
    section.add "productName", valid_574672
  var valid_574673 = path.getOrDefault("billingAccountName")
  valid_574673 = validateParameter(valid_574673, JString, required = true,
                                 default = nil)
  if valid_574673 != nil:
    section.add "billingAccountName", valid_574673
  var valid_574674 = path.getOrDefault("invoiceSectionName")
  valid_574674 = validateParameter(valid_574674, JString, required = true,
                                 default = nil)
  if valid_574674 != nil:
    section.add "invoiceSectionName", valid_574674
  var valid_574675 = path.getOrDefault("billingProfileName")
  valid_574675 = validateParameter(valid_574675, JString, required = true,
                                 default = nil)
  if valid_574675 != nil:
    section.add "billingProfileName", valid_574675
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574676 = query.getOrDefault("api-version")
  valid_574676 = validateParameter(valid_574676, JString, required = true,
                                 default = nil)
  if valid_574676 != nil:
    section.add "api-version", valid_574676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574677: Call_ProductsGet_574669; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574677.validator(path, query, header, formData, body)
  let scheme = call_574677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574677.url(scheme.get, call_574677.host, call_574677.base,
                         call_574677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574677, url, valid)

proc call*(call_574678: Call_ProductsGet_574669; productName: string;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string): Recallable =
  ## productsGet
  ## Get a single product by name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574679 = newJObject()
  var query_574680 = newJObject()
  add(path_574679, "productName", newJString(productName))
  add(query_574680, "api-version", newJString(apiVersion))
  add(path_574679, "billingAccountName", newJString(billingAccountName))
  add(path_574679, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574679, "billingProfileName", newJString(billingProfileName))
  result = call_574678.call(path_574679, query_574680, nil, nil, nil)

var productsGet* = Call_ProductsGet_574669(name: "productsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/products/{productName}",
                                        validator: validate_ProductsGet_574670,
                                        base: "", url: url_ProductsGet_574671,
                                        schemes: {Scheme.Https})
type
  Call_ProductsTransfer_574681 = ref object of OpenApiRestCall_573667
proc url_ProductsTransfer_574683(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/transfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsTransfer_574682(path: JsonNode; query: JsonNode;
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
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_574684 = path.getOrDefault("productName")
  valid_574684 = validateParameter(valid_574684, JString, required = true,
                                 default = nil)
  if valid_574684 != nil:
    section.add "productName", valid_574684
  var valid_574685 = path.getOrDefault("billingAccountName")
  valid_574685 = validateParameter(valid_574685, JString, required = true,
                                 default = nil)
  if valid_574685 != nil:
    section.add "billingAccountName", valid_574685
  var valid_574686 = path.getOrDefault("invoiceSectionName")
  valid_574686 = validateParameter(valid_574686, JString, required = true,
                                 default = nil)
  if valid_574686 != nil:
    section.add "invoiceSectionName", valid_574686
  var valid_574687 = path.getOrDefault("billingProfileName")
  valid_574687 = validateParameter(valid_574687, JString, required = true,
                                 default = nil)
  if valid_574687 != nil:
    section.add "billingProfileName", valid_574687
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574688 = query.getOrDefault("api-version")
  valid_574688 = validateParameter(valid_574688, JString, required = true,
                                 default = nil)
  if valid_574688 != nil:
    section.add "api-version", valid_574688
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

proc call*(call_574690: Call_ProductsTransfer_574681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to transfer a Product to another invoice section.
  ## 
  let valid = call_574690.validator(path, query, header, formData, body)
  let scheme = call_574690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574690.url(scheme.get, call_574690.host, call_574690.base,
                         call_574690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574690, url, valid)

proc call*(call_574691: Call_ProductsTransfer_574681; productName: string;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## productsTransfer
  ## The operation to transfer a Product to another invoice section.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Product operation.
  var path_574692 = newJObject()
  var query_574693 = newJObject()
  var body_574694 = newJObject()
  add(path_574692, "productName", newJString(productName))
  add(query_574693, "api-version", newJString(apiVersion))
  add(path_574692, "billingAccountName", newJString(billingAccountName))
  add(path_574692, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574692, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574694 = parameters
  result = call_574691.call(path_574692, query_574693, nil, nil, body_574694)

var productsTransfer* = Call_ProductsTransfer_574681(name: "productsTransfer",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/products/{productName}/transfer",
    validator: validate_ProductsTransfer_574682, base: "",
    url: url_ProductsTransfer_574683, schemes: {Scheme.Https})
type
  Call_ProductsUpdateAutoRenewByInvoiceSection_574695 = ref object of OpenApiRestCall_573667
proc url_ProductsUpdateAutoRenewByInvoiceSection_574697(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/updateAutoRenew")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsUpdateAutoRenewByInvoiceSection_574696(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel auto renew for product by product id and invoice section name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_574698 = path.getOrDefault("productName")
  valid_574698 = validateParameter(valid_574698, JString, required = true,
                                 default = nil)
  if valid_574698 != nil:
    section.add "productName", valid_574698
  var valid_574699 = path.getOrDefault("billingAccountName")
  valid_574699 = validateParameter(valid_574699, JString, required = true,
                                 default = nil)
  if valid_574699 != nil:
    section.add "billingAccountName", valid_574699
  var valid_574700 = path.getOrDefault("invoiceSectionName")
  valid_574700 = validateParameter(valid_574700, JString, required = true,
                                 default = nil)
  if valid_574700 != nil:
    section.add "invoiceSectionName", valid_574700
  var valid_574701 = path.getOrDefault("billingProfileName")
  valid_574701 = validateParameter(valid_574701, JString, required = true,
                                 default = nil)
  if valid_574701 != nil:
    section.add "billingProfileName", valid_574701
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574702 = query.getOrDefault("api-version")
  valid_574702 = validateParameter(valid_574702, JString, required = true,
                                 default = nil)
  if valid_574702 != nil:
    section.add "api-version", valid_574702
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

proc call*(call_574704: Call_ProductsUpdateAutoRenewByInvoiceSection_574695;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancel auto renew for product by product id and invoice section name
  ## 
  let valid = call_574704.validator(path, query, header, formData, body)
  let scheme = call_574704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574704.url(scheme.get, call_574704.host, call_574704.base,
                         call_574704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574704, url, valid)

proc call*(call_574705: Call_ProductsUpdateAutoRenewByInvoiceSection_574695;
          productName: string; apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string; body: JsonNode): Recallable =
  ## productsUpdateAutoRenewByInvoiceSection
  ## Cancel auto renew for product by product id and invoice section name
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  var path_574706 = newJObject()
  var query_574707 = newJObject()
  var body_574708 = newJObject()
  add(path_574706, "productName", newJString(productName))
  add(query_574707, "api-version", newJString(apiVersion))
  add(path_574706, "billingAccountName", newJString(billingAccountName))
  add(path_574706, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574706, "billingProfileName", newJString(billingProfileName))
  if body != nil:
    body_574708 = body
  result = call_574705.call(path_574706, query_574707, nil, nil, body_574708)

var productsUpdateAutoRenewByInvoiceSection* = Call_ProductsUpdateAutoRenewByInvoiceSection_574695(
    name: "productsUpdateAutoRenewByInvoiceSection", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/products/{productName}/updateAutoRenew",
    validator: validate_ProductsUpdateAutoRenewByInvoiceSection_574696, base: "",
    url: url_ProductsUpdateAutoRenewByInvoiceSection_574697,
    schemes: {Scheme.Https})
type
  Call_ProductsValidateTransfer_574709 = ref object of OpenApiRestCall_573667
proc url_ProductsValidateTransfer_574711(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/validateTransferEligibility")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsValidateTransfer_574710(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the transfer of products across invoice sections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_574712 = path.getOrDefault("productName")
  valid_574712 = validateParameter(valid_574712, JString, required = true,
                                 default = nil)
  if valid_574712 != nil:
    section.add "productName", valid_574712
  var valid_574713 = path.getOrDefault("billingAccountName")
  valid_574713 = validateParameter(valid_574713, JString, required = true,
                                 default = nil)
  if valid_574713 != nil:
    section.add "billingAccountName", valid_574713
  var valid_574714 = path.getOrDefault("invoiceSectionName")
  valid_574714 = validateParameter(valid_574714, JString, required = true,
                                 default = nil)
  if valid_574714 != nil:
    section.add "invoiceSectionName", valid_574714
  var valid_574715 = path.getOrDefault("billingProfileName")
  valid_574715 = validateParameter(valid_574715, JString, required = true,
                                 default = nil)
  if valid_574715 != nil:
    section.add "billingProfileName", valid_574715
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

proc call*(call_574717: Call_ProductsValidateTransfer_574709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the transfer of products across invoice sections.
  ## 
  let valid = call_574717.validator(path, query, header, formData, body)
  let scheme = call_574717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574717.url(scheme.get, call_574717.host, call_574717.base,
                         call_574717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574717, url, valid)

proc call*(call_574718: Call_ProductsValidateTransfer_574709; productName: string;
          billingAccountName: string; invoiceSectionName: string;
          billingProfileName: string; parameters: JsonNode): Recallable =
  ## productsValidateTransfer
  ## Validates the transfer of products across invoice sections.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Products operation.
  var path_574719 = newJObject()
  var body_574720 = newJObject()
  add(path_574719, "productName", newJString(productName))
  add(path_574719, "billingAccountName", newJString(billingAccountName))
  add(path_574719, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574719, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574720 = parameters
  result = call_574718.call(path_574719, nil, nil, nil, body_574720)

var productsValidateTransfer* = Call_ProductsValidateTransfer_574709(
    name: "productsValidateTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/products/{productName}/validateTransferEligibility",
    validator: validate_ProductsValidateTransfer_574710, base: "",
    url: url_ProductsValidateTransfer_574711, schemes: {Scheme.Https})
type
  Call_TransactionsListByInvoiceSection_574721 = ref object of OpenApiRestCall_573667
proc url_TransactionsListByInvoiceSection_574723(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsListByInvoiceSection_574722(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574724 = path.getOrDefault("billingAccountName")
  valid_574724 = validateParameter(valid_574724, JString, required = true,
                                 default = nil)
  if valid_574724 != nil:
    section.add "billingAccountName", valid_574724
  var valid_574725 = path.getOrDefault("invoiceSectionName")
  valid_574725 = validateParameter(valid_574725, JString, required = true,
                                 default = nil)
  if valid_574725 != nil:
    section.add "invoiceSectionName", valid_574725
  var valid_574726 = path.getOrDefault("billingProfileName")
  valid_574726 = validateParameter(valid_574726, JString, required = true,
                                 default = nil)
  if valid_574726 != nil:
    section.add "billingProfileName", valid_574726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574727 = query.getOrDefault("api-version")
  valid_574727 = validateParameter(valid_574727, JString, required = true,
                                 default = nil)
  if valid_574727 != nil:
    section.add "api-version", valid_574727
  var valid_574728 = query.getOrDefault("endDate")
  valid_574728 = validateParameter(valid_574728, JString, required = true,
                                 default = nil)
  if valid_574728 != nil:
    section.add "endDate", valid_574728
  var valid_574729 = query.getOrDefault("startDate")
  valid_574729 = validateParameter(valid_574729, JString, required = true,
                                 default = nil)
  if valid_574729 != nil:
    section.add "startDate", valid_574729
  var valid_574730 = query.getOrDefault("$filter")
  valid_574730 = validateParameter(valid_574730, JString, required = false,
                                 default = nil)
  if valid_574730 != nil:
    section.add "$filter", valid_574730
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574731: Call_TransactionsListByInvoiceSection_574721;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574731.validator(path, query, header, formData, body)
  let scheme = call_574731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574731.url(scheme.get, call_574731.host, call_574731.base,
                         call_574731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574731, url, valid)

proc call*(call_574732: Call_TransactionsListByInvoiceSection_574721;
          apiVersion: string; endDate: string; billingAccountName: string;
          startDate: string; invoiceSectionName: string; billingProfileName: string;
          Filter: string = ""): Recallable =
  ## transactionsListByInvoiceSection
  ## Lists the transactions by invoice section name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_574733 = newJObject()
  var query_574734 = newJObject()
  add(query_574734, "api-version", newJString(apiVersion))
  add(query_574734, "endDate", newJString(endDate))
  add(path_574733, "billingAccountName", newJString(billingAccountName))
  add(query_574734, "startDate", newJString(startDate))
  add(path_574733, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574733, "billingProfileName", newJString(billingProfileName))
  add(query_574734, "$filter", newJString(Filter))
  result = call_574732.call(path_574733, query_574734, nil, nil, nil)

var transactionsListByInvoiceSection* = Call_TransactionsListByInvoiceSection_574721(
    name: "transactionsListByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/transactions",
    validator: validate_TransactionsListByInvoiceSection_574722, base: "",
    url: url_TransactionsListByInvoiceSection_574723, schemes: {Scheme.Https})
type
  Call_TransfersList_574735 = ref object of OpenApiRestCall_573667
proc url_TransfersList_574737(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transfers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersList_574736(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574738 = path.getOrDefault("billingAccountName")
  valid_574738 = validateParameter(valid_574738, JString, required = true,
                                 default = nil)
  if valid_574738 != nil:
    section.add "billingAccountName", valid_574738
  var valid_574739 = path.getOrDefault("invoiceSectionName")
  valid_574739 = validateParameter(valid_574739, JString, required = true,
                                 default = nil)
  if valid_574739 != nil:
    section.add "invoiceSectionName", valid_574739
  var valid_574740 = path.getOrDefault("billingProfileName")
  valid_574740 = validateParameter(valid_574740, JString, required = true,
                                 default = nil)
  if valid_574740 != nil:
    section.add "billingProfileName", valid_574740
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574741: Call_TransfersList_574735; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  let valid = call_574741.validator(path, query, header, formData, body)
  let scheme = call_574741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574741.url(scheme.get, call_574741.host, call_574741.base,
                         call_574741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574741, url, valid)

proc call*(call_574742: Call_TransfersList_574735; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string): Recallable =
  ## transfersList
  ## Lists all transfer's details initiated from given invoice section.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574743 = newJObject()
  add(path_574743, "billingAccountName", newJString(billingAccountName))
  add(path_574743, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574743, "billingProfileName", newJString(billingProfileName))
  result = call_574742.call(path_574743, nil, nil, nil, nil)

var transfersList* = Call_TransfersList_574735(name: "transfersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/transfers",
    validator: validate_TransfersList_574736, base: "", url: url_TransfersList_574737,
    schemes: {Scheme.Https})
type
  Call_TransfersGet_574744 = ref object of OpenApiRestCall_573667
proc url_TransfersGet_574746(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transfers/"),
               (kind: VariableSegment, value: "transferName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersGet_574745(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the transfer details for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574747 = path.getOrDefault("billingAccountName")
  valid_574747 = validateParameter(valid_574747, JString, required = true,
                                 default = nil)
  if valid_574747 != nil:
    section.add "billingAccountName", valid_574747
  var valid_574748 = path.getOrDefault("invoiceSectionName")
  valid_574748 = validateParameter(valid_574748, JString, required = true,
                                 default = nil)
  if valid_574748 != nil:
    section.add "invoiceSectionName", valid_574748
  var valid_574749 = path.getOrDefault("billingProfileName")
  valid_574749 = validateParameter(valid_574749, JString, required = true,
                                 default = nil)
  if valid_574749 != nil:
    section.add "billingProfileName", valid_574749
  var valid_574750 = path.getOrDefault("transferName")
  valid_574750 = validateParameter(valid_574750, JString, required = true,
                                 default = nil)
  if valid_574750 != nil:
    section.add "transferName", valid_574750
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574751: Call_TransfersGet_574744; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the transfer details for given transfer Id.
  ## 
  let valid = call_574751.validator(path, query, header, formData, body)
  let scheme = call_574751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574751.url(scheme.get, call_574751.host, call_574751.base,
                         call_574751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574751, url, valid)

proc call*(call_574752: Call_TransfersGet_574744; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string;
          transferName: string): Recallable =
  ## transfersGet
  ## Gets the transfer details for given transfer Id.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_574753 = newJObject()
  add(path_574753, "billingAccountName", newJString(billingAccountName))
  add(path_574753, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574753, "billingProfileName", newJString(billingProfileName))
  add(path_574753, "transferName", newJString(transferName))
  result = call_574752.call(path_574753, nil, nil, nil, nil)

var transfersGet* = Call_TransfersGet_574744(name: "transfersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/transfers/{transferName}",
    validator: validate_TransfersGet_574745, base: "", url: url_TransfersGet_574746,
    schemes: {Scheme.Https})
type
  Call_TransfersCancel_574754 = ref object of OpenApiRestCall_573667
proc url_TransfersCancel_574756(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transfers/"),
               (kind: VariableSegment, value: "transferName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersCancel_574755(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Cancels the transfer for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574757 = path.getOrDefault("billingAccountName")
  valid_574757 = validateParameter(valid_574757, JString, required = true,
                                 default = nil)
  if valid_574757 != nil:
    section.add "billingAccountName", valid_574757
  var valid_574758 = path.getOrDefault("invoiceSectionName")
  valid_574758 = validateParameter(valid_574758, JString, required = true,
                                 default = nil)
  if valid_574758 != nil:
    section.add "invoiceSectionName", valid_574758
  var valid_574759 = path.getOrDefault("billingProfileName")
  valid_574759 = validateParameter(valid_574759, JString, required = true,
                                 default = nil)
  if valid_574759 != nil:
    section.add "billingProfileName", valid_574759
  var valid_574760 = path.getOrDefault("transferName")
  valid_574760 = validateParameter(valid_574760, JString, required = true,
                                 default = nil)
  if valid_574760 != nil:
    section.add "transferName", valid_574760
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574761: Call_TransfersCancel_574754; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the transfer for given transfer Id.
  ## 
  let valid = call_574761.validator(path, query, header, formData, body)
  let scheme = call_574761.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574761.url(scheme.get, call_574761.host, call_574761.base,
                         call_574761.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574761, url, valid)

proc call*(call_574762: Call_TransfersCancel_574754; billingAccountName: string;
          invoiceSectionName: string; billingProfileName: string;
          transferName: string): Recallable =
  ## transfersCancel
  ## Cancels the transfer for given transfer Id.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_574763 = newJObject()
  add(path_574763, "billingAccountName", newJString(billingAccountName))
  add(path_574763, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_574763, "billingProfileName", newJString(billingProfileName))
  add(path_574763, "transferName", newJString(transferName))
  result = call_574762.call(path_574763, nil, nil, nil, nil)

var transfersCancel* = Call_TransfersCancel_574754(name: "transfersCancel",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/transfers/{transferName}",
    validator: validate_TransfersCancel_574755, base: "", url: url_TransfersCancel_574756,
    schemes: {Scheme.Https})
type
  Call_InvoicesListByBillingProfile_574764 = ref object of OpenApiRestCall_573667
proc url_InvoicesListByBillingProfile_574766(protocol: Scheme; host: string;
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

proc validate_InvoicesListByBillingProfile_574765(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of invoices for a billing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574767 = path.getOrDefault("billingAccountName")
  valid_574767 = validateParameter(valid_574767, JString, required = true,
                                 default = nil)
  if valid_574767 != nil:
    section.add "billingAccountName", valid_574767
  var valid_574768 = path.getOrDefault("billingProfileName")
  valid_574768 = validateParameter(valid_574768, JString, required = true,
                                 default = nil)
  if valid_574768 != nil:
    section.add "billingProfileName", valid_574768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   periodEndDate: JString (required)
  ##                : Invoice period end date.
  ##   periodStartDate: JString (required)
  ##                  : Invoice period start date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574769 = query.getOrDefault("api-version")
  valid_574769 = validateParameter(valid_574769, JString, required = true,
                                 default = nil)
  if valid_574769 != nil:
    section.add "api-version", valid_574769
  var valid_574770 = query.getOrDefault("periodEndDate")
  valid_574770 = validateParameter(valid_574770, JString, required = true,
                                 default = nil)
  if valid_574770 != nil:
    section.add "periodEndDate", valid_574770
  var valid_574771 = query.getOrDefault("periodStartDate")
  valid_574771 = validateParameter(valid_574771, JString, required = true,
                                 default = nil)
  if valid_574771 != nil:
    section.add "periodStartDate", valid_574771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574772: Call_InvoicesListByBillingProfile_574764; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of invoices for a billing profile.
  ## 
  let valid = call_574772.validator(path, query, header, formData, body)
  let scheme = call_574772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574772.url(scheme.get, call_574772.host, call_574772.base,
                         call_574772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574772, url, valid)

proc call*(call_574773: Call_InvoicesListByBillingProfile_574764;
          apiVersion: string; billingAccountName: string; periodEndDate: string;
          periodStartDate: string; billingProfileName: string): Recallable =
  ## invoicesListByBillingProfile
  ## List of invoices for a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   periodEndDate: string (required)
  ##                : Invoice period end date.
  ##   periodStartDate: string (required)
  ##                  : Invoice period start date.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574774 = newJObject()
  var query_574775 = newJObject()
  add(query_574775, "api-version", newJString(apiVersion))
  add(path_574774, "billingAccountName", newJString(billingAccountName))
  add(query_574775, "periodEndDate", newJString(periodEndDate))
  add(query_574775, "periodStartDate", newJString(periodStartDate))
  add(path_574774, "billingProfileName", newJString(billingProfileName))
  result = call_574773.call(path_574774, query_574775, nil, nil, nil)

var invoicesListByBillingProfile* = Call_InvoicesListByBillingProfile_574764(
    name: "invoicesListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices",
    validator: validate_InvoicesListByBillingProfile_574765, base: "",
    url: url_InvoicesListByBillingProfile_574766, schemes: {Scheme.Https})
type
  Call_InvoicesGet_574776 = ref object of OpenApiRestCall_573667
proc url_InvoicesGet_574778(protocol: Scheme; host: string; base: string;
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

proc validate_InvoicesGet_574777(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the invoice by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceName: JString (required)
  ##              : Invoice Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574779 = path.getOrDefault("billingAccountName")
  valid_574779 = validateParameter(valid_574779, JString, required = true,
                                 default = nil)
  if valid_574779 != nil:
    section.add "billingAccountName", valid_574779
  var valid_574780 = path.getOrDefault("invoiceName")
  valid_574780 = validateParameter(valid_574780, JString, required = true,
                                 default = nil)
  if valid_574780 != nil:
    section.add "invoiceName", valid_574780
  var valid_574781 = path.getOrDefault("billingProfileName")
  valid_574781 = validateParameter(valid_574781, JString, required = true,
                                 default = nil)
  if valid_574781 != nil:
    section.add "billingProfileName", valid_574781
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574782 = query.getOrDefault("api-version")
  valid_574782 = validateParameter(valid_574782, JString, required = true,
                                 default = nil)
  if valid_574782 != nil:
    section.add "api-version", valid_574782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574783: Call_InvoicesGet_574776; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the invoice by name.
  ## 
  let valid = call_574783.validator(path, query, header, formData, body)
  let scheme = call_574783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574783.url(scheme.get, call_574783.host, call_574783.base,
                         call_574783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574783, url, valid)

proc call*(call_574784: Call_InvoicesGet_574776; apiVersion: string;
          billingAccountName: string; invoiceName: string;
          billingProfileName: string): Recallable =
  ## invoicesGet
  ## Get the invoice by name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceName: string (required)
  ##              : Invoice Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574785 = newJObject()
  var query_574786 = newJObject()
  add(query_574786, "api-version", newJString(apiVersion))
  add(path_574785, "billingAccountName", newJString(billingAccountName))
  add(path_574785, "invoiceName", newJString(invoiceName))
  add(path_574785, "billingProfileName", newJString(billingProfileName))
  result = call_574784.call(path_574785, query_574786, nil, nil, nil)

var invoicesGet* = Call_InvoicesGet_574776(name: "invoicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices/{invoiceName}",
                                        validator: validate_InvoicesGet_574777,
                                        base: "", url: url_InvoicesGet_574778,
                                        schemes: {Scheme.Https})
type
  Call_PriceSheetDownload_574787 = ref object of OpenApiRestCall_573667
proc url_PriceSheetDownload_574789(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "invoiceName"),
               (kind: ConstantSegment, value: "/pricesheet/default/download")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PriceSheetDownload_574788(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Download price sheet for an invoice.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   invoiceName: JString (required)
  ##              : Invoice Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574790 = path.getOrDefault("billingAccountName")
  valid_574790 = validateParameter(valid_574790, JString, required = true,
                                 default = nil)
  if valid_574790 != nil:
    section.add "billingAccountName", valid_574790
  var valid_574791 = path.getOrDefault("invoiceName")
  valid_574791 = validateParameter(valid_574791, JString, required = true,
                                 default = nil)
  if valid_574791 != nil:
    section.add "invoiceName", valid_574791
  var valid_574792 = path.getOrDefault("billingProfileName")
  valid_574792 = validateParameter(valid_574792, JString, required = true,
                                 default = nil)
  if valid_574792 != nil:
    section.add "billingProfileName", valid_574792
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574793 = query.getOrDefault("api-version")
  valid_574793 = validateParameter(valid_574793, JString, required = true,
                                 default = nil)
  if valid_574793 != nil:
    section.add "api-version", valid_574793
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574794: Call_PriceSheetDownload_574787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Download price sheet for an invoice.
  ## 
  let valid = call_574794.validator(path, query, header, formData, body)
  let scheme = call_574794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574794.url(scheme.get, call_574794.host, call_574794.base,
                         call_574794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574794, url, valid)

proc call*(call_574795: Call_PriceSheetDownload_574787; apiVersion: string;
          billingAccountName: string; invoiceName: string;
          billingProfileName: string): Recallable =
  ## priceSheetDownload
  ## Download price sheet for an invoice.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   invoiceName: string (required)
  ##              : Invoice Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574796 = newJObject()
  var query_574797 = newJObject()
  add(query_574797, "api-version", newJString(apiVersion))
  add(path_574796, "billingAccountName", newJString(billingAccountName))
  add(path_574796, "invoiceName", newJString(invoiceName))
  add(path_574796, "billingProfileName", newJString(billingProfileName))
  result = call_574795.call(path_574796, query_574797, nil, nil, nil)

var priceSheetDownload* = Call_PriceSheetDownload_574787(
    name: "priceSheetDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices/{invoiceName}/pricesheet/default/download",
    validator: validate_PriceSheetDownload_574788, base: "",
    url: url_PriceSheetDownload_574789, schemes: {Scheme.Https})
type
  Call_PaymentMethodsListByBillingProfile_574798 = ref object of OpenApiRestCall_573667
proc url_PaymentMethodsListByBillingProfile_574800(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/paymentMethods")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PaymentMethodsListByBillingProfile_574799(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Payment Methods by billing profile Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574801 = path.getOrDefault("billingAccountName")
  valid_574801 = validateParameter(valid_574801, JString, required = true,
                                 default = nil)
  if valid_574801 != nil:
    section.add "billingAccountName", valid_574801
  var valid_574802 = path.getOrDefault("billingProfileName")
  valid_574802 = validateParameter(valid_574802, JString, required = true,
                                 default = nil)
  if valid_574802 != nil:
    section.add "billingProfileName", valid_574802
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574803 = query.getOrDefault("api-version")
  valid_574803 = validateParameter(valid_574803, JString, required = true,
                                 default = nil)
  if valid_574803 != nil:
    section.add "api-version", valid_574803
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574804: Call_PaymentMethodsListByBillingProfile_574798;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Payment Methods by billing profile Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574804.validator(path, query, header, formData, body)
  let scheme = call_574804.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574804.url(scheme.get, call_574804.host, call_574804.base,
                         call_574804.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574804, url, valid)

proc call*(call_574805: Call_PaymentMethodsListByBillingProfile_574798;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## paymentMethodsListByBillingProfile
  ## Lists the Payment Methods by billing profile Id.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574806 = newJObject()
  var query_574807 = newJObject()
  add(query_574807, "api-version", newJString(apiVersion))
  add(path_574806, "billingAccountName", newJString(billingAccountName))
  add(path_574806, "billingProfileName", newJString(billingProfileName))
  result = call_574805.call(path_574806, query_574807, nil, nil, nil)

var paymentMethodsListByBillingProfile* = Call_PaymentMethodsListByBillingProfile_574798(
    name: "paymentMethodsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/paymentMethods",
    validator: validate_PaymentMethodsListByBillingProfile_574799, base: "",
    url: url_PaymentMethodsListByBillingProfile_574800, schemes: {Scheme.Https})
type
  Call_PoliciesUpdate_574818 = ref object of OpenApiRestCall_573667
proc url_PoliciesUpdate_574820(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesUpdate_574819(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The operation to update a policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574821 = path.getOrDefault("billingAccountName")
  valid_574821 = validateParameter(valid_574821, JString, required = true,
                                 default = nil)
  if valid_574821 != nil:
    section.add "billingAccountName", valid_574821
  var valid_574822 = path.getOrDefault("billingProfileName")
  valid_574822 = validateParameter(valid_574822, JString, required = true,
                                 default = nil)
  if valid_574822 != nil:
    section.add "billingProfileName", valid_574822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574823 = query.getOrDefault("api-version")
  valid_574823 = validateParameter(valid_574823, JString, required = true,
                                 default = nil)
  if valid_574823 != nil:
    section.add "api-version", valid_574823
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

proc call*(call_574825: Call_PoliciesUpdate_574818; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a policy.
  ## 
  let valid = call_574825.validator(path, query, header, formData, body)
  let scheme = call_574825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574825.url(scheme.get, call_574825.host, call_574825.base,
                         call_574825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574825, url, valid)

proc call*(call_574826: Call_PoliciesUpdate_574818; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## policiesUpdate
  ## The operation to update a policy.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update policy operation.
  var path_574827 = newJObject()
  var query_574828 = newJObject()
  var body_574829 = newJObject()
  add(query_574828, "api-version", newJString(apiVersion))
  add(path_574827, "billingAccountName", newJString(billingAccountName))
  add(path_574827, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_574829 = parameters
  result = call_574826.call(path_574827, query_574828, nil, nil, body_574829)

var policiesUpdate* = Call_PoliciesUpdate_574818(name: "policiesUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/policies/default",
    validator: validate_PoliciesUpdate_574819, base: "", url: url_PoliciesUpdate_574820,
    schemes: {Scheme.Https})
type
  Call_PoliciesGetByBillingProfile_574808 = ref object of OpenApiRestCall_573667
proc url_PoliciesGetByBillingProfile_574810(protocol: Scheme; host: string;
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

proc validate_PoliciesGetByBillingProfile_574809(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The policy for a given billing account name and billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574811 = path.getOrDefault("billingAccountName")
  valid_574811 = validateParameter(valid_574811, JString, required = true,
                                 default = nil)
  if valid_574811 != nil:
    section.add "billingAccountName", valid_574811
  var valid_574812 = path.getOrDefault("billingProfileName")
  valid_574812 = validateParameter(valid_574812, JString, required = true,
                                 default = nil)
  if valid_574812 != nil:
    section.add "billingProfileName", valid_574812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574813 = query.getOrDefault("api-version")
  valid_574813 = validateParameter(valid_574813, JString, required = true,
                                 default = nil)
  if valid_574813 != nil:
    section.add "api-version", valid_574813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574814: Call_PoliciesGetByBillingProfile_574808; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The policy for a given billing account name and billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574814.validator(path, query, header, formData, body)
  let scheme = call_574814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574814.url(scheme.get, call_574814.host, call_574814.base,
                         call_574814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574814, url, valid)

proc call*(call_574815: Call_PoliciesGetByBillingProfile_574808;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## policiesGetByBillingProfile
  ## The policy for a given billing account name and billing profile name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574816 = newJObject()
  var query_574817 = newJObject()
  add(query_574817, "api-version", newJString(apiVersion))
  add(path_574816, "billingAccountName", newJString(billingAccountName))
  add(path_574816, "billingProfileName", newJString(billingProfileName))
  result = call_574815.call(path_574816, query_574817, nil, nil, nil)

var policiesGetByBillingProfile* = Call_PoliciesGetByBillingProfile_574808(
    name: "policiesGetByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/policies/default",
    validator: validate_PoliciesGetByBillingProfile_574809, base: "",
    url: url_PoliciesGetByBillingProfile_574810, schemes: {Scheme.Https})
type
  Call_PriceSheetDownloadByBillingProfile_574830 = ref object of OpenApiRestCall_573667
proc url_PriceSheetDownloadByBillingProfile_574832(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/pricesheet/default/download")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PriceSheetDownloadByBillingProfile_574831(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Download price sheet for a billing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574833 = path.getOrDefault("billingAccountName")
  valid_574833 = validateParameter(valid_574833, JString, required = true,
                                 default = nil)
  if valid_574833 != nil:
    section.add "billingAccountName", valid_574833
  var valid_574834 = path.getOrDefault("billingProfileName")
  valid_574834 = validateParameter(valid_574834, JString, required = true,
                                 default = nil)
  if valid_574834 != nil:
    section.add "billingProfileName", valid_574834
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574835 = query.getOrDefault("api-version")
  valid_574835 = validateParameter(valid_574835, JString, required = true,
                                 default = nil)
  if valid_574835 != nil:
    section.add "api-version", valid_574835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574836: Call_PriceSheetDownloadByBillingProfile_574830;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Download price sheet for a billing profile.
  ## 
  let valid = call_574836.validator(path, query, header, formData, body)
  let scheme = call_574836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574836.url(scheme.get, call_574836.host, call_574836.base,
                         call_574836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574836, url, valid)

proc call*(call_574837: Call_PriceSheetDownloadByBillingProfile_574830;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## priceSheetDownloadByBillingProfile
  ## Download price sheet for a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574838 = newJObject()
  var query_574839 = newJObject()
  add(query_574839, "api-version", newJString(apiVersion))
  add(path_574838, "billingAccountName", newJString(billingAccountName))
  add(path_574838, "billingProfileName", newJString(billingProfileName))
  result = call_574837.call(path_574838, query_574839, nil, nil, nil)

var priceSheetDownloadByBillingProfile* = Call_PriceSheetDownloadByBillingProfile_574830(
    name: "priceSheetDownloadByBillingProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/pricesheet/default/download",
    validator: validate_PriceSheetDownloadByBillingProfile_574831, base: "",
    url: url_PriceSheetDownloadByBillingProfile_574832, schemes: {Scheme.Https})
type
  Call_TransactionsListByBillingProfile_574840 = ref object of OpenApiRestCall_573667
proc url_TransactionsListByBillingProfile_574842(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsListByBillingProfile_574841(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by billing profile name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574843 = path.getOrDefault("billingAccountName")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "billingAccountName", valid_574843
  var valid_574844 = path.getOrDefault("billingProfileName")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "billingProfileName", valid_574844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574845 = query.getOrDefault("api-version")
  valid_574845 = validateParameter(valid_574845, JString, required = true,
                                 default = nil)
  if valid_574845 != nil:
    section.add "api-version", valid_574845
  var valid_574846 = query.getOrDefault("endDate")
  valid_574846 = validateParameter(valid_574846, JString, required = true,
                                 default = nil)
  if valid_574846 != nil:
    section.add "endDate", valid_574846
  var valid_574847 = query.getOrDefault("startDate")
  valid_574847 = validateParameter(valid_574847, JString, required = true,
                                 default = nil)
  if valid_574847 != nil:
    section.add "startDate", valid_574847
  var valid_574848 = query.getOrDefault("$filter")
  valid_574848 = validateParameter(valid_574848, JString, required = false,
                                 default = nil)
  if valid_574848 != nil:
    section.add "$filter", valid_574848
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574849: Call_TransactionsListByBillingProfile_574840;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by billing profile name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574849.validator(path, query, header, formData, body)
  let scheme = call_574849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574849.url(scheme.get, call_574849.host, call_574849.base,
                         call_574849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574849, url, valid)

proc call*(call_574850: Call_TransactionsListByBillingProfile_574840;
          apiVersion: string; endDate: string; billingAccountName: string;
          startDate: string; billingProfileName: string; Filter: string = ""): Recallable =
  ## transactionsListByBillingProfile
  ## Lists the transactions by billing profile name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_574851 = newJObject()
  var query_574852 = newJObject()
  add(query_574852, "api-version", newJString(apiVersion))
  add(query_574852, "endDate", newJString(endDate))
  add(path_574851, "billingAccountName", newJString(billingAccountName))
  add(query_574852, "startDate", newJString(startDate))
  add(path_574851, "billingProfileName", newJString(billingProfileName))
  add(query_574852, "$filter", newJString(Filter))
  result = call_574850.call(path_574851, query_574852, nil, nil, nil)

var transactionsListByBillingProfile* = Call_TransactionsListByBillingProfile_574840(
    name: "transactionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/transactions",
    validator: validate_TransactionsListByBillingProfile_574841, base: "",
    url: url_TransactionsListByBillingProfile_574842, schemes: {Scheme.Https})
type
  Call_TransactionsGet_574853 = ref object of OpenApiRestCall_573667
proc url_TransactionsGet_574855(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "transactionName" in path, "`transactionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/transactions/"),
               (kind: VariableSegment, value: "transactionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsGet_574854(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the transaction.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   transactionName: JString (required)
  ##                  : Transaction name.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574856 = path.getOrDefault("billingAccountName")
  valid_574856 = validateParameter(valid_574856, JString, required = true,
                                 default = nil)
  if valid_574856 != nil:
    section.add "billingAccountName", valid_574856
  var valid_574857 = path.getOrDefault("transactionName")
  valid_574857 = validateParameter(valid_574857, JString, required = true,
                                 default = nil)
  if valid_574857 != nil:
    section.add "transactionName", valid_574857
  var valid_574858 = path.getOrDefault("billingProfileName")
  valid_574858 = validateParameter(valid_574858, JString, required = true,
                                 default = nil)
  if valid_574858 != nil:
    section.add "billingProfileName", valid_574858
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574859 = query.getOrDefault("api-version")
  valid_574859 = validateParameter(valid_574859, JString, required = true,
                                 default = nil)
  if valid_574859 != nil:
    section.add "api-version", valid_574859
  var valid_574860 = query.getOrDefault("endDate")
  valid_574860 = validateParameter(valid_574860, JString, required = true,
                                 default = nil)
  if valid_574860 != nil:
    section.add "endDate", valid_574860
  var valid_574861 = query.getOrDefault("startDate")
  valid_574861 = validateParameter(valid_574861, JString, required = true,
                                 default = nil)
  if valid_574861 != nil:
    section.add "startDate", valid_574861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574862: Call_TransactionsGet_574853; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the transaction.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574862.validator(path, query, header, formData, body)
  let scheme = call_574862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574862.url(scheme.get, call_574862.host, call_574862.base,
                         call_574862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574862, url, valid)

proc call*(call_574863: Call_TransactionsGet_574853; apiVersion: string;
          endDate: string; billingAccountName: string; startDate: string;
          transactionName: string; billingProfileName: string): Recallable =
  ## transactionsGet
  ## Get the transaction.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   transactionName: string (required)
  ##                  : Transaction name.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_574864 = newJObject()
  var query_574865 = newJObject()
  add(query_574865, "api-version", newJString(apiVersion))
  add(query_574865, "endDate", newJString(endDate))
  add(path_574864, "billingAccountName", newJString(billingAccountName))
  add(query_574865, "startDate", newJString(startDate))
  add(path_574864, "transactionName", newJString(transactionName))
  add(path_574864, "billingProfileName", newJString(billingProfileName))
  result = call_574863.call(path_574864, query_574865, nil, nil, nil)

var transactionsGet* = Call_TransactionsGet_574853(name: "transactionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/transactions/{transactionName}",
    validator: validate_TransactionsGet_574854, base: "", url: url_TransactionsGet_574855,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByBillingAccount_574866 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsListByBillingAccount_574868(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/billingRoleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsListByBillingAccount_574867(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignments on the Billing Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574869 = path.getOrDefault("billingAccountName")
  valid_574869 = validateParameter(valid_574869, JString, required = true,
                                 default = nil)
  if valid_574869 != nil:
    section.add "billingAccountName", valid_574869
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574870 = query.getOrDefault("api-version")
  valid_574870 = validateParameter(valid_574870, JString, required = true,
                                 default = nil)
  if valid_574870 != nil:
    section.add "api-version", valid_574870
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574871: Call_BillingRoleAssignmentsListByBillingAccount_574866;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the Billing Account
  ## 
  let valid = call_574871.validator(path, query, header, formData, body)
  let scheme = call_574871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574871.url(scheme.get, call_574871.host, call_574871.base,
                         call_574871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574871, url, valid)

proc call*(call_574872: Call_BillingRoleAssignmentsListByBillingAccount_574866;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingRoleAssignmentsListByBillingAccount
  ## Get the role assignments on the Billing Account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_574873 = newJObject()
  var query_574874 = newJObject()
  add(query_574874, "api-version", newJString(apiVersion))
  add(path_574873, "billingAccountName", newJString(billingAccountName))
  result = call_574872.call(path_574873, query_574874, nil, nil, nil)

var billingRoleAssignmentsListByBillingAccount* = Call_BillingRoleAssignmentsListByBillingAccount_574866(
    name: "billingRoleAssignmentsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByBillingAccount_574867,
    base: "", url: url_BillingRoleAssignmentsListByBillingAccount_574868,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByBillingAccount_574875 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsGetByBillingAccount_574877(protocol: Scheme;
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
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsGetByBillingAccount_574876(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignment for the caller
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_574878 = path.getOrDefault("billingRoleAssignmentName")
  valid_574878 = validateParameter(valid_574878, JString, required = true,
                                 default = nil)
  if valid_574878 != nil:
    section.add "billingRoleAssignmentName", valid_574878
  var valid_574879 = path.getOrDefault("billingAccountName")
  valid_574879 = validateParameter(valid_574879, JString, required = true,
                                 default = nil)
  if valid_574879 != nil:
    section.add "billingAccountName", valid_574879
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574880 = query.getOrDefault("api-version")
  valid_574880 = validateParameter(valid_574880, JString, required = true,
                                 default = nil)
  if valid_574880 != nil:
    section.add "api-version", valid_574880
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574881: Call_BillingRoleAssignmentsGetByBillingAccount_574875;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller
  ## 
  let valid = call_574881.validator(path, query, header, formData, body)
  let scheme = call_574881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574881.url(scheme.get, call_574881.host, call_574881.base,
                         call_574881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574881, url, valid)

proc call*(call_574882: Call_BillingRoleAssignmentsGetByBillingAccount_574875;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string): Recallable =
  ## billingRoleAssignmentsGetByBillingAccount
  ## Get the role assignment for the caller
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_574883 = newJObject()
  var query_574884 = newJObject()
  add(query_574884, "api-version", newJString(apiVersion))
  add(path_574883, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_574883, "billingAccountName", newJString(billingAccountName))
  result = call_574882.call(path_574883, query_574884, nil, nil, nil)

var billingRoleAssignmentsGetByBillingAccount* = Call_BillingRoleAssignmentsGetByBillingAccount_574875(
    name: "billingRoleAssignmentsGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByBillingAccount_574876,
    base: "", url: url_BillingRoleAssignmentsGetByBillingAccount_574877,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByBillingAccount_574885 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsDeleteByBillingAccount_574887(protocol: Scheme;
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
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsDeleteByBillingAccount_574886(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the role assignment on this billing account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_574888 = path.getOrDefault("billingRoleAssignmentName")
  valid_574888 = validateParameter(valid_574888, JString, required = true,
                                 default = nil)
  if valid_574888 != nil:
    section.add "billingRoleAssignmentName", valid_574888
  var valid_574889 = path.getOrDefault("billingAccountName")
  valid_574889 = validateParameter(valid_574889, JString, required = true,
                                 default = nil)
  if valid_574889 != nil:
    section.add "billingAccountName", valid_574889
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574890 = query.getOrDefault("api-version")
  valid_574890 = validateParameter(valid_574890, JString, required = true,
                                 default = nil)
  if valid_574890 != nil:
    section.add "api-version", valid_574890
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574891: Call_BillingRoleAssignmentsDeleteByBillingAccount_574885;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on this billing account
  ## 
  let valid = call_574891.validator(path, query, header, formData, body)
  let scheme = call_574891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574891.url(scheme.get, call_574891.host, call_574891.base,
                         call_574891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574891, url, valid)

proc call*(call_574892: Call_BillingRoleAssignmentsDeleteByBillingAccount_574885;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string): Recallable =
  ## billingRoleAssignmentsDeleteByBillingAccount
  ## Delete the role assignment on this billing account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_574893 = newJObject()
  var query_574894 = newJObject()
  add(query_574894, "api-version", newJString(apiVersion))
  add(path_574893, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_574893, "billingAccountName", newJString(billingAccountName))
  result = call_574892.call(path_574893, query_574894, nil, nil, nil)

var billingRoleAssignmentsDeleteByBillingAccount* = Call_BillingRoleAssignmentsDeleteByBillingAccount_574885(
    name: "billingRoleAssignmentsDeleteByBillingAccount",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByBillingAccount_574886,
    base: "", url: url_BillingRoleAssignmentsDeleteByBillingAccount_574887,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByBillingAccount_574895 = ref object of OpenApiRestCall_573667
proc url_BillingRoleDefinitionsListByBillingAccount_574897(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/billingRoleDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsListByBillingAccount_574896(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the role definition for a billing account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574898 = path.getOrDefault("billingAccountName")
  valid_574898 = validateParameter(valid_574898, JString, required = true,
                                 default = nil)
  if valid_574898 != nil:
    section.add "billingAccountName", valid_574898
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574899 = query.getOrDefault("api-version")
  valid_574899 = validateParameter(valid_574899, JString, required = true,
                                 default = nil)
  if valid_574899 != nil:
    section.add "api-version", valid_574899
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574900: Call_BillingRoleDefinitionsListByBillingAccount_574895;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for a billing account
  ## 
  let valid = call_574900.validator(path, query, header, formData, body)
  let scheme = call_574900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574900.url(scheme.get, call_574900.host, call_574900.base,
                         call_574900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574900, url, valid)

proc call*(call_574901: Call_BillingRoleDefinitionsListByBillingAccount_574895;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingRoleDefinitionsListByBillingAccount
  ## Lists the role definition for a billing account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_574902 = newJObject()
  var query_574903 = newJObject()
  add(query_574903, "api-version", newJString(apiVersion))
  add(path_574902, "billingAccountName", newJString(billingAccountName))
  result = call_574901.call(path_574902, query_574903, nil, nil, nil)

var billingRoleDefinitionsListByBillingAccount* = Call_BillingRoleDefinitionsListByBillingAccount_574895(
    name: "billingRoleDefinitionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByBillingAccount_574896,
    base: "", url: url_BillingRoleDefinitionsListByBillingAccount_574897,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByBillingAccount_574904 = ref object of OpenApiRestCall_573667
proc url_BillingRoleDefinitionsGetByBillingAccount_574906(protocol: Scheme;
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
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingRoleDefinitions/"),
               (kind: VariableSegment, value: "billingRoleDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsGetByBillingAccount_574905(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the role definition for a role
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingRoleDefinitionName: JString (required)
  ##                            : role definition id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574907 = path.getOrDefault("billingAccountName")
  valid_574907 = validateParameter(valid_574907, JString, required = true,
                                 default = nil)
  if valid_574907 != nil:
    section.add "billingAccountName", valid_574907
  var valid_574908 = path.getOrDefault("billingRoleDefinitionName")
  valid_574908 = validateParameter(valid_574908, JString, required = true,
                                 default = nil)
  if valid_574908 != nil:
    section.add "billingRoleDefinitionName", valid_574908
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574909 = query.getOrDefault("api-version")
  valid_574909 = validateParameter(valid_574909, JString, required = true,
                                 default = nil)
  if valid_574909 != nil:
    section.add "api-version", valid_574909
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574910: Call_BillingRoleDefinitionsGetByBillingAccount_574904;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_574910.validator(path, query, header, formData, body)
  let scheme = call_574910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574910.url(scheme.get, call_574910.host, call_574910.base,
                         call_574910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574910, url, valid)

proc call*(call_574911: Call_BillingRoleDefinitionsGetByBillingAccount_574904;
          apiVersion: string; billingAccountName: string;
          billingRoleDefinitionName: string): Recallable =
  ## billingRoleDefinitionsGetByBillingAccount
  ## Gets the role definition for a role
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingRoleDefinitionName: string (required)
  ##                            : role definition id.
  var path_574912 = newJObject()
  var query_574913 = newJObject()
  add(query_574913, "api-version", newJString(apiVersion))
  add(path_574912, "billingAccountName", newJString(billingAccountName))
  add(path_574912, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  result = call_574911.call(path_574912, query_574913, nil, nil, nil)

var billingRoleDefinitionsGetByBillingAccount* = Call_BillingRoleDefinitionsGetByBillingAccount_574904(
    name: "billingRoleDefinitionsGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByBillingAccount_574905,
    base: "", url: url_BillingRoleDefinitionsGetByBillingAccount_574906,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByBillingAccount_574914 = ref object of OpenApiRestCall_573667
proc url_BillingSubscriptionsListByBillingAccount_574916(protocol: Scheme;
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

proc validate_BillingSubscriptionsListByBillingAccount_574915(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscriptions by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574917 = path.getOrDefault("billingAccountName")
  valid_574917 = validateParameter(valid_574917, JString, required = true,
                                 default = nil)
  if valid_574917 != nil:
    section.add "billingAccountName", valid_574917
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574918 = query.getOrDefault("api-version")
  valid_574918 = validateParameter(valid_574918, JString, required = true,
                                 default = nil)
  if valid_574918 != nil:
    section.add "api-version", valid_574918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574919: Call_BillingSubscriptionsListByBillingAccount_574914;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscriptions by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574919.validator(path, query, header, formData, body)
  let scheme = call_574919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574919.url(scheme.get, call_574919.host, call_574919.base,
                         call_574919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574919, url, valid)

proc call*(call_574920: Call_BillingSubscriptionsListByBillingAccount_574914;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingSubscriptionsListByBillingAccount
  ## Lists billing subscriptions by billing account name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_574921 = newJObject()
  var query_574922 = newJObject()
  add(query_574922, "api-version", newJString(apiVersion))
  add(path_574921, "billingAccountName", newJString(billingAccountName))
  result = call_574920.call(path_574921, query_574922, nil, nil, nil)

var billingSubscriptionsListByBillingAccount* = Call_BillingSubscriptionsListByBillingAccount_574914(
    name: "billingSubscriptionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByBillingAccount_574915, base: "",
    url: url_BillingSubscriptionsListByBillingAccount_574916,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByBillingAccount_574923 = ref object of OpenApiRestCall_573667
proc url_BillingRoleAssignmentsAddByBillingAccount_574925(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/createBillingRoleAssignment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsAddByBillingAccount_574924(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to add a role assignment to a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574926 = path.getOrDefault("billingAccountName")
  valid_574926 = validateParameter(valid_574926, JString, required = true,
                                 default = nil)
  if valid_574926 != nil:
    section.add "billingAccountName", valid_574926
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574927 = query.getOrDefault("api-version")
  valid_574927 = validateParameter(valid_574927, JString, required = true,
                                 default = nil)
  if valid_574927 != nil:
    section.add "api-version", valid_574927
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

proc call*(call_574929: Call_BillingRoleAssignmentsAddByBillingAccount_574923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a billing account.
  ## 
  let valid = call_574929.validator(path, query, header, formData, body)
  let scheme = call_574929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574929.url(scheme.get, call_574929.host, call_574929.base,
                         call_574929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574929, url, valid)

proc call*(call_574930: Call_BillingRoleAssignmentsAddByBillingAccount_574923;
          apiVersion: string; billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingRoleAssignmentsAddByBillingAccount
  ## The operation to add a role assignment to a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  var path_574931 = newJObject()
  var query_574932 = newJObject()
  var body_574933 = newJObject()
  add(query_574932, "api-version", newJString(apiVersion))
  add(path_574931, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_574933 = parameters
  result = call_574930.call(path_574931, query_574932, nil, nil, body_574933)

var billingRoleAssignmentsAddByBillingAccount* = Call_BillingRoleAssignmentsAddByBillingAccount_574923(
    name: "billingRoleAssignmentsAddByBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByBillingAccount_574924,
    base: "", url: url_BillingRoleAssignmentsAddByBillingAccount_574925,
    schemes: {Scheme.Https})
type
  Call_CustomersListByBillingAccount_574934 = ref object of OpenApiRestCall_573667
proc url_CustomersListByBillingAccount_574936(protocol: Scheme; host: string;
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

proc validate_CustomersListByBillingAccount_574935(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists customers which the current user can work with on-behalf of a partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574937 = path.getOrDefault("billingAccountName")
  valid_574937 = validateParameter(valid_574937, JString, required = true,
                                 default = nil)
  if valid_574937 != nil:
    section.add "billingAccountName", valid_574937
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter the list of customers.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574938 = query.getOrDefault("api-version")
  valid_574938 = validateParameter(valid_574938, JString, required = true,
                                 default = nil)
  if valid_574938 != nil:
    section.add "api-version", valid_574938
  var valid_574939 = query.getOrDefault("$skiptoken")
  valid_574939 = validateParameter(valid_574939, JString, required = false,
                                 default = nil)
  if valid_574939 != nil:
    section.add "$skiptoken", valid_574939
  var valid_574940 = query.getOrDefault("$filter")
  valid_574940 = validateParameter(valid_574940, JString, required = false,
                                 default = nil)
  if valid_574940 != nil:
    section.add "$filter", valid_574940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574941: Call_CustomersListByBillingAccount_574934; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists customers which the current user can work with on-behalf of a partner.
  ## 
  let valid = call_574941.validator(path, query, header, formData, body)
  let scheme = call_574941.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574941.url(scheme.get, call_574941.host, call_574941.base,
                         call_574941.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574941, url, valid)

proc call*(call_574942: Call_CustomersListByBillingAccount_574934;
          apiVersion: string; billingAccountName: string; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## customersListByBillingAccount
  ## Lists customers which the current user can work with on-behalf of a partner.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter the list of customers.
  var path_574943 = newJObject()
  var query_574944 = newJObject()
  add(query_574944, "api-version", newJString(apiVersion))
  add(path_574943, "billingAccountName", newJString(billingAccountName))
  add(query_574944, "$skiptoken", newJString(Skiptoken))
  add(query_574944, "$filter", newJString(Filter))
  result = call_574942.call(path_574943, query_574944, nil, nil, nil)

var customersListByBillingAccount* = Call_CustomersListByBillingAccount_574934(
    name: "customersListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers",
    validator: validate_CustomersListByBillingAccount_574935, base: "",
    url: url_CustomersListByBillingAccount_574936, schemes: {Scheme.Https})
type
  Call_CustomersGet_574945 = ref object of OpenApiRestCall_573667
proc url_CustomersGet_574947(protocol: Scheme; host: string; base: string;
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

proc validate_CustomersGet_574946(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a customer by its id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574948 = path.getOrDefault("billingAccountName")
  valid_574948 = validateParameter(valid_574948, JString, required = true,
                                 default = nil)
  if valid_574948 != nil:
    section.add "billingAccountName", valid_574948
  var valid_574949 = path.getOrDefault("customerName")
  valid_574949 = validateParameter(valid_574949, JString, required = true,
                                 default = nil)
  if valid_574949 != nil:
    section.add "customerName", valid_574949
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand enabledAzurePlans, resellers.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574950 = query.getOrDefault("api-version")
  valid_574950 = validateParameter(valid_574950, JString, required = true,
                                 default = nil)
  if valid_574950 != nil:
    section.add "api-version", valid_574950
  var valid_574951 = query.getOrDefault("$expand")
  valid_574951 = validateParameter(valid_574951, JString, required = false,
                                 default = nil)
  if valid_574951 != nil:
    section.add "$expand", valid_574951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574952: Call_CustomersGet_574945; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a customer by its id.
  ## 
  let valid = call_574952.validator(path, query, header, formData, body)
  let scheme = call_574952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574952.url(scheme.get, call_574952.host, call_574952.base,
                         call_574952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574952, url, valid)

proc call*(call_574953: Call_CustomersGet_574945; apiVersion: string;
          billingAccountName: string; customerName: string; Expand: string = ""): Recallable =
  ## customersGet
  ## Gets a customer by its id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand enabledAzurePlans, resellers.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  var path_574954 = newJObject()
  var query_574955 = newJObject()
  add(query_574955, "api-version", newJString(apiVersion))
  add(query_574955, "$expand", newJString(Expand))
  add(path_574954, "billingAccountName", newJString(billingAccountName))
  add(path_574954, "customerName", newJString(customerName))
  result = call_574953.call(path_574954, query_574955, nil, nil, nil)

var customersGet* = Call_CustomersGet_574945(name: "customersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}",
    validator: validate_CustomersGet_574946, base: "", url: url_CustomersGet_574947,
    schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByCustomer_574956 = ref object of OpenApiRestCall_573667
proc url_BillingPermissionsListByCustomer_574958(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByCustomer_574957(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing permissions the caller has for a customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574959 = path.getOrDefault("billingAccountName")
  valid_574959 = validateParameter(valid_574959, JString, required = true,
                                 default = nil)
  if valid_574959 != nil:
    section.add "billingAccountName", valid_574959
  var valid_574960 = path.getOrDefault("customerName")
  valid_574960 = validateParameter(valid_574960, JString, required = true,
                                 default = nil)
  if valid_574960 != nil:
    section.add "customerName", valid_574960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574961 = query.getOrDefault("api-version")
  valid_574961 = validateParameter(valid_574961, JString, required = true,
                                 default = nil)
  if valid_574961 != nil:
    section.add "api-version", valid_574961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574962: Call_BillingPermissionsListByCustomer_574956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions the caller has for a customer.
  ## 
  let valid = call_574962.validator(path, query, header, formData, body)
  let scheme = call_574962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574962.url(scheme.get, call_574962.host, call_574962.base,
                         call_574962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574962, url, valid)

proc call*(call_574963: Call_BillingPermissionsListByCustomer_574956;
          apiVersion: string; billingAccountName: string; customerName: string): Recallable =
  ## billingPermissionsListByCustomer
  ## Lists all billing permissions the caller has for a customer.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  var path_574964 = newJObject()
  var query_574965 = newJObject()
  add(query_574965, "api-version", newJString(apiVersion))
  add(path_574964, "billingAccountName", newJString(billingAccountName))
  add(path_574964, "customerName", newJString(customerName))
  result = call_574963.call(path_574964, query_574965, nil, nil, nil)

var billingPermissionsListByCustomer* = Call_BillingPermissionsListByCustomer_574956(
    name: "billingPermissionsListByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingPermissions",
    validator: validate_BillingPermissionsListByCustomer_574957, base: "",
    url: url_BillingPermissionsListByCustomer_574958, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByCustomer_574966 = ref object of OpenApiRestCall_573667
proc url_BillingSubscriptionsListByCustomer_574968(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/billingSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsListByCustomer_574967(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscription by customer id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574969 = path.getOrDefault("billingAccountName")
  valid_574969 = validateParameter(valid_574969, JString, required = true,
                                 default = nil)
  if valid_574969 != nil:
    section.add "billingAccountName", valid_574969
  var valid_574970 = path.getOrDefault("customerName")
  valid_574970 = validateParameter(valid_574970, JString, required = true,
                                 default = nil)
  if valid_574970 != nil:
    section.add "customerName", valid_574970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574971 = query.getOrDefault("api-version")
  valid_574971 = validateParameter(valid_574971, JString, required = true,
                                 default = nil)
  if valid_574971 != nil:
    section.add "api-version", valid_574971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574972: Call_BillingSubscriptionsListByCustomer_574966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscription by customer id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_574972.validator(path, query, header, formData, body)
  let scheme = call_574972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574972.url(scheme.get, call_574972.host, call_574972.base,
                         call_574972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574972, url, valid)

proc call*(call_574973: Call_BillingSubscriptionsListByCustomer_574966;
          apiVersion: string; billingAccountName: string; customerName: string): Recallable =
  ## billingSubscriptionsListByCustomer
  ## Lists billing subscription by customer id.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  var path_574974 = newJObject()
  var query_574975 = newJObject()
  add(query_574975, "api-version", newJString(apiVersion))
  add(path_574974, "billingAccountName", newJString(billingAccountName))
  add(path_574974, "customerName", newJString(customerName))
  result = call_574973.call(path_574974, query_574975, nil, nil, nil)

var billingSubscriptionsListByCustomer* = Call_BillingSubscriptionsListByCustomer_574966(
    name: "billingSubscriptionsListByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByCustomer_574967, base: "",
    url: url_BillingSubscriptionsListByCustomer_574968, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsGetByCustomer_574976 = ref object of OpenApiRestCall_573667
proc url_BillingSubscriptionsGetByCustomer_574978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_BillingSubscriptionsGetByCustomer_574977(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single billing subscription by id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574979 = path.getOrDefault("billingAccountName")
  valid_574979 = validateParameter(valid_574979, JString, required = true,
                                 default = nil)
  if valid_574979 != nil:
    section.add "billingAccountName", valid_574979
  var valid_574980 = path.getOrDefault("billingSubscriptionName")
  valid_574980 = validateParameter(valid_574980, JString, required = true,
                                 default = nil)
  if valid_574980 != nil:
    section.add "billingSubscriptionName", valid_574980
  var valid_574981 = path.getOrDefault("customerName")
  valid_574981 = validateParameter(valid_574981, JString, required = true,
                                 default = nil)
  if valid_574981 != nil:
    section.add "customerName", valid_574981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574982 = query.getOrDefault("api-version")
  valid_574982 = validateParameter(valid_574982, JString, required = true,
                                 default = nil)
  if valid_574982 != nil:
    section.add "api-version", valid_574982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574983: Call_BillingSubscriptionsGetByCustomer_574976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a single billing subscription by id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_574983.validator(path, query, header, formData, body)
  let scheme = call_574983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574983.url(scheme.get, call_574983.host, call_574983.base,
                         call_574983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574983, url, valid)

proc call*(call_574984: Call_BillingSubscriptionsGetByCustomer_574976;
          apiVersion: string; billingAccountName: string;
          billingSubscriptionName: string; customerName: string): Recallable =
  ## billingSubscriptionsGetByCustomer
  ## Get a single billing subscription by id.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   customerName: string (required)
  ##               : Customer name.
  var path_574985 = newJObject()
  var query_574986 = newJObject()
  add(query_574986, "api-version", newJString(apiVersion))
  add(path_574985, "billingAccountName", newJString(billingAccountName))
  add(path_574985, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_574985, "customerName", newJString(customerName))
  result = call_574984.call(path_574985, query_574986, nil, nil, nil)

var billingSubscriptionsGetByCustomer* = Call_BillingSubscriptionsGetByCustomer_574976(
    name: "billingSubscriptionsGetByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingSubscriptions/{billingSubscriptionName}",
    validator: validate_BillingSubscriptionsGetByCustomer_574977, base: "",
    url: url_BillingSubscriptionsGetByCustomer_574978, schemes: {Scheme.Https})
type
  Call_PoliciesUpdateCustomer_574997 = ref object of OpenApiRestCall_573667
proc url_PoliciesUpdateCustomer_574999(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/policies/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesUpdateCustomer_574998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a Customer policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575000 = path.getOrDefault("billingAccountName")
  valid_575000 = validateParameter(valid_575000, JString, required = true,
                                 default = nil)
  if valid_575000 != nil:
    section.add "billingAccountName", valid_575000
  var valid_575001 = path.getOrDefault("customerName")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = nil)
  if valid_575001 != nil:
    section.add "customerName", valid_575001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575002 = query.getOrDefault("api-version")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = nil)
  if valid_575002 != nil:
    section.add "api-version", valid_575002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update customer policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575004: Call_PoliciesUpdateCustomer_574997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a Customer policy.
  ## 
  let valid = call_575004.validator(path, query, header, formData, body)
  let scheme = call_575004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575004.url(scheme.get, call_575004.host, call_575004.base,
                         call_575004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575004, url, valid)

proc call*(call_575005: Call_PoliciesUpdateCustomer_574997; apiVersion: string;
          billingAccountName: string; parameters: JsonNode; customerName: string): Recallable =
  ## policiesUpdateCustomer
  ## The operation to update a Customer policy.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update customer policy operation.
  ##   customerName: string (required)
  ##               : Customer name.
  var path_575006 = newJObject()
  var query_575007 = newJObject()
  var body_575008 = newJObject()
  add(query_575007, "api-version", newJString(apiVersion))
  add(path_575006, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_575008 = parameters
  add(path_575006, "customerName", newJString(customerName))
  result = call_575005.call(path_575006, query_575007, nil, nil, body_575008)

var policiesUpdateCustomer* = Call_PoliciesUpdateCustomer_574997(
    name: "policiesUpdateCustomer", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/policies/default",
    validator: validate_PoliciesUpdateCustomer_574998, base: "",
    url: url_PoliciesUpdateCustomer_574999, schemes: {Scheme.Https})
type
  Call_PoliciesGetByCustomer_574987 = ref object of OpenApiRestCall_573667
proc url_PoliciesGetByCustomer_574989(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/policies/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesGetByCustomer_574988(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The policy for a given billing account name and customer name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_574990 = path.getOrDefault("billingAccountName")
  valid_574990 = validateParameter(valid_574990, JString, required = true,
                                 default = nil)
  if valid_574990 != nil:
    section.add "billingAccountName", valid_574990
  var valid_574991 = path.getOrDefault("customerName")
  valid_574991 = validateParameter(valid_574991, JString, required = true,
                                 default = nil)
  if valid_574991 != nil:
    section.add "customerName", valid_574991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574992 = query.getOrDefault("api-version")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = nil)
  if valid_574992 != nil:
    section.add "api-version", valid_574992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574993: Call_PoliciesGetByCustomer_574987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The policy for a given billing account name and customer name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_574993.validator(path, query, header, formData, body)
  let scheme = call_574993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574993.url(scheme.get, call_574993.host, call_574993.base,
                         call_574993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574993, url, valid)

proc call*(call_574994: Call_PoliciesGetByCustomer_574987; apiVersion: string;
          billingAccountName: string; customerName: string): Recallable =
  ## policiesGetByCustomer
  ## The policy for a given billing account name and customer name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  var path_574995 = newJObject()
  var query_574996 = newJObject()
  add(query_574996, "api-version", newJString(apiVersion))
  add(path_574995, "billingAccountName", newJString(billingAccountName))
  add(path_574995, "customerName", newJString(customerName))
  result = call_574994.call(path_574995, query_574996, nil, nil, nil)

var policiesGetByCustomer* = Call_PoliciesGetByCustomer_574987(
    name: "policiesGetByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/policies/default",
    validator: validate_PoliciesGetByCustomer_574988, base: "",
    url: url_PoliciesGetByCustomer_574989, schemes: {Scheme.Https})
type
  Call_ProductsListByCustomer_575009 = ref object of OpenApiRestCall_573667
proc url_ProductsListByCustomer_575011(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsListByCustomer_575010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists products by customer id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575012 = path.getOrDefault("billingAccountName")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "billingAccountName", valid_575012
  var valid_575013 = path.getOrDefault("customerName")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "customerName", valid_575013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575014 = query.getOrDefault("api-version")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "api-version", valid_575014
  var valid_575015 = query.getOrDefault("$filter")
  valid_575015 = validateParameter(valid_575015, JString, required = false,
                                 default = nil)
  if valid_575015 != nil:
    section.add "$filter", valid_575015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575016: Call_ProductsListByCustomer_575009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists products by customer id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_575016.validator(path, query, header, formData, body)
  let scheme = call_575016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575016.url(scheme.get, call_575016.host, call_575016.base,
                         call_575016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575016, url, valid)

proc call*(call_575017: Call_ProductsListByCustomer_575009; apiVersion: string;
          billingAccountName: string; customerName: string; Filter: string = ""): Recallable =
  ## productsListByCustomer
  ## Lists products by customer id.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   Filter: string
  ##         : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575018 = newJObject()
  var query_575019 = newJObject()
  add(query_575019, "api-version", newJString(apiVersion))
  add(path_575018, "billingAccountName", newJString(billingAccountName))
  add(path_575018, "customerName", newJString(customerName))
  add(query_575019, "$filter", newJString(Filter))
  result = call_575017.call(path_575018, query_575019, nil, nil, nil)

var productsListByCustomer* = Call_ProductsListByCustomer_575009(
    name: "productsListByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/products",
    validator: validate_ProductsListByCustomer_575010, base: "",
    url: url_ProductsListByCustomer_575011, schemes: {Scheme.Https})
type
  Call_ProductsGetByCustomer_575020 = ref object of OpenApiRestCall_573667
proc url_ProductsGetByCustomer_575022(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsGetByCustomer_575021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a customer's product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_575023 = path.getOrDefault("productName")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "productName", valid_575023
  var valid_575024 = path.getOrDefault("billingAccountName")
  valid_575024 = validateParameter(valid_575024, JString, required = true,
                                 default = nil)
  if valid_575024 != nil:
    section.add "billingAccountName", valid_575024
  var valid_575025 = path.getOrDefault("customerName")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "customerName", valid_575025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575026 = query.getOrDefault("api-version")
  valid_575026 = validateParameter(valid_575026, JString, required = true,
                                 default = nil)
  if valid_575026 != nil:
    section.add "api-version", valid_575026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575027: Call_ProductsGetByCustomer_575020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a customer's product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_575027.validator(path, query, header, formData, body)
  let scheme = call_575027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575027.url(scheme.get, call_575027.host, call_575027.base,
                         call_575027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575027, url, valid)

proc call*(call_575028: Call_ProductsGetByCustomer_575020; productName: string;
          apiVersion: string; billingAccountName: string; customerName: string): Recallable =
  ## productsGetByCustomer
  ## Get a customer's product by name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  var path_575029 = newJObject()
  var query_575030 = newJObject()
  add(path_575029, "productName", newJString(productName))
  add(query_575030, "api-version", newJString(apiVersion))
  add(path_575029, "billingAccountName", newJString(billingAccountName))
  add(path_575029, "customerName", newJString(customerName))
  result = call_575028.call(path_575029, query_575030, nil, nil, nil)

var productsGetByCustomer* = Call_ProductsGetByCustomer_575020(
    name: "productsGetByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/products/{productName}",
    validator: validate_ProductsGetByCustomer_575021, base: "",
    url: url_ProductsGetByCustomer_575022, schemes: {Scheme.Https})
type
  Call_TransactionsListByCustomer_575031 = ref object of OpenApiRestCall_573667
proc url_TransactionsListByCustomer_575033(protocol: Scheme; host: string;
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

proc validate_TransactionsListByCustomer_575032(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by customer id for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575034 = path.getOrDefault("billingAccountName")
  valid_575034 = validateParameter(valid_575034, JString, required = true,
                                 default = nil)
  if valid_575034 != nil:
    section.add "billingAccountName", valid_575034
  var valid_575035 = path.getOrDefault("customerName")
  valid_575035 = validateParameter(valid_575035, JString, required = true,
                                 default = nil)
  if valid_575035 != nil:
    section.add "customerName", valid_575035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575036 = query.getOrDefault("api-version")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = nil)
  if valid_575036 != nil:
    section.add "api-version", valid_575036
  var valid_575037 = query.getOrDefault("endDate")
  valid_575037 = validateParameter(valid_575037, JString, required = true,
                                 default = nil)
  if valid_575037 != nil:
    section.add "endDate", valid_575037
  var valid_575038 = query.getOrDefault("startDate")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "startDate", valid_575038
  var valid_575039 = query.getOrDefault("$filter")
  valid_575039 = validateParameter(valid_575039, JString, required = false,
                                 default = nil)
  if valid_575039 != nil:
    section.add "$filter", valid_575039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575040: Call_TransactionsListByCustomer_575031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the transactions by customer id for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_575040.validator(path, query, header, formData, body)
  let scheme = call_575040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575040.url(scheme.get, call_575040.host, call_575040.base,
                         call_575040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575040, url, valid)

proc call*(call_575041: Call_TransactionsListByCustomer_575031; apiVersion: string;
          endDate: string; billingAccountName: string; startDate: string;
          customerName: string; Filter: string = ""): Recallable =
  ## transactionsListByCustomer
  ## Lists the transactions by customer id for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   customerName: string (required)
  ##               : Customer name.
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575042 = newJObject()
  var query_575043 = newJObject()
  add(query_575043, "api-version", newJString(apiVersion))
  add(query_575043, "endDate", newJString(endDate))
  add(path_575042, "billingAccountName", newJString(billingAccountName))
  add(query_575043, "startDate", newJString(startDate))
  add(path_575042, "customerName", newJString(customerName))
  add(query_575043, "$filter", newJString(Filter))
  result = call_575041.call(path_575042, query_575043, nil, nil, nil)

var transactionsListByCustomer* = Call_TransactionsListByCustomer_575031(
    name: "transactionsListByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/transactions",
    validator: validate_TransactionsListByCustomer_575032, base: "",
    url: url_TransactionsListByCustomer_575033, schemes: {Scheme.Https})
type
  Call_DepartmentsListByBillingAccountName_575044 = ref object of OpenApiRestCall_573667
proc url_DepartmentsListByBillingAccountName_575046(protocol: Scheme; host: string;
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

proc validate_DepartmentsListByBillingAccountName_575045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all departments for a user which he has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575047 = path.getOrDefault("billingAccountName")
  valid_575047 = validateParameter(valid_575047, JString, required = true,
                                 default = nil)
  if valid_575047 != nil:
    section.add "billingAccountName", valid_575047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the enrollmentAccounts.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575048 = query.getOrDefault("api-version")
  valid_575048 = validateParameter(valid_575048, JString, required = true,
                                 default = nil)
  if valid_575048 != nil:
    section.add "api-version", valid_575048
  var valid_575049 = query.getOrDefault("$expand")
  valid_575049 = validateParameter(valid_575049, JString, required = false,
                                 default = nil)
  if valid_575049 != nil:
    section.add "$expand", valid_575049
  var valid_575050 = query.getOrDefault("$filter")
  valid_575050 = validateParameter(valid_575050, JString, required = false,
                                 default = nil)
  if valid_575050 != nil:
    section.add "$filter", valid_575050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575051: Call_DepartmentsListByBillingAccountName_575044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all departments for a user which he has access to.
  ## 
  let valid = call_575051.validator(path, query, header, formData, body)
  let scheme = call_575051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575051.url(scheme.get, call_575051.host, call_575051.base,
                         call_575051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575051, url, valid)

proc call*(call_575052: Call_DepartmentsListByBillingAccountName_575044;
          apiVersion: string; billingAccountName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## departmentsListByBillingAccountName
  ## Lists all departments for a user which he has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand the enrollmentAccounts.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575053 = newJObject()
  var query_575054 = newJObject()
  add(query_575054, "api-version", newJString(apiVersion))
  add(query_575054, "$expand", newJString(Expand))
  add(path_575053, "billingAccountName", newJString(billingAccountName))
  add(query_575054, "$filter", newJString(Filter))
  result = call_575052.call(path_575053, query_575054, nil, nil, nil)

var departmentsListByBillingAccountName* = Call_DepartmentsListByBillingAccountName_575044(
    name: "departmentsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/departments",
    validator: validate_DepartmentsListByBillingAccountName_575045, base: "",
    url: url_DepartmentsListByBillingAccountName_575046, schemes: {Scheme.Https})
type
  Call_DepartmentsGet_575055 = ref object of OpenApiRestCall_573667
proc url_DepartmentsGet_575057(protocol: Scheme; host: string; base: string;
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

proc validate_DepartmentsGet_575056(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get the department by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   departmentName: JString (required)
  ##                 : Department Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575058 = path.getOrDefault("billingAccountName")
  valid_575058 = validateParameter(valid_575058, JString, required = true,
                                 default = nil)
  if valid_575058 != nil:
    section.add "billingAccountName", valid_575058
  var valid_575059 = path.getOrDefault("departmentName")
  valid_575059 = validateParameter(valid_575059, JString, required = true,
                                 default = nil)
  if valid_575059 != nil:
    section.add "departmentName", valid_575059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the enrollmentAccounts.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575060 = query.getOrDefault("api-version")
  valid_575060 = validateParameter(valid_575060, JString, required = true,
                                 default = nil)
  if valid_575060 != nil:
    section.add "api-version", valid_575060
  var valid_575061 = query.getOrDefault("$expand")
  valid_575061 = validateParameter(valid_575061, JString, required = false,
                                 default = nil)
  if valid_575061 != nil:
    section.add "$expand", valid_575061
  var valid_575062 = query.getOrDefault("$filter")
  valid_575062 = validateParameter(valid_575062, JString, required = false,
                                 default = nil)
  if valid_575062 != nil:
    section.add "$filter", valid_575062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575063: Call_DepartmentsGet_575055; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the department by id.
  ## 
  let valid = call_575063.validator(path, query, header, formData, body)
  let scheme = call_575063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575063.url(scheme.get, call_575063.host, call_575063.base,
                         call_575063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575063, url, valid)

proc call*(call_575064: Call_DepartmentsGet_575055; apiVersion: string;
          billingAccountName: string; departmentName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## departmentsGet
  ## Get the department by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand the enrollmentAccounts.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   departmentName: string (required)
  ##                 : Department Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575065 = newJObject()
  var query_575066 = newJObject()
  add(query_575066, "api-version", newJString(apiVersion))
  add(query_575066, "$expand", newJString(Expand))
  add(path_575065, "billingAccountName", newJString(billingAccountName))
  add(path_575065, "departmentName", newJString(departmentName))
  add(query_575066, "$filter", newJString(Filter))
  result = call_575064.call(path_575065, query_575066, nil, nil, nil)

var departmentsGet* = Call_DepartmentsGet_575055(name: "departmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/departments/{departmentName}",
    validator: validate_DepartmentsGet_575056, base: "", url: url_DepartmentsGet_575057,
    schemes: {Scheme.Https})
type
  Call_EnrollmentAccountsListByBillingAccountName_575067 = ref object of OpenApiRestCall_573667
proc url_EnrollmentAccountsListByBillingAccountName_575069(protocol: Scheme;
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

proc validate_EnrollmentAccountsListByBillingAccountName_575068(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Enrollment Accounts for a user which he has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575070 = path.getOrDefault("billingAccountName")
  valid_575070 = validateParameter(valid_575070, JString, required = true,
                                 default = nil)
  if valid_575070 != nil:
    section.add "billingAccountName", valid_575070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the department.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575071 = query.getOrDefault("api-version")
  valid_575071 = validateParameter(valid_575071, JString, required = true,
                                 default = nil)
  if valid_575071 != nil:
    section.add "api-version", valid_575071
  var valid_575072 = query.getOrDefault("$expand")
  valid_575072 = validateParameter(valid_575072, JString, required = false,
                                 default = nil)
  if valid_575072 != nil:
    section.add "$expand", valid_575072
  var valid_575073 = query.getOrDefault("$filter")
  valid_575073 = validateParameter(valid_575073, JString, required = false,
                                 default = nil)
  if valid_575073 != nil:
    section.add "$filter", valid_575073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575074: Call_EnrollmentAccountsListByBillingAccountName_575067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Enrollment Accounts for a user which he has access to.
  ## 
  let valid = call_575074.validator(path, query, header, formData, body)
  let scheme = call_575074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575074.url(scheme.get, call_575074.host, call_575074.base,
                         call_575074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575074, url, valid)

proc call*(call_575075: Call_EnrollmentAccountsListByBillingAccountName_575067;
          apiVersion: string; billingAccountName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## enrollmentAccountsListByBillingAccountName
  ## Lists all Enrollment Accounts for a user which he has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand the department.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575076 = newJObject()
  var query_575077 = newJObject()
  add(query_575077, "api-version", newJString(apiVersion))
  add(query_575077, "$expand", newJString(Expand))
  add(path_575076, "billingAccountName", newJString(billingAccountName))
  add(query_575077, "$filter", newJString(Filter))
  result = call_575075.call(path_575076, query_575077, nil, nil, nil)

var enrollmentAccountsListByBillingAccountName* = Call_EnrollmentAccountsListByBillingAccountName_575067(
    name: "enrollmentAccountsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts",
    validator: validate_EnrollmentAccountsListByBillingAccountName_575068,
    base: "", url: url_EnrollmentAccountsListByBillingAccountName_575069,
    schemes: {Scheme.Https})
type
  Call_EnrollmentAccountsGetByEnrollmentAccountId_575078 = ref object of OpenApiRestCall_573667
proc url_EnrollmentAccountsGetByEnrollmentAccountId_575080(protocol: Scheme;
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

proc validate_EnrollmentAccountsGetByEnrollmentAccountId_575079(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the enrollment account by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   enrollmentAccountName: JString (required)
  ##                        : Enrollment Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575081 = path.getOrDefault("billingAccountName")
  valid_575081 = validateParameter(valid_575081, JString, required = true,
                                 default = nil)
  if valid_575081 != nil:
    section.add "billingAccountName", valid_575081
  var valid_575082 = path.getOrDefault("enrollmentAccountName")
  valid_575082 = validateParameter(valid_575082, JString, required = true,
                                 default = nil)
  if valid_575082 != nil:
    section.add "enrollmentAccountName", valid_575082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the Department.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575083 = query.getOrDefault("api-version")
  valid_575083 = validateParameter(valid_575083, JString, required = true,
                                 default = nil)
  if valid_575083 != nil:
    section.add "api-version", valid_575083
  var valid_575084 = query.getOrDefault("$expand")
  valid_575084 = validateParameter(valid_575084, JString, required = false,
                                 default = nil)
  if valid_575084 != nil:
    section.add "$expand", valid_575084
  var valid_575085 = query.getOrDefault("$filter")
  valid_575085 = validateParameter(valid_575085, JString, required = false,
                                 default = nil)
  if valid_575085 != nil:
    section.add "$filter", valid_575085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575086: Call_EnrollmentAccountsGetByEnrollmentAccountId_575078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the enrollment account by id.
  ## 
  let valid = call_575086.validator(path, query, header, formData, body)
  let scheme = call_575086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575086.url(scheme.get, call_575086.host, call_575086.base,
                         call_575086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575086, url, valid)

proc call*(call_575087: Call_EnrollmentAccountsGetByEnrollmentAccountId_575078;
          apiVersion: string; billingAccountName: string;
          enrollmentAccountName: string; Expand: string = ""; Filter: string = ""): Recallable =
  ## enrollmentAccountsGetByEnrollmentAccountId
  ## Get the enrollment account by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand the Department.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   enrollmentAccountName: string (required)
  ##                        : Enrollment Account Id.
  var path_575088 = newJObject()
  var query_575089 = newJObject()
  add(query_575089, "api-version", newJString(apiVersion))
  add(query_575089, "$expand", newJString(Expand))
  add(path_575088, "billingAccountName", newJString(billingAccountName))
  add(query_575089, "$filter", newJString(Filter))
  add(path_575088, "enrollmentAccountName", newJString(enrollmentAccountName))
  result = call_575087.call(path_575088, query_575089, nil, nil, nil)

var enrollmentAccountsGetByEnrollmentAccountId* = Call_EnrollmentAccountsGetByEnrollmentAccountId_575078(
    name: "enrollmentAccountsGetByEnrollmentAccountId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName}",
    validator: validate_EnrollmentAccountsGetByEnrollmentAccountId_575079,
    base: "", url: url_EnrollmentAccountsGetByEnrollmentAccountId_575080,
    schemes: {Scheme.Https})
type
  Call_InvoicesListByBillingAccount_575090 = ref object of OpenApiRestCall_573667
proc url_InvoicesListByBillingAccount_575092(protocol: Scheme; host: string;
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

proc validate_InvoicesListByBillingAccount_575091(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of invoices for a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575093 = path.getOrDefault("billingAccountName")
  valid_575093 = validateParameter(valid_575093, JString, required = true,
                                 default = nil)
  if valid_575093 != nil:
    section.add "billingAccountName", valid_575093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   periodEndDate: JString (required)
  ##                : Invoice period end date.
  ##   periodStartDate: JString (required)
  ##                  : Invoice period start date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575094 = query.getOrDefault("api-version")
  valid_575094 = validateParameter(valid_575094, JString, required = true,
                                 default = nil)
  if valid_575094 != nil:
    section.add "api-version", valid_575094
  var valid_575095 = query.getOrDefault("periodEndDate")
  valid_575095 = validateParameter(valid_575095, JString, required = true,
                                 default = nil)
  if valid_575095 != nil:
    section.add "periodEndDate", valid_575095
  var valid_575096 = query.getOrDefault("periodStartDate")
  valid_575096 = validateParameter(valid_575096, JString, required = true,
                                 default = nil)
  if valid_575096 != nil:
    section.add "periodStartDate", valid_575096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575097: Call_InvoicesListByBillingAccount_575090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of invoices for a billing account.
  ## 
  let valid = call_575097.validator(path, query, header, formData, body)
  let scheme = call_575097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575097.url(scheme.get, call_575097.host, call_575097.base,
                         call_575097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575097, url, valid)

proc call*(call_575098: Call_InvoicesListByBillingAccount_575090;
          apiVersion: string; billingAccountName: string; periodEndDate: string;
          periodStartDate: string): Recallable =
  ## invoicesListByBillingAccount
  ## List of invoices for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   periodEndDate: string (required)
  ##                : Invoice period end date.
  ##   periodStartDate: string (required)
  ##                  : Invoice period start date.
  var path_575099 = newJObject()
  var query_575100 = newJObject()
  add(query_575100, "api-version", newJString(apiVersion))
  add(path_575099, "billingAccountName", newJString(billingAccountName))
  add(query_575100, "periodEndDate", newJString(periodEndDate))
  add(query_575100, "periodStartDate", newJString(periodStartDate))
  result = call_575098.call(path_575099, query_575100, nil, nil, nil)

var invoicesListByBillingAccount* = Call_InvoicesListByBillingAccount_575090(
    name: "invoicesListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoices",
    validator: validate_InvoicesListByBillingAccount_575091, base: "",
    url: url_InvoicesListByBillingAccount_575092, schemes: {Scheme.Https})
type
  Call_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_575101 = ref object of OpenApiRestCall_573667
proc url_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_575103(
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

proc validate_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_575102(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all invoice sections with create subscription permission for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575104 = path.getOrDefault("billingAccountName")
  valid_575104 = validateParameter(valid_575104, JString, required = true,
                                 default = nil)
  if valid_575104 != nil:
    section.add "billingAccountName", valid_575104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575105 = query.getOrDefault("api-version")
  valid_575105 = validateParameter(valid_575105, JString, required = true,
                                 default = nil)
  if valid_575105 != nil:
    section.add "api-version", valid_575105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575106: Call_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_575101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoice sections with create subscription permission for a user.
  ## 
  let valid = call_575106.validator(path, query, header, formData, body)
  let scheme = call_575106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575106.url(scheme.get, call_575106.host, call_575106.base,
                         call_575106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575106, url, valid)

proc call*(call_575107: Call_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_575101;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingAccountsListInvoiceSectionsByCreateSubscriptionPermission
  ## Lists all invoice sections with create subscription permission for a user.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_575108 = newJObject()
  var query_575109 = newJObject()
  add(query_575109, "api-version", newJString(apiVersion))
  add(path_575108, "billingAccountName", newJString(billingAccountName))
  result = call_575107.call(path_575108, query_575109, nil, nil, nil)

var billingAccountsListInvoiceSectionsByCreateSubscriptionPermission* = Call_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_575101(
    name: "billingAccountsListInvoiceSectionsByCreateSubscriptionPermission",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/listInvoiceSectionsWithCreateSubscriptionPermission", validator: validate_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_575102,
    base: "",
    url: url_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_575103,
    schemes: {Scheme.Https})
type
  Call_PaymentMethodsListByBillingAccount_575110 = ref object of OpenApiRestCall_573667
proc url_PaymentMethodsListByBillingAccount_575112(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/paymentMethods")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PaymentMethodsListByBillingAccount_575111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Payment Methods by billing account Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/2019-10-01-preview/paymentmethods
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575113 = path.getOrDefault("billingAccountName")
  valid_575113 = validateParameter(valid_575113, JString, required = true,
                                 default = nil)
  if valid_575113 != nil:
    section.add "billingAccountName", valid_575113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575114 = query.getOrDefault("api-version")
  valid_575114 = validateParameter(valid_575114, JString, required = true,
                                 default = nil)
  if valid_575114 != nil:
    section.add "api-version", valid_575114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575115: Call_PaymentMethodsListByBillingAccount_575110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Payment Methods by billing account Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/2019-10-01-preview/paymentmethods
  let valid = call_575115.validator(path, query, header, formData, body)
  let scheme = call_575115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575115.url(scheme.get, call_575115.host, call_575115.base,
                         call_575115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575115, url, valid)

proc call*(call_575116: Call_PaymentMethodsListByBillingAccount_575110;
          apiVersion: string; billingAccountName: string): Recallable =
  ## paymentMethodsListByBillingAccount
  ## Lists the Payment Methods by billing account Id.
  ## https://docs.microsoft.com/en-us/rest/api/billing/2019-10-01-preview/paymentmethods
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_575117 = newJObject()
  var query_575118 = newJObject()
  add(query_575118, "api-version", newJString(apiVersion))
  add(path_575117, "billingAccountName", newJString(billingAccountName))
  result = call_575116.call(path_575117, query_575118, nil, nil, nil)

var paymentMethodsListByBillingAccount* = Call_PaymentMethodsListByBillingAccount_575110(
    name: "paymentMethodsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/paymentMethods",
    validator: validate_PaymentMethodsListByBillingAccount_575111, base: "",
    url: url_PaymentMethodsListByBillingAccount_575112, schemes: {Scheme.Https})
type
  Call_ProductsListByBillingAccount_575119 = ref object of OpenApiRestCall_573667
proc url_ProductsListByBillingAccount_575121(protocol: Scheme; host: string;
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

proc validate_ProductsListByBillingAccount_575120(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists products by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575122 = path.getOrDefault("billingAccountName")
  valid_575122 = validateParameter(valid_575122, JString, required = true,
                                 default = nil)
  if valid_575122 != nil:
    section.add "billingAccountName", valid_575122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575123 = query.getOrDefault("api-version")
  valid_575123 = validateParameter(valid_575123, JString, required = true,
                                 default = nil)
  if valid_575123 != nil:
    section.add "api-version", valid_575123
  var valid_575124 = query.getOrDefault("$filter")
  valid_575124 = validateParameter(valid_575124, JString, required = false,
                                 default = nil)
  if valid_575124 != nil:
    section.add "$filter", valid_575124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575125: Call_ProductsListByBillingAccount_575119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists products by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_575125.validator(path, query, header, formData, body)
  let scheme = call_575125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575125.url(scheme.get, call_575125.host, call_575125.base,
                         call_575125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575125, url, valid)

proc call*(call_575126: Call_ProductsListByBillingAccount_575119;
          apiVersion: string; billingAccountName: string; Filter: string = ""): Recallable =
  ## productsListByBillingAccount
  ## Lists products by billing account name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Filter: string
  ##         : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575127 = newJObject()
  var query_575128 = newJObject()
  add(query_575128, "api-version", newJString(apiVersion))
  add(path_575127, "billingAccountName", newJString(billingAccountName))
  add(query_575128, "$filter", newJString(Filter))
  result = call_575126.call(path_575127, query_575128, nil, nil, nil)

var productsListByBillingAccount* = Call_ProductsListByBillingAccount_575119(
    name: "productsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/products",
    validator: validate_ProductsListByBillingAccount_575120, base: "",
    url: url_ProductsListByBillingAccount_575121, schemes: {Scheme.Https})
type
  Call_TransactionsListByBillingAccount_575129 = ref object of OpenApiRestCall_573667
proc url_TransactionsListByBillingAccount_575131(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsListByBillingAccount_575130(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by billing account name for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_575132 = path.getOrDefault("billingAccountName")
  valid_575132 = validateParameter(valid_575132, JString, required = true,
                                 default = nil)
  if valid_575132 != nil:
    section.add "billingAccountName", valid_575132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575133 = query.getOrDefault("api-version")
  valid_575133 = validateParameter(valid_575133, JString, required = true,
                                 default = nil)
  if valid_575133 != nil:
    section.add "api-version", valid_575133
  var valid_575134 = query.getOrDefault("endDate")
  valid_575134 = validateParameter(valid_575134, JString, required = true,
                                 default = nil)
  if valid_575134 != nil:
    section.add "endDate", valid_575134
  var valid_575135 = query.getOrDefault("startDate")
  valid_575135 = validateParameter(valid_575135, JString, required = true,
                                 default = nil)
  if valid_575135 != nil:
    section.add "startDate", valid_575135
  var valid_575136 = query.getOrDefault("$filter")
  valid_575136 = validateParameter(valid_575136, JString, required = false,
                                 default = nil)
  if valid_575136 != nil:
    section.add "$filter", valid_575136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575137: Call_TransactionsListByBillingAccount_575129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by billing account name for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_575137.validator(path, query, header, formData, body)
  let scheme = call_575137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575137.url(scheme.get, call_575137.host, call_575137.base,
                         call_575137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575137, url, valid)

proc call*(call_575138: Call_TransactionsListByBillingAccount_575129;
          apiVersion: string; endDate: string; billingAccountName: string;
          startDate: string; Filter: string = ""): Recallable =
  ## transactionsListByBillingAccount
  ## Lists the transactions by billing account name for given start and end date.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_575139 = newJObject()
  var query_575140 = newJObject()
  add(query_575140, "api-version", newJString(apiVersion))
  add(query_575140, "endDate", newJString(endDate))
  add(path_575139, "billingAccountName", newJString(billingAccountName))
  add(query_575140, "startDate", newJString(startDate))
  add(query_575140, "$filter", newJString(Filter))
  result = call_575138.call(path_575139, query_575140, nil, nil, nil)

var transactionsListByBillingAccount* = Call_TransactionsListByBillingAccount_575129(
    name: "transactionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/transactions",
    validator: validate_TransactionsListByBillingAccount_575130, base: "",
    url: url_TransactionsListByBillingAccount_575131, schemes: {Scheme.Https})
type
  Call_OperationsList_575141 = ref object of OpenApiRestCall_573667
proc url_OperationsList_575143(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_575142(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575144 = query.getOrDefault("api-version")
  valid_575144 = validateParameter(valid_575144, JString, required = true,
                                 default = nil)
  if valid_575144 != nil:
    section.add "api-version", valid_575144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575145: Call_OperationsList_575141; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available billing REST API operations.
  ## 
  let valid = call_575145.validator(path, query, header, formData, body)
  let scheme = call_575145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575145.url(scheme.get, call_575145.host, call_575145.base,
                         call_575145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575145, url, valid)

proc call*(call_575146: Call_OperationsList_575141; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available billing REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  var query_575147 = newJObject()
  add(query_575147, "api-version", newJString(apiVersion))
  result = call_575146.call(nil, query_575147, nil, nil, nil)

var operationsList* = Call_OperationsList_575141(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/operations",
    validator: validate_OperationsList_575142, base: "", url: url_OperationsList_575143,
    schemes: {Scheme.Https})
type
  Call_RecipientTransfersList_575148 = ref object of OpenApiRestCall_573667
proc url_RecipientTransfersList_575150(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecipientTransfersList_575149(path: JsonNode; query: JsonNode;
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

proc call*(call_575151: Call_RecipientTransfersList_575148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575151.validator(path, query, header, formData, body)
  let scheme = call_575151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575151.url(scheme.get, call_575151.host, call_575151.base,
                         call_575151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575151, url, valid)

proc call*(call_575152: Call_RecipientTransfersList_575148): Recallable =
  ## recipientTransfersList
  result = call_575152.call(nil, nil, nil, nil, nil)

var recipientTransfersList* = Call_RecipientTransfersList_575148(
    name: "recipientTransfersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers",
    validator: validate_RecipientTransfersList_575149, base: "",
    url: url_RecipientTransfersList_575150, schemes: {Scheme.Https})
type
  Call_RecipientTransfersGet_575153 = ref object of OpenApiRestCall_573667
proc url_RecipientTransfersGet_575155(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/transfers/"),
               (kind: VariableSegment, value: "transferName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecipientTransfersGet_575154(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_575156 = path.getOrDefault("transferName")
  valid_575156 = validateParameter(valid_575156, JString, required = true,
                                 default = nil)
  if valid_575156 != nil:
    section.add "transferName", valid_575156
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575157: Call_RecipientTransfersGet_575153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575157.validator(path, query, header, formData, body)
  let scheme = call_575157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575157.url(scheme.get, call_575157.host, call_575157.base,
                         call_575157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575157, url, valid)

proc call*(call_575158: Call_RecipientTransfersGet_575153; transferName: string): Recallable =
  ## recipientTransfersGet
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_575159 = newJObject()
  add(path_575159, "transferName", newJString(transferName))
  result = call_575158.call(path_575159, nil, nil, nil, nil)

var recipientTransfersGet* = Call_RecipientTransfersGet_575153(
    name: "recipientTransfersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/transfers/{transferName}",
    validator: validate_RecipientTransfersGet_575154, base: "",
    url: url_RecipientTransfersGet_575155, schemes: {Scheme.Https})
type
  Call_RecipientTransfersAccept_575160 = ref object of OpenApiRestCall_573667
proc url_RecipientTransfersAccept_575162(protocol: Scheme; host: string;
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

proc validate_RecipientTransfersAccept_575161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_575163 = path.getOrDefault("transferName")
  valid_575163 = validateParameter(valid_575163, JString, required = true,
                                 default = nil)
  if valid_575163 != nil:
    section.add "transferName", valid_575163
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to accept the transfer.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575165: Call_RecipientTransfersAccept_575160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575165.validator(path, query, header, formData, body)
  let scheme = call_575165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575165.url(scheme.get, call_575165.host, call_575165.base,
                         call_575165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575165, url, valid)

proc call*(call_575166: Call_RecipientTransfersAccept_575160; parameters: JsonNode;
          transferName: string): Recallable =
  ## recipientTransfersAccept
  ##   parameters: JObject (required)
  ##             : Parameters supplied to accept the transfer.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_575167 = newJObject()
  var body_575168 = newJObject()
  if parameters != nil:
    body_575168 = parameters
  add(path_575167, "transferName", newJString(transferName))
  result = call_575166.call(path_575167, nil, nil, nil, body_575168)

var recipientTransfersAccept* = Call_RecipientTransfersAccept_575160(
    name: "recipientTransfersAccept", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/acceptTransfer",
    validator: validate_RecipientTransfersAccept_575161, base: "",
    url: url_RecipientTransfersAccept_575162, schemes: {Scheme.Https})
type
  Call_RecipientTransfersDecline_575169 = ref object of OpenApiRestCall_573667
proc url_RecipientTransfersDecline_575171(protocol: Scheme; host: string;
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

proc validate_RecipientTransfersDecline_575170(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_575172 = path.getOrDefault("transferName")
  valid_575172 = validateParameter(valid_575172, JString, required = true,
                                 default = nil)
  if valid_575172 != nil:
    section.add "transferName", valid_575172
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575173: Call_RecipientTransfersDecline_575169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575173.validator(path, query, header, formData, body)
  let scheme = call_575173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575173.url(scheme.get, call_575173.host, call_575173.base,
                         call_575173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575173, url, valid)

proc call*(call_575174: Call_RecipientTransfersDecline_575169; transferName: string): Recallable =
  ## recipientTransfersDecline
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_575175 = newJObject()
  add(path_575175, "transferName", newJString(transferName))
  result = call_575174.call(path_575175, nil, nil, nil, nil)

var recipientTransfersDecline* = Call_RecipientTransfersDecline_575169(
    name: "recipientTransfersDecline", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/declineTransfer",
    validator: validate_RecipientTransfersDecline_575170, base: "",
    url: url_RecipientTransfersDecline_575171, schemes: {Scheme.Https})
type
  Call_RecipientTransfersValidate_575176 = ref object of OpenApiRestCall_573667
proc url_RecipientTransfersValidate_575178(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/validateTransfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecipientTransfersValidate_575177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_575179 = path.getOrDefault("transferName")
  valid_575179 = validateParameter(valid_575179, JString, required = true,
                                 default = nil)
  if valid_575179 != nil:
    section.add "transferName", valid_575179
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to validate the transfer.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575181: Call_RecipientTransfersValidate_575176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575181.validator(path, query, header, formData, body)
  let scheme = call_575181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575181.url(scheme.get, call_575181.host, call_575181.base,
                         call_575181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575181, url, valid)

proc call*(call_575182: Call_RecipientTransfersValidate_575176;
          parameters: JsonNode; transferName: string): Recallable =
  ## recipientTransfersValidate
  ##   parameters: JObject (required)
  ##             : Parameters supplied to validate the transfer.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_575183 = newJObject()
  var body_575184 = newJObject()
  if parameters != nil:
    body_575184 = parameters
  add(path_575183, "transferName", newJString(transferName))
  result = call_575182.call(path_575183, nil, nil, nil, body_575184)

var recipientTransfersValidate* = Call_RecipientTransfersValidate_575176(
    name: "recipientTransfersValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/validateTransfer",
    validator: validate_RecipientTransfersValidate_575177, base: "",
    url: url_RecipientTransfersValidate_575178, schemes: {Scheme.Https})
type
  Call_AddressValidate_575185 = ref object of OpenApiRestCall_573667
proc url_AddressValidate_575187(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AddressValidate_575186(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575188 = query.getOrDefault("api-version")
  valid_575188 = validateParameter(valid_575188, JString, required = true,
                                 default = nil)
  if valid_575188 != nil:
    section.add "api-version", valid_575188
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

proc call*(call_575190: Call_AddressValidate_575185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the address.
  ## 
  let valid = call_575190.validator(path, query, header, formData, body)
  let scheme = call_575190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575190.url(scheme.get, call_575190.host, call_575190.base,
                         call_575190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575190, url, valid)

proc call*(call_575191: Call_AddressValidate_575185; apiVersion: string;
          address: JsonNode): Recallable =
  ## addressValidate
  ## Validates the address.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   address: JObject (required)
  var query_575192 = newJObject()
  var body_575193 = newJObject()
  add(query_575192, "api-version", newJString(apiVersion))
  if address != nil:
    body_575193 = address
  result = call_575191.call(nil, query_575192, nil, nil, body_575193)

var addressValidate* = Call_AddressValidate_575185(name: "addressValidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/validateAddress",
    validator: validate_AddressValidate_575186, base: "", url: url_AddressValidate_575187,
    schemes: {Scheme.Https})
type
  Call_LineOfCreditsUpdate_575203 = ref object of OpenApiRestCall_573667
proc url_LineOfCreditsUpdate_575205(protocol: Scheme; host: string; base: string;
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

proc validate_LineOfCreditsUpdate_575204(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Increase the current line of credit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575206 = path.getOrDefault("subscriptionId")
  valid_575206 = validateParameter(valid_575206, JString, required = true,
                                 default = nil)
  if valid_575206 != nil:
    section.add "subscriptionId", valid_575206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575207 = query.getOrDefault("api-version")
  valid_575207 = validateParameter(valid_575207, JString, required = true,
                                 default = nil)
  if valid_575207 != nil:
    section.add "api-version", valid_575207
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

proc call*(call_575209: Call_LineOfCreditsUpdate_575203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Increase the current line of credit.
  ## 
  let valid = call_575209.validator(path, query, header, formData, body)
  let scheme = call_575209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575209.url(scheme.get, call_575209.host, call_575209.base,
                         call_575209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575209, url, valid)

proc call*(call_575210: Call_LineOfCreditsUpdate_575203; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## lineOfCreditsUpdate
  ## Increase the current line of credit.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the increase line of credit operation.
  var path_575211 = newJObject()
  var query_575212 = newJObject()
  var body_575213 = newJObject()
  add(query_575212, "api-version", newJString(apiVersion))
  add(path_575211, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575213 = parameters
  result = call_575210.call(path_575211, query_575212, nil, nil, body_575213)

var lineOfCreditsUpdate* = Call_LineOfCreditsUpdate_575203(
    name: "lineOfCreditsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default",
    validator: validate_LineOfCreditsUpdate_575204, base: "",
    url: url_LineOfCreditsUpdate_575205, schemes: {Scheme.Https})
type
  Call_LineOfCreditsGet_575194 = ref object of OpenApiRestCall_573667
proc url_LineOfCreditsGet_575196(protocol: Scheme; host: string; base: string;
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

proc validate_LineOfCreditsGet_575195(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the current line of credit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575197 = path.getOrDefault("subscriptionId")
  valid_575197 = validateParameter(valid_575197, JString, required = true,
                                 default = nil)
  if valid_575197 != nil:
    section.add "subscriptionId", valid_575197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575198 = query.getOrDefault("api-version")
  valid_575198 = validateParameter(valid_575198, JString, required = true,
                                 default = nil)
  if valid_575198 != nil:
    section.add "api-version", valid_575198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575199: Call_LineOfCreditsGet_575194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the current line of credit.
  ## 
  let valid = call_575199.validator(path, query, header, formData, body)
  let scheme = call_575199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575199.url(scheme.get, call_575199.host, call_575199.base,
                         call_575199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575199, url, valid)

proc call*(call_575200: Call_LineOfCreditsGet_575194; apiVersion: string;
          subscriptionId: string): Recallable =
  ## lineOfCreditsGet
  ## Get the current line of credit.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575201 = newJObject()
  var query_575202 = newJObject()
  add(query_575202, "api-version", newJString(apiVersion))
  add(path_575201, "subscriptionId", newJString(subscriptionId))
  result = call_575200.call(path_575201, query_575202, nil, nil, nil)

var lineOfCreditsGet* = Call_LineOfCreditsGet_575194(name: "lineOfCreditsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default",
    validator: validate_LineOfCreditsGet_575195, base: "",
    url: url_LineOfCreditsGet_575196, schemes: {Scheme.Https})
type
  Call_BillingPropertyGet_575214 = ref object of OpenApiRestCall_573667
proc url_BillingPropertyGet_575216(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Billing/billingProperty/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPropertyGet_575215(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get billing property by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575217 = path.getOrDefault("subscriptionId")
  valid_575217 = validateParameter(valid_575217, JString, required = true,
                                 default = nil)
  if valid_575217 != nil:
    section.add "subscriptionId", valid_575217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575218 = query.getOrDefault("api-version")
  valid_575218 = validateParameter(valid_575218, JString, required = true,
                                 default = nil)
  if valid_575218 != nil:
    section.add "api-version", valid_575218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575219: Call_BillingPropertyGet_575214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get billing property by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_575219.validator(path, query, header, formData, body)
  let scheme = call_575219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575219.url(scheme.get, call_575219.host, call_575219.base,
                         call_575219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575219, url, valid)

proc call*(call_575220: Call_BillingPropertyGet_575214; apiVersion: string;
          subscriptionId: string): Recallable =
  ## billingPropertyGet
  ## Get billing property by subscription Id.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575221 = newJObject()
  var query_575222 = newJObject()
  add(query_575222, "api-version", newJString(apiVersion))
  add(path_575221, "subscriptionId", newJString(subscriptionId))
  result = call_575220.call(path_575221, query_575222, nil, nil, nil)

var billingPropertyGet* = Call_BillingPropertyGet_575214(
    name: "billingPropertyGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingProperty/default",
    validator: validate_BillingPropertyGet_575215, base: "",
    url: url_BillingPropertyGet_575216, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
