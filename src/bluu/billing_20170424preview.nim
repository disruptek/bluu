
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BillingManagementClient
## version: 2017-04-24-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Billing client provides access to billing resources for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "billing"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593646 = ref object of OpenApiRestCall_593424
proc url_OperationsList_593648(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593647(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_OperationsList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available billing REST API operations.
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_OperationsList_593646; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available billing REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var operationsList* = Call_OperationsList_593646(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/operations",
    validator: validate_OperationsList_593647, base: "", url: url_OperationsList_593648,
    schemes: {Scheme.Https})
type
  Call_BillingPeriodsList_593942 = ref object of OpenApiRestCall_593424
proc url_BillingPeriodsList_593944(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Billing/billingPeriods")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPeriodsList_593943(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the available billing periods for a subscription in reverse chronological order.
  ## 
  ## https://go.microsoft.com/fwlink/?linkid=844490
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593960 = path.getOrDefault("subscriptionId")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "subscriptionId", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N billing periods.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter billing periods by billingPeriodEndDate. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  var valid_593962 = query.getOrDefault("$top")
  valid_593962 = validateParameter(valid_593962, JInt, required = false, default = nil)
  if valid_593962 != nil:
    section.add "$top", valid_593962
  var valid_593963 = query.getOrDefault("$skiptoken")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "$skiptoken", valid_593963
  var valid_593964 = query.getOrDefault("$filter")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "$filter", valid_593964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593965: Call_BillingPeriodsList_593942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available billing periods for a subscription in reverse chronological order.
  ## 
  ## https://go.microsoft.com/fwlink/?linkid=844490
  let valid = call_593965.validator(path, query, header, formData, body)
  let scheme = call_593965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593965.url(scheme.get, call_593965.host, call_593965.base,
                         call_593965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593965, url, valid)

proc call*(call_593966: Call_BillingPeriodsList_593942; apiVersion: string;
          subscriptionId: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## billingPeriodsList
  ## Lists the available billing periods for a subscription in reverse chronological order.
  ## https://go.microsoft.com/fwlink/?linkid=844490
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N billing periods.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter billing periods by billingPeriodEndDate. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_593967 = newJObject()
  var query_593968 = newJObject()
  add(query_593968, "api-version", newJString(apiVersion))
  add(path_593967, "subscriptionId", newJString(subscriptionId))
  add(query_593968, "$top", newJInt(Top))
  add(query_593968, "$skiptoken", newJString(Skiptoken))
  add(query_593968, "$filter", newJString(Filter))
  result = call_593966.call(path_593967, query_593968, nil, nil, nil)

var billingPeriodsList* = Call_BillingPeriodsList_593942(
    name: "billingPeriodsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods",
    validator: validate_BillingPeriodsList_593943, base: "",
    url: url_BillingPeriodsList_593944, schemes: {Scheme.Https})
type
  Call_BillingPeriodsGet_593969 = ref object of OpenApiRestCall_593424
proc url_BillingPeriodsGet_593971(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "billingPeriodName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPeriodsGet_593970(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a named billing period.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   billingPeriodName: JString (required)
  ##                    : The name of a BillingPeriod resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593972 = path.getOrDefault("subscriptionId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "subscriptionId", valid_593972
  var valid_593973 = path.getOrDefault("billingPeriodName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "billingPeriodName", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_BillingPeriodsGet_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a named billing period.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_BillingPeriodsGet_593969; apiVersion: string;
          subscriptionId: string; billingPeriodName: string): Recallable =
  ## billingPeriodsGet
  ## Gets a named billing period.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   billingPeriodName: string (required)
  ##                    : The name of a BillingPeriod resource.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  add(path_593977, "billingPeriodName", newJString(billingPeriodName))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var billingPeriodsGet* = Call_BillingPeriodsGet_593969(name: "billingPeriodsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}",
    validator: validate_BillingPeriodsGet_593970, base: "",
    url: url_BillingPeriodsGet_593971, schemes: {Scheme.Https})
type
  Call_InvoicesList_593979 = ref object of OpenApiRestCall_593424
proc url_InvoicesList_593981(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Billing/invoices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoicesList_593980(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available invoices for a subscription in reverse chronological order beginning with the most recent invoice. In preview, invoices are available via this API only for invoice periods which end December 1, 2016 or later.
  ## 
  ## https://go.microsoft.com/fwlink/?linkid=842057
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593982 = path.getOrDefault("subscriptionId")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "subscriptionId", valid_593982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  ##   $expand: JString
  ##          : May be used to expand the downloadUrl property within a list of invoices. This enables download links to be generated for multiple invoices at once. By default, downloadURLs are not included when listing invoices.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N invoices.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter invoices by invoicePeriodEndDate. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593983 = query.getOrDefault("api-version")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "api-version", valid_593983
  var valid_593984 = query.getOrDefault("$expand")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "$expand", valid_593984
  var valid_593985 = query.getOrDefault("$top")
  valid_593985 = validateParameter(valid_593985, JInt, required = false, default = nil)
  if valid_593985 != nil:
    section.add "$top", valid_593985
  var valid_593986 = query.getOrDefault("$skiptoken")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "$skiptoken", valid_593986
  var valid_593987 = query.getOrDefault("$filter")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "$filter", valid_593987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593988: Call_InvoicesList_593979; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available invoices for a subscription in reverse chronological order beginning with the most recent invoice. In preview, invoices are available via this API only for invoice periods which end December 1, 2016 or later.
  ## 
  ## https://go.microsoft.com/fwlink/?linkid=842057
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_InvoicesList_593979; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## invoicesList
  ## Lists the available invoices for a subscription in reverse chronological order beginning with the most recent invoice. In preview, invoices are available via this API only for invoice periods which end December 1, 2016 or later.
  ## https://go.microsoft.com/fwlink/?linkid=842057
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  ##   Expand: string
  ##         : May be used to expand the downloadUrl property within a list of invoices. This enables download links to be generated for multiple invoices at once. By default, downloadURLs are not included when listing invoices.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N invoices.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter invoices by invoicePeriodEndDate. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  add(query_593991, "api-version", newJString(apiVersion))
  add(query_593991, "$expand", newJString(Expand))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  add(query_593991, "$top", newJInt(Top))
  add(query_593991, "$skiptoken", newJString(Skiptoken))
  add(query_593991, "$filter", newJString(Filter))
  result = call_593989.call(path_593990, query_593991, nil, nil, nil)

var invoicesList* = Call_InvoicesList_593979(name: "invoicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/invoices",
    validator: validate_InvoicesList_593980, base: "", url: url_InvoicesList_593981,
    schemes: {Scheme.Https})
type
  Call_InvoicesGetLatest_593992 = ref object of OpenApiRestCall_593424
proc url_InvoicesGetLatest_593994(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Billing/invoices/latest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoicesGetLatest_593993(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the most recent invoice. When getting a single invoice, the downloadUrl property is expanded automatically.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593995 = path.getOrDefault("subscriptionId")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "subscriptionId", valid_593995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "api-version", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_InvoicesGetLatest_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the most recent invoice. When getting a single invoice, the downloadUrl property is expanded automatically.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_InvoicesGetLatest_593992; apiVersion: string;
          subscriptionId: string): Recallable =
  ## invoicesGetLatest
  ## Gets the most recent invoice. When getting a single invoice, the downloadUrl property is expanded automatically.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var invoicesGetLatest* = Call_InvoicesGetLatest_593992(name: "invoicesGetLatest",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/invoices/latest",
    validator: validate_InvoicesGetLatest_593993, base: "",
    url: url_InvoicesGetLatest_593994, schemes: {Scheme.Https})
type
  Call_InvoicesGet_594001 = ref object of OpenApiRestCall_593424
proc url_InvoicesGet_594003(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "invoiceName" in path, "`invoiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Billing/invoices/"),
               (kind: VariableSegment, value: "invoiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoicesGet_594002(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a named invoice resource. When getting a single invoice, the downloadUrl property is expanded automatically.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   invoiceName: JString (required)
  ##              : The name of an invoice resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594004 = path.getOrDefault("subscriptionId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "subscriptionId", valid_594004
  var valid_594005 = path.getOrDefault("invoiceName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "invoiceName", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_InvoicesGet_594001; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a named invoice resource. When getting a single invoice, the downloadUrl property is expanded automatically.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_InvoicesGet_594001; apiVersion: string;
          subscriptionId: string; invoiceName: string): Recallable =
  ## invoicesGet
  ## Gets a named invoice resource. When getting a single invoice, the downloadUrl property is expanded automatically.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-04-24-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   invoiceName: string (required)
  ##              : The name of an invoice resource.
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  add(path_594009, "invoiceName", newJString(invoiceName))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var invoicesGet* = Call_InvoicesGet_594001(name: "invoicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/invoices/{invoiceName}",
                                        validator: validate_InvoicesGet_594002,
                                        base: "", url: url_InvoicesGet_594003,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
