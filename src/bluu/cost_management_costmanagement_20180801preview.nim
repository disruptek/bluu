
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CostManagementClient
## version: 2018-08-01-preview
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
  Call_AlertsListByDepartment_567890 = ref object of OpenApiRestCall_567668
proc url_AlertsListByDepartment_567892(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListByDepartment_567891(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all alerts for a department.
  ## 
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
  var valid_568066 = path.getOrDefault("billingAccountId")
  valid_568066 = validateParameter(valid_568066, JString, required = true,
                                 default = nil)
  if valid_568066 != nil:
    section.add "billingAccountId", valid_568066
  var valid_568067 = path.getOrDefault("departmentId")
  valid_568067 = validateParameter(valid_568067, JString, required = true,
                                 default = nil)
  if valid_568067 != nil:
    section.add "departmentId", valid_568067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N alerts.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568068 = query.getOrDefault("api-version")
  valid_568068 = validateParameter(valid_568068, JString, required = true,
                                 default = nil)
  if valid_568068 != nil:
    section.add "api-version", valid_568068
  var valid_568069 = query.getOrDefault("$top")
  valid_568069 = validateParameter(valid_568069, JInt, required = false, default = nil)
  if valid_568069 != nil:
    section.add "$top", valid_568069
  var valid_568070 = query.getOrDefault("$skiptoken")
  valid_568070 = validateParameter(valid_568070, JString, required = false,
                                 default = nil)
  if valid_568070 != nil:
    section.add "$skiptoken", valid_568070
  var valid_568071 = query.getOrDefault("$filter")
  valid_568071 = validateParameter(valid_568071, JString, required = false,
                                 default = nil)
  if valid_568071 != nil:
    section.add "$filter", valid_568071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568094: Call_AlertsListByDepartment_567890; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for a department.
  ## 
  let valid = call_568094.validator(path, query, header, formData, body)
  let scheme = call_568094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568094.url(scheme.get, call_568094.host, call_568094.base,
                         call_568094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568094, url, valid)

proc call*(call_568165: Call_AlertsListByDepartment_567890; apiVersion: string;
          billingAccountId: string; departmentId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## alertsListByDepartment
  ## List all alerts for a department.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N alerts.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Filter: string
  ##         : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568166 = newJObject()
  var query_568168 = newJObject()
  add(query_568168, "api-version", newJString(apiVersion))
  add(query_568168, "$top", newJInt(Top))
  add(query_568168, "$skiptoken", newJString(Skiptoken))
  add(path_568166, "billingAccountId", newJString(billingAccountId))
  add(path_568166, "departmentId", newJString(departmentId))
  add(query_568168, "$filter", newJString(Filter))
  result = call_568165.call(path_568166, query_568168, nil, nil, nil)

var alertsListByDepartment* = Call_AlertsListByDepartment_567890(
    name: "alertsListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByDepartment_567891, base: "",
    url: url_AlertsListByDepartment_567892, schemes: {Scheme.Https})
type
  Call_AlertsGetByDepartment_568207 = ref object of OpenApiRestCall_567668
proc url_AlertsGetByDepartment_568209(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetByDepartment_568208(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert for a department by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_568210 = path.getOrDefault("alertId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "alertId", valid_568210
  var valid_568211 = path.getOrDefault("billingAccountId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "billingAccountId", valid_568211
  var valid_568212 = path.getOrDefault("departmentId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "departmentId", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_AlertsGetByDepartment_568207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for a department by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_AlertsGetByDepartment_568207; apiVersion: string;
          alertId: string; billingAccountId: string; departmentId: string): Recallable =
  ## alertsGetByDepartment
  ## Gets the alert for a department by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   departmentId: string (required)
  ##               : Department ID
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "alertId", newJString(alertId))
  add(path_568216, "billingAccountId", newJString(billingAccountId))
  add(path_568216, "departmentId", newJString(departmentId))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var alertsGetByDepartment* = Call_AlertsGetByDepartment_568207(
    name: "alertsGetByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByDepartment_568208, base: "",
    url: url_AlertsGetByDepartment_568209, schemes: {Scheme.Https})
type
  Call_AlertsUpdateDepartmentsAlertStatus_568218 = ref object of OpenApiRestCall_567668
proc url_AlertsUpdateDepartmentsAlertStatus_568220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/updateStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsUpdateDepartmentsAlertStatus_568219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update alerts status for a department.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_568221 = path.getOrDefault("alertId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "alertId", valid_568221
  var valid_568222 = path.getOrDefault("billingAccountId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "billingAccountId", valid_568222
  var valid_568223 = path.getOrDefault("departmentId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "departmentId", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_AlertsUpdateDepartmentsAlertStatus_568218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for a department.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_AlertsUpdateDepartmentsAlertStatus_568218;
          apiVersion: string; alertId: string; billingAccountId: string;
          parameters: JsonNode; departmentId: string): Recallable =
  ## alertsUpdateDepartmentsAlertStatus
  ## Update alerts status for a department.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  ##   departmentId: string (required)
  ##               : Department ID
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  var body_568230 = newJObject()
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "alertId", newJString(alertId))
  add(path_568228, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568230 = parameters
  add(path_568228, "departmentId", newJString(departmentId))
  result = call_568227.call(path_568228, query_568229, nil, nil, body_568230)

var alertsUpdateDepartmentsAlertStatus* = Call_AlertsUpdateDepartmentsAlertStatus_568218(
    name: "alertsUpdateDepartmentsAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateDepartmentsAlertStatus_568219, base: "",
    url: url_AlertsUpdateDepartmentsAlertStatus_568220, schemes: {Scheme.Https})
type
  Call_AlertsListByAccount_568231 = ref object of OpenApiRestCall_567668
proc url_AlertsListByAccount_568233(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListByAccount_568232(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List all alerts for an account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : Enrollment Account Id
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_568234 = path.getOrDefault("enrollmentAccountId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "enrollmentAccountId", valid_568234
  var valid_568235 = path.getOrDefault("billingAccountId")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "billingAccountId", valid_568235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N alerts.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  var valid_568237 = query.getOrDefault("$top")
  valid_568237 = validateParameter(valid_568237, JInt, required = false, default = nil)
  if valid_568237 != nil:
    section.add "$top", valid_568237
  var valid_568238 = query.getOrDefault("$skiptoken")
  valid_568238 = validateParameter(valid_568238, JString, required = false,
                                 default = nil)
  if valid_568238 != nil:
    section.add "$skiptoken", valid_568238
  var valid_568239 = query.getOrDefault("$filter")
  valid_568239 = validateParameter(valid_568239, JString, required = false,
                                 default = nil)
  if valid_568239 != nil:
    section.add "$filter", valid_568239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_AlertsListByAccount_568231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for an account.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_AlertsListByAccount_568231; apiVersion: string;
          enrollmentAccountId: string; billingAccountId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## alertsListByAccount
  ## List all alerts for an account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N alerts.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : Enrollment Account Id
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(query_568243, "api-version", newJString(apiVersion))
  add(query_568243, "$top", newJInt(Top))
  add(query_568243, "$skiptoken", newJString(Skiptoken))
  add(path_568242, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568242, "billingAccountId", newJString(billingAccountId))
  add(query_568243, "$filter", newJString(Filter))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var alertsListByAccount* = Call_AlertsListByAccount_568231(
    name: "alertsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByAccount_568232, base: "",
    url: url_AlertsListByAccount_568233, schemes: {Scheme.Https})
type
  Call_AlertsGetByAccount_568244 = ref object of OpenApiRestCall_567668
proc url_AlertsGetByAccount_568246(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetByAccount_568245(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the alert for an account by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : Enrollment Account Id
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_568247 = path.getOrDefault("enrollmentAccountId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "enrollmentAccountId", valid_568247
  var valid_568248 = path.getOrDefault("alertId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "alertId", valid_568248
  var valid_568249 = path.getOrDefault("billingAccountId")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "billingAccountId", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_AlertsGetByAccount_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for an account by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_AlertsGetByAccount_568244; apiVersion: string;
          enrollmentAccountId: string; alertId: string; billingAccountId: string): Recallable =
  ## alertsGetByAccount
  ## Gets the alert for an account by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   enrollmentAccountId: string (required)
  ##                      : Enrollment Account Id
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  add(query_568254, "api-version", newJString(apiVersion))
  add(path_568253, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568253, "alertId", newJString(alertId))
  add(path_568253, "billingAccountId", newJString(billingAccountId))
  result = call_568252.call(path_568253, query_568254, nil, nil, nil)

var alertsGetByAccount* = Call_AlertsGetByAccount_568244(
    name: "alertsGetByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByAccount_568245, base: "",
    url: url_AlertsGetByAccount_568246, schemes: {Scheme.Https})
type
  Call_AlertsUpdateEnrollmentAccountAlertStatus_568255 = ref object of OpenApiRestCall_567668
proc url_AlertsUpdateEnrollmentAccountAlertStatus_568257(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/updateStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsUpdateEnrollmentAccountAlertStatus_568256(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update alerts status for an enrollment account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : Enrollment Account Id
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_568258 = path.getOrDefault("enrollmentAccountId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "enrollmentAccountId", valid_568258
  var valid_568259 = path.getOrDefault("alertId")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "alertId", valid_568259
  var valid_568260 = path.getOrDefault("billingAccountId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "billingAccountId", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_AlertsUpdateEnrollmentAccountAlertStatus_568255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for an enrollment account.
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_AlertsUpdateEnrollmentAccountAlertStatus_568255;
          apiVersion: string; enrollmentAccountId: string; alertId: string;
          billingAccountId: string; parameters: JsonNode): Recallable =
  ## alertsUpdateEnrollmentAccountAlertStatus
  ## Update alerts status for an enrollment account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   enrollmentAccountId: string (required)
  ##                      : Enrollment Account Id
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  var body_568267 = newJObject()
  add(query_568266, "api-version", newJString(apiVersion))
  add(path_568265, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568265, "alertId", newJString(alertId))
  add(path_568265, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568267 = parameters
  result = call_568264.call(path_568265, query_568266, nil, nil, body_568267)

var alertsUpdateEnrollmentAccountAlertStatus* = Call_AlertsUpdateEnrollmentAccountAlertStatus_568255(
    name: "alertsUpdateEnrollmentAccountAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateEnrollmentAccountAlertStatus_568256, base: "",
    url: url_AlertsUpdateEnrollmentAccountAlertStatus_568257,
    schemes: {Scheme.Https})
type
  Call_QueryBillingAccount_568268 = ref object of OpenApiRestCall_567668
proc url_QueryBillingAccount_568270(protocol: Scheme; host: string; base: string;
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

proc validate_QueryBillingAccount_568269(path: JsonNode; query: JsonNode;
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
  var valid_568288 = path.getOrDefault("billingAccountId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "billingAccountId", valid_568288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_QueryBillingAccount_568268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_QueryBillingAccount_568268; apiVersion: string;
          billingAccountId: string; parameters: JsonNode): Recallable =
  ## queryBillingAccount
  ## Lists the usage data for billing account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  var body_568295 = newJObject()
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568295 = parameters
  result = call_568292.call(path_568293, query_568294, nil, nil, body_568295)

var queryBillingAccount* = Call_QueryBillingAccount_568268(
    name: "queryBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryBillingAccount_568269, base: "",
    url: url_QueryBillingAccount_568270, schemes: {Scheme.Https})
type
  Call_AlertsListByEnrollment_568296 = ref object of OpenApiRestCall_567668
proc url_AlertsListByEnrollment_568298(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListByEnrollment_568297(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all alerts for an enrollment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568299 = path.getOrDefault("billingAccountId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "billingAccountId", valid_568299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N alerts.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568300 = query.getOrDefault("api-version")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "api-version", valid_568300
  var valid_568301 = query.getOrDefault("$top")
  valid_568301 = validateParameter(valid_568301, JInt, required = false, default = nil)
  if valid_568301 != nil:
    section.add "$top", valid_568301
  var valid_568302 = query.getOrDefault("$skiptoken")
  valid_568302 = validateParameter(valid_568302, JString, required = false,
                                 default = nil)
  if valid_568302 != nil:
    section.add "$skiptoken", valid_568302
  var valid_568303 = query.getOrDefault("$filter")
  valid_568303 = validateParameter(valid_568303, JString, required = false,
                                 default = nil)
  if valid_568303 != nil:
    section.add "$filter", valid_568303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568304: Call_AlertsListByEnrollment_568296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for an enrollment.
  ## 
  let valid = call_568304.validator(path, query, header, formData, body)
  let scheme = call_568304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568304.url(scheme.get, call_568304.host, call_568304.base,
                         call_568304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568304, url, valid)

proc call*(call_568305: Call_AlertsListByEnrollment_568296; apiVersion: string;
          billingAccountId: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## alertsListByEnrollment
  ## List all alerts for an enrollment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N alerts.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568306 = newJObject()
  var query_568307 = newJObject()
  add(query_568307, "api-version", newJString(apiVersion))
  add(query_568307, "$top", newJInt(Top))
  add(query_568307, "$skiptoken", newJString(Skiptoken))
  add(path_568306, "billingAccountId", newJString(billingAccountId))
  add(query_568307, "$filter", newJString(Filter))
  result = call_568305.call(path_568306, query_568307, nil, nil, nil)

var alertsListByEnrollment* = Call_AlertsListByEnrollment_568296(
    name: "alertsListByEnrollment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByEnrollment_568297, base: "",
    url: url_AlertsListByEnrollment_568298, schemes: {Scheme.Https})
type
  Call_AlertsGetByEnrollment_568308 = ref object of OpenApiRestCall_567668
proc url_AlertsGetByEnrollment_568310(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetByEnrollment_568309(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert for an enrollment by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_568311 = path.getOrDefault("alertId")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "alertId", valid_568311
  var valid_568312 = path.getOrDefault("billingAccountId")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "billingAccountId", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568314: Call_AlertsGetByEnrollment_568308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for an enrollment by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_AlertsGetByEnrollment_568308; apiVersion: string;
          alertId: string; billingAccountId: string): Recallable =
  ## alertsGetByEnrollment
  ## Gets the alert for an enrollment by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "alertId", newJString(alertId))
  add(path_568316, "billingAccountId", newJString(billingAccountId))
  result = call_568315.call(path_568316, query_568317, nil, nil, nil)

var alertsGetByEnrollment* = Call_AlertsGetByEnrollment_568308(
    name: "alertsGetByEnrollment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByEnrollment_568309, base: "",
    url: url_AlertsGetByEnrollment_568310, schemes: {Scheme.Https})
type
  Call_AlertsUpdateBillingAccountAlertStatus_568318 = ref object of OpenApiRestCall_567668
proc url_AlertsUpdateBillingAccountAlertStatus_568320(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/updateStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsUpdateBillingAccountAlertStatus_568319(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update alerts status for billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_568321 = path.getOrDefault("alertId")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "alertId", valid_568321
  var valid_568322 = path.getOrDefault("billingAccountId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "billingAccountId", valid_568322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568323 = query.getOrDefault("api-version")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "api-version", valid_568323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568325: Call_AlertsUpdateBillingAccountAlertStatus_568318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for billing account.
  ## 
  let valid = call_568325.validator(path, query, header, formData, body)
  let scheme = call_568325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568325.url(scheme.get, call_568325.host, call_568325.base,
                         call_568325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568325, url, valid)

proc call*(call_568326: Call_AlertsUpdateBillingAccountAlertStatus_568318;
          apiVersion: string; alertId: string; billingAccountId: string;
          parameters: JsonNode): Recallable =
  ## alertsUpdateBillingAccountAlertStatus
  ## Update alerts status for billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  var path_568327 = newJObject()
  var query_568328 = newJObject()
  var body_568329 = newJObject()
  add(query_568328, "api-version", newJString(apiVersion))
  add(path_568327, "alertId", newJString(alertId))
  add(path_568327, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568329 = parameters
  result = call_568326.call(path_568327, query_568328, nil, nil, body_568329)

var alertsUpdateBillingAccountAlertStatus* = Call_AlertsUpdateBillingAccountAlertStatus_568318(
    name: "alertsUpdateBillingAccountAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateBillingAccountAlertStatus_568319, base: "",
    url: url_AlertsUpdateBillingAccountAlertStatus_568320, schemes: {Scheme.Https})
type
  Call_BillingAccountDimensionsList_568330 = ref object of OpenApiRestCall_567668
proc url_BillingAccountDimensionsList_568332(protocol: Scheme; host: string;
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

proc validate_BillingAccountDimensionsList_568331(path: JsonNode; query: JsonNode;
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
  var valid_568333 = path.getOrDefault("billingAccountId")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "billingAccountId", valid_568333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var valid_568334 = query.getOrDefault("api-version")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "api-version", valid_568334
  var valid_568335 = query.getOrDefault("$expand")
  valid_568335 = validateParameter(valid_568335, JString, required = false,
                                 default = nil)
  if valid_568335 != nil:
    section.add "$expand", valid_568335
  var valid_568336 = query.getOrDefault("$top")
  valid_568336 = validateParameter(valid_568336, JInt, required = false, default = nil)
  if valid_568336 != nil:
    section.add "$top", valid_568336
  var valid_568337 = query.getOrDefault("$skiptoken")
  valid_568337 = validateParameter(valid_568337, JString, required = false,
                                 default = nil)
  if valid_568337 != nil:
    section.add "$skiptoken", valid_568337
  var valid_568338 = query.getOrDefault("$filter")
  valid_568338 = validateParameter(valid_568338, JString, required = false,
                                 default = nil)
  if valid_568338 != nil:
    section.add "$filter", valid_568338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568339: Call_BillingAccountDimensionsList_568330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by billingAccount Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568339.validator(path, query, header, formData, body)
  let scheme = call_568339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568339.url(scheme.get, call_568339.host, call_568339.base,
                         call_568339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568339, url, valid)

proc call*(call_568340: Call_BillingAccountDimensionsList_568330;
          apiVersion: string; billingAccountId: string; Expand: string = "";
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## billingAccountDimensionsList
  ## Lists the dimensions by billingAccount Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var path_568341 = newJObject()
  var query_568342 = newJObject()
  add(query_568342, "api-version", newJString(apiVersion))
  add(query_568342, "$expand", newJString(Expand))
  add(query_568342, "$top", newJInt(Top))
  add(query_568342, "$skiptoken", newJString(Skiptoken))
  add(path_568341, "billingAccountId", newJString(billingAccountId))
  add(query_568342, "$filter", newJString(Filter))
  result = call_568340.call(path_568341, query_568342, nil, nil, nil)

var billingAccountDimensionsList* = Call_BillingAccountDimensionsList_568330(
    name: "billingAccountDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_BillingAccountDimensionsList_568331, base: "",
    url: url_BillingAccountDimensionsList_568332, schemes: {Scheme.Https})
type
  Call_ReportsListByBillingAccount_568343 = ref object of OpenApiRestCall_567668
proc url_ReportsListByBillingAccount_568345(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CostManagement/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByBillingAccount_568344(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all reports for a billing account.
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
  var valid_568346 = path.getOrDefault("billingAccountId")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "billingAccountId", valid_568346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568347 = query.getOrDefault("api-version")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "api-version", valid_568347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568348: Call_ReportsListByBillingAccount_568343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568348.validator(path, query, header, formData, body)
  let scheme = call_568348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568348.url(scheme.get, call_568348.host, call_568348.base,
                         call_568348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568348, url, valid)

proc call*(call_568349: Call_ReportsListByBillingAccount_568343;
          apiVersion: string; billingAccountId: string): Recallable =
  ## reportsListByBillingAccount
  ## Lists all reports for a billing account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568350 = newJObject()
  var query_568351 = newJObject()
  add(query_568351, "api-version", newJString(apiVersion))
  add(path_568350, "billingAccountId", newJString(billingAccountId))
  result = call_568349.call(path_568350, query_568351, nil, nil, nil)

var reportsListByBillingAccount* = Call_ReportsListByBillingAccount_568343(
    name: "reportsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports",
    validator: validate_ReportsListByBillingAccount_568344, base: "",
    url: url_ReportsListByBillingAccount_568345, schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdateByBillingAccount_568362 = ref object of OpenApiRestCall_567668
proc url_ReportsCreateOrUpdateByBillingAccount_568364(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsCreateOrUpdateByBillingAccount_568363(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a report for billingAccount. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportName` field"
  var valid_568365 = path.getOrDefault("reportName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "reportName", valid_568365
  var valid_568366 = path.getOrDefault("billingAccountId")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "billingAccountId", valid_568366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "api-version", valid_568367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568369: Call_ReportsCreateOrUpdateByBillingAccount_568362;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a report for billingAccount. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568369.validator(path, query, header, formData, body)
  let scheme = call_568369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568369.url(scheme.get, call_568369.host, call_568369.base,
                         call_568369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568369, url, valid)

proc call*(call_568370: Call_ReportsCreateOrUpdateByBillingAccount_568362;
          apiVersion: string; reportName: string; billingAccountId: string;
          parameters: JsonNode): Recallable =
  ## reportsCreateOrUpdateByBillingAccount
  ## The operation to create or update a report for billingAccount. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  var path_568371 = newJObject()
  var query_568372 = newJObject()
  var body_568373 = newJObject()
  add(query_568372, "api-version", newJString(apiVersion))
  add(path_568371, "reportName", newJString(reportName))
  add(path_568371, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_568373 = parameters
  result = call_568370.call(path_568371, query_568372, nil, nil, body_568373)

var reportsCreateOrUpdateByBillingAccount* = Call_ReportsCreateOrUpdateByBillingAccount_568362(
    name: "reportsCreateOrUpdateByBillingAccount", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdateByBillingAccount_568363, base: "",
    url: url_ReportsCreateOrUpdateByBillingAccount_568364, schemes: {Scheme.Https})
type
  Call_ReportsGetByBillingAccount_568352 = ref object of OpenApiRestCall_567668
proc url_ReportsGetByBillingAccount_568354(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsGetByBillingAccount_568353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the report for a billing account by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportName` field"
  var valid_568355 = path.getOrDefault("reportName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "reportName", valid_568355
  var valid_568356 = path.getOrDefault("billingAccountId")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "billingAccountId", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568357 = query.getOrDefault("api-version")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "api-version", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_ReportsGetByBillingAccount_568352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a billing account by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_ReportsGetByBillingAccount_568352; apiVersion: string;
          reportName: string; billingAccountId: string): Recallable =
  ## reportsGetByBillingAccount
  ## Gets the report for a billing account by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "reportName", newJString(reportName))
  add(path_568360, "billingAccountId", newJString(billingAccountId))
  result = call_568359.call(path_568360, query_568361, nil, nil, nil)

var reportsGetByBillingAccount* = Call_ReportsGetByBillingAccount_568352(
    name: "reportsGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsGetByBillingAccount_568353, base: "",
    url: url_ReportsGetByBillingAccount_568354, schemes: {Scheme.Https})
type
  Call_ReportsDeleteByBillingAccount_568374 = ref object of OpenApiRestCall_567668
proc url_ReportsDeleteByBillingAccount_568376(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsDeleteByBillingAccount_568375(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a report for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportName` field"
  var valid_568377 = path.getOrDefault("reportName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "reportName", valid_568377
  var valid_568378 = path.getOrDefault("billingAccountId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "billingAccountId", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568379 = query.getOrDefault("api-version")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "api-version", valid_568379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568380: Call_ReportsDeleteByBillingAccount_568374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a report for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568380.validator(path, query, header, formData, body)
  let scheme = call_568380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568380.url(scheme.get, call_568380.host, call_568380.base,
                         call_568380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568380, url, valid)

proc call*(call_568381: Call_ReportsDeleteByBillingAccount_568374;
          apiVersion: string; reportName: string; billingAccountId: string): Recallable =
  ## reportsDeleteByBillingAccount
  ## The operation to delete a report for billing account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568382 = newJObject()
  var query_568383 = newJObject()
  add(query_568383, "api-version", newJString(apiVersion))
  add(path_568382, "reportName", newJString(reportName))
  add(path_568382, "billingAccountId", newJString(billingAccountId))
  result = call_568381.call(path_568382, query_568383, nil, nil, nil)

var reportsDeleteByBillingAccount* = Call_ReportsDeleteByBillingAccount_568374(
    name: "reportsDeleteByBillingAccount", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDeleteByBillingAccount_568375, base: "",
    url: url_ReportsDeleteByBillingAccount_568376, schemes: {Scheme.Https})
type
  Call_ReportsExecuteByBillingAccount_568384 = ref object of OpenApiRestCall_567668
proc url_ReportsExecuteByBillingAccount_568386(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName"),
               (kind: ConstantSegment, value: "/run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsExecuteByBillingAccount_568385(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to execute a report by billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportName` field"
  var valid_568387 = path.getOrDefault("reportName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "reportName", valid_568387
  var valid_568388 = path.getOrDefault("billingAccountId")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "billingAccountId", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568389 = query.getOrDefault("api-version")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "api-version", valid_568389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568390: Call_ReportsExecuteByBillingAccount_568384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to execute a report by billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568390.validator(path, query, header, formData, body)
  let scheme = call_568390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568390.url(scheme.get, call_568390.host, call_568390.base,
                         call_568390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568390, url, valid)

proc call*(call_568391: Call_ReportsExecuteByBillingAccount_568384;
          apiVersion: string; reportName: string; billingAccountId: string): Recallable =
  ## reportsExecuteByBillingAccount
  ## The operation to execute a report by billing account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568392 = newJObject()
  var query_568393 = newJObject()
  add(query_568393, "api-version", newJString(apiVersion))
  add(path_568392, "reportName", newJString(reportName))
  add(path_568392, "billingAccountId", newJString(billingAccountId))
  result = call_568391.call(path_568392, query_568393, nil, nil, nil)

var reportsExecuteByBillingAccount* = Call_ReportsExecuteByBillingAccount_568384(
    name: "reportsExecuteByBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecuteByBillingAccount_568385, base: "",
    url: url_ReportsExecuteByBillingAccount_568386, schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistoryByBillingAccount_568394 = ref object of OpenApiRestCall_567668
proc url_ReportsGetExecutionHistoryByBillingAccount_568396(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName"),
               (kind: ConstantSegment, value: "/runHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsGetExecutionHistoryByBillingAccount_568395(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the execution history of a report for a billing account by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportName` field"
  var valid_568397 = path.getOrDefault("reportName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "reportName", valid_568397
  var valid_568398 = path.getOrDefault("billingAccountId")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "billingAccountId", valid_568398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568399 = query.getOrDefault("api-version")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "api-version", valid_568399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568400: Call_ReportsGetExecutionHistoryByBillingAccount_568394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the execution history of a report for a billing account by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_ReportsGetExecutionHistoryByBillingAccount_568394;
          apiVersion: string; reportName: string; billingAccountId: string): Recallable =
  ## reportsGetExecutionHistoryByBillingAccount
  ## Gets the execution history of a report for a billing account by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568402 = newJObject()
  var query_568403 = newJObject()
  add(query_568403, "api-version", newJString(apiVersion))
  add(path_568402, "reportName", newJString(reportName))
  add(path_568402, "billingAccountId", newJString(billingAccountId))
  result = call_568401.call(path_568402, query_568403, nil, nil, nil)

var reportsGetExecutionHistoryByBillingAccount* = Call_ReportsGetExecutionHistoryByBillingAccount_568394(
    name: "reportsGetExecutionHistoryByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistoryByBillingAccount_568395,
    base: "", url: url_ReportsGetExecutionHistoryByBillingAccount_568396,
    schemes: {Scheme.Https})
type
  Call_ReportsListByDepartment_568404 = ref object of OpenApiRestCall_567668
proc url_ReportsListByDepartment_568406(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
        value: "/providers/Microsoft.CostManagement/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByDepartment_568405(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all reports for a department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_568407 = path.getOrDefault("departmentId")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "departmentId", valid_568407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568408 = query.getOrDefault("api-version")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "api-version", valid_568408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568409: Call_ReportsListByDepartment_568404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568409.validator(path, query, header, formData, body)
  let scheme = call_568409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568409.url(scheme.get, call_568409.host, call_568409.base,
                         call_568409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568409, url, valid)

proc call*(call_568410: Call_ReportsListByDepartment_568404; apiVersion: string;
          departmentId: string): Recallable =
  ## reportsListByDepartment
  ## Lists all reports for a department.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   departmentId: string (required)
  ##               : Department ID
  var path_568411 = newJObject()
  var query_568412 = newJObject()
  add(query_568412, "api-version", newJString(apiVersion))
  add(path_568411, "departmentId", newJString(departmentId))
  result = call_568410.call(path_568411, query_568412, nil, nil, nil)

var reportsListByDepartment* = Call_ReportsListByDepartment_568404(
    name: "reportsListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports",
    validator: validate_ReportsListByDepartment_568405, base: "",
    url: url_ReportsListByDepartment_568406, schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdateByDepartment_568423 = ref object of OpenApiRestCall_567668
proc url_ReportsCreateOrUpdateByDepartment_568425(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsCreateOrUpdateByDepartment_568424(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a report for department. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportName` field"
  var valid_568426 = path.getOrDefault("reportName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "reportName", valid_568426
  var valid_568427 = path.getOrDefault("departmentId")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "departmentId", valid_568427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568428 = query.getOrDefault("api-version")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "api-version", valid_568428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568430: Call_ReportsCreateOrUpdateByDepartment_568423;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a report for department. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568430.validator(path, query, header, formData, body)
  let scheme = call_568430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568430.url(scheme.get, call_568430.host, call_568430.base,
                         call_568430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568430, url, valid)

proc call*(call_568431: Call_ReportsCreateOrUpdateByDepartment_568423;
          apiVersion: string; reportName: string; parameters: JsonNode;
          departmentId: string): Recallable =
  ## reportsCreateOrUpdateByDepartment
  ## The operation to create or update a report for department. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  ##   departmentId: string (required)
  ##               : Department ID
  var path_568432 = newJObject()
  var query_568433 = newJObject()
  var body_568434 = newJObject()
  add(query_568433, "api-version", newJString(apiVersion))
  add(path_568432, "reportName", newJString(reportName))
  if parameters != nil:
    body_568434 = parameters
  add(path_568432, "departmentId", newJString(departmentId))
  result = call_568431.call(path_568432, query_568433, nil, nil, body_568434)

var reportsCreateOrUpdateByDepartment* = Call_ReportsCreateOrUpdateByDepartment_568423(
    name: "reportsCreateOrUpdateByDepartment", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdateByDepartment_568424, base: "",
    url: url_ReportsCreateOrUpdateByDepartment_568425, schemes: {Scheme.Https})
type
  Call_ReportsGetByDepartment_568413 = ref object of OpenApiRestCall_567668
proc url_ReportsGetByDepartment_568415(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsGetByDepartment_568414(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the report for a department by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportName` field"
  var valid_568416 = path.getOrDefault("reportName")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "reportName", valid_568416
  var valid_568417 = path.getOrDefault("departmentId")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "departmentId", valid_568417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568418 = query.getOrDefault("api-version")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "api-version", valid_568418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568419: Call_ReportsGetByDepartment_568413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a department by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568419.validator(path, query, header, formData, body)
  let scheme = call_568419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568419.url(scheme.get, call_568419.host, call_568419.base,
                         call_568419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568419, url, valid)

proc call*(call_568420: Call_ReportsGetByDepartment_568413; apiVersion: string;
          reportName: string; departmentId: string): Recallable =
  ## reportsGetByDepartment
  ## Gets the report for a department by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   departmentId: string (required)
  ##               : Department ID
  var path_568421 = newJObject()
  var query_568422 = newJObject()
  add(query_568422, "api-version", newJString(apiVersion))
  add(path_568421, "reportName", newJString(reportName))
  add(path_568421, "departmentId", newJString(departmentId))
  result = call_568420.call(path_568421, query_568422, nil, nil, nil)

var reportsGetByDepartment* = Call_ReportsGetByDepartment_568413(
    name: "reportsGetByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsGetByDepartment_568414, base: "",
    url: url_ReportsGetByDepartment_568415, schemes: {Scheme.Https})
type
  Call_ReportsDeleteByDepartment_568435 = ref object of OpenApiRestCall_567668
proc url_ReportsDeleteByDepartment_568437(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsDeleteByDepartment_568436(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a report for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportName` field"
  var valid_568438 = path.getOrDefault("reportName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "reportName", valid_568438
  var valid_568439 = path.getOrDefault("departmentId")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "departmentId", valid_568439
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568440 = query.getOrDefault("api-version")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "api-version", valid_568440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568441: Call_ReportsDeleteByDepartment_568435; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a report for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568441.validator(path, query, header, formData, body)
  let scheme = call_568441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568441.url(scheme.get, call_568441.host, call_568441.base,
                         call_568441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568441, url, valid)

proc call*(call_568442: Call_ReportsDeleteByDepartment_568435; apiVersion: string;
          reportName: string; departmentId: string): Recallable =
  ## reportsDeleteByDepartment
  ## The operation to delete a report for department.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   departmentId: string (required)
  ##               : Department ID
  var path_568443 = newJObject()
  var query_568444 = newJObject()
  add(query_568444, "api-version", newJString(apiVersion))
  add(path_568443, "reportName", newJString(reportName))
  add(path_568443, "departmentId", newJString(departmentId))
  result = call_568442.call(path_568443, query_568444, nil, nil, nil)

var reportsDeleteByDepartment* = Call_ReportsDeleteByDepartment_568435(
    name: "reportsDeleteByDepartment", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDeleteByDepartment_568436, base: "",
    url: url_ReportsDeleteByDepartment_568437, schemes: {Scheme.Https})
type
  Call_ReportsExecuteByDepartment_568445 = ref object of OpenApiRestCall_567668
proc url_ReportsExecuteByDepartment_568447(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName"),
               (kind: ConstantSegment, value: "/run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsExecuteByDepartment_568446(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to execute a report by department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportName` field"
  var valid_568448 = path.getOrDefault("reportName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "reportName", valid_568448
  var valid_568449 = path.getOrDefault("departmentId")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "departmentId", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "api-version", valid_568450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_ReportsExecuteByDepartment_568445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to execute a report by department.
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

proc call*(call_568452: Call_ReportsExecuteByDepartment_568445; apiVersion: string;
          reportName: string; departmentId: string): Recallable =
  ## reportsExecuteByDepartment
  ## The operation to execute a report by department.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   departmentId: string (required)
  ##               : Department ID
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(query_568454, "api-version", newJString(apiVersion))
  add(path_568453, "reportName", newJString(reportName))
  add(path_568453, "departmentId", newJString(departmentId))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var reportsExecuteByDepartment* = Call_ReportsExecuteByDepartment_568445(
    name: "reportsExecuteByDepartment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecuteByDepartment_568446, base: "",
    url: url_ReportsExecuteByDepartment_568447, schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistoryByDepartment_568455 = ref object of OpenApiRestCall_567668
proc url_ReportsGetExecutionHistoryByDepartment_568457(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName"),
               (kind: ConstantSegment, value: "/runHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsGetExecutionHistoryByDepartment_568456(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the execution history of a report for a department by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportName` field"
  var valid_568458 = path.getOrDefault("reportName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "reportName", valid_568458
  var valid_568459 = path.getOrDefault("departmentId")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "departmentId", valid_568459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568460 = query.getOrDefault("api-version")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "api-version", valid_568460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568461: Call_ReportsGetExecutionHistoryByDepartment_568455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the execution history of a report for a department by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568461.validator(path, query, header, formData, body)
  let scheme = call_568461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568461.url(scheme.get, call_568461.host, call_568461.base,
                         call_568461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568461, url, valid)

proc call*(call_568462: Call_ReportsGetExecutionHistoryByDepartment_568455;
          apiVersion: string; reportName: string; departmentId: string): Recallable =
  ## reportsGetExecutionHistoryByDepartment
  ## Gets the execution history of a report for a department by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   departmentId: string (required)
  ##               : Department ID
  var path_568463 = newJObject()
  var query_568464 = newJObject()
  add(query_568464, "api-version", newJString(apiVersion))
  add(path_568463, "reportName", newJString(reportName))
  add(path_568463, "departmentId", newJString(departmentId))
  result = call_568462.call(path_568463, query_568464, nil, nil, nil)

var reportsGetExecutionHistoryByDepartment* = Call_ReportsGetExecutionHistoryByDepartment_568455(
    name: "reportsGetExecutionHistoryByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistoryByDepartment_568456, base: "",
    url: url_ReportsGetExecutionHistoryByDepartment_568457,
    schemes: {Scheme.Https})
type
  Call_OperationsList_568465 = ref object of OpenApiRestCall_567668
proc url_OperationsList_568467(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568466(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available cost management REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568468 = query.getOrDefault("api-version")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "api-version", valid_568468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568469: Call_OperationsList_568465; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available cost management REST API operations.
  ## 
  let valid = call_568469.validator(path, query, header, formData, body)
  let scheme = call_568469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568469.url(scheme.get, call_568469.host, call_568469.base,
                         call_568469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568469, url, valid)

proc call*(call_568470: Call_OperationsList_568465; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available cost management REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  var query_568471 = newJObject()
  add(query_568471, "api-version", newJString(apiVersion))
  result = call_568470.call(nil, query_568471, nil, nil, nil)

var operationsList* = Call_OperationsList_568465(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/operations",
    validator: validate_OperationsList_568466, base: "", url: url_OperationsList_568467,
    schemes: {Scheme.Https})
type
  Call_AlertsListByManagementGroups_568472 = ref object of OpenApiRestCall_567668
proc url_AlertsListByManagementGroups_568474(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListByManagementGroups_568473(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all alerts for Management Groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Management Group ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568475 = path.getOrDefault("managementGroupId")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "managementGroupId", valid_568475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N alerts.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568476 = query.getOrDefault("api-version")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "api-version", valid_568476
  var valid_568477 = query.getOrDefault("$top")
  valid_568477 = validateParameter(valid_568477, JInt, required = false, default = nil)
  if valid_568477 != nil:
    section.add "$top", valid_568477
  var valid_568478 = query.getOrDefault("$skiptoken")
  valid_568478 = validateParameter(valid_568478, JString, required = false,
                                 default = nil)
  if valid_568478 != nil:
    section.add "$skiptoken", valid_568478
  var valid_568479 = query.getOrDefault("$filter")
  valid_568479 = validateParameter(valid_568479, JString, required = false,
                                 default = nil)
  if valid_568479 != nil:
    section.add "$filter", valid_568479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568480: Call_AlertsListByManagementGroups_568472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for Management Groups.
  ## 
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_AlertsListByManagementGroups_568472;
          apiVersion: string; managementGroupId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## alertsListByManagementGroups
  ## List all alerts for Management Groups.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   managementGroupId: string (required)
  ##                    : Management Group ID
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N alerts.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "managementGroupId", newJString(managementGroupId))
  add(query_568483, "$top", newJInt(Top))
  add(query_568483, "$skiptoken", newJString(Skiptoken))
  add(query_568483, "$filter", newJString(Filter))
  result = call_568481.call(path_568482, query_568483, nil, nil, nil)

var alertsListByManagementGroups* = Call_AlertsListByManagementGroups_568472(
    name: "alertsListByManagementGroups", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByManagementGroups_568473, base: "",
    url: url_AlertsListByManagementGroups_568474, schemes: {Scheme.Https})
type
  Call_AlertsGetAlertByManagementGroups_568484 = ref object of OpenApiRestCall_567668
proc url_AlertsGetAlertByManagementGroups_568486(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetAlertByManagementGroups_568485(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an alert for Management Groups by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Management Group ID
  ##   alertId: JString (required)
  ##          : Alert ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568487 = path.getOrDefault("managementGroupId")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "managementGroupId", valid_568487
  var valid_568488 = path.getOrDefault("alertId")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "alertId", valid_568488
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568489 = query.getOrDefault("api-version")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "api-version", valid_568489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568490: Call_AlertsGetAlertByManagementGroups_568484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an alert for Management Groups by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568490.validator(path, query, header, formData, body)
  let scheme = call_568490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568490.url(scheme.get, call_568490.host, call_568490.base,
                         call_568490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568490, url, valid)

proc call*(call_568491: Call_AlertsGetAlertByManagementGroups_568484;
          apiVersion: string; managementGroupId: string; alertId: string): Recallable =
  ## alertsGetAlertByManagementGroups
  ## Gets an alert for Management Groups by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   managementGroupId: string (required)
  ##                    : Management Group ID
  ##   alertId: string (required)
  ##          : Alert ID.
  var path_568492 = newJObject()
  var query_568493 = newJObject()
  add(query_568493, "api-version", newJString(apiVersion))
  add(path_568492, "managementGroupId", newJString(managementGroupId))
  add(path_568492, "alertId", newJString(alertId))
  result = call_568491.call(path_568492, query_568493, nil, nil, nil)

var alertsGetAlertByManagementGroups* = Call_AlertsGetAlertByManagementGroups_568484(
    name: "alertsGetAlertByManagementGroups", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetAlertByManagementGroups_568485, base: "",
    url: url_AlertsGetAlertByManagementGroups_568486, schemes: {Scheme.Https})
type
  Call_AlertsUpdateManagementGroupAlertStatus_568494 = ref object of OpenApiRestCall_567668
proc url_AlertsUpdateManagementGroupAlertStatus_568496(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/UpdateStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsUpdateManagementGroupAlertStatus_568495(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update alerts status for management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Management Group ID
  ##   alertId: JString (required)
  ##          : Alert ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568497 = path.getOrDefault("managementGroupId")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "managementGroupId", valid_568497
  var valid_568498 = path.getOrDefault("alertId")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "alertId", valid_568498
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568499 = query.getOrDefault("api-version")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "api-version", valid_568499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568501: Call_AlertsUpdateManagementGroupAlertStatus_568494;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for management group.
  ## 
  let valid = call_568501.validator(path, query, header, formData, body)
  let scheme = call_568501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568501.url(scheme.get, call_568501.host, call_568501.base,
                         call_568501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568501, url, valid)

proc call*(call_568502: Call_AlertsUpdateManagementGroupAlertStatus_568494;
          apiVersion: string; managementGroupId: string; alertId: string;
          parameters: JsonNode): Recallable =
  ## alertsUpdateManagementGroupAlertStatus
  ## Update alerts status for management group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   managementGroupId: string (required)
  ##                    : Management Group ID
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  var path_568503 = newJObject()
  var query_568504 = newJObject()
  var body_568505 = newJObject()
  add(query_568504, "api-version", newJString(apiVersion))
  add(path_568503, "managementGroupId", newJString(managementGroupId))
  add(path_568503, "alertId", newJString(alertId))
  if parameters != nil:
    body_568505 = parameters
  result = call_568502.call(path_568503, query_568504, nil, nil, body_568505)

var alertsUpdateManagementGroupAlertStatus* = Call_AlertsUpdateManagementGroupAlertStatus_568494(
    name: "alertsUpdateManagementGroupAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/alerts/{alertId}/UpdateStatus",
    validator: validate_AlertsUpdateManagementGroupAlertStatus_568495, base: "",
    url: url_AlertsUpdateManagementGroupAlertStatus_568496,
    schemes: {Scheme.Https})
type
  Call_QuerySubscription_568506 = ref object of OpenApiRestCall_567668
proc url_QuerySubscription_568508(protocol: Scheme; host: string; base: string;
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

proc validate_QuerySubscription_568507(path: JsonNode; query: JsonNode;
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
  var valid_568509 = path.getOrDefault("subscriptionId")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "subscriptionId", valid_568509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568510 = query.getOrDefault("api-version")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "api-version", valid_568510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568512: Call_QuerySubscription_568506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568512.validator(path, query, header, formData, body)
  let scheme = call_568512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568512.url(scheme.get, call_568512.host, call_568512.base,
                         call_568512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568512, url, valid)

proc call*(call_568513: Call_QuerySubscription_568506; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## querySubscription
  ## Lists the usage data for subscriptionId.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  var path_568514 = newJObject()
  var query_568515 = newJObject()
  var body_568516 = newJObject()
  add(query_568515, "api-version", newJString(apiVersion))
  add(path_568514, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568516 = parameters
  result = call_568513.call(path_568514, query_568515, nil, nil, body_568516)

var querySubscription* = Call_QuerySubscription_568506(name: "querySubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QuerySubscription_568507, base: "",
    url: url_QuerySubscription_568508, schemes: {Scheme.Https})
type
  Call_AlertsList_568517 = ref object of OpenApiRestCall_567668
proc url_AlertsList_568519(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsList_568518(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## List all alerts for a subscription.
  ## 
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
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N alerts.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568521 = query.getOrDefault("api-version")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "api-version", valid_568521
  var valid_568522 = query.getOrDefault("$top")
  valid_568522 = validateParameter(valid_568522, JInt, required = false, default = nil)
  if valid_568522 != nil:
    section.add "$top", valid_568522
  var valid_568523 = query.getOrDefault("$skiptoken")
  valid_568523 = validateParameter(valid_568523, JString, required = false,
                                 default = nil)
  if valid_568523 != nil:
    section.add "$skiptoken", valid_568523
  var valid_568524 = query.getOrDefault("$filter")
  valid_568524 = validateParameter(valid_568524, JString, required = false,
                                 default = nil)
  if valid_568524 != nil:
    section.add "$filter", valid_568524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568525: Call_AlertsList_568517; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for a subscription.
  ## 
  let valid = call_568525.validator(path, query, header, formData, body)
  let scheme = call_568525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568525.url(scheme.get, call_568525.host, call_568525.base,
                         call_568525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568525, url, valid)

proc call*(call_568526: Call_AlertsList_568517; apiVersion: string;
          subscriptionId: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## alertsList
  ## List all alerts for a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N alerts.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568527 = newJObject()
  var query_568528 = newJObject()
  add(query_568528, "api-version", newJString(apiVersion))
  add(path_568527, "subscriptionId", newJString(subscriptionId))
  add(query_568528, "$top", newJInt(Top))
  add(query_568528, "$skiptoken", newJString(Skiptoken))
  add(query_568528, "$filter", newJString(Filter))
  result = call_568526.call(path_568527, query_568528, nil, nil, nil)

var alertsList* = Call_AlertsList_568517(name: "alertsList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/alerts",
                                      validator: validate_AlertsList_568518,
                                      base: "", url: url_AlertsList_568519,
                                      schemes: {Scheme.Https})
type
  Call_AlertsGetBySubscription_568529 = ref object of OpenApiRestCall_567668
proc url_AlertsGetBySubscription_568531(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetBySubscription_568530(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert for a subscription by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   alertId: JString (required)
  ##          : Alert ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568532 = path.getOrDefault("subscriptionId")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "subscriptionId", valid_568532
  var valid_568533 = path.getOrDefault("alertId")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "alertId", valid_568533
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568534 = query.getOrDefault("api-version")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "api-version", valid_568534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568535: Call_AlertsGetBySubscription_568529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for a subscription by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568535.validator(path, query, header, formData, body)
  let scheme = call_568535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568535.url(scheme.get, call_568535.host, call_568535.base,
                         call_568535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568535, url, valid)

proc call*(call_568536: Call_AlertsGetBySubscription_568529; apiVersion: string;
          subscriptionId: string; alertId: string): Recallable =
  ## alertsGetBySubscription
  ## Gets the alert for a subscription by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   alertId: string (required)
  ##          : Alert ID.
  var path_568537 = newJObject()
  var query_568538 = newJObject()
  add(query_568538, "api-version", newJString(apiVersion))
  add(path_568537, "subscriptionId", newJString(subscriptionId))
  add(path_568537, "alertId", newJString(alertId))
  result = call_568536.call(path_568537, query_568538, nil, nil, nil)

var alertsGetBySubscription* = Call_AlertsGetBySubscription_568529(
    name: "alertsGetBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetBySubscription_568530, base: "",
    url: url_AlertsGetBySubscription_568531, schemes: {Scheme.Https})
type
  Call_AlertsUpdateSubscriptionAlertStatus_568539 = ref object of OpenApiRestCall_567668
proc url_AlertsUpdateSubscriptionAlertStatus_568541(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/updateStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsUpdateSubscriptionAlertStatus_568540(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update alerts status for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   alertId: JString (required)
  ##          : Alert ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568542 = path.getOrDefault("subscriptionId")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "subscriptionId", valid_568542
  var valid_568543 = path.getOrDefault("alertId")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "alertId", valid_568543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568544 = query.getOrDefault("api-version")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "api-version", valid_568544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568546: Call_AlertsUpdateSubscriptionAlertStatus_568539;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for a subscription.
  ## 
  let valid = call_568546.validator(path, query, header, formData, body)
  let scheme = call_568546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568546.url(scheme.get, call_568546.host, call_568546.base,
                         call_568546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568546, url, valid)

proc call*(call_568547: Call_AlertsUpdateSubscriptionAlertStatus_568539;
          apiVersion: string; subscriptionId: string; alertId: string;
          parameters: JsonNode): Recallable =
  ## alertsUpdateSubscriptionAlertStatus
  ## Update alerts status for a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  var path_568548 = newJObject()
  var query_568549 = newJObject()
  var body_568550 = newJObject()
  add(query_568549, "api-version", newJString(apiVersion))
  add(path_568548, "subscriptionId", newJString(subscriptionId))
  add(path_568548, "alertId", newJString(alertId))
  if parameters != nil:
    body_568550 = parameters
  result = call_568547.call(path_568548, query_568549, nil, nil, body_568550)

var alertsUpdateSubscriptionAlertStatus* = Call_AlertsUpdateSubscriptionAlertStatus_568539(
    name: "alertsUpdateSubscriptionAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateSubscriptionAlertStatus_568540, base: "",
    url: url_AlertsUpdateSubscriptionAlertStatus_568541, schemes: {Scheme.Https})
type
  Call_ConnectorList_568551 = ref object of OpenApiRestCall_567668
proc url_ConnectorList_568553(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.CostManagement/connectors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorList_568552(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List all connector definitions for a subscription
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
  var valid_568554 = path.getOrDefault("subscriptionId")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "subscriptionId", valid_568554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568555 = query.getOrDefault("api-version")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "api-version", valid_568555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568556: Call_ConnectorList_568551; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all connector definitions for a subscription
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568556.validator(path, query, header, formData, body)
  let scheme = call_568556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568556.url(scheme.get, call_568556.host, call_568556.base,
                         call_568556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568556, url, valid)

proc call*(call_568557: Call_ConnectorList_568551; apiVersion: string;
          subscriptionId: string): Recallable =
  ## connectorList
  ## List all connector definitions for a subscription
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568558 = newJObject()
  var query_568559 = newJObject()
  add(query_568559, "api-version", newJString(apiVersion))
  add(path_568558, "subscriptionId", newJString(subscriptionId))
  result = call_568557.call(path_568558, query_568559, nil, nil, nil)

var connectorList* = Call_ConnectorList_568551(name: "connectorList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/connectors",
    validator: validate_ConnectorList_568552, base: "", url: url_ConnectorList_568553,
    schemes: {Scheme.Https})
type
  Call_SubscriptionDimensionsList_568560 = ref object of OpenApiRestCall_567668
proc url_SubscriptionDimensionsList_568562(protocol: Scheme; host: string;
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

proc validate_SubscriptionDimensionsList_568561(path: JsonNode; query: JsonNode;
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
  var valid_568563 = path.getOrDefault("subscriptionId")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "subscriptionId", valid_568563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var valid_568564 = query.getOrDefault("api-version")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "api-version", valid_568564
  var valid_568565 = query.getOrDefault("$expand")
  valid_568565 = validateParameter(valid_568565, JString, required = false,
                                 default = nil)
  if valid_568565 != nil:
    section.add "$expand", valid_568565
  var valid_568566 = query.getOrDefault("$top")
  valid_568566 = validateParameter(valid_568566, JInt, required = false, default = nil)
  if valid_568566 != nil:
    section.add "$top", valid_568566
  var valid_568567 = query.getOrDefault("$skiptoken")
  valid_568567 = validateParameter(valid_568567, JString, required = false,
                                 default = nil)
  if valid_568567 != nil:
    section.add "$skiptoken", valid_568567
  var valid_568568 = query.getOrDefault("$filter")
  valid_568568 = validateParameter(valid_568568, JString, required = false,
                                 default = nil)
  if valid_568568 != nil:
    section.add "$filter", valid_568568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568569: Call_SubscriptionDimensionsList_568560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568569.validator(path, query, header, formData, body)
  let scheme = call_568569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568569.url(scheme.get, call_568569.host, call_568569.base,
                         call_568569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568569, url, valid)

proc call*(call_568570: Call_SubscriptionDimensionsList_568560; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## subscriptionDimensionsList
  ## Lists the dimensions by subscription Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var path_568571 = newJObject()
  var query_568572 = newJObject()
  add(query_568572, "api-version", newJString(apiVersion))
  add(query_568572, "$expand", newJString(Expand))
  add(path_568571, "subscriptionId", newJString(subscriptionId))
  add(query_568572, "$top", newJInt(Top))
  add(query_568572, "$skiptoken", newJString(Skiptoken))
  add(query_568572, "$filter", newJString(Filter))
  result = call_568570.call(path_568571, query_568572, nil, nil, nil)

var subscriptionDimensionsList* = Call_SubscriptionDimensionsList_568560(
    name: "subscriptionDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_SubscriptionDimensionsList_568561, base: "",
    url: url_SubscriptionDimensionsList_568562, schemes: {Scheme.Https})
type
  Call_ReportsList_568573 = ref object of OpenApiRestCall_567668
proc url_ReportsList_568575(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.CostManagement/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsList_568574(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all reports for a subscription.
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
  var valid_568576 = path.getOrDefault("subscriptionId")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "subscriptionId", valid_568576
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568577 = query.getOrDefault("api-version")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "api-version", valid_568577
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568578: Call_ReportsList_568573; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568578.validator(path, query, header, formData, body)
  let scheme = call_568578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568578.url(scheme.get, call_568578.host, call_568578.base,
                         call_568578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568578, url, valid)

proc call*(call_568579: Call_ReportsList_568573; apiVersion: string;
          subscriptionId: string): Recallable =
  ## reportsList
  ## Lists all reports for a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568580 = newJObject()
  var query_568581 = newJObject()
  add(query_568581, "api-version", newJString(apiVersion))
  add(path_568580, "subscriptionId", newJString(subscriptionId))
  result = call_568579.call(path_568580, query_568581, nil, nil, nil)

var reportsList* = Call_ReportsList_568573(name: "reportsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports",
                                        validator: validate_ReportsList_568574,
                                        base: "", url: url_ReportsList_568575,
                                        schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdate_568592 = ref object of OpenApiRestCall_567668
proc url_ReportsCreateOrUpdate_568594(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsCreateOrUpdate_568593(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a report. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568595 = path.getOrDefault("subscriptionId")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "subscriptionId", valid_568595
  var valid_568596 = path.getOrDefault("reportName")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "reportName", valid_568596
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568597 = query.getOrDefault("api-version")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "api-version", valid_568597
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568599: Call_ReportsCreateOrUpdate_568592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a report. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568599.validator(path, query, header, formData, body)
  let scheme = call_568599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568599.url(scheme.get, call_568599.host, call_568599.base,
                         call_568599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568599, url, valid)

proc call*(call_568600: Call_ReportsCreateOrUpdate_568592; apiVersion: string;
          subscriptionId: string; reportName: string; parameters: JsonNode): Recallable =
  ## reportsCreateOrUpdate
  ## The operation to create or update a report. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  var path_568601 = newJObject()
  var query_568602 = newJObject()
  var body_568603 = newJObject()
  add(query_568602, "api-version", newJString(apiVersion))
  add(path_568601, "subscriptionId", newJString(subscriptionId))
  add(path_568601, "reportName", newJString(reportName))
  if parameters != nil:
    body_568603 = parameters
  result = call_568600.call(path_568601, query_568602, nil, nil, body_568603)

var reportsCreateOrUpdate* = Call_ReportsCreateOrUpdate_568592(
    name: "reportsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdate_568593, base: "",
    url: url_ReportsCreateOrUpdate_568594, schemes: {Scheme.Https})
type
  Call_ReportsGet_568582 = ref object of OpenApiRestCall_567668
proc url_ReportsGet_568584(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsGet_568583(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the report for a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568585 = path.getOrDefault("subscriptionId")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "subscriptionId", valid_568585
  var valid_568586 = path.getOrDefault("reportName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "reportName", valid_568586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568587 = query.getOrDefault("api-version")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "api-version", valid_568587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568588: Call_ReportsGet_568582; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568588.validator(path, query, header, formData, body)
  let scheme = call_568588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568588.url(scheme.get, call_568588.host, call_568588.base,
                         call_568588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568588, url, valid)

proc call*(call_568589: Call_ReportsGet_568582; apiVersion: string;
          subscriptionId: string; reportName: string): Recallable =
  ## reportsGet
  ## Gets the report for a subscription by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  var path_568590 = newJObject()
  var query_568591 = newJObject()
  add(query_568591, "api-version", newJString(apiVersion))
  add(path_568590, "subscriptionId", newJString(subscriptionId))
  add(path_568590, "reportName", newJString(reportName))
  result = call_568589.call(path_568590, query_568591, nil, nil, nil)

var reportsGet* = Call_ReportsGet_568582(name: "reportsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}",
                                      validator: validate_ReportsGet_568583,
                                      base: "", url: url_ReportsGet_568584,
                                      schemes: {Scheme.Https})
type
  Call_ReportsDelete_568604 = ref object of OpenApiRestCall_567668
proc url_ReportsDelete_568606(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsDelete_568605(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568607 = path.getOrDefault("subscriptionId")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "subscriptionId", valid_568607
  var valid_568608 = path.getOrDefault("reportName")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "reportName", valid_568608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568609 = query.getOrDefault("api-version")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "api-version", valid_568609
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568610: Call_ReportsDelete_568604; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568610.validator(path, query, header, formData, body)
  let scheme = call_568610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568610.url(scheme.get, call_568610.host, call_568610.base,
                         call_568610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568610, url, valid)

proc call*(call_568611: Call_ReportsDelete_568604; apiVersion: string;
          subscriptionId: string; reportName: string): Recallable =
  ## reportsDelete
  ## The operation to delete a report.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  var path_568612 = newJObject()
  var query_568613 = newJObject()
  add(query_568613, "api-version", newJString(apiVersion))
  add(path_568612, "subscriptionId", newJString(subscriptionId))
  add(path_568612, "reportName", newJString(reportName))
  result = call_568611.call(path_568612, query_568613, nil, nil, nil)

var reportsDelete* = Call_ReportsDelete_568604(name: "reportsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDelete_568605, base: "", url: url_ReportsDelete_568606,
    schemes: {Scheme.Https})
type
  Call_ReportsExecute_568614 = ref object of OpenApiRestCall_567668
proc url_ReportsExecute_568616(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName"),
               (kind: ConstantSegment, value: "/run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsExecute_568615(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The operation to execute a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568617 = path.getOrDefault("subscriptionId")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "subscriptionId", valid_568617
  var valid_568618 = path.getOrDefault("reportName")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "reportName", valid_568618
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568619 = query.getOrDefault("api-version")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "api-version", valid_568619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568620: Call_ReportsExecute_568614; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to execute a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568620.validator(path, query, header, formData, body)
  let scheme = call_568620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568620.url(scheme.get, call_568620.host, call_568620.base,
                         call_568620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568620, url, valid)

proc call*(call_568621: Call_ReportsExecute_568614; apiVersion: string;
          subscriptionId: string; reportName: string): Recallable =
  ## reportsExecute
  ## The operation to execute a report.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  var path_568622 = newJObject()
  var query_568623 = newJObject()
  add(query_568623, "api-version", newJString(apiVersion))
  add(path_568622, "subscriptionId", newJString(subscriptionId))
  add(path_568622, "reportName", newJString(reportName))
  result = call_568621.call(path_568622, query_568623, nil, nil, nil)

var reportsExecute* = Call_ReportsExecute_568614(name: "reportsExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecute_568615, base: "", url: url_ReportsExecute_568616,
    schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistory_568624 = ref object of OpenApiRestCall_567668
proc url_ReportsGetExecutionHistory_568626(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName"),
               (kind: ConstantSegment, value: "/runHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsGetExecutionHistory_568625(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the execution history of a report for a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568627 = path.getOrDefault("subscriptionId")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "subscriptionId", valid_568627
  var valid_568628 = path.getOrDefault("reportName")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "reportName", valid_568628
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568629 = query.getOrDefault("api-version")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "api-version", valid_568629
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568630: Call_ReportsGetExecutionHistory_568624; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the execution history of a report for a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568630.validator(path, query, header, formData, body)
  let scheme = call_568630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568630.url(scheme.get, call_568630.host, call_568630.base,
                         call_568630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568630, url, valid)

proc call*(call_568631: Call_ReportsGetExecutionHistory_568624; apiVersion: string;
          subscriptionId: string; reportName: string): Recallable =
  ## reportsGetExecutionHistory
  ## Gets the execution history of a report for a subscription by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  var path_568632 = newJObject()
  var query_568633 = newJObject()
  add(query_568633, "api-version", newJString(apiVersion))
  add(path_568632, "subscriptionId", newJString(subscriptionId))
  add(path_568632, "reportName", newJString(reportName))
  result = call_568631.call(path_568632, query_568633, nil, nil, nil)

var reportsGetExecutionHistory* = Call_ReportsGetExecutionHistory_568624(
    name: "reportsGetExecutionHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistory_568625, base: "",
    url: url_ReportsGetExecutionHistory_568626, schemes: {Scheme.Https})
type
  Call_AlertsListByResourceGroupName_568634 = ref object of OpenApiRestCall_567668
proc url_AlertsListByResourceGroupName_568636(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.CostManagement/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListByResourceGroupName_568635(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all alerts for a resource group under a subscription.
  ## 
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
  var valid_568637 = path.getOrDefault("resourceGroupName")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "resourceGroupName", valid_568637
  var valid_568638 = path.getOrDefault("subscriptionId")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "subscriptionId", valid_568638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N alerts.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568639 = query.getOrDefault("api-version")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "api-version", valid_568639
  var valid_568640 = query.getOrDefault("$top")
  valid_568640 = validateParameter(valid_568640, JInt, required = false, default = nil)
  if valid_568640 != nil:
    section.add "$top", valid_568640
  var valid_568641 = query.getOrDefault("$skiptoken")
  valid_568641 = validateParameter(valid_568641, JString, required = false,
                                 default = nil)
  if valid_568641 != nil:
    section.add "$skiptoken", valid_568641
  var valid_568642 = query.getOrDefault("$filter")
  valid_568642 = validateParameter(valid_568642, JString, required = false,
                                 default = nil)
  if valid_568642 != nil:
    section.add "$filter", valid_568642
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568643: Call_AlertsListByResourceGroupName_568634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for a resource group under a subscription.
  ## 
  let valid = call_568643.validator(path, query, header, formData, body)
  let scheme = call_568643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568643.url(scheme.get, call_568643.host, call_568643.base,
                         call_568643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568643, url, valid)

proc call*(call_568644: Call_AlertsListByResourceGroupName_568634;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## alertsListByResourceGroupName
  ## List all alerts for a resource group under a subscription.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N alerts.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_568645 = newJObject()
  var query_568646 = newJObject()
  add(path_568645, "resourceGroupName", newJString(resourceGroupName))
  add(query_568646, "api-version", newJString(apiVersion))
  add(path_568645, "subscriptionId", newJString(subscriptionId))
  add(query_568646, "$top", newJInt(Top))
  add(query_568646, "$skiptoken", newJString(Skiptoken))
  add(query_568646, "$filter", newJString(Filter))
  result = call_568644.call(path_568645, query_568646, nil, nil, nil)

var alertsListByResourceGroupName* = Call_AlertsListByResourceGroupName_568634(
    name: "alertsListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByResourceGroupName_568635, base: "",
    url: url_AlertsListByResourceGroupName_568636, schemes: {Scheme.Https})
type
  Call_AlertsGetByResourceGroupName_568647 = ref object of OpenApiRestCall_567668
proc url_AlertsGetByResourceGroupName_568649(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetByResourceGroupName_568648(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert for a resource group under a subscription by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   alertId: JString (required)
  ##          : Alert ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568650 = path.getOrDefault("resourceGroupName")
  valid_568650 = validateParameter(valid_568650, JString, required = true,
                                 default = nil)
  if valid_568650 != nil:
    section.add "resourceGroupName", valid_568650
  var valid_568651 = path.getOrDefault("subscriptionId")
  valid_568651 = validateParameter(valid_568651, JString, required = true,
                                 default = nil)
  if valid_568651 != nil:
    section.add "subscriptionId", valid_568651
  var valid_568652 = path.getOrDefault("alertId")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "alertId", valid_568652
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568653 = query.getOrDefault("api-version")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "api-version", valid_568653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568654: Call_AlertsGetByResourceGroupName_568647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for a resource group under a subscription by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568654.validator(path, query, header, formData, body)
  let scheme = call_568654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568654.url(scheme.get, call_568654.host, call_568654.base,
                         call_568654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568654, url, valid)

proc call*(call_568655: Call_AlertsGetByResourceGroupName_568647;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          alertId: string): Recallable =
  ## alertsGetByResourceGroupName
  ## Gets the alert for a resource group under a subscription by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   alertId: string (required)
  ##          : Alert ID.
  var path_568656 = newJObject()
  var query_568657 = newJObject()
  add(path_568656, "resourceGroupName", newJString(resourceGroupName))
  add(query_568657, "api-version", newJString(apiVersion))
  add(path_568656, "subscriptionId", newJString(subscriptionId))
  add(path_568656, "alertId", newJString(alertId))
  result = call_568655.call(path_568656, query_568657, nil, nil, nil)

var alertsGetByResourceGroupName* = Call_AlertsGetByResourceGroupName_568647(
    name: "alertsGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByResourceGroupName_568648, base: "",
    url: url_AlertsGetByResourceGroupName_568649, schemes: {Scheme.Https})
type
  Call_AlertsUpdateResourceGroupNameAlertStatus_568658 = ref object of OpenApiRestCall_567668
proc url_AlertsUpdateResourceGroupNameAlertStatus_568660(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/updateStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsUpdateResourceGroupNameAlertStatus_568659(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update alerts status for a resource group under a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   alertId: JString (required)
  ##          : Alert ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568661 = path.getOrDefault("resourceGroupName")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "resourceGroupName", valid_568661
  var valid_568662 = path.getOrDefault("subscriptionId")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "subscriptionId", valid_568662
  var valid_568663 = path.getOrDefault("alertId")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "alertId", valid_568663
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568664 = query.getOrDefault("api-version")
  valid_568664 = validateParameter(valid_568664, JString, required = true,
                                 default = nil)
  if valid_568664 != nil:
    section.add "api-version", valid_568664
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568666: Call_AlertsUpdateResourceGroupNameAlertStatus_568658;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for a resource group under a subscription.
  ## 
  let valid = call_568666.validator(path, query, header, formData, body)
  let scheme = call_568666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568666.url(scheme.get, call_568666.host, call_568666.base,
                         call_568666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568666, url, valid)

proc call*(call_568667: Call_AlertsUpdateResourceGroupNameAlertStatus_568658;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          alertId: string; parameters: JsonNode): Recallable =
  ## alertsUpdateResourceGroupNameAlertStatus
  ## Update alerts status for a resource group under a subscription.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  var path_568668 = newJObject()
  var query_568669 = newJObject()
  var body_568670 = newJObject()
  add(path_568668, "resourceGroupName", newJString(resourceGroupName))
  add(query_568669, "api-version", newJString(apiVersion))
  add(path_568668, "subscriptionId", newJString(subscriptionId))
  add(path_568668, "alertId", newJString(alertId))
  if parameters != nil:
    body_568670 = parameters
  result = call_568667.call(path_568668, query_568669, nil, nil, body_568670)

var alertsUpdateResourceGroupNameAlertStatus* = Call_AlertsUpdateResourceGroupNameAlertStatus_568658(
    name: "alertsUpdateResourceGroupNameAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateResourceGroupNameAlertStatus_568659, base: "",
    url: url_AlertsUpdateResourceGroupNameAlertStatus_568660,
    schemes: {Scheme.Https})
type
  Call_ResourceGroupDimensionsList_568671 = ref object of OpenApiRestCall_567668
proc url_ResourceGroupDimensionsList_568673(protocol: Scheme; host: string;
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

proc validate_ResourceGroupDimensionsList_568672(path: JsonNode; query: JsonNode;
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
  var valid_568674 = path.getOrDefault("resourceGroupName")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "resourceGroupName", valid_568674
  var valid_568675 = path.getOrDefault("subscriptionId")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "subscriptionId", valid_568675
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var valid_568676 = query.getOrDefault("api-version")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "api-version", valid_568676
  var valid_568677 = query.getOrDefault("$expand")
  valid_568677 = validateParameter(valid_568677, JString, required = false,
                                 default = nil)
  if valid_568677 != nil:
    section.add "$expand", valid_568677
  var valid_568678 = query.getOrDefault("$top")
  valid_568678 = validateParameter(valid_568678, JInt, required = false, default = nil)
  if valid_568678 != nil:
    section.add "$top", valid_568678
  var valid_568679 = query.getOrDefault("$skiptoken")
  valid_568679 = validateParameter(valid_568679, JString, required = false,
                                 default = nil)
  if valid_568679 != nil:
    section.add "$skiptoken", valid_568679
  var valid_568680 = query.getOrDefault("$filter")
  valid_568680 = validateParameter(valid_568680, JString, required = false,
                                 default = nil)
  if valid_568680 != nil:
    section.add "$filter", valid_568680
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568681: Call_ResourceGroupDimensionsList_568671; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by resource group Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568681.validator(path, query, header, formData, body)
  let scheme = call_568681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568681.url(scheme.get, call_568681.host, call_568681.base,
                         call_568681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568681, url, valid)

proc call*(call_568682: Call_ResourceGroupDimensionsList_568671;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## resourceGroupDimensionsList
  ## Lists the dimensions by resource group Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var path_568683 = newJObject()
  var query_568684 = newJObject()
  add(path_568683, "resourceGroupName", newJString(resourceGroupName))
  add(query_568684, "api-version", newJString(apiVersion))
  add(query_568684, "$expand", newJString(Expand))
  add(path_568683, "subscriptionId", newJString(subscriptionId))
  add(query_568684, "$top", newJInt(Top))
  add(query_568684, "$skiptoken", newJString(Skiptoken))
  add(query_568684, "$filter", newJString(Filter))
  result = call_568682.call(path_568683, query_568684, nil, nil, nil)

var resourceGroupDimensionsList* = Call_ResourceGroupDimensionsList_568671(
    name: "resourceGroupDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_ResourceGroupDimensionsList_568672, base: "",
    url: url_ResourceGroupDimensionsList_568673, schemes: {Scheme.Https})
type
  Call_ReportsListByResourceGroupName_568685 = ref object of OpenApiRestCall_567668
proc url_ReportsListByResourceGroupName_568687(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CostManagement/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByResourceGroupName_568686(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all reports for a resource group under a subscription.
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
  var valid_568688 = path.getOrDefault("resourceGroupName")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "resourceGroupName", valid_568688
  var valid_568689 = path.getOrDefault("subscriptionId")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "subscriptionId", valid_568689
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568690 = query.getOrDefault("api-version")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "api-version", valid_568690
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568691: Call_ReportsListByResourceGroupName_568685; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568691.validator(path, query, header, formData, body)
  let scheme = call_568691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568691.url(scheme.get, call_568691.host, call_568691.base,
                         call_568691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568691, url, valid)

proc call*(call_568692: Call_ReportsListByResourceGroupName_568685;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## reportsListByResourceGroupName
  ## Lists all reports for a resource group under a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568693 = newJObject()
  var query_568694 = newJObject()
  add(path_568693, "resourceGroupName", newJString(resourceGroupName))
  add(query_568694, "api-version", newJString(apiVersion))
  add(path_568693, "subscriptionId", newJString(subscriptionId))
  result = call_568692.call(path_568693, query_568694, nil, nil, nil)

var reportsListByResourceGroupName* = Call_ReportsListByResourceGroupName_568685(
    name: "reportsListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports",
    validator: validate_ReportsListByResourceGroupName_568686, base: "",
    url: url_ReportsListByResourceGroupName_568687, schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdateByResourceGroupName_568706 = ref object of OpenApiRestCall_567668
proc url_ReportsCreateOrUpdateByResourceGroupName_568708(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsCreateOrUpdateByResourceGroupName_568707(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a report. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568709 = path.getOrDefault("resourceGroupName")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "resourceGroupName", valid_568709
  var valid_568710 = path.getOrDefault("subscriptionId")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "subscriptionId", valid_568710
  var valid_568711 = path.getOrDefault("reportName")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "reportName", valid_568711
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568712 = query.getOrDefault("api-version")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "api-version", valid_568712
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568714: Call_ReportsCreateOrUpdateByResourceGroupName_568706;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a report. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568714.validator(path, query, header, formData, body)
  let scheme = call_568714.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568714.url(scheme.get, call_568714.host, call_568714.base,
                         call_568714.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568714, url, valid)

proc call*(call_568715: Call_ReportsCreateOrUpdateByResourceGroupName_568706;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          reportName: string; parameters: JsonNode): Recallable =
  ## reportsCreateOrUpdateByResourceGroupName
  ## The operation to create or update a report. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  var path_568716 = newJObject()
  var query_568717 = newJObject()
  var body_568718 = newJObject()
  add(path_568716, "resourceGroupName", newJString(resourceGroupName))
  add(query_568717, "api-version", newJString(apiVersion))
  add(path_568716, "subscriptionId", newJString(subscriptionId))
  add(path_568716, "reportName", newJString(reportName))
  if parameters != nil:
    body_568718 = parameters
  result = call_568715.call(path_568716, query_568717, nil, nil, body_568718)

var reportsCreateOrUpdateByResourceGroupName* = Call_ReportsCreateOrUpdateByResourceGroupName_568706(
    name: "reportsCreateOrUpdateByResourceGroupName", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdateByResourceGroupName_568707, base: "",
    url: url_ReportsCreateOrUpdateByResourceGroupName_568708,
    schemes: {Scheme.Https})
type
  Call_ReportsGetByResourceGroupName_568695 = ref object of OpenApiRestCall_567668
proc url_ReportsGetByResourceGroupName_568697(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsGetByResourceGroupName_568696(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the report for a resource group under a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568698 = path.getOrDefault("resourceGroupName")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "resourceGroupName", valid_568698
  var valid_568699 = path.getOrDefault("subscriptionId")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "subscriptionId", valid_568699
  var valid_568700 = path.getOrDefault("reportName")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "reportName", valid_568700
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568701 = query.getOrDefault("api-version")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "api-version", valid_568701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568702: Call_ReportsGetByResourceGroupName_568695; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a resource group under a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568702.validator(path, query, header, formData, body)
  let scheme = call_568702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568702.url(scheme.get, call_568702.host, call_568702.base,
                         call_568702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568702, url, valid)

proc call*(call_568703: Call_ReportsGetByResourceGroupName_568695;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          reportName: string): Recallable =
  ## reportsGetByResourceGroupName
  ## Gets the report for a resource group under a subscription by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  var path_568704 = newJObject()
  var query_568705 = newJObject()
  add(path_568704, "resourceGroupName", newJString(resourceGroupName))
  add(query_568705, "api-version", newJString(apiVersion))
  add(path_568704, "subscriptionId", newJString(subscriptionId))
  add(path_568704, "reportName", newJString(reportName))
  result = call_568703.call(path_568704, query_568705, nil, nil, nil)

var reportsGetByResourceGroupName* = Call_ReportsGetByResourceGroupName_568695(
    name: "reportsGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsGetByResourceGroupName_568696, base: "",
    url: url_ReportsGetByResourceGroupName_568697, schemes: {Scheme.Https})
type
  Call_ReportsDeleteByResourceGroupName_568719 = ref object of OpenApiRestCall_567668
proc url_ReportsDeleteByResourceGroupName_568721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsDeleteByResourceGroupName_568720(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568722 = path.getOrDefault("resourceGroupName")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "resourceGroupName", valid_568722
  var valid_568723 = path.getOrDefault("subscriptionId")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "subscriptionId", valid_568723
  var valid_568724 = path.getOrDefault("reportName")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "reportName", valid_568724
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568725 = query.getOrDefault("api-version")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "api-version", valid_568725
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568726: Call_ReportsDeleteByResourceGroupName_568719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568726.validator(path, query, header, formData, body)
  let scheme = call_568726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568726.url(scheme.get, call_568726.host, call_568726.base,
                         call_568726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568726, url, valid)

proc call*(call_568727: Call_ReportsDeleteByResourceGroupName_568719;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          reportName: string): Recallable =
  ## reportsDeleteByResourceGroupName
  ## The operation to delete a report.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  var path_568728 = newJObject()
  var query_568729 = newJObject()
  add(path_568728, "resourceGroupName", newJString(resourceGroupName))
  add(query_568729, "api-version", newJString(apiVersion))
  add(path_568728, "subscriptionId", newJString(subscriptionId))
  add(path_568728, "reportName", newJString(reportName))
  result = call_568727.call(path_568728, query_568729, nil, nil, nil)

var reportsDeleteByResourceGroupName* = Call_ReportsDeleteByResourceGroupName_568719(
    name: "reportsDeleteByResourceGroupName", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDeleteByResourceGroupName_568720, base: "",
    url: url_ReportsDeleteByResourceGroupName_568721, schemes: {Scheme.Https})
type
  Call_ReportsExecuteByResourceGroupName_568730 = ref object of OpenApiRestCall_567668
proc url_ReportsExecuteByResourceGroupName_568732(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName"),
               (kind: ConstantSegment, value: "/run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsExecuteByResourceGroupName_568731(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to execute a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568733 = path.getOrDefault("resourceGroupName")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "resourceGroupName", valid_568733
  var valid_568734 = path.getOrDefault("subscriptionId")
  valid_568734 = validateParameter(valid_568734, JString, required = true,
                                 default = nil)
  if valid_568734 != nil:
    section.add "subscriptionId", valid_568734
  var valid_568735 = path.getOrDefault("reportName")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "reportName", valid_568735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568736 = query.getOrDefault("api-version")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "api-version", valid_568736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568737: Call_ReportsExecuteByResourceGroupName_568730;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to execute a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568737.validator(path, query, header, formData, body)
  let scheme = call_568737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568737.url(scheme.get, call_568737.host, call_568737.base,
                         call_568737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568737, url, valid)

proc call*(call_568738: Call_ReportsExecuteByResourceGroupName_568730;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          reportName: string): Recallable =
  ## reportsExecuteByResourceGroupName
  ## The operation to execute a report.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  var path_568739 = newJObject()
  var query_568740 = newJObject()
  add(path_568739, "resourceGroupName", newJString(resourceGroupName))
  add(query_568740, "api-version", newJString(apiVersion))
  add(path_568739, "subscriptionId", newJString(subscriptionId))
  add(path_568739, "reportName", newJString(reportName))
  result = call_568738.call(path_568739, query_568740, nil, nil, nil)

var reportsExecuteByResourceGroupName* = Call_ReportsExecuteByResourceGroupName_568730(
    name: "reportsExecuteByResourceGroupName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecuteByResourceGroupName_568731, base: "",
    url: url_ReportsExecuteByResourceGroupName_568732, schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistoryByResourceGroupName_568741 = ref object of OpenApiRestCall_567668
proc url_ReportsGetExecutionHistoryByResourceGroupName_568743(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "reportName" in path, "`reportName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/reports/"),
               (kind: VariableSegment, value: "reportName"),
               (kind: ConstantSegment, value: "/runHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsGetExecutionHistoryByResourceGroupName_568742(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the execution history of a report for a resource group by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568744 = path.getOrDefault("resourceGroupName")
  valid_568744 = validateParameter(valid_568744, JString, required = true,
                                 default = nil)
  if valid_568744 != nil:
    section.add "resourceGroupName", valid_568744
  var valid_568745 = path.getOrDefault("subscriptionId")
  valid_568745 = validateParameter(valid_568745, JString, required = true,
                                 default = nil)
  if valid_568745 != nil:
    section.add "subscriptionId", valid_568745
  var valid_568746 = path.getOrDefault("reportName")
  valid_568746 = validateParameter(valid_568746, JString, required = true,
                                 default = nil)
  if valid_568746 != nil:
    section.add "reportName", valid_568746
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568747 = query.getOrDefault("api-version")
  valid_568747 = validateParameter(valid_568747, JString, required = true,
                                 default = nil)
  if valid_568747 != nil:
    section.add "api-version", valid_568747
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568748: Call_ReportsGetExecutionHistoryByResourceGroupName_568741;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the execution history of a report for a resource group by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568748.validator(path, query, header, formData, body)
  let scheme = call_568748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568748.url(scheme.get, call_568748.host, call_568748.base,
                         call_568748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568748, url, valid)

proc call*(call_568749: Call_ReportsGetExecutionHistoryByResourceGroupName_568741;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          reportName: string): Recallable =
  ## reportsGetExecutionHistoryByResourceGroupName
  ## Gets the execution history of a report for a resource group by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  var path_568750 = newJObject()
  var query_568751 = newJObject()
  add(path_568750, "resourceGroupName", newJString(resourceGroupName))
  add(query_568751, "api-version", newJString(apiVersion))
  add(path_568750, "subscriptionId", newJString(subscriptionId))
  add(path_568750, "reportName", newJString(reportName))
  result = call_568749.call(path_568750, query_568751, nil, nil, nil)

var reportsGetExecutionHistoryByResourceGroupName* = Call_ReportsGetExecutionHistoryByResourceGroupName_568741(
    name: "reportsGetExecutionHistoryByResourceGroupName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistoryByResourceGroupName_568742,
    base: "", url: url_ReportsGetExecutionHistoryByResourceGroupName_568743,
    schemes: {Scheme.Https})
type
  Call_QueryResourceGroup_568752 = ref object of OpenApiRestCall_567668
proc url_QueryResourceGroup_568754(protocol: Scheme; host: string; base: string;
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

proc validate_QueryResourceGroup_568753(path: JsonNode; query: JsonNode;
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
  var valid_568755 = path.getOrDefault("resourceGroupName")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "resourceGroupName", valid_568755
  var valid_568756 = path.getOrDefault("subscriptionId")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "subscriptionId", valid_568756
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568757 = query.getOrDefault("api-version")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "api-version", valid_568757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568759: Call_QueryResourceGroup_568752; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568759.validator(path, query, header, formData, body)
  let scheme = call_568759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568759.url(scheme.get, call_568759.host, call_568759.base,
                         call_568759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568759, url, valid)

proc call*(call_568760: Call_QueryResourceGroup_568752; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## queryResourceGroup
  ## Lists the usage data for subscriptionId and resource group.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  var path_568761 = newJObject()
  var query_568762 = newJObject()
  var body_568763 = newJObject()
  add(path_568761, "resourceGroupName", newJString(resourceGroupName))
  add(query_568762, "api-version", newJString(apiVersion))
  add(path_568761, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568763 = parameters
  result = call_568760.call(path_568761, query_568762, nil, nil, body_568763)

var queryResourceGroup* = Call_QueryResourceGroup_568752(
    name: "queryResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryResourceGroup_568753, base: "",
    url: url_QueryResourceGroup_568754, schemes: {Scheme.Https})
type
  Call_ConnectorListByResourceGroupName_568764 = ref object of OpenApiRestCall_567668
proc url_ConnectorListByResourceGroupName_568766(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CostManagement/connectors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorListByResourceGroupName_568765(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all connector definitions for a resource group under a subscription.
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
  var valid_568767 = path.getOrDefault("resourceGroupName")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "resourceGroupName", valid_568767
  var valid_568768 = path.getOrDefault("subscriptionId")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "subscriptionId", valid_568768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568769 = query.getOrDefault("api-version")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "api-version", valid_568769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568770: Call_ConnectorListByResourceGroupName_568764;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all connector definitions for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568770.validator(path, query, header, formData, body)
  let scheme = call_568770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568770.url(scheme.get, call_568770.host, call_568770.base,
                         call_568770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568770, url, valid)

proc call*(call_568771: Call_ConnectorListByResourceGroupName_568764;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## connectorListByResourceGroupName
  ## List all connector definitions for a resource group under a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568772 = newJObject()
  var query_568773 = newJObject()
  add(path_568772, "resourceGroupName", newJString(resourceGroupName))
  add(query_568773, "api-version", newJString(apiVersion))
  add(path_568772, "subscriptionId", newJString(subscriptionId))
  result = call_568771.call(path_568772, query_568773, nil, nil, nil)

var connectorListByResourceGroupName* = Call_ConnectorListByResourceGroupName_568764(
    name: "connectorListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors",
    validator: validate_ConnectorListByResourceGroupName_568765, base: "",
    url: url_ConnectorListByResourceGroupName_568766, schemes: {Scheme.Https})
type
  Call_ConnectorCreateOrUpdate_568785 = ref object of OpenApiRestCall_567668
proc url_ConnectorCreateOrUpdate_568787(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/connectors/"),
               (kind: VariableSegment, value: "connectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorCreateOrUpdate_568786(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: JString (required)
  ##                : Connector Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568788 = path.getOrDefault("resourceGroupName")
  valid_568788 = validateParameter(valid_568788, JString, required = true,
                                 default = nil)
  if valid_568788 != nil:
    section.add "resourceGroupName", valid_568788
  var valid_568789 = path.getOrDefault("subscriptionId")
  valid_568789 = validateParameter(valid_568789, JString, required = true,
                                 default = nil)
  if valid_568789 != nil:
    section.add "subscriptionId", valid_568789
  var valid_568790 = path.getOrDefault("connectorName")
  valid_568790 = validateParameter(valid_568790, JString, required = true,
                                 default = nil)
  if valid_568790 != nil:
    section.add "connectorName", valid_568790
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568791 = query.getOrDefault("api-version")
  valid_568791 = validateParameter(valid_568791, JString, required = true,
                                 default = nil)
  if valid_568791 != nil:
    section.add "api-version", valid_568791
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

proc call*(call_568793: Call_ConnectorCreateOrUpdate_568785; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568793.validator(path, query, header, formData, body)
  let scheme = call_568793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568793.url(scheme.get, call_568793.host, call_568793.base,
                         call_568793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568793, url, valid)

proc call*(call_568794: Call_ConnectorCreateOrUpdate_568785;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          connector: JsonNode; connectorName: string): Recallable =
  ## connectorCreateOrUpdate
  ## Create or update a connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   connector: JObject (required)
  ##            : Connector details
  ##   connectorName: string (required)
  ##                : Connector Name.
  var path_568795 = newJObject()
  var query_568796 = newJObject()
  var body_568797 = newJObject()
  add(path_568795, "resourceGroupName", newJString(resourceGroupName))
  add(query_568796, "api-version", newJString(apiVersion))
  add(path_568795, "subscriptionId", newJString(subscriptionId))
  if connector != nil:
    body_568797 = connector
  add(path_568795, "connectorName", newJString(connectorName))
  result = call_568794.call(path_568795, query_568796, nil, nil, body_568797)

var connectorCreateOrUpdate* = Call_ConnectorCreateOrUpdate_568785(
    name: "connectorCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorCreateOrUpdate_568786, base: "",
    url: url_ConnectorCreateOrUpdate_568787, schemes: {Scheme.Https})
type
  Call_ConnectorGet_568774 = ref object of OpenApiRestCall_567668
proc url_ConnectorGet_568776(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/connectors/"),
               (kind: VariableSegment, value: "connectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorGet_568775(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: JString (required)
  ##                : Connector Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568777 = path.getOrDefault("resourceGroupName")
  valid_568777 = validateParameter(valid_568777, JString, required = true,
                                 default = nil)
  if valid_568777 != nil:
    section.add "resourceGroupName", valid_568777
  var valid_568778 = path.getOrDefault("subscriptionId")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "subscriptionId", valid_568778
  var valid_568779 = path.getOrDefault("connectorName")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "connectorName", valid_568779
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568780 = query.getOrDefault("api-version")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "api-version", valid_568780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568781: Call_ConnectorGet_568774; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568781.validator(path, query, header, formData, body)
  let scheme = call_568781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568781.url(scheme.get, call_568781.host, call_568781.base,
                         call_568781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568781, url, valid)

proc call*(call_568782: Call_ConnectorGet_568774; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; connectorName: string): Recallable =
  ## connectorGet
  ## Get a connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: string (required)
  ##                : Connector Name.
  var path_568783 = newJObject()
  var query_568784 = newJObject()
  add(path_568783, "resourceGroupName", newJString(resourceGroupName))
  add(query_568784, "api-version", newJString(apiVersion))
  add(path_568783, "subscriptionId", newJString(subscriptionId))
  add(path_568783, "connectorName", newJString(connectorName))
  result = call_568782.call(path_568783, query_568784, nil, nil, nil)

var connectorGet* = Call_ConnectorGet_568774(name: "connectorGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorGet_568775, base: "", url: url_ConnectorGet_568776,
    schemes: {Scheme.Https})
type
  Call_ConnectorUpdate_568809 = ref object of OpenApiRestCall_567668
proc url_ConnectorUpdate_568811(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/connectors/"),
               (kind: VariableSegment, value: "connectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorUpdate_568810(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Update a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: JString (required)
  ##                : Connector Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568812 = path.getOrDefault("resourceGroupName")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "resourceGroupName", valid_568812
  var valid_568813 = path.getOrDefault("subscriptionId")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "subscriptionId", valid_568813
  var valid_568814 = path.getOrDefault("connectorName")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "connectorName", valid_568814
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568815 = query.getOrDefault("api-version")
  valid_568815 = validateParameter(valid_568815, JString, required = true,
                                 default = nil)
  if valid_568815 != nil:
    section.add "api-version", valid_568815
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

proc call*(call_568817: Call_ConnectorUpdate_568809; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568817.validator(path, query, header, formData, body)
  let scheme = call_568817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568817.url(scheme.get, call_568817.host, call_568817.base,
                         call_568817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568817, url, valid)

proc call*(call_568818: Call_ConnectorUpdate_568809; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; connector: JsonNode;
          connectorName: string): Recallable =
  ## connectorUpdate
  ## Update a connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   connector: JObject (required)
  ##            : Connector details
  ##   connectorName: string (required)
  ##                : Connector Name.
  var path_568819 = newJObject()
  var query_568820 = newJObject()
  var body_568821 = newJObject()
  add(path_568819, "resourceGroupName", newJString(resourceGroupName))
  add(query_568820, "api-version", newJString(apiVersion))
  add(path_568819, "subscriptionId", newJString(subscriptionId))
  if connector != nil:
    body_568821 = connector
  add(path_568819, "connectorName", newJString(connectorName))
  result = call_568818.call(path_568819, query_568820, nil, nil, body_568821)

var connectorUpdate* = Call_ConnectorUpdate_568809(name: "connectorUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorUpdate_568810, base: "", url: url_ConnectorUpdate_568811,
    schemes: {Scheme.Https})
type
  Call_ConnectorDelete_568798 = ref object of OpenApiRestCall_567668
proc url_ConnectorDelete_568800(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CostManagement/connectors/"),
               (kind: VariableSegment, value: "connectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorDelete_568799(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: JString (required)
  ##                : Connector Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568801 = path.getOrDefault("resourceGroupName")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "resourceGroupName", valid_568801
  var valid_568802 = path.getOrDefault("subscriptionId")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = nil)
  if valid_568802 != nil:
    section.add "subscriptionId", valid_568802
  var valid_568803 = path.getOrDefault("connectorName")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "connectorName", valid_568803
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568804 = query.getOrDefault("api-version")
  valid_568804 = validateParameter(valid_568804, JString, required = true,
                                 default = nil)
  if valid_568804 != nil:
    section.add "api-version", valid_568804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568805: Call_ConnectorDelete_568798; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_568805.validator(path, query, header, formData, body)
  let scheme = call_568805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568805.url(scheme.get, call_568805.host, call_568805.base,
                         call_568805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568805, url, valid)

proc call*(call_568806: Call_ConnectorDelete_568798; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; connectorName: string): Recallable =
  ## connectorDelete
  ## Delete a connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: string (required)
  ##                : Connector Name.
  var path_568807 = newJObject()
  var query_568808 = newJObject()
  add(path_568807, "resourceGroupName", newJString(resourceGroupName))
  add(query_568808, "api-version", newJString(apiVersion))
  add(path_568807, "subscriptionId", newJString(subscriptionId))
  add(path_568807, "connectorName", newJString(connectorName))
  result = call_568806.call(path_568807, query_568808, nil, nil, nil)

var connectorDelete* = Call_ConnectorDelete_568798(name: "connectorDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorDelete_568799, base: "", url: url_ConnectorDelete_568800,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
