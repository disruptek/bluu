
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ConsumptionManagementClient
## version: 2018-03-31
## termsOfService: (not provided)
## license: (not provided)
## 
## Consumption management client provides access to consumption resources for Azure Enterprise Subscriptions.
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "consumption"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetBalancesByBillingAccountByBillingPeriod_567880 = ref object of OpenApiRestCall_567658
proc url_GetBalancesByBillingAccountByBillingPeriod_567882(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/balances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetBalancesByBillingAccountByBillingPeriod_567881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_568055 = path.getOrDefault("billingPeriodName")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "billingPeriodName", valid_568055
  var valid_568056 = path.getOrDefault("billingAccountId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "billingAccountId", valid_568056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_GetBalancesByBillingAccountByBillingPeriod_567880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_GetBalancesByBillingAccountByBillingPeriod_567880;
          apiVersion: string; billingPeriodName: string; billingAccountId: string): Recallable =
  ## getBalancesByBillingAccountByBillingPeriod
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "billingPeriodName", newJString(billingPeriodName))
  add(path_568152, "billingAccountId", newJString(billingAccountId))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var getBalancesByBillingAccountByBillingPeriod* = Call_GetBalancesByBillingAccountByBillingPeriod_567880(
    name: "getBalancesByBillingAccountByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/balances",
    validator: validate_GetBalancesByBillingAccountByBillingPeriod_567881,
    base: "", url: url_GetBalancesByBillingAccountByBillingPeriod_567882,
    schemes: {Scheme.Https})
type
  Call_MarketplacesByBillingAccountListByBillingPeriod_568193 = ref object of OpenApiRestCall_567658
proc url_MarketplacesByBillingAccountListByBillingPeriod_568195(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesByBillingAccountListByBillingPeriod_568194(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billing period and billingAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_568197 = path.getOrDefault("billingPeriodName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "billingPeriodName", valid_568197
  var valid_568198 = path.getOrDefault("billingAccountId")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "billingAccountId", valid_568198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568199 = query.getOrDefault("api-version")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "api-version", valid_568199
  var valid_568200 = query.getOrDefault("$top")
  valid_568200 = validateParameter(valid_568200, JInt, required = false, default = nil)
  if valid_568200 != nil:
    section.add "$top", valid_568200
  var valid_568201 = query.getOrDefault("$skiptoken")
  valid_568201 = validateParameter(valid_568201, JString, required = false,
                                 default = nil)
  if valid_568201 != nil:
    section.add "$skiptoken", valid_568201
  var valid_568202 = query.getOrDefault("$filter")
  valid_568202 = validateParameter(valid_568202, JString, required = false,
                                 default = nil)
  if valid_568202 != nil:
    section.add "$filter", valid_568202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568203: Call_MarketplacesByBillingAccountListByBillingPeriod_568193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and billingAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568203.validator(path, query, header, formData, body)
  let scheme = call_568203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568203.url(scheme.get, call_568203.host, call_568203.base,
                         call_568203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568203, url, valid)

proc call*(call_568204: Call_MarketplacesByBillingAccountListByBillingPeriod_568193;
          apiVersion: string; billingPeriodName: string; billingAccountId: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesByBillingAccountListByBillingPeriod
  ## Lists the marketplaces for a scope by billing period and billingAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568205 = newJObject()
  var query_568206 = newJObject()
  add(query_568206, "api-version", newJString(apiVersion))
  add(query_568206, "$top", newJInt(Top))
  add(query_568206, "$skiptoken", newJString(Skiptoken))
  add(path_568205, "billingPeriodName", newJString(billingPeriodName))
  add(path_568205, "billingAccountId", newJString(billingAccountId))
  add(query_568206, "$filter", newJString(Filter))
  result = call_568204.call(path_568205, query_568206, nil, nil, nil)

var marketplacesByBillingAccountListByBillingPeriod* = Call_MarketplacesByBillingAccountListByBillingPeriod_568193(
    name: "marketplacesByBillingAccountListByBillingPeriod",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByBillingAccountListByBillingPeriod_568194,
    base: "", url: url_MarketplacesByBillingAccountListByBillingPeriod_568195,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsByBillingAccountListByBillingPeriod_568207 = ref object of OpenApiRestCall_567658
proc url_UsageDetailsByBillingAccountListByBillingPeriod_568209(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsByBillingAccountListByBillingPeriod_568208(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the usage details based on billingAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_568210 = path.getOrDefault("billingPeriodName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "billingPeriodName", valid_568210
  var valid_568211 = path.getOrDefault("billingAccountId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "billingAccountId", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568212 = query.getOrDefault("$expand")
  valid_568212 = validateParameter(valid_568212, JString, required = false,
                                 default = nil)
  if valid_568212 != nil:
    section.add "$expand", valid_568212
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  var valid_568214 = query.getOrDefault("$top")
  valid_568214 = validateParameter(valid_568214, JInt, required = false, default = nil)
  if valid_568214 != nil:
    section.add "$top", valid_568214
  var valid_568215 = query.getOrDefault("$skiptoken")
  valid_568215 = validateParameter(valid_568215, JString, required = false,
                                 default = nil)
  if valid_568215 != nil:
    section.add "$skiptoken", valid_568215
  var valid_568216 = query.getOrDefault("$apply")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = nil)
  if valid_568216 != nil:
    section.add "$apply", valid_568216
  var valid_568217 = query.getOrDefault("$filter")
  valid_568217 = validateParameter(valid_568217, JString, required = false,
                                 default = nil)
  if valid_568217 != nil:
    section.add "$filter", valid_568217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568218: Call_UsageDetailsByBillingAccountListByBillingPeriod_568207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details based on billingAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568218.validator(path, query, header, formData, body)
  let scheme = call_568218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568218.url(scheme.get, call_568218.host, call_568218.base,
                         call_568218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568218, url, valid)

proc call*(call_568219: Call_UsageDetailsByBillingAccountListByBillingPeriod_568207;
          apiVersion: string; billingPeriodName: string; billingAccountId: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsByBillingAccountListByBillingPeriod
  ## Lists the usage details based on billingAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568220 = newJObject()
  var query_568221 = newJObject()
  add(query_568221, "$expand", newJString(Expand))
  add(query_568221, "api-version", newJString(apiVersion))
  add(query_568221, "$top", newJInt(Top))
  add(query_568221, "$skiptoken", newJString(Skiptoken))
  add(path_568220, "billingPeriodName", newJString(billingPeriodName))
  add(path_568220, "billingAccountId", newJString(billingAccountId))
  add(query_568221, "$apply", newJString(Apply))
  add(query_568221, "$filter", newJString(Filter))
  result = call_568219.call(path_568220, query_568221, nil, nil, nil)

var usageDetailsByBillingAccountListByBillingPeriod* = Call_UsageDetailsByBillingAccountListByBillingPeriod_568207(
    name: "usageDetailsByBillingAccountListByBillingPeriod",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByBillingAccountListByBillingPeriod_568208,
    base: "", url: url_UsageDetailsByBillingAccountListByBillingPeriod_568209,
    schemes: {Scheme.Https})
type
  Call_GetBalancesByBillingAccount_568222 = ref object of OpenApiRestCall_567658
proc url_GetBalancesByBillingAccount_568224(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/balances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetBalancesByBillingAccount_568223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568225 = path.getOrDefault("billingAccountId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "billingAccountId", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568227: Call_GetBalancesByBillingAccount_568222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568227.validator(path, query, header, formData, body)
  let scheme = call_568227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568227.url(scheme.get, call_568227.host, call_568227.base,
                         call_568227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568227, url, valid)

proc call*(call_568228: Call_GetBalancesByBillingAccount_568222;
          apiVersion: string; billingAccountId: string): Recallable =
  ## getBalancesByBillingAccount
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568229 = newJObject()
  var query_568230 = newJObject()
  add(query_568230, "api-version", newJString(apiVersion))
  add(path_568229, "billingAccountId", newJString(billingAccountId))
  result = call_568228.call(path_568229, query_568230, nil, nil, nil)

var getBalancesByBillingAccount* = Call_GetBalancesByBillingAccount_568222(
    name: "getBalancesByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/balances",
    validator: validate_GetBalancesByBillingAccount_568223, base: "",
    url: url_GetBalancesByBillingAccount_568224, schemes: {Scheme.Https})
type
  Call_CostTagsCreateOrUpdate_568240 = ref object of OpenApiRestCall_567658
proc url_CostTagsCreateOrUpdate_568242(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/costTags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostTagsCreateOrUpdate_568241(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update cost tags associated with a billing account. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568243 = path.getOrDefault("billingAccountId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "billingAccountId", valid_568243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "api-version", valid_568244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create cost tags operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568246: Call_CostTagsCreateOrUpdate_568240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update cost tags associated with a billing account. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568246.validator(path, query, header, formData, body)
  let scheme = call_568246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568246.url(scheme.get, call_568246.host, call_568246.base,
                         call_568246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568246, url, valid)

proc call*(call_568247: Call_CostTagsCreateOrUpdate_568240; apiVersion: string;
          billingAccountId: string; parameters: JsonNode): Recallable =
  ## costTagsCreateOrUpdate
  ## The operation to create or update cost tags associated with a billing account. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create cost tags operation.
  var path_568248 = newJObject()
  var query_568249 = newJObject()
  var body_568250 = newJObject()
  add(query_568249, "api-version", newJString(apiVersion))
  add(path_568248, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568250 = parameters
  result = call_568247.call(path_568248, query_568249, nil, nil, body_568250)

var costTagsCreateOrUpdate* = Call_CostTagsCreateOrUpdate_568240(
    name: "costTagsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/costTags",
    validator: validate_CostTagsCreateOrUpdate_568241, base: "",
    url: url_CostTagsCreateOrUpdate_568242, schemes: {Scheme.Https})
type
  Call_CostTagsGet_568231 = ref object of OpenApiRestCall_567658
proc url_CostTagsGet_568233(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/costTags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostTagsGet_568232(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get cost tags for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568234 = path.getOrDefault("billingAccountId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "billingAccountId", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "api-version", valid_568235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_CostTagsGet_568231; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost tags for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_CostTagsGet_568231; apiVersion: string;
          billingAccountId: string): Recallable =
  ## costTagsGet
  ## Get cost tags for a billing account.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "billingAccountId", newJString(billingAccountId))
  result = call_568237.call(path_568238, query_568239, nil, nil, nil)

var costTagsGet* = Call_CostTagsGet_568231(name: "costTagsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/costTags",
                                        validator: validate_CostTagsGet_568232,
                                        base: "", url: url_CostTagsGet_568233,
                                        schemes: {Scheme.Https})
type
  Call_MarketplacesByBillingAccountList_568251 = ref object of OpenApiRestCall_567658
proc url_MarketplacesByBillingAccountList_568253(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesByBillingAccountList_568252(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billingAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568254 = path.getOrDefault("billingAccountId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "billingAccountId", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  var valid_568256 = query.getOrDefault("$top")
  valid_568256 = validateParameter(valid_568256, JInt, required = false, default = nil)
  if valid_568256 != nil:
    section.add "$top", valid_568256
  var valid_568257 = query.getOrDefault("$skiptoken")
  valid_568257 = validateParameter(valid_568257, JString, required = false,
                                 default = nil)
  if valid_568257 != nil:
    section.add "$skiptoken", valid_568257
  var valid_568258 = query.getOrDefault("$filter")
  valid_568258 = validateParameter(valid_568258, JString, required = false,
                                 default = nil)
  if valid_568258 != nil:
    section.add "$filter", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_MarketplacesByBillingAccountList_568251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billingAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_MarketplacesByBillingAccountList_568251;
          apiVersion: string; billingAccountId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesByBillingAccountList
  ## Lists the marketplaces for a scope by billingAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(query_568262, "api-version", newJString(apiVersion))
  add(query_568262, "$top", newJInt(Top))
  add(query_568262, "$skiptoken", newJString(Skiptoken))
  add(path_568261, "billingAccountId", newJString(billingAccountId))
  add(query_568262, "$filter", newJString(Filter))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var marketplacesByBillingAccountList* = Call_MarketplacesByBillingAccountList_568251(
    name: "marketplacesByBillingAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByBillingAccountList_568252, base: "",
    url: url_MarketplacesByBillingAccountList_568253, schemes: {Scheme.Https})
type
  Call_UsageDetailsByBillingAccountList_568263 = ref object of OpenApiRestCall_567658
proc url_UsageDetailsByBillingAccountList_568265(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsByBillingAccountList_568264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details by billingAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568266 = path.getOrDefault("billingAccountId")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "billingAccountId", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568267 = query.getOrDefault("$expand")
  valid_568267 = validateParameter(valid_568267, JString, required = false,
                                 default = nil)
  if valid_568267 != nil:
    section.add "$expand", valid_568267
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568268 = query.getOrDefault("api-version")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "api-version", valid_568268
  var valid_568269 = query.getOrDefault("$top")
  valid_568269 = validateParameter(valid_568269, JInt, required = false, default = nil)
  if valid_568269 != nil:
    section.add "$top", valid_568269
  var valid_568270 = query.getOrDefault("$skiptoken")
  valid_568270 = validateParameter(valid_568270, JString, required = false,
                                 default = nil)
  if valid_568270 != nil:
    section.add "$skiptoken", valid_568270
  var valid_568271 = query.getOrDefault("$apply")
  valid_568271 = validateParameter(valid_568271, JString, required = false,
                                 default = nil)
  if valid_568271 != nil:
    section.add "$apply", valid_568271
  var valid_568272 = query.getOrDefault("$filter")
  valid_568272 = validateParameter(valid_568272, JString, required = false,
                                 default = nil)
  if valid_568272 != nil:
    section.add "$filter", valid_568272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_UsageDetailsByBillingAccountList_568263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details by billingAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_UsageDetailsByBillingAccountList_568263;
          apiVersion: string; billingAccountId: string; Expand: string = "";
          Top: int = 0; Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsByBillingAccountList
  ## Lists the usage details by billingAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  add(query_568276, "$expand", newJString(Expand))
  add(query_568276, "api-version", newJString(apiVersion))
  add(query_568276, "$top", newJInt(Top))
  add(query_568276, "$skiptoken", newJString(Skiptoken))
  add(path_568275, "billingAccountId", newJString(billingAccountId))
  add(query_568276, "$apply", newJString(Apply))
  add(query_568276, "$filter", newJString(Filter))
  result = call_568274.call(path_568275, query_568276, nil, nil, nil)

var usageDetailsByBillingAccountList* = Call_UsageDetailsByBillingAccountList_568263(
    name: "usageDetailsByBillingAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByBillingAccountList_568264, base: "",
    url: url_UsageDetailsByBillingAccountList_568265, schemes: {Scheme.Https})
type
  Call_MarketplacesByDepartmentListByBillingPeriod_568277 = ref object of OpenApiRestCall_567658
proc url_MarketplacesByDepartmentListByBillingPeriod_568279(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesByDepartmentListByBillingPeriod_568278(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billing period and departmentId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_568280 = path.getOrDefault("billingPeriodName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "billingPeriodName", valid_568280
  var valid_568281 = path.getOrDefault("departmentId")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "departmentId", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  var valid_568283 = query.getOrDefault("$top")
  valid_568283 = validateParameter(valid_568283, JInt, required = false, default = nil)
  if valid_568283 != nil:
    section.add "$top", valid_568283
  var valid_568284 = query.getOrDefault("$skiptoken")
  valid_568284 = validateParameter(valid_568284, JString, required = false,
                                 default = nil)
  if valid_568284 != nil:
    section.add "$skiptoken", valid_568284
  var valid_568285 = query.getOrDefault("$filter")
  valid_568285 = validateParameter(valid_568285, JString, required = false,
                                 default = nil)
  if valid_568285 != nil:
    section.add "$filter", valid_568285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568286: Call_MarketplacesByDepartmentListByBillingPeriod_568277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and departmentId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_MarketplacesByDepartmentListByBillingPeriod_568277;
          apiVersion: string; billingPeriodName: string; departmentId: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesByDepartmentListByBillingPeriod
  ## Lists the marketplaces for a scope by billing period and departmentId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  add(query_568289, "api-version", newJString(apiVersion))
  add(query_568289, "$top", newJInt(Top))
  add(query_568289, "$skiptoken", newJString(Skiptoken))
  add(path_568288, "billingPeriodName", newJString(billingPeriodName))
  add(path_568288, "departmentId", newJString(departmentId))
  add(query_568289, "$filter", newJString(Filter))
  result = call_568287.call(path_568288, query_568289, nil, nil, nil)

var marketplacesByDepartmentListByBillingPeriod* = Call_MarketplacesByDepartmentListByBillingPeriod_568277(
    name: "marketplacesByDepartmentListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByDepartmentListByBillingPeriod_568278,
    base: "", url: url_MarketplacesByDepartmentListByBillingPeriod_568279,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsByDepartmentListByBillingPeriod_568290 = ref object of OpenApiRestCall_567658
proc url_UsageDetailsByDepartmentListByBillingPeriod_568292(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsByDepartmentListByBillingPeriod_568291(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details  based on departmentId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_568293 = path.getOrDefault("billingPeriodName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "billingPeriodName", valid_568293
  var valid_568294 = path.getOrDefault("departmentId")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "departmentId", valid_568294
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568295 = query.getOrDefault("$expand")
  valid_568295 = validateParameter(valid_568295, JString, required = false,
                                 default = nil)
  if valid_568295 != nil:
    section.add "$expand", valid_568295
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  var valid_568297 = query.getOrDefault("$top")
  valid_568297 = validateParameter(valid_568297, JInt, required = false, default = nil)
  if valid_568297 != nil:
    section.add "$top", valid_568297
  var valid_568298 = query.getOrDefault("$skiptoken")
  valid_568298 = validateParameter(valid_568298, JString, required = false,
                                 default = nil)
  if valid_568298 != nil:
    section.add "$skiptoken", valid_568298
  var valid_568299 = query.getOrDefault("$apply")
  valid_568299 = validateParameter(valid_568299, JString, required = false,
                                 default = nil)
  if valid_568299 != nil:
    section.add "$apply", valid_568299
  var valid_568300 = query.getOrDefault("$filter")
  valid_568300 = validateParameter(valid_568300, JString, required = false,
                                 default = nil)
  if valid_568300 != nil:
    section.add "$filter", valid_568300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568301: Call_UsageDetailsByDepartmentListByBillingPeriod_568290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details  based on departmentId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568301.validator(path, query, header, formData, body)
  let scheme = call_568301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568301.url(scheme.get, call_568301.host, call_568301.base,
                         call_568301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568301, url, valid)

proc call*(call_568302: Call_UsageDetailsByDepartmentListByBillingPeriod_568290;
          apiVersion: string; billingPeriodName: string; departmentId: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsByDepartmentListByBillingPeriod
  ## Lists the usage details  based on departmentId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568303 = newJObject()
  var query_568304 = newJObject()
  add(query_568304, "$expand", newJString(Expand))
  add(query_568304, "api-version", newJString(apiVersion))
  add(query_568304, "$top", newJInt(Top))
  add(query_568304, "$skiptoken", newJString(Skiptoken))
  add(path_568303, "billingPeriodName", newJString(billingPeriodName))
  add(path_568303, "departmentId", newJString(departmentId))
  add(query_568304, "$apply", newJString(Apply))
  add(query_568304, "$filter", newJString(Filter))
  result = call_568302.call(path_568303, query_568304, nil, nil, nil)

var usageDetailsByDepartmentListByBillingPeriod* = Call_UsageDetailsByDepartmentListByBillingPeriod_568290(
    name: "usageDetailsByDepartmentListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByDepartmentListByBillingPeriod_568291,
    base: "", url: url_UsageDetailsByDepartmentListByBillingPeriod_568292,
    schemes: {Scheme.Https})
type
  Call_MarketplacesByDepartmentList_568305 = ref object of OpenApiRestCall_567658
proc url_MarketplacesByDepartmentList_568307(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesByDepartmentList_568306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by departmentId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_568308 = path.getOrDefault("departmentId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "departmentId", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  var valid_568310 = query.getOrDefault("$top")
  valid_568310 = validateParameter(valid_568310, JInt, required = false, default = nil)
  if valid_568310 != nil:
    section.add "$top", valid_568310
  var valid_568311 = query.getOrDefault("$skiptoken")
  valid_568311 = validateParameter(valid_568311, JString, required = false,
                                 default = nil)
  if valid_568311 != nil:
    section.add "$skiptoken", valid_568311
  var valid_568312 = query.getOrDefault("$filter")
  valid_568312 = validateParameter(valid_568312, JString, required = false,
                                 default = nil)
  if valid_568312 != nil:
    section.add "$filter", valid_568312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568313: Call_MarketplacesByDepartmentList_568305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by departmentId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_MarketplacesByDepartmentList_568305;
          apiVersion: string; departmentId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesByDepartmentList
  ## Lists the marketplaces for a scope by departmentId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  add(query_568316, "api-version", newJString(apiVersion))
  add(query_568316, "$top", newJInt(Top))
  add(query_568316, "$skiptoken", newJString(Skiptoken))
  add(path_568315, "departmentId", newJString(departmentId))
  add(query_568316, "$filter", newJString(Filter))
  result = call_568314.call(path_568315, query_568316, nil, nil, nil)

var marketplacesByDepartmentList* = Call_MarketplacesByDepartmentList_568305(
    name: "marketplacesByDepartmentList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByDepartmentList_568306, base: "",
    url: url_MarketplacesByDepartmentList_568307, schemes: {Scheme.Https})
type
  Call_UsageDetailsByDepartmentList_568317 = ref object of OpenApiRestCall_567658
proc url_UsageDetailsByDepartmentList_568319(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsByDepartmentList_568318(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details by departmentId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_568320 = path.getOrDefault("departmentId")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "departmentId", valid_568320
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568321 = query.getOrDefault("$expand")
  valid_568321 = validateParameter(valid_568321, JString, required = false,
                                 default = nil)
  if valid_568321 != nil:
    section.add "$expand", valid_568321
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "api-version", valid_568322
  var valid_568323 = query.getOrDefault("$top")
  valid_568323 = validateParameter(valid_568323, JInt, required = false, default = nil)
  if valid_568323 != nil:
    section.add "$top", valid_568323
  var valid_568324 = query.getOrDefault("$skiptoken")
  valid_568324 = validateParameter(valid_568324, JString, required = false,
                                 default = nil)
  if valid_568324 != nil:
    section.add "$skiptoken", valid_568324
  var valid_568325 = query.getOrDefault("$apply")
  valid_568325 = validateParameter(valid_568325, JString, required = false,
                                 default = nil)
  if valid_568325 != nil:
    section.add "$apply", valid_568325
  var valid_568326 = query.getOrDefault("$filter")
  valid_568326 = validateParameter(valid_568326, JString, required = false,
                                 default = nil)
  if valid_568326 != nil:
    section.add "$filter", valid_568326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_UsageDetailsByDepartmentList_568317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details by departmentId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_UsageDetailsByDepartmentList_568317;
          apiVersion: string; departmentId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsByDepartmentList
  ## Lists the usage details by departmentId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  add(query_568330, "$expand", newJString(Expand))
  add(query_568330, "api-version", newJString(apiVersion))
  add(query_568330, "$top", newJInt(Top))
  add(query_568330, "$skiptoken", newJString(Skiptoken))
  add(path_568329, "departmentId", newJString(departmentId))
  add(query_568330, "$apply", newJString(Apply))
  add(query_568330, "$filter", newJString(Filter))
  result = call_568328.call(path_568329, query_568330, nil, nil, nil)

var usageDetailsByDepartmentList* = Call_UsageDetailsByDepartmentList_568317(
    name: "usageDetailsByDepartmentList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByDepartmentList_568318, base: "",
    url: url_UsageDetailsByDepartmentList_568319, schemes: {Scheme.Https})
type
  Call_MarketplacesByEnrollmentAccountsListByBillingPeriod_568331 = ref object of OpenApiRestCall_567658
proc url_MarketplacesByEnrollmentAccountsListByBillingPeriod_568333(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesByEnrollmentAccountsListByBillingPeriod_568332(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billing period and enrollmentAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_568334 = path.getOrDefault("enrollmentAccountId")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "enrollmentAccountId", valid_568334
  var valid_568335 = path.getOrDefault("billingPeriodName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "billingPeriodName", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  var valid_568337 = query.getOrDefault("$top")
  valid_568337 = validateParameter(valid_568337, JInt, required = false, default = nil)
  if valid_568337 != nil:
    section.add "$top", valid_568337
  var valid_568338 = query.getOrDefault("$skiptoken")
  valid_568338 = validateParameter(valid_568338, JString, required = false,
                                 default = nil)
  if valid_568338 != nil:
    section.add "$skiptoken", valid_568338
  var valid_568339 = query.getOrDefault("$filter")
  valid_568339 = validateParameter(valid_568339, JString, required = false,
                                 default = nil)
  if valid_568339 != nil:
    section.add "$filter", valid_568339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_MarketplacesByEnrollmentAccountsListByBillingPeriod_568331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and enrollmentAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_MarketplacesByEnrollmentAccountsListByBillingPeriod_568331;
          apiVersion: string; enrollmentAccountId: string;
          billingPeriodName: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## marketplacesByEnrollmentAccountsListByBillingPeriod
  ## Lists the marketplaces for a scope by billing period and enrollmentAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  add(query_568343, "api-version", newJString(apiVersion))
  add(query_568343, "$top", newJInt(Top))
  add(query_568343, "$skiptoken", newJString(Skiptoken))
  add(path_568342, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568342, "billingPeriodName", newJString(billingPeriodName))
  add(query_568343, "$filter", newJString(Filter))
  result = call_568341.call(path_568342, query_568343, nil, nil, nil)

var marketplacesByEnrollmentAccountsListByBillingPeriod* = Call_MarketplacesByEnrollmentAccountsListByBillingPeriod_568331(
    name: "marketplacesByEnrollmentAccountsListByBillingPeriod",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByEnrollmentAccountsListByBillingPeriod_568332,
    base: "", url: url_MarketplacesByEnrollmentAccountsListByBillingPeriod_568333,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsByEnrollmentAccountListByBillingPeriod_568344 = ref object of OpenApiRestCall_567658
proc url_UsageDetailsByEnrollmentAccountListByBillingPeriod_568346(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsByEnrollmentAccountListByBillingPeriod_568345(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the usage details based on enrollmentAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_568347 = path.getOrDefault("enrollmentAccountId")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "enrollmentAccountId", valid_568347
  var valid_568348 = path.getOrDefault("billingPeriodName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "billingPeriodName", valid_568348
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568349 = query.getOrDefault("$expand")
  valid_568349 = validateParameter(valid_568349, JString, required = false,
                                 default = nil)
  if valid_568349 != nil:
    section.add "$expand", valid_568349
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568350 = query.getOrDefault("api-version")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "api-version", valid_568350
  var valid_568351 = query.getOrDefault("$top")
  valid_568351 = validateParameter(valid_568351, JInt, required = false, default = nil)
  if valid_568351 != nil:
    section.add "$top", valid_568351
  var valid_568352 = query.getOrDefault("$skiptoken")
  valid_568352 = validateParameter(valid_568352, JString, required = false,
                                 default = nil)
  if valid_568352 != nil:
    section.add "$skiptoken", valid_568352
  var valid_568353 = query.getOrDefault("$apply")
  valid_568353 = validateParameter(valid_568353, JString, required = false,
                                 default = nil)
  if valid_568353 != nil:
    section.add "$apply", valid_568353
  var valid_568354 = query.getOrDefault("$filter")
  valid_568354 = validateParameter(valid_568354, JString, required = false,
                                 default = nil)
  if valid_568354 != nil:
    section.add "$filter", valid_568354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568355: Call_UsageDetailsByEnrollmentAccountListByBillingPeriod_568344;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details based on enrollmentAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568355.validator(path, query, header, formData, body)
  let scheme = call_568355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568355.url(scheme.get, call_568355.host, call_568355.base,
                         call_568355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568355, url, valid)

proc call*(call_568356: Call_UsageDetailsByEnrollmentAccountListByBillingPeriod_568344;
          apiVersion: string; enrollmentAccountId: string;
          billingPeriodName: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsByEnrollmentAccountListByBillingPeriod
  ## Lists the usage details based on enrollmentAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568357 = newJObject()
  var query_568358 = newJObject()
  add(query_568358, "$expand", newJString(Expand))
  add(query_568358, "api-version", newJString(apiVersion))
  add(query_568358, "$top", newJInt(Top))
  add(query_568358, "$skiptoken", newJString(Skiptoken))
  add(path_568357, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568357, "billingPeriodName", newJString(billingPeriodName))
  add(query_568358, "$apply", newJString(Apply))
  add(query_568358, "$filter", newJString(Filter))
  result = call_568356.call(path_568357, query_568358, nil, nil, nil)

var usageDetailsByEnrollmentAccountListByBillingPeriod* = Call_UsageDetailsByEnrollmentAccountListByBillingPeriod_568344(
    name: "usageDetailsByEnrollmentAccountListByBillingPeriod",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByEnrollmentAccountListByBillingPeriod_568345,
    base: "", url: url_UsageDetailsByEnrollmentAccountListByBillingPeriod_568346,
    schemes: {Scheme.Https})
type
  Call_MarketplacesByEnrollmentAccountsList_568359 = ref object of OpenApiRestCall_567658
proc url_MarketplacesByEnrollmentAccountsList_568361(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesByEnrollmentAccountsList_568360(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by enrollmentAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : EnrollmentAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_568362 = path.getOrDefault("enrollmentAccountId")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "enrollmentAccountId", valid_568362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568363 = query.getOrDefault("api-version")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "api-version", valid_568363
  var valid_568364 = query.getOrDefault("$top")
  valid_568364 = validateParameter(valid_568364, JInt, required = false, default = nil)
  if valid_568364 != nil:
    section.add "$top", valid_568364
  var valid_568365 = query.getOrDefault("$skiptoken")
  valid_568365 = validateParameter(valid_568365, JString, required = false,
                                 default = nil)
  if valid_568365 != nil:
    section.add "$skiptoken", valid_568365
  var valid_568366 = query.getOrDefault("$filter")
  valid_568366 = validateParameter(valid_568366, JString, required = false,
                                 default = nil)
  if valid_568366 != nil:
    section.add "$filter", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568367: Call_MarketplacesByEnrollmentAccountsList_568359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by enrollmentAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_MarketplacesByEnrollmentAccountsList_568359;
          apiVersion: string; enrollmentAccountId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesByEnrollmentAccountsList
  ## Lists the marketplaces for a scope by enrollmentAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568369 = newJObject()
  var query_568370 = newJObject()
  add(query_568370, "api-version", newJString(apiVersion))
  add(query_568370, "$top", newJInt(Top))
  add(query_568370, "$skiptoken", newJString(Skiptoken))
  add(path_568369, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(query_568370, "$filter", newJString(Filter))
  result = call_568368.call(path_568369, query_568370, nil, nil, nil)

var marketplacesByEnrollmentAccountsList* = Call_MarketplacesByEnrollmentAccountsList_568359(
    name: "marketplacesByEnrollmentAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByEnrollmentAccountsList_568360, base: "",
    url: url_MarketplacesByEnrollmentAccountsList_568361, schemes: {Scheme.Https})
type
  Call_UsageDetailsByEnrollmentAccountList_568371 = ref object of OpenApiRestCall_567658
proc url_UsageDetailsByEnrollmentAccountList_568373(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsByEnrollmentAccountList_568372(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details by enrollmentAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : EnrollmentAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_568374 = path.getOrDefault("enrollmentAccountId")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "enrollmentAccountId", valid_568374
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568375 = query.getOrDefault("$expand")
  valid_568375 = validateParameter(valid_568375, JString, required = false,
                                 default = nil)
  if valid_568375 != nil:
    section.add "$expand", valid_568375
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568376 = query.getOrDefault("api-version")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "api-version", valid_568376
  var valid_568377 = query.getOrDefault("$top")
  valid_568377 = validateParameter(valid_568377, JInt, required = false, default = nil)
  if valid_568377 != nil:
    section.add "$top", valid_568377
  var valid_568378 = query.getOrDefault("$skiptoken")
  valid_568378 = validateParameter(valid_568378, JString, required = false,
                                 default = nil)
  if valid_568378 != nil:
    section.add "$skiptoken", valid_568378
  var valid_568379 = query.getOrDefault("$apply")
  valid_568379 = validateParameter(valid_568379, JString, required = false,
                                 default = nil)
  if valid_568379 != nil:
    section.add "$apply", valid_568379
  var valid_568380 = query.getOrDefault("$filter")
  valid_568380 = validateParameter(valid_568380, JString, required = false,
                                 default = nil)
  if valid_568380 != nil:
    section.add "$filter", valid_568380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568381: Call_UsageDetailsByEnrollmentAccountList_568371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details by enrollmentAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568381.validator(path, query, header, formData, body)
  let scheme = call_568381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568381.url(scheme.get, call_568381.host, call_568381.base,
                         call_568381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568381, url, valid)

proc call*(call_568382: Call_UsageDetailsByEnrollmentAccountList_568371;
          apiVersion: string; enrollmentAccountId: string; Expand: string = "";
          Top: int = 0; Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsByEnrollmentAccountList
  ## Lists the usage details by enrollmentAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568383 = newJObject()
  var query_568384 = newJObject()
  add(query_568384, "$expand", newJString(Expand))
  add(query_568384, "api-version", newJString(apiVersion))
  add(query_568384, "$top", newJInt(Top))
  add(query_568384, "$skiptoken", newJString(Skiptoken))
  add(path_568383, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(query_568384, "$apply", newJString(Apply))
  add(query_568384, "$filter", newJString(Filter))
  result = call_568382.call(path_568383, query_568384, nil, nil, nil)

var usageDetailsByEnrollmentAccountList* = Call_UsageDetailsByEnrollmentAccountList_568371(
    name: "usageDetailsByEnrollmentAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByEnrollmentAccountList_568372, base: "",
    url: url_UsageDetailsByEnrollmentAccountList_568373, schemes: {Scheme.Https})
type
  Call_ReservationsDetailsListByReservationOrder_568385 = ref object of OpenApiRestCall_567658
proc url_ReservationsDetailsListByReservationOrder_568387(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsDetailsListByReservationOrder_568386(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_568388 = path.getOrDefault("reservationOrderId")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "reservationOrderId", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568389 = query.getOrDefault("api-version")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "api-version", valid_568389
  var valid_568390 = query.getOrDefault("$filter")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "$filter", valid_568390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568391: Call_ReservationsDetailsListByReservationOrder_568385;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568391.validator(path, query, header, formData, body)
  let scheme = call_568391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568391.url(scheme.get, call_568391.host, call_568391.base,
                         call_568391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568391, url, valid)

proc call*(call_568392: Call_ReservationsDetailsListByReservationOrder_568385;
          apiVersion: string; reservationOrderId: string; Filter: string): Recallable =
  ## reservationsDetailsListByReservationOrder
  ## Lists the reservations details for provided date range.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string (required)
  ##         : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  var path_568393 = newJObject()
  var query_568394 = newJObject()
  add(query_568394, "api-version", newJString(apiVersion))
  add(path_568393, "reservationOrderId", newJString(reservationOrderId))
  add(query_568394, "$filter", newJString(Filter))
  result = call_568392.call(path_568393, query_568394, nil, nil, nil)

var reservationsDetailsListByReservationOrder* = Call_ReservationsDetailsListByReservationOrder_568385(
    name: "reservationsDetailsListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationDetails",
    validator: validate_ReservationsDetailsListByReservationOrder_568386,
    base: "", url: url_ReservationsDetailsListByReservationOrder_568387,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrder_568395 = ref object of OpenApiRestCall_567658
proc url_ReservationsSummariesListByReservationOrder_568397(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationSummaries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsSummariesListByReservationOrder_568396(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_568398 = path.getOrDefault("reservationOrderId")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "reservationOrderId", valid_568398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $filter: JString
  ##          : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: JString (required)
  ##        : Can be daily or monthly
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568399 = query.getOrDefault("api-version")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "api-version", valid_568399
  var valid_568400 = query.getOrDefault("$filter")
  valid_568400 = validateParameter(valid_568400, JString, required = false,
                                 default = nil)
  if valid_568400 != nil:
    section.add "$filter", valid_568400
  var valid_568414 = query.getOrDefault("grain")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = newJString("daily"))
  if valid_568414 != nil:
    section.add "grain", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_ReservationsSummariesListByReservationOrder_568395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_ReservationsSummariesListByReservationOrder_568395;
          apiVersion: string; reservationOrderId: string; Filter: string = "";
          grain: string = "daily"): Recallable =
  ## reservationsSummariesListByReservationOrder
  ## Lists the reservations summaries for daily or monthly grain.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string
  ##         : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: string (required)
  ##        : Can be daily or monthly
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "reservationOrderId", newJString(reservationOrderId))
  add(query_568418, "$filter", newJString(Filter))
  add(query_568418, "grain", newJString(grain))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var reservationsSummariesListByReservationOrder* = Call_ReservationsSummariesListByReservationOrder_568395(
    name: "reservationsSummariesListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationSummaries",
    validator: validate_ReservationsSummariesListByReservationOrder_568396,
    base: "", url: url_ReservationsSummariesListByReservationOrder_568397,
    schemes: {Scheme.Https})
type
  Call_ReservationsDetailsListByReservationOrderAndReservation_568419 = ref object of OpenApiRestCall_567658
proc url_ReservationsDetailsListByReservationOrderAndReservation_568421(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  assert "reservationId" in path, "`reservationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/reservations/"),
               (kind: VariableSegment, value: "reservationId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsDetailsListByReservationOrderAndReservation_568420(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  ##   reservationId: JString (required)
  ##                : Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_568422 = path.getOrDefault("reservationOrderId")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "reservationOrderId", valid_568422
  var valid_568423 = path.getOrDefault("reservationId")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "reservationId", valid_568423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568424 = query.getOrDefault("api-version")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "api-version", valid_568424
  var valid_568425 = query.getOrDefault("$filter")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "$filter", valid_568425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568426: Call_ReservationsDetailsListByReservationOrderAndReservation_568419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568426.validator(path, query, header, formData, body)
  let scheme = call_568426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568426.url(scheme.get, call_568426.host, call_568426.base,
                         call_568426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568426, url, valid)

proc call*(call_568427: Call_ReservationsDetailsListByReservationOrderAndReservation_568419;
          apiVersion: string; reservationOrderId: string; reservationId: string;
          Filter: string): Recallable =
  ## reservationsDetailsListByReservationOrderAndReservation
  ## Lists the reservations details for provided date range.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the reservation
  ##   Filter: string (required)
  ##         : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  var path_568428 = newJObject()
  var query_568429 = newJObject()
  add(query_568429, "api-version", newJString(apiVersion))
  add(path_568428, "reservationOrderId", newJString(reservationOrderId))
  add(path_568428, "reservationId", newJString(reservationId))
  add(query_568429, "$filter", newJString(Filter))
  result = call_568427.call(path_568428, query_568429, nil, nil, nil)

var reservationsDetailsListByReservationOrderAndReservation* = Call_ReservationsDetailsListByReservationOrderAndReservation_568419(
    name: "reservationsDetailsListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationDetails", validator: validate_ReservationsDetailsListByReservationOrderAndReservation_568420,
    base: "", url: url_ReservationsDetailsListByReservationOrderAndReservation_568421,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrderAndReservation_568430 = ref object of OpenApiRestCall_567658
proc url_ReservationsSummariesListByReservationOrderAndReservation_568432(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  assert "reservationId" in path, "`reservationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/reservations/"),
               (kind: VariableSegment, value: "reservationId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationSummaries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsSummariesListByReservationOrderAndReservation_568431(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  ##   reservationId: JString (required)
  ##                : Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_568433 = path.getOrDefault("reservationOrderId")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "reservationOrderId", valid_568433
  var valid_568434 = path.getOrDefault("reservationId")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "reservationId", valid_568434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $filter: JString
  ##          : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: JString (required)
  ##        : Can be daily or monthly
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568435 = query.getOrDefault("api-version")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "api-version", valid_568435
  var valid_568436 = query.getOrDefault("$filter")
  valid_568436 = validateParameter(valid_568436, JString, required = false,
                                 default = nil)
  if valid_568436 != nil:
    section.add "$filter", valid_568436
  var valid_568437 = query.getOrDefault("grain")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = newJString("daily"))
  if valid_568437 != nil:
    section.add "grain", valid_568437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568438: Call_ReservationsSummariesListByReservationOrderAndReservation_568430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568438.validator(path, query, header, formData, body)
  let scheme = call_568438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568438.url(scheme.get, call_568438.host, call_568438.base,
                         call_568438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568438, url, valid)

proc call*(call_568439: Call_ReservationsSummariesListByReservationOrderAndReservation_568430;
          apiVersion: string; reservationOrderId: string; reservationId: string;
          Filter: string = ""; grain: string = "daily"): Recallable =
  ## reservationsSummariesListByReservationOrderAndReservation
  ## Lists the reservations summaries for daily or monthly grain.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the reservation
  ##   Filter: string
  ##         : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: string (required)
  ##        : Can be daily or monthly
  var path_568440 = newJObject()
  var query_568441 = newJObject()
  add(query_568441, "api-version", newJString(apiVersion))
  add(path_568440, "reservationOrderId", newJString(reservationOrderId))
  add(path_568440, "reservationId", newJString(reservationId))
  add(query_568441, "$filter", newJString(Filter))
  add(query_568441, "grain", newJString(grain))
  result = call_568439.call(path_568440, query_568441, nil, nil, nil)

var reservationsSummariesListByReservationOrderAndReservation* = Call_ReservationsSummariesListByReservationOrderAndReservation_568430(
    name: "reservationsSummariesListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationSummaries", validator: validate_ReservationsSummariesListByReservationOrderAndReservation_568431,
    base: "", url: url_ReservationsSummariesListByReservationOrderAndReservation_568432,
    schemes: {Scheme.Https})
type
  Call_OperationsList_568442 = ref object of OpenApiRestCall_567658
proc url_OperationsList_568444(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568443(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568445 = query.getOrDefault("api-version")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "api-version", valid_568445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568446: Call_OperationsList_568442; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_568446.validator(path, query, header, formData, body)
  let scheme = call_568446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568446.url(scheme.get, call_568446.host, call_568446.base,
                         call_568446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568446, url, valid)

proc call*(call_568447: Call_OperationsList_568442; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  var query_568448 = newJObject()
  add(query_568448, "api-version", newJString(apiVersion))
  result = call_568447.call(nil, query_568448, nil, nil, nil)

var operationsList* = Call_OperationsList_568442(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Consumption/operations",
    validator: validate_OperationsList_568443, base: "", url: url_OperationsList_568444,
    schemes: {Scheme.Https})
type
  Call_TagsGet_568449 = ref object of OpenApiRestCall_567658
proc url_TagsGet_568451(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.CostManagement/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsGet_568450(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all available tag keys for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568452 = path.getOrDefault("billingAccountId")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "billingAccountId", valid_568452
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568453 = query.getOrDefault("api-version")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "api-version", valid_568453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568454: Call_TagsGet_568449; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all available tag keys for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568454.validator(path, query, header, formData, body)
  let scheme = call_568454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568454.url(scheme.get, call_568454.host, call_568454.base,
                         call_568454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568454, url, valid)

proc call*(call_568455: Call_TagsGet_568449; apiVersion: string;
          billingAccountId: string): Recallable =
  ## tagsGet
  ## Get all available tag keys for a billing account.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568456 = newJObject()
  var query_568457 = newJObject()
  add(query_568457, "api-version", newJString(apiVersion))
  add(path_568456, "billingAccountId", newJString(billingAccountId))
  result = call_568455.call(path_568456, query_568457, nil, nil, nil)

var tagsGet* = Call_TagsGet_568449(name: "tagsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/providers/Microsoft.CostManagement/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/tags",
                                validator: validate_TagsGet_568450, base: "",
                                url: url_TagsGet_568451, schemes: {Scheme.Https})
type
  Call_MarketplacesListByBillingPeriod_568458 = ref object of OpenApiRestCall_567658
proc url_MarketplacesListByBillingPeriod_568460(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesListByBillingPeriod_568459(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568461 = path.getOrDefault("subscriptionId")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "subscriptionId", valid_568461
  var valid_568462 = path.getOrDefault("billingPeriodName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "billingPeriodName", valid_568462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568463 = query.getOrDefault("api-version")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "api-version", valid_568463
  var valid_568464 = query.getOrDefault("$top")
  valid_568464 = validateParameter(valid_568464, JInt, required = false, default = nil)
  if valid_568464 != nil:
    section.add "$top", valid_568464
  var valid_568465 = query.getOrDefault("$skiptoken")
  valid_568465 = validateParameter(valid_568465, JString, required = false,
                                 default = nil)
  if valid_568465 != nil:
    section.add "$skiptoken", valid_568465
  var valid_568466 = query.getOrDefault("$filter")
  valid_568466 = validateParameter(valid_568466, JString, required = false,
                                 default = nil)
  if valid_568466 != nil:
    section.add "$filter", valid_568466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568467: Call_MarketplacesListByBillingPeriod_568458;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568467.validator(path, query, header, formData, body)
  let scheme = call_568467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568467.url(scheme.get, call_568467.host, call_568467.base,
                         call_568467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568467, url, valid)

proc call*(call_568468: Call_MarketplacesListByBillingPeriod_568458;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListByBillingPeriod
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568469 = newJObject()
  var query_568470 = newJObject()
  add(query_568470, "api-version", newJString(apiVersion))
  add(path_568469, "subscriptionId", newJString(subscriptionId))
  add(query_568470, "$top", newJInt(Top))
  add(query_568470, "$skiptoken", newJString(Skiptoken))
  add(path_568469, "billingPeriodName", newJString(billingPeriodName))
  add(query_568470, "$filter", newJString(Filter))
  result = call_568468.call(path_568469, query_568470, nil, nil, nil)

var marketplacesListByBillingPeriod* = Call_MarketplacesListByBillingPeriod_568458(
    name: "marketplacesListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByBillingPeriod_568459, base: "",
    url: url_MarketplacesListByBillingPeriod_568460, schemes: {Scheme.Https})
type
  Call_PriceSheetGetByBillingPeriod_568471 = ref object of OpenApiRestCall_567658
proc url_PriceSheetGetByBillingPeriod_568473(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/pricesheets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PriceSheetGetByBillingPeriod_568472(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568474 = path.getOrDefault("subscriptionId")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "subscriptionId", valid_568474
  var valid_568475 = path.getOrDefault("billingPeriodName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "billingPeriodName", valid_568475
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the top N results.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  var valid_568476 = query.getOrDefault("$expand")
  valid_568476 = validateParameter(valid_568476, JString, required = false,
                                 default = nil)
  if valid_568476 != nil:
    section.add "$expand", valid_568476
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568477 = query.getOrDefault("api-version")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "api-version", valid_568477
  var valid_568478 = query.getOrDefault("$top")
  valid_568478 = validateParameter(valid_568478, JInt, required = false, default = nil)
  if valid_568478 != nil:
    section.add "$top", valid_568478
  var valid_568479 = query.getOrDefault("$skiptoken")
  valid_568479 = validateParameter(valid_568479, JString, required = false,
                                 default = nil)
  if valid_568479 != nil:
    section.add "$skiptoken", valid_568479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568480: Call_PriceSheetGetByBillingPeriod_568471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_PriceSheetGetByBillingPeriod_568471;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""): Recallable =
  ## priceSheetGetByBillingPeriod
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the top N results.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  add(query_568483, "$expand", newJString(Expand))
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "subscriptionId", newJString(subscriptionId))
  add(query_568483, "$top", newJInt(Top))
  add(query_568483, "$skiptoken", newJString(Skiptoken))
  add(path_568482, "billingPeriodName", newJString(billingPeriodName))
  result = call_568481.call(path_568482, query_568483, nil, nil, nil)

var priceSheetGetByBillingPeriod* = Call_PriceSheetGetByBillingPeriod_568471(
    name: "priceSheetGetByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGetByBillingPeriod_568472, base: "",
    url: url_PriceSheetGetByBillingPeriod_568473, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByBillingPeriod_568484 = ref object of OpenApiRestCall_567658
proc url_UsageDetailsListByBillingPeriod_568486(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsListByBillingPeriod_568485(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568487 = path.getOrDefault("subscriptionId")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "subscriptionId", valid_568487
  var valid_568488 = path.getOrDefault("billingPeriodName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "billingPeriodName", valid_568488
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568489 = query.getOrDefault("$expand")
  valid_568489 = validateParameter(valid_568489, JString, required = false,
                                 default = nil)
  if valid_568489 != nil:
    section.add "$expand", valid_568489
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568490 = query.getOrDefault("api-version")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "api-version", valid_568490
  var valid_568491 = query.getOrDefault("$top")
  valid_568491 = validateParameter(valid_568491, JInt, required = false, default = nil)
  if valid_568491 != nil:
    section.add "$top", valid_568491
  var valid_568492 = query.getOrDefault("$skiptoken")
  valid_568492 = validateParameter(valid_568492, JString, required = false,
                                 default = nil)
  if valid_568492 != nil:
    section.add "$skiptoken", valid_568492
  var valid_568493 = query.getOrDefault("$apply")
  valid_568493 = validateParameter(valid_568493, JString, required = false,
                                 default = nil)
  if valid_568493 != nil:
    section.add "$apply", valid_568493
  var valid_568494 = query.getOrDefault("$filter")
  valid_568494 = validateParameter(valid_568494, JString, required = false,
                                 default = nil)
  if valid_568494 != nil:
    section.add "$filter", valid_568494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568495: Call_UsageDetailsListByBillingPeriod_568484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568495.validator(path, query, header, formData, body)
  let scheme = call_568495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568495.url(scheme.get, call_568495.host, call_568495.base,
                         call_568495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568495, url, valid)

proc call*(call_568496: Call_UsageDetailsListByBillingPeriod_568484;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListByBillingPeriod
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568497 = newJObject()
  var query_568498 = newJObject()
  add(query_568498, "$expand", newJString(Expand))
  add(query_568498, "api-version", newJString(apiVersion))
  add(path_568497, "subscriptionId", newJString(subscriptionId))
  add(query_568498, "$top", newJInt(Top))
  add(query_568498, "$skiptoken", newJString(Skiptoken))
  add(path_568497, "billingPeriodName", newJString(billingPeriodName))
  add(query_568498, "$apply", newJString(Apply))
  add(query_568498, "$filter", newJString(Filter))
  result = call_568496.call(path_568497, query_568498, nil, nil, nil)

var usageDetailsListByBillingPeriod* = Call_UsageDetailsListByBillingPeriod_568484(
    name: "usageDetailsListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByBillingPeriod_568485, base: "",
    url: url_UsageDetailsListByBillingPeriod_568486, schemes: {Scheme.Https})
type
  Call_BudgetsList_568499 = ref object of OpenApiRestCall_567658
proc url_BudgetsList_568501(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsList_568500(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all budgets for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568502 = path.getOrDefault("subscriptionId")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "subscriptionId", valid_568502
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568503 = query.getOrDefault("api-version")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "api-version", valid_568503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568504: Call_BudgetsList_568499; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568504.validator(path, query, header, formData, body)
  let scheme = call_568504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568504.url(scheme.get, call_568504.host, call_568504.base,
                         call_568504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568504, url, valid)

proc call*(call_568505: Call_BudgetsList_568499; apiVersion: string;
          subscriptionId: string): Recallable =
  ## budgetsList
  ## Lists all budgets for a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568506 = newJObject()
  var query_568507 = newJObject()
  add(query_568507, "api-version", newJString(apiVersion))
  add(path_568506, "subscriptionId", newJString(subscriptionId))
  result = call_568505.call(path_568506, query_568507, nil, nil, nil)

var budgetsList* = Call_BudgetsList_568499(name: "budgetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets",
                                        validator: validate_BudgetsList_568500,
                                        base: "", url: url_BudgetsList_568501,
                                        schemes: {Scheme.Https})
type
  Call_BudgetsCreateOrUpdate_568518 = ref object of OpenApiRestCall_567658
proc url_BudgetsCreateOrUpdate_568520(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsCreateOrUpdate_568519(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568521 = path.getOrDefault("subscriptionId")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "subscriptionId", valid_568521
  var valid_568522 = path.getOrDefault("budgetName")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "budgetName", valid_568522
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568523 = query.getOrDefault("api-version")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "api-version", valid_568523
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568525: Call_BudgetsCreateOrUpdate_568518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568525.validator(path, query, header, formData, body)
  let scheme = call_568525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568525.url(scheme.get, call_568525.host, call_568525.base,
                         call_568525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568525, url, valid)

proc call*(call_568526: Call_BudgetsCreateOrUpdate_568518; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; budgetName: string): Recallable =
  ## budgetsCreateOrUpdate
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568527 = newJObject()
  var query_568528 = newJObject()
  var body_568529 = newJObject()
  add(query_568528, "api-version", newJString(apiVersion))
  add(path_568527, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568529 = parameters
  add(path_568527, "budgetName", newJString(budgetName))
  result = call_568526.call(path_568527, query_568528, nil, nil, body_568529)

var budgetsCreateOrUpdate* = Call_BudgetsCreateOrUpdate_568518(
    name: "budgetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsCreateOrUpdate_568519, base: "",
    url: url_BudgetsCreateOrUpdate_568520, schemes: {Scheme.Https})
type
  Call_BudgetsGet_568508 = ref object of OpenApiRestCall_567658
proc url_BudgetsGet_568510(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsGet_568509(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the budget for a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568511 = path.getOrDefault("subscriptionId")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "subscriptionId", valid_568511
  var valid_568512 = path.getOrDefault("budgetName")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "budgetName", valid_568512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568513 = query.getOrDefault("api-version")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "api-version", valid_568513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568514: Call_BudgetsGet_568508; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_BudgetsGet_568508; apiVersion: string;
          subscriptionId: string; budgetName: string): Recallable =
  ## budgetsGet
  ## Gets the budget for a subscription by budget name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  add(query_568517, "api-version", newJString(apiVersion))
  add(path_568516, "subscriptionId", newJString(subscriptionId))
  add(path_568516, "budgetName", newJString(budgetName))
  result = call_568515.call(path_568516, query_568517, nil, nil, nil)

var budgetsGet* = Call_BudgetsGet_568508(name: "budgetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
                                      validator: validate_BudgetsGet_568509,
                                      base: "", url: url_BudgetsGet_568510,
                                      schemes: {Scheme.Https})
type
  Call_BudgetsDelete_568530 = ref object of OpenApiRestCall_567658
proc url_BudgetsDelete_568532(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsDelete_568531(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568533 = path.getOrDefault("subscriptionId")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "subscriptionId", valid_568533
  var valid_568534 = path.getOrDefault("budgetName")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "budgetName", valid_568534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568535 = query.getOrDefault("api-version")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "api-version", valid_568535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568536: Call_BudgetsDelete_568530; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568536.validator(path, query, header, formData, body)
  let scheme = call_568536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568536.url(scheme.get, call_568536.host, call_568536.base,
                         call_568536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568536, url, valid)

proc call*(call_568537: Call_BudgetsDelete_568530; apiVersion: string;
          subscriptionId: string; budgetName: string): Recallable =
  ## budgetsDelete
  ## The operation to delete a budget.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568538 = newJObject()
  var query_568539 = newJObject()
  add(query_568539, "api-version", newJString(apiVersion))
  add(path_568538, "subscriptionId", newJString(subscriptionId))
  add(path_568538, "budgetName", newJString(budgetName))
  result = call_568537.call(path_568538, query_568539, nil, nil, nil)

var budgetsDelete* = Call_BudgetsDelete_568530(name: "budgetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsDelete_568531, base: "", url: url_BudgetsDelete_568532,
    schemes: {Scheme.Https})
type
  Call_MarketplacesList_568540 = ref object of OpenApiRestCall_567658
proc url_MarketplacesList_568542(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesList_568541(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by subscriptionId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568543 = path.getOrDefault("subscriptionId")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "subscriptionId", valid_568543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568544 = query.getOrDefault("api-version")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "api-version", valid_568544
  var valid_568545 = query.getOrDefault("$top")
  valid_568545 = validateParameter(valid_568545, JInt, required = false, default = nil)
  if valid_568545 != nil:
    section.add "$top", valid_568545
  var valid_568546 = query.getOrDefault("$skiptoken")
  valid_568546 = validateParameter(valid_568546, JString, required = false,
                                 default = nil)
  if valid_568546 != nil:
    section.add "$skiptoken", valid_568546
  var valid_568547 = query.getOrDefault("$filter")
  valid_568547 = validateParameter(valid_568547, JString, required = false,
                                 default = nil)
  if valid_568547 != nil:
    section.add "$filter", valid_568547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568548: Call_MarketplacesList_568540; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by subscriptionId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568548.validator(path, query, header, formData, body)
  let scheme = call_568548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568548.url(scheme.get, call_568548.host, call_568548.base,
                         call_568548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568548, url, valid)

proc call*(call_568549: Call_MarketplacesList_568540; apiVersion: string;
          subscriptionId: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## marketplacesList
  ## Lists the marketplaces for a scope by subscriptionId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568550 = newJObject()
  var query_568551 = newJObject()
  add(query_568551, "api-version", newJString(apiVersion))
  add(path_568550, "subscriptionId", newJString(subscriptionId))
  add(query_568551, "$top", newJInt(Top))
  add(query_568551, "$skiptoken", newJString(Skiptoken))
  add(query_568551, "$filter", newJString(Filter))
  result = call_568549.call(path_568550, query_568551, nil, nil, nil)

var marketplacesList* = Call_MarketplacesList_568540(name: "marketplacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesList_568541, base: "",
    url: url_MarketplacesList_568542, schemes: {Scheme.Https})
type
  Call_PriceSheetGet_568552 = ref object of OpenApiRestCall_567658
proc url_PriceSheetGet_568554(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Consumption/pricesheets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PriceSheetGet_568553(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568555 = path.getOrDefault("subscriptionId")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "subscriptionId", valid_568555
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the top N results.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  var valid_568556 = query.getOrDefault("$expand")
  valid_568556 = validateParameter(valid_568556, JString, required = false,
                                 default = nil)
  if valid_568556 != nil:
    section.add "$expand", valid_568556
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568557 = query.getOrDefault("api-version")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "api-version", valid_568557
  var valid_568558 = query.getOrDefault("$top")
  valid_568558 = validateParameter(valid_568558, JInt, required = false, default = nil)
  if valid_568558 != nil:
    section.add "$top", valid_568558
  var valid_568559 = query.getOrDefault("$skiptoken")
  valid_568559 = validateParameter(valid_568559, JString, required = false,
                                 default = nil)
  if valid_568559 != nil:
    section.add "$skiptoken", valid_568559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568560: Call_PriceSheetGet_568552; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568560.validator(path, query, header, formData, body)
  let scheme = call_568560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568560.url(scheme.get, call_568560.host, call_568560.base,
                         call_568560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568560, url, valid)

proc call*(call_568561: Call_PriceSheetGet_568552; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""): Recallable =
  ## priceSheetGet
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the top N results.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  var path_568562 = newJObject()
  var query_568563 = newJObject()
  add(query_568563, "$expand", newJString(Expand))
  add(query_568563, "api-version", newJString(apiVersion))
  add(path_568562, "subscriptionId", newJString(subscriptionId))
  add(query_568563, "$top", newJInt(Top))
  add(query_568563, "$skiptoken", newJString(Skiptoken))
  result = call_568561.call(path_568562, query_568563, nil, nil, nil)

var priceSheetGet* = Call_PriceSheetGet_568552(name: "priceSheetGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGet_568553, base: "", url: url_PriceSheetGet_568554,
    schemes: {Scheme.Https})
type
  Call_ReservationRecommendationsList_568564 = ref object of OpenApiRestCall_567658
proc url_ReservationRecommendationsList_568566(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/reservationRecommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationRecommendationsList_568565(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of recommendations for purchasing reserved instances.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568567 = path.getOrDefault("subscriptionId")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "subscriptionId", valid_568567
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $filter: JString
  ##          : May be used to filter reservationRecommendations by properties/scope and properties/lookBackPeriod.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568568 = query.getOrDefault("api-version")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "api-version", valid_568568
  var valid_568569 = query.getOrDefault("$filter")
  valid_568569 = validateParameter(valid_568569, JString, required = false,
                                 default = nil)
  if valid_568569 != nil:
    section.add "$filter", valid_568569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568570: Call_ReservationRecommendationsList_568564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of recommendations for purchasing reserved instances.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568570.validator(path, query, header, formData, body)
  let scheme = call_568570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568570.url(scheme.get, call_568570.host, call_568570.base,
                         call_568570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568570, url, valid)

proc call*(call_568571: Call_ReservationRecommendationsList_568564;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## reservationRecommendationsList
  ## List of recommendations for purchasing reserved instances.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Filter: string
  ##         : May be used to filter reservationRecommendations by properties/scope and properties/lookBackPeriod.
  var path_568572 = newJObject()
  var query_568573 = newJObject()
  add(query_568573, "api-version", newJString(apiVersion))
  add(path_568572, "subscriptionId", newJString(subscriptionId))
  add(query_568573, "$filter", newJString(Filter))
  result = call_568571.call(path_568572, query_568573, nil, nil, nil)

var reservationRecommendationsList* = Call_ReservationRecommendationsList_568564(
    name: "reservationRecommendationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/reservationRecommendations",
    validator: validate_ReservationRecommendationsList_568565, base: "",
    url: url_ReservationRecommendationsList_568566, schemes: {Scheme.Https})
type
  Call_UsageDetailsList_568574 = ref object of OpenApiRestCall_567658
proc url_UsageDetailsList_568576(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsList_568575(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the usage details for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568577 = path.getOrDefault("subscriptionId")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "subscriptionId", valid_568577
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568578 = query.getOrDefault("$expand")
  valid_568578 = validateParameter(valid_568578, JString, required = false,
                                 default = nil)
  if valid_568578 != nil:
    section.add "$expand", valid_568578
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568579 = query.getOrDefault("api-version")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "api-version", valid_568579
  var valid_568580 = query.getOrDefault("$top")
  valid_568580 = validateParameter(valid_568580, JInt, required = false, default = nil)
  if valid_568580 != nil:
    section.add "$top", valid_568580
  var valid_568581 = query.getOrDefault("$skiptoken")
  valid_568581 = validateParameter(valid_568581, JString, required = false,
                                 default = nil)
  if valid_568581 != nil:
    section.add "$skiptoken", valid_568581
  var valid_568582 = query.getOrDefault("$apply")
  valid_568582 = validateParameter(valid_568582, JString, required = false,
                                 default = nil)
  if valid_568582 != nil:
    section.add "$apply", valid_568582
  var valid_568583 = query.getOrDefault("$filter")
  valid_568583 = validateParameter(valid_568583, JString, required = false,
                                 default = nil)
  if valid_568583 != nil:
    section.add "$filter", valid_568583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568584: Call_UsageDetailsList_568574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568584.validator(path, query, header, formData, body)
  let scheme = call_568584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568584.url(scheme.get, call_568584.host, call_568584.base,
                         call_568584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568584, url, valid)

proc call*(call_568585: Call_UsageDetailsList_568574; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsList
  ## Lists the usage details for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568586 = newJObject()
  var query_568587 = newJObject()
  add(query_568587, "$expand", newJString(Expand))
  add(query_568587, "api-version", newJString(apiVersion))
  add(path_568586, "subscriptionId", newJString(subscriptionId))
  add(query_568587, "$top", newJInt(Top))
  add(query_568587, "$skiptoken", newJString(Skiptoken))
  add(query_568587, "$apply", newJString(Apply))
  add(query_568587, "$filter", newJString(Filter))
  result = call_568585.call(path_568586, query_568587, nil, nil, nil)

var usageDetailsList* = Call_UsageDetailsList_568574(name: "usageDetailsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsList_568575, base: "",
    url: url_UsageDetailsList_568576, schemes: {Scheme.Https})
type
  Call_BudgetsListByResourceGroupName_568588 = ref object of OpenApiRestCall_567658
proc url_BudgetsListByResourceGroupName_568590(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsListByResourceGroupName_568589(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all budgets for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
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
  var valid_568591 = path.getOrDefault("resourceGroupName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "resourceGroupName", valid_568591
  var valid_568592 = path.getOrDefault("subscriptionId")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "subscriptionId", valid_568592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568593 = query.getOrDefault("api-version")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "api-version", valid_568593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568594: Call_BudgetsListByResourceGroupName_568588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568594.validator(path, query, header, formData, body)
  let scheme = call_568594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568594.url(scheme.get, call_568594.host, call_568594.base,
                         call_568594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568594, url, valid)

proc call*(call_568595: Call_BudgetsListByResourceGroupName_568588;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## budgetsListByResourceGroupName
  ## Lists all budgets for a resource group under a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568596 = newJObject()
  var query_568597 = newJObject()
  add(path_568596, "resourceGroupName", newJString(resourceGroupName))
  add(query_568597, "api-version", newJString(apiVersion))
  add(path_568596, "subscriptionId", newJString(subscriptionId))
  result = call_568595.call(path_568596, query_568597, nil, nil, nil)

var budgetsListByResourceGroupName* = Call_BudgetsListByResourceGroupName_568588(
    name: "budgetsListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets",
    validator: validate_BudgetsListByResourceGroupName_568589, base: "",
    url: url_BudgetsListByResourceGroupName_568590, schemes: {Scheme.Https})
type
  Call_BudgetsCreateOrUpdateByResourceGroupName_568609 = ref object of OpenApiRestCall_567658
proc url_BudgetsCreateOrUpdateByResourceGroupName_568611(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsCreateOrUpdateByResourceGroupName_568610(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568612 = path.getOrDefault("resourceGroupName")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "resourceGroupName", valid_568612
  var valid_568613 = path.getOrDefault("subscriptionId")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "subscriptionId", valid_568613
  var valid_568614 = path.getOrDefault("budgetName")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "budgetName", valid_568614
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568615 = query.getOrDefault("api-version")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "api-version", valid_568615
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568617: Call_BudgetsCreateOrUpdateByResourceGroupName_568609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568617.validator(path, query, header, formData, body)
  let scheme = call_568617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568617.url(scheme.get, call_568617.host, call_568617.base,
                         call_568617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568617, url, valid)

proc call*(call_568618: Call_BudgetsCreateOrUpdateByResourceGroupName_568609;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; budgetName: string): Recallable =
  ## budgetsCreateOrUpdateByResourceGroupName
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568619 = newJObject()
  var query_568620 = newJObject()
  var body_568621 = newJObject()
  add(path_568619, "resourceGroupName", newJString(resourceGroupName))
  add(query_568620, "api-version", newJString(apiVersion))
  add(path_568619, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568621 = parameters
  add(path_568619, "budgetName", newJString(budgetName))
  result = call_568618.call(path_568619, query_568620, nil, nil, body_568621)

var budgetsCreateOrUpdateByResourceGroupName* = Call_BudgetsCreateOrUpdateByResourceGroupName_568609(
    name: "budgetsCreateOrUpdateByResourceGroupName", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsCreateOrUpdateByResourceGroupName_568610, base: "",
    url: url_BudgetsCreateOrUpdateByResourceGroupName_568611,
    schemes: {Scheme.Https})
type
  Call_BudgetsGetByResourceGroupName_568598 = ref object of OpenApiRestCall_567658
proc url_BudgetsGetByResourceGroupName_568600(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsGetByResourceGroupName_568599(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the budget for a resource group under a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568601 = path.getOrDefault("resourceGroupName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "resourceGroupName", valid_568601
  var valid_568602 = path.getOrDefault("subscriptionId")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "subscriptionId", valid_568602
  var valid_568603 = path.getOrDefault("budgetName")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "budgetName", valid_568603
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568604 = query.getOrDefault("api-version")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "api-version", valid_568604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568605: Call_BudgetsGetByResourceGroupName_568598; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for a resource group under a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568605.validator(path, query, header, formData, body)
  let scheme = call_568605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568605.url(scheme.get, call_568605.host, call_568605.base,
                         call_568605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568605, url, valid)

proc call*(call_568606: Call_BudgetsGetByResourceGroupName_568598;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          budgetName: string): Recallable =
  ## budgetsGetByResourceGroupName
  ## Gets the budget for a resource group under a subscription by budget name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568607 = newJObject()
  var query_568608 = newJObject()
  add(path_568607, "resourceGroupName", newJString(resourceGroupName))
  add(query_568608, "api-version", newJString(apiVersion))
  add(path_568607, "subscriptionId", newJString(subscriptionId))
  add(path_568607, "budgetName", newJString(budgetName))
  result = call_568606.call(path_568607, query_568608, nil, nil, nil)

var budgetsGetByResourceGroupName* = Call_BudgetsGetByResourceGroupName_568598(
    name: "budgetsGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsGetByResourceGroupName_568599, base: "",
    url: url_BudgetsGetByResourceGroupName_568600, schemes: {Scheme.Https})
type
  Call_BudgetsDeleteByResourceGroupName_568622 = ref object of OpenApiRestCall_567658
proc url_BudgetsDeleteByResourceGroupName_568624(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsDeleteByResourceGroupName_568623(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568625 = path.getOrDefault("resourceGroupName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "resourceGroupName", valid_568625
  var valid_568626 = path.getOrDefault("subscriptionId")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "subscriptionId", valid_568626
  var valid_568627 = path.getOrDefault("budgetName")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "budgetName", valid_568627
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568628 = query.getOrDefault("api-version")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "api-version", valid_568628
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568629: Call_BudgetsDeleteByResourceGroupName_568622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568629.validator(path, query, header, formData, body)
  let scheme = call_568629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568629.url(scheme.get, call_568629.host, call_568629.base,
                         call_568629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568629, url, valid)

proc call*(call_568630: Call_BudgetsDeleteByResourceGroupName_568622;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          budgetName: string): Recallable =
  ## budgetsDeleteByResourceGroupName
  ## The operation to delete a budget.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568631 = newJObject()
  var query_568632 = newJObject()
  add(path_568631, "resourceGroupName", newJString(resourceGroupName))
  add(query_568632, "api-version", newJString(apiVersion))
  add(path_568631, "subscriptionId", newJString(subscriptionId))
  add(path_568631, "budgetName", newJString(budgetName))
  result = call_568630.call(path_568631, query_568632, nil, nil, nil)

var budgetsDeleteByResourceGroupName* = Call_BudgetsDeleteByResourceGroupName_568622(
    name: "budgetsDeleteByResourceGroupName", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsDeleteByResourceGroupName_568623, base: "",
    url: url_BudgetsDeleteByResourceGroupName_568624, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
