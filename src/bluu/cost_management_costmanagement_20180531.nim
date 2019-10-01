
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CostManagementClient
## version: 2018-05-31
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_567659 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567659](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567659): Option[Scheme] {.used.} =
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
  macServiceName = "cost-management-costmanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QueryBillingAccount_567881 = ref object of OpenApiRestCall_567659
proc url_QueryBillingAccount_567883(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/Query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryBillingAccount_567882(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists the usage data for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568073 = path.getOrDefault("billingAccountId")
  valid_568073 = validateParameter(valid_568073, JString, required = true,
                                 default = nil)
  if valid_568073 != nil:
    section.add "billingAccountId", valid_568073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568074 = query.getOrDefault("api-version")
  valid_568074 = validateParameter(valid_568074, JString, required = true,
                                 default = nil)
  if valid_568074 != nil:
    section.add "api-version", valid_568074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568098: Call_QueryBillingAccount_567881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568098.validator(path, query, header, formData, body)
  let scheme = call_568098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568098.url(scheme.get, call_568098.host, call_568098.base,
                         call_568098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568098, url, valid)

proc call*(call_568169: Call_QueryBillingAccount_567881; apiVersion: string;
          billingAccountId: string; parameters: JsonNode): Recallable =
  ## queryBillingAccount
  ## Lists the usage data for billing account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568170 = newJObject()
  var query_568172 = newJObject()
  var body_568173 = newJObject()
  add(query_568172, "api-version", newJString(apiVersion))
  add(path_568170, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568173 = parameters
  result = call_568169.call(path_568170, query_568172, nil, nil, body_568173)

var queryBillingAccount* = Call_QueryBillingAccount_567881(
    name: "queryBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryBillingAccount_567882, base: "",
    url: url_QueryBillingAccount_567883, schemes: {Scheme.Https})
type
  Call_BillingAccountDimensionsList_568212 = ref object of OpenApiRestCall_567659
proc url_BillingAccountDimensionsList_568214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/dimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingAccountDimensionsList_568213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the dimensions by billingAccount Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568216 = path.getOrDefault("billingAccountId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "billingAccountId", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   $expand: JString
  ##          : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N dimension data.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  var valid_568218 = query.getOrDefault("$expand")
  valid_568218 = validateParameter(valid_568218, JString, required = false,
                                 default = nil)
  if valid_568218 != nil:
    section.add "$expand", valid_568218
  var valid_568219 = query.getOrDefault("$top")
  valid_568219 = validateParameter(valid_568219, JInt, required = false, default = nil)
  if valid_568219 != nil:
    section.add "$top", valid_568219
  var valid_568220 = query.getOrDefault("$skiptoken")
  valid_568220 = validateParameter(valid_568220, JString, required = false,
                                 default = nil)
  if valid_568220 != nil:
    section.add "$skiptoken", valid_568220
  var valid_568221 = query.getOrDefault("$filter")
  valid_568221 = validateParameter(valid_568221, JString, required = false,
                                 default = nil)
  if valid_568221 != nil:
    section.add "$filter", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_BillingAccountDimensionsList_568212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by billingAccount Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_BillingAccountDimensionsList_568212;
          apiVersion: string; billingAccountId: string; Expand: string = "";
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## billingAccountDimensionsList
  ## Lists the dimensions by billingAccount Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(query_568225, "$expand", newJString(Expand))
  add(query_568225, "$top", newJInt(Top))
  add(query_568225, "$skiptoken", newJString(Skiptoken))
  add(path_568224, "billingAccountId", newJString(billingAccountId))
  add(query_568225, "$filter", newJString(Filter))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var billingAccountDimensionsList* = Call_BillingAccountDimensionsList_568212(
    name: "billingAccountDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_BillingAccountDimensionsList_568213, base: "",
    url: url_BillingAccountDimensionsList_568214, schemes: {Scheme.Https})
type
  Call_OperationsList_568226 = ref object of OpenApiRestCall_567659
proc url_OperationsList_568228(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568227(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available consumption REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568229 = query.getOrDefault("api-version")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "api-version", valid_568229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568230: Call_OperationsList_568226; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_OperationsList_568226; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  var query_568232 = newJObject()
  add(query_568232, "api-version", newJString(apiVersion))
  result = call_568231.call(nil, query_568232, nil, nil, nil)

var operationsList* = Call_OperationsList_568226(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/operations",
    validator: validate_OperationsList_568227, base: "", url: url_OperationsList_568228,
    schemes: {Scheme.Https})
type
  Call_QuerySubscription_568233 = ref object of OpenApiRestCall_567659
proc url_QuerySubscription_568235(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/Query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuerySubscription_568234(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists the usage data for subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568236 = path.getOrDefault("subscriptionId")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "subscriptionId", valid_568236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568237 = query.getOrDefault("api-version")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "api-version", valid_568237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_QuerySubscription_568233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_QuerySubscription_568233; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## querySubscription
  ## Lists the usage data for subscriptionId.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  var body_568243 = newJObject()
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568243 = parameters
  result = call_568240.call(path_568241, query_568242, nil, nil, body_568243)

var querySubscription* = Call_QuerySubscription_568233(name: "querySubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QuerySubscription_568234, base: "",
    url: url_QuerySubscription_568235, schemes: {Scheme.Https})
type
  Call_SubscriptionDimensionsList_568244 = ref object of OpenApiRestCall_567659
proc url_SubscriptionDimensionsList_568246(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/dimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionDimensionsList_568245(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the dimensions by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   $expand: JString
  ##          : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N dimension data.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
  var valid_568249 = query.getOrDefault("$expand")
  valid_568249 = validateParameter(valid_568249, JString, required = false,
                                 default = nil)
  if valid_568249 != nil:
    section.add "$expand", valid_568249
  var valid_568250 = query.getOrDefault("$top")
  valid_568250 = validateParameter(valid_568250, JInt, required = false, default = nil)
  if valid_568250 != nil:
    section.add "$top", valid_568250
  var valid_568251 = query.getOrDefault("$skiptoken")
  valid_568251 = validateParameter(valid_568251, JString, required = false,
                                 default = nil)
  if valid_568251 != nil:
    section.add "$skiptoken", valid_568251
  var valid_568252 = query.getOrDefault("$filter")
  valid_568252 = validateParameter(valid_568252, JString, required = false,
                                 default = nil)
  if valid_568252 != nil:
    section.add "$filter", valid_568252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_SubscriptionDimensionsList_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_SubscriptionDimensionsList_568244; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## subscriptionDimensionsList
  ## Lists the dimensions by subscription Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  add(query_568256, "api-version", newJString(apiVersion))
  add(query_568256, "$expand", newJString(Expand))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  add(query_568256, "$top", newJInt(Top))
  add(query_568256, "$skiptoken", newJString(Skiptoken))
  add(query_568256, "$filter", newJString(Filter))
  result = call_568254.call(path_568255, query_568256, nil, nil, nil)

var subscriptionDimensionsList* = Call_SubscriptionDimensionsList_568244(
    name: "subscriptionDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_SubscriptionDimensionsList_568245, base: "",
    url: url_SubscriptionDimensionsList_568246, schemes: {Scheme.Https})
type
  Call_ReportConfigList_568257 = ref object of OpenApiRestCall_567659
proc url_ReportConfigList_568259(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.CostManagement/reportconfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportConfigList_568258(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all report configs for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568262: Call_ReportConfigList_568257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all report configs for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_ReportConfigList_568257; apiVersion: string;
          subscriptionId: string): Recallable =
  ## reportConfigList
  ## Lists all report configs for a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568264 = newJObject()
  var query_568265 = newJObject()
  add(query_568265, "api-version", newJString(apiVersion))
  add(path_568264, "subscriptionId", newJString(subscriptionId))
  result = call_568263.call(path_568264, query_568265, nil, nil, nil)

var reportConfigList* = Call_ReportConfigList_568257(name: "reportConfigList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reportconfigs",
    validator: validate_ReportConfigList_568258, base: "",
    url: url_ReportConfigList_568259, schemes: {Scheme.Https})
type
  Call_ReportConfigCreateOrUpdate_568276 = ref object of OpenApiRestCall_567659
proc url_ReportConfigCreateOrUpdate_568278(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "reportConfigName" in path,
        "`reportConfigName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reportconfigs/"),
               (kind: VariableSegment, value: "reportConfigName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportConfigCreateOrUpdate_568277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a report config. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportConfigName: JString (required)
  ##                   : Report Config Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568279 = path.getOrDefault("subscriptionId")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "subscriptionId", valid_568279
  var valid_568280 = path.getOrDefault("reportConfigName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "reportConfigName", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568281 = query.getOrDefault("api-version")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "api-version", valid_568281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_ReportConfigCreateOrUpdate_568276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a report config. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_ReportConfigCreateOrUpdate_568276; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; reportConfigName: string): Recallable =
  ## reportConfigCreateOrUpdate
  ## The operation to create or update a report config. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  ##   reportConfigName: string (required)
  ##                   : Report Config Name.
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  var body_568287 = newJObject()
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568287 = parameters
  add(path_568285, "reportConfigName", newJString(reportConfigName))
  result = call_568284.call(path_568285, query_568286, nil, nil, body_568287)

var reportConfigCreateOrUpdate* = Call_ReportConfigCreateOrUpdate_568276(
    name: "reportConfigCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reportconfigs/{reportConfigName}",
    validator: validate_ReportConfigCreateOrUpdate_568277, base: "",
    url: url_ReportConfigCreateOrUpdate_568278, schemes: {Scheme.Https})
type
  Call_ReportConfigGet_568266 = ref object of OpenApiRestCall_567659
proc url_ReportConfigGet_568268(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "reportConfigName" in path,
        "`reportConfigName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reportconfigs/"),
               (kind: VariableSegment, value: "reportConfigName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportConfigGet_568267(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the report config for a subscription by report config name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportConfigName: JString (required)
  ##                   : Report Config Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568269 = path.getOrDefault("subscriptionId")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "subscriptionId", valid_568269
  var valid_568270 = path.getOrDefault("reportConfigName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "reportConfigName", valid_568270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568272: Call_ReportConfigGet_568266; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report config for a subscription by report config name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568272.validator(path, query, header, formData, body)
  let scheme = call_568272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568272.url(scheme.get, call_568272.host, call_568272.base,
                         call_568272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568272, url, valid)

proc call*(call_568273: Call_ReportConfigGet_568266; apiVersion: string;
          subscriptionId: string; reportConfigName: string): Recallable =
  ## reportConfigGet
  ## Gets the report config for a subscription by report config name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportConfigName: string (required)
  ##                   : Report Config Name.
  var path_568274 = newJObject()
  var query_568275 = newJObject()
  add(query_568275, "api-version", newJString(apiVersion))
  add(path_568274, "subscriptionId", newJString(subscriptionId))
  add(path_568274, "reportConfigName", newJString(reportConfigName))
  result = call_568273.call(path_568274, query_568275, nil, nil, nil)

var reportConfigGet* = Call_ReportConfigGet_568266(name: "reportConfigGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reportconfigs/{reportConfigName}",
    validator: validate_ReportConfigGet_568267, base: "", url: url_ReportConfigGet_568268,
    schemes: {Scheme.Https})
type
  Call_ReportConfigDelete_568288 = ref object of OpenApiRestCall_567659
proc url_ReportConfigDelete_568290(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "reportConfigName" in path,
        "`reportConfigName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reportconfigs/"),
               (kind: VariableSegment, value: "reportConfigName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportConfigDelete_568289(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The operation to delete a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportConfigName: JString (required)
  ##                   : Report Config Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568291 = path.getOrDefault("subscriptionId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "subscriptionId", valid_568291
  var valid_568292 = path.getOrDefault("reportConfigName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "reportConfigName", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_ReportConfigDelete_568288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_ReportConfigDelete_568288; apiVersion: string;
          subscriptionId: string; reportConfigName: string): Recallable =
  ## reportConfigDelete
  ## The operation to delete a report.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportConfigName: string (required)
  ##                   : Report Config Name.
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  add(path_568296, "reportConfigName", newJString(reportConfigName))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var reportConfigDelete* = Call_ReportConfigDelete_568288(
    name: "reportConfigDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reportconfigs/{reportConfigName}",
    validator: validate_ReportConfigDelete_568289, base: "",
    url: url_ReportConfigDelete_568290, schemes: {Scheme.Https})
type
  Call_ResourceGroupDimensionsList_568298 = ref object of OpenApiRestCall_567659
proc url_ResourceGroupDimensionsList_568300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/dimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupDimensionsList_568299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the dimensions by resource group Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568301 = path.getOrDefault("resourceGroupName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "resourceGroupName", valid_568301
  var valid_568302 = path.getOrDefault("subscriptionId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "subscriptionId", valid_568302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   $expand: JString
  ##          : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N dimension data.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568303 = query.getOrDefault("api-version")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "api-version", valid_568303
  var valid_568304 = query.getOrDefault("$expand")
  valid_568304 = validateParameter(valid_568304, JString, required = false,
                                 default = nil)
  if valid_568304 != nil:
    section.add "$expand", valid_568304
  var valid_568305 = query.getOrDefault("$top")
  valid_568305 = validateParameter(valid_568305, JInt, required = false, default = nil)
  if valid_568305 != nil:
    section.add "$top", valid_568305
  var valid_568306 = query.getOrDefault("$skiptoken")
  valid_568306 = validateParameter(valid_568306, JString, required = false,
                                 default = nil)
  if valid_568306 != nil:
    section.add "$skiptoken", valid_568306
  var valid_568307 = query.getOrDefault("$filter")
  valid_568307 = validateParameter(valid_568307, JString, required = false,
                                 default = nil)
  if valid_568307 != nil:
    section.add "$filter", valid_568307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568308: Call_ResourceGroupDimensionsList_568298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by resource group Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568308.validator(path, query, header, formData, body)
  let scheme = call_568308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568308.url(scheme.get, call_568308.host, call_568308.base,
                         call_568308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568308, url, valid)

proc call*(call_568309: Call_ResourceGroupDimensionsList_568298;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## resourceGroupDimensionsList
  ## Lists the dimensions by resource group Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568310 = newJObject()
  var query_568311 = newJObject()
  add(path_568310, "resourceGroupName", newJString(resourceGroupName))
  add(query_568311, "api-version", newJString(apiVersion))
  add(query_568311, "$expand", newJString(Expand))
  add(path_568310, "subscriptionId", newJString(subscriptionId))
  add(query_568311, "$top", newJInt(Top))
  add(query_568311, "$skiptoken", newJString(Skiptoken))
  add(query_568311, "$filter", newJString(Filter))
  result = call_568309.call(path_568310, query_568311, nil, nil, nil)

var resourceGroupDimensionsList* = Call_ResourceGroupDimensionsList_568298(
    name: "resourceGroupDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_ResourceGroupDimensionsList_568299, base: "",
    url: url_ResourceGroupDimensionsList_568300, schemes: {Scheme.Https})
type
  Call_ReportConfigListByResourceGroupName_568312 = ref object of OpenApiRestCall_567659
proc url_ReportConfigListByResourceGroupName_568314(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reportconfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportConfigListByResourceGroupName_568313(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all report configs for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568315 = path.getOrDefault("resourceGroupName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "resourceGroupName", valid_568315
  var valid_568316 = path.getOrDefault("subscriptionId")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "subscriptionId", valid_568316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "api-version", valid_568317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568318: Call_ReportConfigListByResourceGroupName_568312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all report configs for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_ReportConfigListByResourceGroupName_568312;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## reportConfigListByResourceGroupName
  ## Lists all report configs for a resource group under a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  add(path_568320, "resourceGroupName", newJString(resourceGroupName))
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  result = call_568319.call(path_568320, query_568321, nil, nil, nil)

var reportConfigListByResourceGroupName* = Call_ReportConfigListByResourceGroupName_568312(
    name: "reportConfigListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reportconfigs",
    validator: validate_ReportConfigListByResourceGroupName_568313, base: "",
    url: url_ReportConfigListByResourceGroupName_568314, schemes: {Scheme.Https})
type
  Call_ReportConfigCreateOrUpdateByResourceGroupName_568333 = ref object of OpenApiRestCall_567659
proc url_ReportConfigCreateOrUpdateByResourceGroupName_568335(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "reportConfigName" in path,
        "`reportConfigName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reportconfigs/"),
               (kind: VariableSegment, value: "reportConfigName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportConfigCreateOrUpdateByResourceGroupName_568334(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to create or update a report config. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportConfigName: JString (required)
  ##                   : Report Config Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568336 = path.getOrDefault("resourceGroupName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "resourceGroupName", valid_568336
  var valid_568337 = path.getOrDefault("subscriptionId")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "subscriptionId", valid_568337
  var valid_568338 = path.getOrDefault("reportConfigName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "reportConfigName", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "api-version", valid_568339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568341: Call_ReportConfigCreateOrUpdateByResourceGroupName_568333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a report config. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568341.validator(path, query, header, formData, body)
  let scheme = call_568341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568341.url(scheme.get, call_568341.host, call_568341.base,
                         call_568341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568341, url, valid)

proc call*(call_568342: Call_ReportConfigCreateOrUpdateByResourceGroupName_568333;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; reportConfigName: string): Recallable =
  ## reportConfigCreateOrUpdateByResourceGroupName
  ## The operation to create or update a report config. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  ##   reportConfigName: string (required)
  ##                   : Report Config Name.
  var path_568343 = newJObject()
  var query_568344 = newJObject()
  var body_568345 = newJObject()
  add(path_568343, "resourceGroupName", newJString(resourceGroupName))
  add(query_568344, "api-version", newJString(apiVersion))
  add(path_568343, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568345 = parameters
  add(path_568343, "reportConfigName", newJString(reportConfigName))
  result = call_568342.call(path_568343, query_568344, nil, nil, body_568345)

var reportConfigCreateOrUpdateByResourceGroupName* = Call_ReportConfigCreateOrUpdateByResourceGroupName_568333(
    name: "reportConfigCreateOrUpdateByResourceGroupName",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reportconfigs/{reportConfigName}",
    validator: validate_ReportConfigCreateOrUpdateByResourceGroupName_568334,
    base: "", url: url_ReportConfigCreateOrUpdateByResourceGroupName_568335,
    schemes: {Scheme.Https})
type
  Call_ReportConfigGetByResourceGroupName_568322 = ref object of OpenApiRestCall_567659
proc url_ReportConfigGetByResourceGroupName_568324(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "reportConfigName" in path,
        "`reportConfigName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reportconfigs/"),
               (kind: VariableSegment, value: "reportConfigName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportConfigGetByResourceGroupName_568323(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the report config for a resource group under a subscription by report config name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportConfigName: JString (required)
  ##                   : Report Config Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568325 = path.getOrDefault("resourceGroupName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "resourceGroupName", valid_568325
  var valid_568326 = path.getOrDefault("subscriptionId")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "subscriptionId", valid_568326
  var valid_568327 = path.getOrDefault("reportConfigName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "reportConfigName", valid_568327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568328 = query.getOrDefault("api-version")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "api-version", valid_568328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568329: Call_ReportConfigGetByResourceGroupName_568322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the report config for a resource group under a subscription by report config name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_ReportConfigGetByResourceGroupName_568322;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          reportConfigName: string): Recallable =
  ## reportConfigGetByResourceGroupName
  ## Gets the report config for a resource group under a subscription by report config name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportConfigName: string (required)
  ##                   : Report Config Name.
  var path_568331 = newJObject()
  var query_568332 = newJObject()
  add(path_568331, "resourceGroupName", newJString(resourceGroupName))
  add(query_568332, "api-version", newJString(apiVersion))
  add(path_568331, "subscriptionId", newJString(subscriptionId))
  add(path_568331, "reportConfigName", newJString(reportConfigName))
  result = call_568330.call(path_568331, query_568332, nil, nil, nil)

var reportConfigGetByResourceGroupName* = Call_ReportConfigGetByResourceGroupName_568322(
    name: "reportConfigGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reportconfigs/{reportConfigName}",
    validator: validate_ReportConfigGetByResourceGroupName_568323, base: "",
    url: url_ReportConfigGetByResourceGroupName_568324, schemes: {Scheme.Https})
type
  Call_ReportConfigDeleteByResourceGroupName_568346 = ref object of OpenApiRestCall_567659
proc url_ReportConfigDeleteByResourceGroupName_568348(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "reportConfigName" in path,
        "`reportConfigName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reportconfigs/"),
               (kind: VariableSegment, value: "reportConfigName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportConfigDeleteByResourceGroupName_568347(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a report config.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportConfigName: JString (required)
  ##                   : Report Config Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568349 = path.getOrDefault("resourceGroupName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "resourceGroupName", valid_568349
  var valid_568350 = path.getOrDefault("subscriptionId")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "subscriptionId", valid_568350
  var valid_568351 = path.getOrDefault("reportConfigName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "reportConfigName", valid_568351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "api-version", valid_568352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_ReportConfigDeleteByResourceGroupName_568346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a report config.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_ReportConfigDeleteByResourceGroupName_568346;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          reportConfigName: string): Recallable =
  ## reportConfigDeleteByResourceGroupName
  ## The operation to delete a report config.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportConfigName: string (required)
  ##                   : Report Config Name.
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  add(path_568355, "resourceGroupName", newJString(resourceGroupName))
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  add(path_568355, "reportConfigName", newJString(reportConfigName))
  result = call_568354.call(path_568355, query_568356, nil, nil, nil)

var reportConfigDeleteByResourceGroupName* = Call_ReportConfigDeleteByResourceGroupName_568346(
    name: "reportConfigDeleteByResourceGroupName", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reportconfigs/{reportConfigName}",
    validator: validate_ReportConfigDeleteByResourceGroupName_568347, base: "",
    url: url_ReportConfigDeleteByResourceGroupName_568348, schemes: {Scheme.Https})
type
  Call_QueryResourceGroup_568357 = ref object of OpenApiRestCall_567659
proc url_QueryResourceGroup_568359(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/Query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryResourceGroup_568358(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568360 = path.getOrDefault("resourceGroupName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "resourceGroupName", valid_568360
  var valid_568361 = path.getOrDefault("subscriptionId")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "subscriptionId", valid_568361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-05-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568362 = query.getOrDefault("api-version")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "api-version", valid_568362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_QueryResourceGroup_568357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_QueryResourceGroup_568357; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## queryResourceGroup
  ## Lists the usage data for subscriptionId and resource group.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-05-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  var body_568368 = newJObject()
  add(path_568366, "resourceGroupName", newJString(resourceGroupName))
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568368 = parameters
  result = call_568365.call(path_568366, query_568367, nil, nil, body_568368)

var queryResourceGroup* = Call_QueryResourceGroup_568357(
    name: "queryResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryResourceGroup_568358, base: "",
    url: url_QueryResourceGroup_568359, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
