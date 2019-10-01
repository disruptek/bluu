
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CostManagementClient
## version: 2019-03-01-preview
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

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
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
  Call_ForecastUsageByDepartment_567890 = ref object of OpenApiRestCall_567668
proc url_ForecastUsageByDepartment_567892(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/Forecast")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ForecastUsageByDepartment_567891(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Forecast the usage data for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568082 = path.getOrDefault("billingAccountId")
  valid_568082 = validateParameter(valid_568082, JString, required = true,
                                 default = nil)
  if valid_568082 != nil:
    section.add "billingAccountId", valid_568082
  var valid_568083 = path.getOrDefault("departmentId")
  valid_568083 = validateParameter(valid_568083, JString, required = true,
                                 default = nil)
  if valid_568083 != nil:
    section.add "departmentId", valid_568083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568084 = query.getOrDefault("api-version")
  valid_568084 = validateParameter(valid_568084, JString, required = true,
                                 default = nil)
  if valid_568084 != nil:
    section.add "api-version", valid_568084
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

proc call*(call_568108: Call_ForecastUsageByDepartment_567890; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568108.validator(path, query, header, formData, body)
  let scheme = call_568108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568108.url(scheme.get, call_568108.host, call_568108.base,
                         call_568108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568108, url, valid)

proc call*(call_568179: Call_ForecastUsageByDepartment_567890; apiVersion: string;
          billingAccountId: string; parameters: JsonNode; departmentId: string): Recallable =
  ## forecastUsageByDepartment
  ## Forecast the usage data for department.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  ##   departmentId: string (required)
  ##               : Department ID
  var path_568180 = newJObject()
  var query_568182 = newJObject()
  var body_568183 = newJObject()
  add(query_568182, "api-version", newJString(apiVersion))
  add(path_568180, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568183 = parameters
  add(path_568180, "departmentId", newJString(departmentId))
  result = call_568179.call(path_568180, query_568182, nil, nil, body_568183)

var forecastUsageByDepartment* = Call_ForecastUsageByDepartment_567890(
    name: "forecastUsageByDepartment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByDepartment_567891, base: "",
    url: url_ForecastUsageByDepartment_567892, schemes: {Scheme.Https})
type
  Call_QueryUsageByDepartment_568222 = ref object of OpenApiRestCall_567668
proc url_QueryUsageByDepartment_568224(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/Query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryUsageByDepartment_568223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query the usage data for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568225 = path.getOrDefault("billingAccountId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "billingAccountId", valid_568225
  var valid_568226 = path.getOrDefault("departmentId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "departmentId", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "api-version", valid_568227
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

proc call*(call_568229: Call_QueryUsageByDepartment_568222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_QueryUsageByDepartment_568222; apiVersion: string;
          billingAccountId: string; parameters: JsonNode; departmentId: string): Recallable =
  ## queryUsageByDepartment
  ## Query the usage data for department.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  ##   departmentId: string (required)
  ##               : Department ID
  var path_568231 = newJObject()
  var query_568232 = newJObject()
  var body_568233 = newJObject()
  add(query_568232, "api-version", newJString(apiVersion))
  add(path_568231, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568233 = parameters
  add(path_568231, "departmentId", newJString(departmentId))
  result = call_568230.call(path_568231, query_568232, nil, nil, body_568233)

var queryUsageByDepartment* = Call_QueryUsageByDepartment_568222(
    name: "queryUsageByDepartment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByDepartment_568223, base: "",
    url: url_QueryUsageByDepartment_568224, schemes: {Scheme.Https})
type
  Call_DimensionsListByDepartment_568234 = ref object of OpenApiRestCall_567668
proc url_DimensionsListByDepartment_568236(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/dimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DimensionsListByDepartment_568235(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the dimensions by Department Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568238 = path.getOrDefault("billingAccountId")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "billingAccountId", valid_568238
  var valid_568239 = path.getOrDefault("departmentId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "departmentId", valid_568239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  var valid_568240 = query.getOrDefault("api-version")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "api-version", valid_568240
  var valid_568241 = query.getOrDefault("$expand")
  valid_568241 = validateParameter(valid_568241, JString, required = false,
                                 default = nil)
  if valid_568241 != nil:
    section.add "$expand", valid_568241
  var valid_568242 = query.getOrDefault("$top")
  valid_568242 = validateParameter(valid_568242, JInt, required = false, default = nil)
  if valid_568242 != nil:
    section.add "$top", valid_568242
  var valid_568243 = query.getOrDefault("$skiptoken")
  valid_568243 = validateParameter(valid_568243, JString, required = false,
                                 default = nil)
  if valid_568243 != nil:
    section.add "$skiptoken", valid_568243
  var valid_568244 = query.getOrDefault("$filter")
  valid_568244 = validateParameter(valid_568244, JString, required = false,
                                 default = nil)
  if valid_568244 != nil:
    section.add "$filter", valid_568244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_DimensionsListByDepartment_568234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by Department Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_DimensionsListByDepartment_568234; apiVersion: string;
          billingAccountId: string; departmentId: string; Expand: string = "";
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListByDepartment
  ## Lists the dimensions by Department Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  add(query_568248, "api-version", newJString(apiVersion))
  add(query_568248, "$expand", newJString(Expand))
  add(query_568248, "$top", newJInt(Top))
  add(query_568248, "$skiptoken", newJString(Skiptoken))
  add(path_568247, "billingAccountId", newJString(billingAccountId))
  add(path_568247, "departmentId", newJString(departmentId))
  add(query_568248, "$filter", newJString(Filter))
  result = call_568246.call(path_568247, query_568248, nil, nil, nil)

var dimensionsListByDepartment* = Call_DimensionsListByDepartment_568234(
    name: "dimensionsListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByDepartment_568235, base: "",
    url: url_DimensionsListByDepartment_568236, schemes: {Scheme.Https})
type
  Call_ForecastUsageByEnrollmentAccount_568249 = ref object of OpenApiRestCall_567668
proc url_ForecastUsageByEnrollmentAccount_568251(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/Forecast")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ForecastUsageByEnrollmentAccount_568250(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Forecast the usage data for an enrollment account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : Enrollment Account ID
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_568252 = path.getOrDefault("enrollmentAccountId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "enrollmentAccountId", valid_568252
  var valid_568253 = path.getOrDefault("billingAccountId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "billingAccountId", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
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

proc call*(call_568256: Call_ForecastUsageByEnrollmentAccount_568249;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Forecast the usage data for an enrollment account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_ForecastUsageByEnrollmentAccount_568249;
          apiVersion: string; enrollmentAccountId: string; billingAccountId: string;
          parameters: JsonNode): Recallable =
  ## forecastUsageByEnrollmentAccount
  ## Forecast the usage data for an enrollment account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   enrollmentAccountId: string (required)
  ##                      : Enrollment Account ID
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  var body_568260 = newJObject()
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568258, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568260 = parameters
  result = call_568257.call(path_568258, query_568259, nil, nil, body_568260)

var forecastUsageByEnrollmentAccount* = Call_ForecastUsageByEnrollmentAccount_568249(
    name: "forecastUsageByEnrollmentAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByEnrollmentAccount_568250, base: "",
    url: url_ForecastUsageByEnrollmentAccount_568251, schemes: {Scheme.Https})
type
  Call_QueryUsageByEnrollmentAccount_568261 = ref object of OpenApiRestCall_567668
proc url_QueryUsageByEnrollmentAccount_568263(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/Query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryUsageByEnrollmentAccount_568262(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query the usage data for an enrollment account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : Enrollment Account ID
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_568264 = path.getOrDefault("enrollmentAccountId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "enrollmentAccountId", valid_568264
  var valid_568265 = path.getOrDefault("billingAccountId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "billingAccountId", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
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

proc call*(call_568268: Call_QueryUsageByEnrollmentAccount_568261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for an enrollment account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_QueryUsageByEnrollmentAccount_568261;
          apiVersion: string; enrollmentAccountId: string; billingAccountId: string;
          parameters: JsonNode): Recallable =
  ## queryUsageByEnrollmentAccount
  ## Query the usage data for an enrollment account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   enrollmentAccountId: string (required)
  ##                      : Enrollment Account ID
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  var body_568272 = newJObject()
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568270, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568272 = parameters
  result = call_568269.call(path_568270, query_568271, nil, nil, body_568272)

var queryUsageByEnrollmentAccount* = Call_QueryUsageByEnrollmentAccount_568261(
    name: "queryUsageByEnrollmentAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByEnrollmentAccount_568262, base: "",
    url: url_QueryUsageByEnrollmentAccount_568263, schemes: {Scheme.Https})
type
  Call_DimensionsListByEnrollmentAccount_568273 = ref object of OpenApiRestCall_567668
proc url_DimensionsListByEnrollmentAccount_568275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/dimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DimensionsListByEnrollmentAccount_568274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the dimensions by Enrollment Account Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : Enrollment Account ID
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_568276 = path.getOrDefault("enrollmentAccountId")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "enrollmentAccountId", valid_568276
  var valid_568277 = path.getOrDefault("billingAccountId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "billingAccountId", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  var valid_568279 = query.getOrDefault("$expand")
  valid_568279 = validateParameter(valid_568279, JString, required = false,
                                 default = nil)
  if valid_568279 != nil:
    section.add "$expand", valid_568279
  var valid_568280 = query.getOrDefault("$top")
  valid_568280 = validateParameter(valid_568280, JInt, required = false, default = nil)
  if valid_568280 != nil:
    section.add "$top", valid_568280
  var valid_568281 = query.getOrDefault("$skiptoken")
  valid_568281 = validateParameter(valid_568281, JString, required = false,
                                 default = nil)
  if valid_568281 != nil:
    section.add "$skiptoken", valid_568281
  var valid_568282 = query.getOrDefault("$filter")
  valid_568282 = validateParameter(valid_568282, JString, required = false,
                                 default = nil)
  if valid_568282 != nil:
    section.add "$filter", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_DimensionsListByEnrollmentAccount_568273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the dimensions by Enrollment Account Id.
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

proc call*(call_568284: Call_DimensionsListByEnrollmentAccount_568273;
          apiVersion: string; enrollmentAccountId: string; billingAccountId: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListByEnrollmentAccount
  ## Lists the dimensions by Enrollment Account Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : Enrollment Account ID
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  add(query_568286, "api-version", newJString(apiVersion))
  add(query_568286, "$expand", newJString(Expand))
  add(query_568286, "$top", newJInt(Top))
  add(query_568286, "$skiptoken", newJString(Skiptoken))
  add(path_568285, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568285, "billingAccountId", newJString(billingAccountId))
  add(query_568286, "$filter", newJString(Filter))
  result = call_568284.call(path_568285, query_568286, nil, nil, nil)

var dimensionsListByEnrollmentAccount* = Call_DimensionsListByEnrollmentAccount_568273(
    name: "dimensionsListByEnrollmentAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByEnrollmentAccount_568274, base: "",
    url: url_DimensionsListByEnrollmentAccount_568275, schemes: {Scheme.Https})
type
  Call_ForecastUsageByBillingAccount_568287 = ref object of OpenApiRestCall_567668
proc url_ForecastUsageByBillingAccount_568289(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CostManagement/Forecast")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ForecastUsageByBillingAccount_568288(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Forecast the usage data for billing account.
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
  var valid_568290 = path.getOrDefault("billingAccountId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "billingAccountId", valid_568290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568291 = query.getOrDefault("api-version")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "api-version", valid_568291
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

proc call*(call_568293: Call_ForecastUsageByBillingAccount_568287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_ForecastUsageByBillingAccount_568287;
          apiVersion: string; billingAccountId: string; parameters: JsonNode): Recallable =
  ## forecastUsageByBillingAccount
  ## Forecast the usage data for billing account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568295 = newJObject()
  var query_568296 = newJObject()
  var body_568297 = newJObject()
  add(query_568296, "api-version", newJString(apiVersion))
  add(path_568295, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568297 = parameters
  result = call_568294.call(path_568295, query_568296, nil, nil, body_568297)

var forecastUsageByBillingAccount* = Call_ForecastUsageByBillingAccount_568287(
    name: "forecastUsageByBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByBillingAccount_568288, base: "",
    url: url_ForecastUsageByBillingAccount_568289, schemes: {Scheme.Https})
type
  Call_QueryUsageByBillingAccount_568298 = ref object of OpenApiRestCall_567668
proc url_QueryUsageByBillingAccount_568300(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/Query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryUsageByBillingAccount_568299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query the usage data for billing account.
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
  var valid_568301 = path.getOrDefault("billingAccountId")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "billingAccountId", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "api-version", valid_568302
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

proc call*(call_568304: Call_QueryUsageByBillingAccount_568298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568304.validator(path, query, header, formData, body)
  let scheme = call_568304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568304.url(scheme.get, call_568304.host, call_568304.base,
                         call_568304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568304, url, valid)

proc call*(call_568305: Call_QueryUsageByBillingAccount_568298; apiVersion: string;
          billingAccountId: string; parameters: JsonNode): Recallable =
  ## queryUsageByBillingAccount
  ## Query the usage data for billing account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568306 = newJObject()
  var query_568307 = newJObject()
  var body_568308 = newJObject()
  add(query_568307, "api-version", newJString(apiVersion))
  add(path_568306, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568308 = parameters
  result = call_568305.call(path_568306, query_568307, nil, nil, body_568308)

var queryUsageByBillingAccount* = Call_QueryUsageByBillingAccount_568298(
    name: "queryUsageByBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByBillingAccount_568299, base: "",
    url: url_QueryUsageByBillingAccount_568300, schemes: {Scheme.Https})
type
  Call_DimensionsListByBillingAccount_568309 = ref object of OpenApiRestCall_567668
proc url_DimensionsListByBillingAccount_568311(protocol: Scheme; host: string;
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

proc validate_DimensionsListByBillingAccount_568310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568312 = path.getOrDefault("billingAccountId")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "billingAccountId", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
  var valid_568314 = query.getOrDefault("$expand")
  valid_568314 = validateParameter(valid_568314, JString, required = false,
                                 default = nil)
  if valid_568314 != nil:
    section.add "$expand", valid_568314
  var valid_568315 = query.getOrDefault("$top")
  valid_568315 = validateParameter(valid_568315, JInt, required = false, default = nil)
  if valid_568315 != nil:
    section.add "$top", valid_568315
  var valid_568316 = query.getOrDefault("$skiptoken")
  valid_568316 = validateParameter(valid_568316, JString, required = false,
                                 default = nil)
  if valid_568316 != nil:
    section.add "$skiptoken", valid_568316
  var valid_568317 = query.getOrDefault("$filter")
  valid_568317 = validateParameter(valid_568317, JString, required = false,
                                 default = nil)
  if valid_568317 != nil:
    section.add "$filter", valid_568317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568318: Call_DimensionsListByBillingAccount_568309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by billingAccount Id.
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

proc call*(call_568319: Call_DimensionsListByBillingAccount_568309;
          apiVersion: string; billingAccountId: string; Expand: string = "";
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListByBillingAccount
  ## Lists the dimensions by billingAccount Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  add(query_568321, "api-version", newJString(apiVersion))
  add(query_568321, "$expand", newJString(Expand))
  add(query_568321, "$top", newJInt(Top))
  add(query_568321, "$skiptoken", newJString(Skiptoken))
  add(path_568320, "billingAccountId", newJString(billingAccountId))
  add(query_568321, "$filter", newJString(Filter))
  result = call_568319.call(path_568320, query_568321, nil, nil, nil)

var dimensionsListByBillingAccount* = Call_DimensionsListByBillingAccount_568309(
    name: "dimensionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByBillingAccount_568310, base: "",
    url: url_DimensionsListByBillingAccount_568311, schemes: {Scheme.Https})
type
  Call_ShowbackRulesList_568322 = ref object of OpenApiRestCall_567668
proc url_ShowbackRulesList_568324(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/showbackRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShowbackRulesList_568323(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get list all Showback Rules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568325 = path.getOrDefault("billingAccountId")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "billingAccountId", valid_568325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568326 = query.getOrDefault("api-version")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "api-version", valid_568326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_ShowbackRulesList_568322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get list all Showback Rules.
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_ShowbackRulesList_568322; apiVersion: string;
          billingAccountId: string): Recallable =
  ## showbackRulesList
  ## Get list all Showback Rules.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "billingAccountId", newJString(billingAccountId))
  result = call_568328.call(path_568329, query_568330, nil, nil, nil)

var showbackRulesList* = Call_ShowbackRulesList_568322(name: "showbackRulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/showbackRules",
    validator: validate_ShowbackRulesList_568323, base: "",
    url: url_ShowbackRulesList_568324, schemes: {Scheme.Https})
type
  Call_ShowbackRuleCreateUpdateRule_568341 = ref object of OpenApiRestCall_567668
proc url_ShowbackRuleCreateUpdateRule_568343(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/showbackRules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShowbackRuleCreateUpdateRule_568342(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create/Update showback rule for billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleName: JString (required)
  ##           : Showback rule name
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleName` field"
  var valid_568344 = path.getOrDefault("ruleName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "ruleName", valid_568344
  var valid_568345 = path.getOrDefault("billingAccountId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "billingAccountId", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   showbackRule: JObject (required)
  ##               : Showback rule to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568348: Call_ShowbackRuleCreateUpdateRule_568341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create/Update showback rule for billing account.
  ## 
  let valid = call_568348.validator(path, query, header, formData, body)
  let scheme = call_568348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568348.url(scheme.get, call_568348.host, call_568348.base,
                         call_568348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568348, url, valid)

proc call*(call_568349: Call_ShowbackRuleCreateUpdateRule_568341;
          showbackRule: JsonNode; apiVersion: string; ruleName: string;
          billingAccountId: string): Recallable =
  ## showbackRuleCreateUpdateRule
  ## Create/Update showback rule for billing account.
  ##   showbackRule: JObject (required)
  ##               : Showback rule to create or update.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   ruleName: string (required)
  ##           : Showback rule name
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568350 = newJObject()
  var query_568351 = newJObject()
  var body_568352 = newJObject()
  if showbackRule != nil:
    body_568352 = showbackRule
  add(query_568351, "api-version", newJString(apiVersion))
  add(path_568350, "ruleName", newJString(ruleName))
  add(path_568350, "billingAccountId", newJString(billingAccountId))
  result = call_568349.call(path_568350, query_568351, nil, nil, body_568352)

var showbackRuleCreateUpdateRule* = Call_ShowbackRuleCreateUpdateRule_568341(
    name: "showbackRuleCreateUpdateRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/showbackRules/{ruleName}",
    validator: validate_ShowbackRuleCreateUpdateRule_568342, base: "",
    url: url_ShowbackRuleCreateUpdateRule_568343, schemes: {Scheme.Https})
type
  Call_ShowbackRuleGetBillingAccountId_568331 = ref object of OpenApiRestCall_567668
proc url_ShowbackRuleGetBillingAccountId_568333(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/showbackRules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ShowbackRuleGetBillingAccountId_568332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the showback rule by rule name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleName: JString (required)
  ##           : Showback rule name
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleName` field"
  var valid_568334 = path.getOrDefault("ruleName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "ruleName", valid_568334
  var valid_568335 = path.getOrDefault("billingAccountId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "billingAccountId", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_ShowbackRuleGetBillingAccountId_568331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the showback rule by rule name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_ShowbackRuleGetBillingAccountId_568331;
          apiVersion: string; ruleName: string; billingAccountId: string): Recallable =
  ## showbackRuleGetBillingAccountId
  ## Gets the showback rule by rule name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   ruleName: string (required)
  ##           : Showback rule name
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "ruleName", newJString(ruleName))
  add(path_568339, "billingAccountId", newJString(billingAccountId))
  result = call_568338.call(path_568339, query_568340, nil, nil, nil)

var showbackRuleGetBillingAccountId* = Call_ShowbackRuleGetBillingAccountId_568331(
    name: "showbackRuleGetBillingAccountId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/showbackRules/{ruleName}",
    validator: validate_ShowbackRuleGetBillingAccountId_568332, base: "",
    url: url_ShowbackRuleGetBillingAccountId_568333, schemes: {Scheme.Https})
type
  Call_CloudConnectorList_568353 = ref object of OpenApiRestCall_567668
proc url_CloudConnectorList_568355(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudConnectorList_568354(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List all cloud connector definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568357: Call_CloudConnectorList_568353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all cloud connector definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568357.validator(path, query, header, formData, body)
  let scheme = call_568357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568357.url(scheme.get, call_568357.host, call_568357.base,
                         call_568357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568357, url, valid)

proc call*(call_568358: Call_CloudConnectorList_568353; apiVersion: string): Recallable =
  ## cloudConnectorList
  ## List all cloud connector definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_568359 = newJObject()
  add(query_568359, "api-version", newJString(apiVersion))
  result = call_568358.call(nil, query_568359, nil, nil, nil)

var cloudConnectorList* = Call_CloudConnectorList_568353(
    name: "cloudConnectorList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/cloudConnectors",
    validator: validate_CloudConnectorList_568354, base: "",
    url: url_CloudConnectorList_568355, schemes: {Scheme.Https})
type
  Call_CloudConnectorCreateOrUpdate_568370 = ref object of OpenApiRestCall_567668
proc url_CloudConnectorCreateOrUpdate_568372(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.CostManagement/cloudConnectors/"),
               (kind: VariableSegment, value: "connectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudConnectorCreateOrUpdate_568371(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   connectorName: JString (required)
  ##                : Connector Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `connectorName` field"
  var valid_568373 = path.getOrDefault("connectorName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "connectorName", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "api-version", valid_568374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   connector: JObject (required)
  ##            : Connector details
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568376: Call_CloudConnectorCreateOrUpdate_568370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568376.validator(path, query, header, formData, body)
  let scheme = call_568376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568376.url(scheme.get, call_568376.host, call_568376.base,
                         call_568376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568376, url, valid)

proc call*(call_568377: Call_CloudConnectorCreateOrUpdate_568370;
          apiVersion: string; connector: JsonNode; connectorName: string): Recallable =
  ## cloudConnectorCreateOrUpdate
  ## Create or update a cloud connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   connector: JObject (required)
  ##            : Connector details
  ##   connectorName: string (required)
  ##                : Connector Name.
  var path_568378 = newJObject()
  var query_568379 = newJObject()
  var body_568380 = newJObject()
  add(query_568379, "api-version", newJString(apiVersion))
  if connector != nil:
    body_568380 = connector
  add(path_568378, "connectorName", newJString(connectorName))
  result = call_568377.call(path_568378, query_568379, nil, nil, body_568380)

var cloudConnectorCreateOrUpdate* = Call_CloudConnectorCreateOrUpdate_568370(
    name: "cloudConnectorCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorCreateOrUpdate_568371, base: "",
    url: url_CloudConnectorCreateOrUpdate_568372, schemes: {Scheme.Https})
type
  Call_CloudConnectorGet_568360 = ref object of OpenApiRestCall_567668
proc url_CloudConnectorGet_568362(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.CostManagement/cloudConnectors/"),
               (kind: VariableSegment, value: "connectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudConnectorGet_568361(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   connectorName: JString (required)
  ##                : Connector Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `connectorName` field"
  var valid_568363 = path.getOrDefault("connectorName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "connectorName", valid_568363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $expand: JString
  ##          : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568364 = query.getOrDefault("api-version")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "api-version", valid_568364
  var valid_568365 = query.getOrDefault("$expand")
  valid_568365 = validateParameter(valid_568365, JString, required = false,
                                 default = nil)
  if valid_568365 != nil:
    section.add "$expand", valid_568365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568366: Call_CloudConnectorGet_568360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568366.validator(path, query, header, formData, body)
  let scheme = call_568366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568366.url(scheme.get, call_568366.host, call_568366.base,
                         call_568366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568366, url, valid)

proc call*(call_568367: Call_CloudConnectorGet_568360; apiVersion: string;
          connectorName: string; Expand: string = ""): Recallable =
  ## cloudConnectorGet
  ## Get a cloud connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Expand: string
  ##         : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  ##   connectorName: string (required)
  ##                : Connector Name.
  var path_568368 = newJObject()
  var query_568369 = newJObject()
  add(query_568369, "api-version", newJString(apiVersion))
  add(query_568369, "$expand", newJString(Expand))
  add(path_568368, "connectorName", newJString(connectorName))
  result = call_568367.call(path_568368, query_568369, nil, nil, nil)

var cloudConnectorGet* = Call_CloudConnectorGet_568360(name: "cloudConnectorGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorGet_568361, base: "",
    url: url_CloudConnectorGet_568362, schemes: {Scheme.Https})
type
  Call_CloudConnectorUpdate_568390 = ref object of OpenApiRestCall_567668
proc url_CloudConnectorUpdate_568392(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.CostManagement/cloudConnectors/"),
               (kind: VariableSegment, value: "connectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudConnectorUpdate_568391(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   connectorName: JString (required)
  ##                : Connector Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `connectorName` field"
  var valid_568393 = path.getOrDefault("connectorName")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "connectorName", valid_568393
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568394 = query.getOrDefault("api-version")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "api-version", valid_568394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   connector: JObject (required)
  ##            : Connector details
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568396: Call_CloudConnectorUpdate_568390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568396.validator(path, query, header, formData, body)
  let scheme = call_568396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568396.url(scheme.get, call_568396.host, call_568396.base,
                         call_568396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568396, url, valid)

proc call*(call_568397: Call_CloudConnectorUpdate_568390; apiVersion: string;
          connector: JsonNode; connectorName: string): Recallable =
  ## cloudConnectorUpdate
  ## Update a cloud connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   connector: JObject (required)
  ##            : Connector details
  ##   connectorName: string (required)
  ##                : Connector Name.
  var path_568398 = newJObject()
  var query_568399 = newJObject()
  var body_568400 = newJObject()
  add(query_568399, "api-version", newJString(apiVersion))
  if connector != nil:
    body_568400 = connector
  add(path_568398, "connectorName", newJString(connectorName))
  result = call_568397.call(path_568398, query_568399, nil, nil, body_568400)

var cloudConnectorUpdate* = Call_CloudConnectorUpdate_568390(
    name: "cloudConnectorUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorUpdate_568391, base: "",
    url: url_CloudConnectorUpdate_568392, schemes: {Scheme.Https})
type
  Call_CloudConnectorDelete_568381 = ref object of OpenApiRestCall_567668
proc url_CloudConnectorDelete_568383(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.CostManagement/cloudConnectors/"),
               (kind: VariableSegment, value: "connectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudConnectorDelete_568382(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   connectorName: JString (required)
  ##                : Connector Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `connectorName` field"
  var valid_568384 = path.getOrDefault("connectorName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "connectorName", valid_568384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568385 = query.getOrDefault("api-version")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "api-version", valid_568385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568386: Call_CloudConnectorDelete_568381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568386.validator(path, query, header, formData, body)
  let scheme = call_568386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568386.url(scheme.get, call_568386.host, call_568386.base,
                         call_568386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568386, url, valid)

proc call*(call_568387: Call_CloudConnectorDelete_568381; apiVersion: string;
          connectorName: string): Recallable =
  ## cloudConnectorDelete
  ## Delete a cloud connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   connectorName: string (required)
  ##                : Connector Name.
  var path_568388 = newJObject()
  var query_568389 = newJObject()
  add(query_568389, "api-version", newJString(apiVersion))
  add(path_568388, "connectorName", newJString(connectorName))
  result = call_568387.call(path_568388, query_568389, nil, nil, nil)

var cloudConnectorDelete* = Call_CloudConnectorDelete_568381(
    name: "cloudConnectorDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorDelete_568382, base: "",
    url: url_CloudConnectorDelete_568383, schemes: {Scheme.Https})
type
  Call_ExternalBillingAccountList_568401 = ref object of OpenApiRestCall_567668
proc url_ExternalBillingAccountList_568403(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ExternalBillingAccountList_568402(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ExternalBillingAccount definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568404 = query.getOrDefault("api-version")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "api-version", valid_568404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568405: Call_ExternalBillingAccountList_568401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ExternalBillingAccount definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568405.validator(path, query, header, formData, body)
  let scheme = call_568405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568405.url(scheme.get, call_568405.host, call_568405.base,
                         call_568405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568405, url, valid)

proc call*(call_568406: Call_ExternalBillingAccountList_568401; apiVersion: string): Recallable =
  ## externalBillingAccountList
  ## List all ExternalBillingAccount definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_568407 = newJObject()
  add(query_568407, "api-version", newJString(apiVersion))
  result = call_568406.call(nil, query_568407, nil, nil, nil)

var externalBillingAccountList* = Call_ExternalBillingAccountList_568401(
    name: "externalBillingAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/externalBillingAccounts",
    validator: validate_ExternalBillingAccountList_568402, base: "",
    url: url_ExternalBillingAccountList_568403, schemes: {Scheme.Https})
type
  Call_ExternalBillingAccountGet_568408 = ref object of OpenApiRestCall_567668
proc url_ExternalBillingAccountGet_568410(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "externalBillingAccountName" in path,
        "`externalBillingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/externalBillingAccounts/"),
               (kind: VariableSegment, value: "externalBillingAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExternalBillingAccountGet_568409(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a ExternalBillingAccount definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   externalBillingAccountName: JString (required)
  ##                             : External Billing Account Name. (eg 'aws-{PayerAccountId}')
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `externalBillingAccountName` field"
  var valid_568411 = path.getOrDefault("externalBillingAccountName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "externalBillingAccountName", valid_568411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $expand: JString
  ##          : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568412 = query.getOrDefault("api-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "api-version", valid_568412
  var valid_568413 = query.getOrDefault("$expand")
  valid_568413 = validateParameter(valid_568413, JString, required = false,
                                 default = nil)
  if valid_568413 != nil:
    section.add "$expand", valid_568413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568414: Call_ExternalBillingAccountGet_568408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a ExternalBillingAccount definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_ExternalBillingAccountGet_568408;
          externalBillingAccountName: string; apiVersion: string;
          Expand: string = ""): Recallable =
  ## externalBillingAccountGet
  ## Get a ExternalBillingAccount definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   externalBillingAccountName: string (required)
  ##                             : External Billing Account Name. (eg 'aws-{PayerAccountId}')
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Expand: string
  ##         : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  var path_568416 = newJObject()
  var query_568417 = newJObject()
  add(path_568416, "externalBillingAccountName",
      newJString(externalBillingAccountName))
  add(query_568417, "api-version", newJString(apiVersion))
  add(query_568417, "$expand", newJString(Expand))
  result = call_568415.call(path_568416, query_568417, nil, nil, nil)

var externalBillingAccountGet* = Call_ExternalBillingAccountGet_568408(
    name: "externalBillingAccountGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}",
    validator: validate_ExternalBillingAccountGet_568409, base: "",
    url: url_ExternalBillingAccountGet_568410, schemes: {Scheme.Https})
type
  Call_ForecastUsageByExternalBillingAccount_568418 = ref object of OpenApiRestCall_567668
proc url_ForecastUsageByExternalBillingAccount_568420(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "externalBillingAccountName" in path,
        "`externalBillingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/externalBillingAccounts/"),
               (kind: VariableSegment, value: "externalBillingAccountName"),
               (kind: ConstantSegment, value: "/Forecast")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ForecastUsageByExternalBillingAccount_568419(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Forecast the usage data for external billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   externalBillingAccountName: JString (required)
  ##                             : External Billing Account Name. (eg 'aws-{PayerAccountId}')
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `externalBillingAccountName` field"
  var valid_568421 = path.getOrDefault("externalBillingAccountName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "externalBillingAccountName", valid_568421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568422 = query.getOrDefault("api-version")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "api-version", valid_568422
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

proc call*(call_568424: Call_ForecastUsageByExternalBillingAccount_568418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Forecast the usage data for external billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568424.validator(path, query, header, formData, body)
  let scheme = call_568424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568424.url(scheme.get, call_568424.host, call_568424.base,
                         call_568424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568424, url, valid)

proc call*(call_568425: Call_ForecastUsageByExternalBillingAccount_568418;
          externalBillingAccountName: string; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## forecastUsageByExternalBillingAccount
  ## Forecast the usage data for external billing account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   externalBillingAccountName: string (required)
  ##                             : External Billing Account Name. (eg 'aws-{PayerAccountId}')
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568426 = newJObject()
  var query_568427 = newJObject()
  var body_568428 = newJObject()
  add(path_568426, "externalBillingAccountName",
      newJString(externalBillingAccountName))
  add(query_568427, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568428 = parameters
  result = call_568425.call(path_568426, query_568427, nil, nil, body_568428)

var forecastUsageByExternalBillingAccount* = Call_ForecastUsageByExternalBillingAccount_568418(
    name: "forecastUsageByExternalBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}/Forecast",
    validator: validate_ForecastUsageByExternalBillingAccount_568419, base: "",
    url: url_ForecastUsageByExternalBillingAccount_568420, schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionListByExternalBillingAccount_568429 = ref object of OpenApiRestCall_567668
proc url_ExternalSubscriptionListByExternalBillingAccount_568431(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "externalBillingAccountName" in path,
        "`externalBillingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/externalBillingAccounts/"),
               (kind: VariableSegment, value: "externalBillingAccountName"),
               (kind: ConstantSegment, value: "/externalSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExternalSubscriptionListByExternalBillingAccount_568430(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all ExternalSubscriptions by ExternalBillingAccount definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   externalBillingAccountName: JString (required)
  ##                             : External Billing Account Name. (eg 'aws-{PayerAccountId}')
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `externalBillingAccountName` field"
  var valid_568432 = path.getOrDefault("externalBillingAccountName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "externalBillingAccountName", valid_568432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568433 = query.getOrDefault("api-version")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "api-version", valid_568433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568434: Call_ExternalSubscriptionListByExternalBillingAccount_568429;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ExternalSubscriptions by ExternalBillingAccount definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568434.validator(path, query, header, formData, body)
  let scheme = call_568434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568434.url(scheme.get, call_568434.host, call_568434.base,
                         call_568434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568434, url, valid)

proc call*(call_568435: Call_ExternalSubscriptionListByExternalBillingAccount_568429;
          externalBillingAccountName: string; apiVersion: string): Recallable =
  ## externalSubscriptionListByExternalBillingAccount
  ## List all ExternalSubscriptions by ExternalBillingAccount definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   externalBillingAccountName: string (required)
  ##                             : External Billing Account Name. (eg 'aws-{PayerAccountId}')
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var path_568436 = newJObject()
  var query_568437 = newJObject()
  add(path_568436, "externalBillingAccountName",
      newJString(externalBillingAccountName))
  add(query_568437, "api-version", newJString(apiVersion))
  result = call_568435.call(path_568436, query_568437, nil, nil, nil)

var externalSubscriptionListByExternalBillingAccount* = Call_ExternalSubscriptionListByExternalBillingAccount_568429(
    name: "externalSubscriptionListByExternalBillingAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}/externalSubscriptions",
    validator: validate_ExternalSubscriptionListByExternalBillingAccount_568430,
    base: "", url: url_ExternalSubscriptionListByExternalBillingAccount_568431,
    schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionList_568438 = ref object of OpenApiRestCall_567668
proc url_ExternalSubscriptionList_568440(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ExternalSubscriptionList_568439(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ExternalSubscription definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568441 = query.getOrDefault("api-version")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "api-version", valid_568441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568442: Call_ExternalSubscriptionList_568438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ExternalSubscription definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568442.validator(path, query, header, formData, body)
  let scheme = call_568442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568442.url(scheme.get, call_568442.host, call_568442.base,
                         call_568442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568442, url, valid)

proc call*(call_568443: Call_ExternalSubscriptionList_568438; apiVersion: string): Recallable =
  ## externalSubscriptionList
  ## List all ExternalSubscription definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_568444 = newJObject()
  add(query_568444, "api-version", newJString(apiVersion))
  result = call_568443.call(nil, query_568444, nil, nil, nil)

var externalSubscriptionList* = Call_ExternalSubscriptionList_568438(
    name: "externalSubscriptionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/externalSubscriptions",
    validator: validate_ExternalSubscriptionList_568439, base: "",
    url: url_ExternalSubscriptionList_568440, schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionGet_568445 = ref object of OpenApiRestCall_567668
proc url_ExternalSubscriptionGet_568447(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "externalSubscriptionName" in path,
        "`externalSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/externalSubscriptions/"),
               (kind: VariableSegment, value: "externalSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExternalSubscriptionGet_568446(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an ExternalSubscription definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   externalSubscriptionName: JString (required)
  ##                           : External Subscription Name. (eg 'aws-{UsageAccountId}')
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `externalSubscriptionName` field"
  var valid_568448 = path.getOrDefault("externalSubscriptionName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "externalSubscriptionName", valid_568448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $expand: JString
  ##          : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568449 = query.getOrDefault("api-version")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "api-version", valid_568449
  var valid_568450 = query.getOrDefault("$expand")
  valid_568450 = validateParameter(valid_568450, JString, required = false,
                                 default = nil)
  if valid_568450 != nil:
    section.add "$expand", valid_568450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_ExternalSubscriptionGet_568445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an ExternalSubscription definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_ExternalSubscriptionGet_568445; apiVersion: string;
          externalSubscriptionName: string; Expand: string = ""): Recallable =
  ## externalSubscriptionGet
  ## Get an ExternalSubscription definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Expand: string
  ##         : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  ##   externalSubscriptionName: string (required)
  ##                           : External Subscription Name. (eg 'aws-{UsageAccountId}')
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(query_568454, "api-version", newJString(apiVersion))
  add(query_568454, "$expand", newJString(Expand))
  add(path_568453, "externalSubscriptionName",
      newJString(externalSubscriptionName))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var externalSubscriptionGet* = Call_ExternalSubscriptionGet_568445(
    name: "externalSubscriptionGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}",
    validator: validate_ExternalSubscriptionGet_568446, base: "",
    url: url_ExternalSubscriptionGet_568447, schemes: {Scheme.Https})
type
  Call_OperationsList_568455 = ref object of OpenApiRestCall_567668
proc url_OperationsList_568457(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568456(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568458 = query.getOrDefault("api-version")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "api-version", valid_568458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568459: Call_OperationsList_568455; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_568459.validator(path, query, header, formData, body)
  let scheme = call_568459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568459.url(scheme.get, call_568459.host, call_568459.base,
                         call_568459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568459, url, valid)

proc call*(call_568460: Call_OperationsList_568455; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_568461 = newJObject()
  add(query_568461, "api-version", newJString(apiVersion))
  result = call_568460.call(nil, query_568461, nil, nil, nil)

var operationsList* = Call_OperationsList_568455(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/operations",
    validator: validate_OperationsList_568456, base: "", url: url_OperationsList_568457,
    schemes: {Scheme.Https})
type
  Call_ForecastUsageByManagementGroup_568462 = ref object of OpenApiRestCall_567668
proc url_ForecastUsageByManagementGroup_568464(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/Forecast")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ForecastUsageByManagementGroup_568463(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage data for management group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : ManagementGroup ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568465 = path.getOrDefault("managementGroupId")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "managementGroupId", valid_568465
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568466 = query.getOrDefault("api-version")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "api-version", valid_568466
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

proc call*(call_568468: Call_ForecastUsageByManagementGroup_568462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for management group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568468.validator(path, query, header, formData, body)
  let scheme = call_568468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568468.url(scheme.get, call_568468.host, call_568468.base,
                         call_568468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568468, url, valid)

proc call*(call_568469: Call_ForecastUsageByManagementGroup_568462;
          apiVersion: string; managementGroupId: string; parameters: JsonNode): Recallable =
  ## forecastUsageByManagementGroup
  ## Lists the usage data for management group.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   managementGroupId: string (required)
  ##                    : ManagementGroup ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568470 = newJObject()
  var query_568471 = newJObject()
  var body_568472 = newJObject()
  add(query_568471, "api-version", newJString(apiVersion))
  add(path_568470, "managementGroupId", newJString(managementGroupId))
  if parameters != nil:
    body_568472 = parameters
  result = call_568469.call(path_568470, query_568471, nil, nil, body_568472)

var forecastUsageByManagementGroup* = Call_ForecastUsageByManagementGroup_568462(
    name: "forecastUsageByManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByManagementGroup_568463, base: "",
    url: url_ForecastUsageByManagementGroup_568464, schemes: {Scheme.Https})
type
  Call_QueryUsageByManagementGroup_568473 = ref object of OpenApiRestCall_567668
proc url_QueryUsageByManagementGroup_568475(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/Query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryUsageByManagementGroup_568474(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage data for management group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : ManagementGroup ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568476 = path.getOrDefault("managementGroupId")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "managementGroupId", valid_568476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568477 = query.getOrDefault("api-version")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "api-version", valid_568477
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

proc call*(call_568479: Call_QueryUsageByManagementGroup_568473; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for management group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568479.validator(path, query, header, formData, body)
  let scheme = call_568479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568479.url(scheme.get, call_568479.host, call_568479.base,
                         call_568479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568479, url, valid)

proc call*(call_568480: Call_QueryUsageByManagementGroup_568473;
          apiVersion: string; managementGroupId: string; parameters: JsonNode): Recallable =
  ## queryUsageByManagementGroup
  ## Lists the usage data for management group.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   managementGroupId: string (required)
  ##                    : ManagementGroup ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568481 = newJObject()
  var query_568482 = newJObject()
  var body_568483 = newJObject()
  add(query_568482, "api-version", newJString(apiVersion))
  add(path_568481, "managementGroupId", newJString(managementGroupId))
  if parameters != nil:
    body_568483 = parameters
  result = call_568480.call(path_568481, query_568482, nil, nil, body_568483)

var queryUsageByManagementGroup* = Call_QueryUsageByManagementGroup_568473(
    name: "queryUsageByManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByManagementGroup_568474, base: "",
    url: url_QueryUsageByManagementGroup_568475, schemes: {Scheme.Https})
type
  Call_DimensionsListByManagementGroup_568484 = ref object of OpenApiRestCall_567668
proc url_DimensionsListByManagementGroup_568486(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/dimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DimensionsListByManagementGroup_568485(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the dimensions by managementGroup Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : ManagementGroup ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568487 = path.getOrDefault("managementGroupId")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "managementGroupId", valid_568487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  var valid_568488 = query.getOrDefault("api-version")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "api-version", valid_568488
  var valid_568489 = query.getOrDefault("$expand")
  valid_568489 = validateParameter(valid_568489, JString, required = false,
                                 default = nil)
  if valid_568489 != nil:
    section.add "$expand", valid_568489
  var valid_568490 = query.getOrDefault("$top")
  valid_568490 = validateParameter(valid_568490, JInt, required = false, default = nil)
  if valid_568490 != nil:
    section.add "$top", valid_568490
  var valid_568491 = query.getOrDefault("$skiptoken")
  valid_568491 = validateParameter(valid_568491, JString, required = false,
                                 default = nil)
  if valid_568491 != nil:
    section.add "$skiptoken", valid_568491
  var valid_568492 = query.getOrDefault("$filter")
  valid_568492 = validateParameter(valid_568492, JString, required = false,
                                 default = nil)
  if valid_568492 != nil:
    section.add "$filter", valid_568492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568493: Call_DimensionsListByManagementGroup_568484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the dimensions by managementGroup Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568493.validator(path, query, header, formData, body)
  let scheme = call_568493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568493.url(scheme.get, call_568493.host, call_568493.base,
                         call_568493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568493, url, valid)

proc call*(call_568494: Call_DimensionsListByManagementGroup_568484;
          apiVersion: string; managementGroupId: string; Expand: string = "";
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListByManagementGroup
  ## Lists the dimensions by managementGroup Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   managementGroupId: string (required)
  ##                    : ManagementGroup ID
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568495 = newJObject()
  var query_568496 = newJObject()
  add(query_568496, "api-version", newJString(apiVersion))
  add(query_568496, "$expand", newJString(Expand))
  add(path_568495, "managementGroupId", newJString(managementGroupId))
  add(query_568496, "$top", newJInt(Top))
  add(query_568496, "$skiptoken", newJString(Skiptoken))
  add(query_568496, "$filter", newJString(Filter))
  result = call_568494.call(path_568495, query_568496, nil, nil, nil)

var dimensionsListByManagementGroup* = Call_DimensionsListByManagementGroup_568484(
    name: "dimensionsListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByManagementGroup_568485, base: "",
    url: url_DimensionsListByManagementGroup_568486, schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionListByManagementGroup_568497 = ref object of OpenApiRestCall_567668
proc url_ExternalSubscriptionListByManagementGroup_568499(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/externalSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExternalSubscriptionListByManagementGroup_568498(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ExternalSubscription definitions for Management Group
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : ManagementGroup ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568500 = path.getOrDefault("managementGroupId")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "managementGroupId", valid_568500
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $recurse: JBool
  ##           : The $recurse=true query string parameter allows returning externalSubscriptions associated with the specified managementGroup, or any of its descendants.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568501 = query.getOrDefault("api-version")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "api-version", valid_568501
  var valid_568502 = query.getOrDefault("$recurse")
  valid_568502 = validateParameter(valid_568502, JBool, required = false, default = nil)
  if valid_568502 != nil:
    section.add "$recurse", valid_568502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568503: Call_ExternalSubscriptionListByManagementGroup_568497;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ExternalSubscription definitions for Management Group
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568503.validator(path, query, header, formData, body)
  let scheme = call_568503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568503.url(scheme.get, call_568503.host, call_568503.base,
                         call_568503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568503, url, valid)

proc call*(call_568504: Call_ExternalSubscriptionListByManagementGroup_568497;
          apiVersion: string; managementGroupId: string; Recurse: bool = false): Recallable =
  ## externalSubscriptionListByManagementGroup
  ## List all ExternalSubscription definitions for Management Group
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   managementGroupId: string (required)
  ##                    : ManagementGroup ID
  ##   Recurse: bool
  ##          : The $recurse=true query string parameter allows returning externalSubscriptions associated with the specified managementGroup, or any of its descendants.
  var path_568505 = newJObject()
  var query_568506 = newJObject()
  add(query_568506, "api-version", newJString(apiVersion))
  add(path_568505, "managementGroupId", newJString(managementGroupId))
  add(query_568506, "$recurse", newJBool(Recurse))
  result = call_568504.call(path_568505, query_568506, nil, nil, nil)

var externalSubscriptionListByManagementGroup* = Call_ExternalSubscriptionListByManagementGroup_568497(
    name: "externalSubscriptionListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/externalSubscriptions",
    validator: validate_ExternalSubscriptionListByManagementGroup_568498,
    base: "", url: url_ExternalSubscriptionListByManagementGroup_568499,
    schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionUpdateManagementGroup_568507 = ref object of OpenApiRestCall_567668
proc url_ExternalSubscriptionUpdateManagementGroup_568509(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "externalSubscriptionName" in path,
        "`externalSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/externalSubscriptions/"),
               (kind: VariableSegment, value: "externalSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExternalSubscriptionUpdateManagementGroup_568508(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the management group of an ExternalSubscription
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : ManagementGroup ID
  ##   externalSubscriptionName: JString (required)
  ##                           : External Subscription Name. (eg 'aws-{UsageAccountId}')
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568510 = path.getOrDefault("managementGroupId")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "managementGroupId", valid_568510
  var valid_568511 = path.getOrDefault("externalSubscriptionName")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "externalSubscriptionName", valid_568511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568512 = query.getOrDefault("api-version")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "api-version", valid_568512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568513: Call_ExternalSubscriptionUpdateManagementGroup_568507;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the management group of an ExternalSubscription
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568513.validator(path, query, header, formData, body)
  let scheme = call_568513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568513.url(scheme.get, call_568513.host, call_568513.base,
                         call_568513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568513, url, valid)

proc call*(call_568514: Call_ExternalSubscriptionUpdateManagementGroup_568507;
          apiVersion: string; managementGroupId: string;
          externalSubscriptionName: string): Recallable =
  ## externalSubscriptionUpdateManagementGroup
  ## Updates the management group of an ExternalSubscription
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   managementGroupId: string (required)
  ##                    : ManagementGroup ID
  ##   externalSubscriptionName: string (required)
  ##                           : External Subscription Name. (eg 'aws-{UsageAccountId}')
  var path_568515 = newJObject()
  var query_568516 = newJObject()
  add(query_568516, "api-version", newJString(apiVersion))
  add(path_568515, "managementGroupId", newJString(managementGroupId))
  add(path_568515, "externalSubscriptionName",
      newJString(externalSubscriptionName))
  result = call_568514.call(path_568515, query_568516, nil, nil, nil)

var externalSubscriptionUpdateManagementGroup* = Call_ExternalSubscriptionUpdateManagementGroup_568507(
    name: "externalSubscriptionUpdateManagementGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}",
    validator: validate_ExternalSubscriptionUpdateManagementGroup_568508,
    base: "", url: url_ExternalSubscriptionUpdateManagementGroup_568509,
    schemes: {Scheme.Https})
type
  Call_ForecastUsageBySubscription_568517 = ref object of OpenApiRestCall_567668
proc url_ForecastUsageBySubscription_568519(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CostManagement/Forecast")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ForecastUsageBySubscription_568518(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Forecast the usage data for subscriptionId.
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
  var valid_568520 = path.getOrDefault("subscriptionId")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "subscriptionId", valid_568520
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568521 = query.getOrDefault("api-version")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "api-version", valid_568521
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

proc call*(call_568523: Call_ForecastUsageBySubscription_568517; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568523.validator(path, query, header, formData, body)
  let scheme = call_568523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568523.url(scheme.get, call_568523.host, call_568523.base,
                         call_568523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568523, url, valid)

proc call*(call_568524: Call_ForecastUsageBySubscription_568517;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## forecastUsageBySubscription
  ## Forecast the usage data for subscriptionId.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568525 = newJObject()
  var query_568526 = newJObject()
  var body_568527 = newJObject()
  add(query_568526, "api-version", newJString(apiVersion))
  add(path_568525, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568527 = parameters
  result = call_568524.call(path_568525, query_568526, nil, nil, body_568527)

var forecastUsageBySubscription* = Call_ForecastUsageBySubscription_568517(
    name: "forecastUsageBySubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageBySubscription_568518, base: "",
    url: url_ForecastUsageBySubscription_568519, schemes: {Scheme.Https})
type
  Call_QueryUsageBySubscription_568528 = ref object of OpenApiRestCall_567668
proc url_QueryUsageBySubscription_568530(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_QueryUsageBySubscription_568529(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query the usage data for subscriptionId.
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
  var valid_568531 = path.getOrDefault("subscriptionId")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "subscriptionId", valid_568531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568532 = query.getOrDefault("api-version")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "api-version", valid_568532
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

proc call*(call_568534: Call_QueryUsageBySubscription_568528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568534.validator(path, query, header, formData, body)
  let scheme = call_568534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568534.url(scheme.get, call_568534.host, call_568534.base,
                         call_568534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568534, url, valid)

proc call*(call_568535: Call_QueryUsageBySubscription_568528; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## queryUsageBySubscription
  ## Query the usage data for subscriptionId.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568536 = newJObject()
  var query_568537 = newJObject()
  var body_568538 = newJObject()
  add(query_568537, "api-version", newJString(apiVersion))
  add(path_568536, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568538 = parameters
  result = call_568535.call(path_568536, query_568537, nil, nil, body_568538)

var queryUsageBySubscription* = Call_QueryUsageBySubscription_568528(
    name: "queryUsageBySubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageBySubscription_568529, base: "",
    url: url_QueryUsageBySubscription_568530, schemes: {Scheme.Https})
type
  Call_DimensionsListBySubscription_568539 = ref object of OpenApiRestCall_567668
proc url_DimensionsListBySubscription_568541(protocol: Scheme; host: string;
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

proc validate_DimensionsListBySubscription_568540(path: JsonNode; query: JsonNode;
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
  var valid_568542 = path.getOrDefault("subscriptionId")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "subscriptionId", valid_568542
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  var valid_568543 = query.getOrDefault("api-version")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "api-version", valid_568543
  var valid_568544 = query.getOrDefault("$expand")
  valid_568544 = validateParameter(valid_568544, JString, required = false,
                                 default = nil)
  if valid_568544 != nil:
    section.add "$expand", valid_568544
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

proc call*(call_568548: Call_DimensionsListBySubscription_568539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568548.validator(path, query, header, formData, body)
  let scheme = call_568548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568548.url(scheme.get, call_568548.host, call_568548.base,
                         call_568548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568548, url, valid)

proc call*(call_568549: Call_DimensionsListBySubscription_568539;
          apiVersion: string; subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListBySubscription
  ## Lists the dimensions by subscription Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  var path_568550 = newJObject()
  var query_568551 = newJObject()
  add(query_568551, "api-version", newJString(apiVersion))
  add(query_568551, "$expand", newJString(Expand))
  add(path_568550, "subscriptionId", newJString(subscriptionId))
  add(query_568551, "$top", newJInt(Top))
  add(query_568551, "$skiptoken", newJString(Skiptoken))
  add(query_568551, "$filter", newJString(Filter))
  result = call_568549.call(path_568550, query_568551, nil, nil, nil)

var dimensionsListBySubscription* = Call_DimensionsListBySubscription_568539(
    name: "dimensionsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListBySubscription_568540, base: "",
    url: url_DimensionsListBySubscription_568541, schemes: {Scheme.Https})
type
  Call_DimensionsListByResourceGroup_568552 = ref object of OpenApiRestCall_567668
proc url_DimensionsListByResourceGroup_568554(protocol: Scheme; host: string;
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

proc validate_DimensionsListByResourceGroup_568553(path: JsonNode; query: JsonNode;
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
  var valid_568555 = path.getOrDefault("resourceGroupName")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "resourceGroupName", valid_568555
  var valid_568556 = path.getOrDefault("subscriptionId")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "subscriptionId", valid_568556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  var valid_568557 = query.getOrDefault("api-version")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "api-version", valid_568557
  var valid_568558 = query.getOrDefault("$expand")
  valid_568558 = validateParameter(valid_568558, JString, required = false,
                                 default = nil)
  if valid_568558 != nil:
    section.add "$expand", valid_568558
  var valid_568559 = query.getOrDefault("$top")
  valid_568559 = validateParameter(valid_568559, JInt, required = false, default = nil)
  if valid_568559 != nil:
    section.add "$top", valid_568559
  var valid_568560 = query.getOrDefault("$skiptoken")
  valid_568560 = validateParameter(valid_568560, JString, required = false,
                                 default = nil)
  if valid_568560 != nil:
    section.add "$skiptoken", valid_568560
  var valid_568561 = query.getOrDefault("$filter")
  valid_568561 = validateParameter(valid_568561, JString, required = false,
                                 default = nil)
  if valid_568561 != nil:
    section.add "$filter", valid_568561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568562: Call_DimensionsListByResourceGroup_568552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by resource group Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568562.validator(path, query, header, formData, body)
  let scheme = call_568562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568562.url(scheme.get, call_568562.host, call_568562.base,
                         call_568562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568562, url, valid)

proc call*(call_568563: Call_DimensionsListByResourceGroup_568552;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListByResourceGroup
  ## Lists the dimensions by resource group Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  var path_568564 = newJObject()
  var query_568565 = newJObject()
  add(path_568564, "resourceGroupName", newJString(resourceGroupName))
  add(query_568565, "api-version", newJString(apiVersion))
  add(query_568565, "$expand", newJString(Expand))
  add(path_568564, "subscriptionId", newJString(subscriptionId))
  add(query_568565, "$top", newJInt(Top))
  add(query_568565, "$skiptoken", newJString(Skiptoken))
  add(query_568565, "$filter", newJString(Filter))
  result = call_568563.call(path_568564, query_568565, nil, nil, nil)

var dimensionsListByResourceGroup* = Call_DimensionsListByResourceGroup_568552(
    name: "dimensionsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByResourceGroup_568553, base: "",
    url: url_DimensionsListByResourceGroup_568554, schemes: {Scheme.Https})
type
  Call_ForecastUsageByResourceGroup_568566 = ref object of OpenApiRestCall_567668
proc url_ForecastUsageByResourceGroup_568568(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/Forecast")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ForecastUsageByResourceGroup_568567(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Forecast the usage data for subscriptionId and resource group.
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
  var valid_568569 = path.getOrDefault("resourceGroupName")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "resourceGroupName", valid_568569
  var valid_568570 = path.getOrDefault("subscriptionId")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "subscriptionId", valid_568570
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568571 = query.getOrDefault("api-version")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "api-version", valid_568571
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

proc call*(call_568573: Call_ForecastUsageByResourceGroup_568566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568573.validator(path, query, header, formData, body)
  let scheme = call_568573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568573.url(scheme.get, call_568573.host, call_568573.base,
                         call_568573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568573, url, valid)

proc call*(call_568574: Call_ForecastUsageByResourceGroup_568566;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## forecastUsageByResourceGroup
  ## Forecast the usage data for subscriptionId and resource group.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568575 = newJObject()
  var query_568576 = newJObject()
  var body_568577 = newJObject()
  add(path_568575, "resourceGroupName", newJString(resourceGroupName))
  add(query_568576, "api-version", newJString(apiVersion))
  add(path_568575, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568577 = parameters
  result = call_568574.call(path_568575, query_568576, nil, nil, body_568577)

var forecastUsageByResourceGroup* = Call_ForecastUsageByResourceGroup_568566(
    name: "forecastUsageByResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByResourceGroup_568567, base: "",
    url: url_ForecastUsageByResourceGroup_568568, schemes: {Scheme.Https})
type
  Call_QueryUsageByResourceGroup_568578 = ref object of OpenApiRestCall_567668
proc url_QueryUsageByResourceGroup_568580(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/Query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryUsageByResourceGroup_568579(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query the usage data for subscriptionId and resource group.
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
  var valid_568581 = path.getOrDefault("resourceGroupName")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "resourceGroupName", valid_568581
  var valid_568582 = path.getOrDefault("subscriptionId")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "subscriptionId", valid_568582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568583 = query.getOrDefault("api-version")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "api-version", valid_568583
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

proc call*(call_568585: Call_QueryUsageByResourceGroup_568578; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568585.validator(path, query, header, formData, body)
  let scheme = call_568585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568585.url(scheme.get, call_568585.host, call_568585.base,
                         call_568585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568585, url, valid)

proc call*(call_568586: Call_QueryUsageByResourceGroup_568578;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## queryUsageByResourceGroup
  ## Query the usage data for subscriptionId and resource group.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_568587 = newJObject()
  var query_568588 = newJObject()
  var body_568589 = newJObject()
  add(path_568587, "resourceGroupName", newJString(resourceGroupName))
  add(query_568588, "api-version", newJString(apiVersion))
  add(path_568587, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568589 = parameters
  result = call_568586.call(path_568587, query_568588, nil, nil, body_568589)

var queryUsageByResourceGroup* = Call_QueryUsageByResourceGroup_568578(
    name: "queryUsageByResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByResourceGroup_568579, base: "",
    url: url_QueryUsageByResourceGroup_568580, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
