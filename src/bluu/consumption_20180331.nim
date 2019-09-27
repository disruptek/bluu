
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_GetBalancesByBillingAccountByBillingPeriod_593647 = ref object of OpenApiRestCall_593425
proc url_GetBalancesByBillingAccountByBillingPeriod_593649(protocol: Scheme;
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

proc validate_GetBalancesByBillingAccountByBillingPeriod_593648(path: JsonNode;
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
  var valid_593822 = path.getOrDefault("billingPeriodName")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "billingPeriodName", valid_593822
  var valid_593823 = path.getOrDefault("billingAccountId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "billingAccountId", valid_593823
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593847: Call_GetBalancesByBillingAccountByBillingPeriod_593647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_GetBalancesByBillingAccountByBillingPeriod_593647;
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
  var path_593919 = newJObject()
  var query_593921 = newJObject()
  add(query_593921, "api-version", newJString(apiVersion))
  add(path_593919, "billingPeriodName", newJString(billingPeriodName))
  add(path_593919, "billingAccountId", newJString(billingAccountId))
  result = call_593918.call(path_593919, query_593921, nil, nil, nil)

var getBalancesByBillingAccountByBillingPeriod* = Call_GetBalancesByBillingAccountByBillingPeriod_593647(
    name: "getBalancesByBillingAccountByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/balances",
    validator: validate_GetBalancesByBillingAccountByBillingPeriod_593648,
    base: "", url: url_GetBalancesByBillingAccountByBillingPeriod_593649,
    schemes: {Scheme.Https})
type
  Call_MarketplacesByBillingAccountListByBillingPeriod_593960 = ref object of OpenApiRestCall_593425
proc url_MarketplacesByBillingAccountListByBillingPeriod_593962(protocol: Scheme;
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

proc validate_MarketplacesByBillingAccountListByBillingPeriod_593961(
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
  var valid_593964 = path.getOrDefault("billingPeriodName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "billingPeriodName", valid_593964
  var valid_593965 = path.getOrDefault("billingAccountId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "billingAccountId", valid_593965
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
  var valid_593966 = query.getOrDefault("api-version")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "api-version", valid_593966
  var valid_593967 = query.getOrDefault("$top")
  valid_593967 = validateParameter(valid_593967, JInt, required = false, default = nil)
  if valid_593967 != nil:
    section.add "$top", valid_593967
  var valid_593968 = query.getOrDefault("$skiptoken")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "$skiptoken", valid_593968
  var valid_593969 = query.getOrDefault("$filter")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "$filter", valid_593969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593970: Call_MarketplacesByBillingAccountListByBillingPeriod_593960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and billingAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_593970.validator(path, query, header, formData, body)
  let scheme = call_593970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593970.url(scheme.get, call_593970.host, call_593970.base,
                         call_593970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593970, url, valid)

proc call*(call_593971: Call_MarketplacesByBillingAccountListByBillingPeriod_593960;
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
  var path_593972 = newJObject()
  var query_593973 = newJObject()
  add(query_593973, "api-version", newJString(apiVersion))
  add(query_593973, "$top", newJInt(Top))
  add(query_593973, "$skiptoken", newJString(Skiptoken))
  add(path_593972, "billingPeriodName", newJString(billingPeriodName))
  add(path_593972, "billingAccountId", newJString(billingAccountId))
  add(query_593973, "$filter", newJString(Filter))
  result = call_593971.call(path_593972, query_593973, nil, nil, nil)

var marketplacesByBillingAccountListByBillingPeriod* = Call_MarketplacesByBillingAccountListByBillingPeriod_593960(
    name: "marketplacesByBillingAccountListByBillingPeriod",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByBillingAccountListByBillingPeriod_593961,
    base: "", url: url_MarketplacesByBillingAccountListByBillingPeriod_593962,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsByBillingAccountListByBillingPeriod_593974 = ref object of OpenApiRestCall_593425
proc url_UsageDetailsByBillingAccountListByBillingPeriod_593976(protocol: Scheme;
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

proc validate_UsageDetailsByBillingAccountListByBillingPeriod_593975(
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
  var valid_593977 = path.getOrDefault("billingPeriodName")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "billingPeriodName", valid_593977
  var valid_593978 = path.getOrDefault("billingAccountId")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "billingAccountId", valid_593978
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
  var valid_593979 = query.getOrDefault("$expand")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "$expand", valid_593979
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593980 = query.getOrDefault("api-version")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "api-version", valid_593980
  var valid_593981 = query.getOrDefault("$top")
  valid_593981 = validateParameter(valid_593981, JInt, required = false, default = nil)
  if valid_593981 != nil:
    section.add "$top", valid_593981
  var valid_593982 = query.getOrDefault("$skiptoken")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "$skiptoken", valid_593982
  var valid_593983 = query.getOrDefault("$apply")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "$apply", valid_593983
  var valid_593984 = query.getOrDefault("$filter")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "$filter", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_UsageDetailsByBillingAccountListByBillingPeriod_593974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details based on billingAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_UsageDetailsByBillingAccountListByBillingPeriod_593974;
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
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(query_593988, "$expand", newJString(Expand))
  add(query_593988, "api-version", newJString(apiVersion))
  add(query_593988, "$top", newJInt(Top))
  add(query_593988, "$skiptoken", newJString(Skiptoken))
  add(path_593987, "billingPeriodName", newJString(billingPeriodName))
  add(path_593987, "billingAccountId", newJString(billingAccountId))
  add(query_593988, "$apply", newJString(Apply))
  add(query_593988, "$filter", newJString(Filter))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var usageDetailsByBillingAccountListByBillingPeriod* = Call_UsageDetailsByBillingAccountListByBillingPeriod_593974(
    name: "usageDetailsByBillingAccountListByBillingPeriod",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByBillingAccountListByBillingPeriod_593975,
    base: "", url: url_UsageDetailsByBillingAccountListByBillingPeriod_593976,
    schemes: {Scheme.Https})
type
  Call_GetBalancesByBillingAccount_593989 = ref object of OpenApiRestCall_593425
proc url_GetBalancesByBillingAccount_593991(protocol: Scheme; host: string;
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

proc validate_GetBalancesByBillingAccount_593990(path: JsonNode; query: JsonNode;
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
  var valid_593992 = path.getOrDefault("billingAccountId")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "billingAccountId", valid_593992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "api-version", valid_593993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593994: Call_GetBalancesByBillingAccount_593989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_GetBalancesByBillingAccount_593989;
          apiVersion: string; billingAccountId: string): Recallable =
  ## getBalancesByBillingAccount
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  add(query_593997, "api-version", newJString(apiVersion))
  add(path_593996, "billingAccountId", newJString(billingAccountId))
  result = call_593995.call(path_593996, query_593997, nil, nil, nil)

var getBalancesByBillingAccount* = Call_GetBalancesByBillingAccount_593989(
    name: "getBalancesByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/balances",
    validator: validate_GetBalancesByBillingAccount_593990, base: "",
    url: url_GetBalancesByBillingAccount_593991, schemes: {Scheme.Https})
type
  Call_CostTagsCreateOrUpdate_594007 = ref object of OpenApiRestCall_593425
proc url_CostTagsCreateOrUpdate_594009(protocol: Scheme; host: string; base: string;
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

proc validate_CostTagsCreateOrUpdate_594008(path: JsonNode; query: JsonNode;
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
  var valid_594010 = path.getOrDefault("billingAccountId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "billingAccountId", valid_594010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "api-version", valid_594011
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

proc call*(call_594013: Call_CostTagsCreateOrUpdate_594007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update cost tags associated with a billing account. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_CostTagsCreateOrUpdate_594007; apiVersion: string;
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
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  var body_594017 = newJObject()
  add(query_594016, "api-version", newJString(apiVersion))
  add(path_594015, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_594017 = parameters
  result = call_594014.call(path_594015, query_594016, nil, nil, body_594017)

var costTagsCreateOrUpdate* = Call_CostTagsCreateOrUpdate_594007(
    name: "costTagsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/costTags",
    validator: validate_CostTagsCreateOrUpdate_594008, base: "",
    url: url_CostTagsCreateOrUpdate_594009, schemes: {Scheme.Https})
type
  Call_CostTagsGet_593998 = ref object of OpenApiRestCall_593425
proc url_CostTagsGet_594000(protocol: Scheme; host: string; base: string;
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

proc validate_CostTagsGet_593999(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594001 = path.getOrDefault("billingAccountId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "billingAccountId", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_CostTagsGet_593998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost tags for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_CostTagsGet_593998; apiVersion: string;
          billingAccountId: string): Recallable =
  ## costTagsGet
  ## Get cost tags for a billing account.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "billingAccountId", newJString(billingAccountId))
  result = call_594004.call(path_594005, query_594006, nil, nil, nil)

var costTagsGet* = Call_CostTagsGet_593998(name: "costTagsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/costTags",
                                        validator: validate_CostTagsGet_593999,
                                        base: "", url: url_CostTagsGet_594000,
                                        schemes: {Scheme.Https})
type
  Call_MarketplacesByBillingAccountList_594018 = ref object of OpenApiRestCall_593425
proc url_MarketplacesByBillingAccountList_594020(protocol: Scheme; host: string;
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

proc validate_MarketplacesByBillingAccountList_594019(path: JsonNode;
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
  var valid_594021 = path.getOrDefault("billingAccountId")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "billingAccountId", valid_594021
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
  var valid_594022 = query.getOrDefault("api-version")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "api-version", valid_594022
  var valid_594023 = query.getOrDefault("$top")
  valid_594023 = validateParameter(valid_594023, JInt, required = false, default = nil)
  if valid_594023 != nil:
    section.add "$top", valid_594023
  var valid_594024 = query.getOrDefault("$skiptoken")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "$skiptoken", valid_594024
  var valid_594025 = query.getOrDefault("$filter")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "$filter", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_MarketplacesByBillingAccountList_594018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billingAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_MarketplacesByBillingAccountList_594018;
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
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(query_594029, "api-version", newJString(apiVersion))
  add(query_594029, "$top", newJInt(Top))
  add(query_594029, "$skiptoken", newJString(Skiptoken))
  add(path_594028, "billingAccountId", newJString(billingAccountId))
  add(query_594029, "$filter", newJString(Filter))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var marketplacesByBillingAccountList* = Call_MarketplacesByBillingAccountList_594018(
    name: "marketplacesByBillingAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByBillingAccountList_594019, base: "",
    url: url_MarketplacesByBillingAccountList_594020, schemes: {Scheme.Https})
type
  Call_UsageDetailsByBillingAccountList_594030 = ref object of OpenApiRestCall_593425
proc url_UsageDetailsByBillingAccountList_594032(protocol: Scheme; host: string;
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

proc validate_UsageDetailsByBillingAccountList_594031(path: JsonNode;
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
  var valid_594033 = path.getOrDefault("billingAccountId")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "billingAccountId", valid_594033
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
  var valid_594034 = query.getOrDefault("$expand")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "$expand", valid_594034
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594035 = query.getOrDefault("api-version")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "api-version", valid_594035
  var valid_594036 = query.getOrDefault("$top")
  valid_594036 = validateParameter(valid_594036, JInt, required = false, default = nil)
  if valid_594036 != nil:
    section.add "$top", valid_594036
  var valid_594037 = query.getOrDefault("$skiptoken")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "$skiptoken", valid_594037
  var valid_594038 = query.getOrDefault("$apply")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "$apply", valid_594038
  var valid_594039 = query.getOrDefault("$filter")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "$filter", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_UsageDetailsByBillingAccountList_594030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details by billingAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_UsageDetailsByBillingAccountList_594030;
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
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  add(query_594043, "$expand", newJString(Expand))
  add(query_594043, "api-version", newJString(apiVersion))
  add(query_594043, "$top", newJInt(Top))
  add(query_594043, "$skiptoken", newJString(Skiptoken))
  add(path_594042, "billingAccountId", newJString(billingAccountId))
  add(query_594043, "$apply", newJString(Apply))
  add(query_594043, "$filter", newJString(Filter))
  result = call_594041.call(path_594042, query_594043, nil, nil, nil)

var usageDetailsByBillingAccountList* = Call_UsageDetailsByBillingAccountList_594030(
    name: "usageDetailsByBillingAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByBillingAccountList_594031, base: "",
    url: url_UsageDetailsByBillingAccountList_594032, schemes: {Scheme.Https})
type
  Call_MarketplacesByDepartmentListByBillingPeriod_594044 = ref object of OpenApiRestCall_593425
proc url_MarketplacesByDepartmentListByBillingPeriod_594046(protocol: Scheme;
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

proc validate_MarketplacesByDepartmentListByBillingPeriod_594045(path: JsonNode;
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
  var valid_594047 = path.getOrDefault("billingPeriodName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "billingPeriodName", valid_594047
  var valid_594048 = path.getOrDefault("departmentId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "departmentId", valid_594048
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
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "api-version", valid_594049
  var valid_594050 = query.getOrDefault("$top")
  valid_594050 = validateParameter(valid_594050, JInt, required = false, default = nil)
  if valid_594050 != nil:
    section.add "$top", valid_594050
  var valid_594051 = query.getOrDefault("$skiptoken")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "$skiptoken", valid_594051
  var valid_594052 = query.getOrDefault("$filter")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "$filter", valid_594052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594053: Call_MarketplacesByDepartmentListByBillingPeriod_594044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and departmentId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_MarketplacesByDepartmentListByBillingPeriod_594044;
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
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  add(query_594056, "api-version", newJString(apiVersion))
  add(query_594056, "$top", newJInt(Top))
  add(query_594056, "$skiptoken", newJString(Skiptoken))
  add(path_594055, "billingPeriodName", newJString(billingPeriodName))
  add(path_594055, "departmentId", newJString(departmentId))
  add(query_594056, "$filter", newJString(Filter))
  result = call_594054.call(path_594055, query_594056, nil, nil, nil)

var marketplacesByDepartmentListByBillingPeriod* = Call_MarketplacesByDepartmentListByBillingPeriod_594044(
    name: "marketplacesByDepartmentListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByDepartmentListByBillingPeriod_594045,
    base: "", url: url_MarketplacesByDepartmentListByBillingPeriod_594046,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsByDepartmentListByBillingPeriod_594057 = ref object of OpenApiRestCall_593425
proc url_UsageDetailsByDepartmentListByBillingPeriod_594059(protocol: Scheme;
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

proc validate_UsageDetailsByDepartmentListByBillingPeriod_594058(path: JsonNode;
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
  var valid_594060 = path.getOrDefault("billingPeriodName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "billingPeriodName", valid_594060
  var valid_594061 = path.getOrDefault("departmentId")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "departmentId", valid_594061
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
  var valid_594062 = query.getOrDefault("$expand")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "$expand", valid_594062
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  var valid_594064 = query.getOrDefault("$top")
  valid_594064 = validateParameter(valid_594064, JInt, required = false, default = nil)
  if valid_594064 != nil:
    section.add "$top", valid_594064
  var valid_594065 = query.getOrDefault("$skiptoken")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "$skiptoken", valid_594065
  var valid_594066 = query.getOrDefault("$apply")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "$apply", valid_594066
  var valid_594067 = query.getOrDefault("$filter")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "$filter", valid_594067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594068: Call_UsageDetailsByDepartmentListByBillingPeriod_594057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details  based on departmentId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594068.validator(path, query, header, formData, body)
  let scheme = call_594068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594068.url(scheme.get, call_594068.host, call_594068.base,
                         call_594068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594068, url, valid)

proc call*(call_594069: Call_UsageDetailsByDepartmentListByBillingPeriod_594057;
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
  var path_594070 = newJObject()
  var query_594071 = newJObject()
  add(query_594071, "$expand", newJString(Expand))
  add(query_594071, "api-version", newJString(apiVersion))
  add(query_594071, "$top", newJInt(Top))
  add(query_594071, "$skiptoken", newJString(Skiptoken))
  add(path_594070, "billingPeriodName", newJString(billingPeriodName))
  add(path_594070, "departmentId", newJString(departmentId))
  add(query_594071, "$apply", newJString(Apply))
  add(query_594071, "$filter", newJString(Filter))
  result = call_594069.call(path_594070, query_594071, nil, nil, nil)

var usageDetailsByDepartmentListByBillingPeriod* = Call_UsageDetailsByDepartmentListByBillingPeriod_594057(
    name: "usageDetailsByDepartmentListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByDepartmentListByBillingPeriod_594058,
    base: "", url: url_UsageDetailsByDepartmentListByBillingPeriod_594059,
    schemes: {Scheme.Https})
type
  Call_MarketplacesByDepartmentList_594072 = ref object of OpenApiRestCall_593425
proc url_MarketplacesByDepartmentList_594074(protocol: Scheme; host: string;
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

proc validate_MarketplacesByDepartmentList_594073(path: JsonNode; query: JsonNode;
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
  var valid_594075 = path.getOrDefault("departmentId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "departmentId", valid_594075
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
  var valid_594076 = query.getOrDefault("api-version")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "api-version", valid_594076
  var valid_594077 = query.getOrDefault("$top")
  valid_594077 = validateParameter(valid_594077, JInt, required = false, default = nil)
  if valid_594077 != nil:
    section.add "$top", valid_594077
  var valid_594078 = query.getOrDefault("$skiptoken")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "$skiptoken", valid_594078
  var valid_594079 = query.getOrDefault("$filter")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "$filter", valid_594079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_MarketplacesByDepartmentList_594072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by departmentId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_MarketplacesByDepartmentList_594072;
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
  var path_594082 = newJObject()
  var query_594083 = newJObject()
  add(query_594083, "api-version", newJString(apiVersion))
  add(query_594083, "$top", newJInt(Top))
  add(query_594083, "$skiptoken", newJString(Skiptoken))
  add(path_594082, "departmentId", newJString(departmentId))
  add(query_594083, "$filter", newJString(Filter))
  result = call_594081.call(path_594082, query_594083, nil, nil, nil)

var marketplacesByDepartmentList* = Call_MarketplacesByDepartmentList_594072(
    name: "marketplacesByDepartmentList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByDepartmentList_594073, base: "",
    url: url_MarketplacesByDepartmentList_594074, schemes: {Scheme.Https})
type
  Call_UsageDetailsByDepartmentList_594084 = ref object of OpenApiRestCall_593425
proc url_UsageDetailsByDepartmentList_594086(protocol: Scheme; host: string;
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

proc validate_UsageDetailsByDepartmentList_594085(path: JsonNode; query: JsonNode;
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
  var valid_594087 = path.getOrDefault("departmentId")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "departmentId", valid_594087
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
  var valid_594088 = query.getOrDefault("$expand")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "$expand", valid_594088
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594089 = query.getOrDefault("api-version")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "api-version", valid_594089
  var valid_594090 = query.getOrDefault("$top")
  valid_594090 = validateParameter(valid_594090, JInt, required = false, default = nil)
  if valid_594090 != nil:
    section.add "$top", valid_594090
  var valid_594091 = query.getOrDefault("$skiptoken")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "$skiptoken", valid_594091
  var valid_594092 = query.getOrDefault("$apply")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "$apply", valid_594092
  var valid_594093 = query.getOrDefault("$filter")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "$filter", valid_594093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594094: Call_UsageDetailsByDepartmentList_594084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details by departmentId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594094.validator(path, query, header, formData, body)
  let scheme = call_594094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594094.url(scheme.get, call_594094.host, call_594094.base,
                         call_594094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594094, url, valid)

proc call*(call_594095: Call_UsageDetailsByDepartmentList_594084;
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
  var path_594096 = newJObject()
  var query_594097 = newJObject()
  add(query_594097, "$expand", newJString(Expand))
  add(query_594097, "api-version", newJString(apiVersion))
  add(query_594097, "$top", newJInt(Top))
  add(query_594097, "$skiptoken", newJString(Skiptoken))
  add(path_594096, "departmentId", newJString(departmentId))
  add(query_594097, "$apply", newJString(Apply))
  add(query_594097, "$filter", newJString(Filter))
  result = call_594095.call(path_594096, query_594097, nil, nil, nil)

var usageDetailsByDepartmentList* = Call_UsageDetailsByDepartmentList_594084(
    name: "usageDetailsByDepartmentList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByDepartmentList_594085, base: "",
    url: url_UsageDetailsByDepartmentList_594086, schemes: {Scheme.Https})
type
  Call_MarketplacesByEnrollmentAccountsListByBillingPeriod_594098 = ref object of OpenApiRestCall_593425
proc url_MarketplacesByEnrollmentAccountsListByBillingPeriod_594100(
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

proc validate_MarketplacesByEnrollmentAccountsListByBillingPeriod_594099(
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
  var valid_594101 = path.getOrDefault("enrollmentAccountId")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "enrollmentAccountId", valid_594101
  var valid_594102 = path.getOrDefault("billingPeriodName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "billingPeriodName", valid_594102
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
  var valid_594103 = query.getOrDefault("api-version")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "api-version", valid_594103
  var valid_594104 = query.getOrDefault("$top")
  valid_594104 = validateParameter(valid_594104, JInt, required = false, default = nil)
  if valid_594104 != nil:
    section.add "$top", valid_594104
  var valid_594105 = query.getOrDefault("$skiptoken")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "$skiptoken", valid_594105
  var valid_594106 = query.getOrDefault("$filter")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "$filter", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_MarketplacesByEnrollmentAccountsListByBillingPeriod_594098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and enrollmentAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_MarketplacesByEnrollmentAccountsListByBillingPeriod_594098;
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
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(query_594110, "api-version", newJString(apiVersion))
  add(query_594110, "$top", newJInt(Top))
  add(query_594110, "$skiptoken", newJString(Skiptoken))
  add(path_594109, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_594109, "billingPeriodName", newJString(billingPeriodName))
  add(query_594110, "$filter", newJString(Filter))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var marketplacesByEnrollmentAccountsListByBillingPeriod* = Call_MarketplacesByEnrollmentAccountsListByBillingPeriod_594098(
    name: "marketplacesByEnrollmentAccountsListByBillingPeriod",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByEnrollmentAccountsListByBillingPeriod_594099,
    base: "", url: url_MarketplacesByEnrollmentAccountsListByBillingPeriod_594100,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsByEnrollmentAccountListByBillingPeriod_594111 = ref object of OpenApiRestCall_593425
proc url_UsageDetailsByEnrollmentAccountListByBillingPeriod_594113(
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

proc validate_UsageDetailsByEnrollmentAccountListByBillingPeriod_594112(
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
  var valid_594114 = path.getOrDefault("enrollmentAccountId")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "enrollmentAccountId", valid_594114
  var valid_594115 = path.getOrDefault("billingPeriodName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "billingPeriodName", valid_594115
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
  var valid_594116 = query.getOrDefault("$expand")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "$expand", valid_594116
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594117 = query.getOrDefault("api-version")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "api-version", valid_594117
  var valid_594118 = query.getOrDefault("$top")
  valid_594118 = validateParameter(valid_594118, JInt, required = false, default = nil)
  if valid_594118 != nil:
    section.add "$top", valid_594118
  var valid_594119 = query.getOrDefault("$skiptoken")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "$skiptoken", valid_594119
  var valid_594120 = query.getOrDefault("$apply")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "$apply", valid_594120
  var valid_594121 = query.getOrDefault("$filter")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "$filter", valid_594121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594122: Call_UsageDetailsByEnrollmentAccountListByBillingPeriod_594111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details based on enrollmentAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_UsageDetailsByEnrollmentAccountListByBillingPeriod_594111;
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
  var path_594124 = newJObject()
  var query_594125 = newJObject()
  add(query_594125, "$expand", newJString(Expand))
  add(query_594125, "api-version", newJString(apiVersion))
  add(query_594125, "$top", newJInt(Top))
  add(query_594125, "$skiptoken", newJString(Skiptoken))
  add(path_594124, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_594124, "billingPeriodName", newJString(billingPeriodName))
  add(query_594125, "$apply", newJString(Apply))
  add(query_594125, "$filter", newJString(Filter))
  result = call_594123.call(path_594124, query_594125, nil, nil, nil)

var usageDetailsByEnrollmentAccountListByBillingPeriod* = Call_UsageDetailsByEnrollmentAccountListByBillingPeriod_594111(
    name: "usageDetailsByEnrollmentAccountListByBillingPeriod",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByEnrollmentAccountListByBillingPeriod_594112,
    base: "", url: url_UsageDetailsByEnrollmentAccountListByBillingPeriod_594113,
    schemes: {Scheme.Https})
type
  Call_MarketplacesByEnrollmentAccountsList_594126 = ref object of OpenApiRestCall_593425
proc url_MarketplacesByEnrollmentAccountsList_594128(protocol: Scheme;
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

proc validate_MarketplacesByEnrollmentAccountsList_594127(path: JsonNode;
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
  var valid_594129 = path.getOrDefault("enrollmentAccountId")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "enrollmentAccountId", valid_594129
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
  var valid_594130 = query.getOrDefault("api-version")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "api-version", valid_594130
  var valid_594131 = query.getOrDefault("$top")
  valid_594131 = validateParameter(valid_594131, JInt, required = false, default = nil)
  if valid_594131 != nil:
    section.add "$top", valid_594131
  var valid_594132 = query.getOrDefault("$skiptoken")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "$skiptoken", valid_594132
  var valid_594133 = query.getOrDefault("$filter")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "$filter", valid_594133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594134: Call_MarketplacesByEnrollmentAccountsList_594126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by enrollmentAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594134.validator(path, query, header, formData, body)
  let scheme = call_594134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594134.url(scheme.get, call_594134.host, call_594134.base,
                         call_594134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594134, url, valid)

proc call*(call_594135: Call_MarketplacesByEnrollmentAccountsList_594126;
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
  var path_594136 = newJObject()
  var query_594137 = newJObject()
  add(query_594137, "api-version", newJString(apiVersion))
  add(query_594137, "$top", newJInt(Top))
  add(query_594137, "$skiptoken", newJString(Skiptoken))
  add(path_594136, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(query_594137, "$filter", newJString(Filter))
  result = call_594135.call(path_594136, query_594137, nil, nil, nil)

var marketplacesByEnrollmentAccountsList* = Call_MarketplacesByEnrollmentAccountsList_594126(
    name: "marketplacesByEnrollmentAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesByEnrollmentAccountsList_594127, base: "",
    url: url_MarketplacesByEnrollmentAccountsList_594128, schemes: {Scheme.Https})
type
  Call_UsageDetailsByEnrollmentAccountList_594138 = ref object of OpenApiRestCall_593425
proc url_UsageDetailsByEnrollmentAccountList_594140(protocol: Scheme; host: string;
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

proc validate_UsageDetailsByEnrollmentAccountList_594139(path: JsonNode;
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
  var valid_594141 = path.getOrDefault("enrollmentAccountId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "enrollmentAccountId", valid_594141
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
  var valid_594142 = query.getOrDefault("$expand")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "$expand", valid_594142
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594143 = query.getOrDefault("api-version")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "api-version", valid_594143
  var valid_594144 = query.getOrDefault("$top")
  valid_594144 = validateParameter(valid_594144, JInt, required = false, default = nil)
  if valid_594144 != nil:
    section.add "$top", valid_594144
  var valid_594145 = query.getOrDefault("$skiptoken")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "$skiptoken", valid_594145
  var valid_594146 = query.getOrDefault("$apply")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "$apply", valid_594146
  var valid_594147 = query.getOrDefault("$filter")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "$filter", valid_594147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594148: Call_UsageDetailsByEnrollmentAccountList_594138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details by enrollmentAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_UsageDetailsByEnrollmentAccountList_594138;
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
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  add(query_594151, "$expand", newJString(Expand))
  add(query_594151, "api-version", newJString(apiVersion))
  add(query_594151, "$top", newJInt(Top))
  add(query_594151, "$skiptoken", newJString(Skiptoken))
  add(path_594150, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(query_594151, "$apply", newJString(Apply))
  add(query_594151, "$filter", newJString(Filter))
  result = call_594149.call(path_594150, query_594151, nil, nil, nil)

var usageDetailsByEnrollmentAccountList* = Call_UsageDetailsByEnrollmentAccountList_594138(
    name: "usageDetailsByEnrollmentAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsByEnrollmentAccountList_594139, base: "",
    url: url_UsageDetailsByEnrollmentAccountList_594140, schemes: {Scheme.Https})
type
  Call_ReservationsDetailsListByReservationOrder_594152 = ref object of OpenApiRestCall_593425
proc url_ReservationsDetailsListByReservationOrder_594154(protocol: Scheme;
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

proc validate_ReservationsDetailsListByReservationOrder_594153(path: JsonNode;
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
  var valid_594155 = path.getOrDefault("reservationOrderId")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "reservationOrderId", valid_594155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594156 = query.getOrDefault("api-version")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "api-version", valid_594156
  var valid_594157 = query.getOrDefault("$filter")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "$filter", valid_594157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594158: Call_ReservationsDetailsListByReservationOrder_594152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594158.validator(path, query, header, formData, body)
  let scheme = call_594158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594158.url(scheme.get, call_594158.host, call_594158.base,
                         call_594158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594158, url, valid)

proc call*(call_594159: Call_ReservationsDetailsListByReservationOrder_594152;
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
  var path_594160 = newJObject()
  var query_594161 = newJObject()
  add(query_594161, "api-version", newJString(apiVersion))
  add(path_594160, "reservationOrderId", newJString(reservationOrderId))
  add(query_594161, "$filter", newJString(Filter))
  result = call_594159.call(path_594160, query_594161, nil, nil, nil)

var reservationsDetailsListByReservationOrder* = Call_ReservationsDetailsListByReservationOrder_594152(
    name: "reservationsDetailsListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationDetails",
    validator: validate_ReservationsDetailsListByReservationOrder_594153,
    base: "", url: url_ReservationsDetailsListByReservationOrder_594154,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrder_594162 = ref object of OpenApiRestCall_593425
proc url_ReservationsSummariesListByReservationOrder_594164(protocol: Scheme;
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

proc validate_ReservationsSummariesListByReservationOrder_594163(path: JsonNode;
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
  var valid_594165 = path.getOrDefault("reservationOrderId")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "reservationOrderId", valid_594165
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
  var valid_594166 = query.getOrDefault("api-version")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "api-version", valid_594166
  var valid_594167 = query.getOrDefault("$filter")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "$filter", valid_594167
  var valid_594181 = query.getOrDefault("grain")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = newJString("daily"))
  if valid_594181 != nil:
    section.add "grain", valid_594181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594182: Call_ReservationsSummariesListByReservationOrder_594162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_ReservationsSummariesListByReservationOrder_594162;
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
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  add(query_594185, "api-version", newJString(apiVersion))
  add(path_594184, "reservationOrderId", newJString(reservationOrderId))
  add(query_594185, "$filter", newJString(Filter))
  add(query_594185, "grain", newJString(grain))
  result = call_594183.call(path_594184, query_594185, nil, nil, nil)

var reservationsSummariesListByReservationOrder* = Call_ReservationsSummariesListByReservationOrder_594162(
    name: "reservationsSummariesListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationSummaries",
    validator: validate_ReservationsSummariesListByReservationOrder_594163,
    base: "", url: url_ReservationsSummariesListByReservationOrder_594164,
    schemes: {Scheme.Https})
type
  Call_ReservationsDetailsListByReservationOrderAndReservation_594186 = ref object of OpenApiRestCall_593425
proc url_ReservationsDetailsListByReservationOrderAndReservation_594188(
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

proc validate_ReservationsDetailsListByReservationOrderAndReservation_594187(
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
  var valid_594189 = path.getOrDefault("reservationOrderId")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "reservationOrderId", valid_594189
  var valid_594190 = path.getOrDefault("reservationId")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "reservationId", valid_594190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594191 = query.getOrDefault("api-version")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "api-version", valid_594191
  var valid_594192 = query.getOrDefault("$filter")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "$filter", valid_594192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594193: Call_ReservationsDetailsListByReservationOrderAndReservation_594186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594193.validator(path, query, header, formData, body)
  let scheme = call_594193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594193.url(scheme.get, call_594193.host, call_594193.base,
                         call_594193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594193, url, valid)

proc call*(call_594194: Call_ReservationsDetailsListByReservationOrderAndReservation_594186;
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
  var path_594195 = newJObject()
  var query_594196 = newJObject()
  add(query_594196, "api-version", newJString(apiVersion))
  add(path_594195, "reservationOrderId", newJString(reservationOrderId))
  add(path_594195, "reservationId", newJString(reservationId))
  add(query_594196, "$filter", newJString(Filter))
  result = call_594194.call(path_594195, query_594196, nil, nil, nil)

var reservationsDetailsListByReservationOrderAndReservation* = Call_ReservationsDetailsListByReservationOrderAndReservation_594186(
    name: "reservationsDetailsListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationDetails", validator: validate_ReservationsDetailsListByReservationOrderAndReservation_594187,
    base: "", url: url_ReservationsDetailsListByReservationOrderAndReservation_594188,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrderAndReservation_594197 = ref object of OpenApiRestCall_593425
proc url_ReservationsSummariesListByReservationOrderAndReservation_594199(
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

proc validate_ReservationsSummariesListByReservationOrderAndReservation_594198(
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
  var valid_594200 = path.getOrDefault("reservationOrderId")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "reservationOrderId", valid_594200
  var valid_594201 = path.getOrDefault("reservationId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "reservationId", valid_594201
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
  var valid_594202 = query.getOrDefault("api-version")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "api-version", valid_594202
  var valid_594203 = query.getOrDefault("$filter")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "$filter", valid_594203
  var valid_594204 = query.getOrDefault("grain")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = newJString("daily"))
  if valid_594204 != nil:
    section.add "grain", valid_594204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594205: Call_ReservationsSummariesListByReservationOrderAndReservation_594197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_ReservationsSummariesListByReservationOrderAndReservation_594197;
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
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  add(query_594208, "api-version", newJString(apiVersion))
  add(path_594207, "reservationOrderId", newJString(reservationOrderId))
  add(path_594207, "reservationId", newJString(reservationId))
  add(query_594208, "$filter", newJString(Filter))
  add(query_594208, "grain", newJString(grain))
  result = call_594206.call(path_594207, query_594208, nil, nil, nil)

var reservationsSummariesListByReservationOrderAndReservation* = Call_ReservationsSummariesListByReservationOrderAndReservation_594197(
    name: "reservationsSummariesListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationSummaries", validator: validate_ReservationsSummariesListByReservationOrderAndReservation_594198,
    base: "", url: url_ReservationsSummariesListByReservationOrderAndReservation_594199,
    schemes: {Scheme.Https})
type
  Call_OperationsList_594209 = ref object of OpenApiRestCall_593425
proc url_OperationsList_594211(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_594210(path: JsonNode; query: JsonNode;
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
  var valid_594212 = query.getOrDefault("api-version")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "api-version", valid_594212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594213: Call_OperationsList_594209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_594213.validator(path, query, header, formData, body)
  let scheme = call_594213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594213.url(scheme.get, call_594213.host, call_594213.base,
                         call_594213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594213, url, valid)

proc call*(call_594214: Call_OperationsList_594209; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  var query_594215 = newJObject()
  add(query_594215, "api-version", newJString(apiVersion))
  result = call_594214.call(nil, query_594215, nil, nil, nil)

var operationsList* = Call_OperationsList_594209(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Consumption/operations",
    validator: validate_OperationsList_594210, base: "", url: url_OperationsList_594211,
    schemes: {Scheme.Https})
type
  Call_TagsGet_594216 = ref object of OpenApiRestCall_593425
proc url_TagsGet_594218(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TagsGet_594217(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594219 = path.getOrDefault("billingAccountId")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "billingAccountId", valid_594219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594220 = query.getOrDefault("api-version")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "api-version", valid_594220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594221: Call_TagsGet_594216; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all available tag keys for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594221.validator(path, query, header, formData, body)
  let scheme = call_594221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594221.url(scheme.get, call_594221.host, call_594221.base,
                         call_594221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594221, url, valid)

proc call*(call_594222: Call_TagsGet_594216; apiVersion: string;
          billingAccountId: string): Recallable =
  ## tagsGet
  ## Get all available tag keys for a billing account.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_594223 = newJObject()
  var query_594224 = newJObject()
  add(query_594224, "api-version", newJString(apiVersion))
  add(path_594223, "billingAccountId", newJString(billingAccountId))
  result = call_594222.call(path_594223, query_594224, nil, nil, nil)

var tagsGet* = Call_TagsGet_594216(name: "tagsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/providers/Microsoft.CostManagement/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/tags",
                                validator: validate_TagsGet_594217, base: "",
                                url: url_TagsGet_594218, schemes: {Scheme.Https})
type
  Call_MarketplacesListByBillingPeriod_594225 = ref object of OpenApiRestCall_593425
proc url_MarketplacesListByBillingPeriod_594227(protocol: Scheme; host: string;
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

proc validate_MarketplacesListByBillingPeriod_594226(path: JsonNode;
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
  var valid_594228 = path.getOrDefault("subscriptionId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "subscriptionId", valid_594228
  var valid_594229 = path.getOrDefault("billingPeriodName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "billingPeriodName", valid_594229
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
  var valid_594230 = query.getOrDefault("api-version")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "api-version", valid_594230
  var valid_594231 = query.getOrDefault("$top")
  valid_594231 = validateParameter(valid_594231, JInt, required = false, default = nil)
  if valid_594231 != nil:
    section.add "$top", valid_594231
  var valid_594232 = query.getOrDefault("$skiptoken")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "$skiptoken", valid_594232
  var valid_594233 = query.getOrDefault("$filter")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "$filter", valid_594233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594234: Call_MarketplacesListByBillingPeriod_594225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594234.validator(path, query, header, formData, body)
  let scheme = call_594234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594234.url(scheme.get, call_594234.host, call_594234.base,
                         call_594234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594234, url, valid)

proc call*(call_594235: Call_MarketplacesListByBillingPeriod_594225;
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
  var path_594236 = newJObject()
  var query_594237 = newJObject()
  add(query_594237, "api-version", newJString(apiVersion))
  add(path_594236, "subscriptionId", newJString(subscriptionId))
  add(query_594237, "$top", newJInt(Top))
  add(query_594237, "$skiptoken", newJString(Skiptoken))
  add(path_594236, "billingPeriodName", newJString(billingPeriodName))
  add(query_594237, "$filter", newJString(Filter))
  result = call_594235.call(path_594236, query_594237, nil, nil, nil)

var marketplacesListByBillingPeriod* = Call_MarketplacesListByBillingPeriod_594225(
    name: "marketplacesListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByBillingPeriod_594226, base: "",
    url: url_MarketplacesListByBillingPeriod_594227, schemes: {Scheme.Https})
type
  Call_PriceSheetGetByBillingPeriod_594238 = ref object of OpenApiRestCall_593425
proc url_PriceSheetGetByBillingPeriod_594240(protocol: Scheme; host: string;
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

proc validate_PriceSheetGetByBillingPeriod_594239(path: JsonNode; query: JsonNode;
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
  var valid_594241 = path.getOrDefault("subscriptionId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "subscriptionId", valid_594241
  var valid_594242 = path.getOrDefault("billingPeriodName")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "billingPeriodName", valid_594242
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
  var valid_594243 = query.getOrDefault("$expand")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "$expand", valid_594243
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594244 = query.getOrDefault("api-version")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "api-version", valid_594244
  var valid_594245 = query.getOrDefault("$top")
  valid_594245 = validateParameter(valid_594245, JInt, required = false, default = nil)
  if valid_594245 != nil:
    section.add "$top", valid_594245
  var valid_594246 = query.getOrDefault("$skiptoken")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "$skiptoken", valid_594246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594247: Call_PriceSheetGetByBillingPeriod_594238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594247.validator(path, query, header, formData, body)
  let scheme = call_594247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594247.url(scheme.get, call_594247.host, call_594247.base,
                         call_594247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594247, url, valid)

proc call*(call_594248: Call_PriceSheetGetByBillingPeriod_594238;
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
  var path_594249 = newJObject()
  var query_594250 = newJObject()
  add(query_594250, "$expand", newJString(Expand))
  add(query_594250, "api-version", newJString(apiVersion))
  add(path_594249, "subscriptionId", newJString(subscriptionId))
  add(query_594250, "$top", newJInt(Top))
  add(query_594250, "$skiptoken", newJString(Skiptoken))
  add(path_594249, "billingPeriodName", newJString(billingPeriodName))
  result = call_594248.call(path_594249, query_594250, nil, nil, nil)

var priceSheetGetByBillingPeriod* = Call_PriceSheetGetByBillingPeriod_594238(
    name: "priceSheetGetByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGetByBillingPeriod_594239, base: "",
    url: url_PriceSheetGetByBillingPeriod_594240, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByBillingPeriod_594251 = ref object of OpenApiRestCall_593425
proc url_UsageDetailsListByBillingPeriod_594253(protocol: Scheme; host: string;
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

proc validate_UsageDetailsListByBillingPeriod_594252(path: JsonNode;
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
  var valid_594254 = path.getOrDefault("subscriptionId")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "subscriptionId", valid_594254
  var valid_594255 = path.getOrDefault("billingPeriodName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "billingPeriodName", valid_594255
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
  var valid_594256 = query.getOrDefault("$expand")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "$expand", valid_594256
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594257 = query.getOrDefault("api-version")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "api-version", valid_594257
  var valid_594258 = query.getOrDefault("$top")
  valid_594258 = validateParameter(valid_594258, JInt, required = false, default = nil)
  if valid_594258 != nil:
    section.add "$top", valid_594258
  var valid_594259 = query.getOrDefault("$skiptoken")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "$skiptoken", valid_594259
  var valid_594260 = query.getOrDefault("$apply")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "$apply", valid_594260
  var valid_594261 = query.getOrDefault("$filter")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "$filter", valid_594261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594262: Call_UsageDetailsListByBillingPeriod_594251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594262.validator(path, query, header, formData, body)
  let scheme = call_594262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594262.url(scheme.get, call_594262.host, call_594262.base,
                         call_594262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594262, url, valid)

proc call*(call_594263: Call_UsageDetailsListByBillingPeriod_594251;
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
  var path_594264 = newJObject()
  var query_594265 = newJObject()
  add(query_594265, "$expand", newJString(Expand))
  add(query_594265, "api-version", newJString(apiVersion))
  add(path_594264, "subscriptionId", newJString(subscriptionId))
  add(query_594265, "$top", newJInt(Top))
  add(query_594265, "$skiptoken", newJString(Skiptoken))
  add(path_594264, "billingPeriodName", newJString(billingPeriodName))
  add(query_594265, "$apply", newJString(Apply))
  add(query_594265, "$filter", newJString(Filter))
  result = call_594263.call(path_594264, query_594265, nil, nil, nil)

var usageDetailsListByBillingPeriod* = Call_UsageDetailsListByBillingPeriod_594251(
    name: "usageDetailsListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByBillingPeriod_594252, base: "",
    url: url_UsageDetailsListByBillingPeriod_594253, schemes: {Scheme.Https})
type
  Call_BudgetsList_594266 = ref object of OpenApiRestCall_593425
proc url_BudgetsList_594268(protocol: Scheme; host: string; base: string;
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

proc validate_BudgetsList_594267(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594269 = path.getOrDefault("subscriptionId")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "subscriptionId", valid_594269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594270 = query.getOrDefault("api-version")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "api-version", valid_594270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594271: Call_BudgetsList_594266; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594271.validator(path, query, header, formData, body)
  let scheme = call_594271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594271.url(scheme.get, call_594271.host, call_594271.base,
                         call_594271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594271, url, valid)

proc call*(call_594272: Call_BudgetsList_594266; apiVersion: string;
          subscriptionId: string): Recallable =
  ## budgetsList
  ## Lists all budgets for a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594273 = newJObject()
  var query_594274 = newJObject()
  add(query_594274, "api-version", newJString(apiVersion))
  add(path_594273, "subscriptionId", newJString(subscriptionId))
  result = call_594272.call(path_594273, query_594274, nil, nil, nil)

var budgetsList* = Call_BudgetsList_594266(name: "budgetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets",
                                        validator: validate_BudgetsList_594267,
                                        base: "", url: url_BudgetsList_594268,
                                        schemes: {Scheme.Https})
type
  Call_BudgetsCreateOrUpdate_594285 = ref object of OpenApiRestCall_593425
proc url_BudgetsCreateOrUpdate_594287(protocol: Scheme; host: string; base: string;
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

proc validate_BudgetsCreateOrUpdate_594286(path: JsonNode; query: JsonNode;
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
  var valid_594288 = path.getOrDefault("subscriptionId")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "subscriptionId", valid_594288
  var valid_594289 = path.getOrDefault("budgetName")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "budgetName", valid_594289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594290 = query.getOrDefault("api-version")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "api-version", valid_594290
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

proc call*(call_594292: Call_BudgetsCreateOrUpdate_594285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594292.validator(path, query, header, formData, body)
  let scheme = call_594292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594292.url(scheme.get, call_594292.host, call_594292.base,
                         call_594292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594292, url, valid)

proc call*(call_594293: Call_BudgetsCreateOrUpdate_594285; apiVersion: string;
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
  var path_594294 = newJObject()
  var query_594295 = newJObject()
  var body_594296 = newJObject()
  add(query_594295, "api-version", newJString(apiVersion))
  add(path_594294, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594296 = parameters
  add(path_594294, "budgetName", newJString(budgetName))
  result = call_594293.call(path_594294, query_594295, nil, nil, body_594296)

var budgetsCreateOrUpdate* = Call_BudgetsCreateOrUpdate_594285(
    name: "budgetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsCreateOrUpdate_594286, base: "",
    url: url_BudgetsCreateOrUpdate_594287, schemes: {Scheme.Https})
type
  Call_BudgetsGet_594275 = ref object of OpenApiRestCall_593425
proc url_BudgetsGet_594277(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BudgetsGet_594276(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594278 = path.getOrDefault("subscriptionId")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "subscriptionId", valid_594278
  var valid_594279 = path.getOrDefault("budgetName")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "budgetName", valid_594279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594280 = query.getOrDefault("api-version")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "api-version", valid_594280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594281: Call_BudgetsGet_594275; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594281.validator(path, query, header, formData, body)
  let scheme = call_594281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594281.url(scheme.get, call_594281.host, call_594281.base,
                         call_594281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594281, url, valid)

proc call*(call_594282: Call_BudgetsGet_594275; apiVersion: string;
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
  var path_594283 = newJObject()
  var query_594284 = newJObject()
  add(query_594284, "api-version", newJString(apiVersion))
  add(path_594283, "subscriptionId", newJString(subscriptionId))
  add(path_594283, "budgetName", newJString(budgetName))
  result = call_594282.call(path_594283, query_594284, nil, nil, nil)

var budgetsGet* = Call_BudgetsGet_594275(name: "budgetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
                                      validator: validate_BudgetsGet_594276,
                                      base: "", url: url_BudgetsGet_594277,
                                      schemes: {Scheme.Https})
type
  Call_BudgetsDelete_594297 = ref object of OpenApiRestCall_593425
proc url_BudgetsDelete_594299(protocol: Scheme; host: string; base: string;
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

proc validate_BudgetsDelete_594298(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594300 = path.getOrDefault("subscriptionId")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "subscriptionId", valid_594300
  var valid_594301 = path.getOrDefault("budgetName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "budgetName", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594302 = query.getOrDefault("api-version")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "api-version", valid_594302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594303: Call_BudgetsDelete_594297; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_BudgetsDelete_594297; apiVersion: string;
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
  var path_594305 = newJObject()
  var query_594306 = newJObject()
  add(query_594306, "api-version", newJString(apiVersion))
  add(path_594305, "subscriptionId", newJString(subscriptionId))
  add(path_594305, "budgetName", newJString(budgetName))
  result = call_594304.call(path_594305, query_594306, nil, nil, nil)

var budgetsDelete* = Call_BudgetsDelete_594297(name: "budgetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsDelete_594298, base: "", url: url_BudgetsDelete_594299,
    schemes: {Scheme.Https})
type
  Call_MarketplacesList_594307 = ref object of OpenApiRestCall_593425
proc url_MarketplacesList_594309(protocol: Scheme; host: string; base: string;
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

proc validate_MarketplacesList_594308(path: JsonNode; query: JsonNode;
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
  var valid_594310 = path.getOrDefault("subscriptionId")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "subscriptionId", valid_594310
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
  var valid_594311 = query.getOrDefault("api-version")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "api-version", valid_594311
  var valid_594312 = query.getOrDefault("$top")
  valid_594312 = validateParameter(valid_594312, JInt, required = false, default = nil)
  if valid_594312 != nil:
    section.add "$top", valid_594312
  var valid_594313 = query.getOrDefault("$skiptoken")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "$skiptoken", valid_594313
  var valid_594314 = query.getOrDefault("$filter")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "$filter", valid_594314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594315: Call_MarketplacesList_594307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by subscriptionId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594315.validator(path, query, header, formData, body)
  let scheme = call_594315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594315.url(scheme.get, call_594315.host, call_594315.base,
                         call_594315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594315, url, valid)

proc call*(call_594316: Call_MarketplacesList_594307; apiVersion: string;
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
  var path_594317 = newJObject()
  var query_594318 = newJObject()
  add(query_594318, "api-version", newJString(apiVersion))
  add(path_594317, "subscriptionId", newJString(subscriptionId))
  add(query_594318, "$top", newJInt(Top))
  add(query_594318, "$skiptoken", newJString(Skiptoken))
  add(query_594318, "$filter", newJString(Filter))
  result = call_594316.call(path_594317, query_594318, nil, nil, nil)

var marketplacesList* = Call_MarketplacesList_594307(name: "marketplacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesList_594308, base: "",
    url: url_MarketplacesList_594309, schemes: {Scheme.Https})
type
  Call_PriceSheetGet_594319 = ref object of OpenApiRestCall_593425
proc url_PriceSheetGet_594321(protocol: Scheme; host: string; base: string;
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

proc validate_PriceSheetGet_594320(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594322 = path.getOrDefault("subscriptionId")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "subscriptionId", valid_594322
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
  var valid_594323 = query.getOrDefault("$expand")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "$expand", valid_594323
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594324 = query.getOrDefault("api-version")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "api-version", valid_594324
  var valid_594325 = query.getOrDefault("$top")
  valid_594325 = validateParameter(valid_594325, JInt, required = false, default = nil)
  if valid_594325 != nil:
    section.add "$top", valid_594325
  var valid_594326 = query.getOrDefault("$skiptoken")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "$skiptoken", valid_594326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594327: Call_PriceSheetGet_594319; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594327.validator(path, query, header, formData, body)
  let scheme = call_594327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594327.url(scheme.get, call_594327.host, call_594327.base,
                         call_594327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594327, url, valid)

proc call*(call_594328: Call_PriceSheetGet_594319; apiVersion: string;
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
  var path_594329 = newJObject()
  var query_594330 = newJObject()
  add(query_594330, "$expand", newJString(Expand))
  add(query_594330, "api-version", newJString(apiVersion))
  add(path_594329, "subscriptionId", newJString(subscriptionId))
  add(query_594330, "$top", newJInt(Top))
  add(query_594330, "$skiptoken", newJString(Skiptoken))
  result = call_594328.call(path_594329, query_594330, nil, nil, nil)

var priceSheetGet* = Call_PriceSheetGet_594319(name: "priceSheetGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGet_594320, base: "", url: url_PriceSheetGet_594321,
    schemes: {Scheme.Https})
type
  Call_ReservationRecommendationsList_594331 = ref object of OpenApiRestCall_593425
proc url_ReservationRecommendationsList_594333(protocol: Scheme; host: string;
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

proc validate_ReservationRecommendationsList_594332(path: JsonNode;
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
  var valid_594334 = path.getOrDefault("subscriptionId")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "subscriptionId", valid_594334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  ##   $filter: JString
  ##          : May be used to filter reservationRecommendations by properties/scope and properties/lookBackPeriod.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594335 = query.getOrDefault("api-version")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "api-version", valid_594335
  var valid_594336 = query.getOrDefault("$filter")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "$filter", valid_594336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594337: Call_ReservationRecommendationsList_594331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of recommendations for purchasing reserved instances.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594337.validator(path, query, header, formData, body)
  let scheme = call_594337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594337.url(scheme.get, call_594337.host, call_594337.base,
                         call_594337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594337, url, valid)

proc call*(call_594338: Call_ReservationRecommendationsList_594331;
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
  var path_594339 = newJObject()
  var query_594340 = newJObject()
  add(query_594340, "api-version", newJString(apiVersion))
  add(path_594339, "subscriptionId", newJString(subscriptionId))
  add(query_594340, "$filter", newJString(Filter))
  result = call_594338.call(path_594339, query_594340, nil, nil, nil)

var reservationRecommendationsList* = Call_ReservationRecommendationsList_594331(
    name: "reservationRecommendationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/reservationRecommendations",
    validator: validate_ReservationRecommendationsList_594332, base: "",
    url: url_ReservationRecommendationsList_594333, schemes: {Scheme.Https})
type
  Call_UsageDetailsList_594341 = ref object of OpenApiRestCall_593425
proc url_UsageDetailsList_594343(protocol: Scheme; host: string; base: string;
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

proc validate_UsageDetailsList_594342(path: JsonNode; query: JsonNode;
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
  var valid_594344 = path.getOrDefault("subscriptionId")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "subscriptionId", valid_594344
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
  var valid_594345 = query.getOrDefault("$expand")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "$expand", valid_594345
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594346 = query.getOrDefault("api-version")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "api-version", valid_594346
  var valid_594347 = query.getOrDefault("$top")
  valid_594347 = validateParameter(valid_594347, JInt, required = false, default = nil)
  if valid_594347 != nil:
    section.add "$top", valid_594347
  var valid_594348 = query.getOrDefault("$skiptoken")
  valid_594348 = validateParameter(valid_594348, JString, required = false,
                                 default = nil)
  if valid_594348 != nil:
    section.add "$skiptoken", valid_594348
  var valid_594349 = query.getOrDefault("$apply")
  valid_594349 = validateParameter(valid_594349, JString, required = false,
                                 default = nil)
  if valid_594349 != nil:
    section.add "$apply", valid_594349
  var valid_594350 = query.getOrDefault("$filter")
  valid_594350 = validateParameter(valid_594350, JString, required = false,
                                 default = nil)
  if valid_594350 != nil:
    section.add "$filter", valid_594350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594351: Call_UsageDetailsList_594341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594351.validator(path, query, header, formData, body)
  let scheme = call_594351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594351.url(scheme.get, call_594351.host, call_594351.base,
                         call_594351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594351, url, valid)

proc call*(call_594352: Call_UsageDetailsList_594341; apiVersion: string;
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
  var path_594353 = newJObject()
  var query_594354 = newJObject()
  add(query_594354, "$expand", newJString(Expand))
  add(query_594354, "api-version", newJString(apiVersion))
  add(path_594353, "subscriptionId", newJString(subscriptionId))
  add(query_594354, "$top", newJInt(Top))
  add(query_594354, "$skiptoken", newJString(Skiptoken))
  add(query_594354, "$apply", newJString(Apply))
  add(query_594354, "$filter", newJString(Filter))
  result = call_594352.call(path_594353, query_594354, nil, nil, nil)

var usageDetailsList* = Call_UsageDetailsList_594341(name: "usageDetailsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsList_594342, base: "",
    url: url_UsageDetailsList_594343, schemes: {Scheme.Https})
type
  Call_BudgetsListByResourceGroupName_594355 = ref object of OpenApiRestCall_593425
proc url_BudgetsListByResourceGroupName_594357(protocol: Scheme; host: string;
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

proc validate_BudgetsListByResourceGroupName_594356(path: JsonNode;
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
  var valid_594358 = path.getOrDefault("resourceGroupName")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "resourceGroupName", valid_594358
  var valid_594359 = path.getOrDefault("subscriptionId")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "subscriptionId", valid_594359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594360 = query.getOrDefault("api-version")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "api-version", valid_594360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594361: Call_BudgetsListByResourceGroupName_594355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594361.validator(path, query, header, formData, body)
  let scheme = call_594361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594361.url(scheme.get, call_594361.host, call_594361.base,
                         call_594361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594361, url, valid)

proc call*(call_594362: Call_BudgetsListByResourceGroupName_594355;
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
  var path_594363 = newJObject()
  var query_594364 = newJObject()
  add(path_594363, "resourceGroupName", newJString(resourceGroupName))
  add(query_594364, "api-version", newJString(apiVersion))
  add(path_594363, "subscriptionId", newJString(subscriptionId))
  result = call_594362.call(path_594363, query_594364, nil, nil, nil)

var budgetsListByResourceGroupName* = Call_BudgetsListByResourceGroupName_594355(
    name: "budgetsListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets",
    validator: validate_BudgetsListByResourceGroupName_594356, base: "",
    url: url_BudgetsListByResourceGroupName_594357, schemes: {Scheme.Https})
type
  Call_BudgetsCreateOrUpdateByResourceGroupName_594376 = ref object of OpenApiRestCall_593425
proc url_BudgetsCreateOrUpdateByResourceGroupName_594378(protocol: Scheme;
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

proc validate_BudgetsCreateOrUpdateByResourceGroupName_594377(path: JsonNode;
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
  var valid_594379 = path.getOrDefault("resourceGroupName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "resourceGroupName", valid_594379
  var valid_594380 = path.getOrDefault("subscriptionId")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "subscriptionId", valid_594380
  var valid_594381 = path.getOrDefault("budgetName")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "budgetName", valid_594381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594382 = query.getOrDefault("api-version")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "api-version", valid_594382
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

proc call*(call_594384: Call_BudgetsCreateOrUpdateByResourceGroupName_594376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594384.validator(path, query, header, formData, body)
  let scheme = call_594384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594384.url(scheme.get, call_594384.host, call_594384.base,
                         call_594384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594384, url, valid)

proc call*(call_594385: Call_BudgetsCreateOrUpdateByResourceGroupName_594376;
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
  var path_594386 = newJObject()
  var query_594387 = newJObject()
  var body_594388 = newJObject()
  add(path_594386, "resourceGroupName", newJString(resourceGroupName))
  add(query_594387, "api-version", newJString(apiVersion))
  add(path_594386, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594388 = parameters
  add(path_594386, "budgetName", newJString(budgetName))
  result = call_594385.call(path_594386, query_594387, nil, nil, body_594388)

var budgetsCreateOrUpdateByResourceGroupName* = Call_BudgetsCreateOrUpdateByResourceGroupName_594376(
    name: "budgetsCreateOrUpdateByResourceGroupName", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsCreateOrUpdateByResourceGroupName_594377, base: "",
    url: url_BudgetsCreateOrUpdateByResourceGroupName_594378,
    schemes: {Scheme.Https})
type
  Call_BudgetsGetByResourceGroupName_594365 = ref object of OpenApiRestCall_593425
proc url_BudgetsGetByResourceGroupName_594367(protocol: Scheme; host: string;
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

proc validate_BudgetsGetByResourceGroupName_594366(path: JsonNode; query: JsonNode;
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
  var valid_594368 = path.getOrDefault("resourceGroupName")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "resourceGroupName", valid_594368
  var valid_594369 = path.getOrDefault("subscriptionId")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "subscriptionId", valid_594369
  var valid_594370 = path.getOrDefault("budgetName")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "budgetName", valid_594370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594371 = query.getOrDefault("api-version")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "api-version", valid_594371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594372: Call_BudgetsGetByResourceGroupName_594365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for a resource group under a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594372.validator(path, query, header, formData, body)
  let scheme = call_594372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594372.url(scheme.get, call_594372.host, call_594372.base,
                         call_594372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594372, url, valid)

proc call*(call_594373: Call_BudgetsGetByResourceGroupName_594365;
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
  var path_594374 = newJObject()
  var query_594375 = newJObject()
  add(path_594374, "resourceGroupName", newJString(resourceGroupName))
  add(query_594375, "api-version", newJString(apiVersion))
  add(path_594374, "subscriptionId", newJString(subscriptionId))
  add(path_594374, "budgetName", newJString(budgetName))
  result = call_594373.call(path_594374, query_594375, nil, nil, nil)

var budgetsGetByResourceGroupName* = Call_BudgetsGetByResourceGroupName_594365(
    name: "budgetsGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsGetByResourceGroupName_594366, base: "",
    url: url_BudgetsGetByResourceGroupName_594367, schemes: {Scheme.Https})
type
  Call_BudgetsDeleteByResourceGroupName_594389 = ref object of OpenApiRestCall_593425
proc url_BudgetsDeleteByResourceGroupName_594391(protocol: Scheme; host: string;
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

proc validate_BudgetsDeleteByResourceGroupName_594390(path: JsonNode;
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
  var valid_594392 = path.getOrDefault("resourceGroupName")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "resourceGroupName", valid_594392
  var valid_594393 = path.getOrDefault("subscriptionId")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "subscriptionId", valid_594393
  var valid_594394 = path.getOrDefault("budgetName")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = nil)
  if valid_594394 != nil:
    section.add "budgetName", valid_594394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594395 = query.getOrDefault("api-version")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "api-version", valid_594395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594396: Call_BudgetsDeleteByResourceGroupName_594389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594396.validator(path, query, header, formData, body)
  let scheme = call_594396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594396.url(scheme.get, call_594396.host, call_594396.base,
                         call_594396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594396, url, valid)

proc call*(call_594397: Call_BudgetsDeleteByResourceGroupName_594389;
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
  var path_594398 = newJObject()
  var query_594399 = newJObject()
  add(path_594398, "resourceGroupName", newJString(resourceGroupName))
  add(query_594399, "api-version", newJString(apiVersion))
  add(path_594398, "subscriptionId", newJString(subscriptionId))
  add(path_594398, "budgetName", newJString(budgetName))
  result = call_594397.call(path_594398, query_594399, nil, nil, nil)

var budgetsDeleteByResourceGroupName* = Call_BudgetsDeleteByResourceGroupName_594389(
    name: "budgetsDeleteByResourceGroupName", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsDeleteByResourceGroupName_594390, base: "",
    url: url_BudgetsDeleteByResourceGroupName_594391, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
