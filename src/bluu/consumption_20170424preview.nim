
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ConsumptionManagementClient
## version: 2017-04-24-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Consumption management client provides access to consumption resources for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
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
  Call_OperationsList_593647 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593648(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_OperationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_OperationsList_593647; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Consumption/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsList_593943 = ref object of OpenApiRestCall_593425
proc url_UsageDetailsList_593945(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsList_593944(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the usage details for a scope in reverse chronological order by billing period. Usage details are available via this API only for January 1, 2017 or later.
  ## 
  ## https://go.microsoft.com/fwlink/?linkid=845275
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the usage details. The scope can be '/subscriptions/{subscriptionId}' for a subscription, or 
  ## '/subscriptions/{subscriptionId}/providers/Microsoft.Billing/invoices/{invoiceName}' for an invoice or 
  ## '/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}' for a billing period.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_593961 = path.getOrDefault("scope")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "scope", valid_593961
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the additionalProperties or meterDetails property within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by usageEnd (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_593962 = query.getOrDefault("$expand")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "$expand", valid_593962
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  var valid_593964 = query.getOrDefault("$top")
  valid_593964 = validateParameter(valid_593964, JInt, required = false, default = nil)
  if valid_593964 != nil:
    section.add "$top", valid_593964
  var valid_593965 = query.getOrDefault("$skiptoken")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "$skiptoken", valid_593965
  var valid_593966 = query.getOrDefault("$filter")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "$filter", valid_593966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593967: Call_UsageDetailsList_593943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details for a scope in reverse chronological order by billing period. Usage details are available via this API only for January 1, 2017 or later.
  ## 
  ## https://go.microsoft.com/fwlink/?linkid=845275
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_UsageDetailsList_593943; apiVersion: string;
          scope: string; Expand: string = ""; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsList
  ## Lists the usage details for a scope in reverse chronological order by billing period. Usage details are available via this API only for January 1, 2017 or later.
  ## https://go.microsoft.com/fwlink/?linkid=845275
  ##   Expand: string
  ##         : May be used to expand the additionalProperties or meterDetails property within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   scope: string (required)
  ##        : The scope of the usage details. The scope can be '/subscriptions/{subscriptionId}' for a subscription, or 
  ## '/subscriptions/{subscriptionId}/providers/Microsoft.Billing/invoices/{invoiceName}' for an invoice or 
  ## '/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}' for a billing period.
  ##   Filter: string
  ##         : May be used to filter usageDetails by usageEnd (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_593969 = newJObject()
  var query_593970 = newJObject()
  add(query_593970, "$expand", newJString(Expand))
  add(query_593970, "api-version", newJString(apiVersion))
  add(query_593970, "$top", newJInt(Top))
  add(query_593970, "$skiptoken", newJString(Skiptoken))
  add(path_593969, "scope", newJString(scope))
  add(query_593970, "$filter", newJString(Filter))
  result = call_593968.call(path_593969, query_593970, nil, nil, nil)

var usageDetailsList* = Call_UsageDetailsList_593943(name: "usageDetailsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsList_593944, base: "",
    url: url_UsageDetailsList_593945, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
