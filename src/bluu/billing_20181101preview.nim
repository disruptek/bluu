
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  ## Lists all billing accounts for which a user has access.
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
  ## Lists all billing accounts for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections and billingProfiles.
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
  ##                     : Billing Account Id.
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
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections and billingProfiles.
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
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections and billingProfiles.
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
  ##                     : Billing Account Id.
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
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
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
  ##             : Parameters supplied to the update billing account operation.
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
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update billing account operation.
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
  Call_AgreementsListByBillingAccountName_564139 = ref object of OpenApiRestCall_563565
proc url_AgreementsListByBillingAccountName_564141(protocol: Scheme; host: string;
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

proc validate_AgreementsListByBillingAccountName_564140(path: JsonNode;
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
  var valid_564142 = path.getOrDefault("billingAccountName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "billingAccountName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
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

proc call*(call_564145: Call_AgreementsListByBillingAccountName_564139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_564146: Call_AgreementsListByBillingAccountName_564139;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## agreementsListByBillingAccountName
  ## Lists all agreements for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the participants.
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  add(query_564148, "api-version", newJString(apiVersion))
  add(path_564147, "billingAccountName", newJString(billingAccountName))
  add(query_564148, "$expand", newJString(Expand))
  result = call_564146.call(path_564147, query_564148, nil, nil, nil)

var agreementsListByBillingAccountName* = Call_AgreementsListByBillingAccountName_564139(
    name: "agreementsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/agreements",
    validator: validate_AgreementsListByBillingAccountName_564140, base: "",
    url: url_AgreementsListByBillingAccountName_564141, schemes: {Scheme.Https})
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
  ##                     : Billing Account Id.
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
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
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
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
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
  Call_BillingProfilesCreate_564170 = ref object of OpenApiRestCall_563565
proc url_BillingProfilesCreate_564172(protocol: Scheme; host: string; base: string;
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

proc validate_BillingProfilesCreate_564171(path: JsonNode; query: JsonNode;
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
  var valid_564173 = path.getOrDefault("billingAccountName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "billingAccountName", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564174 = query.getOrDefault("api-version")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "api-version", valid_564174
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

proc call*(call_564176: Call_BillingProfilesCreate_564170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a BillingProfile.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_BillingProfilesCreate_564170; apiVersion: string;
          billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingProfilesCreate
  ## The operation to create a BillingProfile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create BillingProfile operation.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  var body_564180 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_564180 = parameters
  result = call_564177.call(path_564178, query_564179, nil, nil, body_564180)

var billingProfilesCreate* = Call_BillingProfilesCreate_564170(
    name: "billingProfilesCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles",
    validator: validate_BillingProfilesCreate_564171, base: "",
    url: url_BillingProfilesCreate_564172, schemes: {Scheme.Https})
type
  Call_BillingProfilesListByBillingAccountName_564160 = ref object of OpenApiRestCall_563565
proc url_BillingProfilesListByBillingAccountName_564162(protocol: Scheme;
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

proc validate_BillingProfilesListByBillingAccountName_564161(path: JsonNode;
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
  var valid_564163 = path.getOrDefault("billingAccountName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "billingAccountName", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  var valid_564165 = query.getOrDefault("$expand")
  valid_564165 = validateParameter(valid_564165, JString, required = false,
                                 default = nil)
  if valid_564165 != nil:
    section.add "$expand", valid_564165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564166: Call_BillingProfilesListByBillingAccountName_564160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing profiles for a user which that user has access to.
  ## 
  let valid = call_564166.validator(path, query, header, formData, body)
  let scheme = call_564166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564166.url(scheme.get, call_564166.host, call_564166.base,
                         call_564166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564166, url, valid)

proc call*(call_564167: Call_BillingProfilesListByBillingAccountName_564160;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## billingProfilesListByBillingAccountName
  ## Lists all billing profiles for a user which that user has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections.
  var path_564168 = newJObject()
  var query_564169 = newJObject()
  add(query_564169, "api-version", newJString(apiVersion))
  add(path_564168, "billingAccountName", newJString(billingAccountName))
  add(query_564169, "$expand", newJString(Expand))
  result = call_564167.call(path_564168, query_564169, nil, nil, nil)

var billingProfilesListByBillingAccountName* = Call_BillingProfilesListByBillingAccountName_564160(
    name: "billingProfilesListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles",
    validator: validate_BillingProfilesListByBillingAccountName_564161, base: "",
    url: url_BillingProfilesListByBillingAccountName_564162,
    schemes: {Scheme.Https})
type
  Call_BillingProfilesUpdate_564192 = ref object of OpenApiRestCall_563565
proc url_BillingProfilesUpdate_564194(protocol: Scheme; host: string; base: string;
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

proc validate_BillingProfilesUpdate_564193(path: JsonNode; query: JsonNode;
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
  var valid_564195 = path.getOrDefault("billingAccountName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "billingAccountName", valid_564195
  var valid_564196 = path.getOrDefault("billingProfileName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "billingProfileName", valid_564196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564197 = query.getOrDefault("api-version")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "api-version", valid_564197
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

proc call*(call_564199: Call_BillingProfilesUpdate_564192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a billing profile.
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_BillingProfilesUpdate_564192; apiVersion: string;
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
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  var body_564203 = newJObject()
  add(query_564202, "api-version", newJString(apiVersion))
  add(path_564201, "billingAccountName", newJString(billingAccountName))
  add(path_564201, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564203 = parameters
  result = call_564200.call(path_564201, query_564202, nil, nil, body_564203)

var billingProfilesUpdate* = Call_BillingProfilesUpdate_564192(
    name: "billingProfilesUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesUpdate_564193, base: "",
    url: url_BillingProfilesUpdate_564194, schemes: {Scheme.Https})
type
  Call_BillingProfilesGet_564181 = ref object of OpenApiRestCall_563565
proc url_BillingProfilesGet_564183(protocol: Scheme; host: string; base: string;
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

proc validate_BillingProfilesGet_564182(path: JsonNode; query: JsonNode;
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
  var valid_564184 = path.getOrDefault("billingAccountName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "billingAccountName", valid_564184
  var valid_564185 = path.getOrDefault("billingProfileName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "billingProfileName", valid_564185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "api-version", valid_564186
  var valid_564187 = query.getOrDefault("$expand")
  valid_564187 = validateParameter(valid_564187, JString, required = false,
                                 default = nil)
  if valid_564187 != nil:
    section.add "$expand", valid_564187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_BillingProfilesGet_564181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the billing profile by id.
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_BillingProfilesGet_564181; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          Expand: string = ""): Recallable =
  ## billingProfilesGet
  ## Get the billing profile by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "billingAccountName", newJString(billingAccountName))
  add(query_564191, "$expand", newJString(Expand))
  add(path_564190, "billingProfileName", newJString(billingProfileName))
  result = call_564189.call(path_564190, query_564191, nil, nil, nil)

var billingProfilesGet* = Call_BillingProfilesGet_564181(
    name: "billingProfilesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesGet_564182, base: "",
    url: url_BillingProfilesGet_564183, schemes: {Scheme.Https})
type
  Call_AvailableBalancesGetByBillingProfile_564204 = ref object of OpenApiRestCall_563565
proc url_AvailableBalancesGetByBillingProfile_564206(protocol: Scheme;
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

proc validate_AvailableBalancesGetByBillingProfile_564205(path: JsonNode;
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
  var valid_564207 = path.getOrDefault("billingAccountName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "billingAccountName", valid_564207
  var valid_564208 = path.getOrDefault("billingProfileName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "billingProfileName", valid_564208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564209 = query.getOrDefault("api-version")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "api-version", valid_564209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564210: Call_AvailableBalancesGetByBillingProfile_564204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ## 
  let valid = call_564210.validator(path, query, header, formData, body)
  let scheme = call_564210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564210.url(scheme.get, call_564210.host, call_564210.base,
                         call_564210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564210, url, valid)

proc call*(call_564211: Call_AvailableBalancesGetByBillingProfile_564204;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## availableBalancesGetByBillingProfile
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564212 = newJObject()
  var query_564213 = newJObject()
  add(query_564213, "api-version", newJString(apiVersion))
  add(path_564212, "billingAccountName", newJString(billingAccountName))
  add(path_564212, "billingProfileName", newJString(billingProfileName))
  result = call_564211.call(path_564212, query_564213, nil, nil, nil)

var availableBalancesGetByBillingProfile* = Call_AvailableBalancesGetByBillingProfile_564204(
    name: "availableBalancesGetByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/availableBalance/default",
    validator: validate_AvailableBalancesGetByBillingProfile_564205, base: "",
    url: url_AvailableBalancesGetByBillingProfile_564206, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByBillingProfileName_564214 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsListByBillingProfileName_564216(protocol: Scheme;
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

proc validate_BillingSubscriptionsListByBillingProfileName_564215(path: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
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

proc call*(call_564220: Call_BillingSubscriptionsListByBillingProfileName_564214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscriptions by billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_BillingSubscriptionsListByBillingProfileName_564214;
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
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "billingAccountName", newJString(billingAccountName))
  add(path_564222, "billingProfileName", newJString(billingProfileName))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var billingSubscriptionsListByBillingProfileName* = Call_BillingSubscriptionsListByBillingProfileName_564214(
    name: "billingSubscriptionsListByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByBillingProfileName_564215,
    base: "", url: url_BillingSubscriptionsListByBillingProfileName_564216,
    schemes: {Scheme.Https})
type
  Call_InvoiceSectionsListByBillingProfileName_564224 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsListByBillingProfileName_564226(protocol: Scheme;
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

proc validate_InvoiceSectionsListByBillingProfileName_564225(path: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
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

proc call*(call_564230: Call_InvoiceSectionsListByBillingProfileName_564224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoice sections under a billing profile for which a user has access.
  ## 
  let valid = call_564230.validator(path, query, header, formData, body)
  let scheme = call_564230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564230.url(scheme.get, call_564230.host, call_564230.base,
                         call_564230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564230, url, valid)

proc call*(call_564231: Call_InvoiceSectionsListByBillingProfileName_564224;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## invoiceSectionsListByBillingProfileName
  ## Lists all invoice sections under a billing profile for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564232 = newJObject()
  var query_564233 = newJObject()
  add(query_564233, "api-version", newJString(apiVersion))
  add(path_564232, "billingAccountName", newJString(billingAccountName))
  add(path_564232, "billingProfileName", newJString(billingProfileName))
  result = call_564231.call(path_564232, query_564233, nil, nil, nil)

var invoiceSectionsListByBillingProfileName* = Call_InvoiceSectionsListByBillingProfileName_564224(
    name: "invoiceSectionsListByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections",
    validator: validate_InvoiceSectionsListByBillingProfileName_564225, base: "",
    url: url_InvoiceSectionsListByBillingProfileName_564226,
    schemes: {Scheme.Https})
type
  Call_InvoicesListByBillingProfile_564234 = ref object of OpenApiRestCall_563565
proc url_InvoicesListByBillingProfile_564236(protocol: Scheme; host: string;
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

proc validate_InvoicesListByBillingProfile_564235(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   periodEndDate: JString (required)
  ##                : Invoice period end date.
  ##   periodStartDate: JString (required)
  ##                  : Invoice period start date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564239 = query.getOrDefault("api-version")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "api-version", valid_564239
  var valid_564240 = query.getOrDefault("periodEndDate")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "periodEndDate", valid_564240
  var valid_564241 = query.getOrDefault("periodStartDate")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "periodStartDate", valid_564241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564242: Call_InvoicesListByBillingProfile_564234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of invoices for a billing profile.
  ## 
  let valid = call_564242.validator(path, query, header, formData, body)
  let scheme = call_564242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564242.url(scheme.get, call_564242.host, call_564242.base,
                         call_564242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564242, url, valid)

proc call*(call_564243: Call_InvoicesListByBillingProfile_564234;
          apiVersion: string; billingAccountName: string; periodEndDate: string;
          billingProfileName: string; periodStartDate: string): Recallable =
  ## invoicesListByBillingProfile
  ## List of invoices for a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   periodEndDate: string (required)
  ##                : Invoice period end date.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   periodStartDate: string (required)
  ##                  : Invoice period start date.
  var path_564244 = newJObject()
  var query_564245 = newJObject()
  add(query_564245, "api-version", newJString(apiVersion))
  add(path_564244, "billingAccountName", newJString(billingAccountName))
  add(query_564245, "periodEndDate", newJString(periodEndDate))
  add(path_564244, "billingProfileName", newJString(billingProfileName))
  add(query_564245, "periodStartDate", newJString(periodStartDate))
  result = call_564243.call(path_564244, query_564245, nil, nil, nil)

var invoicesListByBillingProfile* = Call_InvoicesListByBillingProfile_564234(
    name: "invoicesListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices",
    validator: validate_InvoicesListByBillingProfile_564235, base: "",
    url: url_InvoicesListByBillingProfile_564236, schemes: {Scheme.Https})
type
  Call_InvoicesGet_564246 = ref object of OpenApiRestCall_563565
proc url_InvoicesGet_564248(protocol: Scheme; host: string; base: string;
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

proc validate_InvoicesGet_564247(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564249 = path.getOrDefault("billingAccountName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "billingAccountName", valid_564249
  var valid_564250 = path.getOrDefault("invoiceName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "invoiceName", valid_564250
  var valid_564251 = path.getOrDefault("billingProfileName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "billingProfileName", valid_564251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564252 = query.getOrDefault("api-version")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "api-version", valid_564252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564253: Call_InvoicesGet_564246; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the invoice by name.
  ## 
  let valid = call_564253.validator(path, query, header, formData, body)
  let scheme = call_564253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564253.url(scheme.get, call_564253.host, call_564253.base,
                         call_564253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564253, url, valid)

proc call*(call_564254: Call_InvoicesGet_564246; apiVersion: string;
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
  var path_564255 = newJObject()
  var query_564256 = newJObject()
  add(query_564256, "api-version", newJString(apiVersion))
  add(path_564255, "billingAccountName", newJString(billingAccountName))
  add(path_564255, "invoiceName", newJString(invoiceName))
  add(path_564255, "billingProfileName", newJString(billingProfileName))
  result = call_564254.call(path_564255, query_564256, nil, nil, nil)

var invoicesGet* = Call_InvoicesGet_564246(name: "invoicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices/{invoiceName}",
                                        validator: validate_InvoicesGet_564247,
                                        base: "", url: url_InvoicesGet_564248,
                                        schemes: {Scheme.Https})
type
  Call_PaymentMethodsListByBillingProfileName_564257 = ref object of OpenApiRestCall_563565
proc url_PaymentMethodsListByBillingProfileName_564259(protocol: Scheme;
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

proc validate_PaymentMethodsListByBillingProfileName_564258(path: JsonNode;
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
  var valid_564260 = path.getOrDefault("billingAccountName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "billingAccountName", valid_564260
  var valid_564261 = path.getOrDefault("billingProfileName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "billingProfileName", valid_564261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564262 = query.getOrDefault("api-version")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "api-version", valid_564262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564263: Call_PaymentMethodsListByBillingProfileName_564257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Payment Methods by billing profile Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_PaymentMethodsListByBillingProfileName_564257;
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
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  add(query_564266, "api-version", newJString(apiVersion))
  add(path_564265, "billingAccountName", newJString(billingAccountName))
  add(path_564265, "billingProfileName", newJString(billingProfileName))
  result = call_564264.call(path_564265, query_564266, nil, nil, nil)

var paymentMethodsListByBillingProfileName* = Call_PaymentMethodsListByBillingProfileName_564257(
    name: "paymentMethodsListByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/paymentMethods",
    validator: validate_PaymentMethodsListByBillingProfileName_564258, base: "",
    url: url_PaymentMethodsListByBillingProfileName_564259,
    schemes: {Scheme.Https})
type
  Call_PoliciesUpdate_564277 = ref object of OpenApiRestCall_563565
proc url_PoliciesUpdate_564279(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesUpdate_564278(path: JsonNode; query: JsonNode;
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
  var valid_564280 = path.getOrDefault("billingAccountName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "billingAccountName", valid_564280
  var valid_564281 = path.getOrDefault("billingProfileName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "billingProfileName", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564284: Call_PoliciesUpdate_564277; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a policy.
  ## 
  let valid = call_564284.validator(path, query, header, formData, body)
  let scheme = call_564284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564284.url(scheme.get, call_564284.host, call_564284.base,
                         call_564284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564284, url, valid)

proc call*(call_564285: Call_PoliciesUpdate_564277; apiVersion: string;
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
  var path_564286 = newJObject()
  var query_564287 = newJObject()
  var body_564288 = newJObject()
  add(query_564287, "api-version", newJString(apiVersion))
  add(path_564286, "billingAccountName", newJString(billingAccountName))
  add(path_564286, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564288 = parameters
  result = call_564285.call(path_564286, query_564287, nil, nil, body_564288)

var policiesUpdate* = Call_PoliciesUpdate_564277(name: "policiesUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/policies/default",
    validator: validate_PoliciesUpdate_564278, base: "", url: url_PoliciesUpdate_564279,
    schemes: {Scheme.Https})
type
  Call_PoliciesGetByBillingProfileName_564267 = ref object of OpenApiRestCall_563565
proc url_PoliciesGetByBillingProfileName_564269(protocol: Scheme; host: string;
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

proc validate_PoliciesGetByBillingProfileName_564268(path: JsonNode;
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
  var valid_564270 = path.getOrDefault("billingAccountName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "billingAccountName", valid_564270
  var valid_564271 = path.getOrDefault("billingProfileName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "billingProfileName", valid_564271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564272 = query.getOrDefault("api-version")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "api-version", valid_564272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564273: Call_PoliciesGetByBillingProfileName_564267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The policy for a given billing account name and billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564273.validator(path, query, header, formData, body)
  let scheme = call_564273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564273.url(scheme.get, call_564273.host, call_564273.base,
                         call_564273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564273, url, valid)

proc call*(call_564274: Call_PoliciesGetByBillingProfileName_564267;
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
  var path_564275 = newJObject()
  var query_564276 = newJObject()
  add(query_564276, "api-version", newJString(apiVersion))
  add(path_564275, "billingAccountName", newJString(billingAccountName))
  add(path_564275, "billingProfileName", newJString(billingProfileName))
  result = call_564274.call(path_564275, query_564276, nil, nil, nil)

var policiesGetByBillingProfileName* = Call_PoliciesGetByBillingProfileName_564267(
    name: "policiesGetByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/policies/default",
    validator: validate_PoliciesGetByBillingProfileName_564268, base: "",
    url: url_PoliciesGetByBillingProfileName_564269, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByBillingProfile_564289 = ref object of OpenApiRestCall_563565
proc url_BillingPermissionsListByBillingProfile_564291(protocol: Scheme;
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

proc validate_BillingPermissionsListByBillingProfile_564290(path: JsonNode;
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
  var valid_564292 = path.getOrDefault("billingAccountName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "billingAccountName", valid_564292
  var valid_564293 = path.getOrDefault("billingProfileName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "billingProfileName", valid_564293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564294 = query.getOrDefault("api-version")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "api-version", valid_564294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564295: Call_BillingPermissionsListByBillingProfile_564289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billingPermissions for the caller has for a billing account.
  ## 
  let valid = call_564295.validator(path, query, header, formData, body)
  let scheme = call_564295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564295.url(scheme.get, call_564295.host, call_564295.base,
                         call_564295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564295, url, valid)

proc call*(call_564296: Call_BillingPermissionsListByBillingProfile_564289;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingPermissionsListByBillingProfile
  ## Lists all billingPermissions for the caller has for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564297 = newJObject()
  var query_564298 = newJObject()
  add(query_564298, "api-version", newJString(apiVersion))
  add(path_564297, "billingAccountName", newJString(billingAccountName))
  add(path_564297, "billingProfileName", newJString(billingProfileName))
  result = call_564296.call(path_564297, query_564298, nil, nil, nil)

var billingPermissionsListByBillingProfile* = Call_BillingPermissionsListByBillingProfile_564289(
    name: "billingPermissionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByBillingProfile_564290, base: "",
    url: url_BillingPermissionsListByBillingProfile_564291,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByBillingProfileName_564299 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsListByBillingProfileName_564301(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsListByBillingProfileName_564300(
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
  var valid_564302 = path.getOrDefault("billingAccountName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "billingAccountName", valid_564302
  var valid_564303 = path.getOrDefault("billingProfileName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "billingProfileName", valid_564303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564304 = query.getOrDefault("api-version")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "api-version", valid_564304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564305: Call_BillingRoleAssignmentsListByBillingProfileName_564299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the Billing Profile
  ## 
  let valid = call_564305.validator(path, query, header, formData, body)
  let scheme = call_564305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564305.url(scheme.get, call_564305.host, call_564305.base,
                         call_564305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564305, url, valid)

proc call*(call_564306: Call_BillingRoleAssignmentsListByBillingProfileName_564299;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsListByBillingProfileName
  ## Get the role assignments on the Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564307 = newJObject()
  var query_564308 = newJObject()
  add(query_564308, "api-version", newJString(apiVersion))
  add(path_564307, "billingAccountName", newJString(billingAccountName))
  add(path_564307, "billingProfileName", newJString(billingProfileName))
  result = call_564306.call(path_564307, query_564308, nil, nil, nil)

var billingRoleAssignmentsListByBillingProfileName* = Call_BillingRoleAssignmentsListByBillingProfileName_564299(
    name: "billingRoleAssignmentsListByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByBillingProfileName_564300,
    base: "", url: url_BillingRoleAssignmentsListByBillingProfileName_564301,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByBillingProfileName_564309 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsGetByBillingProfileName_564311(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsGetByBillingProfileName_564310(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignment for the caller on the Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
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
  var valid_564313 = path.getOrDefault("billingRoleAssignmentName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "billingRoleAssignmentName", valid_564313
  var valid_564314 = path.getOrDefault("billingProfileName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "billingProfileName", valid_564314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564315 = query.getOrDefault("api-version")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "api-version", valid_564315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564316: Call_BillingRoleAssignmentsGetByBillingProfileName_564309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller on the Billing Profile
  ## 
  let valid = call_564316.validator(path, query, header, formData, body)
  let scheme = call_564316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564316.url(scheme.get, call_564316.host, call_564316.base,
                         call_564316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564316, url, valid)

proc call*(call_564317: Call_BillingRoleAssignmentsGetByBillingProfileName_564309;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsGetByBillingProfileName
  ## Get the role assignment for the caller on the Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564318 = newJObject()
  var query_564319 = newJObject()
  add(query_564319, "api-version", newJString(apiVersion))
  add(path_564318, "billingAccountName", newJString(billingAccountName))
  add(path_564318, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_564318, "billingProfileName", newJString(billingProfileName))
  result = call_564317.call(path_564318, query_564319, nil, nil, nil)

var billingRoleAssignmentsGetByBillingProfileName* = Call_BillingRoleAssignmentsGetByBillingProfileName_564309(
    name: "billingRoleAssignmentsGetByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByBillingProfileName_564310,
    base: "", url: url_BillingRoleAssignmentsGetByBillingProfileName_564311,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByBillingProfileName_564320 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsDeleteByBillingProfileName_564322(
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

proc validate_BillingRoleAssignmentsDeleteByBillingProfileName_564321(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete the role assignment on this Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564323 = path.getOrDefault("billingAccountName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "billingAccountName", valid_564323
  var valid_564324 = path.getOrDefault("billingRoleAssignmentName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "billingRoleAssignmentName", valid_564324
  var valid_564325 = path.getOrDefault("billingProfileName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "billingProfileName", valid_564325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564326 = query.getOrDefault("api-version")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "api-version", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_BillingRoleAssignmentsDeleteByBillingProfileName_564320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on this Billing Profile
  ## 
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_BillingRoleAssignmentsDeleteByBillingProfileName_564320;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsDeleteByBillingProfileName
  ## Delete the role assignment on this Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  add(query_564330, "api-version", newJString(apiVersion))
  add(path_564329, "billingAccountName", newJString(billingAccountName))
  add(path_564329, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_564329, "billingProfileName", newJString(billingProfileName))
  result = call_564328.call(path_564329, query_564330, nil, nil, nil)

var billingRoleAssignmentsDeleteByBillingProfileName* = Call_BillingRoleAssignmentsDeleteByBillingProfileName_564320(
    name: "billingRoleAssignmentsDeleteByBillingProfileName",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByBillingProfileName_564321,
    base: "", url: url_BillingRoleAssignmentsDeleteByBillingProfileName_564322,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByBillingProfileName_564331 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsListByBillingProfileName_564333(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsListByBillingProfileName_564332(
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
  var valid_564334 = path.getOrDefault("billingAccountName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "billingAccountName", valid_564334
  var valid_564335 = path.getOrDefault("billingProfileName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "billingProfileName", valid_564335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564336 = query.getOrDefault("api-version")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "api-version", valid_564336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564337: Call_BillingRoleDefinitionsListByBillingProfileName_564331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for a Billing Profile
  ## 
  let valid = call_564337.validator(path, query, header, formData, body)
  let scheme = call_564337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564337.url(scheme.get, call_564337.host, call_564337.base,
                         call_564337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564337, url, valid)

proc call*(call_564338: Call_BillingRoleDefinitionsListByBillingProfileName_564331;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleDefinitionsListByBillingProfileName
  ## Lists the role definition for a Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564339 = newJObject()
  var query_564340 = newJObject()
  add(query_564340, "api-version", newJString(apiVersion))
  add(path_564339, "billingAccountName", newJString(billingAccountName))
  add(path_564339, "billingProfileName", newJString(billingProfileName))
  result = call_564338.call(path_564339, query_564340, nil, nil, nil)

var billingRoleDefinitionsListByBillingProfileName* = Call_BillingRoleDefinitionsListByBillingProfileName_564331(
    name: "billingRoleDefinitionsListByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByBillingProfileName_564332,
    base: "", url: url_BillingRoleDefinitionsListByBillingProfileName_564333,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByBillingProfileName_564341 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsGetByBillingProfileName_564343(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsGetByBillingProfileName_564342(
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
  var valid_564344 = path.getOrDefault("billingAccountName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "billingAccountName", valid_564344
  var valid_564345 = path.getOrDefault("billingRoleDefinitionName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "billingRoleDefinitionName", valid_564345
  var valid_564346 = path.getOrDefault("billingProfileName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "billingProfileName", valid_564346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564347 = query.getOrDefault("api-version")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "api-version", valid_564347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564348: Call_BillingRoleDefinitionsGetByBillingProfileName_564341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_564348.validator(path, query, header, formData, body)
  let scheme = call_564348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564348.url(scheme.get, call_564348.host, call_564348.base,
                         call_564348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564348, url, valid)

proc call*(call_564349: Call_BillingRoleDefinitionsGetByBillingProfileName_564341;
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
  var path_564350 = newJObject()
  var query_564351 = newJObject()
  add(query_564351, "api-version", newJString(apiVersion))
  add(path_564350, "billingAccountName", newJString(billingAccountName))
  add(path_564350, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  add(path_564350, "billingProfileName", newJString(billingProfileName))
  result = call_564349.call(path_564350, query_564351, nil, nil, nil)

var billingRoleDefinitionsGetByBillingProfileName* = Call_BillingRoleDefinitionsGetByBillingProfileName_564341(
    name: "billingRoleDefinitionsGetByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByBillingProfileName_564342,
    base: "", url: url_BillingRoleDefinitionsGetByBillingProfileName_564343,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByBillingProfileName_564352 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsAddByBillingProfileName_564354(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsAddByBillingProfileName_564353(
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
  var valid_564355 = path.getOrDefault("billingAccountName")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "billingAccountName", valid_564355
  var valid_564356 = path.getOrDefault("billingProfileName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "billingProfileName", valid_564356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564357 = query.getOrDefault("api-version")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "api-version", valid_564357
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

proc call*(call_564359: Call_BillingRoleAssignmentsAddByBillingProfileName_564352;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a billing profile.
  ## 
  let valid = call_564359.validator(path, query, header, formData, body)
  let scheme = call_564359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564359.url(scheme.get, call_564359.host, call_564359.base,
                         call_564359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564359, url, valid)

proc call*(call_564360: Call_BillingRoleAssignmentsAddByBillingProfileName_564352;
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
  var path_564361 = newJObject()
  var query_564362 = newJObject()
  var body_564363 = newJObject()
  add(query_564362, "api-version", newJString(apiVersion))
  add(path_564361, "billingAccountName", newJString(billingAccountName))
  add(path_564361, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_564363 = parameters
  result = call_564360.call(path_564361, query_564362, nil, nil, body_564363)

var billingRoleAssignmentsAddByBillingProfileName* = Call_BillingRoleAssignmentsAddByBillingProfileName_564352(
    name: "billingRoleAssignmentsAddByBillingProfileName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByBillingProfileName_564353,
    base: "", url: url_BillingRoleAssignmentsAddByBillingProfileName_564354,
    schemes: {Scheme.Https})
type
  Call_TransactionsListByBillingProfileName_564364 = ref object of OpenApiRestCall_563565
proc url_TransactionsListByBillingProfileName_564366(protocol: Scheme;
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

proc validate_TransactionsListByBillingProfileName_564365(path: JsonNode;
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
  var valid_564367 = path.getOrDefault("billingAccountName")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "billingAccountName", valid_564367
  var valid_564368 = path.getOrDefault("billingProfileName")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "billingProfileName", valid_564368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564369 = query.getOrDefault("api-version")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "api-version", valid_564369
  var valid_564370 = query.getOrDefault("endDate")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "endDate", valid_564370
  var valid_564371 = query.getOrDefault("$filter")
  valid_564371 = validateParameter(valid_564371, JString, required = false,
                                 default = nil)
  if valid_564371 != nil:
    section.add "$filter", valid_564371
  var valid_564372 = query.getOrDefault("startDate")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "startDate", valid_564372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564373: Call_TransactionsListByBillingProfileName_564364;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by billing profile name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564373.validator(path, query, header, formData, body)
  let scheme = call_564373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564373.url(scheme.get, call_564373.host, call_564373.base,
                         call_564373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564373, url, valid)

proc call*(call_564374: Call_TransactionsListByBillingProfileName_564364;
          apiVersion: string; billingAccountName: string; endDate: string;
          startDate: string; billingProfileName: string; Filter: string = ""): Recallable =
  ## transactionsListByBillingProfileName
  ## Lists the transactions by billing profile name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   endDate: string (required)
  ##          : End date
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: string (required)
  ##            : Start date
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_564375 = newJObject()
  var query_564376 = newJObject()
  add(query_564376, "api-version", newJString(apiVersion))
  add(path_564375, "billingAccountName", newJString(billingAccountName))
  add(query_564376, "endDate", newJString(endDate))
  add(query_564376, "$filter", newJString(Filter))
  add(query_564376, "startDate", newJString(startDate))
  add(path_564375, "billingProfileName", newJString(billingProfileName))
  result = call_564374.call(path_564375, query_564376, nil, nil, nil)

var transactionsListByBillingProfileName* = Call_TransactionsListByBillingProfileName_564364(
    name: "transactionsListByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/transactions",
    validator: validate_TransactionsListByBillingProfileName_564365, base: "",
    url: url_TransactionsListByBillingProfileName_564366, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByBillingAccountName_564377 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsListByBillingAccountName_564379(protocol: Scheme;
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

proc validate_BillingSubscriptionsListByBillingAccountName_564378(path: JsonNode;
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
  var valid_564380 = path.getOrDefault("billingAccountName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "billingAccountName", valid_564380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564381 = query.getOrDefault("api-version")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "api-version", valid_564381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564382: Call_BillingSubscriptionsListByBillingAccountName_564377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscriptions by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564382.validator(path, query, header, formData, body)
  let scheme = call_564382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564382.url(scheme.get, call_564382.host, call_564382.base,
                         call_564382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564382, url, valid)

proc call*(call_564383: Call_BillingSubscriptionsListByBillingAccountName_564377;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingSubscriptionsListByBillingAccountName
  ## Lists billing subscriptions by billing account name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_564384 = newJObject()
  var query_564385 = newJObject()
  add(query_564385, "api-version", newJString(apiVersion))
  add(path_564384, "billingAccountName", newJString(billingAccountName))
  result = call_564383.call(path_564384, query_564385, nil, nil, nil)

var billingSubscriptionsListByBillingAccountName* = Call_BillingSubscriptionsListByBillingAccountName_564377(
    name: "billingSubscriptionsListByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByBillingAccountName_564378,
    base: "", url: url_BillingSubscriptionsListByBillingAccountName_564379,
    schemes: {Scheme.Https})
type
  Call_CustomersListByBillingAccountName_564386 = ref object of OpenApiRestCall_563565
proc url_CustomersListByBillingAccountName_564388(protocol: Scheme; host: string;
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

proc validate_CustomersListByBillingAccountName_564387(path: JsonNode;
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
  var valid_564389 = path.getOrDefault("billingAccountName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "billingAccountName", valid_564389
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
  var valid_564390 = query.getOrDefault("api-version")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "api-version", valid_564390
  var valid_564391 = query.getOrDefault("$skiptoken")
  valid_564391 = validateParameter(valid_564391, JString, required = false,
                                 default = nil)
  if valid_564391 != nil:
    section.add "$skiptoken", valid_564391
  var valid_564392 = query.getOrDefault("$filter")
  valid_564392 = validateParameter(valid_564392, JString, required = false,
                                 default = nil)
  if valid_564392 != nil:
    section.add "$filter", valid_564392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564393: Call_CustomersListByBillingAccountName_564386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all customers which the current user can work with on-behalf of a partner.
  ## 
  let valid = call_564393.validator(path, query, header, formData, body)
  let scheme = call_564393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564393.url(scheme.get, call_564393.host, call_564393.base,
                         call_564393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564393, url, valid)

proc call*(call_564394: Call_CustomersListByBillingAccountName_564386;
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
  var path_564395 = newJObject()
  var query_564396 = newJObject()
  add(query_564396, "api-version", newJString(apiVersion))
  add(path_564395, "billingAccountName", newJString(billingAccountName))
  add(query_564396, "$skiptoken", newJString(Skiptoken))
  add(query_564396, "$filter", newJString(Filter))
  result = call_564394.call(path_564395, query_564396, nil, nil, nil)

var customersListByBillingAccountName* = Call_CustomersListByBillingAccountName_564386(
    name: "customersListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers",
    validator: validate_CustomersListByBillingAccountName_564387, base: "",
    url: url_CustomersListByBillingAccountName_564388, schemes: {Scheme.Https})
type
  Call_CustomersGet_564397 = ref object of OpenApiRestCall_563565
proc url_CustomersGet_564399(protocol: Scheme; host: string; base: string;
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

proc validate_CustomersGet_564398(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564400 = path.getOrDefault("billingAccountName")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "billingAccountName", valid_564400
  var valid_564401 = path.getOrDefault("customerName")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "customerName", valid_564401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand enabledAzureSkus, resellers.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564402 = query.getOrDefault("api-version")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "api-version", valid_564402
  var valid_564403 = query.getOrDefault("$expand")
  valid_564403 = validateParameter(valid_564403, JString, required = false,
                                 default = nil)
  if valid_564403 != nil:
    section.add "$expand", valid_564403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564404: Call_CustomersGet_564397; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the customer by id.
  ## 
  let valid = call_564404.validator(path, query, header, formData, body)
  let scheme = call_564404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564404.url(scheme.get, call_564404.host, call_564404.base,
                         call_564404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564404, url, valid)

proc call*(call_564405: Call_CustomersGet_564397; apiVersion: string;
          billingAccountName: string; customerName: string; Expand: string = ""): Recallable =
  ## customersGet
  ## Get the customer by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  ##   Expand: string
  ##         : May be used to expand enabledAzureSkus, resellers.
  var path_564406 = newJObject()
  var query_564407 = newJObject()
  add(query_564407, "api-version", newJString(apiVersion))
  add(path_564406, "billingAccountName", newJString(billingAccountName))
  add(path_564406, "customerName", newJString(customerName))
  add(query_564407, "$expand", newJString(Expand))
  result = call_564405.call(path_564406, query_564407, nil, nil, nil)

var customersGet* = Call_CustomersGet_564397(name: "customersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}",
    validator: validate_CustomersGet_564398, base: "", url: url_CustomersGet_564399,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByCustomerName_564408 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsListByCustomerName_564410(protocol: Scheme;
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

proc validate_BillingSubscriptionsListByCustomerName_564409(path: JsonNode;
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
  var valid_564411 = path.getOrDefault("billingAccountName")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "billingAccountName", valid_564411
  var valid_564412 = path.getOrDefault("customerName")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "customerName", valid_564412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564413 = query.getOrDefault("api-version")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "api-version", valid_564413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564414: Call_BillingSubscriptionsListByCustomerName_564408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscription by customer name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564414.validator(path, query, header, formData, body)
  let scheme = call_564414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564414.url(scheme.get, call_564414.host, call_564414.base,
                         call_564414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564414, url, valid)

proc call*(call_564415: Call_BillingSubscriptionsListByCustomerName_564408;
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
  var path_564416 = newJObject()
  var query_564417 = newJObject()
  add(query_564417, "api-version", newJString(apiVersion))
  add(path_564416, "billingAccountName", newJString(billingAccountName))
  add(path_564416, "customerName", newJString(customerName))
  result = call_564415.call(path_564416, query_564417, nil, nil, nil)

var billingSubscriptionsListByCustomerName* = Call_BillingSubscriptionsListByCustomerName_564408(
    name: "billingSubscriptionsListByCustomerName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByCustomerName_564409, base: "",
    url: url_BillingSubscriptionsListByCustomerName_564410,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsGetByCustomerName_564418 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsGetByCustomerName_564420(protocol: Scheme;
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

proc validate_BillingSubscriptionsGetByCustomerName_564419(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564421 = path.getOrDefault("billingAccountName")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "billingAccountName", valid_564421
  var valid_564422 = path.getOrDefault("customerName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "customerName", valid_564422
  var valid_564423 = path.getOrDefault("billingSubscriptionName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "billingSubscriptionName", valid_564423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564424 = query.getOrDefault("api-version")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "api-version", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564425: Call_BillingSubscriptionsGetByCustomerName_564418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564425.validator(path, query, header, formData, body)
  let scheme = call_564425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564425.url(scheme.get, call_564425.host, call_564425.base,
                         call_564425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564425, url, valid)

proc call*(call_564426: Call_BillingSubscriptionsGetByCustomerName_564418;
          apiVersion: string; billingAccountName: string; customerName: string;
          billingSubscriptionName: string): Recallable =
  ## billingSubscriptionsGetByCustomerName
  ## Get a single billing subscription by name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  var path_564427 = newJObject()
  var query_564428 = newJObject()
  add(query_564428, "api-version", newJString(apiVersion))
  add(path_564427, "billingAccountName", newJString(billingAccountName))
  add(path_564427, "customerName", newJString(customerName))
  add(path_564427, "billingSubscriptionName", newJString(billingSubscriptionName))
  result = call_564426.call(path_564427, query_564428, nil, nil, nil)

var billingSubscriptionsGetByCustomerName* = Call_BillingSubscriptionsGetByCustomerName_564418(
    name: "billingSubscriptionsGetByCustomerName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingSubscriptions/{billingSubscriptionName}",
    validator: validate_BillingSubscriptionsGetByCustomerName_564419, base: "",
    url: url_BillingSubscriptionsGetByCustomerName_564420, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByCustomers_564429 = ref object of OpenApiRestCall_563565
proc url_BillingPermissionsListByCustomers_564431(protocol: Scheme; host: string;
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

proc validate_BillingPermissionsListByCustomers_564430(path: JsonNode;
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
  var valid_564432 = path.getOrDefault("billingAccountName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "billingAccountName", valid_564432
  var valid_564433 = path.getOrDefault("customerName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "customerName", valid_564433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564434 = query.getOrDefault("api-version")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "api-version", valid_564434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564435: Call_BillingPermissionsListByCustomers_564429;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under customer.
  ## 
  let valid = call_564435.validator(path, query, header, formData, body)
  let scheme = call_564435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564435.url(scheme.get, call_564435.host, call_564435.base,
                         call_564435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564435, url, valid)

proc call*(call_564436: Call_BillingPermissionsListByCustomers_564429;
          apiVersion: string; billingAccountName: string; customerName: string): Recallable =
  ## billingPermissionsListByCustomers
  ## Lists all billing permissions for the caller under customer.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  var path_564437 = newJObject()
  var query_564438 = newJObject()
  add(query_564438, "api-version", newJString(apiVersion))
  add(path_564437, "billingAccountName", newJString(billingAccountName))
  add(path_564437, "customerName", newJString(customerName))
  result = call_564436.call(path_564437, query_564438, nil, nil, nil)

var billingPermissionsListByCustomers* = Call_BillingPermissionsListByCustomers_564429(
    name: "billingPermissionsListByCustomers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByCustomers_564430, base: "",
    url: url_BillingPermissionsListByCustomers_564431, schemes: {Scheme.Https})
type
  Call_TransactionsListByCustomerName_564439 = ref object of OpenApiRestCall_563565
proc url_TransactionsListByCustomerName_564441(protocol: Scheme; host: string;
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

proc validate_TransactionsListByCustomerName_564440(path: JsonNode;
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
  var valid_564442 = path.getOrDefault("billingAccountName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "billingAccountName", valid_564442
  var valid_564443 = path.getOrDefault("customerName")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "customerName", valid_564443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564444 = query.getOrDefault("api-version")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "api-version", valid_564444
  var valid_564445 = query.getOrDefault("endDate")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "endDate", valid_564445
  var valid_564446 = query.getOrDefault("$filter")
  valid_564446 = validateParameter(valid_564446, JString, required = false,
                                 default = nil)
  if valid_564446 != nil:
    section.add "$filter", valid_564446
  var valid_564447 = query.getOrDefault("startDate")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "startDate", valid_564447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564448: Call_TransactionsListByCustomerName_564439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564448.validator(path, query, header, formData, body)
  let scheme = call_564448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564448.url(scheme.get, call_564448.host, call_564448.base,
                         call_564448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564448, url, valid)

proc call*(call_564449: Call_TransactionsListByCustomerName_564439;
          apiVersion: string; billingAccountName: string; customerName: string;
          endDate: string; startDate: string; Filter: string = ""): Recallable =
  ## transactionsListByCustomerName
  ## Lists the transactions by invoice section name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  ##   endDate: string (required)
  ##          : End date
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: string (required)
  ##            : Start date
  var path_564450 = newJObject()
  var query_564451 = newJObject()
  add(query_564451, "api-version", newJString(apiVersion))
  add(path_564450, "billingAccountName", newJString(billingAccountName))
  add(path_564450, "customerName", newJString(customerName))
  add(query_564451, "endDate", newJString(endDate))
  add(query_564451, "$filter", newJString(Filter))
  add(query_564451, "startDate", newJString(startDate))
  result = call_564449.call(path_564450, query_564451, nil, nil, nil)

var transactionsListByCustomerName* = Call_TransactionsListByCustomerName_564439(
    name: "transactionsListByCustomerName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/transactions",
    validator: validate_TransactionsListByCustomerName_564440, base: "",
    url: url_TransactionsListByCustomerName_564441, schemes: {Scheme.Https})
type
  Call_DepartmentsListByBillingAccountName_564452 = ref object of OpenApiRestCall_563565
proc url_DepartmentsListByBillingAccountName_564454(protocol: Scheme; host: string;
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

proc validate_DepartmentsListByBillingAccountName_564453(path: JsonNode;
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
  var valid_564455 = path.getOrDefault("billingAccountName")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "billingAccountName", valid_564455
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
  var valid_564456 = query.getOrDefault("api-version")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "api-version", valid_564456
  var valid_564457 = query.getOrDefault("$expand")
  valid_564457 = validateParameter(valid_564457, JString, required = false,
                                 default = nil)
  if valid_564457 != nil:
    section.add "$expand", valid_564457
  var valid_564458 = query.getOrDefault("$filter")
  valid_564458 = validateParameter(valid_564458, JString, required = false,
                                 default = nil)
  if valid_564458 != nil:
    section.add "$filter", valid_564458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564459: Call_DepartmentsListByBillingAccountName_564452;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all departments for which a user has access.
  ## 
  let valid = call_564459.validator(path, query, header, formData, body)
  let scheme = call_564459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564459.url(scheme.get, call_564459.host, call_564459.base,
                         call_564459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564459, url, valid)

proc call*(call_564460: Call_DepartmentsListByBillingAccountName_564452;
          apiVersion: string; billingAccountName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## departmentsListByBillingAccountName
  ## Lists all departments for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the enrollmentAccounts.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564461 = newJObject()
  var query_564462 = newJObject()
  add(query_564462, "api-version", newJString(apiVersion))
  add(path_564461, "billingAccountName", newJString(billingAccountName))
  add(query_564462, "$expand", newJString(Expand))
  add(query_564462, "$filter", newJString(Filter))
  result = call_564460.call(path_564461, query_564462, nil, nil, nil)

var departmentsListByBillingAccountName* = Call_DepartmentsListByBillingAccountName_564452(
    name: "departmentsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/departments",
    validator: validate_DepartmentsListByBillingAccountName_564453, base: "",
    url: url_DepartmentsListByBillingAccountName_564454, schemes: {Scheme.Https})
type
  Call_DepartmentsGet_564463 = ref object of OpenApiRestCall_563565
proc url_DepartmentsGet_564465(protocol: Scheme; host: string; base: string;
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

proc validate_DepartmentsGet_564464(path: JsonNode; query: JsonNode;
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
  var valid_564466 = path.getOrDefault("billingAccountName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "billingAccountName", valid_564466
  var valid_564467 = path.getOrDefault("departmentName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "departmentName", valid_564467
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
  var valid_564468 = query.getOrDefault("api-version")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "api-version", valid_564468
  var valid_564469 = query.getOrDefault("$expand")
  valid_564469 = validateParameter(valid_564469, JString, required = false,
                                 default = nil)
  if valid_564469 != nil:
    section.add "$expand", valid_564469
  var valid_564470 = query.getOrDefault("$filter")
  valid_564470 = validateParameter(valid_564470, JString, required = false,
                                 default = nil)
  if valid_564470 != nil:
    section.add "$filter", valid_564470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564471: Call_DepartmentsGet_564463; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the department by id.
  ## 
  let valid = call_564471.validator(path, query, header, formData, body)
  let scheme = call_564471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564471.url(scheme.get, call_564471.host, call_564471.base,
                         call_564471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564471, url, valid)

proc call*(call_564472: Call_DepartmentsGet_564463; apiVersion: string;
          billingAccountName: string; departmentName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## departmentsGet
  ## Get the department by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the enrollmentAccounts.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   departmentName: string (required)
  ##                 : Department Id.
  var path_564473 = newJObject()
  var query_564474 = newJObject()
  add(query_564474, "api-version", newJString(apiVersion))
  add(path_564473, "billingAccountName", newJString(billingAccountName))
  add(query_564474, "$expand", newJString(Expand))
  add(query_564474, "$filter", newJString(Filter))
  add(path_564473, "departmentName", newJString(departmentName))
  result = call_564472.call(path_564473, query_564474, nil, nil, nil)

var departmentsGet* = Call_DepartmentsGet_564463(name: "departmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/departments/{departmentName}",
    validator: validate_DepartmentsGet_564464, base: "", url: url_DepartmentsGet_564465,
    schemes: {Scheme.Https})
type
  Call_EnrollmentAccountsListByBillingAccountName_564475 = ref object of OpenApiRestCall_563565
proc url_EnrollmentAccountsListByBillingAccountName_564477(protocol: Scheme;
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

proc validate_EnrollmentAccountsListByBillingAccountName_564476(path: JsonNode;
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
  var valid_564478 = path.getOrDefault("billingAccountName")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "billingAccountName", valid_564478
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
  var valid_564479 = query.getOrDefault("api-version")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "api-version", valid_564479
  var valid_564480 = query.getOrDefault("$expand")
  valid_564480 = validateParameter(valid_564480, JString, required = false,
                                 default = nil)
  if valid_564480 != nil:
    section.add "$expand", valid_564480
  var valid_564481 = query.getOrDefault("$filter")
  valid_564481 = validateParameter(valid_564481, JString, required = false,
                                 default = nil)
  if valid_564481 != nil:
    section.add "$filter", valid_564481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564482: Call_EnrollmentAccountsListByBillingAccountName_564475;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Enrollment Accounts for which a user has access.
  ## 
  let valid = call_564482.validator(path, query, header, formData, body)
  let scheme = call_564482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564482.url(scheme.get, call_564482.host, call_564482.base,
                         call_564482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564482, url, valid)

proc call*(call_564483: Call_EnrollmentAccountsListByBillingAccountName_564475;
          apiVersion: string; billingAccountName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## enrollmentAccountsListByBillingAccountName
  ## Lists all Enrollment Accounts for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the department.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564484 = newJObject()
  var query_564485 = newJObject()
  add(query_564485, "api-version", newJString(apiVersion))
  add(path_564484, "billingAccountName", newJString(billingAccountName))
  add(query_564485, "$expand", newJString(Expand))
  add(query_564485, "$filter", newJString(Filter))
  result = call_564483.call(path_564484, query_564485, nil, nil, nil)

var enrollmentAccountsListByBillingAccountName* = Call_EnrollmentAccountsListByBillingAccountName_564475(
    name: "enrollmentAccountsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts",
    validator: validate_EnrollmentAccountsListByBillingAccountName_564476,
    base: "", url: url_EnrollmentAccountsListByBillingAccountName_564477,
    schemes: {Scheme.Https})
type
  Call_EnrollmentAccountsGetByEnrollmentAccountId_564486 = ref object of OpenApiRestCall_563565
proc url_EnrollmentAccountsGetByEnrollmentAccountId_564488(protocol: Scheme;
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

proc validate_EnrollmentAccountsGetByEnrollmentAccountId_564487(path: JsonNode;
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
  var valid_564489 = path.getOrDefault("billingAccountName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "billingAccountName", valid_564489
  var valid_564490 = path.getOrDefault("enrollmentAccountName")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "enrollmentAccountName", valid_564490
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
  var valid_564491 = query.getOrDefault("api-version")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "api-version", valid_564491
  var valid_564492 = query.getOrDefault("$expand")
  valid_564492 = validateParameter(valid_564492, JString, required = false,
                                 default = nil)
  if valid_564492 != nil:
    section.add "$expand", valid_564492
  var valid_564493 = query.getOrDefault("$filter")
  valid_564493 = validateParameter(valid_564493, JString, required = false,
                                 default = nil)
  if valid_564493 != nil:
    section.add "$filter", valid_564493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564494: Call_EnrollmentAccountsGetByEnrollmentAccountId_564486;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the enrollment account by id.
  ## 
  let valid = call_564494.validator(path, query, header, formData, body)
  let scheme = call_564494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564494.url(scheme.get, call_564494.host, call_564494.base,
                         call_564494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564494, url, valid)

proc call*(call_564495: Call_EnrollmentAccountsGetByEnrollmentAccountId_564486;
          apiVersion: string; billingAccountName: string;
          enrollmentAccountName: string; Expand: string = ""; Filter: string = ""): Recallable =
  ## enrollmentAccountsGetByEnrollmentAccountId
  ## Get the enrollment account by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the Department.
  ##   enrollmentAccountName: string (required)
  ##                        : Enrollment Account Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564496 = newJObject()
  var query_564497 = newJObject()
  add(query_564497, "api-version", newJString(apiVersion))
  add(path_564496, "billingAccountName", newJString(billingAccountName))
  add(query_564497, "$expand", newJString(Expand))
  add(path_564496, "enrollmentAccountName", newJString(enrollmentAccountName))
  add(query_564497, "$filter", newJString(Filter))
  result = call_564495.call(path_564496, query_564497, nil, nil, nil)

var enrollmentAccountsGetByEnrollmentAccountId* = Call_EnrollmentAccountsGetByEnrollmentAccountId_564486(
    name: "enrollmentAccountsGetByEnrollmentAccountId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName}",
    validator: validate_EnrollmentAccountsGetByEnrollmentAccountId_564487,
    base: "", url: url_EnrollmentAccountsGetByEnrollmentAccountId_564488,
    schemes: {Scheme.Https})
type
  Call_InvoiceSectionsCreate_564508 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsCreate_564510(protocol: Scheme; host: string; base: string;
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

proc validate_InvoiceSectionsCreate_564509(path: JsonNode; query: JsonNode;
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
  var valid_564511 = path.getOrDefault("billingAccountName")
  valid_564511 = validateParameter(valid_564511, JString, required = true,
                                 default = nil)
  if valid_564511 != nil:
    section.add "billingAccountName", valid_564511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564512 = query.getOrDefault("api-version")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "api-version", valid_564512
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

proc call*(call_564514: Call_InvoiceSectionsCreate_564508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a InvoiceSection.
  ## 
  let valid = call_564514.validator(path, query, header, formData, body)
  let scheme = call_564514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564514.url(scheme.get, call_564514.host, call_564514.base,
                         call_564514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564514, url, valid)

proc call*(call_564515: Call_InvoiceSectionsCreate_564508; apiVersion: string;
          billingAccountName: string; parameters: JsonNode): Recallable =
  ## invoiceSectionsCreate
  ## The operation to create a InvoiceSection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create InvoiceSection operation.
  var path_564516 = newJObject()
  var query_564517 = newJObject()
  var body_564518 = newJObject()
  add(query_564517, "api-version", newJString(apiVersion))
  add(path_564516, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_564518 = parameters
  result = call_564515.call(path_564516, query_564517, nil, nil, body_564518)

var invoiceSectionsCreate* = Call_InvoiceSectionsCreate_564508(
    name: "invoiceSectionsCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections",
    validator: validate_InvoiceSectionsCreate_564509, base: "",
    url: url_InvoiceSectionsCreate_564510, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsListByBillingAccountName_564498 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsListByBillingAccountName_564500(protocol: Scheme;
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

proc validate_InvoiceSectionsListByBillingAccountName_564499(path: JsonNode;
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
  var valid_564501 = path.getOrDefault("billingAccountName")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "billingAccountName", valid_564501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564502 = query.getOrDefault("api-version")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "api-version", valid_564502
  var valid_564503 = query.getOrDefault("$expand")
  valid_564503 = validateParameter(valid_564503, JString, required = false,
                                 default = nil)
  if valid_564503 != nil:
    section.add "$expand", valid_564503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564504: Call_InvoiceSectionsListByBillingAccountName_564498;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoice sections for which a user has access.
  ## 
  let valid = call_564504.validator(path, query, header, formData, body)
  let scheme = call_564504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564504.url(scheme.get, call_564504.host, call_564504.base,
                         call_564504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564504, url, valid)

proc call*(call_564505: Call_InvoiceSectionsListByBillingAccountName_564498;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## invoiceSectionsListByBillingAccountName
  ## Lists all invoice sections for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the billingProfiles.
  var path_564506 = newJObject()
  var query_564507 = newJObject()
  add(query_564507, "api-version", newJString(apiVersion))
  add(path_564506, "billingAccountName", newJString(billingAccountName))
  add(query_564507, "$expand", newJString(Expand))
  result = call_564505.call(path_564506, query_564507, nil, nil, nil)

var invoiceSectionsListByBillingAccountName* = Call_InvoiceSectionsListByBillingAccountName_564498(
    name: "invoiceSectionsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections",
    validator: validate_InvoiceSectionsListByBillingAccountName_564499, base: "",
    url: url_InvoiceSectionsListByBillingAccountName_564500,
    schemes: {Scheme.Https})
type
  Call_InvoiceSectionsUpdate_564530 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsUpdate_564532(protocol: Scheme; host: string; base: string;
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

proc validate_InvoiceSectionsUpdate_564531(path: JsonNode; query: JsonNode;
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
  var valid_564533 = path.getOrDefault("billingAccountName")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "billingAccountName", valid_564533
  var valid_564534 = path.getOrDefault("invoiceSectionName")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "invoiceSectionName", valid_564534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564535 = query.getOrDefault("api-version")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "api-version", valid_564535
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

proc call*(call_564537: Call_InvoiceSectionsUpdate_564530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a InvoiceSection.
  ## 
  let valid = call_564537.validator(path, query, header, formData, body)
  let scheme = call_564537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564537.url(scheme.get, call_564537.host, call_564537.base,
                         call_564537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564537, url, valid)

proc call*(call_564538: Call_InvoiceSectionsUpdate_564530; apiVersion: string;
          billingAccountName: string; parameters: JsonNode;
          invoiceSectionName: string): Recallable =
  ## invoiceSectionsUpdate
  ## The operation to update a InvoiceSection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create InvoiceSection operation.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564539 = newJObject()
  var query_564540 = newJObject()
  var body_564541 = newJObject()
  add(query_564540, "api-version", newJString(apiVersion))
  add(path_564539, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_564541 = parameters
  add(path_564539, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564538.call(path_564539, query_564540, nil, nil, body_564541)

var invoiceSectionsUpdate* = Call_InvoiceSectionsUpdate_564530(
    name: "invoiceSectionsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsUpdate_564531, base: "",
    url: url_InvoiceSectionsUpdate_564532, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsGet_564519 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsGet_564521(protocol: Scheme; host: string; base: string;
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

proc validate_InvoiceSectionsGet_564520(path: JsonNode; query: JsonNode;
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
  var valid_564522 = path.getOrDefault("billingAccountName")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "billingAccountName", valid_564522
  var valid_564523 = path.getOrDefault("invoiceSectionName")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = nil)
  if valid_564523 != nil:
    section.add "invoiceSectionName", valid_564523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564524 = query.getOrDefault("api-version")
  valid_564524 = validateParameter(valid_564524, JString, required = true,
                                 default = nil)
  if valid_564524 != nil:
    section.add "api-version", valid_564524
  var valid_564525 = query.getOrDefault("$expand")
  valid_564525 = validateParameter(valid_564525, JString, required = false,
                                 default = nil)
  if valid_564525 != nil:
    section.add "$expand", valid_564525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564526: Call_InvoiceSectionsGet_564519; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the InvoiceSection by id.
  ## 
  let valid = call_564526.validator(path, query, header, formData, body)
  let scheme = call_564526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564526.url(scheme.get, call_564526.host, call_564526.base,
                         call_564526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564526, url, valid)

proc call*(call_564527: Call_InvoiceSectionsGet_564519; apiVersion: string;
          billingAccountName: string; invoiceSectionName: string;
          Expand: string = ""): Recallable =
  ## invoiceSectionsGet
  ## Get the InvoiceSection by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the billingProfiles.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564528 = newJObject()
  var query_564529 = newJObject()
  add(query_564529, "api-version", newJString(apiVersion))
  add(path_564528, "billingAccountName", newJString(billingAccountName))
  add(query_564529, "$expand", newJString(Expand))
  add(path_564528, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564527.call(path_564528, query_564529, nil, nil, nil)

var invoiceSectionsGet* = Call_InvoiceSectionsGet_564519(
    name: "invoiceSectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsGet_564520, base: "",
    url: url_InvoiceSectionsGet_564521, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByInvoiceSectionName_564542 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsListByInvoiceSectionName_564544(protocol: Scheme;
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

proc validate_BillingSubscriptionsListByInvoiceSectionName_564543(path: JsonNode;
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
  var valid_564545 = path.getOrDefault("billingAccountName")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "billingAccountName", valid_564545
  var valid_564546 = path.getOrDefault("invoiceSectionName")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "invoiceSectionName", valid_564546
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564547 = query.getOrDefault("api-version")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "api-version", valid_564547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564548: Call_BillingSubscriptionsListByInvoiceSectionName_564542;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscription by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564548.validator(path, query, header, formData, body)
  let scheme = call_564548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564548.url(scheme.get, call_564548.host, call_564548.base,
                         call_564548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564548, url, valid)

proc call*(call_564549: Call_BillingSubscriptionsListByInvoiceSectionName_564542;
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
  var path_564550 = newJObject()
  var query_564551 = newJObject()
  add(query_564551, "api-version", newJString(apiVersion))
  add(path_564550, "billingAccountName", newJString(billingAccountName))
  add(path_564550, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564549.call(path_564550, query_564551, nil, nil, nil)

var billingSubscriptionsListByInvoiceSectionName* = Call_BillingSubscriptionsListByInvoiceSectionName_564542(
    name: "billingSubscriptionsListByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByInvoiceSectionName_564543,
    base: "", url: url_BillingSubscriptionsListByInvoiceSectionName_564544,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsGet_564552 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsGet_564554(protocol: Scheme; host: string; base: string;
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

proc validate_BillingSubscriptionsGet_564553(path: JsonNode; query: JsonNode;
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
  var valid_564555 = path.getOrDefault("billingAccountName")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "billingAccountName", valid_564555
  var valid_564556 = path.getOrDefault("billingSubscriptionName")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "billingSubscriptionName", valid_564556
  var valid_564557 = path.getOrDefault("invoiceSectionName")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "invoiceSectionName", valid_564557
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564558 = query.getOrDefault("api-version")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "api-version", valid_564558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564559: Call_BillingSubscriptionsGet_564552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564559.validator(path, query, header, formData, body)
  let scheme = call_564559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564559.url(scheme.get, call_564559.host, call_564559.base,
                         call_564559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564559, url, valid)

proc call*(call_564560: Call_BillingSubscriptionsGet_564552; apiVersion: string;
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
  var path_564561 = newJObject()
  var query_564562 = newJObject()
  add(query_564562, "api-version", newJString(apiVersion))
  add(path_564561, "billingAccountName", newJString(billingAccountName))
  add(path_564561, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_564561, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564560.call(path_564561, query_564562, nil, nil, nil)

var billingSubscriptionsGet* = Call_BillingSubscriptionsGet_564552(
    name: "billingSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}",
    validator: validate_BillingSubscriptionsGet_564553, base: "",
    url: url_BillingSubscriptionsGet_564554, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsTransfer_564563 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsTransfer_564565(protocol: Scheme; host: string;
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

proc validate_BillingSubscriptionsTransfer_564564(path: JsonNode; query: JsonNode;
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
  var valid_564566 = path.getOrDefault("billingAccountName")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "billingAccountName", valid_564566
  var valid_564567 = path.getOrDefault("billingSubscriptionName")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "billingSubscriptionName", valid_564567
  var valid_564568 = path.getOrDefault("invoiceSectionName")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "invoiceSectionName", valid_564568
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

proc call*(call_564570: Call_BillingSubscriptionsTransfer_564563; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Transfers the subscription from one invoice section to another within a billing account.
  ## 
  let valid = call_564570.validator(path, query, header, formData, body)
  let scheme = call_564570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564570.url(scheme.get, call_564570.host, call_564570.base,
                         call_564570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564570, url, valid)

proc call*(call_564571: Call_BillingSubscriptionsTransfer_564563;
          billingAccountName: string; billingSubscriptionName: string;
          parameters: JsonNode; invoiceSectionName: string): Recallable =
  ## billingSubscriptionsTransfer
  ## Transfers the subscription from one invoice section to another within a billing account.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564572 = newJObject()
  var body_564573 = newJObject()
  add(path_564572, "billingAccountName", newJString(billingAccountName))
  add(path_564572, "billingSubscriptionName", newJString(billingSubscriptionName))
  if parameters != nil:
    body_564573 = parameters
  add(path_564572, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564571.call(path_564572, nil, nil, nil, body_564573)

var billingSubscriptionsTransfer* = Call_BillingSubscriptionsTransfer_564563(
    name: "billingSubscriptionsTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}/transfer",
    validator: validate_BillingSubscriptionsTransfer_564564, base: "",
    url: url_BillingSubscriptionsTransfer_564565, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsValidateTransfer_564574 = ref object of OpenApiRestCall_563565
proc url_BillingSubscriptionsValidateTransfer_564576(protocol: Scheme;
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

proc validate_BillingSubscriptionsValidateTransfer_564575(path: JsonNode;
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
  var valid_564577 = path.getOrDefault("billingAccountName")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = nil)
  if valid_564577 != nil:
    section.add "billingAccountName", valid_564577
  var valid_564578 = path.getOrDefault("billingSubscriptionName")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "billingSubscriptionName", valid_564578
  var valid_564579 = path.getOrDefault("invoiceSectionName")
  valid_564579 = validateParameter(valid_564579, JString, required = true,
                                 default = nil)
  if valid_564579 != nil:
    section.add "invoiceSectionName", valid_564579
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

proc call*(call_564581: Call_BillingSubscriptionsValidateTransfer_564574;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates the transfer of billing subscriptions across invoice sections.
  ## 
  let valid = call_564581.validator(path, query, header, formData, body)
  let scheme = call_564581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564581.url(scheme.get, call_564581.host, call_564581.base,
                         call_564581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564581, url, valid)

proc call*(call_564582: Call_BillingSubscriptionsValidateTransfer_564574;
          billingAccountName: string; billingSubscriptionName: string;
          parameters: JsonNode; invoiceSectionName: string): Recallable =
  ## billingSubscriptionsValidateTransfer
  ## Validates the transfer of billing subscriptions across invoice sections.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564583 = newJObject()
  var body_564584 = newJObject()
  add(path_564583, "billingAccountName", newJString(billingAccountName))
  add(path_564583, "billingSubscriptionName", newJString(billingSubscriptionName))
  if parameters != nil:
    body_564584 = parameters
  add(path_564583, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564582.call(path_564583, nil, nil, nil, body_564584)

var billingSubscriptionsValidateTransfer* = Call_BillingSubscriptionsValidateTransfer_564574(
    name: "billingSubscriptionsValidateTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}/validateTransferEligibility",
    validator: validate_BillingSubscriptionsValidateTransfer_564575, base: "",
    url: url_BillingSubscriptionsValidateTransfer_564576, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsElevateToBillingProfile_564585 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsElevateToBillingProfile_564587(protocol: Scheme;
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

proc validate_InvoiceSectionsElevateToBillingProfile_564586(path: JsonNode;
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
  var valid_564588 = path.getOrDefault("billingAccountName")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "billingAccountName", valid_564588
  var valid_564589 = path.getOrDefault("invoiceSectionName")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "invoiceSectionName", valid_564589
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564590: Call_InvoiceSectionsElevateToBillingProfile_564585;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Elevates the caller's access to match their billing profile access.
  ## 
  let valid = call_564590.validator(path, query, header, formData, body)
  let scheme = call_564590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564590.url(scheme.get, call_564590.host, call_564590.base,
                         call_564590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564590, url, valid)

proc call*(call_564591: Call_InvoiceSectionsElevateToBillingProfile_564585;
          billingAccountName: string; invoiceSectionName: string): Recallable =
  ## invoiceSectionsElevateToBillingProfile
  ## Elevates the caller's access to match their billing profile access.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564592 = newJObject()
  add(path_564592, "billingAccountName", newJString(billingAccountName))
  add(path_564592, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564591.call(path_564592, nil, nil, nil, nil)

var invoiceSectionsElevateToBillingProfile* = Call_InvoiceSectionsElevateToBillingProfile_564585(
    name: "invoiceSectionsElevateToBillingProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/elevate",
    validator: validate_InvoiceSectionsElevateToBillingProfile_564586, base: "",
    url: url_InvoiceSectionsElevateToBillingProfile_564587,
    schemes: {Scheme.Https})
type
  Call_TransfersInitiate_564593 = ref object of OpenApiRestCall_563565
proc url_TransfersInitiate_564595(protocol: Scheme; host: string; base: string;
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

proc validate_TransfersInitiate_564594(path: JsonNode; query: JsonNode;
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
  var valid_564596 = path.getOrDefault("billingAccountName")
  valid_564596 = validateParameter(valid_564596, JString, required = true,
                                 default = nil)
  if valid_564596 != nil:
    section.add "billingAccountName", valid_564596
  var valid_564597 = path.getOrDefault("invoiceSectionName")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "invoiceSectionName", valid_564597
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

proc call*(call_564599: Call_TransfersInitiate_564593; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  let valid = call_564599.validator(path, query, header, formData, body)
  let scheme = call_564599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564599.url(scheme.get, call_564599.host, call_564599.base,
                         call_564599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564599, url, valid)

proc call*(call_564600: Call_TransfersInitiate_564593; billingAccountName: string;
          body: JsonNode; invoiceSectionName: string): Recallable =
  ## transfersInitiate
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   body: JObject (required)
  ##       : Initiate transfer parameters.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564601 = newJObject()
  var body_564602 = newJObject()
  add(path_564601, "billingAccountName", newJString(billingAccountName))
  if body != nil:
    body_564602 = body
  add(path_564601, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564600.call(path_564601, nil, nil, nil, body_564602)

var transfersInitiate* = Call_TransfersInitiate_564593(name: "transfersInitiate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/initiateTransfer",
    validator: validate_TransfersInitiate_564594, base: "",
    url: url_TransfersInitiate_564595, schemes: {Scheme.Https})
type
  Call_ProductsListByInvoiceSectionName_564603 = ref object of OpenApiRestCall_563565
proc url_ProductsListByInvoiceSectionName_564605(protocol: Scheme; host: string;
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

proc validate_ProductsListByInvoiceSectionName_564604(path: JsonNode;
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
  var valid_564606 = path.getOrDefault("billingAccountName")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "billingAccountName", valid_564606
  var valid_564607 = path.getOrDefault("invoiceSectionName")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "invoiceSectionName", valid_564607
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564608 = query.getOrDefault("api-version")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "api-version", valid_564608
  var valid_564609 = query.getOrDefault("$filter")
  valid_564609 = validateParameter(valid_564609, JString, required = false,
                                 default = nil)
  if valid_564609 != nil:
    section.add "$filter", valid_564609
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564610: Call_ProductsListByInvoiceSectionName_564603;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists products by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564610.validator(path, query, header, formData, body)
  let scheme = call_564610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564610.url(scheme.get, call_564610.host, call_564610.base,
                         call_564610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564610, url, valid)

proc call*(call_564611: Call_ProductsListByInvoiceSectionName_564603;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; Filter: string = ""): Recallable =
  ## productsListByInvoiceSectionName
  ## Lists products by invoice section name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Filter: string
  ##         : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564612 = newJObject()
  var query_564613 = newJObject()
  add(query_564613, "api-version", newJString(apiVersion))
  add(path_564612, "billingAccountName", newJString(billingAccountName))
  add(query_564613, "$filter", newJString(Filter))
  add(path_564612, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564611.call(path_564612, query_564613, nil, nil, nil)

var productsListByInvoiceSectionName* = Call_ProductsListByInvoiceSectionName_564603(
    name: "productsListByInvoiceSectionName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products",
    validator: validate_ProductsListByInvoiceSectionName_564604, base: "",
    url: url_ProductsListByInvoiceSectionName_564605, schemes: {Scheme.Https})
type
  Call_ProductsGet_564614 = ref object of OpenApiRestCall_563565
proc url_ProductsGet_564616(protocol: Scheme; host: string; base: string;
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

proc validate_ProductsGet_564615(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564617 = path.getOrDefault("billingAccountName")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "billingAccountName", valid_564617
  var valid_564618 = path.getOrDefault("productName")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "productName", valid_564618
  var valid_564619 = path.getOrDefault("invoiceSectionName")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "invoiceSectionName", valid_564619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564620 = query.getOrDefault("api-version")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "api-version", valid_564620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564621: Call_ProductsGet_564614; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564621.validator(path, query, header, formData, body)
  let scheme = call_564621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564621.url(scheme.get, call_564621.host, call_564621.base,
                         call_564621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564621, url, valid)

proc call*(call_564622: Call_ProductsGet_564614; apiVersion: string;
          billingAccountName: string; productName: string;
          invoiceSectionName: string): Recallable =
  ## productsGet
  ## Get a single product by name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564623 = newJObject()
  var query_564624 = newJObject()
  add(query_564624, "api-version", newJString(apiVersion))
  add(path_564623, "billingAccountName", newJString(billingAccountName))
  add(path_564623, "productName", newJString(productName))
  add(path_564623, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564622.call(path_564623, query_564624, nil, nil, nil)

var productsGet* = Call_ProductsGet_564614(name: "productsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}",
                                        validator: validate_ProductsGet_564615,
                                        base: "", url: url_ProductsGet_564616,
                                        schemes: {Scheme.Https})
type
  Call_ProductsTransfer_564625 = ref object of OpenApiRestCall_563565
proc url_ProductsTransfer_564627(protocol: Scheme; host: string; base: string;
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

proc validate_ProductsTransfer_564626(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The operation to transfer a Product to another invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564628 = path.getOrDefault("billingAccountName")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "billingAccountName", valid_564628
  var valid_564629 = path.getOrDefault("productName")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "productName", valid_564629
  var valid_564630 = path.getOrDefault("invoiceSectionName")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "invoiceSectionName", valid_564630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564631 = query.getOrDefault("api-version")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "api-version", valid_564631
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

proc call*(call_564633: Call_ProductsTransfer_564625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to transfer a Product to another invoice section.
  ## 
  let valid = call_564633.validator(path, query, header, formData, body)
  let scheme = call_564633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564633.url(scheme.get, call_564633.host, call_564633.base,
                         call_564633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564633, url, valid)

proc call*(call_564634: Call_ProductsTransfer_564625; apiVersion: string;
          billingAccountName: string; productName: string; parameters: JsonNode;
          invoiceSectionName: string): Recallable =
  ## productsTransfer
  ## The operation to transfer a Product to another invoice section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Product operation.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564635 = newJObject()
  var query_564636 = newJObject()
  var body_564637 = newJObject()
  add(query_564636, "api-version", newJString(apiVersion))
  add(path_564635, "billingAccountName", newJString(billingAccountName))
  add(path_564635, "productName", newJString(productName))
  if parameters != nil:
    body_564637 = parameters
  add(path_564635, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564634.call(path_564635, query_564636, nil, nil, body_564637)

var productsTransfer* = Call_ProductsTransfer_564625(name: "productsTransfer",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}/transfer",
    validator: validate_ProductsTransfer_564626, base: "",
    url: url_ProductsTransfer_564627, schemes: {Scheme.Https})
type
  Call_ProductsUpdateAutoRenewByInvoiceSectionName_564638 = ref object of OpenApiRestCall_563565
proc url_ProductsUpdateAutoRenewByInvoiceSectionName_564640(protocol: Scheme;
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

proc validate_ProductsUpdateAutoRenewByInvoiceSectionName_564639(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel auto renew for product by product id and invoice section name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564641 = path.getOrDefault("billingAccountName")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "billingAccountName", valid_564641
  var valid_564642 = path.getOrDefault("productName")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "productName", valid_564642
  var valid_564643 = path.getOrDefault("invoiceSectionName")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "invoiceSectionName", valid_564643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564644 = query.getOrDefault("api-version")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "api-version", valid_564644
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

proc call*(call_564646: Call_ProductsUpdateAutoRenewByInvoiceSectionName_564638;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancel auto renew for product by product id and invoice section name
  ## 
  let valid = call_564646.validator(path, query, header, formData, body)
  let scheme = call_564646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564646.url(scheme.get, call_564646.host, call_564646.base,
                         call_564646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564646, url, valid)

proc call*(call_564647: Call_ProductsUpdateAutoRenewByInvoiceSectionName_564638;
          apiVersion: string; billingAccountName: string; productName: string;
          body: JsonNode; invoiceSectionName: string): Recallable =
  ## productsUpdateAutoRenewByInvoiceSectionName
  ## Cancel auto renew for product by product id and invoice section name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564648 = newJObject()
  var query_564649 = newJObject()
  var body_564650 = newJObject()
  add(query_564649, "api-version", newJString(apiVersion))
  add(path_564648, "billingAccountName", newJString(billingAccountName))
  add(path_564648, "productName", newJString(productName))
  if body != nil:
    body_564650 = body
  add(path_564648, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564647.call(path_564648, query_564649, nil, nil, body_564650)

var productsUpdateAutoRenewByInvoiceSectionName* = Call_ProductsUpdateAutoRenewByInvoiceSectionName_564638(
    name: "productsUpdateAutoRenewByInvoiceSectionName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}/updateAutoRenew",
    validator: validate_ProductsUpdateAutoRenewByInvoiceSectionName_564639,
    base: "", url: url_ProductsUpdateAutoRenewByInvoiceSectionName_564640,
    schemes: {Scheme.Https})
type
  Call_ProductsValidateTransfer_564651 = ref object of OpenApiRestCall_563565
proc url_ProductsValidateTransfer_564653(protocol: Scheme; host: string;
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

proc validate_ProductsValidateTransfer_564652(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the transfer of products across invoice sections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564654 = path.getOrDefault("billingAccountName")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "billingAccountName", valid_564654
  var valid_564655 = path.getOrDefault("productName")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "productName", valid_564655
  var valid_564656 = path.getOrDefault("invoiceSectionName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "invoiceSectionName", valid_564656
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

proc call*(call_564658: Call_ProductsValidateTransfer_564651; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the transfer of products across invoice sections.
  ## 
  let valid = call_564658.validator(path, query, header, formData, body)
  let scheme = call_564658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564658.url(scheme.get, call_564658.host, call_564658.base,
                         call_564658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564658, url, valid)

proc call*(call_564659: Call_ProductsValidateTransfer_564651;
          billingAccountName: string; productName: string; parameters: JsonNode;
          invoiceSectionName: string): Recallable =
  ## productsValidateTransfer
  ## Validates the transfer of products across invoice sections.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Products operation.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564660 = newJObject()
  var body_564661 = newJObject()
  add(path_564660, "billingAccountName", newJString(billingAccountName))
  add(path_564660, "productName", newJString(productName))
  if parameters != nil:
    body_564661 = parameters
  add(path_564660, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564659.call(path_564660, nil, nil, nil, body_564661)

var productsValidateTransfer* = Call_ProductsValidateTransfer_564651(
    name: "productsValidateTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}/validateTransferEligibility",
    validator: validate_ProductsValidateTransfer_564652, base: "",
    url: url_ProductsValidateTransfer_564653, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByInvoiceSections_564662 = ref object of OpenApiRestCall_563565
proc url_BillingPermissionsListByInvoiceSections_564664(protocol: Scheme;
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

proc validate_BillingPermissionsListByInvoiceSections_564663(path: JsonNode;
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
  var valid_564665 = path.getOrDefault("billingAccountName")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "billingAccountName", valid_564665
  var valid_564666 = path.getOrDefault("invoiceSectionName")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "invoiceSectionName", valid_564666
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564667 = query.getOrDefault("api-version")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "api-version", valid_564667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564668: Call_BillingPermissionsListByInvoiceSections_564662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under invoice section.
  ## 
  let valid = call_564668.validator(path, query, header, formData, body)
  let scheme = call_564668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564668.url(scheme.get, call_564668.host, call_564668.base,
                         call_564668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564668, url, valid)

proc call*(call_564669: Call_BillingPermissionsListByInvoiceSections_564662;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingPermissionsListByInvoiceSections
  ## Lists all billing permissions for the caller under invoice section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564670 = newJObject()
  var query_564671 = newJObject()
  add(query_564671, "api-version", newJString(apiVersion))
  add(path_564670, "billingAccountName", newJString(billingAccountName))
  add(path_564670, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564669.call(path_564670, query_564671, nil, nil, nil)

var billingPermissionsListByInvoiceSections* = Call_BillingPermissionsListByInvoiceSections_564662(
    name: "billingPermissionsListByInvoiceSections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByInvoiceSections_564663, base: "",
    url: url_BillingPermissionsListByInvoiceSections_564664,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByInvoiceSectionName_564672 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsListByInvoiceSectionName_564674(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsListByInvoiceSectionName_564673(
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
  var valid_564675 = path.getOrDefault("billingAccountName")
  valid_564675 = validateParameter(valid_564675, JString, required = true,
                                 default = nil)
  if valid_564675 != nil:
    section.add "billingAccountName", valid_564675
  var valid_564676 = path.getOrDefault("invoiceSectionName")
  valid_564676 = validateParameter(valid_564676, JString, required = true,
                                 default = nil)
  if valid_564676 != nil:
    section.add "invoiceSectionName", valid_564676
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564677 = query.getOrDefault("api-version")
  valid_564677 = validateParameter(valid_564677, JString, required = true,
                                 default = nil)
  if valid_564677 != nil:
    section.add "api-version", valid_564677
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564678: Call_BillingRoleAssignmentsListByInvoiceSectionName_564672;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the invoice Section
  ## 
  let valid = call_564678.validator(path, query, header, formData, body)
  let scheme = call_564678.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564678.url(scheme.get, call_564678.host, call_564678.base,
                         call_564678.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564678, url, valid)

proc call*(call_564679: Call_BillingRoleAssignmentsListByInvoiceSectionName_564672;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsListByInvoiceSectionName
  ## Get the role assignments on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564680 = newJObject()
  var query_564681 = newJObject()
  add(query_564681, "api-version", newJString(apiVersion))
  add(path_564680, "billingAccountName", newJString(billingAccountName))
  add(path_564680, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564679.call(path_564680, query_564681, nil, nil, nil)

var billingRoleAssignmentsListByInvoiceSectionName* = Call_BillingRoleAssignmentsListByInvoiceSectionName_564672(
    name: "billingRoleAssignmentsListByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByInvoiceSectionName_564673,
    base: "", url: url_BillingRoleAssignmentsListByInvoiceSectionName_564674,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByInvoiceSectionName_564682 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsGetByInvoiceSectionName_564684(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsGetByInvoiceSectionName_564683(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignment for the caller on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564685 = path.getOrDefault("billingAccountName")
  valid_564685 = validateParameter(valid_564685, JString, required = true,
                                 default = nil)
  if valid_564685 != nil:
    section.add "billingAccountName", valid_564685
  var valid_564686 = path.getOrDefault("billingRoleAssignmentName")
  valid_564686 = validateParameter(valid_564686, JString, required = true,
                                 default = nil)
  if valid_564686 != nil:
    section.add "billingRoleAssignmentName", valid_564686
  var valid_564687 = path.getOrDefault("invoiceSectionName")
  valid_564687 = validateParameter(valid_564687, JString, required = true,
                                 default = nil)
  if valid_564687 != nil:
    section.add "invoiceSectionName", valid_564687
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564688 = query.getOrDefault("api-version")
  valid_564688 = validateParameter(valid_564688, JString, required = true,
                                 default = nil)
  if valid_564688 != nil:
    section.add "api-version", valid_564688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564689: Call_BillingRoleAssignmentsGetByInvoiceSectionName_564682;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller on the invoice Section
  ## 
  let valid = call_564689.validator(path, query, header, formData, body)
  let scheme = call_564689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564689.url(scheme.get, call_564689.host, call_564689.base,
                         call_564689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564689, url, valid)

proc call*(call_564690: Call_BillingRoleAssignmentsGetByInvoiceSectionName_564682;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string; invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsGetByInvoiceSectionName
  ## Get the role assignment for the caller on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564691 = newJObject()
  var query_564692 = newJObject()
  add(query_564692, "api-version", newJString(apiVersion))
  add(path_564691, "billingAccountName", newJString(billingAccountName))
  add(path_564691, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_564691, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564690.call(path_564691, query_564692, nil, nil, nil)

var billingRoleAssignmentsGetByInvoiceSectionName* = Call_BillingRoleAssignmentsGetByInvoiceSectionName_564682(
    name: "billingRoleAssignmentsGetByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByInvoiceSectionName_564683,
    base: "", url: url_BillingRoleAssignmentsGetByInvoiceSectionName_564684,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_564693 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsDeleteByInvoiceSectionName_564695(
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

proc validate_BillingRoleAssignmentsDeleteByInvoiceSectionName_564694(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete the role assignment on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564696 = path.getOrDefault("billingAccountName")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "billingAccountName", valid_564696
  var valid_564697 = path.getOrDefault("billingRoleAssignmentName")
  valid_564697 = validateParameter(valid_564697, JString, required = true,
                                 default = nil)
  if valid_564697 != nil:
    section.add "billingRoleAssignmentName", valid_564697
  var valid_564698 = path.getOrDefault("invoiceSectionName")
  valid_564698 = validateParameter(valid_564698, JString, required = true,
                                 default = nil)
  if valid_564698 != nil:
    section.add "invoiceSectionName", valid_564698
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564699 = query.getOrDefault("api-version")
  valid_564699 = validateParameter(valid_564699, JString, required = true,
                                 default = nil)
  if valid_564699 != nil:
    section.add "api-version", valid_564699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564700: Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_564693;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on the invoice Section
  ## 
  let valid = call_564700.validator(path, query, header, formData, body)
  let scheme = call_564700.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564700.url(scheme.get, call_564700.host, call_564700.base,
                         call_564700.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564700, url, valid)

proc call*(call_564701: Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_564693;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string; invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsDeleteByInvoiceSectionName
  ## Delete the role assignment on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564702 = newJObject()
  var query_564703 = newJObject()
  add(query_564703, "api-version", newJString(apiVersion))
  add(path_564702, "billingAccountName", newJString(billingAccountName))
  add(path_564702, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_564702, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564701.call(path_564702, query_564703, nil, nil, nil)

var billingRoleAssignmentsDeleteByInvoiceSectionName* = Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_564693(
    name: "billingRoleAssignmentsDeleteByInvoiceSectionName",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByInvoiceSectionName_564694,
    base: "", url: url_BillingRoleAssignmentsDeleteByInvoiceSectionName_564695,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByInvoiceSectionName_564704 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsListByInvoiceSectionName_564706(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsListByInvoiceSectionName_564705(
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
  var valid_564707 = path.getOrDefault("billingAccountName")
  valid_564707 = validateParameter(valid_564707, JString, required = true,
                                 default = nil)
  if valid_564707 != nil:
    section.add "billingAccountName", valid_564707
  var valid_564708 = path.getOrDefault("invoiceSectionName")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "invoiceSectionName", valid_564708
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564709 = query.getOrDefault("api-version")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "api-version", valid_564709
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564710: Call_BillingRoleDefinitionsListByInvoiceSectionName_564704;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for an invoice Section
  ## 
  let valid = call_564710.validator(path, query, header, formData, body)
  let scheme = call_564710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564710.url(scheme.get, call_564710.host, call_564710.base,
                         call_564710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564710, url, valid)

proc call*(call_564711: Call_BillingRoleDefinitionsListByInvoiceSectionName_564704;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingRoleDefinitionsListByInvoiceSectionName
  ## Lists the role definition for an invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564712 = newJObject()
  var query_564713 = newJObject()
  add(query_564713, "api-version", newJString(apiVersion))
  add(path_564712, "billingAccountName", newJString(billingAccountName))
  add(path_564712, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564711.call(path_564712, query_564713, nil, nil, nil)

var billingRoleDefinitionsListByInvoiceSectionName* = Call_BillingRoleDefinitionsListByInvoiceSectionName_564704(
    name: "billingRoleDefinitionsListByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByInvoiceSectionName_564705,
    base: "", url: url_BillingRoleDefinitionsListByInvoiceSectionName_564706,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByInvoiceSectionName_564714 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsGetByInvoiceSectionName_564716(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsGetByInvoiceSectionName_564715(
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
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564717 = path.getOrDefault("billingAccountName")
  valid_564717 = validateParameter(valid_564717, JString, required = true,
                                 default = nil)
  if valid_564717 != nil:
    section.add "billingAccountName", valid_564717
  var valid_564718 = path.getOrDefault("billingRoleDefinitionName")
  valid_564718 = validateParameter(valid_564718, JString, required = true,
                                 default = nil)
  if valid_564718 != nil:
    section.add "billingRoleDefinitionName", valid_564718
  var valid_564719 = path.getOrDefault("invoiceSectionName")
  valid_564719 = validateParameter(valid_564719, JString, required = true,
                                 default = nil)
  if valid_564719 != nil:
    section.add "invoiceSectionName", valid_564719
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564720 = query.getOrDefault("api-version")
  valid_564720 = validateParameter(valid_564720, JString, required = true,
                                 default = nil)
  if valid_564720 != nil:
    section.add "api-version", valid_564720
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564721: Call_BillingRoleDefinitionsGetByInvoiceSectionName_564714;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_564721.validator(path, query, header, formData, body)
  let scheme = call_564721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564721.url(scheme.get, call_564721.host, call_564721.base,
                         call_564721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564721, url, valid)

proc call*(call_564722: Call_BillingRoleDefinitionsGetByInvoiceSectionName_564714;
          apiVersion: string; billingAccountName: string;
          billingRoleDefinitionName: string; invoiceSectionName: string): Recallable =
  ## billingRoleDefinitionsGetByInvoiceSectionName
  ## Gets the role definition for a role
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingRoleDefinitionName: string (required)
  ##                            : role definition id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564723 = newJObject()
  var query_564724 = newJObject()
  add(query_564724, "api-version", newJString(apiVersion))
  add(path_564723, "billingAccountName", newJString(billingAccountName))
  add(path_564723, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  add(path_564723, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564722.call(path_564723, query_564724, nil, nil, nil)

var billingRoleDefinitionsGetByInvoiceSectionName* = Call_BillingRoleDefinitionsGetByInvoiceSectionName_564714(
    name: "billingRoleDefinitionsGetByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByInvoiceSectionName_564715,
    base: "", url: url_BillingRoleDefinitionsGetByInvoiceSectionName_564716,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByInvoiceSectionName_564725 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsAddByInvoiceSectionName_564727(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsAddByInvoiceSectionName_564726(
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
  var valid_564728 = path.getOrDefault("billingAccountName")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = nil)
  if valid_564728 != nil:
    section.add "billingAccountName", valid_564728
  var valid_564729 = path.getOrDefault("invoiceSectionName")
  valid_564729 = validateParameter(valid_564729, JString, required = true,
                                 default = nil)
  if valid_564729 != nil:
    section.add "invoiceSectionName", valid_564729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564730 = query.getOrDefault("api-version")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "api-version", valid_564730
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

proc call*(call_564732: Call_BillingRoleAssignmentsAddByInvoiceSectionName_564725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a invoice Section.
  ## 
  let valid = call_564732.validator(path, query, header, formData, body)
  let scheme = call_564732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564732.url(scheme.get, call_564732.host, call_564732.base,
                         call_564732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564732, url, valid)

proc call*(call_564733: Call_BillingRoleAssignmentsAddByInvoiceSectionName_564725;
          apiVersion: string; billingAccountName: string; parameters: JsonNode;
          invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsAddByInvoiceSectionName
  ## The operation to add a role assignment to a invoice Section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564734 = newJObject()
  var query_564735 = newJObject()
  var body_564736 = newJObject()
  add(query_564735, "api-version", newJString(apiVersion))
  add(path_564734, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_564736 = parameters
  add(path_564734, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564733.call(path_564734, query_564735, nil, nil, body_564736)

var billingRoleAssignmentsAddByInvoiceSectionName* = Call_BillingRoleAssignmentsAddByInvoiceSectionName_564725(
    name: "billingRoleAssignmentsAddByInvoiceSectionName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByInvoiceSectionName_564726,
    base: "", url: url_BillingRoleAssignmentsAddByInvoiceSectionName_564727,
    schemes: {Scheme.Https})
type
  Call_TransactionsListByInvoiceSectionName_564737 = ref object of OpenApiRestCall_563565
proc url_TransactionsListByInvoiceSectionName_564739(protocol: Scheme;
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

proc validate_TransactionsListByInvoiceSectionName_564738(path: JsonNode;
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
  var valid_564740 = path.getOrDefault("billingAccountName")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "billingAccountName", valid_564740
  var valid_564741 = path.getOrDefault("invoiceSectionName")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "invoiceSectionName", valid_564741
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564742 = query.getOrDefault("api-version")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "api-version", valid_564742
  var valid_564743 = query.getOrDefault("endDate")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = nil)
  if valid_564743 != nil:
    section.add "endDate", valid_564743
  var valid_564744 = query.getOrDefault("$filter")
  valid_564744 = validateParameter(valid_564744, JString, required = false,
                                 default = nil)
  if valid_564744 != nil:
    section.add "$filter", valid_564744
  var valid_564745 = query.getOrDefault("startDate")
  valid_564745 = validateParameter(valid_564745, JString, required = true,
                                 default = nil)
  if valid_564745 != nil:
    section.add "startDate", valid_564745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564746: Call_TransactionsListByInvoiceSectionName_564737;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564746.validator(path, query, header, formData, body)
  let scheme = call_564746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564746.url(scheme.get, call_564746.host, call_564746.base,
                         call_564746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564746, url, valid)

proc call*(call_564747: Call_TransactionsListByInvoiceSectionName_564737;
          apiVersion: string; billingAccountName: string; endDate: string;
          startDate: string; invoiceSectionName: string; Filter: string = ""): Recallable =
  ## transactionsListByInvoiceSectionName
  ## Lists the transactions by invoice section name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   endDate: string (required)
  ##          : End date
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: string (required)
  ##            : Start date
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564748 = newJObject()
  var query_564749 = newJObject()
  add(query_564749, "api-version", newJString(apiVersion))
  add(path_564748, "billingAccountName", newJString(billingAccountName))
  add(query_564749, "endDate", newJString(endDate))
  add(query_564749, "$filter", newJString(Filter))
  add(query_564749, "startDate", newJString(startDate))
  add(path_564748, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564747.call(path_564748, query_564749, nil, nil, nil)

var transactionsListByInvoiceSectionName* = Call_TransactionsListByInvoiceSectionName_564737(
    name: "transactionsListByInvoiceSectionName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transactions",
    validator: validate_TransactionsListByInvoiceSectionName_564738, base: "",
    url: url_TransactionsListByInvoiceSectionName_564739, schemes: {Scheme.Https})
type
  Call_TransfersList_564750 = ref object of OpenApiRestCall_563565
proc url_TransfersList_564752(protocol: Scheme; host: string; base: string;
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

proc validate_TransfersList_564751(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564753 = path.getOrDefault("billingAccountName")
  valid_564753 = validateParameter(valid_564753, JString, required = true,
                                 default = nil)
  if valid_564753 != nil:
    section.add "billingAccountName", valid_564753
  var valid_564754 = path.getOrDefault("invoiceSectionName")
  valid_564754 = validateParameter(valid_564754, JString, required = true,
                                 default = nil)
  if valid_564754 != nil:
    section.add "invoiceSectionName", valid_564754
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564755: Call_TransfersList_564750; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  let valid = call_564755.validator(path, query, header, formData, body)
  let scheme = call_564755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564755.url(scheme.get, call_564755.host, call_564755.base,
                         call_564755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564755, url, valid)

proc call*(call_564756: Call_TransfersList_564750; billingAccountName: string;
          invoiceSectionName: string): Recallable =
  ## transfersList
  ## Lists all transfer's details initiated from given invoice section.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564757 = newJObject()
  add(path_564757, "billingAccountName", newJString(billingAccountName))
  add(path_564757, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564756.call(path_564757, nil, nil, nil, nil)

var transfersList* = Call_TransfersList_564750(name: "transfersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transfers",
    validator: validate_TransfersList_564751, base: "", url: url_TransfersList_564752,
    schemes: {Scheme.Https})
type
  Call_TransfersGet_564758 = ref object of OpenApiRestCall_563565
proc url_TransfersGet_564760(protocol: Scheme; host: string; base: string;
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

proc validate_TransfersGet_564759(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the transfer details for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_564761 = path.getOrDefault("transferName")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "transferName", valid_564761
  var valid_564762 = path.getOrDefault("billingAccountName")
  valid_564762 = validateParameter(valid_564762, JString, required = true,
                                 default = nil)
  if valid_564762 != nil:
    section.add "billingAccountName", valid_564762
  var valid_564763 = path.getOrDefault("invoiceSectionName")
  valid_564763 = validateParameter(valid_564763, JString, required = true,
                                 default = nil)
  if valid_564763 != nil:
    section.add "invoiceSectionName", valid_564763
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564764: Call_TransfersGet_564758; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the transfer details for given transfer Id.
  ## 
  let valid = call_564764.validator(path, query, header, formData, body)
  let scheme = call_564764.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564764.url(scheme.get, call_564764.host, call_564764.base,
                         call_564764.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564764, url, valid)

proc call*(call_564765: Call_TransfersGet_564758; transferName: string;
          billingAccountName: string; invoiceSectionName: string): Recallable =
  ## transfersGet
  ## Gets the transfer details for given transfer Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564766 = newJObject()
  add(path_564766, "transferName", newJString(transferName))
  add(path_564766, "billingAccountName", newJString(billingAccountName))
  add(path_564766, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564765.call(path_564766, nil, nil, nil, nil)

var transfersGet* = Call_TransfersGet_564758(name: "transfersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transfers/{transferName}",
    validator: validate_TransfersGet_564759, base: "", url: url_TransfersGet_564760,
    schemes: {Scheme.Https})
type
  Call_TransfersCancel_564767 = ref object of OpenApiRestCall_563565
proc url_TransfersCancel_564769(protocol: Scheme; host: string; base: string;
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

proc validate_TransfersCancel_564768(path: JsonNode; query: JsonNode;
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
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_564770 = path.getOrDefault("transferName")
  valid_564770 = validateParameter(valid_564770, JString, required = true,
                                 default = nil)
  if valid_564770 != nil:
    section.add "transferName", valid_564770
  var valid_564771 = path.getOrDefault("billingAccountName")
  valid_564771 = validateParameter(valid_564771, JString, required = true,
                                 default = nil)
  if valid_564771 != nil:
    section.add "billingAccountName", valid_564771
  var valid_564772 = path.getOrDefault("invoiceSectionName")
  valid_564772 = validateParameter(valid_564772, JString, required = true,
                                 default = nil)
  if valid_564772 != nil:
    section.add "invoiceSectionName", valid_564772
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564773: Call_TransfersCancel_564767; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the transfer for given transfer Id.
  ## 
  let valid = call_564773.validator(path, query, header, formData, body)
  let scheme = call_564773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564773.url(scheme.get, call_564773.host, call_564773.base,
                         call_564773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564773, url, valid)

proc call*(call_564774: Call_TransfersCancel_564767; transferName: string;
          billingAccountName: string; invoiceSectionName: string): Recallable =
  ## transfersCancel
  ## Cancels the transfer for given transfer Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_564775 = newJObject()
  add(path_564775, "transferName", newJString(transferName))
  add(path_564775, "billingAccountName", newJString(billingAccountName))
  add(path_564775, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_564774.call(path_564775, nil, nil, nil, nil)

var transfersCancel* = Call_TransfersCancel_564767(name: "transfersCancel",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transfers/{transferName}",
    validator: validate_TransfersCancel_564768, base: "", url: url_TransfersCancel_564769,
    schemes: {Scheme.Https})
type
  Call_InvoicesListByBillingAccountName_564776 = ref object of OpenApiRestCall_563565
proc url_InvoicesListByBillingAccountName_564778(protocol: Scheme; host: string;
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

proc validate_InvoicesListByBillingAccountName_564777(path: JsonNode;
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
  var valid_564779 = path.getOrDefault("billingAccountName")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "billingAccountName", valid_564779
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
  var valid_564780 = query.getOrDefault("api-version")
  valid_564780 = validateParameter(valid_564780, JString, required = true,
                                 default = nil)
  if valid_564780 != nil:
    section.add "api-version", valid_564780
  var valid_564781 = query.getOrDefault("periodEndDate")
  valid_564781 = validateParameter(valid_564781, JString, required = true,
                                 default = nil)
  if valid_564781 != nil:
    section.add "periodEndDate", valid_564781
  var valid_564782 = query.getOrDefault("periodStartDate")
  valid_564782 = validateParameter(valid_564782, JString, required = true,
                                 default = nil)
  if valid_564782 != nil:
    section.add "periodStartDate", valid_564782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564783: Call_InvoicesListByBillingAccountName_564776;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of invoices for a billing account.
  ## 
  let valid = call_564783.validator(path, query, header, formData, body)
  let scheme = call_564783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564783.url(scheme.get, call_564783.host, call_564783.base,
                         call_564783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564783, url, valid)

proc call*(call_564784: Call_InvoicesListByBillingAccountName_564776;
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
  var path_564785 = newJObject()
  var query_564786 = newJObject()
  add(query_564786, "api-version", newJString(apiVersion))
  add(path_564785, "billingAccountName", newJString(billingAccountName))
  add(query_564786, "periodEndDate", newJString(periodEndDate))
  add(query_564786, "periodStartDate", newJString(periodStartDate))
  result = call_564784.call(path_564785, query_564786, nil, nil, nil)

var invoicesListByBillingAccountName* = Call_InvoicesListByBillingAccountName_564776(
    name: "invoicesListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoices",
    validator: validate_InvoicesListByBillingAccountName_564777, base: "",
    url: url_InvoicesListByBillingAccountName_564778, schemes: {Scheme.Https})
type
  Call_PriceSheetDownload_564787 = ref object of OpenApiRestCall_563565
proc url_PriceSheetDownload_564789(protocol: Scheme; host: string; base: string;
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

proc validate_PriceSheetDownload_564788(path: JsonNode; query: JsonNode;
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
  var valid_564790 = path.getOrDefault("billingAccountName")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "billingAccountName", valid_564790
  var valid_564791 = path.getOrDefault("invoiceName")
  valid_564791 = validateParameter(valid_564791, JString, required = true,
                                 default = nil)
  if valid_564791 != nil:
    section.add "invoiceName", valid_564791
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564792 = query.getOrDefault("api-version")
  valid_564792 = validateParameter(valid_564792, JString, required = true,
                                 default = nil)
  if valid_564792 != nil:
    section.add "api-version", valid_564792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564793: Call_PriceSheetDownload_564787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Download price sheet for an invoice.
  ## 
  let valid = call_564793.validator(path, query, header, formData, body)
  let scheme = call_564793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564793.url(scheme.get, call_564793.host, call_564793.base,
                         call_564793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564793, url, valid)

proc call*(call_564794: Call_PriceSheetDownload_564787; apiVersion: string;
          billingAccountName: string; invoiceName: string): Recallable =
  ## priceSheetDownload
  ## Download price sheet for an invoice.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Azure Billing Account ID.
  ##   invoiceName: string (required)
  ##              : The name of an invoice resource.
  var path_564795 = newJObject()
  var query_564796 = newJObject()
  add(query_564796, "api-version", newJString(apiVersion))
  add(path_564795, "billingAccountName", newJString(billingAccountName))
  add(path_564795, "invoiceName", newJString(invoiceName))
  result = call_564794.call(path_564795, query_564796, nil, nil, nil)

var priceSheetDownload* = Call_PriceSheetDownload_564787(
    name: "priceSheetDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoices/{invoiceName}/pricesheet/default/download",
    validator: validate_PriceSheetDownload_564788, base: "",
    url: url_PriceSheetDownload_564789, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsListByCreateSubscriptionPermission_564797 = ref object of OpenApiRestCall_563565
proc url_InvoiceSectionsListByCreateSubscriptionPermission_564799(
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

proc validate_InvoiceSectionsListByCreateSubscriptionPermission_564798(
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
  var valid_564800 = path.getOrDefault("billingAccountName")
  valid_564800 = validateParameter(valid_564800, JString, required = true,
                                 default = nil)
  if valid_564800 != nil:
    section.add "billingAccountName", valid_564800
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564801 = query.getOrDefault("api-version")
  valid_564801 = validateParameter(valid_564801, JString, required = true,
                                 default = nil)
  if valid_564801 != nil:
    section.add "api-version", valid_564801
  var valid_564802 = query.getOrDefault("$expand")
  valid_564802 = validateParameter(valid_564802, JString, required = false,
                                 default = nil)
  if valid_564802 != nil:
    section.add "$expand", valid_564802
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564803: Call_InvoiceSectionsListByCreateSubscriptionPermission_564797;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoiceSections with create subscription permission for a user.
  ## 
  let valid = call_564803.validator(path, query, header, formData, body)
  let scheme = call_564803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564803.url(scheme.get, call_564803.host, call_564803.base,
                         call_564803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564803, url, valid)

proc call*(call_564804: Call_InvoiceSectionsListByCreateSubscriptionPermission_564797;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## invoiceSectionsListByCreateSubscriptionPermission
  ## Lists all invoiceSections with create subscription permission for a user.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Expand: string
  ##         : May be used to expand the billingProfiles.
  var path_564805 = newJObject()
  var query_564806 = newJObject()
  add(query_564806, "api-version", newJString(apiVersion))
  add(path_564805, "billingAccountName", newJString(billingAccountName))
  add(query_564806, "$expand", newJString(Expand))
  result = call_564804.call(path_564805, query_564806, nil, nil, nil)

var invoiceSectionsListByCreateSubscriptionPermission* = Call_InvoiceSectionsListByCreateSubscriptionPermission_564797(
    name: "invoiceSectionsListByCreateSubscriptionPermission",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/listInvoiceSectionsWithCreateSubscriptionPermission",
    validator: validate_InvoiceSectionsListByCreateSubscriptionPermission_564798,
    base: "", url: url_InvoiceSectionsListByCreateSubscriptionPermission_564799,
    schemes: {Scheme.Https})
type
  Call_PaymentMethodsListByBillingAccountName_564807 = ref object of OpenApiRestCall_563565
proc url_PaymentMethodsListByBillingAccountName_564809(protocol: Scheme;
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

proc validate_PaymentMethodsListByBillingAccountName_564808(path: JsonNode;
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
  var valid_564810 = path.getOrDefault("billingAccountName")
  valid_564810 = validateParameter(valid_564810, JString, required = true,
                                 default = nil)
  if valid_564810 != nil:
    section.add "billingAccountName", valid_564810
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564811 = query.getOrDefault("api-version")
  valid_564811 = validateParameter(valid_564811, JString, required = true,
                                 default = nil)
  if valid_564811 != nil:
    section.add "api-version", valid_564811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564812: Call_PaymentMethodsListByBillingAccountName_564807;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Payment Methods by billing account Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/2018-11-01-preview/paymentmethods
  let valid = call_564812.validator(path, query, header, formData, body)
  let scheme = call_564812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564812.url(scheme.get, call_564812.host, call_564812.base,
                         call_564812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564812, url, valid)

proc call*(call_564813: Call_PaymentMethodsListByBillingAccountName_564807;
          apiVersion: string; billingAccountName: string): Recallable =
  ## paymentMethodsListByBillingAccountName
  ## Lists the Payment Methods by billing account Id.
  ## https://docs.microsoft.com/en-us/rest/api/billing/2018-11-01-preview/paymentmethods
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_564814 = newJObject()
  var query_564815 = newJObject()
  add(query_564815, "api-version", newJString(apiVersion))
  add(path_564814, "billingAccountName", newJString(billingAccountName))
  result = call_564813.call(path_564814, query_564815, nil, nil, nil)

var paymentMethodsListByBillingAccountName* = Call_PaymentMethodsListByBillingAccountName_564807(
    name: "paymentMethodsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/paymentMethods",
    validator: validate_PaymentMethodsListByBillingAccountName_564808, base: "",
    url: url_PaymentMethodsListByBillingAccountName_564809,
    schemes: {Scheme.Https})
type
  Call_ProductsListByBillingAccountName_564816 = ref object of OpenApiRestCall_563565
proc url_ProductsListByBillingAccountName_564818(protocol: Scheme; host: string;
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

proc validate_ProductsListByBillingAccountName_564817(path: JsonNode;
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
  var valid_564819 = path.getOrDefault("billingAccountName")
  valid_564819 = validateParameter(valid_564819, JString, required = true,
                                 default = nil)
  if valid_564819 != nil:
    section.add "billingAccountName", valid_564819
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564820 = query.getOrDefault("api-version")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = nil)
  if valid_564820 != nil:
    section.add "api-version", valid_564820
  var valid_564821 = query.getOrDefault("$filter")
  valid_564821 = validateParameter(valid_564821, JString, required = false,
                                 default = nil)
  if valid_564821 != nil:
    section.add "$filter", valid_564821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564822: Call_ProductsListByBillingAccountName_564816;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists products by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564822.validator(path, query, header, formData, body)
  let scheme = call_564822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564822.url(scheme.get, call_564822.host, call_564822.base,
                         call_564822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564822, url, valid)

proc call*(call_564823: Call_ProductsListByBillingAccountName_564816;
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
  var path_564824 = newJObject()
  var query_564825 = newJObject()
  add(query_564825, "api-version", newJString(apiVersion))
  add(path_564824, "billingAccountName", newJString(billingAccountName))
  add(query_564825, "$filter", newJString(Filter))
  result = call_564823.call(path_564824, query_564825, nil, nil, nil)

var productsListByBillingAccountName* = Call_ProductsListByBillingAccountName_564816(
    name: "productsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/products",
    validator: validate_ProductsListByBillingAccountName_564817, base: "",
    url: url_ProductsListByBillingAccountName_564818, schemes: {Scheme.Https})
type
  Call_ProductsUpdateAutoRenewByBillingAccountName_564826 = ref object of OpenApiRestCall_563565
proc url_ProductsUpdateAutoRenewByBillingAccountName_564828(protocol: Scheme;
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

proc validate_ProductsUpdateAutoRenewByBillingAccountName_564827(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel auto renew for product by product id and billing account name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   productName: JString (required)
  ##              : Invoice Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564829 = path.getOrDefault("billingAccountName")
  valid_564829 = validateParameter(valid_564829, JString, required = true,
                                 default = nil)
  if valid_564829 != nil:
    section.add "billingAccountName", valid_564829
  var valid_564830 = path.getOrDefault("productName")
  valid_564830 = validateParameter(valid_564830, JString, required = true,
                                 default = nil)
  if valid_564830 != nil:
    section.add "productName", valid_564830
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564831 = query.getOrDefault("api-version")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "api-version", valid_564831
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

proc call*(call_564833: Call_ProductsUpdateAutoRenewByBillingAccountName_564826;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancel auto renew for product by product id and billing account name
  ## 
  let valid = call_564833.validator(path, query, header, formData, body)
  let scheme = call_564833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564833.url(scheme.get, call_564833.host, call_564833.base,
                         call_564833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564833, url, valid)

proc call*(call_564834: Call_ProductsUpdateAutoRenewByBillingAccountName_564826;
          apiVersion: string; billingAccountName: string; productName: string;
          body: JsonNode): Recallable =
  ## productsUpdateAutoRenewByBillingAccountName
  ## Cancel auto renew for product by product id and billing account name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  var path_564835 = newJObject()
  var query_564836 = newJObject()
  var body_564837 = newJObject()
  add(query_564836, "api-version", newJString(apiVersion))
  add(path_564835, "billingAccountName", newJString(billingAccountName))
  add(path_564835, "productName", newJString(productName))
  if body != nil:
    body_564837 = body
  result = call_564834.call(path_564835, query_564836, nil, nil, body_564837)

var productsUpdateAutoRenewByBillingAccountName* = Call_ProductsUpdateAutoRenewByBillingAccountName_564826(
    name: "productsUpdateAutoRenewByBillingAccountName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/products/{productName}/updateAutoRenew",
    validator: validate_ProductsUpdateAutoRenewByBillingAccountName_564827,
    base: "", url: url_ProductsUpdateAutoRenewByBillingAccountName_564828,
    schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByBillingAccount_564838 = ref object of OpenApiRestCall_563565
proc url_BillingPermissionsListByBillingAccount_564840(protocol: Scheme;
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

proc validate_BillingPermissionsListByBillingAccount_564839(path: JsonNode;
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
  var valid_564841 = path.getOrDefault("billingAccountName")
  valid_564841 = validateParameter(valid_564841, JString, required = true,
                                 default = nil)
  if valid_564841 != nil:
    section.add "billingAccountName", valid_564841
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564842 = query.getOrDefault("api-version")
  valid_564842 = validateParameter(valid_564842, JString, required = true,
                                 default = nil)
  if valid_564842 != nil:
    section.add "api-version", valid_564842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564843: Call_BillingPermissionsListByBillingAccount_564838;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under a billing account.
  ## 
  let valid = call_564843.validator(path, query, header, formData, body)
  let scheme = call_564843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564843.url(scheme.get, call_564843.host, call_564843.base,
                         call_564843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564843, url, valid)

proc call*(call_564844: Call_BillingPermissionsListByBillingAccount_564838;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingPermissionsListByBillingAccount
  ## Lists all billing permissions for the caller under a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_564845 = newJObject()
  var query_564846 = newJObject()
  add(query_564846, "api-version", newJString(apiVersion))
  add(path_564845, "billingAccountName", newJString(billingAccountName))
  result = call_564844.call(path_564845, query_564846, nil, nil, nil)

var billingPermissionsListByBillingAccount* = Call_BillingPermissionsListByBillingAccount_564838(
    name: "billingPermissionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByBillingAccount_564839, base: "",
    url: url_BillingPermissionsListByBillingAccount_564840,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByBillingAccountName_564847 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsListByBillingAccountName_564849(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsListByBillingAccountName_564848(
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
  var valid_564850 = path.getOrDefault("billingAccountName")
  valid_564850 = validateParameter(valid_564850, JString, required = true,
                                 default = nil)
  if valid_564850 != nil:
    section.add "billingAccountName", valid_564850
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564851 = query.getOrDefault("api-version")
  valid_564851 = validateParameter(valid_564851, JString, required = true,
                                 default = nil)
  if valid_564851 != nil:
    section.add "api-version", valid_564851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564852: Call_BillingRoleAssignmentsListByBillingAccountName_564847;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the Billing Account
  ## 
  let valid = call_564852.validator(path, query, header, formData, body)
  let scheme = call_564852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564852.url(scheme.get, call_564852.host, call_564852.base,
                         call_564852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564852, url, valid)

proc call*(call_564853: Call_BillingRoleAssignmentsListByBillingAccountName_564847;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingRoleAssignmentsListByBillingAccountName
  ## Get the role assignments on the Billing Account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_564854 = newJObject()
  var query_564855 = newJObject()
  add(query_564855, "api-version", newJString(apiVersion))
  add(path_564854, "billingAccountName", newJString(billingAccountName))
  result = call_564853.call(path_564854, query_564855, nil, nil, nil)

var billingRoleAssignmentsListByBillingAccountName* = Call_BillingRoleAssignmentsListByBillingAccountName_564847(
    name: "billingRoleAssignmentsListByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByBillingAccountName_564848,
    base: "", url: url_BillingRoleAssignmentsListByBillingAccountName_564849,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByBillingAccount_564856 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsGetByBillingAccount_564858(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsGetByBillingAccount_564857(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignment for the caller
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564859 = path.getOrDefault("billingAccountName")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = nil)
  if valid_564859 != nil:
    section.add "billingAccountName", valid_564859
  var valid_564860 = path.getOrDefault("billingRoleAssignmentName")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "billingRoleAssignmentName", valid_564860
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
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

proc call*(call_564862: Call_BillingRoleAssignmentsGetByBillingAccount_564856;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller
  ## 
  let valid = call_564862.validator(path, query, header, formData, body)
  let scheme = call_564862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564862.url(scheme.get, call_564862.host, call_564862.base,
                         call_564862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564862, url, valid)

proc call*(call_564863: Call_BillingRoleAssignmentsGetByBillingAccount_564856;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string): Recallable =
  ## billingRoleAssignmentsGetByBillingAccount
  ## Get the role assignment for the caller
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  var path_564864 = newJObject()
  var query_564865 = newJObject()
  add(query_564865, "api-version", newJString(apiVersion))
  add(path_564864, "billingAccountName", newJString(billingAccountName))
  add(path_564864, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  result = call_564863.call(path_564864, query_564865, nil, nil, nil)

var billingRoleAssignmentsGetByBillingAccount* = Call_BillingRoleAssignmentsGetByBillingAccount_564856(
    name: "billingRoleAssignmentsGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByBillingAccount_564857,
    base: "", url: url_BillingRoleAssignmentsGetByBillingAccount_564858,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByBillingAccountName_564866 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsDeleteByBillingAccountName_564868(
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

proc validate_BillingRoleAssignmentsDeleteByBillingAccountName_564867(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete the role assignment on this billing account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_564869 = path.getOrDefault("billingAccountName")
  valid_564869 = validateParameter(valid_564869, JString, required = true,
                                 default = nil)
  if valid_564869 != nil:
    section.add "billingAccountName", valid_564869
  var valid_564870 = path.getOrDefault("billingRoleAssignmentName")
  valid_564870 = validateParameter(valid_564870, JString, required = true,
                                 default = nil)
  if valid_564870 != nil:
    section.add "billingRoleAssignmentName", valid_564870
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
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

proc call*(call_564872: Call_BillingRoleAssignmentsDeleteByBillingAccountName_564866;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on this billing account
  ## 
  let valid = call_564872.validator(path, query, header, formData, body)
  let scheme = call_564872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564872.url(scheme.get, call_564872.host, call_564872.base,
                         call_564872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564872, url, valid)

proc call*(call_564873: Call_BillingRoleAssignmentsDeleteByBillingAccountName_564866;
          apiVersion: string; billingAccountName: string;
          billingRoleAssignmentName: string): Recallable =
  ## billingRoleAssignmentsDeleteByBillingAccountName
  ## Delete the role assignment on this billing account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  var path_564874 = newJObject()
  var query_564875 = newJObject()
  add(query_564875, "api-version", newJString(apiVersion))
  add(path_564874, "billingAccountName", newJString(billingAccountName))
  add(path_564874, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  result = call_564873.call(path_564874, query_564875, nil, nil, nil)

var billingRoleAssignmentsDeleteByBillingAccountName* = Call_BillingRoleAssignmentsDeleteByBillingAccountName_564866(
    name: "billingRoleAssignmentsDeleteByBillingAccountName",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByBillingAccountName_564867,
    base: "", url: url_BillingRoleAssignmentsDeleteByBillingAccountName_564868,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByBillingAccountName_564876 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsListByBillingAccountName_564878(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsListByBillingAccountName_564877(
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
  var valid_564879 = path.getOrDefault("billingAccountName")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "billingAccountName", valid_564879
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564880 = query.getOrDefault("api-version")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "api-version", valid_564880
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564881: Call_BillingRoleDefinitionsListByBillingAccountName_564876;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for a billing account
  ## 
  let valid = call_564881.validator(path, query, header, formData, body)
  let scheme = call_564881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564881.url(scheme.get, call_564881.host, call_564881.base,
                         call_564881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564881, url, valid)

proc call*(call_564882: Call_BillingRoleDefinitionsListByBillingAccountName_564876;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingRoleDefinitionsListByBillingAccountName
  ## Lists the role definition for a billing account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_564883 = newJObject()
  var query_564884 = newJObject()
  add(query_564884, "api-version", newJString(apiVersion))
  add(path_564883, "billingAccountName", newJString(billingAccountName))
  result = call_564882.call(path_564883, query_564884, nil, nil, nil)

var billingRoleDefinitionsListByBillingAccountName* = Call_BillingRoleDefinitionsListByBillingAccountName_564876(
    name: "billingRoleDefinitionsListByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByBillingAccountName_564877,
    base: "", url: url_BillingRoleDefinitionsListByBillingAccountName_564878,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByBillingAccountName_564885 = ref object of OpenApiRestCall_563565
proc url_BillingRoleDefinitionsGetByBillingAccountName_564887(protocol: Scheme;
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

proc validate_BillingRoleDefinitionsGetByBillingAccountName_564886(
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
  var valid_564888 = path.getOrDefault("billingAccountName")
  valid_564888 = validateParameter(valid_564888, JString, required = true,
                                 default = nil)
  if valid_564888 != nil:
    section.add "billingAccountName", valid_564888
  var valid_564889 = path.getOrDefault("billingRoleDefinitionName")
  valid_564889 = validateParameter(valid_564889, JString, required = true,
                                 default = nil)
  if valid_564889 != nil:
    section.add "billingRoleDefinitionName", valid_564889
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564890 = query.getOrDefault("api-version")
  valid_564890 = validateParameter(valid_564890, JString, required = true,
                                 default = nil)
  if valid_564890 != nil:
    section.add "api-version", valid_564890
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564891: Call_BillingRoleDefinitionsGetByBillingAccountName_564885;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_564891.validator(path, query, header, formData, body)
  let scheme = call_564891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564891.url(scheme.get, call_564891.host, call_564891.base,
                         call_564891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564891, url, valid)

proc call*(call_564892: Call_BillingRoleDefinitionsGetByBillingAccountName_564885;
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
  var path_564893 = newJObject()
  var query_564894 = newJObject()
  add(query_564894, "api-version", newJString(apiVersion))
  add(path_564893, "billingAccountName", newJString(billingAccountName))
  add(path_564893, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  result = call_564892.call(path_564893, query_564894, nil, nil, nil)

var billingRoleDefinitionsGetByBillingAccountName* = Call_BillingRoleDefinitionsGetByBillingAccountName_564885(
    name: "billingRoleDefinitionsGetByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByBillingAccountName_564886,
    base: "", url: url_BillingRoleDefinitionsGetByBillingAccountName_564887,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByBillingAccountName_564895 = ref object of OpenApiRestCall_563565
proc url_BillingRoleAssignmentsAddByBillingAccountName_564897(protocol: Scheme;
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

proc validate_BillingRoleAssignmentsAddByBillingAccountName_564896(
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
  var valid_564898 = path.getOrDefault("billingAccountName")
  valid_564898 = validateParameter(valid_564898, JString, required = true,
                                 default = nil)
  if valid_564898 != nil:
    section.add "billingAccountName", valid_564898
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564899 = query.getOrDefault("api-version")
  valid_564899 = validateParameter(valid_564899, JString, required = true,
                                 default = nil)
  if valid_564899 != nil:
    section.add "api-version", valid_564899
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

proc call*(call_564901: Call_BillingRoleAssignmentsAddByBillingAccountName_564895;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a billing account.
  ## 
  let valid = call_564901.validator(path, query, header, formData, body)
  let scheme = call_564901.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564901.url(scheme.get, call_564901.host, call_564901.base,
                         call_564901.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564901, url, valid)

proc call*(call_564902: Call_BillingRoleAssignmentsAddByBillingAccountName_564895;
          apiVersion: string; billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingRoleAssignmentsAddByBillingAccountName
  ## The operation to add a role assignment to a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  var path_564903 = newJObject()
  var query_564904 = newJObject()
  var body_564905 = newJObject()
  add(query_564904, "api-version", newJString(apiVersion))
  add(path_564903, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_564905 = parameters
  result = call_564902.call(path_564903, query_564904, nil, nil, body_564905)

var billingRoleAssignmentsAddByBillingAccountName* = Call_BillingRoleAssignmentsAddByBillingAccountName_564895(
    name: "billingRoleAssignmentsAddByBillingAccountName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByBillingAccountName_564896,
    base: "", url: url_BillingRoleAssignmentsAddByBillingAccountName_564897,
    schemes: {Scheme.Https})
type
  Call_TransactionsListByBillingAccountName_564906 = ref object of OpenApiRestCall_563565
proc url_TransactionsListByBillingAccountName_564908(protocol: Scheme;
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

proc validate_TransactionsListByBillingAccountName_564907(path: JsonNode;
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
  var valid_564909 = path.getOrDefault("billingAccountName")
  valid_564909 = validateParameter(valid_564909, JString, required = true,
                                 default = nil)
  if valid_564909 != nil:
    section.add "billingAccountName", valid_564909
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564910 = query.getOrDefault("api-version")
  valid_564910 = validateParameter(valid_564910, JString, required = true,
                                 default = nil)
  if valid_564910 != nil:
    section.add "api-version", valid_564910
  var valid_564911 = query.getOrDefault("endDate")
  valid_564911 = validateParameter(valid_564911, JString, required = true,
                                 default = nil)
  if valid_564911 != nil:
    section.add "endDate", valid_564911
  var valid_564912 = query.getOrDefault("$filter")
  valid_564912 = validateParameter(valid_564912, JString, required = false,
                                 default = nil)
  if valid_564912 != nil:
    section.add "$filter", valid_564912
  var valid_564913 = query.getOrDefault("startDate")
  valid_564913 = validateParameter(valid_564913, JString, required = true,
                                 default = nil)
  if valid_564913 != nil:
    section.add "startDate", valid_564913
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564914: Call_TransactionsListByBillingAccountName_564906;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by billing account name for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564914.validator(path, query, header, formData, body)
  let scheme = call_564914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564914.url(scheme.get, call_564914.host, call_564914.base,
                         call_564914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564914, url, valid)

proc call*(call_564915: Call_TransactionsListByBillingAccountName_564906;
          apiVersion: string; billingAccountName: string; endDate: string;
          startDate: string; Filter: string = ""): Recallable =
  ## transactionsListByBillingAccountName
  ## Lists the transactions by billing account name for given start and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   endDate: string (required)
  ##          : End date
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   startDate: string (required)
  ##            : Start date
  var path_564916 = newJObject()
  var query_564917 = newJObject()
  add(query_564917, "api-version", newJString(apiVersion))
  add(path_564916, "billingAccountName", newJString(billingAccountName))
  add(query_564917, "endDate", newJString(endDate))
  add(query_564917, "$filter", newJString(Filter))
  add(query_564917, "startDate", newJString(startDate))
  result = call_564915.call(path_564916, query_564917, nil, nil, nil)

var transactionsListByBillingAccountName* = Call_TransactionsListByBillingAccountName_564906(
    name: "transactionsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/transactions",
    validator: validate_TransactionsListByBillingAccountName_564907, base: "",
    url: url_TransactionsListByBillingAccountName_564908, schemes: {Scheme.Https})
type
  Call_OperationsList_564918 = ref object of OpenApiRestCall_563565
proc url_OperationsList_564920(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564919(path: JsonNode; query: JsonNode;
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
  var valid_564921 = query.getOrDefault("api-version")
  valid_564921 = validateParameter(valid_564921, JString, required = true,
                                 default = nil)
  if valid_564921 != nil:
    section.add "api-version", valid_564921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564922: Call_OperationsList_564918; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available billing REST API operations.
  ## 
  let valid = call_564922.validator(path, query, header, formData, body)
  let scheme = call_564922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564922.url(scheme.get, call_564922.host, call_564922.base,
                         call_564922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564922, url, valid)

proc call*(call_564923: Call_OperationsList_564918; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available billing REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  var query_564924 = newJObject()
  add(query_564924, "api-version", newJString(apiVersion))
  result = call_564923.call(nil, query_564924, nil, nil, nil)

var operationsList* = Call_OperationsList_564918(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/operations",
    validator: validate_OperationsList_564919, base: "", url: url_OperationsList_564920,
    schemes: {Scheme.Https})
type
  Call_RecipientTransfersList_564925 = ref object of OpenApiRestCall_563565
proc url_RecipientTransfersList_564927(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecipientTransfersList_564926(path: JsonNode; query: JsonNode;
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

proc call*(call_564928: Call_RecipientTransfersList_564925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564928.validator(path, query, header, formData, body)
  let scheme = call_564928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564928.url(scheme.get, call_564928.host, call_564928.base,
                         call_564928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564928, url, valid)

proc call*(call_564929: Call_RecipientTransfersList_564925): Recallable =
  ## recipientTransfersList
  result = call_564929.call(nil, nil, nil, nil, nil)

var recipientTransfersList* = Call_RecipientTransfersList_564925(
    name: "recipientTransfersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers",
    validator: validate_RecipientTransfersList_564926, base: "",
    url: url_RecipientTransfersList_564927, schemes: {Scheme.Https})
type
  Call_RecipientTransfersGet_564930 = ref object of OpenApiRestCall_563565
proc url_RecipientTransfersGet_564932(protocol: Scheme; host: string; base: string;
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

proc validate_RecipientTransfersGet_564931(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_564933 = path.getOrDefault("transferName")
  valid_564933 = validateParameter(valid_564933, JString, required = true,
                                 default = nil)
  if valid_564933 != nil:
    section.add "transferName", valid_564933
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564934: Call_RecipientTransfersGet_564930; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564934.validator(path, query, header, formData, body)
  let scheme = call_564934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564934.url(scheme.get, call_564934.host, call_564934.base,
                         call_564934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564934, url, valid)

proc call*(call_564935: Call_RecipientTransfersGet_564930; transferName: string): Recallable =
  ## recipientTransfersGet
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_564936 = newJObject()
  add(path_564936, "transferName", newJString(transferName))
  result = call_564935.call(path_564936, nil, nil, nil, nil)

var recipientTransfersGet* = Call_RecipientTransfersGet_564930(
    name: "recipientTransfersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/transfers/{transferName}/",
    validator: validate_RecipientTransfersGet_564931, base: "",
    url: url_RecipientTransfersGet_564932, schemes: {Scheme.Https})
type
  Call_RecipientTransfersAccept_564937 = ref object of OpenApiRestCall_563565
proc url_RecipientTransfersAccept_564939(protocol: Scheme; host: string;
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

proc validate_RecipientTransfersAccept_564938(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_564940 = path.getOrDefault("transferName")
  valid_564940 = validateParameter(valid_564940, JString, required = true,
                                 default = nil)
  if valid_564940 != nil:
    section.add "transferName", valid_564940
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

proc call*(call_564942: Call_RecipientTransfersAccept_564937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564942.validator(path, query, header, formData, body)
  let scheme = call_564942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564942.url(scheme.get, call_564942.host, call_564942.base,
                         call_564942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564942, url, valid)

proc call*(call_564943: Call_RecipientTransfersAccept_564937; transferName: string;
          body: JsonNode): Recallable =
  ## recipientTransfersAccept
  ##   transferName: string (required)
  ##               : Transfer Name.
  ##   body: JObject (required)
  ##       : Accept transfer parameters.
  var path_564944 = newJObject()
  var body_564945 = newJObject()
  add(path_564944, "transferName", newJString(transferName))
  if body != nil:
    body_564945 = body
  result = call_564943.call(path_564944, nil, nil, nil, body_564945)

var recipientTransfersAccept* = Call_RecipientTransfersAccept_564937(
    name: "recipientTransfersAccept", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/acceptTransfer",
    validator: validate_RecipientTransfersAccept_564938, base: "",
    url: url_RecipientTransfersAccept_564939, schemes: {Scheme.Https})
type
  Call_RecipientTransfersDecline_564946 = ref object of OpenApiRestCall_563565
proc url_RecipientTransfersDecline_564948(protocol: Scheme; host: string;
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

proc validate_RecipientTransfersDecline_564947(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_564949 = path.getOrDefault("transferName")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "transferName", valid_564949
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564950: Call_RecipientTransfersDecline_564946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564950.validator(path, query, header, formData, body)
  let scheme = call_564950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564950.url(scheme.get, call_564950.host, call_564950.base,
                         call_564950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564950, url, valid)

proc call*(call_564951: Call_RecipientTransfersDecline_564946; transferName: string): Recallable =
  ## recipientTransfersDecline
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_564952 = newJObject()
  add(path_564952, "transferName", newJString(transferName))
  result = call_564951.call(path_564952, nil, nil, nil, nil)

var recipientTransfersDecline* = Call_RecipientTransfersDecline_564946(
    name: "recipientTransfersDecline", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/declineTransfer",
    validator: validate_RecipientTransfersDecline_564947, base: "",
    url: url_RecipientTransfersDecline_564948, schemes: {Scheme.Https})
type
  Call_AddressesValidate_564953 = ref object of OpenApiRestCall_563565
proc url_AddressesValidate_564955(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AddressesValidate_564954(path: JsonNode; query: JsonNode;
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
  var valid_564956 = query.getOrDefault("api-version")
  valid_564956 = validateParameter(valid_564956, JString, required = true,
                                 default = nil)
  if valid_564956 != nil:
    section.add "api-version", valid_564956
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

proc call*(call_564958: Call_AddressesValidate_564953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the address.
  ## 
  let valid = call_564958.validator(path, query, header, formData, body)
  let scheme = call_564958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564958.url(scheme.get, call_564958.host, call_564958.base,
                         call_564958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564958, url, valid)

proc call*(call_564959: Call_AddressesValidate_564953; apiVersion: string;
          address: JsonNode): Recallable =
  ## addressesValidate
  ## Validates the address.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   address: JObject (required)
  var query_564960 = newJObject()
  var body_564961 = newJObject()
  add(query_564960, "api-version", newJString(apiVersion))
  if address != nil:
    body_564961 = address
  result = call_564959.call(nil, query_564960, nil, nil, body_564961)

var addressesValidate* = Call_AddressesValidate_564953(name: "addressesValidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/validateAddress",
    validator: validate_AddressesValidate_564954, base: "",
    url: url_AddressesValidate_564955, schemes: {Scheme.Https})
type
  Call_LineOfCreditsUpdate_564971 = ref object of OpenApiRestCall_563565
proc url_LineOfCreditsUpdate_564973(protocol: Scheme; host: string; base: string;
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

proc validate_LineOfCreditsUpdate_564972(path: JsonNode; query: JsonNode;
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
  var valid_564974 = path.getOrDefault("subscriptionId")
  valid_564974 = validateParameter(valid_564974, JString, required = true,
                                 default = nil)
  if valid_564974 != nil:
    section.add "subscriptionId", valid_564974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564975 = query.getOrDefault("api-version")
  valid_564975 = validateParameter(valid_564975, JString, required = true,
                                 default = nil)
  if valid_564975 != nil:
    section.add "api-version", valid_564975
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

proc call*(call_564977: Call_LineOfCreditsUpdate_564971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Increase the current line of credit.
  ## 
  let valid = call_564977.validator(path, query, header, formData, body)
  let scheme = call_564977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564977.url(scheme.get, call_564977.host, call_564977.base,
                         call_564977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564977, url, valid)

proc call*(call_564978: Call_LineOfCreditsUpdate_564971; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## lineOfCreditsUpdate
  ## Increase the current line of credit.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the increase line of credit operation.
  var path_564979 = newJObject()
  var query_564980 = newJObject()
  var body_564981 = newJObject()
  add(query_564980, "api-version", newJString(apiVersion))
  add(path_564979, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564981 = parameters
  result = call_564978.call(path_564979, query_564980, nil, nil, body_564981)

var lineOfCreditsUpdate* = Call_LineOfCreditsUpdate_564971(
    name: "lineOfCreditsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default",
    validator: validate_LineOfCreditsUpdate_564972, base: "",
    url: url_LineOfCreditsUpdate_564973, schemes: {Scheme.Https})
type
  Call_LineOfCreditsGet_564962 = ref object of OpenApiRestCall_563565
proc url_LineOfCreditsGet_564964(protocol: Scheme; host: string; base: string;
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

proc validate_LineOfCreditsGet_564963(path: JsonNode; query: JsonNode;
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
  var valid_564965 = path.getOrDefault("subscriptionId")
  valid_564965 = validateParameter(valid_564965, JString, required = true,
                                 default = nil)
  if valid_564965 != nil:
    section.add "subscriptionId", valid_564965
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564966 = query.getOrDefault("api-version")
  valid_564966 = validateParameter(valid_564966, JString, required = true,
                                 default = nil)
  if valid_564966 != nil:
    section.add "api-version", valid_564966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564967: Call_LineOfCreditsGet_564962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the current line of credit.
  ## 
  let valid = call_564967.validator(path, query, header, formData, body)
  let scheme = call_564967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564967.url(scheme.get, call_564967.host, call_564967.base,
                         call_564967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564967, url, valid)

proc call*(call_564968: Call_LineOfCreditsGet_564962; apiVersion: string;
          subscriptionId: string): Recallable =
  ## lineOfCreditsGet
  ## Get the current line of credit.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id.
  var path_564969 = newJObject()
  var query_564970 = newJObject()
  add(query_564970, "api-version", newJString(apiVersion))
  add(path_564969, "subscriptionId", newJString(subscriptionId))
  result = call_564968.call(path_564969, query_564970, nil, nil, nil)

var lineOfCreditsGet* = Call_LineOfCreditsGet_564962(name: "lineOfCreditsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default",
    validator: validate_LineOfCreditsGet_564963, base: "",
    url: url_LineOfCreditsGet_564964, schemes: {Scheme.Https})
type
  Call_BillingPropertyGet_564982 = ref object of OpenApiRestCall_563565
proc url_BillingPropertyGet_564984(protocol: Scheme; host: string; base: string;
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

proc validate_BillingPropertyGet_564983(path: JsonNode; query: JsonNode;
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
  var valid_564985 = path.getOrDefault("subscriptionId")
  valid_564985 = validateParameter(valid_564985, JString, required = true,
                                 default = nil)
  if valid_564985 != nil:
    section.add "subscriptionId", valid_564985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564986 = query.getOrDefault("api-version")
  valid_564986 = validateParameter(valid_564986, JString, required = true,
                                 default = nil)
  if valid_564986 != nil:
    section.add "api-version", valid_564986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564987: Call_BillingPropertyGet_564982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get billing property by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564987.validator(path, query, header, formData, body)
  let scheme = call_564987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564987.url(scheme.get, call_564987.host, call_564987.base,
                         call_564987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564987, url, valid)

proc call*(call_564988: Call_BillingPropertyGet_564982; apiVersion: string;
          subscriptionId: string): Recallable =
  ## billingPropertyGet
  ## Get billing property by subscription Id.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id.
  var path_564989 = newJObject()
  var query_564990 = newJObject()
  add(query_564990, "api-version", newJString(apiVersion))
  add(path_564989, "subscriptionId", newJString(subscriptionId))
  result = call_564988.call(path_564989, query_564990, nil, nil, nil)

var billingPropertyGet* = Call_BillingPropertyGet_564982(
    name: "billingPropertyGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingProperty",
    validator: validate_BillingPropertyGet_564983, base: "",
    url: url_BillingPropertyGet_564984, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
