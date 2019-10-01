
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BillingManagementClient
## version: 2018-03-01-preview
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
  Call_EnrollmentAccountsList_574679 = ref object of OpenApiRestCall_574457
proc url_EnrollmentAccountsList_574681(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EnrollmentAccountsList_574680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the enrollment accounts the caller has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
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

proc call*(call_574863: Call_EnrollmentAccountsList_574679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the enrollment accounts the caller has access to.
  ## 
  let valid = call_574863.validator(path, query, header, formData, body)
  let scheme = call_574863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574863.url(scheme.get, call_574863.host, call_574863.base,
                         call_574863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574863, url, valid)

proc call*(call_574934: Call_EnrollmentAccountsList_574679; apiVersion: string): Recallable =
  ## enrollmentAccountsList
  ## Lists the enrollment accounts the caller has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  var query_574935 = newJObject()
  add(query_574935, "api-version", newJString(apiVersion))
  result = call_574934.call(nil, query_574935, nil, nil, nil)

var enrollmentAccountsList* = Call_EnrollmentAccountsList_574679(
    name: "enrollmentAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/enrollmentAccounts",
    validator: validate_EnrollmentAccountsList_574680, base: "",
    url: url_EnrollmentAccountsList_574681, schemes: {Scheme.Https})
type
  Call_EnrollmentAccountsGet_574975 = ref object of OpenApiRestCall_574457
proc url_EnrollmentAccountsGet_574977(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/enrollmentAccounts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnrollmentAccountsGet_574976(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a enrollment account by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Enrollment Account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574992 = path.getOrDefault("name")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = nil)
  if valid_574992 != nil:
    section.add "name", valid_574992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574993 = query.getOrDefault("api-version")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "api-version", valid_574993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574994: Call_EnrollmentAccountsGet_574975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a enrollment account by name.
  ## 
  let valid = call_574994.validator(path, query, header, formData, body)
  let scheme = call_574994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574994.url(scheme.get, call_574994.host, call_574994.base,
                         call_574994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574994, url, valid)

proc call*(call_574995: Call_EnrollmentAccountsGet_574975; apiVersion: string;
          name: string): Recallable =
  ## enrollmentAccountsGet
  ## Gets a enrollment account by name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  ##   name: string (required)
  ##       : Enrollment Account name.
  var path_574996 = newJObject()
  var query_574997 = newJObject()
  add(query_574997, "api-version", newJString(apiVersion))
  add(path_574996, "name", newJString(name))
  result = call_574995.call(path_574996, query_574997, nil, nil, nil)

var enrollmentAccountsGet* = Call_EnrollmentAccountsGet_574975(
    name: "enrollmentAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/enrollmentAccounts/{name}",
    validator: validate_EnrollmentAccountsGet_574976, base: "",
    url: url_EnrollmentAccountsGet_574977, schemes: {Scheme.Https})
type
  Call_OperationsList_574998 = ref object of OpenApiRestCall_574457
proc url_OperationsList_575000(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574999(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575001 = query.getOrDefault("api-version")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = nil)
  if valid_575001 != nil:
    section.add "api-version", valid_575001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575002: Call_OperationsList_574998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available billing REST API operations.
  ## 
  let valid = call_575002.validator(path, query, header, formData, body)
  let scheme = call_575002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575002.url(scheme.get, call_575002.host, call_575002.base,
                         call_575002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575002, url, valid)

proc call*(call_575003: Call_OperationsList_574998; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available billing REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  var query_575004 = newJObject()
  add(query_575004, "api-version", newJString(apiVersion))
  result = call_575003.call(nil, query_575004, nil, nil, nil)

var operationsList* = Call_OperationsList_574998(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/operations",
    validator: validate_OperationsList_574999, base: "", url: url_OperationsList_575000,
    schemes: {Scheme.Https})
type
  Call_BillingPeriodsList_575005 = ref object of OpenApiRestCall_574457
proc url_BillingPeriodsList_575007(protocol: Scheme; host: string; base: string;
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

proc validate_BillingPeriodsList_575006(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the available billing periods for a subscription in reverse chronological order. This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
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
  var valid_575009 = path.getOrDefault("subscriptionId")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = nil)
  if valid_575009 != nil:
    section.add "subscriptionId", valid_575009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N billing periods.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter billing periods by billingPeriodEndDate. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575010 = query.getOrDefault("api-version")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "api-version", valid_575010
  var valid_575011 = query.getOrDefault("$top")
  valid_575011 = validateParameter(valid_575011, JInt, required = false, default = nil)
  if valid_575011 != nil:
    section.add "$top", valid_575011
  var valid_575012 = query.getOrDefault("$skiptoken")
  valid_575012 = validateParameter(valid_575012, JString, required = false,
                                 default = nil)
  if valid_575012 != nil:
    section.add "$skiptoken", valid_575012
  var valid_575013 = query.getOrDefault("$filter")
  valid_575013 = validateParameter(valid_575013, JString, required = false,
                                 default = nil)
  if valid_575013 != nil:
    section.add "$filter", valid_575013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575014: Call_BillingPeriodsList_575005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available billing periods for a subscription in reverse chronological order. This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
  ## 
  ## https://go.microsoft.com/fwlink/?linkid=844490
  let valid = call_575014.validator(path, query, header, formData, body)
  let scheme = call_575014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575014.url(scheme.get, call_575014.host, call_575014.base,
                         call_575014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575014, url, valid)

proc call*(call_575015: Call_BillingPeriodsList_575005; apiVersion: string;
          subscriptionId: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## billingPeriodsList
  ## Lists the available billing periods for a subscription in reverse chronological order. This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
  ## https://go.microsoft.com/fwlink/?linkid=844490
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N billing periods.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter billing periods by billingPeriodEndDate. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_575016 = newJObject()
  var query_575017 = newJObject()
  add(query_575017, "api-version", newJString(apiVersion))
  add(path_575016, "subscriptionId", newJString(subscriptionId))
  add(query_575017, "$top", newJInt(Top))
  add(query_575017, "$skiptoken", newJString(Skiptoken))
  add(query_575017, "$filter", newJString(Filter))
  result = call_575015.call(path_575016, query_575017, nil, nil, nil)

var billingPeriodsList* = Call_BillingPeriodsList_575005(
    name: "billingPeriodsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods",
    validator: validate_BillingPeriodsList_575006, base: "",
    url: url_BillingPeriodsList_575007, schemes: {Scheme.Https})
type
  Call_BillingPeriodsGet_575018 = ref object of OpenApiRestCall_574457
proc url_BillingPeriodsGet_575020(protocol: Scheme; host: string; base: string;
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

proc validate_BillingPeriodsGet_575019(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a named billing period.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
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
  var valid_575021 = path.getOrDefault("subscriptionId")
  valid_575021 = validateParameter(valid_575021, JString, required = true,
                                 default = nil)
  if valid_575021 != nil:
    section.add "subscriptionId", valid_575021
  var valid_575022 = path.getOrDefault("billingPeriodName")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "billingPeriodName", valid_575022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575023 = query.getOrDefault("api-version")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "api-version", valid_575023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575024: Call_BillingPeriodsGet_575018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a named billing period.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
  ## 
  let valid = call_575024.validator(path, query, header, formData, body)
  let scheme = call_575024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575024.url(scheme.get, call_575024.host, call_575024.base,
                         call_575024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575024, url, valid)

proc call*(call_575025: Call_BillingPeriodsGet_575018; apiVersion: string;
          subscriptionId: string; billingPeriodName: string): Recallable =
  ## billingPeriodsGet
  ## Gets a named billing period.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   billingPeriodName: string (required)
  ##                    : The name of a BillingPeriod resource.
  var path_575026 = newJObject()
  var query_575027 = newJObject()
  add(query_575027, "api-version", newJString(apiVersion))
  add(path_575026, "subscriptionId", newJString(subscriptionId))
  add(path_575026, "billingPeriodName", newJString(billingPeriodName))
  result = call_575025.call(path_575026, query_575027, nil, nil, nil)

var billingPeriodsGet* = Call_BillingPeriodsGet_575018(name: "billingPeriodsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}",
    validator: validate_BillingPeriodsGet_575019, base: "",
    url: url_BillingPeriodsGet_575020, schemes: {Scheme.Https})
type
  Call_InvoicesList_575028 = ref object of OpenApiRestCall_574457
proc url_InvoicesList_575030(protocol: Scheme; host: string; base: string;
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

proc validate_InvoicesList_575029(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available invoices for a subscription in reverse chronological order beginning with the most recent invoice. In preview, invoices are available via this API only for invoice periods which end December 1, 2016 or later.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
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
  var valid_575031 = path.getOrDefault("subscriptionId")
  valid_575031 = validateParameter(valid_575031, JString, required = true,
                                 default = nil)
  if valid_575031 != nil:
    section.add "subscriptionId", valid_575031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
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
  var valid_575032 = query.getOrDefault("api-version")
  valid_575032 = validateParameter(valid_575032, JString, required = true,
                                 default = nil)
  if valid_575032 != nil:
    section.add "api-version", valid_575032
  var valid_575033 = query.getOrDefault("$expand")
  valid_575033 = validateParameter(valid_575033, JString, required = false,
                                 default = nil)
  if valid_575033 != nil:
    section.add "$expand", valid_575033
  var valid_575034 = query.getOrDefault("$top")
  valid_575034 = validateParameter(valid_575034, JInt, required = false, default = nil)
  if valid_575034 != nil:
    section.add "$top", valid_575034
  var valid_575035 = query.getOrDefault("$skiptoken")
  valid_575035 = validateParameter(valid_575035, JString, required = false,
                                 default = nil)
  if valid_575035 != nil:
    section.add "$skiptoken", valid_575035
  var valid_575036 = query.getOrDefault("$filter")
  valid_575036 = validateParameter(valid_575036, JString, required = false,
                                 default = nil)
  if valid_575036 != nil:
    section.add "$filter", valid_575036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575037: Call_InvoicesList_575028; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available invoices for a subscription in reverse chronological order beginning with the most recent invoice. In preview, invoices are available via this API only for invoice periods which end December 1, 2016 or later.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
  ## 
  ## https://go.microsoft.com/fwlink/?linkid=842057
  let valid = call_575037.validator(path, query, header, formData, body)
  let scheme = call_575037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575037.url(scheme.get, call_575037.host, call_575037.base,
                         call_575037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575037, url, valid)

proc call*(call_575038: Call_InvoicesList_575028; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## invoicesList
  ## Lists the available invoices for a subscription in reverse chronological order beginning with the most recent invoice. In preview, invoices are available via this API only for invoice periods which end December 1, 2016 or later.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
  ## https://go.microsoft.com/fwlink/?linkid=842057
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
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
  var path_575039 = newJObject()
  var query_575040 = newJObject()
  add(query_575040, "api-version", newJString(apiVersion))
  add(query_575040, "$expand", newJString(Expand))
  add(path_575039, "subscriptionId", newJString(subscriptionId))
  add(query_575040, "$top", newJInt(Top))
  add(query_575040, "$skiptoken", newJString(Skiptoken))
  add(query_575040, "$filter", newJString(Filter))
  result = call_575038.call(path_575039, query_575040, nil, nil, nil)

var invoicesList* = Call_InvoicesList_575028(name: "invoicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/invoices",
    validator: validate_InvoicesList_575029, base: "", url: url_InvoicesList_575030,
    schemes: {Scheme.Https})
type
  Call_InvoicesGetLatest_575041 = ref object of OpenApiRestCall_574457
proc url_InvoicesGetLatest_575043(protocol: Scheme; host: string; base: string;
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

proc validate_InvoicesGetLatest_575042(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the most recent invoice. When getting a single invoice, the downloadUrl property is expanded automatically.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575044 = path.getOrDefault("subscriptionId")
  valid_575044 = validateParameter(valid_575044, JString, required = true,
                                 default = nil)
  if valid_575044 != nil:
    section.add "subscriptionId", valid_575044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575045 = query.getOrDefault("api-version")
  valid_575045 = validateParameter(valid_575045, JString, required = true,
                                 default = nil)
  if valid_575045 != nil:
    section.add "api-version", valid_575045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575046: Call_InvoicesGetLatest_575041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the most recent invoice. When getting a single invoice, the downloadUrl property is expanded automatically.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
  ## 
  let valid = call_575046.validator(path, query, header, formData, body)
  let scheme = call_575046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575046.url(scheme.get, call_575046.host, call_575046.base,
                         call_575046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575046, url, valid)

proc call*(call_575047: Call_InvoicesGetLatest_575041; apiVersion: string;
          subscriptionId: string): Recallable =
  ## invoicesGetLatest
  ## Gets the most recent invoice. When getting a single invoice, the downloadUrl property is expanded automatically.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575048 = newJObject()
  var query_575049 = newJObject()
  add(query_575049, "api-version", newJString(apiVersion))
  add(path_575048, "subscriptionId", newJString(subscriptionId))
  result = call_575047.call(path_575048, query_575049, nil, nil, nil)

var invoicesGetLatest* = Call_InvoicesGetLatest_575041(name: "invoicesGetLatest",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/invoices/latest",
    validator: validate_InvoicesGetLatest_575042, base: "",
    url: url_InvoicesGetLatest_575043, schemes: {Scheme.Https})
type
  Call_InvoicesGet_575050 = ref object of OpenApiRestCall_574457
proc url_InvoicesGet_575052(protocol: Scheme; host: string; base: string;
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

proc validate_InvoicesGet_575051(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a named invoice resource. When getting a single invoice, the downloadUrl property is expanded automatically.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
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
  var valid_575053 = path.getOrDefault("subscriptionId")
  valid_575053 = validateParameter(valid_575053, JString, required = true,
                                 default = nil)
  if valid_575053 != nil:
    section.add "subscriptionId", valid_575053
  var valid_575054 = path.getOrDefault("invoiceName")
  valid_575054 = validateParameter(valid_575054, JString, required = true,
                                 default = nil)
  if valid_575054 != nil:
    section.add "invoiceName", valid_575054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575055 = query.getOrDefault("api-version")
  valid_575055 = validateParameter(valid_575055, JString, required = true,
                                 default = nil)
  if valid_575055 != nil:
    section.add "api-version", valid_575055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575056: Call_InvoicesGet_575050; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a named invoice resource. When getting a single invoice, the downloadUrl property is expanded automatically.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
  ## 
  let valid = call_575056.validator(path, query, header, formData, body)
  let scheme = call_575056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575056.url(scheme.get, call_575056.host, call_575056.base,
                         call_575056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575056, url, valid)

proc call*(call_575057: Call_InvoicesGet_575050; apiVersion: string;
          subscriptionId: string; invoiceName: string): Recallable =
  ## invoicesGet
  ## Gets a named invoice resource. When getting a single invoice, the downloadUrl property is expanded automatically.  This is only supported for Azure Web-Direct subscriptions. Other subscription types which were not purchased directly through the Azure web portal are not supported through this preview API.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-03-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   invoiceName: string (required)
  ##              : The name of an invoice resource.
  var path_575058 = newJObject()
  var query_575059 = newJObject()
  add(query_575059, "api-version", newJString(apiVersion))
  add(path_575058, "subscriptionId", newJString(subscriptionId))
  add(path_575058, "invoiceName", newJString(invoiceName))
  result = call_575057.call(path_575058, query_575059, nil, nil, nil)

var invoicesGet* = Call_InvoicesGet_575050(name: "invoicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/invoices/{invoiceName}",
                                        validator: validate_InvoicesGet_575051,
                                        base: "", url: url_InvoicesGet_575052,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
