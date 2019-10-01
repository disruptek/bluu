
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BillingClient
## version: 2017-02-27-preview
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

  OpenApiRestCall_574457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574457): Option[Scheme] {.used.} =
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
  Call_OperationsList_574679 = ref object of OpenApiRestCall_574457
proc url_OperationsList_574681(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574680(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574840 = query.getOrDefault("api-version")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = nil)
  if valid_574840 != nil:
    section.add "api-version", valid_574840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574863: Call_OperationsList_574679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available billing REST API operations.
  ## 
  let valid = call_574863.validator(path, query, header, formData, body)
  let scheme = call_574863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574863.url(scheme.get, call_574863.host, call_574863.base,
                         call_574863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574863, url, valid)

proc call*(call_574934: Call_OperationsList_574679; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available billing REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  var query_574935 = newJObject()
  add(query_574935, "api-version", newJString(apiVersion))
  result = call_574934.call(nil, query_574935, nil, nil, nil)

var operationsList* = Call_OperationsList_574679(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/operations",
    validator: validate_OperationsList_574680, base: "", url: url_OperationsList_574681,
    schemes: {Scheme.Https})
type
  Call_InvoicesList_574975 = ref object of OpenApiRestCall_574457
proc url_InvoicesList_574977(protocol: Scheme; host: string; base: string;
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

proc validate_InvoicesList_574976(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available invoices for a subscription in reverse chronological order beginning with the most recent invoice. In preview, invoices are available via this API only for invoice periods which end December 1, 2016 or later
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
  var valid_574993 = path.getOrDefault("subscriptionId")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "subscriptionId", valid_574993
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the downloadUrl property within a list of invoices. This enables download links to be generated for multiple invoices at once. By default, downloadURLs are not included when listing invoices.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N invoices.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter invoices by invoicePeriodEndDate. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'
  section = newJObject()
  var valid_574994 = query.getOrDefault("$expand")
  valid_574994 = validateParameter(valid_574994, JString, required = false,
                                 default = nil)
  if valid_574994 != nil:
    section.add "$expand", valid_574994
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574995 = query.getOrDefault("api-version")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "api-version", valid_574995
  var valid_574996 = query.getOrDefault("$top")
  valid_574996 = validateParameter(valid_574996, JInt, required = false, default = nil)
  if valid_574996 != nil:
    section.add "$top", valid_574996
  var valid_574997 = query.getOrDefault("$skiptoken")
  valid_574997 = validateParameter(valid_574997, JString, required = false,
                                 default = nil)
  if valid_574997 != nil:
    section.add "$skiptoken", valid_574997
  var valid_574998 = query.getOrDefault("$filter")
  valid_574998 = validateParameter(valid_574998, JString, required = false,
                                 default = nil)
  if valid_574998 != nil:
    section.add "$filter", valid_574998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574999: Call_InvoicesList_574975; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available invoices for a subscription in reverse chronological order beginning with the most recent invoice. In preview, invoices are available via this API only for invoice periods which end December 1, 2016 or later
  ## 
  ## https://go.microsoft.com/fwlink/?linkid=842057
  let valid = call_574999.validator(path, query, header, formData, body)
  let scheme = call_574999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574999.url(scheme.get, call_574999.host, call_574999.base,
                         call_574999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574999, url, valid)

proc call*(call_575000: Call_InvoicesList_574975; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## invoicesList
  ## Lists the available invoices for a subscription in reverse chronological order beginning with the most recent invoice. In preview, invoices are available via this API only for invoice periods which end December 1, 2016 or later
  ## https://go.microsoft.com/fwlink/?linkid=842057
  ##   Expand: string
  ##         : May be used to expand the downloadUrl property within a list of invoices. This enables download links to be generated for multiple invoices at once. By default, downloadURLs are not included when listing invoices.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N invoices.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter invoices by invoicePeriodEndDate. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'
  var path_575001 = newJObject()
  var query_575002 = newJObject()
  add(query_575002, "$expand", newJString(Expand))
  add(query_575002, "api-version", newJString(apiVersion))
  add(path_575001, "subscriptionId", newJString(subscriptionId))
  add(query_575002, "$top", newJInt(Top))
  add(query_575002, "$skiptoken", newJString(Skiptoken))
  add(query_575002, "$filter", newJString(Filter))
  result = call_575000.call(path_575001, query_575002, nil, nil, nil)

var invoicesList* = Call_InvoicesList_574975(name: "invoicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/invoices",
    validator: validate_InvoicesList_574976, base: "", url: url_InvoicesList_574977,
    schemes: {Scheme.Https})
type
  Call_InvoicesGetLatest_575003 = ref object of OpenApiRestCall_574457
proc url_InvoicesGetLatest_575005(protocol: Scheme; host: string; base: string;
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

proc validate_InvoicesGetLatest_575004(path: JsonNode; query: JsonNode;
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
  var valid_575006 = path.getOrDefault("subscriptionId")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "subscriptionId", valid_575006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575007 = query.getOrDefault("api-version")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "api-version", valid_575007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575008: Call_InvoicesGetLatest_575003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the most recent invoice. When getting a single invoice, the downloadUrl property is expanded automatically.
  ## 
  let valid = call_575008.validator(path, query, header, formData, body)
  let scheme = call_575008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575008.url(scheme.get, call_575008.host, call_575008.base,
                         call_575008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575008, url, valid)

proc call*(call_575009: Call_InvoicesGetLatest_575003; apiVersion: string;
          subscriptionId: string): Recallable =
  ## invoicesGetLatest
  ## Gets the most recent invoice. When getting a single invoice, the downloadUrl property is expanded automatically.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575010 = newJObject()
  var query_575011 = newJObject()
  add(query_575011, "api-version", newJString(apiVersion))
  add(path_575010, "subscriptionId", newJString(subscriptionId))
  result = call_575009.call(path_575010, query_575011, nil, nil, nil)

var invoicesGetLatest* = Call_InvoicesGetLatest_575003(name: "invoicesGetLatest",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/invoices/latest",
    validator: validate_InvoicesGetLatest_575004, base: "",
    url: url_InvoicesGetLatest_575005, schemes: {Scheme.Https})
type
  Call_InvoicesGet_575012 = ref object of OpenApiRestCall_574457
proc url_InvoicesGet_575014(protocol: Scheme; host: string; base: string;
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

proc validate_InvoicesGet_575013(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575015 = path.getOrDefault("subscriptionId")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = nil)
  if valid_575015 != nil:
    section.add "subscriptionId", valid_575015
  var valid_575016 = path.getOrDefault("invoiceName")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = nil)
  if valid_575016 != nil:
    section.add "invoiceName", valid_575016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575017 = query.getOrDefault("api-version")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "api-version", valid_575017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575018: Call_InvoicesGet_575012; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a named invoice resource. When getting a single invoice, the downloadUrl property is expanded automatically.
  ## 
  let valid = call_575018.validator(path, query, header, formData, body)
  let scheme = call_575018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575018.url(scheme.get, call_575018.host, call_575018.base,
                         call_575018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575018, url, valid)

proc call*(call_575019: Call_InvoicesGet_575012; apiVersion: string;
          subscriptionId: string; invoiceName: string): Recallable =
  ## invoicesGet
  ## Gets a named invoice resource. When getting a single invoice, the downloadUrl property is expanded automatically.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-02-27-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   invoiceName: string (required)
  ##              : The name of an invoice resource.
  var path_575020 = newJObject()
  var query_575021 = newJObject()
  add(query_575021, "api-version", newJString(apiVersion))
  add(path_575020, "subscriptionId", newJString(subscriptionId))
  add(path_575020, "invoiceName", newJString(invoiceName))
  result = call_575019.call(path_575020, query_575021, nil, nil, nil)

var invoicesGet* = Call_InvoicesGet_575012(name: "invoicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/invoices/{invoiceName}",
                                        validator: validate_InvoicesGet_575013,
                                        base: "", url: url_InvoicesGet_575014,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
