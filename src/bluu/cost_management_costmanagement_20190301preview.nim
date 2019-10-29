
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563566 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563566](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563566): Option[Scheme] {.used.} =
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
  macServiceName = "cost-management-costmanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ForecastUsageByDepartment_563788 = ref object of OpenApiRestCall_563566
proc url_ForecastUsageByDepartment_563790(protocol: Scheme; host: string;
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

proc validate_ForecastUsageByDepartment_563789(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Forecast the usage data for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_563982 = path.getOrDefault("departmentId")
  valid_563982 = validateParameter(valid_563982, JString, required = true,
                                 default = nil)
  if valid_563982 != nil:
    section.add "departmentId", valid_563982
  var valid_563983 = path.getOrDefault("billingAccountId")
  valid_563983 = validateParameter(valid_563983, JString, required = true,
                                 default = nil)
  if valid_563983 != nil:
    section.add "billingAccountId", valid_563983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563984 = query.getOrDefault("api-version")
  valid_563984 = validateParameter(valid_563984, JString, required = true,
                                 default = nil)
  if valid_563984 != nil:
    section.add "api-version", valid_563984
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

proc call*(call_564008: Call_ForecastUsageByDepartment_563788; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564008.validator(path, query, header, formData, body)
  let scheme = call_564008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564008.url(scheme.get, call_564008.host, call_564008.base,
                         call_564008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564008, url, valid)

proc call*(call_564079: Call_ForecastUsageByDepartment_563788; apiVersion: string;
          departmentId: string; billingAccountId: string; parameters: JsonNode): Recallable =
  ## forecastUsageByDepartment
  ## Forecast the usage data for department.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   departmentId: string (required)
  ##               : Department ID
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_564080 = newJObject()
  var query_564082 = newJObject()
  var body_564083 = newJObject()
  add(query_564082, "api-version", newJString(apiVersion))
  add(path_564080, "departmentId", newJString(departmentId))
  add(path_564080, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_564083 = parameters
  result = call_564079.call(path_564080, query_564082, nil, nil, body_564083)

var forecastUsageByDepartment* = Call_ForecastUsageByDepartment_563788(
    name: "forecastUsageByDepartment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByDepartment_563789, base: "",
    url: url_ForecastUsageByDepartment_563790, schemes: {Scheme.Https})
type
  Call_QueryUsageByDepartment_564122 = ref object of OpenApiRestCall_563566
proc url_QueryUsageByDepartment_564124(protocol: Scheme; host: string; base: string;
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

proc validate_QueryUsageByDepartment_564123(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query the usage data for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564125 = path.getOrDefault("departmentId")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "departmentId", valid_564125
  var valid_564126 = path.getOrDefault("billingAccountId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "billingAccountId", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564127 = query.getOrDefault("api-version")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "api-version", valid_564127
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

proc call*(call_564129: Call_QueryUsageByDepartment_564122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_QueryUsageByDepartment_564122; apiVersion: string;
          departmentId: string; billingAccountId: string; parameters: JsonNode): Recallable =
  ## queryUsageByDepartment
  ## Query the usage data for department.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   departmentId: string (required)
  ##               : Department ID
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  var body_564133 = newJObject()
  add(query_564132, "api-version", newJString(apiVersion))
  add(path_564131, "departmentId", newJString(departmentId))
  add(path_564131, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_564133 = parameters
  result = call_564130.call(path_564131, query_564132, nil, nil, body_564133)

var queryUsageByDepartment* = Call_QueryUsageByDepartment_564122(
    name: "queryUsageByDepartment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByDepartment_564123, base: "",
    url: url_QueryUsageByDepartment_564124, schemes: {Scheme.Https})
type
  Call_DimensionsListByDepartment_564134 = ref object of OpenApiRestCall_563566
proc url_DimensionsListByDepartment_564136(protocol: Scheme; host: string;
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

proc validate_DimensionsListByDepartment_564135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the dimensions by Department Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564138 = path.getOrDefault("departmentId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "departmentId", valid_564138
  var valid_564139 = path.getOrDefault("billingAccountId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "billingAccountId", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N dimension data.
  ##   $expand: JString
  ##          : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  var valid_564141 = query.getOrDefault("$top")
  valid_564141 = validateParameter(valid_564141, JInt, required = false, default = nil)
  if valid_564141 != nil:
    section.add "$top", valid_564141
  var valid_564142 = query.getOrDefault("$expand")
  valid_564142 = validateParameter(valid_564142, JString, required = false,
                                 default = nil)
  if valid_564142 != nil:
    section.add "$expand", valid_564142
  var valid_564143 = query.getOrDefault("$skiptoken")
  valid_564143 = validateParameter(valid_564143, JString, required = false,
                                 default = nil)
  if valid_564143 != nil:
    section.add "$skiptoken", valid_564143
  var valid_564144 = query.getOrDefault("$filter")
  valid_564144 = validateParameter(valid_564144, JString, required = false,
                                 default = nil)
  if valid_564144 != nil:
    section.add "$filter", valid_564144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564145: Call_DimensionsListByDepartment_564134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by Department Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_DimensionsListByDepartment_564134; apiVersion: string;
          departmentId: string; billingAccountId: string; Top: int = 0;
          Expand: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListByDepartment
  ## Lists the dimensions by Department Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  add(query_564148, "api-version", newJString(apiVersion))
  add(query_564148, "$top", newJInt(Top))
  add(query_564148, "$expand", newJString(Expand))
  add(path_564147, "departmentId", newJString(departmentId))
  add(query_564148, "$skiptoken", newJString(Skiptoken))
  add(path_564147, "billingAccountId", newJString(billingAccountId))
  add(query_564148, "$filter", newJString(Filter))
  result = call_564146.call(path_564147, query_564148, nil, nil, nil)

var dimensionsListByDepartment* = Call_DimensionsListByDepartment_564134(
    name: "dimensionsListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByDepartment_564135, base: "",
    url: url_DimensionsListByDepartment_564136, schemes: {Scheme.Https})
type
  Call_ForecastUsageByEnrollmentAccount_564149 = ref object of OpenApiRestCall_563566
proc url_ForecastUsageByEnrollmentAccount_564151(protocol: Scheme; host: string;
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

proc validate_ForecastUsageByEnrollmentAccount_564150(path: JsonNode;
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
  var valid_564152 = path.getOrDefault("enrollmentAccountId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "enrollmentAccountId", valid_564152
  var valid_564153 = path.getOrDefault("billingAccountId")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "billingAccountId", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "api-version", valid_564154
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

proc call*(call_564156: Call_ForecastUsageByEnrollmentAccount_564149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Forecast the usage data for an enrollment account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_ForecastUsageByEnrollmentAccount_564149;
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
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  var body_564160 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_564158, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_564160 = parameters
  result = call_564157.call(path_564158, query_564159, nil, nil, body_564160)

var forecastUsageByEnrollmentAccount* = Call_ForecastUsageByEnrollmentAccount_564149(
    name: "forecastUsageByEnrollmentAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByEnrollmentAccount_564150, base: "",
    url: url_ForecastUsageByEnrollmentAccount_564151, schemes: {Scheme.Https})
type
  Call_QueryUsageByEnrollmentAccount_564161 = ref object of OpenApiRestCall_563566
proc url_QueryUsageByEnrollmentAccount_564163(protocol: Scheme; host: string;
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

proc validate_QueryUsageByEnrollmentAccount_564162(path: JsonNode; query: JsonNode;
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
  var valid_564164 = path.getOrDefault("enrollmentAccountId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "enrollmentAccountId", valid_564164
  var valid_564165 = path.getOrDefault("billingAccountId")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "billingAccountId", valid_564165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
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

proc call*(call_564168: Call_QueryUsageByEnrollmentAccount_564161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for an enrollment account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564168.validator(path, query, header, formData, body)
  let scheme = call_564168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564168.url(scheme.get, call_564168.host, call_564168.base,
                         call_564168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564168, url, valid)

proc call*(call_564169: Call_QueryUsageByEnrollmentAccount_564161;
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
  var path_564170 = newJObject()
  var query_564171 = newJObject()
  var body_564172 = newJObject()
  add(query_564171, "api-version", newJString(apiVersion))
  add(path_564170, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_564170, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_564172 = parameters
  result = call_564169.call(path_564170, query_564171, nil, nil, body_564172)

var queryUsageByEnrollmentAccount* = Call_QueryUsageByEnrollmentAccount_564161(
    name: "queryUsageByEnrollmentAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByEnrollmentAccount_564162, base: "",
    url: url_QueryUsageByEnrollmentAccount_564163, schemes: {Scheme.Https})
type
  Call_DimensionsListByEnrollmentAccount_564173 = ref object of OpenApiRestCall_563566
proc url_DimensionsListByEnrollmentAccount_564175(protocol: Scheme; host: string;
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

proc validate_DimensionsListByEnrollmentAccount_564174(path: JsonNode;
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
  var valid_564176 = path.getOrDefault("enrollmentAccountId")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "enrollmentAccountId", valid_564176
  var valid_564177 = path.getOrDefault("billingAccountId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "billingAccountId", valid_564177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N dimension data.
  ##   $expand: JString
  ##          : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564178 = query.getOrDefault("api-version")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "api-version", valid_564178
  var valid_564179 = query.getOrDefault("$top")
  valid_564179 = validateParameter(valid_564179, JInt, required = false, default = nil)
  if valid_564179 != nil:
    section.add "$top", valid_564179
  var valid_564180 = query.getOrDefault("$expand")
  valid_564180 = validateParameter(valid_564180, JString, required = false,
                                 default = nil)
  if valid_564180 != nil:
    section.add "$expand", valid_564180
  var valid_564181 = query.getOrDefault("$skiptoken")
  valid_564181 = validateParameter(valid_564181, JString, required = false,
                                 default = nil)
  if valid_564181 != nil:
    section.add "$skiptoken", valid_564181
  var valid_564182 = query.getOrDefault("$filter")
  valid_564182 = validateParameter(valid_564182, JString, required = false,
                                 default = nil)
  if valid_564182 != nil:
    section.add "$filter", valid_564182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564183: Call_DimensionsListByEnrollmentAccount_564173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the dimensions by Enrollment Account Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564183.validator(path, query, header, formData, body)
  let scheme = call_564183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564183.url(scheme.get, call_564183.host, call_564183.base,
                         call_564183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564183, url, valid)

proc call*(call_564184: Call_DimensionsListByEnrollmentAccount_564173;
          apiVersion: string; enrollmentAccountId: string; billingAccountId: string;
          Top: int = 0; Expand: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListByEnrollmentAccount
  ## Lists the dimensions by Enrollment Account Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : Enrollment Account ID
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_564185 = newJObject()
  var query_564186 = newJObject()
  add(query_564186, "api-version", newJString(apiVersion))
  add(query_564186, "$top", newJInt(Top))
  add(query_564186, "$expand", newJString(Expand))
  add(query_564186, "$skiptoken", newJString(Skiptoken))
  add(path_564185, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_564185, "billingAccountId", newJString(billingAccountId))
  add(query_564186, "$filter", newJString(Filter))
  result = call_564184.call(path_564185, query_564186, nil, nil, nil)

var dimensionsListByEnrollmentAccount* = Call_DimensionsListByEnrollmentAccount_564173(
    name: "dimensionsListByEnrollmentAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByEnrollmentAccount_564174, base: "",
    url: url_DimensionsListByEnrollmentAccount_564175, schemes: {Scheme.Https})
type
  Call_ForecastUsageByBillingAccount_564187 = ref object of OpenApiRestCall_563566
proc url_ForecastUsageByBillingAccount_564189(protocol: Scheme; host: string;
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

proc validate_ForecastUsageByBillingAccount_564188(path: JsonNode; query: JsonNode;
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
  var valid_564190 = path.getOrDefault("billingAccountId")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "billingAccountId", valid_564190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564191 = query.getOrDefault("api-version")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "api-version", valid_564191
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

proc call*(call_564193: Call_ForecastUsageByBillingAccount_564187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_ForecastUsageByBillingAccount_564187;
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
  var path_564195 = newJObject()
  var query_564196 = newJObject()
  var body_564197 = newJObject()
  add(query_564196, "api-version", newJString(apiVersion))
  add(path_564195, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_564197 = parameters
  result = call_564194.call(path_564195, query_564196, nil, nil, body_564197)

var forecastUsageByBillingAccount* = Call_ForecastUsageByBillingAccount_564187(
    name: "forecastUsageByBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByBillingAccount_564188, base: "",
    url: url_ForecastUsageByBillingAccount_564189, schemes: {Scheme.Https})
type
  Call_QueryUsageByBillingAccount_564198 = ref object of OpenApiRestCall_563566
proc url_QueryUsageByBillingAccount_564200(protocol: Scheme; host: string;
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

proc validate_QueryUsageByBillingAccount_564199(path: JsonNode; query: JsonNode;
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
  var valid_564201 = path.getOrDefault("billingAccountId")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "billingAccountId", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "api-version", valid_564202
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

proc call*(call_564204: Call_QueryUsageByBillingAccount_564198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_QueryUsageByBillingAccount_564198; apiVersion: string;
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
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  var body_564208 = newJObject()
  add(query_564207, "api-version", newJString(apiVersion))
  add(path_564206, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_564208 = parameters
  result = call_564205.call(path_564206, query_564207, nil, nil, body_564208)

var queryUsageByBillingAccount* = Call_QueryUsageByBillingAccount_564198(
    name: "queryUsageByBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByBillingAccount_564199, base: "",
    url: url_QueryUsageByBillingAccount_564200, schemes: {Scheme.Https})
type
  Call_DimensionsListByBillingAccount_564209 = ref object of OpenApiRestCall_563566
proc url_DimensionsListByBillingAccount_564211(protocol: Scheme; host: string;
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

proc validate_DimensionsListByBillingAccount_564210(path: JsonNode;
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
  var valid_564212 = path.getOrDefault("billingAccountId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "billingAccountId", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N dimension data.
  ##   $expand: JString
  ##          : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "api-version", valid_564213
  var valid_564214 = query.getOrDefault("$top")
  valid_564214 = validateParameter(valid_564214, JInt, required = false, default = nil)
  if valid_564214 != nil:
    section.add "$top", valid_564214
  var valid_564215 = query.getOrDefault("$expand")
  valid_564215 = validateParameter(valid_564215, JString, required = false,
                                 default = nil)
  if valid_564215 != nil:
    section.add "$expand", valid_564215
  var valid_564216 = query.getOrDefault("$skiptoken")
  valid_564216 = validateParameter(valid_564216, JString, required = false,
                                 default = nil)
  if valid_564216 != nil:
    section.add "$skiptoken", valid_564216
  var valid_564217 = query.getOrDefault("$filter")
  valid_564217 = validateParameter(valid_564217, JString, required = false,
                                 default = nil)
  if valid_564217 != nil:
    section.add "$filter", valid_564217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_DimensionsListByBillingAccount_564209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by billingAccount Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_DimensionsListByBillingAccount_564209;
          apiVersion: string; billingAccountId: string; Top: int = 0;
          Expand: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListByBillingAccount
  ## Lists the dimensions by billingAccount Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  add(query_564221, "api-version", newJString(apiVersion))
  add(query_564221, "$top", newJInt(Top))
  add(query_564221, "$expand", newJString(Expand))
  add(query_564221, "$skiptoken", newJString(Skiptoken))
  add(path_564220, "billingAccountId", newJString(billingAccountId))
  add(query_564221, "$filter", newJString(Filter))
  result = call_564219.call(path_564220, query_564221, nil, nil, nil)

var dimensionsListByBillingAccount* = Call_DimensionsListByBillingAccount_564209(
    name: "dimensionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByBillingAccount_564210, base: "",
    url: url_DimensionsListByBillingAccount_564211, schemes: {Scheme.Https})
type
  Call_ShowbackRulesList_564222 = ref object of OpenApiRestCall_563566
proc url_ShowbackRulesList_564224(protocol: Scheme; host: string; base: string;
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

proc validate_ShowbackRulesList_564223(path: JsonNode; query: JsonNode;
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
  var valid_564225 = path.getOrDefault("billingAccountId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "billingAccountId", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_ShowbackRulesList_564222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get list all Showback Rules.
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_ShowbackRulesList_564222; apiVersion: string;
          billingAccountId: string): Recallable =
  ## showbackRulesList
  ## Get list all Showback Rules.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_564229 = newJObject()
  var query_564230 = newJObject()
  add(query_564230, "api-version", newJString(apiVersion))
  add(path_564229, "billingAccountId", newJString(billingAccountId))
  result = call_564228.call(path_564229, query_564230, nil, nil, nil)

var showbackRulesList* = Call_ShowbackRulesList_564222(name: "showbackRulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/showbackRules",
    validator: validate_ShowbackRulesList_564223, base: "",
    url: url_ShowbackRulesList_564224, schemes: {Scheme.Https})
type
  Call_ShowbackRuleCreateUpdateRule_564241 = ref object of OpenApiRestCall_563566
proc url_ShowbackRuleCreateUpdateRule_564243(protocol: Scheme; host: string;
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

proc validate_ShowbackRuleCreateUpdateRule_564242(path: JsonNode; query: JsonNode;
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
  var valid_564244 = path.getOrDefault("ruleName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "ruleName", valid_564244
  var valid_564245 = path.getOrDefault("billingAccountId")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "billingAccountId", valid_564245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564246 = query.getOrDefault("api-version")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "api-version", valid_564246
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

proc call*(call_564248: Call_ShowbackRuleCreateUpdateRule_564241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create/Update showback rule for billing account.
  ## 
  let valid = call_564248.validator(path, query, header, formData, body)
  let scheme = call_564248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564248.url(scheme.get, call_564248.host, call_564248.base,
                         call_564248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564248, url, valid)

proc call*(call_564249: Call_ShowbackRuleCreateUpdateRule_564241;
          apiVersion: string; ruleName: string; billingAccountId: string;
          showbackRule: JsonNode): Recallable =
  ## showbackRuleCreateUpdateRule
  ## Create/Update showback rule for billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   ruleName: string (required)
  ##           : Showback rule name
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   showbackRule: JObject (required)
  ##               : Showback rule to create or update.
  var path_564250 = newJObject()
  var query_564251 = newJObject()
  var body_564252 = newJObject()
  add(query_564251, "api-version", newJString(apiVersion))
  add(path_564250, "ruleName", newJString(ruleName))
  add(path_564250, "billingAccountId", newJString(billingAccountId))
  if showbackRule != nil:
    body_564252 = showbackRule
  result = call_564249.call(path_564250, query_564251, nil, nil, body_564252)

var showbackRuleCreateUpdateRule* = Call_ShowbackRuleCreateUpdateRule_564241(
    name: "showbackRuleCreateUpdateRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/showbackRules/{ruleName}",
    validator: validate_ShowbackRuleCreateUpdateRule_564242, base: "",
    url: url_ShowbackRuleCreateUpdateRule_564243, schemes: {Scheme.Https})
type
  Call_ShowbackRuleGetBillingAccountId_564231 = ref object of OpenApiRestCall_563566
proc url_ShowbackRuleGetBillingAccountId_564233(protocol: Scheme; host: string;
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

proc validate_ShowbackRuleGetBillingAccountId_564232(path: JsonNode;
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
  var valid_564234 = path.getOrDefault("ruleName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "ruleName", valid_564234
  var valid_564235 = path.getOrDefault("billingAccountId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "billingAccountId", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564236 = query.getOrDefault("api-version")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "api-version", valid_564236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564237: Call_ShowbackRuleGetBillingAccountId_564231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the showback rule by rule name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564237.validator(path, query, header, formData, body)
  let scheme = call_564237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564237.url(scheme.get, call_564237.host, call_564237.base,
                         call_564237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564237, url, valid)

proc call*(call_564238: Call_ShowbackRuleGetBillingAccountId_564231;
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
  var path_564239 = newJObject()
  var query_564240 = newJObject()
  add(query_564240, "api-version", newJString(apiVersion))
  add(path_564239, "ruleName", newJString(ruleName))
  add(path_564239, "billingAccountId", newJString(billingAccountId))
  result = call_564238.call(path_564239, query_564240, nil, nil, nil)

var showbackRuleGetBillingAccountId* = Call_ShowbackRuleGetBillingAccountId_564231(
    name: "showbackRuleGetBillingAccountId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/showbackRules/{ruleName}",
    validator: validate_ShowbackRuleGetBillingAccountId_564232, base: "",
    url: url_ShowbackRuleGetBillingAccountId_564233, schemes: {Scheme.Https})
type
  Call_CloudConnectorList_564253 = ref object of OpenApiRestCall_563566
proc url_CloudConnectorList_564255(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudConnectorList_564254(path: JsonNode; query: JsonNode;
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
  var valid_564256 = query.getOrDefault("api-version")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "api-version", valid_564256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564257: Call_CloudConnectorList_564253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all cloud connector definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564257.validator(path, query, header, formData, body)
  let scheme = call_564257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564257.url(scheme.get, call_564257.host, call_564257.base,
                         call_564257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564257, url, valid)

proc call*(call_564258: Call_CloudConnectorList_564253; apiVersion: string): Recallable =
  ## cloudConnectorList
  ## List all cloud connector definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_564259 = newJObject()
  add(query_564259, "api-version", newJString(apiVersion))
  result = call_564258.call(nil, query_564259, nil, nil, nil)

var cloudConnectorList* = Call_CloudConnectorList_564253(
    name: "cloudConnectorList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/cloudConnectors",
    validator: validate_CloudConnectorList_564254, base: "",
    url: url_CloudConnectorList_564255, schemes: {Scheme.Https})
type
  Call_CloudConnectorCreateOrUpdate_564270 = ref object of OpenApiRestCall_563566
proc url_CloudConnectorCreateOrUpdate_564272(protocol: Scheme; host: string;
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

proc validate_CloudConnectorCreateOrUpdate_564271(path: JsonNode; query: JsonNode;
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
  var valid_564273 = path.getOrDefault("connectorName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "connectorName", valid_564273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564274 = query.getOrDefault("api-version")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "api-version", valid_564274
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

proc call*(call_564276: Call_CloudConnectorCreateOrUpdate_564270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564276.validator(path, query, header, formData, body)
  let scheme = call_564276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564276.url(scheme.get, call_564276.host, call_564276.base,
                         call_564276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564276, url, valid)

proc call*(call_564277: Call_CloudConnectorCreateOrUpdate_564270;
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
  var path_564278 = newJObject()
  var query_564279 = newJObject()
  var body_564280 = newJObject()
  add(query_564279, "api-version", newJString(apiVersion))
  if connector != nil:
    body_564280 = connector
  add(path_564278, "connectorName", newJString(connectorName))
  result = call_564277.call(path_564278, query_564279, nil, nil, body_564280)

var cloudConnectorCreateOrUpdate* = Call_CloudConnectorCreateOrUpdate_564270(
    name: "cloudConnectorCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorCreateOrUpdate_564271, base: "",
    url: url_CloudConnectorCreateOrUpdate_564272, schemes: {Scheme.Https})
type
  Call_CloudConnectorGet_564260 = ref object of OpenApiRestCall_563566
proc url_CloudConnectorGet_564262(protocol: Scheme; host: string; base: string;
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

proc validate_CloudConnectorGet_564261(path: JsonNode; query: JsonNode;
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
  var valid_564263 = path.getOrDefault("connectorName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "connectorName", valid_564263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $expand: JString
  ##          : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564264 = query.getOrDefault("api-version")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "api-version", valid_564264
  var valid_564265 = query.getOrDefault("$expand")
  valid_564265 = validateParameter(valid_564265, JString, required = false,
                                 default = nil)
  if valid_564265 != nil:
    section.add "$expand", valid_564265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564266: Call_CloudConnectorGet_564260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

proc call*(call_564267: Call_CloudConnectorGet_564260; apiVersion: string;
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
  var path_564268 = newJObject()
  var query_564269 = newJObject()
  add(query_564269, "api-version", newJString(apiVersion))
  add(query_564269, "$expand", newJString(Expand))
  add(path_564268, "connectorName", newJString(connectorName))
  result = call_564267.call(path_564268, query_564269, nil, nil, nil)

var cloudConnectorGet* = Call_CloudConnectorGet_564260(name: "cloudConnectorGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorGet_564261, base: "",
    url: url_CloudConnectorGet_564262, schemes: {Scheme.Https})
type
  Call_CloudConnectorUpdate_564290 = ref object of OpenApiRestCall_563566
proc url_CloudConnectorUpdate_564292(protocol: Scheme; host: string; base: string;
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

proc validate_CloudConnectorUpdate_564291(path: JsonNode; query: JsonNode;
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
  var valid_564293 = path.getOrDefault("connectorName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "connectorName", valid_564293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  ## parameters in `body` object:
  ##   connector: JObject (required)
  ##            : Connector details
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564296: Call_CloudConnectorUpdate_564290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564296.validator(path, query, header, formData, body)
  let scheme = call_564296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564296.url(scheme.get, call_564296.host, call_564296.base,
                         call_564296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564296, url, valid)

proc call*(call_564297: Call_CloudConnectorUpdate_564290; apiVersion: string;
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
  var path_564298 = newJObject()
  var query_564299 = newJObject()
  var body_564300 = newJObject()
  add(query_564299, "api-version", newJString(apiVersion))
  if connector != nil:
    body_564300 = connector
  add(path_564298, "connectorName", newJString(connectorName))
  result = call_564297.call(path_564298, query_564299, nil, nil, body_564300)

var cloudConnectorUpdate* = Call_CloudConnectorUpdate_564290(
    name: "cloudConnectorUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorUpdate_564291, base: "",
    url: url_CloudConnectorUpdate_564292, schemes: {Scheme.Https})
type
  Call_CloudConnectorDelete_564281 = ref object of OpenApiRestCall_563566
proc url_CloudConnectorDelete_564283(protocol: Scheme; host: string; base: string;
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

proc validate_CloudConnectorDelete_564282(path: JsonNode; query: JsonNode;
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
  var valid_564284 = path.getOrDefault("connectorName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "connectorName", valid_564284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564285 = query.getOrDefault("api-version")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "api-version", valid_564285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564286: Call_CloudConnectorDelete_564281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564286.validator(path, query, header, formData, body)
  let scheme = call_564286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564286.url(scheme.get, call_564286.host, call_564286.base,
                         call_564286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564286, url, valid)

proc call*(call_564287: Call_CloudConnectorDelete_564281; apiVersion: string;
          connectorName: string): Recallable =
  ## cloudConnectorDelete
  ## Delete a cloud connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   connectorName: string (required)
  ##                : Connector Name.
  var path_564288 = newJObject()
  var query_564289 = newJObject()
  add(query_564289, "api-version", newJString(apiVersion))
  add(path_564288, "connectorName", newJString(connectorName))
  result = call_564287.call(path_564288, query_564289, nil, nil, nil)

var cloudConnectorDelete* = Call_CloudConnectorDelete_564281(
    name: "cloudConnectorDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorDelete_564282, base: "",
    url: url_CloudConnectorDelete_564283, schemes: {Scheme.Https})
type
  Call_ExternalBillingAccountList_564301 = ref object of OpenApiRestCall_563566
proc url_ExternalBillingAccountList_564303(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ExternalBillingAccountList_564302(path: JsonNode; query: JsonNode;
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

proc call*(call_564305: Call_ExternalBillingAccountList_564301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ExternalBillingAccount definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564305.validator(path, query, header, formData, body)
  let scheme = call_564305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564305.url(scheme.get, call_564305.host, call_564305.base,
                         call_564305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564305, url, valid)

proc call*(call_564306: Call_ExternalBillingAccountList_564301; apiVersion: string): Recallable =
  ## externalBillingAccountList
  ## List all ExternalBillingAccount definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_564307 = newJObject()
  add(query_564307, "api-version", newJString(apiVersion))
  result = call_564306.call(nil, query_564307, nil, nil, nil)

var externalBillingAccountList* = Call_ExternalBillingAccountList_564301(
    name: "externalBillingAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/externalBillingAccounts",
    validator: validate_ExternalBillingAccountList_564302, base: "",
    url: url_ExternalBillingAccountList_564303, schemes: {Scheme.Https})
type
  Call_ExternalBillingAccountGet_564308 = ref object of OpenApiRestCall_563566
proc url_ExternalBillingAccountGet_564310(protocol: Scheme; host: string;
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

proc validate_ExternalBillingAccountGet_564309(path: JsonNode; query: JsonNode;
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
  var valid_564311 = path.getOrDefault("externalBillingAccountName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "externalBillingAccountName", valid_564311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $expand: JString
  ##          : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564312 = query.getOrDefault("api-version")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "api-version", valid_564312
  var valid_564313 = query.getOrDefault("$expand")
  valid_564313 = validateParameter(valid_564313, JString, required = false,
                                 default = nil)
  if valid_564313 != nil:
    section.add "$expand", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_ExternalBillingAccountGet_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a ExternalBillingAccount definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_ExternalBillingAccountGet_564308; apiVersion: string;
          externalBillingAccountName: string; Expand: string = ""): Recallable =
  ## externalBillingAccountGet
  ## Get a ExternalBillingAccount definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Expand: string
  ##         : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  ##   externalBillingAccountName: string (required)
  ##                             : External Billing Account Name. (eg 'aws-{PayerAccountId}')
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(query_564317, "$expand", newJString(Expand))
  add(path_564316, "externalBillingAccountName",
      newJString(externalBillingAccountName))
  result = call_564315.call(path_564316, query_564317, nil, nil, nil)

var externalBillingAccountGet* = Call_ExternalBillingAccountGet_564308(
    name: "externalBillingAccountGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}",
    validator: validate_ExternalBillingAccountGet_564309, base: "",
    url: url_ExternalBillingAccountGet_564310, schemes: {Scheme.Https})
type
  Call_ForecastUsageByExternalBillingAccount_564318 = ref object of OpenApiRestCall_563566
proc url_ForecastUsageByExternalBillingAccount_564320(protocol: Scheme;
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

proc validate_ForecastUsageByExternalBillingAccount_564319(path: JsonNode;
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
  var valid_564321 = path.getOrDefault("externalBillingAccountName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "externalBillingAccountName", valid_564321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564322 = query.getOrDefault("api-version")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "api-version", valid_564322
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

proc call*(call_564324: Call_ForecastUsageByExternalBillingAccount_564318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Forecast the usage data for external billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564324.validator(path, query, header, formData, body)
  let scheme = call_564324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564324.url(scheme.get, call_564324.host, call_564324.base,
                         call_564324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564324, url, valid)

proc call*(call_564325: Call_ForecastUsageByExternalBillingAccount_564318;
          apiVersion: string; externalBillingAccountName: string;
          parameters: JsonNode): Recallable =
  ## forecastUsageByExternalBillingAccount
  ## Forecast the usage data for external billing account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   externalBillingAccountName: string (required)
  ##                             : External Billing Account Name. (eg 'aws-{PayerAccountId}')
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_564326 = newJObject()
  var query_564327 = newJObject()
  var body_564328 = newJObject()
  add(query_564327, "api-version", newJString(apiVersion))
  add(path_564326, "externalBillingAccountName",
      newJString(externalBillingAccountName))
  if parameters != nil:
    body_564328 = parameters
  result = call_564325.call(path_564326, query_564327, nil, nil, body_564328)

var forecastUsageByExternalBillingAccount* = Call_ForecastUsageByExternalBillingAccount_564318(
    name: "forecastUsageByExternalBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}/Forecast",
    validator: validate_ForecastUsageByExternalBillingAccount_564319, base: "",
    url: url_ForecastUsageByExternalBillingAccount_564320, schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionListByExternalBillingAccount_564329 = ref object of OpenApiRestCall_563566
proc url_ExternalSubscriptionListByExternalBillingAccount_564331(
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

proc validate_ExternalSubscriptionListByExternalBillingAccount_564330(
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
  var valid_564332 = path.getOrDefault("externalBillingAccountName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "externalBillingAccountName", valid_564332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564334: Call_ExternalSubscriptionListByExternalBillingAccount_564329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ExternalSubscriptions by ExternalBillingAccount definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564334.validator(path, query, header, formData, body)
  let scheme = call_564334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564334.url(scheme.get, call_564334.host, call_564334.base,
                         call_564334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564334, url, valid)

proc call*(call_564335: Call_ExternalSubscriptionListByExternalBillingAccount_564329;
          apiVersion: string; externalBillingAccountName: string): Recallable =
  ## externalSubscriptionListByExternalBillingAccount
  ## List all ExternalSubscriptions by ExternalBillingAccount definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   externalBillingAccountName: string (required)
  ##                             : External Billing Account Name. (eg 'aws-{PayerAccountId}')
  var path_564336 = newJObject()
  var query_564337 = newJObject()
  add(query_564337, "api-version", newJString(apiVersion))
  add(path_564336, "externalBillingAccountName",
      newJString(externalBillingAccountName))
  result = call_564335.call(path_564336, query_564337, nil, nil, nil)

var externalSubscriptionListByExternalBillingAccount* = Call_ExternalSubscriptionListByExternalBillingAccount_564329(
    name: "externalSubscriptionListByExternalBillingAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}/externalSubscriptions",
    validator: validate_ExternalSubscriptionListByExternalBillingAccount_564330,
    base: "", url: url_ExternalSubscriptionListByExternalBillingAccount_564331,
    schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionList_564338 = ref object of OpenApiRestCall_563566
proc url_ExternalSubscriptionList_564340(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ExternalSubscriptionList_564339(path: JsonNode; query: JsonNode;
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
  var valid_564341 = query.getOrDefault("api-version")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "api-version", valid_564341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564342: Call_ExternalSubscriptionList_564338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ExternalSubscription definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564342.validator(path, query, header, formData, body)
  let scheme = call_564342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564342.url(scheme.get, call_564342.host, call_564342.base,
                         call_564342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564342, url, valid)

proc call*(call_564343: Call_ExternalSubscriptionList_564338; apiVersion: string): Recallable =
  ## externalSubscriptionList
  ## List all ExternalSubscription definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_564344 = newJObject()
  add(query_564344, "api-version", newJString(apiVersion))
  result = call_564343.call(nil, query_564344, nil, nil, nil)

var externalSubscriptionList* = Call_ExternalSubscriptionList_564338(
    name: "externalSubscriptionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/externalSubscriptions",
    validator: validate_ExternalSubscriptionList_564339, base: "",
    url: url_ExternalSubscriptionList_564340, schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionGet_564345 = ref object of OpenApiRestCall_563566
proc url_ExternalSubscriptionGet_564347(protocol: Scheme; host: string; base: string;
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

proc validate_ExternalSubscriptionGet_564346(path: JsonNode; query: JsonNode;
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
  var valid_564348 = path.getOrDefault("externalSubscriptionName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "externalSubscriptionName", valid_564348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $expand: JString
  ##          : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564349 = query.getOrDefault("api-version")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "api-version", valid_564349
  var valid_564350 = query.getOrDefault("$expand")
  valid_564350 = validateParameter(valid_564350, JString, required = false,
                                 default = nil)
  if valid_564350 != nil:
    section.add "$expand", valid_564350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564351: Call_ExternalSubscriptionGet_564345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an ExternalSubscription definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564351.validator(path, query, header, formData, body)
  let scheme = call_564351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564351.url(scheme.get, call_564351.host, call_564351.base,
                         call_564351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564351, url, valid)

proc call*(call_564352: Call_ExternalSubscriptionGet_564345; apiVersion: string;
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
  var path_564353 = newJObject()
  var query_564354 = newJObject()
  add(query_564354, "api-version", newJString(apiVersion))
  add(query_564354, "$expand", newJString(Expand))
  add(path_564353, "externalSubscriptionName",
      newJString(externalSubscriptionName))
  result = call_564352.call(path_564353, query_564354, nil, nil, nil)

var externalSubscriptionGet* = Call_ExternalSubscriptionGet_564345(
    name: "externalSubscriptionGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}",
    validator: validate_ExternalSubscriptionGet_564346, base: "",
    url: url_ExternalSubscriptionGet_564347, schemes: {Scheme.Https})
type
  Call_OperationsList_564355 = ref object of OpenApiRestCall_563566
proc url_OperationsList_564357(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564356(path: JsonNode; query: JsonNode;
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
  var valid_564358 = query.getOrDefault("api-version")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "api-version", valid_564358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564359: Call_OperationsList_564355; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_564359.validator(path, query, header, formData, body)
  let scheme = call_564359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564359.url(scheme.get, call_564359.host, call_564359.base,
                         call_564359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564359, url, valid)

proc call*(call_564360: Call_OperationsList_564355; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_564361 = newJObject()
  add(query_564361, "api-version", newJString(apiVersion))
  result = call_564360.call(nil, query_564361, nil, nil, nil)

var operationsList* = Call_OperationsList_564355(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/operations",
    validator: validate_OperationsList_564356, base: "", url: url_OperationsList_564357,
    schemes: {Scheme.Https})
type
  Call_ForecastUsageByManagementGroup_564362 = ref object of OpenApiRestCall_563566
proc url_ForecastUsageByManagementGroup_564364(protocol: Scheme; host: string;
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

proc validate_ForecastUsageByManagementGroup_564363(path: JsonNode;
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
  var valid_564365 = path.getOrDefault("managementGroupId")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "managementGroupId", valid_564365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564368: Call_ForecastUsageByManagementGroup_564362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for management group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564368.validator(path, query, header, formData, body)
  let scheme = call_564368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564368.url(scheme.get, call_564368.host, call_564368.base,
                         call_564368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564368, url, valid)

proc call*(call_564369: Call_ForecastUsageByManagementGroup_564362;
          managementGroupId: string; apiVersion: string; parameters: JsonNode): Recallable =
  ## forecastUsageByManagementGroup
  ## Lists the usage data for management group.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   managementGroupId: string (required)
  ##                    : ManagementGroup ID
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_564370 = newJObject()
  var query_564371 = newJObject()
  var body_564372 = newJObject()
  add(path_564370, "managementGroupId", newJString(managementGroupId))
  add(query_564371, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564372 = parameters
  result = call_564369.call(path_564370, query_564371, nil, nil, body_564372)

var forecastUsageByManagementGroup* = Call_ForecastUsageByManagementGroup_564362(
    name: "forecastUsageByManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByManagementGroup_564363, base: "",
    url: url_ForecastUsageByManagementGroup_564364, schemes: {Scheme.Https})
type
  Call_QueryUsageByManagementGroup_564373 = ref object of OpenApiRestCall_563566
proc url_QueryUsageByManagementGroup_564375(protocol: Scheme; host: string;
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

proc validate_QueryUsageByManagementGroup_564374(path: JsonNode; query: JsonNode;
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
  var valid_564376 = path.getOrDefault("managementGroupId")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "managementGroupId", valid_564376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564379: Call_QueryUsageByManagementGroup_564373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for management group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564379.validator(path, query, header, formData, body)
  let scheme = call_564379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564379.url(scheme.get, call_564379.host, call_564379.base,
                         call_564379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564379, url, valid)

proc call*(call_564380: Call_QueryUsageByManagementGroup_564373;
          managementGroupId: string; apiVersion: string; parameters: JsonNode): Recallable =
  ## queryUsageByManagementGroup
  ## Lists the usage data for management group.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   managementGroupId: string (required)
  ##                    : ManagementGroup ID
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_564381 = newJObject()
  var query_564382 = newJObject()
  var body_564383 = newJObject()
  add(path_564381, "managementGroupId", newJString(managementGroupId))
  add(query_564382, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564383 = parameters
  result = call_564380.call(path_564381, query_564382, nil, nil, body_564383)

var queryUsageByManagementGroup* = Call_QueryUsageByManagementGroup_564373(
    name: "queryUsageByManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByManagementGroup_564374, base: "",
    url: url_QueryUsageByManagementGroup_564375, schemes: {Scheme.Https})
type
  Call_DimensionsListByManagementGroup_564384 = ref object of OpenApiRestCall_563566
proc url_DimensionsListByManagementGroup_564386(protocol: Scheme; host: string;
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

proc validate_DimensionsListByManagementGroup_564385(path: JsonNode;
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
  var valid_564387 = path.getOrDefault("managementGroupId")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "managementGroupId", valid_564387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N dimension data.
  ##   $expand: JString
  ##          : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564388 = query.getOrDefault("api-version")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "api-version", valid_564388
  var valid_564389 = query.getOrDefault("$top")
  valid_564389 = validateParameter(valid_564389, JInt, required = false, default = nil)
  if valid_564389 != nil:
    section.add "$top", valid_564389
  var valid_564390 = query.getOrDefault("$expand")
  valid_564390 = validateParameter(valid_564390, JString, required = false,
                                 default = nil)
  if valid_564390 != nil:
    section.add "$expand", valid_564390
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

proc call*(call_564393: Call_DimensionsListByManagementGroup_564384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the dimensions by managementGroup Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564393.validator(path, query, header, formData, body)
  let scheme = call_564393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564393.url(scheme.get, call_564393.host, call_564393.base,
                         call_564393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564393, url, valid)

proc call*(call_564394: Call_DimensionsListByManagementGroup_564384;
          managementGroupId: string; apiVersion: string; Top: int = 0;
          Expand: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListByManagementGroup
  ## Lists the dimensions by managementGroup Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   managementGroupId: string (required)
  ##                    : ManagementGroup ID
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_564395 = newJObject()
  var query_564396 = newJObject()
  add(path_564395, "managementGroupId", newJString(managementGroupId))
  add(query_564396, "api-version", newJString(apiVersion))
  add(query_564396, "$top", newJInt(Top))
  add(query_564396, "$expand", newJString(Expand))
  add(query_564396, "$skiptoken", newJString(Skiptoken))
  add(query_564396, "$filter", newJString(Filter))
  result = call_564394.call(path_564395, query_564396, nil, nil, nil)

var dimensionsListByManagementGroup* = Call_DimensionsListByManagementGroup_564384(
    name: "dimensionsListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByManagementGroup_564385, base: "",
    url: url_DimensionsListByManagementGroup_564386, schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionListByManagementGroup_564397 = ref object of OpenApiRestCall_563566
proc url_ExternalSubscriptionListByManagementGroup_564399(protocol: Scheme;
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

proc validate_ExternalSubscriptionListByManagementGroup_564398(path: JsonNode;
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
  var valid_564400 = path.getOrDefault("managementGroupId")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "managementGroupId", valid_564400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $recurse: JBool
  ##           : The $recurse=true query string parameter allows returning externalSubscriptions associated with the specified managementGroup, or any of its descendants.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564401 = query.getOrDefault("api-version")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "api-version", valid_564401
  var valid_564402 = query.getOrDefault("$recurse")
  valid_564402 = validateParameter(valid_564402, JBool, required = false, default = nil)
  if valid_564402 != nil:
    section.add "$recurse", valid_564402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564403: Call_ExternalSubscriptionListByManagementGroup_564397;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ExternalSubscription definitions for Management Group
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564403.validator(path, query, header, formData, body)
  let scheme = call_564403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564403.url(scheme.get, call_564403.host, call_564403.base,
                         call_564403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564403, url, valid)

proc call*(call_564404: Call_ExternalSubscriptionListByManagementGroup_564397;
          managementGroupId: string; apiVersion: string; Recurse: bool = false): Recallable =
  ## externalSubscriptionListByManagementGroup
  ## List all ExternalSubscription definitions for Management Group
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   managementGroupId: string (required)
  ##                    : ManagementGroup ID
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Recurse: bool
  ##          : The $recurse=true query string parameter allows returning externalSubscriptions associated with the specified managementGroup, or any of its descendants.
  var path_564405 = newJObject()
  var query_564406 = newJObject()
  add(path_564405, "managementGroupId", newJString(managementGroupId))
  add(query_564406, "api-version", newJString(apiVersion))
  add(query_564406, "$recurse", newJBool(Recurse))
  result = call_564404.call(path_564405, query_564406, nil, nil, nil)

var externalSubscriptionListByManagementGroup* = Call_ExternalSubscriptionListByManagementGroup_564397(
    name: "externalSubscriptionListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/externalSubscriptions",
    validator: validate_ExternalSubscriptionListByManagementGroup_564398,
    base: "", url: url_ExternalSubscriptionListByManagementGroup_564399,
    schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionUpdateManagementGroup_564407 = ref object of OpenApiRestCall_563566
proc url_ExternalSubscriptionUpdateManagementGroup_564409(protocol: Scheme;
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

proc validate_ExternalSubscriptionUpdateManagementGroup_564408(path: JsonNode;
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
  var valid_564410 = path.getOrDefault("managementGroupId")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "managementGroupId", valid_564410
  var valid_564411 = path.getOrDefault("externalSubscriptionName")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "externalSubscriptionName", valid_564411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564412 = query.getOrDefault("api-version")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "api-version", valid_564412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564413: Call_ExternalSubscriptionUpdateManagementGroup_564407;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the management group of an ExternalSubscription
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564413.validator(path, query, header, formData, body)
  let scheme = call_564413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564413.url(scheme.get, call_564413.host, call_564413.base,
                         call_564413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564413, url, valid)

proc call*(call_564414: Call_ExternalSubscriptionUpdateManagementGroup_564407;
          managementGroupId: string; apiVersion: string;
          externalSubscriptionName: string): Recallable =
  ## externalSubscriptionUpdateManagementGroup
  ## Updates the management group of an ExternalSubscription
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   managementGroupId: string (required)
  ##                    : ManagementGroup ID
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   externalSubscriptionName: string (required)
  ##                           : External Subscription Name. (eg 'aws-{UsageAccountId}')
  var path_564415 = newJObject()
  var query_564416 = newJObject()
  add(path_564415, "managementGroupId", newJString(managementGroupId))
  add(query_564416, "api-version", newJString(apiVersion))
  add(path_564415, "externalSubscriptionName",
      newJString(externalSubscriptionName))
  result = call_564414.call(path_564415, query_564416, nil, nil, nil)

var externalSubscriptionUpdateManagementGroup* = Call_ExternalSubscriptionUpdateManagementGroup_564407(
    name: "externalSubscriptionUpdateManagementGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}",
    validator: validate_ExternalSubscriptionUpdateManagementGroup_564408,
    base: "", url: url_ExternalSubscriptionUpdateManagementGroup_564409,
    schemes: {Scheme.Https})
type
  Call_ForecastUsageBySubscription_564417 = ref object of OpenApiRestCall_563566
proc url_ForecastUsageBySubscription_564419(protocol: Scheme; host: string;
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

proc validate_ForecastUsageBySubscription_564418(path: JsonNode; query: JsonNode;
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
  var valid_564420 = path.getOrDefault("subscriptionId")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "subscriptionId", valid_564420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564421 = query.getOrDefault("api-version")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "api-version", valid_564421
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

proc call*(call_564423: Call_ForecastUsageBySubscription_564417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564423.validator(path, query, header, formData, body)
  let scheme = call_564423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564423.url(scheme.get, call_564423.host, call_564423.base,
                         call_564423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564423, url, valid)

proc call*(call_564424: Call_ForecastUsageBySubscription_564417;
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
  var path_564425 = newJObject()
  var query_564426 = newJObject()
  var body_564427 = newJObject()
  add(query_564426, "api-version", newJString(apiVersion))
  add(path_564425, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564427 = parameters
  result = call_564424.call(path_564425, query_564426, nil, nil, body_564427)

var forecastUsageBySubscription* = Call_ForecastUsageBySubscription_564417(
    name: "forecastUsageBySubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageBySubscription_564418, base: "",
    url: url_ForecastUsageBySubscription_564419, schemes: {Scheme.Https})
type
  Call_QueryUsageBySubscription_564428 = ref object of OpenApiRestCall_563566
proc url_QueryUsageBySubscription_564430(protocol: Scheme; host: string;
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

proc validate_QueryUsageBySubscription_564429(path: JsonNode; query: JsonNode;
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
  var valid_564431 = path.getOrDefault("subscriptionId")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "subscriptionId", valid_564431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564432 = query.getOrDefault("api-version")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "api-version", valid_564432
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

proc call*(call_564434: Call_QueryUsageBySubscription_564428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564434.validator(path, query, header, formData, body)
  let scheme = call_564434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564434.url(scheme.get, call_564434.host, call_564434.base,
                         call_564434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564434, url, valid)

proc call*(call_564435: Call_QueryUsageBySubscription_564428; apiVersion: string;
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
  var path_564436 = newJObject()
  var query_564437 = newJObject()
  var body_564438 = newJObject()
  add(query_564437, "api-version", newJString(apiVersion))
  add(path_564436, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564438 = parameters
  result = call_564435.call(path_564436, query_564437, nil, nil, body_564438)

var queryUsageBySubscription* = Call_QueryUsageBySubscription_564428(
    name: "queryUsageBySubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageBySubscription_564429, base: "",
    url: url_QueryUsageBySubscription_564430, schemes: {Scheme.Https})
type
  Call_DimensionsListBySubscription_564439 = ref object of OpenApiRestCall_563566
proc url_DimensionsListBySubscription_564441(protocol: Scheme; host: string;
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

proc validate_DimensionsListBySubscription_564440(path: JsonNode; query: JsonNode;
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
  var valid_564442 = path.getOrDefault("subscriptionId")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "subscriptionId", valid_564442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N dimension data.
  ##   $expand: JString
  ##          : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564443 = query.getOrDefault("api-version")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "api-version", valid_564443
  var valid_564444 = query.getOrDefault("$top")
  valid_564444 = validateParameter(valid_564444, JInt, required = false, default = nil)
  if valid_564444 != nil:
    section.add "$top", valid_564444
  var valid_564445 = query.getOrDefault("$expand")
  valid_564445 = validateParameter(valid_564445, JString, required = false,
                                 default = nil)
  if valid_564445 != nil:
    section.add "$expand", valid_564445
  var valid_564446 = query.getOrDefault("$skiptoken")
  valid_564446 = validateParameter(valid_564446, JString, required = false,
                                 default = nil)
  if valid_564446 != nil:
    section.add "$skiptoken", valid_564446
  var valid_564447 = query.getOrDefault("$filter")
  valid_564447 = validateParameter(valid_564447, JString, required = false,
                                 default = nil)
  if valid_564447 != nil:
    section.add "$filter", valid_564447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564448: Call_DimensionsListBySubscription_564439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564448.validator(path, query, header, formData, body)
  let scheme = call_564448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564448.url(scheme.get, call_564448.host, call_564448.base,
                         call_564448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564448, url, valid)

proc call*(call_564449: Call_DimensionsListBySubscription_564439;
          apiVersion: string; subscriptionId: string; Top: int = 0; Expand: string = "";
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListBySubscription
  ## Lists the dimensions by subscription Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_564450 = newJObject()
  var query_564451 = newJObject()
  add(query_564451, "api-version", newJString(apiVersion))
  add(query_564451, "$top", newJInt(Top))
  add(query_564451, "$expand", newJString(Expand))
  add(path_564450, "subscriptionId", newJString(subscriptionId))
  add(query_564451, "$skiptoken", newJString(Skiptoken))
  add(query_564451, "$filter", newJString(Filter))
  result = call_564449.call(path_564450, query_564451, nil, nil, nil)

var dimensionsListBySubscription* = Call_DimensionsListBySubscription_564439(
    name: "dimensionsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListBySubscription_564440, base: "",
    url: url_DimensionsListBySubscription_564441, schemes: {Scheme.Https})
type
  Call_DimensionsListByResourceGroup_564452 = ref object of OpenApiRestCall_563566
proc url_DimensionsListByResourceGroup_564454(protocol: Scheme; host: string;
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

proc validate_DimensionsListByResourceGroup_564453(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the dimensions by resource group Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564455 = path.getOrDefault("subscriptionId")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "subscriptionId", valid_564455
  var valid_564456 = path.getOrDefault("resourceGroupName")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "resourceGroupName", valid_564456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N dimension data.
  ##   $expand: JString
  ##          : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564457 = query.getOrDefault("api-version")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "api-version", valid_564457
  var valid_564458 = query.getOrDefault("$top")
  valid_564458 = validateParameter(valid_564458, JInt, required = false, default = nil)
  if valid_564458 != nil:
    section.add "$top", valid_564458
  var valid_564459 = query.getOrDefault("$expand")
  valid_564459 = validateParameter(valid_564459, JString, required = false,
                                 default = nil)
  if valid_564459 != nil:
    section.add "$expand", valid_564459
  var valid_564460 = query.getOrDefault("$skiptoken")
  valid_564460 = validateParameter(valid_564460, JString, required = false,
                                 default = nil)
  if valid_564460 != nil:
    section.add "$skiptoken", valid_564460
  var valid_564461 = query.getOrDefault("$filter")
  valid_564461 = validateParameter(valid_564461, JString, required = false,
                                 default = nil)
  if valid_564461 != nil:
    section.add "$filter", valid_564461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564462: Call_DimensionsListByResourceGroup_564452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by resource group Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564462.validator(path, query, header, formData, body)
  let scheme = call_564462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564462.url(scheme.get, call_564462.host, call_564462.base,
                         call_564462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564462, url, valid)

proc call*(call_564463: Call_DimensionsListByResourceGroup_564452;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Expand: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## dimensionsListByResourceGroup
  ## Lists the dimensions by resource group Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N dimension data.
  ##   Expand: string
  ##         : May be used to expand the properties/data within a dimension category. By default, data is not included when listing dimensions.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   Filter: string
  ##         : May be used to filter dimensions by properties/category, properties/usageStart, properties/usageEnd. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_564464 = newJObject()
  var query_564465 = newJObject()
  add(query_564465, "api-version", newJString(apiVersion))
  add(query_564465, "$top", newJInt(Top))
  add(query_564465, "$expand", newJString(Expand))
  add(path_564464, "subscriptionId", newJString(subscriptionId))
  add(query_564465, "$skiptoken", newJString(Skiptoken))
  add(path_564464, "resourceGroupName", newJString(resourceGroupName))
  add(query_564465, "$filter", newJString(Filter))
  result = call_564463.call(path_564464, query_564465, nil, nil, nil)

var dimensionsListByResourceGroup* = Call_DimensionsListByResourceGroup_564452(
    name: "dimensionsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByResourceGroup_564453, base: "",
    url: url_DimensionsListByResourceGroup_564454, schemes: {Scheme.Https})
type
  Call_ForecastUsageByResourceGroup_564466 = ref object of OpenApiRestCall_563566
proc url_ForecastUsageByResourceGroup_564468(protocol: Scheme; host: string;
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

proc validate_ForecastUsageByResourceGroup_564467(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Forecast the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564469 = path.getOrDefault("subscriptionId")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "subscriptionId", valid_564469
  var valid_564470 = path.getOrDefault("resourceGroupName")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "resourceGroupName", valid_564470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564471 = query.getOrDefault("api-version")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "api-version", valid_564471
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

proc call*(call_564473: Call_ForecastUsageByResourceGroup_564466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564473.validator(path, query, header, formData, body)
  let scheme = call_564473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564473.url(scheme.get, call_564473.host, call_564473.base,
                         call_564473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564473, url, valid)

proc call*(call_564474: Call_ForecastUsageByResourceGroup_564466;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## forecastUsageByResourceGroup
  ## Forecast the usage data for subscriptionId and resource group.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_564475 = newJObject()
  var query_564476 = newJObject()
  var body_564477 = newJObject()
  add(query_564476, "api-version", newJString(apiVersion))
  add(path_564475, "subscriptionId", newJString(subscriptionId))
  add(path_564475, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564477 = parameters
  result = call_564474.call(path_564475, query_564476, nil, nil, body_564477)

var forecastUsageByResourceGroup* = Call_ForecastUsageByResourceGroup_564466(
    name: "forecastUsageByResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByResourceGroup_564467, base: "",
    url: url_ForecastUsageByResourceGroup_564468, schemes: {Scheme.Https})
type
  Call_QueryUsageByResourceGroup_564478 = ref object of OpenApiRestCall_563566
proc url_QueryUsageByResourceGroup_564480(protocol: Scheme; host: string;
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

proc validate_QueryUsageByResourceGroup_564479(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564481 = path.getOrDefault("subscriptionId")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "subscriptionId", valid_564481
  var valid_564482 = path.getOrDefault("resourceGroupName")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "resourceGroupName", valid_564482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564485: Call_QueryUsageByResourceGroup_564478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564485.validator(path, query, header, formData, body)
  let scheme = call_564485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564485.url(scheme.get, call_564485.host, call_564485.base,
                         call_564485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564485, url, valid)

proc call*(call_564486: Call_QueryUsageByResourceGroup_564478; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## queryUsageByResourceGroup
  ## Query the usage data for subscriptionId and resource group.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report Config operation.
  var path_564487 = newJObject()
  var query_564488 = newJObject()
  var body_564489 = newJObject()
  add(query_564488, "api-version", newJString(apiVersion))
  add(path_564487, "subscriptionId", newJString(subscriptionId))
  add(path_564487, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564489 = parameters
  result = call_564486.call(path_564487, query_564488, nil, nil, body_564489)

var queryUsageByResourceGroup* = Call_QueryUsageByResourceGroup_564478(
    name: "queryUsageByResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByResourceGroup_564479, base: "",
    url: url_QueryUsageByResourceGroup_564480, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
