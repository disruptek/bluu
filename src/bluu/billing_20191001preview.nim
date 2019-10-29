
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "billing"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BillingAccountsList_563787 = ref object of OpenApiRestCall_563565
proc url_BillingAccountsList_563789(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BillingAccountsList_563788(path: JsonNode; query: JsonNode;
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
  var valid_563951 = query.getOrDefault("api-version")
  valid_563951 = validateParameter(valid_563951, JString, required = true,
                                 default = nil)
  if valid_563951 != nil:
    section.add "api-version", valid_563951
  var valid_563952 = query.getOrDefault("$expand")
  valid_563952 = validateParameter(valid_563952, JString, required = false,
                                 default = nil)
  if valid_563952 != nil:
    section.add "$expand", valid_563952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563975: Call_BillingAccountsList_563787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all billing accounts for a user which he has access to.
  ## 
  let valid = call_563975.validator(path, query, header, formData, body)
  let scheme = call_563975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563975.url(scheme.get, call_563975.host, call_563975.base,
                         call_563975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563975, url, valid)

proc call*(call_564046: Call_BillingAccountsList_563787; apiVersion: string;
          Expand: string = ""): Recallable =
  ## billingAccountsList
  ## Lists all billing accounts for a user which he has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   Expand: string
  ##         : May be used to expand the address, invoiceSections and billingProfiles.
  var query_564047 = newJObject()
  add(query_564047, "api-version", newJString(apiVersion))
  add(query_564047, "$expand", newJString(Expand))
  result = call_564046.call(nil, query_564047, nil, nil, nil)

var billingAccountsList* = Call_BillingAccountsList_563787(
    name: "billingAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts",
    validator: validate_BillingAccountsList_563788, base: "",
    url: url_BillingAccountsList_563789, schemes: {Scheme.Https})
type
  Call_BillingAccountsGet_564087 = ref object of OpenApiRestCall_563565
proc url_BillingAccountsGet_564089(protocol: Scheme; host: string; base: string;
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

proc validate_BillingAccountsGet_564088(path: JsonNode; query: JsonNode;
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
  var valid_564104 = path.getOrDefault("billingAccountName")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "billingAccountName", valid_564104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the address, invoiceSections and billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564105 = query.getOrDefault("api-version")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "api-version", valid_564105
  var valid_564106 = query.getOrDefault("$expand")
  valid_564106 = validateParameter(valid_564106, JString, required = false,
                                 default = nil)
  if valid_564106 != nil:
    section.add "$expand", valid_564106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564107: Call_BillingAccountsGet_564087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the billing account by id.
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_BillingAccountsGet_564087; apiVersion: string;
          billingAccountName: string; Expand: string = ""): Recallable =
  ## billingAccountsGet
  ## Get the billing account by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the address, invoiceSections and billingProfiles.
  var path_564109 = newJObject()
  var query_564110 = newJObject()
  add(query_564110, "api-version", newJString(apiVersion))
  add(path_564109, "billingAccountName", newJString(billingAccountName))
  add(query_564110, "$expand", newJString(Expand))
  result = call_564108.call(path_564109, query_564110, nil, nil, nil)

var billingAccountsGet* = Call_BillingAccountsGet_564087(
    name: "billingAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}",
    validator: validate_BillingAccountsGet_564088, base: "",
    url: url_BillingAccountsGet_564089, schemes: {Scheme.Https})
type
  Call_BillingAccountsUpdate_564111 = ref object of OpenApiRestCall_563565
proc url_BillingAccountsUpdate_564113(protocol: Scheme; host: string; base: string;
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

proc validate_BillingAccountsUpdate_564112(path: JsonNode; query: JsonNode;
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
  var valid_564131 = path.getOrDefault("billingAccountName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "billingAccountName", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
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

proc call*(call_564134: Call_BillingAccountsUpdate_564111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a billing account.
  ## 
  let valid = call_564134.validator(path, query, header, formData, body)
  let scheme = call_564134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564134.url(scheme.get, call_564134.host, call_564134.base,
                         call_564134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564134, url, valid)

proc call*(call_564135: Call_BillingAccountsUpdate_564111; apiVersion: string;
          billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingAccountsUpdate
  ## The operation to update a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the update billing account operation.
  var path_564136 = newJObject()
  var query_564137 = newJObject()
  var body_564138 = newJObject()
  add(query_564137, "api-version", newJString(apiVersion))
  add(path_564136, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_564138 = parameters
  result = call_564135.call(path_564136, query_564137, nil, nil, body_564138)

var billingAccountsUpdate* = Call_BillingAccountsUpdate_564111(
    name: "billingAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}",
    validator: validate_BillingAccountsUpdate_564112, base: "",
    url: url_BillingAccountsUpdate_564113, schemes: {Scheme.Https})
type
  Call_AgreementsListByBillingAccount_564139 = ref object of OpenApiRestCall_563565
proc url_AgreementsListByBillingAccount_564141(protocol: Scheme; host: string;
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

proc validate_AgreementsListByBillingAccount_564140(path: JsonNode;
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
  var valid_564142 = path.getOrDefault("billingAccountName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "billingAccountName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the participants.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  var valid_564144 = query.getOrDefault("$expand")
  valid_564144 = validateParameter(valid_564144, JString, required = false,
                                 default = nil)
  if valid_564144 != nil:
    section.add "$expand", valid_564144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564145: Call_AgreementsListByBillingAccount_564139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all agreements for a billing account.
  ## 
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_AgreementsListByBillingAccount_564139;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## agreementsListByBillingAccount
  ## Lists all agreements for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the participants.
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  add(query_564148, "api-version", newJString(apiVersion))
  add(path_564147, "billingAccountName", newJString(billingAccountName))
  add(query_564148, "$expand", newJString(Expand))
  result = call_564146.call(path_564147, query_564148, nil, nil, nil)

var agreementsListByBillingAccount* = Call_AgreementsListByBillingAccount_564139(
    name: "agreementsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/agreements",
    validator: validate_AgreementsListByBillingAccount_564140, base: "",
    url: url_AgreementsListByBillingAccount_564141, schemes: {Scheme.Https})
type
  Call_AgreementsGet_564149 = ref object of OpenApiRestCall_563565
proc url_AgreementsGet_564151(protocol: Scheme; host: string; base: string;
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

proc validate_AgreementsGet_564150(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564152 = path.getOrDefault("billingAccountName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "billingAccountName", valid_564152
  var valid_564153 = path.getOrDefault("agreementName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "agreementName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the participants.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  var valid_564155 = query.getOrDefault("$expand")
  valid_564155 = validateParameter(valid_564155, JString, required = false,
                                 default = nil)
  if valid_564155 != nil:
    section.add "$expand", valid_564155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_AgreementsGet_564149; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the agreement by name.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_AgreementsGet_564149; apiVersion: string;
          billingAccountName: string; agreementName: string; Expand: string = ""): Recallable =
  ## agreementsGet
  ## Get the agreement by name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the participants.
  ##   agreementName: string (required)
  ##                : Agreement Id.
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "billingAccountName", newJString(billingAccountName))
  add(query_564159, "$expand", newJString(Expand))
  add(path_564158, "agreementName", newJString(agreementName))
  result = call_564157.call(path_564158, query_564159, nil, nil, nil)

var agreementsGet* = Call_AgreementsGet_564149(name: "agreementsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsGet_564150, base: "", url: url_AgreementsGet_564151,
    schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByBillingAccount_564160 = ref object of OpenApiRestCall_563565
proc url_BillingPermissionsListByBillingAccount_564162(protocol: Scheme;
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

proc validate_BillingPermissionsListByBillingAccount_564161(path: JsonNode;
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
  var valid_564163 = path.getOrDefault("billingAccountName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "billingAccountName", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_BillingPermissionsListByBillingAccount_564160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under a billing account.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_BillingPermissionsListByBillingAccount_564160;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingPermissionsListByBillingAccount
  ## Lists all billing permissions for the caller under a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(query_564168, "api-version", newJString(apiVersion))
  add(path_564167, "billingAccountName", newJString(billingAccountName))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var billingPermissionsListByBillingAccount* = Call_BillingPermissionsListByBillingAccount_564160(
    name: "billingPermissionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingPermissions",
    validator: validate_BillingPermissionsListByBillingAccount_564161, base: "",
    url: url_BillingPermissionsListByBillingAccount_564162,
    schemes: {Scheme.Https})
type
  Call_BillingProfilesListByBillingAccount_564169 = ref object of OpenApiRestCall_563565
proc url_BillingProfilesListByBillingAccount_564171(protocol: Scheme; host: string;
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

proc validate_BillingProfilesListByBillingAccount_564170(path: JsonNode;
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
  var valid_564172 = path.getOrDefault("billingAccountName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "billingAccountName", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  var valid_564174 = query.getOrDefault("$expand")
  valid_564174 = validateParameter(valid_564174, JString, required = false,
                                 default = nil)
  if valid_564174 != nil:
    section.add "$expand", valid_564174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_BillingProfilesListByBillingAccount_564169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing profiles for a user which that user has access to.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_BillingProfilesListByBillingAccount_564169;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## billingProfilesListByBillingAccount
  ## Lists all billing profiles for a user which that user has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "billingAccountName", newJString(billingAccountName))
  add(query_564178, "$expand", newJString(Expand))
  result = call_564176.call(path_564177, query_564178, nil, nil, nil)

var billingProfilesListByBillingAccount* = Call_BillingProfilesListByBillingAccount_564169(
    name: "billingProfilesListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles",
    validator: validate_BillingProfilesListByBillingAccount_564170, base: "",
    url: url_BillingProfilesListByBillingAccount_564171, schemes: {Scheme.Https})
type
  Call_BillingProfilesCreate_564190 = ref object of OpenApiRestCall_563565
proc url_BillingProfilesCreate_564192(protocol: Scheme; host: string; base: string;
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

proc validate_BillingProfilesCreate_564191(path: JsonNode; query: JsonNode;
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
  var valid_564193 = path.getOrDefault("billingAccountName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "billingAccountName", valid_564193
  var valid_564194 = path.getOrDefault("billingProfileName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "billingProfileName", valid_564194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564195 = query.getOrDefault("api-version")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "api-version", valid_564195
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

proc call*(call_564197: Call_BillingProfilesCreate_564190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a BillingProfile.
  ## 
  let valid = call_564197.validator(path, query, header, formData, body)
  let scheme = call_564197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564197.url(scheme.get, call_564197.host, call_564197.base,
                         call_564197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564197, url, valid)

proc call*(call_564198: Call_BillingProfilesCreate_564190; apiVersion: string;
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
  var path_564199 = newJObject()
  var query_564200 = newJObject()
  var body_564201 = newJObject()
  add(query_564200, "api-version", newJString(apiVersion))
  add(path_564199, "billingAccountName", newJString(billingAccountName))
  add(path_564199, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564201 = parameters
  result = call_564198.call(path_564199, query_564200, nil, nil, body_564201)

var billingProfilesCreate* = Call_BillingProfilesCreate_564190(
    name: "billingProfilesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesCreate_564191, base: "",
    url: url_BillingProfilesCreate_564192, schemes: {Scheme.Https})
type
  Call_BillingProfilesGet_564179 = ref object of OpenApiRestCall_563565
proc url_BillingProfilesGet_564181(protocol: Scheme; host: string; base: string;
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

proc validate_BillingProfilesGet_564180(path: JsonNode; query: JsonNode;
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
  var valid_564182 = path.getOrDefault("billingAccountName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "billingAccountName", valid_564182
  var valid_564183 = path.getOrDefault("billingProfileName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "billingProfileName", valid_564183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564184 = query.getOrDefault("api-version")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "api-version", valid_564184
  var valid_564185 = query.getOrDefault("$expand")
  valid_564185 = validateParameter(valid_564185, JString, required = false,
                                 default = nil)
  if valid_564185 != nil:
    section.add "$expand", valid_564185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564186: Call_BillingProfilesGet_564179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the billing profile by id.
  ## 
  let valid = call_564186.validator(path, query, header, formData, body)
  let scheme = call_564186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564186.url(scheme.get, call_564186.host, call_564186.base,
                         call_564186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564186, url, valid)

proc call*(call_564187: Call_BillingProfilesGet_564179; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          Expand: string = ""): Recallable =
  ## billingProfilesGet
  ## Get the billing profile by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564188 = newJObject()
  var query_564189 = newJObject()
  add(query_564189, "api-version", newJString(apiVersion))
  add(path_564188, "billingAccountName", newJString(billingAccountName))
  add(query_564189, "$expand", newJString(Expand))
  add(path_564188, "billingProfileName", newJString(billingProfileName))
  result = call_564187.call(path_564188, query_564189, nil, nil, nil)

var billingProfilesGet* = Call_BillingProfilesGet_564179(
    name: "billingProfilesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesGet_564180, base: "",
    url: url_BillingProfilesGet_564181, schemes: {Scheme.Https})
type
  Call_BillingProfilesUpdate_564202 = ref object of OpenApiRestCall_563565
proc url_BillingProfilesUpdate_564204(protocol: Scheme; host: string; base: string;
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

proc validate_BillingProfilesUpdate_564203(path: JsonNode; query: JsonNode;
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
  var valid_564205 = path.getOrDefault("billingAccountName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "billingAccountName", valid_564205
  var valid_564206 = path.getOrDefault("billingProfileName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "billingProfileName", valid_564206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564207 = query.getOrDefault("api-version")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "api-version", valid_564207
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

proc call*(call_564209: Call_BillingProfilesUpdate_564202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a billing profile.
  ## 
  let valid = call_564209.validator(path, query, header, formData, body)
  let scheme = call_564209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564209.url(scheme.get, call_564209.host, call_564209.base,
                         call_564209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564209, url, valid)

proc call*(call_564210: Call_BillingProfilesUpdate_564202; apiVersion: string;
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
  var path_564211 = newJObject()
  var query_564212 = newJObject()
  var body_564213 = newJObject()
  add(query_564212, "api-version", newJString(apiVersion))
  add(path_564211, "billingAccountName", newJString(billingAccountName))
  add(path_564211, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564213 = parameters
  result = call_564210.call(path_564211, query_564212, nil, nil, body_564213)

var billingProfilesUpdate* = Call_BillingProfilesUpdate_564202(
    name: "billingProfilesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesUpdate_564203, base: "",
    url: url_BillingProfilesUpdate_564204, schemes: {Scheme.Https})
type
  Call_AvailableBalancesGetByBillingProfile_564214 = ref object of OpenApiRestCall_563565
proc url_AvailableBalancesGetByBillingProfile_564216(protocol: Scheme;
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

proc validate_AvailableBalancesGetByBillingProfile_564215(path: JsonNode;
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
  var valid_564217 = path.getOrDefault("billingAccountName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "billingAccountName", valid_564217
  var valid_564218 = path.getOrDefault("billingProfileName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "billingProfileName", valid_564218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564219 = query.getOrDefault("api-version")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "api-version", valid_564219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_AvailableBalancesGetByBillingProfile_564214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_AvailableBalancesGetByBillingProfile_564214;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## availableBalancesGetByBillingProfile
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "billingAccountName", newJString(billingAccountName))
  add(path_564222, "billingProfileName", newJString(billingProfileName))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var availableBalancesGetByBillingProfile* = Call_AvailableBalancesGetByBillingProfile_564214(
    name: "availableBalancesGetByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/availableBalance/default",
    validator: validate_AvailableBalancesGetByBillingProfile_564215, base: "",
    url: url_AvailableBalancesGetByBillingProfile_564216, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByBillingProfile_564224 = ref object of OpenApiRestCall_563565
proc url_BillingPermissionsListByBillingProfile_564226(protocol: Scheme;
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

proc validate_BillingPermissionsListByBillingProfile_564225(path: JsonNode;
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
  var valid_564227 = path.getOrDefault("billingAccountName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "billingAccountName", valid_564227
  var valid_564228 = path.getOrDefault("billingProfileName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "billingProfileName", valid_564228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "api-version", valid_564229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564230: Call_BillingPermissionsListByBillingProfile_564224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions the caller has for a billing account.
  ## 
  let valid = call_564230.validator(path, query, header, formData, body)
  let scheme = call_564230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564230.url(scheme.get, call_564230.host, call_564230.base,
                         call_564230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564230, url, valid)

proc call*(call_564231: Call_BillingPermissionsListByBillingProfile_564224;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingPermissionsListByBillingProfile
  ## Lists all billing permissions the caller has for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564232 = newJObject()
  var query_564233 = newJObject()
  add(query_564233, "api-version", newJString(apiVersion))
  add(path_564232, "billingAccountName", newJString(billingAccountName))
  add(path_564232, "billingProfileName", newJString(billingProfileName))
  result = call_564231.call(path_564232, query_564233, nil, nil, nil)

var billingPermissionsListByBillingProfile* = Call_BillingPermissionsListByBillingProfile_564224(
    name: "billingPermissionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingPermissions",
    validator: validate_BillingPermissionsListByBillingProfile_564225, base: "",
    url: url_BillingPermissionsListByBillingProfile_564226,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByBillingProfile_564234 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsListByBillingProfile_564236(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsListByBillingProfile_564235(path: JsonNode;
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
  var valid_564237 = path.getOrDefault("billingAccountName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "billingAccountName", valid_564237
  var valid_564238 = path.getOrDefault("billingProfileName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "billingProfileName", valid_564238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564239 = query.getOrDefault("api-version")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "api-version", valid_564239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564240: Call_BillingRoleAssignmentsListByBillingProfile_564234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the Billing Profile
  ## 
  let valid = call_564240.validator(path, query, header, formData, body)
  let scheme = call_564240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564240.url(scheme.get, call_564240.host, call_564240.base,
                         call_564240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564240, url, valid)

proc call*(call_564241: Call_BillingRoleAssignmentsListByBillingProfile_564234;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsListByBillingProfile
  ## Get the role assignments on the Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564242 = newJObject()
  var query_564243 = newJObject()
  add(query_564243, "api-version", newJString(apiVersion))
  add(path_564242, "billingAccountName", newJString(billingAccountName))
  add(path_564242, "billingProfileName", newJString(billingProfileName))
  result = call_564241.call(path_564242, query_564243, nil, nil, nil)

var billingRoleAssignmentsListByBillingProfile* = Call_BillingRoleAssignmentsListByBillingProfile_564234(
    name: "billingRoleAssignmentsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByBillingProfile_564235,
    base: "", url: url_BillingRoleAssignmentsListByBillingProfile_564236,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByBillingProfile_564244 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsGetByBillingProfile_564246(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsGetByBillingProfile_564245(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignment for the caller on the Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564247 = path.getOrDefault("billingAccountName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "billingAccountName", valid_564247
  var valid_564248 = path.getOrDefault("billingRoleAssignmentName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "billingRoleAssignmentName", valid_564248
  var valid_564249 = path.getOrDefault("billingProfileName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "billingProfileName", valid_564249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564250 = query.getOrDefault("api-version")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "api-version", valid_564250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564251: Call_BillingRoleAssignmentsGetByBillingProfile_564244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller on the Billing Profile
  ## 
  let valid = call_564251.validator(path, query, header, formData, body)
  let scheme = call_564251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564251.url(scheme.get, call_564251.host, call_564251.base,
                         call_564251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564251, url, valid)

proc call*(call_564252: Call_BillingRoleAssignmentsGetByBillingProfile_564244;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsGetByBillingProfile
  ## Get the role assignment for the caller on the Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564253 = newJObject()
  var query_564254 = newJObject()
  add(query_564254, "api-version", newJString(apiVersion))
  add(path_564253, "billingAccountName", newJString(billingAccountName))
  add(path_564253, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_564253, "billingProfileName", newJString(billingProfileName))
  result = call_564252.call(path_564253, query_564254, nil, nil, nil)

var billingRoleAssignmentsGetByBillingProfile* = Call_BillingRoleAssignmentsGetByBillingProfile_564244(
    name: "billingRoleAssignmentsGetByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByBillingProfile_564245,
    base: "", url: url_BillingRoleAssignmentsGetByBillingProfile_564246,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByBillingProfile_564255 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsDeleteByBillingProfile_564257(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsDeleteByBillingProfile_564256(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the role assignment on this Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564258 = path.getOrDefault("billingAccountName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "billingAccountName", valid_564258
  var valid_564259 = path.getOrDefault("billingRoleAssignmentName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "billingRoleAssignmentName", valid_564259
  var valid_564260 = path.getOrDefault("billingProfileName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "billingProfileName", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564262: Call_BillingRoleAssignmentsDeleteByBillingProfile_564255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on this Billing Profile
  ## 
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_BillingRoleAssignmentsDeleteByBillingProfile_564255;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsDeleteByBillingProfile
  ## Delete the role assignment on this Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  add(query_564265, "api-version", newJString(apiVersion))
  add(path_564264, "billingAccountName", newJString(billingAccountName))
  add(path_564264, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_564264, "billingProfileName", newJString(billingProfileName))
  result = call_564263.call(path_564264, query_564265, nil, nil, nil)

var billingRoleAssignmentsDeleteByBillingProfile* = Call_BillingRoleAssignmentsDeleteByBillingProfile_564255(
    name: "billingRoleAssignmentsDeleteByBillingProfile",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByBillingProfile_564256,
    base: "", url: url_BillingRoleAssignmentsDeleteByBillingProfile_564257,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByBillingProfile_564266 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsListByBillingProfile_564268(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsListByBillingProfile_564267(path: JsonNode;
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
  var valid_564269 = path.getOrDefault("billingAccountName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "billingAccountName", valid_564269
  var valid_564270 = path.getOrDefault("billingProfileName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "billingProfileName", valid_564270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564271 = query.getOrDefault("api-version")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "api-version", valid_564271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564272: Call_BillingRoleDefinitionsListByBillingProfile_564266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for a Billing Profile
  ## 
  let valid = call_564272.validator(path, query, header, formData, body)
  let scheme = call_564272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564272.url(scheme.get, call_564272.host, call_564272.base,
                         call_564272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564272, url, valid)

proc call*(call_564273: Call_BillingRoleDefinitionsListByBillingProfile_564266;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleDefinitionsListByBillingProfile
  ## Lists the role definition for a Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564274 = newJObject()
  var query_564275 = newJObject()
  add(query_564275, "api-version", newJString(apiVersion))
  add(path_564274, "billingAccountName", newJString(billingAccountName))
  add(path_564274, "billingProfileName", newJString(billingProfileName))
  result = call_564273.call(path_564274, query_564275, nil, nil, nil)

var billingRoleDefinitionsListByBillingProfile* = Call_BillingRoleDefinitionsListByBillingProfile_564266(
    name: "billingRoleDefinitionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByBillingProfile_564267,
    base: "", url: url_BillingRoleDefinitionsListByBillingProfile_564268,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByBillingProfile_564276 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsGetByBillingProfile_564278(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsGetByBillingProfile_564277(path: JsonNode;
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
  var valid_564279 = path.getOrDefault("billingAccountName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "billingAccountName", valid_564279
  var valid_564280 = path.getOrDefault("billingRoleDefinitionName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "billingRoleDefinitionName", valid_564280
  var valid_564281 = path.getOrDefault("billingProfileName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "billingProfileName", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564282 = query.getOrDefault("api-version")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "api-version", valid_564282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564283: Call_BillingRoleDefinitionsGetByBillingProfile_564276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_564283.validator(path, query, header, formData, body)
  let scheme = call_564283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564283.url(scheme.get, call_564283.host, call_564283.base,
                         call_564283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564283, url, valid)

proc call*(call_564284: Call_BillingRoleDefinitionsGetByBillingProfile_564276;
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
  var path_564285 = newJObject()
  var query_564286 = newJObject()
  add(query_564286, "api-version", newJString(apiVersion))
  add(path_564285, "billingAccountName", newJString(billingAccountName))
  add(path_564285, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  add(path_564285, "billingProfileName", newJString(billingProfileName))
  result = call_564284.call(path_564285, query_564286, nil, nil, nil)

var billingRoleDefinitionsGetByBillingProfile* = Call_BillingRoleDefinitionsGetByBillingProfile_564276(
    name: "billingRoleDefinitionsGetByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByBillingProfile_564277,
    base: "", url: url_BillingRoleDefinitionsGetByBillingProfile_564278,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByBillingProfile_564287 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsListByBillingProfile_564289(protocol: Scheme;
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

proc validate_BillingSubscriptionsListByBillingProfile_564288(path: JsonNode;
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
  var valid_564290 = path.getOrDefault("billingAccountName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "billingAccountName", valid_564290
  var valid_564291 = path.getOrDefault("billingProfileName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "billingProfileName", valid_564291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564292 = query.getOrDefault("api-version")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "api-version", valid_564292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_BillingSubscriptionsListByBillingProfile_564287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscriptions by billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_BillingSubscriptionsListByBillingProfile_564287;
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
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  add(query_564296, "api-version", newJString(apiVersion))
  add(path_564295, "billingAccountName", newJString(billingAccountName))
  add(path_564295, "billingProfileName", newJString(billingProfileName))
  result = call_564294.call(path_564295, query_564296, nil, nil, nil)

var billingSubscriptionsListByBillingProfile* = Call_BillingSubscriptionsListByBillingProfile_564287(
    name: "billingSubscriptionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByBillingProfile_564288, base: "",
    url: url_BillingSubscriptionsListByBillingProfile_564289,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByBillingProfile_564297 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsAddByBillingProfile_564299(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsAddByBillingProfile_564298(path: JsonNode;
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
  var valid_564300 = path.getOrDefault("billingAccountName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "billingAccountName", valid_564300
  var valid_564301 = path.getOrDefault("billingProfileName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "billingProfileName", valid_564301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564302 = query.getOrDefault("api-version")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "api-version", valid_564302
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

proc call*(call_564304: Call_BillingRoleAssignmentsAddByBillingProfile_564297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a billing profile.
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_BillingRoleAssignmentsAddByBillingProfile_564297;
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
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  var body_564308 = newJObject()
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "billingAccountName", newJString(billingAccountName))
  add(path_564306, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564308 = parameters
  result = call_564305.call(path_564306, query_564307, nil, nil, body_564308)

var billingRoleAssignmentsAddByBillingProfile* = Call_BillingRoleAssignmentsAddByBillingProfile_564297(
    name: "billingRoleAssignmentsAddByBillingProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByBillingProfile_564298,
    base: "", url: url_BillingRoleAssignmentsAddByBillingProfile_564299,
    schemes: {Scheme.Https})
type
  Call_CustomersListByBillingProfile_564309 = ref object of OpenApiRestCall_563565
proc url_CustomersListByBillingProfile_564311(protocol: Scheme; host: string;
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

proc validate_CustomersListByBillingProfile_564310(path: JsonNode; query: JsonNode;
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
  var valid_564312 = path.getOrDefault("billingAccountName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "billingAccountName", valid_564312
  var valid_564313 = path.getOrDefault("billingProfileName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "billingProfileName", valid_564313
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
  var valid_564314 = query.getOrDefault("api-version")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "api-version", valid_564314
  var valid_564315 = query.getOrDefault("$skiptoken")
  valid_564315 = validateParameter(valid_564315, JString, required = false,
                                 default = nil)
  if valid_564315 != nil:
    section.add "$skiptoken", valid_564315
  var valid_564316 = query.getOrDefault("$filter")
  valid_564316 = validateParameter(valid_564316, JString, required = false,
                                 default = nil)
  if valid_564316 != nil:
    section.add "$filter", valid_564316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564317: Call_CustomersListByBillingProfile_564309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists customers by billing profile which the current user can work with on-behalf of a partner.
  ## 
  let valid = call_564317.validator(path, query, header, formData, body)
  let scheme = call_564317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564317.url(scheme.get, call_564317.host, call_564317.base,
                         call_564317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564317, url, valid)

proc call*(call_564318: Call_CustomersListByBillingProfile_564309;
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
  ##   Filter: string
  ##         : May be used to filter the list of customers.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564319 = newJObject()
  var query_564320 = newJObject()
  add(query_564320, "api-version", newJString(apiVersion))
  add(path_564319, "billingAccountName", newJString(billingAccountName))
  add(query_564320, "$skiptoken", newJString(Skiptoken))
  add(query_564320, "$filter", newJString(Filter))
  add(path_564319, "billingProfileName", newJString(billingProfileName))
  result = call_564318.call(path_564319, query_564320, nil, nil, nil)

var customersListByBillingProfile* = Call_CustomersListByBillingProfile_564309(
    name: "customersListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/customers",
    validator: validate_CustomersListByBillingProfile_564310, base: "",
    url: url_CustomersListByBillingProfile_564311, schemes: {Scheme.Https})
type
  Call_PartnerTransfersInitiate_564321 = ref object of OpenApiRestCall_563565
proc url_PartnerTransfersInitiate_564323(protocol: Scheme; host: string;
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

proc validate_PartnerTransfersInitiate_564322(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564324 = path.getOrDefault("billingAccountName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "billingAccountName", valid_564324
  var valid_564325 = path.getOrDefault("customerName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "customerName", valid_564325
  var valid_564326 = path.getOrDefault("billingProfileName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "billingProfileName", valid_564326
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

proc call*(call_564328: Call_PartnerTransfersInitiate_564321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_PartnerTransfersInitiate_564321;
          billingAccountName: string; customerName: string;
          billingProfileName: string; parameters: JsonNode): Recallable =
  ## partnerTransfersInitiate
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to initiate the transfer.
  var path_564330 = newJObject()
  var body_564331 = newJObject()
  add(path_564330, "billingAccountName", newJString(billingAccountName))
  add(path_564330, "customerName", newJString(customerName))
  add(path_564330, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564331 = parameters
  result = call_564329.call(path_564330, nil, nil, nil, body_564331)

var partnerTransfersInitiate* = Call_PartnerTransfersInitiate_564321(
    name: "partnerTransfersInitiate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/customers/{customerName}/initiateTransfer",
    validator: validate_PartnerTransfersInitiate_564322, base: "",
    url: url_PartnerTransfersInitiate_564323, schemes: {Scheme.Https})
type
  Call_PartnerTransfersTransfersList_564332 = ref object of OpenApiRestCall_563565
proc url_PartnerTransfersTransfersList_564334(protocol: Scheme; host: string;
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

proc validate_PartnerTransfersTransfersList_564333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564335 = path.getOrDefault("billingAccountName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "billingAccountName", valid_564335
  var valid_564336 = path.getOrDefault("customerName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "customerName", valid_564336
  var valid_564337 = path.getOrDefault("billingProfileName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "billingProfileName", valid_564337
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564338: Call_PartnerTransfersTransfersList_564332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_PartnerTransfersTransfersList_564332;
          billingAccountName: string; customerName: string;
          billingProfileName: string): Recallable =
  ## partnerTransfersTransfersList
  ## Lists all transfer's details initiated from given invoice section.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564340 = newJObject()
  add(path_564340, "billingAccountName", newJString(billingAccountName))
  add(path_564340, "customerName", newJString(customerName))
  add(path_564340, "billingProfileName", newJString(billingProfileName))
  result = call_564339.call(path_564340, nil, nil, nil, nil)

var partnerTransfersTransfersList* = Call_PartnerTransfersTransfersList_564332(
    name: "partnerTransfersTransfersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/customers/{customerName}/transfers",
    validator: validate_PartnerTransfersTransfersList_564333, base: "",
    url: url_PartnerTransfersTransfersList_564334, schemes: {Scheme.Https})
type
  Call_PartnerTransfersGet_564341 = ref object of OpenApiRestCall_563565
proc url_PartnerTransfersGet_564343(protocol: Scheme; host: string; base: string;
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

proc validate_PartnerTransfersGet_564342(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the transfer details for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_564344 = path.getOrDefault("transferName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "transferName", valid_564344
  var valid_564345 = path.getOrDefault("billingAccountName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "billingAccountName", valid_564345
  var valid_564346 = path.getOrDefault("customerName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "customerName", valid_564346
  var valid_564347 = path.getOrDefault("billingProfileName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "billingProfileName", valid_564347
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564348: Call_PartnerTransfersGet_564341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the transfer details for given transfer Id.
  ## 
  let valid = call_564348.validator(path, query, header, formData, body)
  let scheme = call_564348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564348.url(scheme.get, call_564348.host, call_564348.base,
                         call_564348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564348, url, valid)

proc call*(call_564349: Call_PartnerTransfersGet_564341; transferName: string;
          billingAccountName: string; customerName: string;
          billingProfileName: string): Recallable =
  ## partnerTransfersGet
  ## Gets the transfer details for given transfer Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564350 = newJObject()
  add(path_564350, "transferName", newJString(transferName))
  add(path_564350, "billingAccountName", newJString(billingAccountName))
  add(path_564350, "customerName", newJString(customerName))
  add(path_564350, "billingProfileName", newJString(billingProfileName))
  result = call_564349.call(path_564350, nil, nil, nil, nil)

var partnerTransfersGet* = Call_PartnerTransfersGet_564341(
    name: "partnerTransfersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/customers/{customerName}/transfers/{transferName}",
    validator: validate_PartnerTransfersGet_564342, base: "",
    url: url_PartnerTransfersGet_564343, schemes: {Scheme.Https})
type
  Call_PartnerTransfersCancel_564351 = ref object of OpenApiRestCall_563565
proc url_PartnerTransfersCancel_564353(protocol: Scheme; host: string; base: string;
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

proc validate_PartnerTransfersCancel_564352(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the transfer for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_564354 = path.getOrDefault("transferName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "transferName", valid_564354
  var valid_564355 = path.getOrDefault("billingAccountName")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "billingAccountName", valid_564355
  var valid_564356 = path.getOrDefault("customerName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "customerName", valid_564356
  var valid_564357 = path.getOrDefault("billingProfileName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "billingProfileName", valid_564357
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564358: Call_PartnerTransfersCancel_564351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the transfer for given transfer Id.
  ## 
  let valid = call_564358.validator(path, query, header, formData, body)
  let scheme = call_564358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564358.url(scheme.get, call_564358.host, call_564358.base,
                         call_564358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564358, url, valid)

proc call*(call_564359: Call_PartnerTransfersCancel_564351; transferName: string;
          billingAccountName: string; customerName: string;
          billingProfileName: string): Recallable =
  ## partnerTransfersCancel
  ## Cancels the transfer for given transfer Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564360 = newJObject()
  add(path_564360, "transferName", newJString(transferName))
  add(path_564360, "billingAccountName", newJString(billingAccountName))
  add(path_564360, "customerName", newJString(customerName))
  add(path_564360, "billingProfileName", newJString(billingProfileName))
  result = call_564359.call(path_564360, nil, nil, nil, nil)

var partnerTransfersCancel* = Call_PartnerTransfersCancel_564351(
    name: "partnerTransfersCancel", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/customers/{customerName}/transfers/{transferName}",
    validator: validate_PartnerTransfersCancel_564352, base: "",
    url: url_PartnerTransfersCancel_564353, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsListByBillingProfile_564361 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsListByBillingProfile_564363(protocol: Scheme; host: string;
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

proc validate_InvoiceSectionsListByBillingProfile_564362(path: JsonNode;
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
  var valid_564364 = path.getOrDefault("billingAccountName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "billingAccountName", valid_564364
  var valid_564365 = path.getOrDefault("billingProfileName")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "billingProfileName", valid_564365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564366 = query.getOrDefault("api-version")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "api-version", valid_564366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564367: Call_InvoiceSectionsListByBillingProfile_564361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoice sections for a user which he has access to.
  ## 
  let valid = call_564367.validator(path, query, header, formData, body)
  let scheme = call_564367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564367.url(scheme.get, call_564367.host, call_564367.base,
                         call_564367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564367, url, valid)

proc call*(call_564368: Call_InvoiceSectionsListByBillingProfile_564361;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## invoiceSectionsListByBillingProfile
  ## Lists all invoice sections for a user which he has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564369 = newJObject()
  var query_564370 = newJObject()
  add(query_564370, "api-version", newJString(apiVersion))
  add(path_564369, "billingAccountName", newJString(billingAccountName))
  add(path_564369, "billingProfileName", newJString(billingProfileName))
  result = call_564368.call(path_564369, query_564370, nil, nil, nil)

var invoiceSectionsListByBillingProfile* = Call_InvoiceSectionsListByBillingProfile_564361(
    name: "invoiceSectionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections",
    validator: validate_InvoiceSectionsListByBillingProfile_564362, base: "",
    url: url_InvoiceSectionsListByBillingProfile_564363, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsCreate_564382 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsCreate_564384(protocol: Scheme; host: string; base: string;
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

proc validate_InvoiceSectionsCreate_564383(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564385 = path.getOrDefault("billingAccountName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "billingAccountName", valid_564385
  var valid_564386 = path.getOrDefault("billingProfileName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "billingProfileName", valid_564386
  var valid_564387 = path.getOrDefault("invoiceSectionName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "invoiceSectionName", valid_564387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564388 = query.getOrDefault("api-version")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "api-version", valid_564388
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

proc call*(call_564390: Call_InvoiceSectionsCreate_564382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create an invoice section.
  ## 
  let valid = call_564390.validator(path, query, header, formData, body)
  let scheme = call_564390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564390.url(scheme.get, call_564390.host, call_564390.base,
                         call_564390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564390, url, valid)

proc call*(call_564391: Call_InvoiceSectionsCreate_564382; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          parameters: JsonNode; invoiceSectionName: string): Recallable =
  ## invoiceSectionsCreate
  ## The operation to create an invoice section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the Create InvoiceSection operation.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564392 = newJObject()
  var query_564393 = newJObject()
  var body_564394 = newJObject()
  add(query_564393, "api-version", newJString(apiVersion))
  add(path_564392, "billingAccountName", newJString(billingAccountName))
  add(path_564392, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564394 = parameters
  add(path_564392, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564391.call(path_564392, query_564393, nil, nil, body_564394)

var invoiceSectionsCreate* = Call_InvoiceSectionsCreate_564382(
    name: "invoiceSectionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsCreate_564383, base: "",
    url: url_InvoiceSectionsCreate_564384, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsGet_564371 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsGet_564373(protocol: Scheme; host: string; base: string;
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

proc validate_InvoiceSectionsGet_564372(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the InvoiceSection by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564374 = path.getOrDefault("billingAccountName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "billingAccountName", valid_564374
  var valid_564375 = path.getOrDefault("billingProfileName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "billingProfileName", valid_564375
  var valid_564376 = path.getOrDefault("invoiceSectionName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "invoiceSectionName", valid_564376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564377 = query.getOrDefault("api-version")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "api-version", valid_564377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564378: Call_InvoiceSectionsGet_564371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the InvoiceSection by id.
  ## 
  let valid = call_564378.validator(path, query, header, formData, body)
  let scheme = call_564378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564378.url(scheme.get, call_564378.host, call_564378.base,
                         call_564378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564378, url, valid)

proc call*(call_564379: Call_InvoiceSectionsGet_564371; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          invoiceSectionName: string): Recallable =
  ## invoiceSectionsGet
  ## Get the InvoiceSection by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564380 = newJObject()
  var query_564381 = newJObject()
  add(query_564381, "api-version", newJString(apiVersion))
  add(path_564380, "billingAccountName", newJString(billingAccountName))
  add(path_564380, "billingProfileName", newJString(billingProfileName))
  add(path_564380, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564379.call(path_564380, query_564381, nil, nil, nil)

var invoiceSectionsGet* = Call_InvoiceSectionsGet_564371(
    name: "invoiceSectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsGet_564372, base: "",
    url: url_InvoiceSectionsGet_564373, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsUpdate_564395 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsUpdate_564397(protocol: Scheme; host: string; base: string;
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

proc validate_InvoiceSectionsUpdate_564396(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a InvoiceSection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564398 = path.getOrDefault("billingAccountName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "billingAccountName", valid_564398
  var valid_564399 = path.getOrDefault("billingProfileName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "billingProfileName", valid_564399
  var valid_564400 = path.getOrDefault("invoiceSectionName")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "invoiceSectionName", valid_564400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564401 = query.getOrDefault("api-version")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "api-version", valid_564401
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

proc call*(call_564403: Call_InvoiceSectionsUpdate_564395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a InvoiceSection.
  ## 
  let valid = call_564403.validator(path, query, header, formData, body)
  let scheme = call_564403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564403.url(scheme.get, call_564403.host, call_564403.base,
                         call_564403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564403, url, valid)

proc call*(call_564404: Call_InvoiceSectionsUpdate_564395; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          parameters: JsonNode; invoiceSectionName: string): Recallable =
  ## invoiceSectionsUpdate
  ## The operation to update a InvoiceSection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the Create InvoiceSection operation.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564405 = newJObject()
  var query_564406 = newJObject()
  var body_564407 = newJObject()
  add(query_564406, "api-version", newJString(apiVersion))
  add(path_564405, "billingAccountName", newJString(billingAccountName))
  add(path_564405, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564407 = parameters
  add(path_564405, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564404.call(path_564405, query_564406, nil, nil, body_564407)

var invoiceSectionsUpdate* = Call_InvoiceSectionsUpdate_564395(
    name: "invoiceSectionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsUpdate_564396, base: "",
    url: url_InvoiceSectionsUpdate_564397, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByInvoiceSections_564408 = ref object of OpenApiRestCall_563565
proc url_BillingPermissionsListByInvoiceSections_564410(protocol: Scheme;
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

proc validate_BillingPermissionsListByInvoiceSections_564409(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing permissions for the caller under invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564411 = path.getOrDefault("billingAccountName")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "billingAccountName", valid_564411
  var valid_564412 = path.getOrDefault("billingProfileName")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "billingProfileName", valid_564412
  var valid_564413 = path.getOrDefault("invoiceSectionName")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "invoiceSectionName", valid_564413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564414 = query.getOrDefault("api-version")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "api-version", valid_564414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564415: Call_BillingPermissionsListByInvoiceSections_564408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under invoice section.
  ## 
  let valid = call_564415.validator(path, query, header, formData, body)
  let scheme = call_564415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564415.url(scheme.get, call_564415.host, call_564415.base,
                         call_564415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564415, url, valid)

proc call*(call_564416: Call_BillingPermissionsListByInvoiceSections_564408;
          apiVersion: string; billingAccountName: string;
          billingProfileName: string; invoiceSectionName: string): Recallable =
  ## billingPermissionsListByInvoiceSections
  ## Lists all billing permissions for the caller under invoice section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564417 = newJObject()
  var query_564418 = newJObject()
  add(query_564418, "api-version", newJString(apiVersion))
  add(path_564417, "billingAccountName", newJString(billingAccountName))
  add(path_564417, "billingProfileName", newJString(billingProfileName))
  add(path_564417, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564416.call(path_564417, query_564418, nil, nil, nil)

var billingPermissionsListByInvoiceSections* = Call_BillingPermissionsListByInvoiceSections_564408(
    name: "billingPermissionsListByInvoiceSections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingPermissions",
    validator: validate_BillingPermissionsListByInvoiceSections_564409, base: "",
    url: url_BillingPermissionsListByInvoiceSections_564410,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByInvoiceSection_564419 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsListByInvoiceSection_564421(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsListByInvoiceSection_564420(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignments on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564422 = path.getOrDefault("billingAccountName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "billingAccountName", valid_564422
  var valid_564423 = path.getOrDefault("billingProfileName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "billingProfileName", valid_564423
  var valid_564424 = path.getOrDefault("invoiceSectionName")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "invoiceSectionName", valid_564424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564425 = query.getOrDefault("api-version")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "api-version", valid_564425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564426: Call_BillingRoleAssignmentsListByInvoiceSection_564419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the invoice Section
  ## 
  let valid = call_564426.validator(path, query, header, formData, body)
  let scheme = call_564426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564426.url(scheme.get, call_564426.host, call_564426.base,
                         call_564426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564426, url, valid)

proc call*(call_564427: Call_BillingRoleAssignmentsListByInvoiceSection_564419;
          apiVersion: string; billingAccountName: string;
          billingProfileName: string; invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsListByInvoiceSection
  ## Get the role assignments on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564428 = newJObject()
  var query_564429 = newJObject()
  add(query_564429, "api-version", newJString(apiVersion))
  add(path_564428, "billingAccountName", newJString(billingAccountName))
  add(path_564428, "billingProfileName", newJString(billingProfileName))
  add(path_564428, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564427.call(path_564428, query_564429, nil, nil, nil)

var billingRoleAssignmentsListByInvoiceSection* = Call_BillingRoleAssignmentsListByInvoiceSection_564419(
    name: "billingRoleAssignmentsListByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByInvoiceSection_564420,
    base: "", url: url_BillingRoleAssignmentsListByInvoiceSection_564421,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByInvoiceSection_564430 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsGetByInvoiceSection_564432(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsGetByInvoiceSection_564431(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignment for the caller on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564433 = path.getOrDefault("billingAccountName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "billingAccountName", valid_564433
  var valid_564434 = path.getOrDefault("billingRoleAssignmentName")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "billingRoleAssignmentName", valid_564434
  var valid_564435 = path.getOrDefault("billingProfileName")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "billingProfileName", valid_564435
  var valid_564436 = path.getOrDefault("invoiceSectionName")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "invoiceSectionName", valid_564436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564437 = query.getOrDefault("api-version")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "api-version", valid_564437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564438: Call_BillingRoleAssignmentsGetByInvoiceSection_564430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller on the invoice Section
  ## 
  let valid = call_564438.validator(path, query, header, formData, body)
  let scheme = call_564438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564438.url(scheme.get, call_564438.host, call_564438.base,
                         call_564438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564438, url, valid)

proc call*(call_564439: Call_BillingRoleAssignmentsGetByInvoiceSection_564430;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string; billingProfileName: string;
          invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsGetByInvoiceSection
  ## Get the role assignment for the caller on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564440 = newJObject()
  var query_564441 = newJObject()
  add(query_564441, "api-version", newJString(apiVersion))
  add(path_564440, "billingAccountName", newJString(billingAccountName))
  add(path_564440, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_564440, "billingProfileName", newJString(billingProfileName))
  add(path_564440, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564439.call(path_564440, query_564441, nil, nil, nil)

var billingRoleAssignmentsGetByInvoiceSection* = Call_BillingRoleAssignmentsGetByInvoiceSection_564430(
    name: "billingRoleAssignmentsGetByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByInvoiceSection_564431,
    base: "", url: url_BillingRoleAssignmentsGetByInvoiceSection_564432,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByInvoiceSection_564442 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsDeleteByInvoiceSection_564444(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsDeleteByInvoiceSection_564443(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the role assignment on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564445 = path.getOrDefault("billingAccountName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "billingAccountName", valid_564445
  var valid_564446 = path.getOrDefault("billingRoleAssignmentName")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "billingRoleAssignmentName", valid_564446
  var valid_564447 = path.getOrDefault("billingProfileName")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "billingProfileName", valid_564447
  var valid_564448 = path.getOrDefault("invoiceSectionName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "invoiceSectionName", valid_564448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564449 = query.getOrDefault("api-version")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "api-version", valid_564449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564450: Call_BillingRoleAssignmentsDeleteByInvoiceSection_564442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on the invoice Section
  ## 
  let valid = call_564450.validator(path, query, header, formData, body)
  let scheme = call_564450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564450.url(scheme.get, call_564450.host, call_564450.base,
                         call_564450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564450, url, valid)

proc call*(call_564451: Call_BillingRoleAssignmentsDeleteByInvoiceSection_564442;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string; billingProfileName: string;
          invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsDeleteByInvoiceSection
  ## Delete the role assignment on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564452 = newJObject()
  var query_564453 = newJObject()
  add(query_564453, "api-version", newJString(apiVersion))
  add(path_564452, "billingAccountName", newJString(billingAccountName))
  add(path_564452, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_564452, "billingProfileName", newJString(billingProfileName))
  add(path_564452, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564451.call(path_564452, query_564453, nil, nil, nil)

var billingRoleAssignmentsDeleteByInvoiceSection* = Call_BillingRoleAssignmentsDeleteByInvoiceSection_564442(
    name: "billingRoleAssignmentsDeleteByInvoiceSection",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByInvoiceSection_564443,
    base: "", url: url_BillingRoleAssignmentsDeleteByInvoiceSection_564444,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByInvoiceSection_564454 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsListByInvoiceSection_564456(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsListByInvoiceSection_564455(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the role definition for an invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564457 = path.getOrDefault("billingAccountName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "billingAccountName", valid_564457
  var valid_564458 = path.getOrDefault("billingProfileName")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "billingProfileName", valid_564458
  var valid_564459 = path.getOrDefault("invoiceSectionName")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "invoiceSectionName", valid_564459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564460 = query.getOrDefault("api-version")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "api-version", valid_564460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564461: Call_BillingRoleDefinitionsListByInvoiceSection_564454;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for an invoice Section
  ## 
  let valid = call_564461.validator(path, query, header, formData, body)
  let scheme = call_564461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564461.url(scheme.get, call_564461.host, call_564461.base,
                         call_564461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564461, url, valid)

proc call*(call_564462: Call_BillingRoleDefinitionsListByInvoiceSection_564454;
          apiVersion: string; billingAccountName: string;
          billingProfileName: string; invoiceSectionName: string): Recallable =
  ## billingRoleDefinitionsListByInvoiceSection
  ## Lists the role definition for an invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564463 = newJObject()
  var query_564464 = newJObject()
  add(query_564464, "api-version", newJString(apiVersion))
  add(path_564463, "billingAccountName", newJString(billingAccountName))
  add(path_564463, "billingProfileName", newJString(billingProfileName))
  add(path_564463, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564462.call(path_564463, query_564464, nil, nil, nil)

var billingRoleDefinitionsListByInvoiceSection* = Call_BillingRoleDefinitionsListByInvoiceSection_564454(
    name: "billingRoleDefinitionsListByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByInvoiceSection_564455,
    base: "", url: url_BillingRoleDefinitionsListByInvoiceSection_564456,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByInvoiceSection_564465 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsGetByInvoiceSection_564467(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsGetByInvoiceSection_564466(path: JsonNode;
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
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564468 = path.getOrDefault("billingAccountName")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "billingAccountName", valid_564468
  var valid_564469 = path.getOrDefault("billingRoleDefinitionName")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "billingRoleDefinitionName", valid_564469
  var valid_564470 = path.getOrDefault("billingProfileName")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "billingProfileName", valid_564470
  var valid_564471 = path.getOrDefault("invoiceSectionName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "invoiceSectionName", valid_564471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564472 = query.getOrDefault("api-version")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "api-version", valid_564472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564473: Call_BillingRoleDefinitionsGetByInvoiceSection_564465;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_564473.validator(path, query, header, formData, body)
  let scheme = call_564473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564473.url(scheme.get, call_564473.host, call_564473.base,
                         call_564473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564473, url, valid)

proc call*(call_564474: Call_BillingRoleDefinitionsGetByInvoiceSection_564465;
          apiVersion: string; billingAccountName: string;
          billingRoleDefinitionName: string; billingProfileName: string;
          invoiceSectionName: string): Recallable =
  ## billingRoleDefinitionsGetByInvoiceSection
  ## Gets the role definition for a role
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingRoleDefinitionName: string (required)
  ##                            : role definition id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564475 = newJObject()
  var query_564476 = newJObject()
  add(query_564476, "api-version", newJString(apiVersion))
  add(path_564475, "billingAccountName", newJString(billingAccountName))
  add(path_564475, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  add(path_564475, "billingProfileName", newJString(billingProfileName))
  add(path_564475, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564474.call(path_564475, query_564476, nil, nil, nil)

var billingRoleDefinitionsGetByInvoiceSection* = Call_BillingRoleDefinitionsGetByInvoiceSection_564465(
    name: "billingRoleDefinitionsGetByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByInvoiceSection_564466,
    base: "", url: url_BillingRoleDefinitionsGetByInvoiceSection_564467,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByInvoiceSection_564477 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsListByInvoiceSection_564479(protocol: Scheme;
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

proc validate_BillingSubscriptionsListByInvoiceSection_564478(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscription by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564480 = path.getOrDefault("billingAccountName")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "billingAccountName", valid_564480
  var valid_564481 = path.getOrDefault("billingProfileName")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "billingProfileName", valid_564481
  var valid_564482 = path.getOrDefault("invoiceSectionName")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "invoiceSectionName", valid_564482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564483 = query.getOrDefault("api-version")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "api-version", valid_564483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564484: Call_BillingSubscriptionsListByInvoiceSection_564477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscription by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564484.validator(path, query, header, formData, body)
  let scheme = call_564484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564484.url(scheme.get, call_564484.host, call_564484.base,
                         call_564484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564484, url, valid)

proc call*(call_564485: Call_BillingSubscriptionsListByInvoiceSection_564477;
          apiVersion: string; billingAccountName: string;
          billingProfileName: string; invoiceSectionName: string): Recallable =
  ## billingSubscriptionsListByInvoiceSection
  ## Lists billing subscription by invoice section name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564486 = newJObject()
  var query_564487 = newJObject()
  add(query_564487, "api-version", newJString(apiVersion))
  add(path_564486, "billingAccountName", newJString(billingAccountName))
  add(path_564486, "billingProfileName", newJString(billingProfileName))
  add(path_564486, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564485.call(path_564486, query_564487, nil, nil, nil)

var billingSubscriptionsListByInvoiceSection* = Call_BillingSubscriptionsListByInvoiceSection_564477(
    name: "billingSubscriptionsListByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByInvoiceSection_564478, base: "",
    url: url_BillingSubscriptionsListByInvoiceSection_564479,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsGet_564488 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsGet_564490(protocol: Scheme; host: string; base: string;
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

proc validate_BillingSubscriptionsGet_564489(path: JsonNode; query: JsonNode;
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
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564491 = path.getOrDefault("billingAccountName")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "billingAccountName", valid_564491
  var valid_564492 = path.getOrDefault("billingSubscriptionName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "billingSubscriptionName", valid_564492
  var valid_564493 = path.getOrDefault("billingProfileName")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "billingProfileName", valid_564493
  var valid_564494 = path.getOrDefault("invoiceSectionName")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "invoiceSectionName", valid_564494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564495 = query.getOrDefault("api-version")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "api-version", valid_564495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564496: Call_BillingSubscriptionsGet_564488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564496.validator(path, query, header, formData, body)
  let scheme = call_564496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564496.url(scheme.get, call_564496.host, call_564496.base,
                         call_564496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564496, url, valid)

proc call*(call_564497: Call_BillingSubscriptionsGet_564488; apiVersion: string;
          billingAccountName: string; billingSubscriptionName: string;
          billingProfileName: string; invoiceSectionName: string): Recallable =
  ## billingSubscriptionsGet
  ## Get a single billing subscription by name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564498 = newJObject()
  var query_564499 = newJObject()
  add(query_564499, "api-version", newJString(apiVersion))
  add(path_564498, "billingAccountName", newJString(billingAccountName))
  add(path_564498, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_564498, "billingProfileName", newJString(billingProfileName))
  add(path_564498, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564497.call(path_564498, query_564499, nil, nil, nil)

var billingSubscriptionsGet* = Call_BillingSubscriptionsGet_564488(
    name: "billingSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}",
    validator: validate_BillingSubscriptionsGet_564489, base: "",
    url: url_BillingSubscriptionsGet_564490, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsTransfer_564500 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsTransfer_564502(protocol: Scheme; host: string;
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

proc validate_BillingSubscriptionsTransfer_564501(path: JsonNode; query: JsonNode;
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
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564503 = path.getOrDefault("billingAccountName")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "billingAccountName", valid_564503
  var valid_564504 = path.getOrDefault("billingSubscriptionName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "billingSubscriptionName", valid_564504
  var valid_564505 = path.getOrDefault("billingProfileName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "billingProfileName", valid_564505
  var valid_564506 = path.getOrDefault("invoiceSectionName")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "invoiceSectionName", valid_564506
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

proc call*(call_564508: Call_BillingSubscriptionsTransfer_564500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Transfers the subscription from one invoice section to another within a billing account.
  ## 
  let valid = call_564508.validator(path, query, header, formData, body)
  let scheme = call_564508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564508.url(scheme.get, call_564508.host, call_564508.base,
                         call_564508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564508, url, valid)

proc call*(call_564509: Call_BillingSubscriptionsTransfer_564500;
          billingAccountName: string; billingSubscriptionName: string;
          billingProfileName: string; parameters: JsonNode;
          invoiceSectionName: string): Recallable =
  ## billingSubscriptionsTransfer
  ## Transfers the subscription from one invoice section to another within a billing account.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Request parameters supplied to the Transfer Billing Subscription operation.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564510 = newJObject()
  var body_564511 = newJObject()
  add(path_564510, "billingAccountName", newJString(billingAccountName))
  add(path_564510, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_564510, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564511 = parameters
  add(path_564510, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564509.call(path_564510, nil, nil, nil, body_564511)

var billingSubscriptionsTransfer* = Call_BillingSubscriptionsTransfer_564500(
    name: "billingSubscriptionsTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}/transfer",
    validator: validate_BillingSubscriptionsTransfer_564501, base: "",
    url: url_BillingSubscriptionsTransfer_564502, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsValidateTransfer_564512 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsValidateTransfer_564514(protocol: Scheme;
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

proc validate_BillingSubscriptionsValidateTransfer_564513(path: JsonNode;
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
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564515 = path.getOrDefault("billingAccountName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "billingAccountName", valid_564515
  var valid_564516 = path.getOrDefault("billingSubscriptionName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "billingSubscriptionName", valid_564516
  var valid_564517 = path.getOrDefault("billingProfileName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "billingProfileName", valid_564517
  var valid_564518 = path.getOrDefault("invoiceSectionName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "invoiceSectionName", valid_564518
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

proc call*(call_564520: Call_BillingSubscriptionsValidateTransfer_564512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates the transfer of billing subscriptions across invoice sections.
  ## 
  let valid = call_564520.validator(path, query, header, formData, body)
  let scheme = call_564520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564520.url(scheme.get, call_564520.host, call_564520.base,
                         call_564520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564520, url, valid)

proc call*(call_564521: Call_BillingSubscriptionsValidateTransfer_564512;
          billingAccountName: string; billingSubscriptionName: string;
          billingProfileName: string; parameters: JsonNode;
          invoiceSectionName: string): Recallable =
  ## billingSubscriptionsValidateTransfer
  ## Validates the transfer of billing subscriptions across invoice sections.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564522 = newJObject()
  var body_564523 = newJObject()
  add(path_564522, "billingAccountName", newJString(billingAccountName))
  add(path_564522, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_564522, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564523 = parameters
  add(path_564522, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564521.call(path_564522, nil, nil, nil, body_564523)

var billingSubscriptionsValidateTransfer* = Call_BillingSubscriptionsValidateTransfer_564512(
    name: "billingSubscriptionsValidateTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}/validateTransferEligibility",
    validator: validate_BillingSubscriptionsValidateTransfer_564513, base: "",
    url: url_BillingSubscriptionsValidateTransfer_564514, schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByInvoiceSection_564524 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsAddByInvoiceSection_564526(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsAddByInvoiceSection_564525(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to add a role assignment to a invoice Section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564527 = path.getOrDefault("billingAccountName")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "billingAccountName", valid_564527
  var valid_564528 = path.getOrDefault("billingProfileName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "billingProfileName", valid_564528
  var valid_564529 = path.getOrDefault("invoiceSectionName")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "invoiceSectionName", valid_564529
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564530 = query.getOrDefault("api-version")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "api-version", valid_564530
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

proc call*(call_564532: Call_BillingRoleAssignmentsAddByInvoiceSection_564524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a invoice Section.
  ## 
  let valid = call_564532.validator(path, query, header, formData, body)
  let scheme = call_564532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564532.url(scheme.get, call_564532.host, call_564532.base,
                         call_564532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564532, url, valid)

proc call*(call_564533: Call_BillingRoleAssignmentsAddByInvoiceSection_564524;
          apiVersion: string; billingAccountName: string;
          billingProfileName: string; parameters: JsonNode;
          invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsAddByInvoiceSection
  ## The operation to add a role assignment to a invoice Section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564534 = newJObject()
  var query_564535 = newJObject()
  var body_564536 = newJObject()
  add(query_564535, "api-version", newJString(apiVersion))
  add(path_564534, "billingAccountName", newJString(billingAccountName))
  add(path_564534, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564536 = parameters
  add(path_564534, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564533.call(path_564534, query_564535, nil, nil, body_564536)

var billingRoleAssignmentsAddByInvoiceSection* = Call_BillingRoleAssignmentsAddByInvoiceSection_564524(
    name: "billingRoleAssignmentsAddByInvoiceSection", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByInvoiceSection_564525,
    base: "", url: url_BillingRoleAssignmentsAddByInvoiceSection_564526,
    schemes: {Scheme.Https})
type
  Call_InvoiceSectionsElevateToBillingProfile_564537 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsElevateToBillingProfile_564539(protocol: Scheme;
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

proc validate_InvoiceSectionsElevateToBillingProfile_564538(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Elevates the caller's access to match their billing profile access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564540 = path.getOrDefault("billingAccountName")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "billingAccountName", valid_564540
  var valid_564541 = path.getOrDefault("billingProfileName")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "billingProfileName", valid_564541
  var valid_564542 = path.getOrDefault("invoiceSectionName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "invoiceSectionName", valid_564542
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564543: Call_InvoiceSectionsElevateToBillingProfile_564537;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Elevates the caller's access to match their billing profile access.
  ## 
  let valid = call_564543.validator(path, query, header, formData, body)
  let scheme = call_564543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564543.url(scheme.get, call_564543.host, call_564543.base,
                         call_564543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564543, url, valid)

proc call*(call_564544: Call_InvoiceSectionsElevateToBillingProfile_564537;
          billingAccountName: string; billingProfileName: string;
          invoiceSectionName: string): Recallable =
  ## invoiceSectionsElevateToBillingProfile
  ## Elevates the caller's access to match their billing profile access.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564545 = newJObject()
  add(path_564545, "billingAccountName", newJString(billingAccountName))
  add(path_564545, "billingProfileName", newJString(billingProfileName))
  add(path_564545, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564544.call(path_564545, nil, nil, nil, nil)

var invoiceSectionsElevateToBillingProfile* = Call_InvoiceSectionsElevateToBillingProfile_564537(
    name: "invoiceSectionsElevateToBillingProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/elevate",
    validator: validate_InvoiceSectionsElevateToBillingProfile_564538, base: "",
    url: url_InvoiceSectionsElevateToBillingProfile_564539,
    schemes: {Scheme.Https})
type
  Call_TransfersInitiate_564546 = ref object of OpenApiRestCall_563565
proc url_TransfersInitiate_564548(protocol: Scheme; host: string; base: string;
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

proc validate_TransfersInitiate_564547(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564549 = path.getOrDefault("billingAccountName")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "billingAccountName", valid_564549
  var valid_564550 = path.getOrDefault("billingProfileName")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "billingProfileName", valid_564550
  var valid_564551 = path.getOrDefault("invoiceSectionName")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "invoiceSectionName", valid_564551
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

proc call*(call_564553: Call_TransfersInitiate_564546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  let valid = call_564553.validator(path, query, header, formData, body)
  let scheme = call_564553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564553.url(scheme.get, call_564553.host, call_564553.base,
                         call_564553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564553, url, valid)

proc call*(call_564554: Call_TransfersInitiate_564546; billingAccountName: string;
          billingProfileName: string; parameters: JsonNode;
          invoiceSectionName: string): Recallable =
  ## transfersInitiate
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to initiate the transfer.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564555 = newJObject()
  var body_564556 = newJObject()
  add(path_564555, "billingAccountName", newJString(billingAccountName))
  add(path_564555, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564556 = parameters
  add(path_564555, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564554.call(path_564555, nil, nil, nil, body_564556)

var transfersInitiate* = Call_TransfersInitiate_564546(name: "transfersInitiate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/initiateTransfer",
    validator: validate_TransfersInitiate_564547, base: "",
    url: url_TransfersInitiate_564548, schemes: {Scheme.Https})
type
  Call_ProductsListByInvoiceSection_564557 = ref object of OpenApiRestCall_563565
proc url_ProductsListByInvoiceSection_564559(protocol: Scheme; host: string;
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

proc validate_ProductsListByInvoiceSection_564558(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists products by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564560 = path.getOrDefault("billingAccountName")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "billingAccountName", valid_564560
  var valid_564561 = path.getOrDefault("billingProfileName")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "billingProfileName", valid_564561
  var valid_564562 = path.getOrDefault("invoiceSectionName")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "invoiceSectionName", valid_564562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564563 = query.getOrDefault("api-version")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "api-version", valid_564563
  var valid_564564 = query.getOrDefault("$filter")
  valid_564564 = validateParameter(valid_564564, JString, required = false,
                                 default = nil)
  if valid_564564 != nil:
    section.add "$filter", valid_564564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564565: Call_ProductsListByInvoiceSection_564557; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists products by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564565.validator(path, query, header, formData, body)
  let scheme = call_564565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564565.url(scheme.get, call_564565.host, call_564565.base,
                         call_564565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564565, url, valid)

proc call*(call_564566: Call_ProductsListByInvoiceSection_564557;
          apiVersion: string; billingAccountName: string;
          billingProfileName: string; invoiceSectionName: string;
          Filter: string = ""): Recallable =
  ## productsListByInvoiceSection
  ## Lists products by invoice section name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Filter: string
  ##         : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564567 = newJObject()
  var query_564568 = newJObject()
  add(query_564568, "api-version", newJString(apiVersion))
  add(path_564567, "billingAccountName", newJString(billingAccountName))
  add(query_564568, "$filter", newJString(Filter))
  add(path_564567, "billingProfileName", newJString(billingProfileName))
  add(path_564567, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564566.call(path_564567, query_564568, nil, nil, nil)

var productsListByInvoiceSection* = Call_ProductsListByInvoiceSection_564557(
    name: "productsListByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/products",
    validator: validate_ProductsListByInvoiceSection_564558, base: "",
    url: url_ProductsListByInvoiceSection_564559, schemes: {Scheme.Https})
type
  Call_ProductsGet_564569 = ref object of OpenApiRestCall_563565
proc url_ProductsGet_564571(protocol: Scheme; host: string; base: string;
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

proc validate_ProductsGet_564570(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564572 = path.getOrDefault("billingAccountName")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "billingAccountName", valid_564572
  var valid_564573 = path.getOrDefault("productName")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "productName", valid_564573
  var valid_564574 = path.getOrDefault("billingProfileName")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "billingProfileName", valid_564574
  var valid_564575 = path.getOrDefault("invoiceSectionName")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "invoiceSectionName", valid_564575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564576 = query.getOrDefault("api-version")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "api-version", valid_564576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564577: Call_ProductsGet_564569; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564577.validator(path, query, header, formData, body)
  let scheme = call_564577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564577.url(scheme.get, call_564577.host, call_564577.base,
                         call_564577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564577, url, valid)

proc call*(call_564578: Call_ProductsGet_564569; apiVersion: string;
          billingAccountName: string; productName: string;
          billingProfileName: string; invoiceSectionName: string): Recallable =
  ## productsGet
  ## Get a single product by name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564579 = newJObject()
  var query_564580 = newJObject()
  add(query_564580, "api-version", newJString(apiVersion))
  add(path_564579, "billingAccountName", newJString(billingAccountName))
  add(path_564579, "productName", newJString(productName))
  add(path_564579, "billingProfileName", newJString(billingProfileName))
  add(path_564579, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564578.call(path_564579, query_564580, nil, nil, nil)

var productsGet* = Call_ProductsGet_564569(name: "productsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/products/{productName}",
                                        validator: validate_ProductsGet_564570,
                                        base: "", url: url_ProductsGet_564571,
                                        schemes: {Scheme.Https})
type
  Call_ProductsTransfer_564581 = ref object of OpenApiRestCall_563565
proc url_ProductsTransfer_564583(protocol: Scheme; host: string; base: string;
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

proc validate_ProductsTransfer_564582(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The operation to transfer a Product to another invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564584 = path.getOrDefault("billingAccountName")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "billingAccountName", valid_564584
  var valid_564585 = path.getOrDefault("productName")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "productName", valid_564585
  var valid_564586 = path.getOrDefault("billingProfileName")
  valid_564586 = validateParameter(valid_564586, JString, required = true,
                                 default = nil)
  if valid_564586 != nil:
    section.add "billingProfileName", valid_564586
  var valid_564587 = path.getOrDefault("invoiceSectionName")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "invoiceSectionName", valid_564587
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564588 = query.getOrDefault("api-version")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "api-version", valid_564588
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

proc call*(call_564590: Call_ProductsTransfer_564581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to transfer a Product to another invoice section.
  ## 
  let valid = call_564590.validator(path, query, header, formData, body)
  let scheme = call_564590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564590.url(scheme.get, call_564590.host, call_564590.base,
                         call_564590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564590, url, valid)

proc call*(call_564591: Call_ProductsTransfer_564581; apiVersion: string;
          billingAccountName: string; productName: string;
          billingProfileName: string; parameters: JsonNode;
          invoiceSectionName: string): Recallable =
  ## productsTransfer
  ## The operation to transfer a Product to another invoice section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Product operation.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564592 = newJObject()
  var query_564593 = newJObject()
  var body_564594 = newJObject()
  add(query_564593, "api-version", newJString(apiVersion))
  add(path_564592, "billingAccountName", newJString(billingAccountName))
  add(path_564592, "productName", newJString(productName))
  add(path_564592, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564594 = parameters
  add(path_564592, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564591.call(path_564592, query_564593, nil, nil, body_564594)

var productsTransfer* = Call_ProductsTransfer_564581(name: "productsTransfer",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/products/{productName}/transfer",
    validator: validate_ProductsTransfer_564582, base: "",
    url: url_ProductsTransfer_564583, schemes: {Scheme.Https})
type
  Call_ProductsUpdateAutoRenewByInvoiceSection_564595 = ref object of OpenApiRestCall_563565
proc url_ProductsUpdateAutoRenewByInvoiceSection_564597(protocol: Scheme;
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

proc validate_ProductsUpdateAutoRenewByInvoiceSection_564596(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel auto renew for product by product id and invoice section name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564598 = path.getOrDefault("billingAccountName")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "billingAccountName", valid_564598
  var valid_564599 = path.getOrDefault("productName")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "productName", valid_564599
  var valid_564600 = path.getOrDefault("billingProfileName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "billingProfileName", valid_564600
  var valid_564601 = path.getOrDefault("invoiceSectionName")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "invoiceSectionName", valid_564601
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564602 = query.getOrDefault("api-version")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = nil)
  if valid_564602 != nil:
    section.add "api-version", valid_564602
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

proc call*(call_564604: Call_ProductsUpdateAutoRenewByInvoiceSection_564595;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancel auto renew for product by product id and invoice section name
  ## 
  let valid = call_564604.validator(path, query, header, formData, body)
  let scheme = call_564604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564604.url(scheme.get, call_564604.host, call_564604.base,
                         call_564604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564604, url, valid)

proc call*(call_564605: Call_ProductsUpdateAutoRenewByInvoiceSection_564595;
          apiVersion: string; billingAccountName: string; productName: string;
          body: JsonNode; billingProfileName: string; invoiceSectionName: string): Recallable =
  ## productsUpdateAutoRenewByInvoiceSection
  ## Cancel auto renew for product by product id and invoice section name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564606 = newJObject()
  var query_564607 = newJObject()
  var body_564608 = newJObject()
  add(query_564607, "api-version", newJString(apiVersion))
  add(path_564606, "billingAccountName", newJString(billingAccountName))
  add(path_564606, "productName", newJString(productName))
  if body != nil:
    body_564608 = body
  add(path_564606, "billingProfileName", newJString(billingProfileName))
  add(path_564606, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564605.call(path_564606, query_564607, nil, nil, body_564608)

var productsUpdateAutoRenewByInvoiceSection* = Call_ProductsUpdateAutoRenewByInvoiceSection_564595(
    name: "productsUpdateAutoRenewByInvoiceSection", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/products/{productName}/updateAutoRenew",
    validator: validate_ProductsUpdateAutoRenewByInvoiceSection_564596, base: "",
    url: url_ProductsUpdateAutoRenewByInvoiceSection_564597,
    schemes: {Scheme.Https})
type
  Call_ProductsValidateTransfer_564609 = ref object of OpenApiRestCall_563565
proc url_ProductsValidateTransfer_564611(protocol: Scheme; host: string;
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

proc validate_ProductsValidateTransfer_564610(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the transfer of products across invoice sections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564612 = path.getOrDefault("billingAccountName")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "billingAccountName", valid_564612
  var valid_564613 = path.getOrDefault("productName")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "productName", valid_564613
  var valid_564614 = path.getOrDefault("billingProfileName")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "billingProfileName", valid_564614
  var valid_564615 = path.getOrDefault("invoiceSectionName")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "invoiceSectionName", valid_564615
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

proc call*(call_564617: Call_ProductsValidateTransfer_564609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the transfer of products across invoice sections.
  ## 
  let valid = call_564617.validator(path, query, header, formData, body)
  let scheme = call_564617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564617.url(scheme.get, call_564617.host, call_564617.base,
                         call_564617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564617, url, valid)

proc call*(call_564618: Call_ProductsValidateTransfer_564609;
          billingAccountName: string; productName: string;
          billingProfileName: string; parameters: JsonNode;
          invoiceSectionName: string): Recallable =
  ## productsValidateTransfer
  ## Validates the transfer of products across invoice sections.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Products operation.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564619 = newJObject()
  var body_564620 = newJObject()
  add(path_564619, "billingAccountName", newJString(billingAccountName))
  add(path_564619, "productName", newJString(productName))
  add(path_564619, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564620 = parameters
  add(path_564619, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564618.call(path_564619, nil, nil, nil, body_564620)

var productsValidateTransfer* = Call_ProductsValidateTransfer_564609(
    name: "productsValidateTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/products/{productName}/validateTransferEligibility",
    validator: validate_ProductsValidateTransfer_564610, base: "",
    url: url_ProductsValidateTransfer_564611, schemes: {Scheme.Https})
type
  Call_TransactionsListByInvoiceSection_564621 = ref object of OpenApiRestCall_563565
proc url_TransactionsListByInvoiceSection_564623(protocol: Scheme; host: string;
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

proc validate_TransactionsListByInvoiceSection_564622(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564624 = path.getOrDefault("billingAccountName")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "billingAccountName", valid_564624
  var valid_564625 = path.getOrDefault("billingProfileName")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "billingProfileName", valid_564625
  var valid_564626 = path.getOrDefault("invoiceSectionName")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "invoiceSectionName", valid_564626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564627 = query.getOrDefault("api-version")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = nil)
  if valid_564627 != nil:
    section.add "api-version", valid_564627
  var valid_564628 = query.getOrDefault("endDate")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "endDate", valid_564628
  var valid_564629 = query.getOrDefault("$filter")
  valid_564629 = validateParameter(valid_564629, JString, required = false,
                                 default = nil)
  if valid_564629 != nil:
    section.add "$filter", valid_564629
  var valid_564630 = query.getOrDefault("startDate")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "startDate", valid_564630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564631: Call_TransactionsListByInvoiceSection_564621;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564631.validator(path, query, header, formData, body)
  let scheme = call_564631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564631.url(scheme.get, call_564631.host, call_564631.base,
                         call_564631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564631, url, valid)

proc call*(call_564632: Call_TransactionsListByInvoiceSection_564621;
          apiVersion: string; billingAccountName: string; endDate: string;
          startDate: string; billingProfileName: string; invoiceSectionName: string;
          Filter: string = ""): Recallable =
  ## transactionsListByInvoiceSection
  ## Lists the transactions by invoice section name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   endDate: string (required)
  ##          : End date
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: string (required)
  ##            : Start date
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564633 = newJObject()
  var query_564634 = newJObject()
  add(query_564634, "api-version", newJString(apiVersion))
  add(path_564633, "billingAccountName", newJString(billingAccountName))
  add(query_564634, "endDate", newJString(endDate))
  add(query_564634, "$filter", newJString(Filter))
  add(query_564634, "startDate", newJString(startDate))
  add(path_564633, "billingProfileName", newJString(billingProfileName))
  add(path_564633, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564632.call(path_564633, query_564634, nil, nil, nil)

var transactionsListByInvoiceSection* = Call_TransactionsListByInvoiceSection_564621(
    name: "transactionsListByInvoiceSection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/transactions",
    validator: validate_TransactionsListByInvoiceSection_564622, base: "",
    url: url_TransactionsListByInvoiceSection_564623, schemes: {Scheme.Https})
type
  Call_TransfersList_564635 = ref object of OpenApiRestCall_563565
proc url_TransfersList_564637(protocol: Scheme; host: string; base: string;
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

proc validate_TransfersList_564636(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564638 = path.getOrDefault("billingAccountName")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "billingAccountName", valid_564638
  var valid_564639 = path.getOrDefault("billingProfileName")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "billingProfileName", valid_564639
  var valid_564640 = path.getOrDefault("invoiceSectionName")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "invoiceSectionName", valid_564640
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564641: Call_TransfersList_564635; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  let valid = call_564641.validator(path, query, header, formData, body)
  let scheme = call_564641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564641.url(scheme.get, call_564641.host, call_564641.base,
                         call_564641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564641, url, valid)

proc call*(call_564642: Call_TransfersList_564635; billingAccountName: string;
          billingProfileName: string; invoiceSectionName: string): Recallable =
  ## transfersList
  ## Lists all transfer's details initiated from given invoice section.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564643 = newJObject()
  add(path_564643, "billingAccountName", newJString(billingAccountName))
  add(path_564643, "billingProfileName", newJString(billingProfileName))
  add(path_564643, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564642.call(path_564643, nil, nil, nil, nil)

var transfersList* = Call_TransfersList_564635(name: "transfersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/transfers",
    validator: validate_TransfersList_564636, base: "", url: url_TransfersList_564637,
    schemes: {Scheme.Https})
type
  Call_TransfersGet_564644 = ref object of OpenApiRestCall_563565
proc url_TransfersGet_564646(protocol: Scheme; host: string; base: string;
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

proc validate_TransfersGet_564645(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the transfer details for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_564647 = path.getOrDefault("transferName")
  valid_564647 = validateParameter(valid_564647, JString, required = true,
                                 default = nil)
  if valid_564647 != nil:
    section.add "transferName", valid_564647
  var valid_564648 = path.getOrDefault("billingAccountName")
  valid_564648 = validateParameter(valid_564648, JString, required = true,
                                 default = nil)
  if valid_564648 != nil:
    section.add "billingAccountName", valid_564648
  var valid_564649 = path.getOrDefault("billingProfileName")
  valid_564649 = validateParameter(valid_564649, JString, required = true,
                                 default = nil)
  if valid_564649 != nil:
    section.add "billingProfileName", valid_564649
  var valid_564650 = path.getOrDefault("invoiceSectionName")
  valid_564650 = validateParameter(valid_564650, JString, required = true,
                                 default = nil)
  if valid_564650 != nil:
    section.add "invoiceSectionName", valid_564650
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564651: Call_TransfersGet_564644; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the transfer details for given transfer Id.
  ## 
  let valid = call_564651.validator(path, query, header, formData, body)
  let scheme = call_564651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564651.url(scheme.get, call_564651.host, call_564651.base,
                         call_564651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564651, url, valid)

proc call*(call_564652: Call_TransfersGet_564644; transferName: string;
          billingAccountName: string; billingProfileName: string;
          invoiceSectionName: string): Recallable =
  ## transfersGet
  ## Gets the transfer details for given transfer Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564653 = newJObject()
  add(path_564653, "transferName", newJString(transferName))
  add(path_564653, "billingAccountName", newJString(billingAccountName))
  add(path_564653, "billingProfileName", newJString(billingProfileName))
  add(path_564653, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564652.call(path_564653, nil, nil, nil, nil)

var transfersGet* = Call_TransfersGet_564644(name: "transfersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/transfers/{transferName}",
    validator: validate_TransfersGet_564645, base: "", url: url_TransfersGet_564646,
    schemes: {Scheme.Https})
type
  Call_TransfersCancel_564654 = ref object of OpenApiRestCall_563565
proc url_TransfersCancel_564656(protocol: Scheme; host: string; base: string;
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

proc validate_TransfersCancel_564655(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Cancels the transfer for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_564657 = path.getOrDefault("transferName")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "transferName", valid_564657
  var valid_564658 = path.getOrDefault("billingAccountName")
  valid_564658 = validateParameter(valid_564658, JString, required = true,
                                 default = nil)
  if valid_564658 != nil:
    section.add "billingAccountName", valid_564658
  var valid_564659 = path.getOrDefault("billingProfileName")
  valid_564659 = validateParameter(valid_564659, JString, required = true,
                                 default = nil)
  if valid_564659 != nil:
    section.add "billingProfileName", valid_564659
  var valid_564660 = path.getOrDefault("invoiceSectionName")
  valid_564660 = validateParameter(valid_564660, JString, required = true,
                                 default = nil)
  if valid_564660 != nil:
    section.add "invoiceSectionName", valid_564660
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564661: Call_TransfersCancel_564654; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the transfer for given transfer Id.
  ## 
  let valid = call_564661.validator(path, query, header, formData, body)
  let scheme = call_564661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564661.url(scheme.get, call_564661.host, call_564661.base,
                         call_564661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564661, url, valid)

proc call*(call_564662: Call_TransfersCancel_564654; transferName: string;
          billingAccountName: string; billingProfileName: string;
          invoiceSectionName: string): Recallable =
  ## transfersCancel
  ## Cancels the transfer for given transfer Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564663 = newJObject()
  add(path_564663, "transferName", newJString(transferName))
  add(path_564663, "billingAccountName", newJString(billingAccountName))
  add(path_564663, "billingProfileName", newJString(billingProfileName))
  add(path_564663, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564662.call(path_564663, nil, nil, nil, nil)

var transfersCancel* = Call_TransfersCancel_564654(name: "transfersCancel",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}/transfers/{transferName}",
    validator: validate_TransfersCancel_564655, base: "", url: url_TransfersCancel_564656,
    schemes: {Scheme.Https})
type
  Call_InvoicesListByBillingProfile_564664 = ref object of OpenApiRestCall_563565
proc url_InvoicesListByBillingProfile_564666(protocol: Scheme; host: string;
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

proc validate_InvoicesListByBillingProfile_564665(path: JsonNode; query: JsonNode;
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
  var valid_564667 = path.getOrDefault("billingAccountName")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "billingAccountName", valid_564667
  var valid_564668 = path.getOrDefault("billingProfileName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "billingProfileName", valid_564668
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
  var valid_564669 = query.getOrDefault("api-version")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "api-version", valid_564669
  var valid_564670 = query.getOrDefault("periodEndDate")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "periodEndDate", valid_564670
  var valid_564671 = query.getOrDefault("periodStartDate")
  valid_564671 = validateParameter(valid_564671, JString, required = true,
                                 default = nil)
  if valid_564671 != nil:
    section.add "periodStartDate", valid_564671
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564672: Call_InvoicesListByBillingProfile_564664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of invoices for a billing profile.
  ## 
  let valid = call_564672.validator(path, query, header, formData, body)
  let scheme = call_564672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564672.url(scheme.get, call_564672.host, call_564672.base,
                         call_564672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564672, url, valid)

proc call*(call_564673: Call_InvoicesListByBillingProfile_564664;
          apiVersion: string; billingAccountName: string; periodEndDate: string;
          billingProfileName: string; periodStartDate: string): Recallable =
  ## invoicesListByBillingProfile
  ## List of invoices for a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   periodEndDate: string (required)
  ##                : Invoice period end date.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   periodStartDate: string (required)
  ##                  : Invoice period start date.
  var path_564674 = newJObject()
  var query_564675 = newJObject()
  add(query_564675, "api-version", newJString(apiVersion))
  add(path_564674, "billingAccountName", newJString(billingAccountName))
  add(query_564675, "periodEndDate", newJString(periodEndDate))
  add(path_564674, "billingProfileName", newJString(billingProfileName))
  add(query_564675, "periodStartDate", newJString(periodStartDate))
  result = call_564673.call(path_564674, query_564675, nil, nil, nil)

var invoicesListByBillingProfile* = Call_InvoicesListByBillingProfile_564664(
    name: "invoicesListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices",
    validator: validate_InvoicesListByBillingProfile_564665, base: "",
    url: url_InvoicesListByBillingProfile_564666, schemes: {Scheme.Https})
type
  Call_InvoicesGet_564676 = ref object of OpenApiRestCall_563565
proc url_InvoicesGet_564678(protocol: Scheme; host: string; base: string;
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

proc validate_InvoicesGet_564677(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564679 = path.getOrDefault("billingAccountName")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "billingAccountName", valid_564679
  var valid_564680 = path.getOrDefault("invoiceName")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "invoiceName", valid_564680
  var valid_564681 = path.getOrDefault("billingProfileName")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "billingProfileName", valid_564681
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564682 = query.getOrDefault("api-version")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "api-version", valid_564682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564683: Call_InvoicesGet_564676; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the invoice by name.
  ## 
  let valid = call_564683.validator(path, query, header, formData, body)
  let scheme = call_564683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564683.url(scheme.get, call_564683.host, call_564683.base,
                         call_564683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564683, url, valid)

proc call*(call_564684: Call_InvoicesGet_564676; apiVersion: string;
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
  var path_564685 = newJObject()
  var query_564686 = newJObject()
  add(query_564686, "api-version", newJString(apiVersion))
  add(path_564685, "billingAccountName", newJString(billingAccountName))
  add(path_564685, "invoiceName", newJString(invoiceName))
  add(path_564685, "billingProfileName", newJString(billingProfileName))
  result = call_564684.call(path_564685, query_564686, nil, nil, nil)

var invoicesGet* = Call_InvoicesGet_564676(name: "invoicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices/{invoiceName}",
                                        validator: validate_InvoicesGet_564677,
                                        base: "", url: url_InvoicesGet_564678,
                                        schemes: {Scheme.Https})
type
  Call_PriceSheetDownload_564687 = ref object of OpenApiRestCall_563565
proc url_PriceSheetDownload_564689(protocol: Scheme; host: string; base: string;
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

proc validate_PriceSheetDownload_564688(path: JsonNode; query: JsonNode;
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
  var valid_564690 = path.getOrDefault("billingAccountName")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = nil)
  if valid_564690 != nil:
    section.add "billingAccountName", valid_564690
  var valid_564691 = path.getOrDefault("invoiceName")
  valid_564691 = validateParameter(valid_564691, JString, required = true,
                                 default = nil)
  if valid_564691 != nil:
    section.add "invoiceName", valid_564691
  var valid_564692 = path.getOrDefault("billingProfileName")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "billingProfileName", valid_564692
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564693 = query.getOrDefault("api-version")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "api-version", valid_564693
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564694: Call_PriceSheetDownload_564687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Download price sheet for an invoice.
  ## 
  let valid = call_564694.validator(path, query, header, formData, body)
  let scheme = call_564694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564694.url(scheme.get, call_564694.host, call_564694.base,
                         call_564694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564694, url, valid)

proc call*(call_564695: Call_PriceSheetDownload_564687; apiVersion: string;
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
  var path_564696 = newJObject()
  var query_564697 = newJObject()
  add(query_564697, "api-version", newJString(apiVersion))
  add(path_564696, "billingAccountName", newJString(billingAccountName))
  add(path_564696, "invoiceName", newJString(invoiceName))
  add(path_564696, "billingProfileName", newJString(billingProfileName))
  result = call_564695.call(path_564696, query_564697, nil, nil, nil)

var priceSheetDownload* = Call_PriceSheetDownload_564687(
    name: "priceSheetDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices/{invoiceName}/pricesheet/default/download",
    validator: validate_PriceSheetDownload_564688, base: "",
    url: url_PriceSheetDownload_564689, schemes: {Scheme.Https})
type
  Call_PaymentMethodsListByBillingProfile_564698 = ref object of OpenApiRestCall_563565
proc url_PaymentMethodsListByBillingProfile_564700(protocol: Scheme; host: string;
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

proc validate_PaymentMethodsListByBillingProfile_564699(path: JsonNode;
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
  var valid_564701 = path.getOrDefault("billingAccountName")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = nil)
  if valid_564701 != nil:
    section.add "billingAccountName", valid_564701
  var valid_564702 = path.getOrDefault("billingProfileName")
  valid_564702 = validateParameter(valid_564702, JString, required = true,
                                 default = nil)
  if valid_564702 != nil:
    section.add "billingProfileName", valid_564702
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564703 = query.getOrDefault("api-version")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "api-version", valid_564703
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564704: Call_PaymentMethodsListByBillingProfile_564698;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Payment Methods by billing profile Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564704.validator(path, query, header, formData, body)
  let scheme = call_564704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564704.url(scheme.get, call_564704.host, call_564704.base,
                         call_564704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564704, url, valid)

proc call*(call_564705: Call_PaymentMethodsListByBillingProfile_564698;
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
  var path_564706 = newJObject()
  var query_564707 = newJObject()
  add(query_564707, "api-version", newJString(apiVersion))
  add(path_564706, "billingAccountName", newJString(billingAccountName))
  add(path_564706, "billingProfileName", newJString(billingProfileName))
  result = call_564705.call(path_564706, query_564707, nil, nil, nil)

var paymentMethodsListByBillingProfile* = Call_PaymentMethodsListByBillingProfile_564698(
    name: "paymentMethodsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/paymentMethods",
    validator: validate_PaymentMethodsListByBillingProfile_564699, base: "",
    url: url_PaymentMethodsListByBillingProfile_564700, schemes: {Scheme.Https})
type
  Call_PoliciesUpdate_564718 = ref object of OpenApiRestCall_563565
proc url_PoliciesUpdate_564720(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesUpdate_564719(path: JsonNode; query: JsonNode;
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
  var valid_564721 = path.getOrDefault("billingAccountName")
  valid_564721 = validateParameter(valid_564721, JString, required = true,
                                 default = nil)
  if valid_564721 != nil:
    section.add "billingAccountName", valid_564721
  var valid_564722 = path.getOrDefault("billingProfileName")
  valid_564722 = validateParameter(valid_564722, JString, required = true,
                                 default = nil)
  if valid_564722 != nil:
    section.add "billingProfileName", valid_564722
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564723 = query.getOrDefault("api-version")
  valid_564723 = validateParameter(valid_564723, JString, required = true,
                                 default = nil)
  if valid_564723 != nil:
    section.add "api-version", valid_564723
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

proc call*(call_564725: Call_PoliciesUpdate_564718; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a policy.
  ## 
  let valid = call_564725.validator(path, query, header, formData, body)
  let scheme = call_564725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564725.url(scheme.get, call_564725.host, call_564725.base,
                         call_564725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564725, url, valid)

proc call*(call_564726: Call_PoliciesUpdate_564718; apiVersion: string;
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
  var path_564727 = newJObject()
  var query_564728 = newJObject()
  var body_564729 = newJObject()
  add(query_564728, "api-version", newJString(apiVersion))
  add(path_564727, "billingAccountName", newJString(billingAccountName))
  add(path_564727, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564729 = parameters
  result = call_564726.call(path_564727, query_564728, nil, nil, body_564729)

var policiesUpdate* = Call_PoliciesUpdate_564718(name: "policiesUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/policies/default",
    validator: validate_PoliciesUpdate_564719, base: "", url: url_PoliciesUpdate_564720,
    schemes: {Scheme.Https})
type
  Call_PoliciesGetByBillingProfile_564708 = ref object of OpenApiRestCall_563565
proc url_PoliciesGetByBillingProfile_564710(protocol: Scheme; host: string;
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

proc validate_PoliciesGetByBillingProfile_564709(path: JsonNode; query: JsonNode;
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
  var valid_564711 = path.getOrDefault("billingAccountName")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = nil)
  if valid_564711 != nil:
    section.add "billingAccountName", valid_564711
  var valid_564712 = path.getOrDefault("billingProfileName")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "billingProfileName", valid_564712
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564713 = query.getOrDefault("api-version")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "api-version", valid_564713
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564714: Call_PoliciesGetByBillingProfile_564708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The policy for a given billing account name and billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564714.validator(path, query, header, formData, body)
  let scheme = call_564714.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564714.url(scheme.get, call_564714.host, call_564714.base,
                         call_564714.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564714, url, valid)

proc call*(call_564715: Call_PoliciesGetByBillingProfile_564708;
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
  var path_564716 = newJObject()
  var query_564717 = newJObject()
  add(query_564717, "api-version", newJString(apiVersion))
  add(path_564716, "billingAccountName", newJString(billingAccountName))
  add(path_564716, "billingProfileName", newJString(billingProfileName))
  result = call_564715.call(path_564716, query_564717, nil, nil, nil)

var policiesGetByBillingProfile* = Call_PoliciesGetByBillingProfile_564708(
    name: "policiesGetByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/policies/default",
    validator: validate_PoliciesGetByBillingProfile_564709, base: "",
    url: url_PoliciesGetByBillingProfile_564710, schemes: {Scheme.Https})
type
  Call_PriceSheetDownloadByBillingProfile_564730 = ref object of OpenApiRestCall_563565
proc url_PriceSheetDownloadByBillingProfile_564732(protocol: Scheme; host: string;
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

proc validate_PriceSheetDownloadByBillingProfile_564731(path: JsonNode;
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
  var valid_564733 = path.getOrDefault("billingAccountName")
  valid_564733 = validateParameter(valid_564733, JString, required = true,
                                 default = nil)
  if valid_564733 != nil:
    section.add "billingAccountName", valid_564733
  var valid_564734 = path.getOrDefault("billingProfileName")
  valid_564734 = validateParameter(valid_564734, JString, required = true,
                                 default = nil)
  if valid_564734 != nil:
    section.add "billingProfileName", valid_564734
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564735 = query.getOrDefault("api-version")
  valid_564735 = validateParameter(valid_564735, JString, required = true,
                                 default = nil)
  if valid_564735 != nil:
    section.add "api-version", valid_564735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564736: Call_PriceSheetDownloadByBillingProfile_564730;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Download price sheet for a billing profile.
  ## 
  let valid = call_564736.validator(path, query, header, formData, body)
  let scheme = call_564736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564736.url(scheme.get, call_564736.host, call_564736.base,
                         call_564736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564736, url, valid)

proc call*(call_564737: Call_PriceSheetDownloadByBillingProfile_564730;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## priceSheetDownloadByBillingProfile
  ## Download price sheet for a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564738 = newJObject()
  var query_564739 = newJObject()
  add(query_564739, "api-version", newJString(apiVersion))
  add(path_564738, "billingAccountName", newJString(billingAccountName))
  add(path_564738, "billingProfileName", newJString(billingProfileName))
  result = call_564737.call(path_564738, query_564739, nil, nil, nil)

var priceSheetDownloadByBillingProfile* = Call_PriceSheetDownloadByBillingProfile_564730(
    name: "priceSheetDownloadByBillingProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/pricesheet/default/download",
    validator: validate_PriceSheetDownloadByBillingProfile_564731, base: "",
    url: url_PriceSheetDownloadByBillingProfile_564732, schemes: {Scheme.Https})
type
  Call_TransactionsListByBillingProfile_564740 = ref object of OpenApiRestCall_563565
proc url_TransactionsListByBillingProfile_564742(protocol: Scheme; host: string;
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

proc validate_TransactionsListByBillingProfile_564741(path: JsonNode;
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
  var valid_564743 = path.getOrDefault("billingAccountName")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = nil)
  if valid_564743 != nil:
    section.add "billingAccountName", valid_564743
  var valid_564744 = path.getOrDefault("billingProfileName")
  valid_564744 = validateParameter(valid_564744, JString, required = true,
                                 default = nil)
  if valid_564744 != nil:
    section.add "billingProfileName", valid_564744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564745 = query.getOrDefault("api-version")
  valid_564745 = validateParameter(valid_564745, JString, required = true,
                                 default = nil)
  if valid_564745 != nil:
    section.add "api-version", valid_564745
  var valid_564746 = query.getOrDefault("endDate")
  valid_564746 = validateParameter(valid_564746, JString, required = true,
                                 default = nil)
  if valid_564746 != nil:
    section.add "endDate", valid_564746
  var valid_564747 = query.getOrDefault("$filter")
  valid_564747 = validateParameter(valid_564747, JString, required = false,
                                 default = nil)
  if valid_564747 != nil:
    section.add "$filter", valid_564747
  var valid_564748 = query.getOrDefault("startDate")
  valid_564748 = validateParameter(valid_564748, JString, required = true,
                                 default = nil)
  if valid_564748 != nil:
    section.add "startDate", valid_564748
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564749: Call_TransactionsListByBillingProfile_564740;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by billing profile name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564749.validator(path, query, header, formData, body)
  let scheme = call_564749.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564749.url(scheme.get, call_564749.host, call_564749.base,
                         call_564749.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564749, url, valid)

proc call*(call_564750: Call_TransactionsListByBillingProfile_564740;
          apiVersion: string; billingAccountName: string; endDate: string;
          startDate: string; billingProfileName: string; Filter: string = ""): Recallable =
  ## transactionsListByBillingProfile
  ## Lists the transactions by billing profile name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   endDate: string (required)
  ##          : End date
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: string (required)
  ##            : Start date
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564751 = newJObject()
  var query_564752 = newJObject()
  add(query_564752, "api-version", newJString(apiVersion))
  add(path_564751, "billingAccountName", newJString(billingAccountName))
  add(query_564752, "endDate", newJString(endDate))
  add(query_564752, "$filter", newJString(Filter))
  add(query_564752, "startDate", newJString(startDate))
  add(path_564751, "billingProfileName", newJString(billingProfileName))
  result = call_564750.call(path_564751, query_564752, nil, nil, nil)

var transactionsListByBillingProfile* = Call_TransactionsListByBillingProfile_564740(
    name: "transactionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/transactions",
    validator: validate_TransactionsListByBillingProfile_564741, base: "",
    url: url_TransactionsListByBillingProfile_564742, schemes: {Scheme.Https})
type
  Call_TransactionsGet_564753 = ref object of OpenApiRestCall_563565
proc url_TransactionsGet_564755(protocol: Scheme; host: string; base: string;
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

proc validate_TransactionsGet_564754(path: JsonNode; query: JsonNode;
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
  var valid_564756 = path.getOrDefault("billingAccountName")
  valid_564756 = validateParameter(valid_564756, JString, required = true,
                                 default = nil)
  if valid_564756 != nil:
    section.add "billingAccountName", valid_564756
  var valid_564757 = path.getOrDefault("transactionName")
  valid_564757 = validateParameter(valid_564757, JString, required = true,
                                 default = nil)
  if valid_564757 != nil:
    section.add "transactionName", valid_564757
  var valid_564758 = path.getOrDefault("billingProfileName")
  valid_564758 = validateParameter(valid_564758, JString, required = true,
                                 default = nil)
  if valid_564758 != nil:
    section.add "billingProfileName", valid_564758
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
  var valid_564759 = query.getOrDefault("api-version")
  valid_564759 = validateParameter(valid_564759, JString, required = true,
                                 default = nil)
  if valid_564759 != nil:
    section.add "api-version", valid_564759
  var valid_564760 = query.getOrDefault("endDate")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = nil)
  if valid_564760 != nil:
    section.add "endDate", valid_564760
  var valid_564761 = query.getOrDefault("startDate")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "startDate", valid_564761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564762: Call_TransactionsGet_564753; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the transaction.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564762.validator(path, query, header, formData, body)
  let scheme = call_564762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564762.url(scheme.get, call_564762.host, call_564762.base,
                         call_564762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564762, url, valid)

proc call*(call_564763: Call_TransactionsGet_564753; apiVersion: string;
          billingAccountName: string; endDate: string; transactionName: string;
          startDate: string; billingProfileName: string): Recallable =
  ## transactionsGet
  ## Get the transaction.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   endDate: string (required)
  ##          : End date
  ##   transactionName: string (required)
  ##                  : Transaction name.
  ##   startDate: string (required)
  ##            : Start date
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564764 = newJObject()
  var query_564765 = newJObject()
  add(query_564765, "api-version", newJString(apiVersion))
  add(path_564764, "billingAccountName", newJString(billingAccountName))
  add(query_564765, "endDate", newJString(endDate))
  add(path_564764, "transactionName", newJString(transactionName))
  add(query_564765, "startDate", newJString(startDate))
  add(path_564764, "billingProfileName", newJString(billingProfileName))
  result = call_564763.call(path_564764, query_564765, nil, nil, nil)

var transactionsGet* = Call_TransactionsGet_564753(name: "transactionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/transactions/{transactionName}",
    validator: validate_TransactionsGet_564754, base: "", url: url_TransactionsGet_564755,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByBillingAccount_564766 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsListByBillingAccount_564768(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsListByBillingAccount_564767(path: JsonNode;
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
  var valid_564769 = path.getOrDefault("billingAccountName")
  valid_564769 = validateParameter(valid_564769, JString, required = true,
                                 default = nil)
  if valid_564769 != nil:
    section.add "billingAccountName", valid_564769
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564770 = query.getOrDefault("api-version")
  valid_564770 = validateParameter(valid_564770, JString, required = true,
                                 default = nil)
  if valid_564770 != nil:
    section.add "api-version", valid_564770
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564771: Call_BillingRoleAssignmentsListByBillingAccount_564766;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the Billing Account
  ## 
  let valid = call_564771.validator(path, query, header, formData, body)
  let scheme = call_564771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564771.url(scheme.get, call_564771.host, call_564771.base,
                         call_564771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564771, url, valid)

proc call*(call_564772: Call_BillingRoleAssignmentsListByBillingAccount_564766;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingRoleAssignmentsListByBillingAccount
  ## Get the role assignments on the Billing Account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_564773 = newJObject()
  var query_564774 = newJObject()
  add(query_564774, "api-version", newJString(apiVersion))
  add(path_564773, "billingAccountName", newJString(billingAccountName))
  result = call_564772.call(path_564773, query_564774, nil, nil, nil)

var billingRoleAssignmentsListByBillingAccount* = Call_BillingRoleAssignmentsListByBillingAccount_564766(
    name: "billingRoleAssignmentsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByBillingAccount_564767,
    base: "", url: url_BillingRoleAssignmentsListByBillingAccount_564768,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByBillingAccount_564775 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsGetByBillingAccount_564777(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsGetByBillingAccount_564776(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignment for the caller
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564778 = path.getOrDefault("billingAccountName")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "billingAccountName", valid_564778
  var valid_564779 = path.getOrDefault("billingRoleAssignmentName")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "billingRoleAssignmentName", valid_564779
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564780 = query.getOrDefault("api-version")
  valid_564780 = validateParameter(valid_564780, JString, required = true,
                                 default = nil)
  if valid_564780 != nil:
    section.add "api-version", valid_564780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564781: Call_BillingRoleAssignmentsGetByBillingAccount_564775;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller
  ## 
  let valid = call_564781.validator(path, query, header, formData, body)
  let scheme = call_564781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564781.url(scheme.get, call_564781.host, call_564781.base,
                         call_564781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564781, url, valid)

proc call*(call_564782: Call_BillingRoleAssignmentsGetByBillingAccount_564775;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string): Recallable =
  ## billingRoleAssignmentsGetByBillingAccount
  ## Get the role assignment for the caller
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  var path_564783 = newJObject()
  var query_564784 = newJObject()
  add(query_564784, "api-version", newJString(apiVersion))
  add(path_564783, "billingAccountName", newJString(billingAccountName))
  add(path_564783, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  result = call_564782.call(path_564783, query_564784, nil, nil, nil)

var billingRoleAssignmentsGetByBillingAccount* = Call_BillingRoleAssignmentsGetByBillingAccount_564775(
    name: "billingRoleAssignmentsGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByBillingAccount_564776,
    base: "", url: url_BillingRoleAssignmentsGetByBillingAccount_564777,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByBillingAccount_564785 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsDeleteByBillingAccount_564787(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsDeleteByBillingAccount_564786(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the role assignment on this billing account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564788 = path.getOrDefault("billingAccountName")
  valid_564788 = validateParameter(valid_564788, JString, required = true,
                                 default = nil)
  if valid_564788 != nil:
    section.add "billingAccountName", valid_564788
  var valid_564789 = path.getOrDefault("billingRoleAssignmentName")
  valid_564789 = validateParameter(valid_564789, JString, required = true,
                                 default = nil)
  if valid_564789 != nil:
    section.add "billingRoleAssignmentName", valid_564789
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564790 = query.getOrDefault("api-version")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "api-version", valid_564790
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564791: Call_BillingRoleAssignmentsDeleteByBillingAccount_564785;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on this billing account
  ## 
  let valid = call_564791.validator(path, query, header, formData, body)
  let scheme = call_564791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564791.url(scheme.get, call_564791.host, call_564791.base,
                         call_564791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564791, url, valid)

proc call*(call_564792: Call_BillingRoleAssignmentsDeleteByBillingAccount_564785;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string): Recallable =
  ## billingRoleAssignmentsDeleteByBillingAccount
  ## Delete the role assignment on this billing account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  var path_564793 = newJObject()
  var query_564794 = newJObject()
  add(query_564794, "api-version", newJString(apiVersion))
  add(path_564793, "billingAccountName", newJString(billingAccountName))
  add(path_564793, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  result = call_564792.call(path_564793, query_564794, nil, nil, nil)

var billingRoleAssignmentsDeleteByBillingAccount* = Call_BillingRoleAssignmentsDeleteByBillingAccount_564785(
    name: "billingRoleAssignmentsDeleteByBillingAccount",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByBillingAccount_564786,
    base: "", url: url_BillingRoleAssignmentsDeleteByBillingAccount_564787,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByBillingAccount_564795 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsListByBillingAccount_564797(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsListByBillingAccount_564796(path: JsonNode;
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
  var valid_564798 = path.getOrDefault("billingAccountName")
  valid_564798 = validateParameter(valid_564798, JString, required = true,
                                 default = nil)
  if valid_564798 != nil:
    section.add "billingAccountName", valid_564798
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564799 = query.getOrDefault("api-version")
  valid_564799 = validateParameter(valid_564799, JString, required = true,
                                 default = nil)
  if valid_564799 != nil:
    section.add "api-version", valid_564799
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564800: Call_BillingRoleDefinitionsListByBillingAccount_564795;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for a billing account
  ## 
  let valid = call_564800.validator(path, query, header, formData, body)
  let scheme = call_564800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564800.url(scheme.get, call_564800.host, call_564800.base,
                         call_564800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564800, url, valid)

proc call*(call_564801: Call_BillingRoleDefinitionsListByBillingAccount_564795;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingRoleDefinitionsListByBillingAccount
  ## Lists the role definition for a billing account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_564802 = newJObject()
  var query_564803 = newJObject()
  add(query_564803, "api-version", newJString(apiVersion))
  add(path_564802, "billingAccountName", newJString(billingAccountName))
  result = call_564801.call(path_564802, query_564803, nil, nil, nil)

var billingRoleDefinitionsListByBillingAccount* = Call_BillingRoleDefinitionsListByBillingAccount_564795(
    name: "billingRoleDefinitionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByBillingAccount_564796,
    base: "", url: url_BillingRoleDefinitionsListByBillingAccount_564797,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByBillingAccount_564804 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsGetByBillingAccount_564806(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsGetByBillingAccount_564805(path: JsonNode;
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
  var valid_564807 = path.getOrDefault("billingAccountName")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = nil)
  if valid_564807 != nil:
    section.add "billingAccountName", valid_564807
  var valid_564808 = path.getOrDefault("billingRoleDefinitionName")
  valid_564808 = validateParameter(valid_564808, JString, required = true,
                                 default = nil)
  if valid_564808 != nil:
    section.add "billingRoleDefinitionName", valid_564808
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564809 = query.getOrDefault("api-version")
  valid_564809 = validateParameter(valid_564809, JString, required = true,
                                 default = nil)
  if valid_564809 != nil:
    section.add "api-version", valid_564809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564810: Call_BillingRoleDefinitionsGetByBillingAccount_564804;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_564810.validator(path, query, header, formData, body)
  let scheme = call_564810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564810.url(scheme.get, call_564810.host, call_564810.base,
                         call_564810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564810, url, valid)

proc call*(call_564811: Call_BillingRoleDefinitionsGetByBillingAccount_564804;
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
  var path_564812 = newJObject()
  var query_564813 = newJObject()
  add(query_564813, "api-version", newJString(apiVersion))
  add(path_564812, "billingAccountName", newJString(billingAccountName))
  add(path_564812, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  result = call_564811.call(path_564812, query_564813, nil, nil, nil)

var billingRoleDefinitionsGetByBillingAccount* = Call_BillingRoleDefinitionsGetByBillingAccount_564804(
    name: "billingRoleDefinitionsGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByBillingAccount_564805,
    base: "", url: url_BillingRoleDefinitionsGetByBillingAccount_564806,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByBillingAccount_564814 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsListByBillingAccount_564816(protocol: Scheme;
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

proc validate_BillingSubscriptionsListByBillingAccount_564815(path: JsonNode;
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
  var valid_564817 = path.getOrDefault("billingAccountName")
  valid_564817 = validateParameter(valid_564817, JString, required = true,
                                 default = nil)
  if valid_564817 != nil:
    section.add "billingAccountName", valid_564817
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564818 = query.getOrDefault("api-version")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "api-version", valid_564818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564819: Call_BillingSubscriptionsListByBillingAccount_564814;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscriptions by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564819.validator(path, query, header, formData, body)
  let scheme = call_564819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564819.url(scheme.get, call_564819.host, call_564819.base,
                         call_564819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564819, url, valid)

proc call*(call_564820: Call_BillingSubscriptionsListByBillingAccount_564814;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingSubscriptionsListByBillingAccount
  ## Lists billing subscriptions by billing account name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_564821 = newJObject()
  var query_564822 = newJObject()
  add(query_564822, "api-version", newJString(apiVersion))
  add(path_564821, "billingAccountName", newJString(billingAccountName))
  result = call_564820.call(path_564821, query_564822, nil, nil, nil)

var billingSubscriptionsListByBillingAccount* = Call_BillingSubscriptionsListByBillingAccount_564814(
    name: "billingSubscriptionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByBillingAccount_564815, base: "",
    url: url_BillingSubscriptionsListByBillingAccount_564816,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByBillingAccount_564823 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsAddByBillingAccount_564825(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsAddByBillingAccount_564824(path: JsonNode;
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
  var valid_564826 = path.getOrDefault("billingAccountName")
  valid_564826 = validateParameter(valid_564826, JString, required = true,
                                 default = nil)
  if valid_564826 != nil:
    section.add "billingAccountName", valid_564826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564827 = query.getOrDefault("api-version")
  valid_564827 = validateParameter(valid_564827, JString, required = true,
                                 default = nil)
  if valid_564827 != nil:
    section.add "api-version", valid_564827
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

proc call*(call_564829: Call_BillingRoleAssignmentsAddByBillingAccount_564823;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a billing account.
  ## 
  let valid = call_564829.validator(path, query, header, formData, body)
  let scheme = call_564829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564829.url(scheme.get, call_564829.host, call_564829.base,
                         call_564829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564829, url, valid)

proc call*(call_564830: Call_BillingRoleAssignmentsAddByBillingAccount_564823;
          apiVersion: string; billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingRoleAssignmentsAddByBillingAccount
  ## The operation to add a role assignment to a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  var path_564831 = newJObject()
  var query_564832 = newJObject()
  var body_564833 = newJObject()
  add(query_564832, "api-version", newJString(apiVersion))
  add(path_564831, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_564833 = parameters
  result = call_564830.call(path_564831, query_564832, nil, nil, body_564833)

var billingRoleAssignmentsAddByBillingAccount* = Call_BillingRoleAssignmentsAddByBillingAccount_564823(
    name: "billingRoleAssignmentsAddByBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByBillingAccount_564824,
    base: "", url: url_BillingRoleAssignmentsAddByBillingAccount_564825,
    schemes: {Scheme.Https})
type
  Call_CustomersListByBillingAccount_564834 = ref object of OpenApiRestCall_563565
proc url_CustomersListByBillingAccount_564836(protocol: Scheme; host: string;
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

proc validate_CustomersListByBillingAccount_564835(path: JsonNode; query: JsonNode;
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
  var valid_564837 = path.getOrDefault("billingAccountName")
  valid_564837 = validateParameter(valid_564837, JString, required = true,
                                 default = nil)
  if valid_564837 != nil:
    section.add "billingAccountName", valid_564837
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
  var valid_564838 = query.getOrDefault("api-version")
  valid_564838 = validateParameter(valid_564838, JString, required = true,
                                 default = nil)
  if valid_564838 != nil:
    section.add "api-version", valid_564838
  var valid_564839 = query.getOrDefault("$skiptoken")
  valid_564839 = validateParameter(valid_564839, JString, required = false,
                                 default = nil)
  if valid_564839 != nil:
    section.add "$skiptoken", valid_564839
  var valid_564840 = query.getOrDefault("$filter")
  valid_564840 = validateParameter(valid_564840, JString, required = false,
                                 default = nil)
  if valid_564840 != nil:
    section.add "$filter", valid_564840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564841: Call_CustomersListByBillingAccount_564834; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists customers which the current user can work with on-behalf of a partner.
  ## 
  let valid = call_564841.validator(path, query, header, formData, body)
  let scheme = call_564841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564841.url(scheme.get, call_564841.host, call_564841.base,
                         call_564841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564841, url, valid)

proc call*(call_564842: Call_CustomersListByBillingAccount_564834;
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
  var path_564843 = newJObject()
  var query_564844 = newJObject()
  add(query_564844, "api-version", newJString(apiVersion))
  add(path_564843, "billingAccountName", newJString(billingAccountName))
  add(query_564844, "$skiptoken", newJString(Skiptoken))
  add(query_564844, "$filter", newJString(Filter))
  result = call_564842.call(path_564843, query_564844, nil, nil, nil)

var customersListByBillingAccount* = Call_CustomersListByBillingAccount_564834(
    name: "customersListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers",
    validator: validate_CustomersListByBillingAccount_564835, base: "",
    url: url_CustomersListByBillingAccount_564836, schemes: {Scheme.Https})
type
  Call_CustomersGet_564845 = ref object of OpenApiRestCall_563565
proc url_CustomersGet_564847(protocol: Scheme; host: string; base: string;
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

proc validate_CustomersGet_564846(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564848 = path.getOrDefault("billingAccountName")
  valid_564848 = validateParameter(valid_564848, JString, required = true,
                                 default = nil)
  if valid_564848 != nil:
    section.add "billingAccountName", valid_564848
  var valid_564849 = path.getOrDefault("customerName")
  valid_564849 = validateParameter(valid_564849, JString, required = true,
                                 default = nil)
  if valid_564849 != nil:
    section.add "customerName", valid_564849
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $expand: JString
  ##          : May be used to expand enabledAzurePlans, resellers.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564850 = query.getOrDefault("api-version")
  valid_564850 = validateParameter(valid_564850, JString, required = true,
                                 default = nil)
  if valid_564850 != nil:
    section.add "api-version", valid_564850
  var valid_564851 = query.getOrDefault("$expand")
  valid_564851 = validateParameter(valid_564851, JString, required = false,
                                 default = nil)
  if valid_564851 != nil:
    section.add "$expand", valid_564851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564852: Call_CustomersGet_564845; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a customer by its id.
  ## 
  let valid = call_564852.validator(path, query, header, formData, body)
  let scheme = call_564852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564852.url(scheme.get, call_564852.host, call_564852.base,
                         call_564852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564852, url, valid)

proc call*(call_564853: Call_CustomersGet_564845; apiVersion: string;
          billingAccountName: string; customerName: string; Expand: string = ""): Recallable =
  ## customersGet
  ## Gets a customer by its id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   Expand: string
  ##         : May be used to expand enabledAzurePlans, resellers.
  var path_564854 = newJObject()
  var query_564855 = newJObject()
  add(query_564855, "api-version", newJString(apiVersion))
  add(path_564854, "billingAccountName", newJString(billingAccountName))
  add(path_564854, "customerName", newJString(customerName))
  add(query_564855, "$expand", newJString(Expand))
  result = call_564853.call(path_564854, query_564855, nil, nil, nil)

var customersGet* = Call_CustomersGet_564845(name: "customersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}",
    validator: validate_CustomersGet_564846, base: "", url: url_CustomersGet_564847,
    schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByCustomer_564856 = ref object of OpenApiRestCall_563565
proc url_BillingPermissionsListByCustomer_564858(protocol: Scheme; host: string;
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

proc validate_BillingPermissionsListByCustomer_564857(path: JsonNode;
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
  var valid_564859 = path.getOrDefault("billingAccountName")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = nil)
  if valid_564859 != nil:
    section.add "billingAccountName", valid_564859
  var valid_564860 = path.getOrDefault("customerName")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "customerName", valid_564860
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564861 = query.getOrDefault("api-version")
  valid_564861 = validateParameter(valid_564861, JString, required = true,
                                 default = nil)
  if valid_564861 != nil:
    section.add "api-version", valid_564861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564862: Call_BillingPermissionsListByCustomer_564856;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions the caller has for a customer.
  ## 
  let valid = call_564862.validator(path, query, header, formData, body)
  let scheme = call_564862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564862.url(scheme.get, call_564862.host, call_564862.base,
                         call_564862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564862, url, valid)

proc call*(call_564863: Call_BillingPermissionsListByCustomer_564856;
          apiVersion: string; billingAccountName: string; customerName: string): Recallable =
  ## billingPermissionsListByCustomer
  ## Lists all billing permissions the caller has for a customer.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  var path_564864 = newJObject()
  var query_564865 = newJObject()
  add(query_564865, "api-version", newJString(apiVersion))
  add(path_564864, "billingAccountName", newJString(billingAccountName))
  add(path_564864, "customerName", newJString(customerName))
  result = call_564863.call(path_564864, query_564865, nil, nil, nil)

var billingPermissionsListByCustomer* = Call_BillingPermissionsListByCustomer_564856(
    name: "billingPermissionsListByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingPermissions",
    validator: validate_BillingPermissionsListByCustomer_564857, base: "",
    url: url_BillingPermissionsListByCustomer_564858, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByCustomer_564866 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsListByCustomer_564868(protocol: Scheme; host: string;
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

proc validate_BillingSubscriptionsListByCustomer_564867(path: JsonNode;
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
  var valid_564869 = path.getOrDefault("billingAccountName")
  valid_564869 = validateParameter(valid_564869, JString, required = true,
                                 default = nil)
  if valid_564869 != nil:
    section.add "billingAccountName", valid_564869
  var valid_564870 = path.getOrDefault("customerName")
  valid_564870 = validateParameter(valid_564870, JString, required = true,
                                 default = nil)
  if valid_564870 != nil:
    section.add "customerName", valid_564870
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564871 = query.getOrDefault("api-version")
  valid_564871 = validateParameter(valid_564871, JString, required = true,
                                 default = nil)
  if valid_564871 != nil:
    section.add "api-version", valid_564871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564872: Call_BillingSubscriptionsListByCustomer_564866;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscription by customer id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564872.validator(path, query, header, formData, body)
  let scheme = call_564872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564872.url(scheme.get, call_564872.host, call_564872.base,
                         call_564872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564872, url, valid)

proc call*(call_564873: Call_BillingSubscriptionsListByCustomer_564866;
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
  var path_564874 = newJObject()
  var query_564875 = newJObject()
  add(query_564875, "api-version", newJString(apiVersion))
  add(path_564874, "billingAccountName", newJString(billingAccountName))
  add(path_564874, "customerName", newJString(customerName))
  result = call_564873.call(path_564874, query_564875, nil, nil, nil)

var billingSubscriptionsListByCustomer* = Call_BillingSubscriptionsListByCustomer_564866(
    name: "billingSubscriptionsListByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByCustomer_564867, base: "",
    url: url_BillingSubscriptionsListByCustomer_564868, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsGetByCustomer_564876 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsGetByCustomer_564878(protocol: Scheme; host: string;
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

proc validate_BillingSubscriptionsGetByCustomer_564877(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single billing subscription by id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564879 = path.getOrDefault("billingAccountName")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "billingAccountName", valid_564879
  var valid_564880 = path.getOrDefault("customerName")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "customerName", valid_564880
  var valid_564881 = path.getOrDefault("billingSubscriptionName")
  valid_564881 = validateParameter(valid_564881, JString, required = true,
                                 default = nil)
  if valid_564881 != nil:
    section.add "billingSubscriptionName", valid_564881
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564882 = query.getOrDefault("api-version")
  valid_564882 = validateParameter(valid_564882, JString, required = true,
                                 default = nil)
  if valid_564882 != nil:
    section.add "api-version", valid_564882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564883: Call_BillingSubscriptionsGetByCustomer_564876;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a single billing subscription by id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564883.validator(path, query, header, formData, body)
  let scheme = call_564883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564883.url(scheme.get, call_564883.host, call_564883.base,
                         call_564883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564883, url, valid)

proc call*(call_564884: Call_BillingSubscriptionsGetByCustomer_564876;
          apiVersion: string; billingAccountName: string; customerName: string;
          billingSubscriptionName: string): Recallable =
  ## billingSubscriptionsGetByCustomer
  ## Get a single billing subscription by id.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  var path_564885 = newJObject()
  var query_564886 = newJObject()
  add(query_564886, "api-version", newJString(apiVersion))
  add(path_564885, "billingAccountName", newJString(billingAccountName))
  add(path_564885, "customerName", newJString(customerName))
  add(path_564885, "billingSubscriptionName", newJString(billingSubscriptionName))
  result = call_564884.call(path_564885, query_564886, nil, nil, nil)

var billingSubscriptionsGetByCustomer* = Call_BillingSubscriptionsGetByCustomer_564876(
    name: "billingSubscriptionsGetByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingSubscriptions/{billingSubscriptionName}",
    validator: validate_BillingSubscriptionsGetByCustomer_564877, base: "",
    url: url_BillingSubscriptionsGetByCustomer_564878, schemes: {Scheme.Https})
type
  Call_PoliciesUpdateCustomer_564897 = ref object of OpenApiRestCall_563565
proc url_PoliciesUpdateCustomer_564899(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesUpdateCustomer_564898(path: JsonNode; query: JsonNode;
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
  var valid_564900 = path.getOrDefault("billingAccountName")
  valid_564900 = validateParameter(valid_564900, JString, required = true,
                                 default = nil)
  if valid_564900 != nil:
    section.add "billingAccountName", valid_564900
  var valid_564901 = path.getOrDefault("customerName")
  valid_564901 = validateParameter(valid_564901, JString, required = true,
                                 default = nil)
  if valid_564901 != nil:
    section.add "customerName", valid_564901
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564902 = query.getOrDefault("api-version")
  valid_564902 = validateParameter(valid_564902, JString, required = true,
                                 default = nil)
  if valid_564902 != nil:
    section.add "api-version", valid_564902
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

proc call*(call_564904: Call_PoliciesUpdateCustomer_564897; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a Customer policy.
  ## 
  let valid = call_564904.validator(path, query, header, formData, body)
  let scheme = call_564904.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564904.url(scheme.get, call_564904.host, call_564904.base,
                         call_564904.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564904, url, valid)

proc call*(call_564905: Call_PoliciesUpdateCustomer_564897; apiVersion: string;
          billingAccountName: string; customerName: string; parameters: JsonNode): Recallable =
  ## policiesUpdateCustomer
  ## The operation to update a Customer policy.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update customer policy operation.
  var path_564906 = newJObject()
  var query_564907 = newJObject()
  var body_564908 = newJObject()
  add(query_564907, "api-version", newJString(apiVersion))
  add(path_564906, "billingAccountName", newJString(billingAccountName))
  add(path_564906, "customerName", newJString(customerName))
  if parameters != nil:
    body_564908 = parameters
  result = call_564905.call(path_564906, query_564907, nil, nil, body_564908)

var policiesUpdateCustomer* = Call_PoliciesUpdateCustomer_564897(
    name: "policiesUpdateCustomer", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/policies/default",
    validator: validate_PoliciesUpdateCustomer_564898, base: "",
    url: url_PoliciesUpdateCustomer_564899, schemes: {Scheme.Https})
type
  Call_PoliciesGetByCustomer_564887 = ref object of OpenApiRestCall_563565
proc url_PoliciesGetByCustomer_564889(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesGetByCustomer_564888(path: JsonNode; query: JsonNode;
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
  var valid_564890 = path.getOrDefault("billingAccountName")
  valid_564890 = validateParameter(valid_564890, JString, required = true,
                                 default = nil)
  if valid_564890 != nil:
    section.add "billingAccountName", valid_564890
  var valid_564891 = path.getOrDefault("customerName")
  valid_564891 = validateParameter(valid_564891, JString, required = true,
                                 default = nil)
  if valid_564891 != nil:
    section.add "customerName", valid_564891
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564892 = query.getOrDefault("api-version")
  valid_564892 = validateParameter(valid_564892, JString, required = true,
                                 default = nil)
  if valid_564892 != nil:
    section.add "api-version", valid_564892
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564893: Call_PoliciesGetByCustomer_564887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The policy for a given billing account name and customer name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564893.validator(path, query, header, formData, body)
  let scheme = call_564893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564893.url(scheme.get, call_564893.host, call_564893.base,
                         call_564893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564893, url, valid)

proc call*(call_564894: Call_PoliciesGetByCustomer_564887; apiVersion: string;
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
  var path_564895 = newJObject()
  var query_564896 = newJObject()
  add(query_564896, "api-version", newJString(apiVersion))
  add(path_564895, "billingAccountName", newJString(billingAccountName))
  add(path_564895, "customerName", newJString(customerName))
  result = call_564894.call(path_564895, query_564896, nil, nil, nil)

var policiesGetByCustomer* = Call_PoliciesGetByCustomer_564887(
    name: "policiesGetByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/policies/default",
    validator: validate_PoliciesGetByCustomer_564888, base: "",
    url: url_PoliciesGetByCustomer_564889, schemes: {Scheme.Https})
type
  Call_ProductsListByCustomer_564909 = ref object of OpenApiRestCall_563565
proc url_ProductsListByCustomer_564911(protocol: Scheme; host: string; base: string;
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

proc validate_ProductsListByCustomer_564910(path: JsonNode; query: JsonNode;
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
  var valid_564912 = path.getOrDefault("billingAccountName")
  valid_564912 = validateParameter(valid_564912, JString, required = true,
                                 default = nil)
  if valid_564912 != nil:
    section.add "billingAccountName", valid_564912
  var valid_564913 = path.getOrDefault("customerName")
  valid_564913 = validateParameter(valid_564913, JString, required = true,
                                 default = nil)
  if valid_564913 != nil:
    section.add "customerName", valid_564913
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564914 = query.getOrDefault("api-version")
  valid_564914 = validateParameter(valid_564914, JString, required = true,
                                 default = nil)
  if valid_564914 != nil:
    section.add "api-version", valid_564914
  var valid_564915 = query.getOrDefault("$filter")
  valid_564915 = validateParameter(valid_564915, JString, required = false,
                                 default = nil)
  if valid_564915 != nil:
    section.add "$filter", valid_564915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564916: Call_ProductsListByCustomer_564909; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists products by customer id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564916.validator(path, query, header, formData, body)
  let scheme = call_564916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564916.url(scheme.get, call_564916.host, call_564916.base,
                         call_564916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564916, url, valid)

proc call*(call_564917: Call_ProductsListByCustomer_564909; apiVersion: string;
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
  var path_564918 = newJObject()
  var query_564919 = newJObject()
  add(query_564919, "api-version", newJString(apiVersion))
  add(path_564918, "billingAccountName", newJString(billingAccountName))
  add(path_564918, "customerName", newJString(customerName))
  add(query_564919, "$filter", newJString(Filter))
  result = call_564917.call(path_564918, query_564919, nil, nil, nil)

var productsListByCustomer* = Call_ProductsListByCustomer_564909(
    name: "productsListByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/products",
    validator: validate_ProductsListByCustomer_564910, base: "",
    url: url_ProductsListByCustomer_564911, schemes: {Scheme.Https})
type
  Call_ProductsGetByCustomer_564920 = ref object of OpenApiRestCall_563565
proc url_ProductsGetByCustomer_564922(protocol: Scheme; host: string; base: string;
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

proc validate_ProductsGetByCustomer_564921(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a customer's product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer name.
  ##   productName: JString (required)
  ##              : Invoice Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564923 = path.getOrDefault("billingAccountName")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "billingAccountName", valid_564923
  var valid_564924 = path.getOrDefault("customerName")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "customerName", valid_564924
  var valid_564925 = path.getOrDefault("productName")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "productName", valid_564925
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564926 = query.getOrDefault("api-version")
  valid_564926 = validateParameter(valid_564926, JString, required = true,
                                 default = nil)
  if valid_564926 != nil:
    section.add "api-version", valid_564926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564927: Call_ProductsGetByCustomer_564920; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a customer's product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_564927.validator(path, query, header, formData, body)
  let scheme = call_564927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564927.url(scheme.get, call_564927.host, call_564927.base,
                         call_564927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564927, url, valid)

proc call*(call_564928: Call_ProductsGetByCustomer_564920; apiVersion: string;
          billingAccountName: string; customerName: string; productName: string): Recallable =
  ## productsGetByCustomer
  ## Get a customer's product by name.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   productName: string (required)
  ##              : Invoice Id.
  var path_564929 = newJObject()
  var query_564930 = newJObject()
  add(query_564930, "api-version", newJString(apiVersion))
  add(path_564929, "billingAccountName", newJString(billingAccountName))
  add(path_564929, "customerName", newJString(customerName))
  add(path_564929, "productName", newJString(productName))
  result = call_564928.call(path_564929, query_564930, nil, nil, nil)

var productsGetByCustomer* = Call_ProductsGetByCustomer_564920(
    name: "productsGetByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/products/{productName}",
    validator: validate_ProductsGetByCustomer_564921, base: "",
    url: url_ProductsGetByCustomer_564922, schemes: {Scheme.Https})
type
  Call_TransactionsListByCustomer_564931 = ref object of OpenApiRestCall_563565
proc url_TransactionsListByCustomer_564933(protocol: Scheme; host: string;
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

proc validate_TransactionsListByCustomer_564932(path: JsonNode; query: JsonNode;
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
  var valid_564934 = path.getOrDefault("billingAccountName")
  valid_564934 = validateParameter(valid_564934, JString, required = true,
                                 default = nil)
  if valid_564934 != nil:
    section.add "billingAccountName", valid_564934
  var valid_564935 = path.getOrDefault("customerName")
  valid_564935 = validateParameter(valid_564935, JString, required = true,
                                 default = nil)
  if valid_564935 != nil:
    section.add "customerName", valid_564935
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564936 = query.getOrDefault("api-version")
  valid_564936 = validateParameter(valid_564936, JString, required = true,
                                 default = nil)
  if valid_564936 != nil:
    section.add "api-version", valid_564936
  var valid_564937 = query.getOrDefault("endDate")
  valid_564937 = validateParameter(valid_564937, JString, required = true,
                                 default = nil)
  if valid_564937 != nil:
    section.add "endDate", valid_564937
  var valid_564938 = query.getOrDefault("$filter")
  valid_564938 = validateParameter(valid_564938, JString, required = false,
                                 default = nil)
  if valid_564938 != nil:
    section.add "$filter", valid_564938
  var valid_564939 = query.getOrDefault("startDate")
  valid_564939 = validateParameter(valid_564939, JString, required = true,
                                 default = nil)
  if valid_564939 != nil:
    section.add "startDate", valid_564939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564940: Call_TransactionsListByCustomer_564931; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the transactions by customer id for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564940.validator(path, query, header, formData, body)
  let scheme = call_564940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564940.url(scheme.get, call_564940.host, call_564940.base,
                         call_564940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564940, url, valid)

proc call*(call_564941: Call_TransactionsListByCustomer_564931; apiVersion: string;
          billingAccountName: string; customerName: string; endDate: string;
          startDate: string; Filter: string = ""): Recallable =
  ## transactionsListByCustomer
  ## Lists the transactions by customer id for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   customerName: string (required)
  ##               : Customer name.
  ##   endDate: string (required)
  ##          : End date
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: string (required)
  ##            : Start date
  var path_564942 = newJObject()
  var query_564943 = newJObject()
  add(query_564943, "api-version", newJString(apiVersion))
  add(path_564942, "billingAccountName", newJString(billingAccountName))
  add(path_564942, "customerName", newJString(customerName))
  add(query_564943, "endDate", newJString(endDate))
  add(query_564943, "$filter", newJString(Filter))
  add(query_564943, "startDate", newJString(startDate))
  result = call_564941.call(path_564942, query_564943, nil, nil, nil)

var transactionsListByCustomer* = Call_TransactionsListByCustomer_564931(
    name: "transactionsListByCustomer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/transactions",
    validator: validate_TransactionsListByCustomer_564932, base: "",
    url: url_TransactionsListByCustomer_564933, schemes: {Scheme.Https})
type
  Call_DepartmentsListByBillingAccountName_564944 = ref object of OpenApiRestCall_563565
proc url_DepartmentsListByBillingAccountName_564946(protocol: Scheme; host: string;
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

proc validate_DepartmentsListByBillingAccountName_564945(path: JsonNode;
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
  var valid_564947 = path.getOrDefault("billingAccountName")
  valid_564947 = validateParameter(valid_564947, JString, required = true,
                                 default = nil)
  if valid_564947 != nil:
    section.add "billingAccountName", valid_564947
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
  var valid_564948 = query.getOrDefault("api-version")
  valid_564948 = validateParameter(valid_564948, JString, required = true,
                                 default = nil)
  if valid_564948 != nil:
    section.add "api-version", valid_564948
  var valid_564949 = query.getOrDefault("$expand")
  valid_564949 = validateParameter(valid_564949, JString, required = false,
                                 default = nil)
  if valid_564949 != nil:
    section.add "$expand", valid_564949
  var valid_564950 = query.getOrDefault("$filter")
  valid_564950 = validateParameter(valid_564950, JString, required = false,
                                 default = nil)
  if valid_564950 != nil:
    section.add "$filter", valid_564950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564951: Call_DepartmentsListByBillingAccountName_564944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all departments for a user which he has access to.
  ## 
  let valid = call_564951.validator(path, query, header, formData, body)
  let scheme = call_564951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564951.url(scheme.get, call_564951.host, call_564951.base,
                         call_564951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564951, url, valid)

proc call*(call_564952: Call_DepartmentsListByBillingAccountName_564944;
          apiVersion: string; billingAccountName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## departmentsListByBillingAccountName
  ## Lists all departments for a user which he has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the enrollmentAccounts.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564953 = newJObject()
  var query_564954 = newJObject()
  add(query_564954, "api-version", newJString(apiVersion))
  add(path_564953, "billingAccountName", newJString(billingAccountName))
  add(query_564954, "$expand", newJString(Expand))
  add(query_564954, "$filter", newJString(Filter))
  result = call_564952.call(path_564953, query_564954, nil, nil, nil)

var departmentsListByBillingAccountName* = Call_DepartmentsListByBillingAccountName_564944(
    name: "departmentsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/departments",
    validator: validate_DepartmentsListByBillingAccountName_564945, base: "",
    url: url_DepartmentsListByBillingAccountName_564946, schemes: {Scheme.Https})
type
  Call_DepartmentsGet_564955 = ref object of OpenApiRestCall_563565
proc url_DepartmentsGet_564957(protocol: Scheme; host: string; base: string;
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

proc validate_DepartmentsGet_564956(path: JsonNode; query: JsonNode;
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
  var valid_564958 = path.getOrDefault("billingAccountName")
  valid_564958 = validateParameter(valid_564958, JString, required = true,
                                 default = nil)
  if valid_564958 != nil:
    section.add "billingAccountName", valid_564958
  var valid_564959 = path.getOrDefault("departmentName")
  valid_564959 = validateParameter(valid_564959, JString, required = true,
                                 default = nil)
  if valid_564959 != nil:
    section.add "departmentName", valid_564959
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
  var valid_564960 = query.getOrDefault("api-version")
  valid_564960 = validateParameter(valid_564960, JString, required = true,
                                 default = nil)
  if valid_564960 != nil:
    section.add "api-version", valid_564960
  var valid_564961 = query.getOrDefault("$expand")
  valid_564961 = validateParameter(valid_564961, JString, required = false,
                                 default = nil)
  if valid_564961 != nil:
    section.add "$expand", valid_564961
  var valid_564962 = query.getOrDefault("$filter")
  valid_564962 = validateParameter(valid_564962, JString, required = false,
                                 default = nil)
  if valid_564962 != nil:
    section.add "$filter", valid_564962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564963: Call_DepartmentsGet_564955; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the department by id.
  ## 
  let valid = call_564963.validator(path, query, header, formData, body)
  let scheme = call_564963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564963.url(scheme.get, call_564963.host, call_564963.base,
                         call_564963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564963, url, valid)

proc call*(call_564964: Call_DepartmentsGet_564955; apiVersion: string;
          billingAccountName: string; departmentName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## departmentsGet
  ## Get the department by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the enrollmentAccounts.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   departmentName: string (required)
  ##                 : Department Id.
  var path_564965 = newJObject()
  var query_564966 = newJObject()
  add(query_564966, "api-version", newJString(apiVersion))
  add(path_564965, "billingAccountName", newJString(billingAccountName))
  add(query_564966, "$expand", newJString(Expand))
  add(query_564966, "$filter", newJString(Filter))
  add(path_564965, "departmentName", newJString(departmentName))
  result = call_564964.call(path_564965, query_564966, nil, nil, nil)

var departmentsGet* = Call_DepartmentsGet_564955(name: "departmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/departments/{departmentName}",
    validator: validate_DepartmentsGet_564956, base: "", url: url_DepartmentsGet_564957,
    schemes: {Scheme.Https})
type
  Call_EnrollmentAccountsListByBillingAccountName_564967 = ref object of OpenApiRestCall_563565
proc url_EnrollmentAccountsListByBillingAccountName_564969(protocol: Scheme;
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

proc validate_EnrollmentAccountsListByBillingAccountName_564968(path: JsonNode;
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
  var valid_564970 = path.getOrDefault("billingAccountName")
  valid_564970 = validateParameter(valid_564970, JString, required = true,
                                 default = nil)
  if valid_564970 != nil:
    section.add "billingAccountName", valid_564970
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
  var valid_564971 = query.getOrDefault("api-version")
  valid_564971 = validateParameter(valid_564971, JString, required = true,
                                 default = nil)
  if valid_564971 != nil:
    section.add "api-version", valid_564971
  var valid_564972 = query.getOrDefault("$expand")
  valid_564972 = validateParameter(valid_564972, JString, required = false,
                                 default = nil)
  if valid_564972 != nil:
    section.add "$expand", valid_564972
  var valid_564973 = query.getOrDefault("$filter")
  valid_564973 = validateParameter(valid_564973, JString, required = false,
                                 default = nil)
  if valid_564973 != nil:
    section.add "$filter", valid_564973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564974: Call_EnrollmentAccountsListByBillingAccountName_564967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Enrollment Accounts for a user which he has access to.
  ## 
  let valid = call_564974.validator(path, query, header, formData, body)
  let scheme = call_564974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564974.url(scheme.get, call_564974.host, call_564974.base,
                         call_564974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564974, url, valid)

proc call*(call_564975: Call_EnrollmentAccountsListByBillingAccountName_564967;
          apiVersion: string; billingAccountName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## enrollmentAccountsListByBillingAccountName
  ## Lists all Enrollment Accounts for a user which he has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the department.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564976 = newJObject()
  var query_564977 = newJObject()
  add(query_564977, "api-version", newJString(apiVersion))
  add(path_564976, "billingAccountName", newJString(billingAccountName))
  add(query_564977, "$expand", newJString(Expand))
  add(query_564977, "$filter", newJString(Filter))
  result = call_564975.call(path_564976, query_564977, nil, nil, nil)

var enrollmentAccountsListByBillingAccountName* = Call_EnrollmentAccountsListByBillingAccountName_564967(
    name: "enrollmentAccountsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts",
    validator: validate_EnrollmentAccountsListByBillingAccountName_564968,
    base: "", url: url_EnrollmentAccountsListByBillingAccountName_564969,
    schemes: {Scheme.Https})
type
  Call_EnrollmentAccountsGetByEnrollmentAccountId_564978 = ref object of OpenApiRestCall_563565
proc url_EnrollmentAccountsGetByEnrollmentAccountId_564980(protocol: Scheme;
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

proc validate_EnrollmentAccountsGetByEnrollmentAccountId_564979(path: JsonNode;
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
  var valid_564981 = path.getOrDefault("billingAccountName")
  valid_564981 = validateParameter(valid_564981, JString, required = true,
                                 default = nil)
  if valid_564981 != nil:
    section.add "billingAccountName", valid_564981
  var valid_564982 = path.getOrDefault("enrollmentAccountName")
  valid_564982 = validateParameter(valid_564982, JString, required = true,
                                 default = nil)
  if valid_564982 != nil:
    section.add "enrollmentAccountName", valid_564982
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
  var valid_564983 = query.getOrDefault("api-version")
  valid_564983 = validateParameter(valid_564983, JString, required = true,
                                 default = nil)
  if valid_564983 != nil:
    section.add "api-version", valid_564983
  var valid_564984 = query.getOrDefault("$expand")
  valid_564984 = validateParameter(valid_564984, JString, required = false,
                                 default = nil)
  if valid_564984 != nil:
    section.add "$expand", valid_564984
  var valid_564985 = query.getOrDefault("$filter")
  valid_564985 = validateParameter(valid_564985, JString, required = false,
                                 default = nil)
  if valid_564985 != nil:
    section.add "$filter", valid_564985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564986: Call_EnrollmentAccountsGetByEnrollmentAccountId_564978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the enrollment account by id.
  ## 
  let valid = call_564986.validator(path, query, header, formData, body)
  let scheme = call_564986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564986.url(scheme.get, call_564986.host, call_564986.base,
                         call_564986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564986, url, valid)

proc call*(call_564987: Call_EnrollmentAccountsGetByEnrollmentAccountId_564978;
          apiVersion: string; billingAccountName: string;
          enrollmentAccountName: string; Expand: string = ""; Filter: string = ""): Recallable =
  ## enrollmentAccountsGetByEnrollmentAccountId
  ## Get the enrollment account by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the Department.
  ##   enrollmentAccountName: string (required)
  ##                        : Enrollment Account Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564988 = newJObject()
  var query_564989 = newJObject()
  add(query_564989, "api-version", newJString(apiVersion))
  add(path_564988, "billingAccountName", newJString(billingAccountName))
  add(query_564989, "$expand", newJString(Expand))
  add(path_564988, "enrollmentAccountName", newJString(enrollmentAccountName))
  add(query_564989, "$filter", newJString(Filter))
  result = call_564987.call(path_564988, query_564989, nil, nil, nil)

var enrollmentAccountsGetByEnrollmentAccountId* = Call_EnrollmentAccountsGetByEnrollmentAccountId_564978(
    name: "enrollmentAccountsGetByEnrollmentAccountId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName}",
    validator: validate_EnrollmentAccountsGetByEnrollmentAccountId_564979,
    base: "", url: url_EnrollmentAccountsGetByEnrollmentAccountId_564980,
    schemes: {Scheme.Https})
type
  Call_InvoicesListByBillingAccount_564990 = ref object of OpenApiRestCall_563565
proc url_InvoicesListByBillingAccount_564992(protocol: Scheme; host: string;
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

proc validate_InvoicesListByBillingAccount_564991(path: JsonNode; query: JsonNode;
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
  var valid_564993 = path.getOrDefault("billingAccountName")
  valid_564993 = validateParameter(valid_564993, JString, required = true,
                                 default = nil)
  if valid_564993 != nil:
    section.add "billingAccountName", valid_564993
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
  var valid_564994 = query.getOrDefault("api-version")
  valid_564994 = validateParameter(valid_564994, JString, required = true,
                                 default = nil)
  if valid_564994 != nil:
    section.add "api-version", valid_564994
  var valid_564995 = query.getOrDefault("periodEndDate")
  valid_564995 = validateParameter(valid_564995, JString, required = true,
                                 default = nil)
  if valid_564995 != nil:
    section.add "periodEndDate", valid_564995
  var valid_564996 = query.getOrDefault("periodStartDate")
  valid_564996 = validateParameter(valid_564996, JString, required = true,
                                 default = nil)
  if valid_564996 != nil:
    section.add "periodStartDate", valid_564996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564997: Call_InvoicesListByBillingAccount_564990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of invoices for a billing account.
  ## 
  let valid = call_564997.validator(path, query, header, formData, body)
  let scheme = call_564997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564997.url(scheme.get, call_564997.host, call_564997.base,
                         call_564997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564997, url, valid)

proc call*(call_564998: Call_InvoicesListByBillingAccount_564990;
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
  var path_564999 = newJObject()
  var query_565000 = newJObject()
  add(query_565000, "api-version", newJString(apiVersion))
  add(path_564999, "billingAccountName", newJString(billingAccountName))
  add(query_565000, "periodEndDate", newJString(periodEndDate))
  add(query_565000, "periodStartDate", newJString(periodStartDate))
  result = call_564998.call(path_564999, query_565000, nil, nil, nil)

var invoicesListByBillingAccount* = Call_InvoicesListByBillingAccount_564990(
    name: "invoicesListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoices",
    validator: validate_InvoicesListByBillingAccount_564991, base: "",
    url: url_InvoicesListByBillingAccount_564992, schemes: {Scheme.Https})
type
  Call_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_565001 = ref object of OpenApiRestCall_563565
proc url_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_565003(
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

proc validate_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_565002(
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
  var valid_565004 = path.getOrDefault("billingAccountName")
  valid_565004 = validateParameter(valid_565004, JString, required = true,
                                 default = nil)
  if valid_565004 != nil:
    section.add "billingAccountName", valid_565004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565005 = query.getOrDefault("api-version")
  valid_565005 = validateParameter(valid_565005, JString, required = true,
                                 default = nil)
  if valid_565005 != nil:
    section.add "api-version", valid_565005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565006: Call_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_565001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoice sections with create subscription permission for a user.
  ## 
  let valid = call_565006.validator(path, query, header, formData, body)
  let scheme = call_565006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565006.url(scheme.get, call_565006.host, call_565006.base,
                         call_565006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565006, url, valid)

proc call*(call_565007: Call_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_565001;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingAccountsListInvoiceSectionsByCreateSubscriptionPermission
  ## Lists all invoice sections with create subscription permission for a user.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_565008 = newJObject()
  var query_565009 = newJObject()
  add(query_565009, "api-version", newJString(apiVersion))
  add(path_565008, "billingAccountName", newJString(billingAccountName))
  result = call_565007.call(path_565008, query_565009, nil, nil, nil)

var billingAccountsListInvoiceSectionsByCreateSubscriptionPermission* = Call_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_565001(
    name: "billingAccountsListInvoiceSectionsByCreateSubscriptionPermission",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/listInvoiceSectionsWithCreateSubscriptionPermission", validator: validate_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_565002,
    base: "",
    url: url_BillingAccountsListInvoiceSectionsByCreateSubscriptionPermission_565003,
    schemes: {Scheme.Https})
type
  Call_PaymentMethodsListByBillingAccount_565010 = ref object of OpenApiRestCall_563565
proc url_PaymentMethodsListByBillingAccount_565012(protocol: Scheme; host: string;
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

proc validate_PaymentMethodsListByBillingAccount_565011(path: JsonNode;
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
  var valid_565013 = path.getOrDefault("billingAccountName")
  valid_565013 = validateParameter(valid_565013, JString, required = true,
                                 default = nil)
  if valid_565013 != nil:
    section.add "billingAccountName", valid_565013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565014 = query.getOrDefault("api-version")
  valid_565014 = validateParameter(valid_565014, JString, required = true,
                                 default = nil)
  if valid_565014 != nil:
    section.add "api-version", valid_565014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565015: Call_PaymentMethodsListByBillingAccount_565010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Payment Methods by billing account Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/2019-10-01-preview/paymentmethods
  let valid = call_565015.validator(path, query, header, formData, body)
  let scheme = call_565015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565015.url(scheme.get, call_565015.host, call_565015.base,
                         call_565015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565015, url, valid)

proc call*(call_565016: Call_PaymentMethodsListByBillingAccount_565010;
          apiVersion: string; billingAccountName: string): Recallable =
  ## paymentMethodsListByBillingAccount
  ## Lists the Payment Methods by billing account Id.
  ## https://docs.microsoft.com/en-us/rest/api/billing/2019-10-01-preview/paymentmethods
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  var path_565017 = newJObject()
  var query_565018 = newJObject()
  add(query_565018, "api-version", newJString(apiVersion))
  add(path_565017, "billingAccountName", newJString(billingAccountName))
  result = call_565016.call(path_565017, query_565018, nil, nil, nil)

var paymentMethodsListByBillingAccount* = Call_PaymentMethodsListByBillingAccount_565010(
    name: "paymentMethodsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/paymentMethods",
    validator: validate_PaymentMethodsListByBillingAccount_565011, base: "",
    url: url_PaymentMethodsListByBillingAccount_565012, schemes: {Scheme.Https})
type
  Call_ProductsListByBillingAccount_565019 = ref object of OpenApiRestCall_563565
proc url_ProductsListByBillingAccount_565021(protocol: Scheme; host: string;
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

proc validate_ProductsListByBillingAccount_565020(path: JsonNode; query: JsonNode;
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
  var valid_565022 = path.getOrDefault("billingAccountName")
  valid_565022 = validateParameter(valid_565022, JString, required = true,
                                 default = nil)
  if valid_565022 != nil:
    section.add "billingAccountName", valid_565022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565023 = query.getOrDefault("api-version")
  valid_565023 = validateParameter(valid_565023, JString, required = true,
                                 default = nil)
  if valid_565023 != nil:
    section.add "api-version", valid_565023
  var valid_565024 = query.getOrDefault("$filter")
  valid_565024 = validateParameter(valid_565024, JString, required = false,
                                 default = nil)
  if valid_565024 != nil:
    section.add "$filter", valid_565024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565025: Call_ProductsListByBillingAccount_565019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists products by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_565025.validator(path, query, header, formData, body)
  let scheme = call_565025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565025.url(scheme.get, call_565025.host, call_565025.base,
                         call_565025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565025, url, valid)

proc call*(call_565026: Call_ProductsListByBillingAccount_565019;
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
  var path_565027 = newJObject()
  var query_565028 = newJObject()
  add(query_565028, "api-version", newJString(apiVersion))
  add(path_565027, "billingAccountName", newJString(billingAccountName))
  add(query_565028, "$filter", newJString(Filter))
  result = call_565026.call(path_565027, query_565028, nil, nil, nil)

var productsListByBillingAccount* = Call_ProductsListByBillingAccount_565019(
    name: "productsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/products",
    validator: validate_ProductsListByBillingAccount_565020, base: "",
    url: url_ProductsListByBillingAccount_565021, schemes: {Scheme.Https})
type
  Call_TransactionsListByBillingAccount_565029 = ref object of OpenApiRestCall_563565
proc url_TransactionsListByBillingAccount_565031(protocol: Scheme; host: string;
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

proc validate_TransactionsListByBillingAccount_565030(path: JsonNode;
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
  var valid_565032 = path.getOrDefault("billingAccountName")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = nil)
  if valid_565032 != nil:
    section.add "billingAccountName", valid_565032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565033 = query.getOrDefault("api-version")
  valid_565033 = validateParameter(valid_565033, JString, required = true,
                                 default = nil)
  if valid_565033 != nil:
    section.add "api-version", valid_565033
  var valid_565034 = query.getOrDefault("endDate")
  valid_565034 = validateParameter(valid_565034, JString, required = true,
                                 default = nil)
  if valid_565034 != nil:
    section.add "endDate", valid_565034
  var valid_565035 = query.getOrDefault("$filter")
  valid_565035 = validateParameter(valid_565035, JString, required = false,
                                 default = nil)
  if valid_565035 != nil:
    section.add "$filter", valid_565035
  var valid_565036 = query.getOrDefault("startDate")
  valid_565036 = validateParameter(valid_565036, JString, required = true,
                                 default = nil)
  if valid_565036 != nil:
    section.add "startDate", valid_565036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565037: Call_TransactionsListByBillingAccount_565029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by billing account name for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_565037.validator(path, query, header, formData, body)
  let scheme = call_565037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565037.url(scheme.get, call_565037.host, call_565037.base,
                         call_565037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565037, url, valid)

proc call*(call_565038: Call_TransactionsListByBillingAccount_565029;
          apiVersion: string; billingAccountName: string; endDate: string;
          startDate: string; Filter: string = ""): Recallable =
  ## transactionsListByBillingAccount
  ## Lists the transactions by billing account name for given start and end date.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   billingAccountName: string (required)
  ##                     : billing Account Id.
  ##   endDate: string (required)
  ##          : End date
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: string (required)
  ##            : Start date
  var path_565039 = newJObject()
  var query_565040 = newJObject()
  add(query_565040, "api-version", newJString(apiVersion))
  add(path_565039, "billingAccountName", newJString(billingAccountName))
  add(query_565040, "endDate", newJString(endDate))
  add(query_565040, "$filter", newJString(Filter))
  add(query_565040, "startDate", newJString(startDate))
  result = call_565038.call(path_565039, query_565040, nil, nil, nil)

var transactionsListByBillingAccount* = Call_TransactionsListByBillingAccount_565029(
    name: "transactionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/transactions",
    validator: validate_TransactionsListByBillingAccount_565030, base: "",
    url: url_TransactionsListByBillingAccount_565031, schemes: {Scheme.Https})
type
  Call_OperationsList_565041 = ref object of OpenApiRestCall_563565
proc url_OperationsList_565043(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_565042(path: JsonNode; query: JsonNode;
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
  var valid_565044 = query.getOrDefault("api-version")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "api-version", valid_565044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565045: Call_OperationsList_565041; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available billing REST API operations.
  ## 
  let valid = call_565045.validator(path, query, header, formData, body)
  let scheme = call_565045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565045.url(scheme.get, call_565045.host, call_565045.base,
                         call_565045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565045, url, valid)

proc call*(call_565046: Call_OperationsList_565041; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available billing REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  var query_565047 = newJObject()
  add(query_565047, "api-version", newJString(apiVersion))
  result = call_565046.call(nil, query_565047, nil, nil, nil)

var operationsList* = Call_OperationsList_565041(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/operations",
    validator: validate_OperationsList_565042, base: "", url: url_OperationsList_565043,
    schemes: {Scheme.Https})
type
  Call_RecipientTransfersList_565048 = ref object of OpenApiRestCall_563565
proc url_RecipientTransfersList_565050(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecipientTransfersList_565049(path: JsonNode; query: JsonNode;
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

proc call*(call_565051: Call_RecipientTransfersList_565048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565051.validator(path, query, header, formData, body)
  let scheme = call_565051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565051.url(scheme.get, call_565051.host, call_565051.base,
                         call_565051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565051, url, valid)

proc call*(call_565052: Call_RecipientTransfersList_565048): Recallable =
  ## recipientTransfersList
  result = call_565052.call(nil, nil, nil, nil, nil)

var recipientTransfersList* = Call_RecipientTransfersList_565048(
    name: "recipientTransfersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers",
    validator: validate_RecipientTransfersList_565049, base: "",
    url: url_RecipientTransfersList_565050, schemes: {Scheme.Https})
type
  Call_RecipientTransfersGet_565053 = ref object of OpenApiRestCall_563565
proc url_RecipientTransfersGet_565055(protocol: Scheme; host: string; base: string;
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

proc validate_RecipientTransfersGet_565054(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_565056 = path.getOrDefault("transferName")
  valid_565056 = validateParameter(valid_565056, JString, required = true,
                                 default = nil)
  if valid_565056 != nil:
    section.add "transferName", valid_565056
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565057: Call_RecipientTransfersGet_565053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565057.validator(path, query, header, formData, body)
  let scheme = call_565057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565057.url(scheme.get, call_565057.host, call_565057.base,
                         call_565057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565057, url, valid)

proc call*(call_565058: Call_RecipientTransfersGet_565053; transferName: string): Recallable =
  ## recipientTransfersGet
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_565059 = newJObject()
  add(path_565059, "transferName", newJString(transferName))
  result = call_565058.call(path_565059, nil, nil, nil, nil)

var recipientTransfersGet* = Call_RecipientTransfersGet_565053(
    name: "recipientTransfersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/transfers/{transferName}",
    validator: validate_RecipientTransfersGet_565054, base: "",
    url: url_RecipientTransfersGet_565055, schemes: {Scheme.Https})
type
  Call_RecipientTransfersAccept_565060 = ref object of OpenApiRestCall_563565
proc url_RecipientTransfersAccept_565062(protocol: Scheme; host: string;
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

proc validate_RecipientTransfersAccept_565061(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_565063 = path.getOrDefault("transferName")
  valid_565063 = validateParameter(valid_565063, JString, required = true,
                                 default = nil)
  if valid_565063 != nil:
    section.add "transferName", valid_565063
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

proc call*(call_565065: Call_RecipientTransfersAccept_565060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565065.validator(path, query, header, formData, body)
  let scheme = call_565065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565065.url(scheme.get, call_565065.host, call_565065.base,
                         call_565065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565065, url, valid)

proc call*(call_565066: Call_RecipientTransfersAccept_565060; transferName: string;
          parameters: JsonNode): Recallable =
  ## recipientTransfersAccept
  ##   transferName: string (required)
  ##               : Transfer Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to accept the transfer.
  var path_565067 = newJObject()
  var body_565068 = newJObject()
  add(path_565067, "transferName", newJString(transferName))
  if parameters != nil:
    body_565068 = parameters
  result = call_565066.call(path_565067, nil, nil, nil, body_565068)

var recipientTransfersAccept* = Call_RecipientTransfersAccept_565060(
    name: "recipientTransfersAccept", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/acceptTransfer",
    validator: validate_RecipientTransfersAccept_565061, base: "",
    url: url_RecipientTransfersAccept_565062, schemes: {Scheme.Https})
type
  Call_RecipientTransfersDecline_565069 = ref object of OpenApiRestCall_563565
proc url_RecipientTransfersDecline_565071(protocol: Scheme; host: string;
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

proc validate_RecipientTransfersDecline_565070(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_565072 = path.getOrDefault("transferName")
  valid_565072 = validateParameter(valid_565072, JString, required = true,
                                 default = nil)
  if valid_565072 != nil:
    section.add "transferName", valid_565072
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565073: Call_RecipientTransfersDecline_565069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565073.validator(path, query, header, formData, body)
  let scheme = call_565073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565073.url(scheme.get, call_565073.host, call_565073.base,
                         call_565073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565073, url, valid)

proc call*(call_565074: Call_RecipientTransfersDecline_565069; transferName: string): Recallable =
  ## recipientTransfersDecline
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_565075 = newJObject()
  add(path_565075, "transferName", newJString(transferName))
  result = call_565074.call(path_565075, nil, nil, nil, nil)

var recipientTransfersDecline* = Call_RecipientTransfersDecline_565069(
    name: "recipientTransfersDecline", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/declineTransfer",
    validator: validate_RecipientTransfersDecline_565070, base: "",
    url: url_RecipientTransfersDecline_565071, schemes: {Scheme.Https})
type
  Call_RecipientTransfersValidate_565076 = ref object of OpenApiRestCall_563565
proc url_RecipientTransfersValidate_565078(protocol: Scheme; host: string;
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

proc validate_RecipientTransfersValidate_565077(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_565079 = path.getOrDefault("transferName")
  valid_565079 = validateParameter(valid_565079, JString, required = true,
                                 default = nil)
  if valid_565079 != nil:
    section.add "transferName", valid_565079
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

proc call*(call_565081: Call_RecipientTransfersValidate_565076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565081.validator(path, query, header, formData, body)
  let scheme = call_565081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565081.url(scheme.get, call_565081.host, call_565081.base,
                         call_565081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565081, url, valid)

proc call*(call_565082: Call_RecipientTransfersValidate_565076;
          transferName: string; parameters: JsonNode): Recallable =
  ## recipientTransfersValidate
  ##   transferName: string (required)
  ##               : Transfer Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to validate the transfer.
  var path_565083 = newJObject()
  var body_565084 = newJObject()
  add(path_565083, "transferName", newJString(transferName))
  if parameters != nil:
    body_565084 = parameters
  result = call_565082.call(path_565083, nil, nil, nil, body_565084)

var recipientTransfersValidate* = Call_RecipientTransfersValidate_565076(
    name: "recipientTransfersValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/validateTransfer",
    validator: validate_RecipientTransfersValidate_565077, base: "",
    url: url_RecipientTransfersValidate_565078, schemes: {Scheme.Https})
type
  Call_AddressValidate_565085 = ref object of OpenApiRestCall_563565
proc url_AddressValidate_565087(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AddressValidate_565086(path: JsonNode; query: JsonNode;
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
  var valid_565088 = query.getOrDefault("api-version")
  valid_565088 = validateParameter(valid_565088, JString, required = true,
                                 default = nil)
  if valid_565088 != nil:
    section.add "api-version", valid_565088
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

proc call*(call_565090: Call_AddressValidate_565085; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the address.
  ## 
  let valid = call_565090.validator(path, query, header, formData, body)
  let scheme = call_565090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565090.url(scheme.get, call_565090.host, call_565090.base,
                         call_565090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565090, url, valid)

proc call*(call_565091: Call_AddressValidate_565085; apiVersion: string;
          address: JsonNode): Recallable =
  ## addressValidate
  ## Validates the address.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   address: JObject (required)
  var query_565092 = newJObject()
  var body_565093 = newJObject()
  add(query_565092, "api-version", newJString(apiVersion))
  if address != nil:
    body_565093 = address
  result = call_565091.call(nil, query_565092, nil, nil, body_565093)

var addressValidate* = Call_AddressValidate_565085(name: "addressValidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/validateAddress",
    validator: validate_AddressValidate_565086, base: "", url: url_AddressValidate_565087,
    schemes: {Scheme.Https})
type
  Call_LineOfCreditsUpdate_565103 = ref object of OpenApiRestCall_563565
proc url_LineOfCreditsUpdate_565105(protocol: Scheme; host: string; base: string;
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

proc validate_LineOfCreditsUpdate_565104(path: JsonNode; query: JsonNode;
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
  var valid_565106 = path.getOrDefault("subscriptionId")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "subscriptionId", valid_565106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565107 = query.getOrDefault("api-version")
  valid_565107 = validateParameter(valid_565107, JString, required = true,
                                 default = nil)
  if valid_565107 != nil:
    section.add "api-version", valid_565107
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

proc call*(call_565109: Call_LineOfCreditsUpdate_565103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Increase the current line of credit.
  ## 
  let valid = call_565109.validator(path, query, header, formData, body)
  let scheme = call_565109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565109.url(scheme.get, call_565109.host, call_565109.base,
                         call_565109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565109, url, valid)

proc call*(call_565110: Call_LineOfCreditsUpdate_565103; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## lineOfCreditsUpdate
  ## Increase the current line of credit.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the increase line of credit operation.
  var path_565111 = newJObject()
  var query_565112 = newJObject()
  var body_565113 = newJObject()
  add(query_565112, "api-version", newJString(apiVersion))
  add(path_565111, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_565113 = parameters
  result = call_565110.call(path_565111, query_565112, nil, nil, body_565113)

var lineOfCreditsUpdate* = Call_LineOfCreditsUpdate_565103(
    name: "lineOfCreditsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default",
    validator: validate_LineOfCreditsUpdate_565104, base: "",
    url: url_LineOfCreditsUpdate_565105, schemes: {Scheme.Https})
type
  Call_LineOfCreditsGet_565094 = ref object of OpenApiRestCall_563565
proc url_LineOfCreditsGet_565096(protocol: Scheme; host: string; base: string;
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

proc validate_LineOfCreditsGet_565095(path: JsonNode; query: JsonNode;
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
  var valid_565097 = path.getOrDefault("subscriptionId")
  valid_565097 = validateParameter(valid_565097, JString, required = true,
                                 default = nil)
  if valid_565097 != nil:
    section.add "subscriptionId", valid_565097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565098 = query.getOrDefault("api-version")
  valid_565098 = validateParameter(valid_565098, JString, required = true,
                                 default = nil)
  if valid_565098 != nil:
    section.add "api-version", valid_565098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565099: Call_LineOfCreditsGet_565094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the current line of credit.
  ## 
  let valid = call_565099.validator(path, query, header, formData, body)
  let scheme = call_565099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565099.url(scheme.get, call_565099.host, call_565099.base,
                         call_565099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565099, url, valid)

proc call*(call_565100: Call_LineOfCreditsGet_565094; apiVersion: string;
          subscriptionId: string): Recallable =
  ## lineOfCreditsGet
  ## Get the current line of credit.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_565101 = newJObject()
  var query_565102 = newJObject()
  add(query_565102, "api-version", newJString(apiVersion))
  add(path_565101, "subscriptionId", newJString(subscriptionId))
  result = call_565100.call(path_565101, query_565102, nil, nil, nil)

var lineOfCreditsGet* = Call_LineOfCreditsGet_565094(name: "lineOfCreditsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default",
    validator: validate_LineOfCreditsGet_565095, base: "",
    url: url_LineOfCreditsGet_565096, schemes: {Scheme.Https})
type
  Call_BillingPropertyGet_565114 = ref object of OpenApiRestCall_563565
proc url_BillingPropertyGet_565116(protocol: Scheme; host: string; base: string;
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

proc validate_BillingPropertyGet_565115(path: JsonNode; query: JsonNode;
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
  var valid_565117 = path.getOrDefault("subscriptionId")
  valid_565117 = validateParameter(valid_565117, JString, required = true,
                                 default = nil)
  if valid_565117 != nil:
    section.add "subscriptionId", valid_565117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565118 = query.getOrDefault("api-version")
  valid_565118 = validateParameter(valid_565118, JString, required = true,
                                 default = nil)
  if valid_565118 != nil:
    section.add "api-version", valid_565118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565119: Call_BillingPropertyGet_565114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get billing property by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  let valid = call_565119.validator(path, query, header, formData, body)
  let scheme = call_565119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565119.url(scheme.get, call_565119.host, call_565119.base,
                         call_565119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565119, url, valid)

proc call*(call_565120: Call_BillingPropertyGet_565114; apiVersion: string;
          subscriptionId: string): Recallable =
  ## billingPropertyGet
  ## Get billing property by subscription Id.
  ## https://docs.microsoft.com/en-us/rest/api/billing/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-10-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_565121 = newJObject()
  var query_565122 = newJObject()
  add(query_565122, "api-version", newJString(apiVersion))
  add(path_565121, "subscriptionId", newJString(subscriptionId))
  result = call_565120.call(path_565121, query_565122, nil, nil, nil)

var billingPropertyGet* = Call_BillingPropertyGet_565114(
    name: "billingPropertyGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingProperty/default",
    validator: validate_BillingPropertyGet_565115, base: "",
    url: url_BillingPropertyGet_565116, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
