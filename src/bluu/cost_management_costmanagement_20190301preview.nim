
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593439 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593439](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593439): Option[Scheme] {.used.} =
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
  macServiceName = "cost-management-costmanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ForecastUsageByDepartment_593661 = ref object of OpenApiRestCall_593439
proc url_ForecastUsageByDepartment_593663(protocol: Scheme; host: string;
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

proc validate_ForecastUsageByDepartment_593662(path: JsonNode; query: JsonNode;
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
  var valid_593853 = path.getOrDefault("billingAccountId")
  valid_593853 = validateParameter(valid_593853, JString, required = true,
                                 default = nil)
  if valid_593853 != nil:
    section.add "billingAccountId", valid_593853
  var valid_593854 = path.getOrDefault("departmentId")
  valid_593854 = validateParameter(valid_593854, JString, required = true,
                                 default = nil)
  if valid_593854 != nil:
    section.add "departmentId", valid_593854
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593855 = query.getOrDefault("api-version")
  valid_593855 = validateParameter(valid_593855, JString, required = true,
                                 default = nil)
  if valid_593855 != nil:
    section.add "api-version", valid_593855
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

proc call*(call_593879: Call_ForecastUsageByDepartment_593661; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_593879.validator(path, query, header, formData, body)
  let scheme = call_593879.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593879.url(scheme.get, call_593879.host, call_593879.base,
                         call_593879.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593879, url, valid)

proc call*(call_593950: Call_ForecastUsageByDepartment_593661; apiVersion: string;
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
  var path_593951 = newJObject()
  var query_593953 = newJObject()
  var body_593954 = newJObject()
  add(query_593953, "api-version", newJString(apiVersion))
  add(path_593951, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_593954 = parameters
  add(path_593951, "departmentId", newJString(departmentId))
  result = call_593950.call(path_593951, query_593953, nil, nil, body_593954)

var forecastUsageByDepartment* = Call_ForecastUsageByDepartment_593661(
    name: "forecastUsageByDepartment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByDepartment_593662, base: "",
    url: url_ForecastUsageByDepartment_593663, schemes: {Scheme.Https})
type
  Call_QueryUsageByDepartment_593993 = ref object of OpenApiRestCall_593439
proc url_QueryUsageByDepartment_593995(protocol: Scheme; host: string; base: string;
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

proc validate_QueryUsageByDepartment_593994(path: JsonNode; query: JsonNode;
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
  var valid_593996 = path.getOrDefault("billingAccountId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "billingAccountId", valid_593996
  var valid_593997 = path.getOrDefault("departmentId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "departmentId", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "api-version", valid_593998
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

proc call*(call_594000: Call_QueryUsageByDepartment_593993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_QueryUsageByDepartment_593993; apiVersion: string;
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
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  var body_594004 = newJObject()
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_594004 = parameters
  add(path_594002, "departmentId", newJString(departmentId))
  result = call_594001.call(path_594002, query_594003, nil, nil, body_594004)

var queryUsageByDepartment* = Call_QueryUsageByDepartment_593993(
    name: "queryUsageByDepartment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByDepartment_593994, base: "",
    url: url_QueryUsageByDepartment_593995, schemes: {Scheme.Https})
type
  Call_DimensionsListByDepartment_594005 = ref object of OpenApiRestCall_593439
proc url_DimensionsListByDepartment_594007(protocol: Scheme; host: string;
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

proc validate_DimensionsListByDepartment_594006(path: JsonNode; query: JsonNode;
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
  var valid_594009 = path.getOrDefault("billingAccountId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "billingAccountId", valid_594009
  var valid_594010 = path.getOrDefault("departmentId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "departmentId", valid_594010
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
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "api-version", valid_594011
  var valid_594012 = query.getOrDefault("$expand")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "$expand", valid_594012
  var valid_594013 = query.getOrDefault("$top")
  valid_594013 = validateParameter(valid_594013, JInt, required = false, default = nil)
  if valid_594013 != nil:
    section.add "$top", valid_594013
  var valid_594014 = query.getOrDefault("$skiptoken")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "$skiptoken", valid_594014
  var valid_594015 = query.getOrDefault("$filter")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "$filter", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_DimensionsListByDepartment_594005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by Department Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_DimensionsListByDepartment_594005; apiVersion: string;
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
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  add(query_594019, "api-version", newJString(apiVersion))
  add(query_594019, "$expand", newJString(Expand))
  add(query_594019, "$top", newJInt(Top))
  add(query_594019, "$skiptoken", newJString(Skiptoken))
  add(path_594018, "billingAccountId", newJString(billingAccountId))
  add(path_594018, "departmentId", newJString(departmentId))
  add(query_594019, "$filter", newJString(Filter))
  result = call_594017.call(path_594018, query_594019, nil, nil, nil)

var dimensionsListByDepartment* = Call_DimensionsListByDepartment_594005(
    name: "dimensionsListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByDepartment_594006, base: "",
    url: url_DimensionsListByDepartment_594007, schemes: {Scheme.Https})
type
  Call_ForecastUsageByEnrollmentAccount_594020 = ref object of OpenApiRestCall_593439
proc url_ForecastUsageByEnrollmentAccount_594022(protocol: Scheme; host: string;
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

proc validate_ForecastUsageByEnrollmentAccount_594021(path: JsonNode;
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
  var valid_594023 = path.getOrDefault("enrollmentAccountId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "enrollmentAccountId", valid_594023
  var valid_594024 = path.getOrDefault("billingAccountId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "billingAccountId", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
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

proc call*(call_594027: Call_ForecastUsageByEnrollmentAccount_594020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Forecast the usage data for an enrollment account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_ForecastUsageByEnrollmentAccount_594020;
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
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  var body_594031 = newJObject()
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_594029, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_594031 = parameters
  result = call_594028.call(path_594029, query_594030, nil, nil, body_594031)

var forecastUsageByEnrollmentAccount* = Call_ForecastUsageByEnrollmentAccount_594020(
    name: "forecastUsageByEnrollmentAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByEnrollmentAccount_594021, base: "",
    url: url_ForecastUsageByEnrollmentAccount_594022, schemes: {Scheme.Https})
type
  Call_QueryUsageByEnrollmentAccount_594032 = ref object of OpenApiRestCall_593439
proc url_QueryUsageByEnrollmentAccount_594034(protocol: Scheme; host: string;
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

proc validate_QueryUsageByEnrollmentAccount_594033(path: JsonNode; query: JsonNode;
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
  var valid_594035 = path.getOrDefault("enrollmentAccountId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "enrollmentAccountId", valid_594035
  var valid_594036 = path.getOrDefault("billingAccountId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "billingAccountId", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "api-version", valid_594037
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

proc call*(call_594039: Call_QueryUsageByEnrollmentAccount_594032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for an enrollment account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_QueryUsageByEnrollmentAccount_594032;
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
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  var body_594043 = newJObject()
  add(query_594042, "api-version", newJString(apiVersion))
  add(path_594041, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_594041, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_594043 = parameters
  result = call_594040.call(path_594041, query_594042, nil, nil, body_594043)

var queryUsageByEnrollmentAccount* = Call_QueryUsageByEnrollmentAccount_594032(
    name: "queryUsageByEnrollmentAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByEnrollmentAccount_594033, base: "",
    url: url_QueryUsageByEnrollmentAccount_594034, schemes: {Scheme.Https})
type
  Call_DimensionsListByEnrollmentAccount_594044 = ref object of OpenApiRestCall_593439
proc url_DimensionsListByEnrollmentAccount_594046(protocol: Scheme; host: string;
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

proc validate_DimensionsListByEnrollmentAccount_594045(path: JsonNode;
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
  var valid_594047 = path.getOrDefault("enrollmentAccountId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "enrollmentAccountId", valid_594047
  var valid_594048 = path.getOrDefault("billingAccountId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "billingAccountId", valid_594048
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
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "api-version", valid_594049
  var valid_594050 = query.getOrDefault("$expand")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "$expand", valid_594050
  var valid_594051 = query.getOrDefault("$top")
  valid_594051 = validateParameter(valid_594051, JInt, required = false, default = nil)
  if valid_594051 != nil:
    section.add "$top", valid_594051
  var valid_594052 = query.getOrDefault("$skiptoken")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "$skiptoken", valid_594052
  var valid_594053 = query.getOrDefault("$filter")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "$filter", valid_594053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594054: Call_DimensionsListByEnrollmentAccount_594044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the dimensions by Enrollment Account Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_DimensionsListByEnrollmentAccount_594044;
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
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  add(query_594057, "api-version", newJString(apiVersion))
  add(query_594057, "$expand", newJString(Expand))
  add(query_594057, "$top", newJInt(Top))
  add(query_594057, "$skiptoken", newJString(Skiptoken))
  add(path_594056, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_594056, "billingAccountId", newJString(billingAccountId))
  add(query_594057, "$filter", newJString(Filter))
  result = call_594055.call(path_594056, query_594057, nil, nil, nil)

var dimensionsListByEnrollmentAccount* = Call_DimensionsListByEnrollmentAccount_594044(
    name: "dimensionsListByEnrollmentAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByEnrollmentAccount_594045, base: "",
    url: url_DimensionsListByEnrollmentAccount_594046, schemes: {Scheme.Https})
type
  Call_ForecastUsageByBillingAccount_594058 = ref object of OpenApiRestCall_593439
proc url_ForecastUsageByBillingAccount_594060(protocol: Scheme; host: string;
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

proc validate_ForecastUsageByBillingAccount_594059(path: JsonNode; query: JsonNode;
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
  var valid_594061 = path.getOrDefault("billingAccountId")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "billingAccountId", valid_594061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594062 = query.getOrDefault("api-version")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "api-version", valid_594062
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

proc call*(call_594064: Call_ForecastUsageByBillingAccount_594058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_ForecastUsageByBillingAccount_594058;
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
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  var body_594068 = newJObject()
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_594068 = parameters
  result = call_594065.call(path_594066, query_594067, nil, nil, body_594068)

var forecastUsageByBillingAccount* = Call_ForecastUsageByBillingAccount_594058(
    name: "forecastUsageByBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByBillingAccount_594059, base: "",
    url: url_ForecastUsageByBillingAccount_594060, schemes: {Scheme.Https})
type
  Call_QueryUsageByBillingAccount_594069 = ref object of OpenApiRestCall_593439
proc url_QueryUsageByBillingAccount_594071(protocol: Scheme; host: string;
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

proc validate_QueryUsageByBillingAccount_594070(path: JsonNode; query: JsonNode;
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
  var valid_594072 = path.getOrDefault("billingAccountId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "billingAccountId", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594073 = query.getOrDefault("api-version")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "api-version", valid_594073
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

proc call*(call_594075: Call_QueryUsageByBillingAccount_594069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_QueryUsageByBillingAccount_594069; apiVersion: string;
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
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  var body_594079 = newJObject()
  add(query_594078, "api-version", newJString(apiVersion))
  add(path_594077, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_594079 = parameters
  result = call_594076.call(path_594077, query_594078, nil, nil, body_594079)

var queryUsageByBillingAccount* = Call_QueryUsageByBillingAccount_594069(
    name: "queryUsageByBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByBillingAccount_594070, base: "",
    url: url_QueryUsageByBillingAccount_594071, schemes: {Scheme.Https})
type
  Call_DimensionsListByBillingAccount_594080 = ref object of OpenApiRestCall_593439
proc url_DimensionsListByBillingAccount_594082(protocol: Scheme; host: string;
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

proc validate_DimensionsListByBillingAccount_594081(path: JsonNode;
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
  var valid_594083 = path.getOrDefault("billingAccountId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "billingAccountId", valid_594083
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
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
  var valid_594085 = query.getOrDefault("$expand")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "$expand", valid_594085
  var valid_594086 = query.getOrDefault("$top")
  valid_594086 = validateParameter(valid_594086, JInt, required = false, default = nil)
  if valid_594086 != nil:
    section.add "$top", valid_594086
  var valid_594087 = query.getOrDefault("$skiptoken")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "$skiptoken", valid_594087
  var valid_594088 = query.getOrDefault("$filter")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "$filter", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_DimensionsListByBillingAccount_594080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by billingAccount Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_DimensionsListByBillingAccount_594080;
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
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  add(query_594092, "api-version", newJString(apiVersion))
  add(query_594092, "$expand", newJString(Expand))
  add(query_594092, "$top", newJInt(Top))
  add(query_594092, "$skiptoken", newJString(Skiptoken))
  add(path_594091, "billingAccountId", newJString(billingAccountId))
  add(query_594092, "$filter", newJString(Filter))
  result = call_594090.call(path_594091, query_594092, nil, nil, nil)

var dimensionsListByBillingAccount* = Call_DimensionsListByBillingAccount_594080(
    name: "dimensionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByBillingAccount_594081, base: "",
    url: url_DimensionsListByBillingAccount_594082, schemes: {Scheme.Https})
type
  Call_ShowbackRulesList_594093 = ref object of OpenApiRestCall_593439
proc url_ShowbackRulesList_594095(protocol: Scheme; host: string; base: string;
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

proc validate_ShowbackRulesList_594094(path: JsonNode; query: JsonNode;
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
  var valid_594096 = path.getOrDefault("billingAccountId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "billingAccountId", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594097 = query.getOrDefault("api-version")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "api-version", valid_594097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_ShowbackRulesList_594093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get list all Showback Rules.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_ShowbackRulesList_594093; apiVersion: string;
          billingAccountId: string): Recallable =
  ## showbackRulesList
  ## Get list all Showback Rules.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  add(query_594101, "api-version", newJString(apiVersion))
  add(path_594100, "billingAccountId", newJString(billingAccountId))
  result = call_594099.call(path_594100, query_594101, nil, nil, nil)

var showbackRulesList* = Call_ShowbackRulesList_594093(name: "showbackRulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/showbackRules",
    validator: validate_ShowbackRulesList_594094, base: "",
    url: url_ShowbackRulesList_594095, schemes: {Scheme.Https})
type
  Call_ShowbackRuleCreateUpdateRule_594112 = ref object of OpenApiRestCall_593439
proc url_ShowbackRuleCreateUpdateRule_594114(protocol: Scheme; host: string;
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

proc validate_ShowbackRuleCreateUpdateRule_594113(path: JsonNode; query: JsonNode;
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
  var valid_594115 = path.getOrDefault("ruleName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "ruleName", valid_594115
  var valid_594116 = path.getOrDefault("billingAccountId")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "billingAccountId", valid_594116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594117 = query.getOrDefault("api-version")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "api-version", valid_594117
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

proc call*(call_594119: Call_ShowbackRuleCreateUpdateRule_594112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create/Update showback rule for billing account.
  ## 
  let valid = call_594119.validator(path, query, header, formData, body)
  let scheme = call_594119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594119.url(scheme.get, call_594119.host, call_594119.base,
                         call_594119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594119, url, valid)

proc call*(call_594120: Call_ShowbackRuleCreateUpdateRule_594112;
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
  var path_594121 = newJObject()
  var query_594122 = newJObject()
  var body_594123 = newJObject()
  if showbackRule != nil:
    body_594123 = showbackRule
  add(query_594122, "api-version", newJString(apiVersion))
  add(path_594121, "ruleName", newJString(ruleName))
  add(path_594121, "billingAccountId", newJString(billingAccountId))
  result = call_594120.call(path_594121, query_594122, nil, nil, body_594123)

var showbackRuleCreateUpdateRule* = Call_ShowbackRuleCreateUpdateRule_594112(
    name: "showbackRuleCreateUpdateRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/showbackRules/{ruleName}",
    validator: validate_ShowbackRuleCreateUpdateRule_594113, base: "",
    url: url_ShowbackRuleCreateUpdateRule_594114, schemes: {Scheme.Https})
type
  Call_ShowbackRuleGetBillingAccountId_594102 = ref object of OpenApiRestCall_593439
proc url_ShowbackRuleGetBillingAccountId_594104(protocol: Scheme; host: string;
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

proc validate_ShowbackRuleGetBillingAccountId_594103(path: JsonNode;
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
  var valid_594105 = path.getOrDefault("ruleName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "ruleName", valid_594105
  var valid_594106 = path.getOrDefault("billingAccountId")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "billingAccountId", valid_594106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594107 = query.getOrDefault("api-version")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "api-version", valid_594107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594108: Call_ShowbackRuleGetBillingAccountId_594102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the showback rule by rule name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594108.validator(path, query, header, formData, body)
  let scheme = call_594108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594108.url(scheme.get, call_594108.host, call_594108.base,
                         call_594108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594108, url, valid)

proc call*(call_594109: Call_ShowbackRuleGetBillingAccountId_594102;
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
  var path_594110 = newJObject()
  var query_594111 = newJObject()
  add(query_594111, "api-version", newJString(apiVersion))
  add(path_594110, "ruleName", newJString(ruleName))
  add(path_594110, "billingAccountId", newJString(billingAccountId))
  result = call_594109.call(path_594110, query_594111, nil, nil, nil)

var showbackRuleGetBillingAccountId* = Call_ShowbackRuleGetBillingAccountId_594102(
    name: "showbackRuleGetBillingAccountId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/showbackRules/{ruleName}",
    validator: validate_ShowbackRuleGetBillingAccountId_594103, base: "",
    url: url_ShowbackRuleGetBillingAccountId_594104, schemes: {Scheme.Https})
type
  Call_CloudConnectorList_594124 = ref object of OpenApiRestCall_593439
proc url_CloudConnectorList_594126(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudConnectorList_594125(path: JsonNode; query: JsonNode;
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
  var valid_594127 = query.getOrDefault("api-version")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "api-version", valid_594127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_CloudConnectorList_594124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all cloud connector definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_CloudConnectorList_594124; apiVersion: string): Recallable =
  ## cloudConnectorList
  ## List all cloud connector definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_594130 = newJObject()
  add(query_594130, "api-version", newJString(apiVersion))
  result = call_594129.call(nil, query_594130, nil, nil, nil)

var cloudConnectorList* = Call_CloudConnectorList_594124(
    name: "cloudConnectorList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/cloudConnectors",
    validator: validate_CloudConnectorList_594125, base: "",
    url: url_CloudConnectorList_594126, schemes: {Scheme.Https})
type
  Call_CloudConnectorCreateOrUpdate_594141 = ref object of OpenApiRestCall_593439
proc url_CloudConnectorCreateOrUpdate_594143(protocol: Scheme; host: string;
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

proc validate_CloudConnectorCreateOrUpdate_594142(path: JsonNode; query: JsonNode;
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
  var valid_594144 = path.getOrDefault("connectorName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "connectorName", valid_594144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594145 = query.getOrDefault("api-version")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "api-version", valid_594145
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

proc call*(call_594147: Call_CloudConnectorCreateOrUpdate_594141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_CloudConnectorCreateOrUpdate_594141;
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
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  var body_594151 = newJObject()
  add(query_594150, "api-version", newJString(apiVersion))
  if connector != nil:
    body_594151 = connector
  add(path_594149, "connectorName", newJString(connectorName))
  result = call_594148.call(path_594149, query_594150, nil, nil, body_594151)

var cloudConnectorCreateOrUpdate* = Call_CloudConnectorCreateOrUpdate_594141(
    name: "cloudConnectorCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorCreateOrUpdate_594142, base: "",
    url: url_CloudConnectorCreateOrUpdate_594143, schemes: {Scheme.Https})
type
  Call_CloudConnectorGet_594131 = ref object of OpenApiRestCall_593439
proc url_CloudConnectorGet_594133(protocol: Scheme; host: string; base: string;
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

proc validate_CloudConnectorGet_594132(path: JsonNode; query: JsonNode;
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
  var valid_594134 = path.getOrDefault("connectorName")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "connectorName", valid_594134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $expand: JString
  ##          : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594135 = query.getOrDefault("api-version")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "api-version", valid_594135
  var valid_594136 = query.getOrDefault("$expand")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "$expand", valid_594136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594137: Call_CloudConnectorGet_594131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594137.validator(path, query, header, formData, body)
  let scheme = call_594137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594137.url(scheme.get, call_594137.host, call_594137.base,
                         call_594137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594137, url, valid)

proc call*(call_594138: Call_CloudConnectorGet_594131; apiVersion: string;
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
  var path_594139 = newJObject()
  var query_594140 = newJObject()
  add(query_594140, "api-version", newJString(apiVersion))
  add(query_594140, "$expand", newJString(Expand))
  add(path_594139, "connectorName", newJString(connectorName))
  result = call_594138.call(path_594139, query_594140, nil, nil, nil)

var cloudConnectorGet* = Call_CloudConnectorGet_594131(name: "cloudConnectorGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorGet_594132, base: "",
    url: url_CloudConnectorGet_594133, schemes: {Scheme.Https})
type
  Call_CloudConnectorUpdate_594161 = ref object of OpenApiRestCall_593439
proc url_CloudConnectorUpdate_594163(protocol: Scheme; host: string; base: string;
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

proc validate_CloudConnectorUpdate_594162(path: JsonNode; query: JsonNode;
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
  var valid_594164 = path.getOrDefault("connectorName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "connectorName", valid_594164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594165 = query.getOrDefault("api-version")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "api-version", valid_594165
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

proc call*(call_594167: Call_CloudConnectorUpdate_594161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594167.validator(path, query, header, formData, body)
  let scheme = call_594167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594167.url(scheme.get, call_594167.host, call_594167.base,
                         call_594167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594167, url, valid)

proc call*(call_594168: Call_CloudConnectorUpdate_594161; apiVersion: string;
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
  var path_594169 = newJObject()
  var query_594170 = newJObject()
  var body_594171 = newJObject()
  add(query_594170, "api-version", newJString(apiVersion))
  if connector != nil:
    body_594171 = connector
  add(path_594169, "connectorName", newJString(connectorName))
  result = call_594168.call(path_594169, query_594170, nil, nil, body_594171)

var cloudConnectorUpdate* = Call_CloudConnectorUpdate_594161(
    name: "cloudConnectorUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorUpdate_594162, base: "",
    url: url_CloudConnectorUpdate_594163, schemes: {Scheme.Https})
type
  Call_CloudConnectorDelete_594152 = ref object of OpenApiRestCall_593439
proc url_CloudConnectorDelete_594154(protocol: Scheme; host: string; base: string;
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

proc validate_CloudConnectorDelete_594153(path: JsonNode; query: JsonNode;
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
  var valid_594155 = path.getOrDefault("connectorName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "connectorName", valid_594155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594156 = query.getOrDefault("api-version")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "api-version", valid_594156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594157: Call_CloudConnectorDelete_594152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a cloud connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594157.validator(path, query, header, formData, body)
  let scheme = call_594157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594157.url(scheme.get, call_594157.host, call_594157.base,
                         call_594157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594157, url, valid)

proc call*(call_594158: Call_CloudConnectorDelete_594152; apiVersion: string;
          connectorName: string): Recallable =
  ## cloudConnectorDelete
  ## Delete a cloud connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   connectorName: string (required)
  ##                : Connector Name.
  var path_594159 = newJObject()
  var query_594160 = newJObject()
  add(query_594160, "api-version", newJString(apiVersion))
  add(path_594159, "connectorName", newJString(connectorName))
  result = call_594158.call(path_594159, query_594160, nil, nil, nil)

var cloudConnectorDelete* = Call_CloudConnectorDelete_594152(
    name: "cloudConnectorDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/cloudConnectors/{connectorName}",
    validator: validate_CloudConnectorDelete_594153, base: "",
    url: url_CloudConnectorDelete_594154, schemes: {Scheme.Https})
type
  Call_ExternalBillingAccountList_594172 = ref object of OpenApiRestCall_593439
proc url_ExternalBillingAccountList_594174(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ExternalBillingAccountList_594173(path: JsonNode; query: JsonNode;
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
  var valid_594175 = query.getOrDefault("api-version")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "api-version", valid_594175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594176: Call_ExternalBillingAccountList_594172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ExternalBillingAccount definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_ExternalBillingAccountList_594172; apiVersion: string): Recallable =
  ## externalBillingAccountList
  ## List all ExternalBillingAccount definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_594178 = newJObject()
  add(query_594178, "api-version", newJString(apiVersion))
  result = call_594177.call(nil, query_594178, nil, nil, nil)

var externalBillingAccountList* = Call_ExternalBillingAccountList_594172(
    name: "externalBillingAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/externalBillingAccounts",
    validator: validate_ExternalBillingAccountList_594173, base: "",
    url: url_ExternalBillingAccountList_594174, schemes: {Scheme.Https})
type
  Call_ExternalBillingAccountGet_594179 = ref object of OpenApiRestCall_593439
proc url_ExternalBillingAccountGet_594181(protocol: Scheme; host: string;
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

proc validate_ExternalBillingAccountGet_594180(path: JsonNode; query: JsonNode;
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
  var valid_594182 = path.getOrDefault("externalBillingAccountName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "externalBillingAccountName", valid_594182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $expand: JString
  ##          : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594183 = query.getOrDefault("api-version")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "api-version", valid_594183
  var valid_594184 = query.getOrDefault("$expand")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "$expand", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_ExternalBillingAccountGet_594179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a ExternalBillingAccount definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_ExternalBillingAccountGet_594179;
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
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(path_594187, "externalBillingAccountName",
      newJString(externalBillingAccountName))
  add(query_594188, "api-version", newJString(apiVersion))
  add(query_594188, "$expand", newJString(Expand))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var externalBillingAccountGet* = Call_ExternalBillingAccountGet_594179(
    name: "externalBillingAccountGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}",
    validator: validate_ExternalBillingAccountGet_594180, base: "",
    url: url_ExternalBillingAccountGet_594181, schemes: {Scheme.Https})
type
  Call_ForecastUsageByExternalBillingAccount_594189 = ref object of OpenApiRestCall_593439
proc url_ForecastUsageByExternalBillingAccount_594191(protocol: Scheme;
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

proc validate_ForecastUsageByExternalBillingAccount_594190(path: JsonNode;
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
  var valid_594192 = path.getOrDefault("externalBillingAccountName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "externalBillingAccountName", valid_594192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594193 = query.getOrDefault("api-version")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "api-version", valid_594193
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

proc call*(call_594195: Call_ForecastUsageByExternalBillingAccount_594189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Forecast the usage data for external billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594195.validator(path, query, header, formData, body)
  let scheme = call_594195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594195.url(scheme.get, call_594195.host, call_594195.base,
                         call_594195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594195, url, valid)

proc call*(call_594196: Call_ForecastUsageByExternalBillingAccount_594189;
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
  var path_594197 = newJObject()
  var query_594198 = newJObject()
  var body_594199 = newJObject()
  add(path_594197, "externalBillingAccountName",
      newJString(externalBillingAccountName))
  add(query_594198, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594199 = parameters
  result = call_594196.call(path_594197, query_594198, nil, nil, body_594199)

var forecastUsageByExternalBillingAccount* = Call_ForecastUsageByExternalBillingAccount_594189(
    name: "forecastUsageByExternalBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}/Forecast",
    validator: validate_ForecastUsageByExternalBillingAccount_594190, base: "",
    url: url_ForecastUsageByExternalBillingAccount_594191, schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionListByExternalBillingAccount_594200 = ref object of OpenApiRestCall_593439
proc url_ExternalSubscriptionListByExternalBillingAccount_594202(
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

proc validate_ExternalSubscriptionListByExternalBillingAccount_594201(
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
  var valid_594203 = path.getOrDefault("externalBillingAccountName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "externalBillingAccountName", valid_594203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594204 = query.getOrDefault("api-version")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "api-version", valid_594204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594205: Call_ExternalSubscriptionListByExternalBillingAccount_594200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ExternalSubscriptions by ExternalBillingAccount definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_ExternalSubscriptionListByExternalBillingAccount_594200;
          externalBillingAccountName: string; apiVersion: string): Recallable =
  ## externalSubscriptionListByExternalBillingAccount
  ## List all ExternalSubscriptions by ExternalBillingAccount definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   externalBillingAccountName: string (required)
  ##                             : External Billing Account Name. (eg 'aws-{PayerAccountId}')
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  add(path_594207, "externalBillingAccountName",
      newJString(externalBillingAccountName))
  add(query_594208, "api-version", newJString(apiVersion))
  result = call_594206.call(path_594207, query_594208, nil, nil, nil)

var externalSubscriptionListByExternalBillingAccount* = Call_ExternalSubscriptionListByExternalBillingAccount_594200(
    name: "externalSubscriptionListByExternalBillingAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalBillingAccounts/{externalBillingAccountName}/externalSubscriptions",
    validator: validate_ExternalSubscriptionListByExternalBillingAccount_594201,
    base: "", url: url_ExternalSubscriptionListByExternalBillingAccount_594202,
    schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionList_594209 = ref object of OpenApiRestCall_593439
proc url_ExternalSubscriptionList_594211(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ExternalSubscriptionList_594210(path: JsonNode; query: JsonNode;
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

proc call*(call_594213: Call_ExternalSubscriptionList_594209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ExternalSubscription definitions
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594213.validator(path, query, header, formData, body)
  let scheme = call_594213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594213.url(scheme.get, call_594213.host, call_594213.base,
                         call_594213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594213, url, valid)

proc call*(call_594214: Call_ExternalSubscriptionList_594209; apiVersion: string): Recallable =
  ## externalSubscriptionList
  ## List all ExternalSubscription definitions
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_594215 = newJObject()
  add(query_594215, "api-version", newJString(apiVersion))
  result = call_594214.call(nil, query_594215, nil, nil, nil)

var externalSubscriptionList* = Call_ExternalSubscriptionList_594209(
    name: "externalSubscriptionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/externalSubscriptions",
    validator: validate_ExternalSubscriptionList_594210, base: "",
    url: url_ExternalSubscriptionList_594211, schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionGet_594216 = ref object of OpenApiRestCall_593439
proc url_ExternalSubscriptionGet_594218(protocol: Scheme; host: string; base: string;
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

proc validate_ExternalSubscriptionGet_594217(path: JsonNode; query: JsonNode;
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
  var valid_594219 = path.getOrDefault("externalSubscriptionName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "externalSubscriptionName", valid_594219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $expand: JString
  ##          : May be used to expand the collectionInfo property. By default, collectionInfo is not included.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594220 = query.getOrDefault("api-version")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "api-version", valid_594220
  var valid_594221 = query.getOrDefault("$expand")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "$expand", valid_594221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594222: Call_ExternalSubscriptionGet_594216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an ExternalSubscription definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_ExternalSubscriptionGet_594216; apiVersion: string;
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
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  add(query_594225, "api-version", newJString(apiVersion))
  add(query_594225, "$expand", newJString(Expand))
  add(path_594224, "externalSubscriptionName",
      newJString(externalSubscriptionName))
  result = call_594223.call(path_594224, query_594225, nil, nil, nil)

var externalSubscriptionGet* = Call_ExternalSubscriptionGet_594216(
    name: "externalSubscriptionGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}",
    validator: validate_ExternalSubscriptionGet_594217, base: "",
    url: url_ExternalSubscriptionGet_594218, schemes: {Scheme.Https})
type
  Call_OperationsList_594226 = ref object of OpenApiRestCall_593439
proc url_OperationsList_594228(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_594227(path: JsonNode; query: JsonNode;
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
  var valid_594229 = query.getOrDefault("api-version")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "api-version", valid_594229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594230: Call_OperationsList_594226; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_594230.validator(path, query, header, formData, body)
  let scheme = call_594230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594230.url(scheme.get, call_594230.host, call_594230.base,
                         call_594230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594230, url, valid)

proc call*(call_594231: Call_OperationsList_594226; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  var query_594232 = newJObject()
  add(query_594232, "api-version", newJString(apiVersion))
  result = call_594231.call(nil, query_594232, nil, nil, nil)

var operationsList* = Call_OperationsList_594226(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/operations",
    validator: validate_OperationsList_594227, base: "", url: url_OperationsList_594228,
    schemes: {Scheme.Https})
type
  Call_ForecastUsageByManagementGroup_594233 = ref object of OpenApiRestCall_593439
proc url_ForecastUsageByManagementGroup_594235(protocol: Scheme; host: string;
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

proc validate_ForecastUsageByManagementGroup_594234(path: JsonNode;
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
  var valid_594236 = path.getOrDefault("managementGroupId")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "managementGroupId", valid_594236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594237 = query.getOrDefault("api-version")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "api-version", valid_594237
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

proc call*(call_594239: Call_ForecastUsageByManagementGroup_594233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for management group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594239.validator(path, query, header, formData, body)
  let scheme = call_594239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594239.url(scheme.get, call_594239.host, call_594239.base,
                         call_594239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594239, url, valid)

proc call*(call_594240: Call_ForecastUsageByManagementGroup_594233;
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
  var path_594241 = newJObject()
  var query_594242 = newJObject()
  var body_594243 = newJObject()
  add(query_594242, "api-version", newJString(apiVersion))
  add(path_594241, "managementGroupId", newJString(managementGroupId))
  if parameters != nil:
    body_594243 = parameters
  result = call_594240.call(path_594241, query_594242, nil, nil, body_594243)

var forecastUsageByManagementGroup* = Call_ForecastUsageByManagementGroup_594233(
    name: "forecastUsageByManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByManagementGroup_594234, base: "",
    url: url_ForecastUsageByManagementGroup_594235, schemes: {Scheme.Https})
type
  Call_QueryUsageByManagementGroup_594244 = ref object of OpenApiRestCall_593439
proc url_QueryUsageByManagementGroup_594246(protocol: Scheme; host: string;
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

proc validate_QueryUsageByManagementGroup_594245(path: JsonNode; query: JsonNode;
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
  var valid_594247 = path.getOrDefault("managementGroupId")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "managementGroupId", valid_594247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594248 = query.getOrDefault("api-version")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "api-version", valid_594248
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

proc call*(call_594250: Call_QueryUsageByManagementGroup_594244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for management group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_QueryUsageByManagementGroup_594244;
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
  var path_594252 = newJObject()
  var query_594253 = newJObject()
  var body_594254 = newJObject()
  add(query_594253, "api-version", newJString(apiVersion))
  add(path_594252, "managementGroupId", newJString(managementGroupId))
  if parameters != nil:
    body_594254 = parameters
  result = call_594251.call(path_594252, query_594253, nil, nil, body_594254)

var queryUsageByManagementGroup* = Call_QueryUsageByManagementGroup_594244(
    name: "queryUsageByManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByManagementGroup_594245, base: "",
    url: url_QueryUsageByManagementGroup_594246, schemes: {Scheme.Https})
type
  Call_DimensionsListByManagementGroup_594255 = ref object of OpenApiRestCall_593439
proc url_DimensionsListByManagementGroup_594257(protocol: Scheme; host: string;
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

proc validate_DimensionsListByManagementGroup_594256(path: JsonNode;
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
  var valid_594258 = path.getOrDefault("managementGroupId")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "managementGroupId", valid_594258
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
  var valid_594259 = query.getOrDefault("api-version")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "api-version", valid_594259
  var valid_594260 = query.getOrDefault("$expand")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "$expand", valid_594260
  var valid_594261 = query.getOrDefault("$top")
  valid_594261 = validateParameter(valid_594261, JInt, required = false, default = nil)
  if valid_594261 != nil:
    section.add "$top", valid_594261
  var valid_594262 = query.getOrDefault("$skiptoken")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "$skiptoken", valid_594262
  var valid_594263 = query.getOrDefault("$filter")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "$filter", valid_594263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594264: Call_DimensionsListByManagementGroup_594255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the dimensions by managementGroup Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_DimensionsListByManagementGroup_594255;
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
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  add(query_594267, "api-version", newJString(apiVersion))
  add(query_594267, "$expand", newJString(Expand))
  add(path_594266, "managementGroupId", newJString(managementGroupId))
  add(query_594267, "$top", newJInt(Top))
  add(query_594267, "$skiptoken", newJString(Skiptoken))
  add(query_594267, "$filter", newJString(Filter))
  result = call_594265.call(path_594266, query_594267, nil, nil, nil)

var dimensionsListByManagementGroup* = Call_DimensionsListByManagementGroup_594255(
    name: "dimensionsListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByManagementGroup_594256, base: "",
    url: url_DimensionsListByManagementGroup_594257, schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionListByManagementGroup_594268 = ref object of OpenApiRestCall_593439
proc url_ExternalSubscriptionListByManagementGroup_594270(protocol: Scheme;
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

proc validate_ExternalSubscriptionListByManagementGroup_594269(path: JsonNode;
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
  var valid_594271 = path.getOrDefault("managementGroupId")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "managementGroupId", valid_594271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  ##   $recurse: JBool
  ##           : The $recurse=true query string parameter allows returning externalSubscriptions associated with the specified managementGroup, or any of its descendants.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594272 = query.getOrDefault("api-version")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "api-version", valid_594272
  var valid_594273 = query.getOrDefault("$recurse")
  valid_594273 = validateParameter(valid_594273, JBool, required = false, default = nil)
  if valid_594273 != nil:
    section.add "$recurse", valid_594273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594274: Call_ExternalSubscriptionListByManagementGroup_594268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ExternalSubscription definitions for Management Group
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594274.validator(path, query, header, formData, body)
  let scheme = call_594274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594274.url(scheme.get, call_594274.host, call_594274.base,
                         call_594274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594274, url, valid)

proc call*(call_594275: Call_ExternalSubscriptionListByManagementGroup_594268;
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
  var path_594276 = newJObject()
  var query_594277 = newJObject()
  add(query_594277, "api-version", newJString(apiVersion))
  add(path_594276, "managementGroupId", newJString(managementGroupId))
  add(query_594277, "$recurse", newJBool(Recurse))
  result = call_594275.call(path_594276, query_594277, nil, nil, nil)

var externalSubscriptionListByManagementGroup* = Call_ExternalSubscriptionListByManagementGroup_594268(
    name: "externalSubscriptionListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/externalSubscriptions",
    validator: validate_ExternalSubscriptionListByManagementGroup_594269,
    base: "", url: url_ExternalSubscriptionListByManagementGroup_594270,
    schemes: {Scheme.Https})
type
  Call_ExternalSubscriptionUpdateManagementGroup_594278 = ref object of OpenApiRestCall_593439
proc url_ExternalSubscriptionUpdateManagementGroup_594280(protocol: Scheme;
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

proc validate_ExternalSubscriptionUpdateManagementGroup_594279(path: JsonNode;
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
  var valid_594281 = path.getOrDefault("managementGroupId")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "managementGroupId", valid_594281
  var valid_594282 = path.getOrDefault("externalSubscriptionName")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "externalSubscriptionName", valid_594282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594283 = query.getOrDefault("api-version")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "api-version", valid_594283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594284: Call_ExternalSubscriptionUpdateManagementGroup_594278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the management group of an ExternalSubscription
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_ExternalSubscriptionUpdateManagementGroup_594278;
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
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  add(query_594287, "api-version", newJString(apiVersion))
  add(path_594286, "managementGroupId", newJString(managementGroupId))
  add(path_594286, "externalSubscriptionName",
      newJString(externalSubscriptionName))
  result = call_594285.call(path_594286, query_594287, nil, nil, nil)

var externalSubscriptionUpdateManagementGroup* = Call_ExternalSubscriptionUpdateManagementGroup_594278(
    name: "externalSubscriptionUpdateManagementGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/externalSubscriptions/{externalSubscriptionName}",
    validator: validate_ExternalSubscriptionUpdateManagementGroup_594279,
    base: "", url: url_ExternalSubscriptionUpdateManagementGroup_594280,
    schemes: {Scheme.Https})
type
  Call_ForecastUsageBySubscription_594288 = ref object of OpenApiRestCall_593439
proc url_ForecastUsageBySubscription_594290(protocol: Scheme; host: string;
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

proc validate_ForecastUsageBySubscription_594289(path: JsonNode; query: JsonNode;
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
  var valid_594291 = path.getOrDefault("subscriptionId")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "subscriptionId", valid_594291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594292 = query.getOrDefault("api-version")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "api-version", valid_594292
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

proc call*(call_594294: Call_ForecastUsageBySubscription_594288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594294.validator(path, query, header, formData, body)
  let scheme = call_594294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594294.url(scheme.get, call_594294.host, call_594294.base,
                         call_594294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594294, url, valid)

proc call*(call_594295: Call_ForecastUsageBySubscription_594288;
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
  var path_594296 = newJObject()
  var query_594297 = newJObject()
  var body_594298 = newJObject()
  add(query_594297, "api-version", newJString(apiVersion))
  add(path_594296, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594298 = parameters
  result = call_594295.call(path_594296, query_594297, nil, nil, body_594298)

var forecastUsageBySubscription* = Call_ForecastUsageBySubscription_594288(
    name: "forecastUsageBySubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageBySubscription_594289, base: "",
    url: url_ForecastUsageBySubscription_594290, schemes: {Scheme.Https})
type
  Call_QueryUsageBySubscription_594299 = ref object of OpenApiRestCall_593439
proc url_QueryUsageBySubscription_594301(protocol: Scheme; host: string;
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

proc validate_QueryUsageBySubscription_594300(path: JsonNode; query: JsonNode;
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
  var valid_594302 = path.getOrDefault("subscriptionId")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "subscriptionId", valid_594302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594303 = query.getOrDefault("api-version")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "api-version", valid_594303
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

proc call*(call_594305: Call_QueryUsageBySubscription_594299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594305.validator(path, query, header, formData, body)
  let scheme = call_594305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594305.url(scheme.get, call_594305.host, call_594305.base,
                         call_594305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594305, url, valid)

proc call*(call_594306: Call_QueryUsageBySubscription_594299; apiVersion: string;
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
  var path_594307 = newJObject()
  var query_594308 = newJObject()
  var body_594309 = newJObject()
  add(query_594308, "api-version", newJString(apiVersion))
  add(path_594307, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594309 = parameters
  result = call_594306.call(path_594307, query_594308, nil, nil, body_594309)

var queryUsageBySubscription* = Call_QueryUsageBySubscription_594299(
    name: "queryUsageBySubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageBySubscription_594300, base: "",
    url: url_QueryUsageBySubscription_594301, schemes: {Scheme.Https})
type
  Call_DimensionsListBySubscription_594310 = ref object of OpenApiRestCall_593439
proc url_DimensionsListBySubscription_594312(protocol: Scheme; host: string;
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

proc validate_DimensionsListBySubscription_594311(path: JsonNode; query: JsonNode;
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
  var valid_594313 = path.getOrDefault("subscriptionId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "subscriptionId", valid_594313
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
  var valid_594314 = query.getOrDefault("api-version")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "api-version", valid_594314
  var valid_594315 = query.getOrDefault("$expand")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "$expand", valid_594315
  var valid_594316 = query.getOrDefault("$top")
  valid_594316 = validateParameter(valid_594316, JInt, required = false, default = nil)
  if valid_594316 != nil:
    section.add "$top", valid_594316
  var valid_594317 = query.getOrDefault("$skiptoken")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "$skiptoken", valid_594317
  var valid_594318 = query.getOrDefault("$filter")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "$filter", valid_594318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594319: Call_DimensionsListBySubscription_594310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594319.validator(path, query, header, formData, body)
  let scheme = call_594319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594319.url(scheme.get, call_594319.host, call_594319.base,
                         call_594319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594319, url, valid)

proc call*(call_594320: Call_DimensionsListBySubscription_594310;
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
  var path_594321 = newJObject()
  var query_594322 = newJObject()
  add(query_594322, "api-version", newJString(apiVersion))
  add(query_594322, "$expand", newJString(Expand))
  add(path_594321, "subscriptionId", newJString(subscriptionId))
  add(query_594322, "$top", newJInt(Top))
  add(query_594322, "$skiptoken", newJString(Skiptoken))
  add(query_594322, "$filter", newJString(Filter))
  result = call_594320.call(path_594321, query_594322, nil, nil, nil)

var dimensionsListBySubscription* = Call_DimensionsListBySubscription_594310(
    name: "dimensionsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListBySubscription_594311, base: "",
    url: url_DimensionsListBySubscription_594312, schemes: {Scheme.Https})
type
  Call_DimensionsListByResourceGroup_594323 = ref object of OpenApiRestCall_593439
proc url_DimensionsListByResourceGroup_594325(protocol: Scheme; host: string;
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

proc validate_DimensionsListByResourceGroup_594324(path: JsonNode; query: JsonNode;
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
  var valid_594326 = path.getOrDefault("resourceGroupName")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "resourceGroupName", valid_594326
  var valid_594327 = path.getOrDefault("subscriptionId")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "subscriptionId", valid_594327
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
  var valid_594328 = query.getOrDefault("api-version")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "api-version", valid_594328
  var valid_594329 = query.getOrDefault("$expand")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "$expand", valid_594329
  var valid_594330 = query.getOrDefault("$top")
  valid_594330 = validateParameter(valid_594330, JInt, required = false, default = nil)
  if valid_594330 != nil:
    section.add "$top", valid_594330
  var valid_594331 = query.getOrDefault("$skiptoken")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = nil)
  if valid_594331 != nil:
    section.add "$skiptoken", valid_594331
  var valid_594332 = query.getOrDefault("$filter")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "$filter", valid_594332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594333: Call_DimensionsListByResourceGroup_594323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by resource group Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594333.validator(path, query, header, formData, body)
  let scheme = call_594333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594333.url(scheme.get, call_594333.host, call_594333.base,
                         call_594333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594333, url, valid)

proc call*(call_594334: Call_DimensionsListByResourceGroup_594323;
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
  var path_594335 = newJObject()
  var query_594336 = newJObject()
  add(path_594335, "resourceGroupName", newJString(resourceGroupName))
  add(query_594336, "api-version", newJString(apiVersion))
  add(query_594336, "$expand", newJString(Expand))
  add(path_594335, "subscriptionId", newJString(subscriptionId))
  add(query_594336, "$top", newJInt(Top))
  add(query_594336, "$skiptoken", newJString(Skiptoken))
  add(query_594336, "$filter", newJString(Filter))
  result = call_594334.call(path_594335, query_594336, nil, nil, nil)

var dimensionsListByResourceGroup* = Call_DimensionsListByResourceGroup_594323(
    name: "dimensionsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_DimensionsListByResourceGroup_594324, base: "",
    url: url_DimensionsListByResourceGroup_594325, schemes: {Scheme.Https})
type
  Call_ForecastUsageByResourceGroup_594337 = ref object of OpenApiRestCall_593439
proc url_ForecastUsageByResourceGroup_594339(protocol: Scheme; host: string;
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

proc validate_ForecastUsageByResourceGroup_594338(path: JsonNode; query: JsonNode;
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
  var valid_594340 = path.getOrDefault("resourceGroupName")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "resourceGroupName", valid_594340
  var valid_594341 = path.getOrDefault("subscriptionId")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "subscriptionId", valid_594341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594342 = query.getOrDefault("api-version")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "api-version", valid_594342
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

proc call*(call_594344: Call_ForecastUsageByResourceGroup_594337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Forecast the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594344.validator(path, query, header, formData, body)
  let scheme = call_594344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594344.url(scheme.get, call_594344.host, call_594344.base,
                         call_594344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594344, url, valid)

proc call*(call_594345: Call_ForecastUsageByResourceGroup_594337;
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
  var path_594346 = newJObject()
  var query_594347 = newJObject()
  var body_594348 = newJObject()
  add(path_594346, "resourceGroupName", newJString(resourceGroupName))
  add(query_594347, "api-version", newJString(apiVersion))
  add(path_594346, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594348 = parameters
  result = call_594345.call(path_594346, query_594347, nil, nil, body_594348)

var forecastUsageByResourceGroup* = Call_ForecastUsageByResourceGroup_594337(
    name: "forecastUsageByResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/Forecast",
    validator: validate_ForecastUsageByResourceGroup_594338, base: "",
    url: url_ForecastUsageByResourceGroup_594339, schemes: {Scheme.Https})
type
  Call_QueryUsageByResourceGroup_594349 = ref object of OpenApiRestCall_593439
proc url_QueryUsageByResourceGroup_594351(protocol: Scheme; host: string;
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

proc validate_QueryUsageByResourceGroup_594350(path: JsonNode; query: JsonNode;
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
  var valid_594352 = path.getOrDefault("resourceGroupName")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "resourceGroupName", valid_594352
  var valid_594353 = path.getOrDefault("subscriptionId")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "subscriptionId", valid_594353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594354 = query.getOrDefault("api-version")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "api-version", valid_594354
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

proc call*(call_594356: Call_QueryUsageByResourceGroup_594349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594356.validator(path, query, header, formData, body)
  let scheme = call_594356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594356.url(scheme.get, call_594356.host, call_594356.base,
                         call_594356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594356, url, valid)

proc call*(call_594357: Call_QueryUsageByResourceGroup_594349;
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
  var path_594358 = newJObject()
  var query_594359 = newJObject()
  var body_594360 = newJObject()
  add(path_594358, "resourceGroupName", newJString(resourceGroupName))
  add(query_594359, "api-version", newJString(apiVersion))
  add(path_594358, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594360 = parameters
  result = call_594357.call(path_594358, query_594359, nil, nil, body_594360)

var queryUsageByResourceGroup* = Call_QueryUsageByResourceGroup_594349(
    name: "queryUsageByResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryUsageByResourceGroup_594350, base: "",
    url: url_QueryUsageByResourceGroup_594351, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
