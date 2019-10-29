
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  Call_AlertsListByDepartment_563788 = ref object of OpenApiRestCall_563566
proc url_AlertsListByDepartment_563790(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsListByDepartment_563789(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all alerts for a department.
  ## 
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
  var valid_563966 = path.getOrDefault("departmentId")
  valid_563966 = validateParameter(valid_563966, JString, required = true,
                                 default = nil)
  if valid_563966 != nil:
    section.add "departmentId", valid_563966
  var valid_563967 = path.getOrDefault("billingAccountId")
  valid_563967 = validateParameter(valid_563967, JString, required = true,
                                 default = nil)
  if valid_563967 != nil:
    section.add "billingAccountId", valid_563967
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
  var valid_563968 = query.getOrDefault("api-version")
  valid_563968 = validateParameter(valid_563968, JString, required = true,
                                 default = nil)
  if valid_563968 != nil:
    section.add "api-version", valid_563968
  var valid_563969 = query.getOrDefault("$top")
  valid_563969 = validateParameter(valid_563969, JInt, required = false, default = nil)
  if valid_563969 != nil:
    section.add "$top", valid_563969
  var valid_563970 = query.getOrDefault("$skiptoken")
  valid_563970 = validateParameter(valid_563970, JString, required = false,
                                 default = nil)
  if valid_563970 != nil:
    section.add "$skiptoken", valid_563970
  var valid_563971 = query.getOrDefault("$filter")
  valid_563971 = validateParameter(valid_563971, JString, required = false,
                                 default = nil)
  if valid_563971 != nil:
    section.add "$filter", valid_563971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563994: Call_AlertsListByDepartment_563788; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for a department.
  ## 
  let valid = call_563994.validator(path, query, header, formData, body)
  let scheme = call_563994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563994.url(scheme.get, call_563994.host, call_563994.base,
                         call_563994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563994, url, valid)

proc call*(call_564065: Call_AlertsListByDepartment_563788; apiVersion: string;
          departmentId: string; billingAccountId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## alertsListByDepartment
  ## List all alerts for a department.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N alerts.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_564066 = newJObject()
  var query_564068 = newJObject()
  add(query_564068, "api-version", newJString(apiVersion))
  add(query_564068, "$top", newJInt(Top))
  add(path_564066, "departmentId", newJString(departmentId))
  add(query_564068, "$skiptoken", newJString(Skiptoken))
  add(path_564066, "billingAccountId", newJString(billingAccountId))
  add(query_564068, "$filter", newJString(Filter))
  result = call_564065.call(path_564066, query_564068, nil, nil, nil)

var alertsListByDepartment* = Call_AlertsListByDepartment_563788(
    name: "alertsListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByDepartment_563789, base: "",
    url: url_AlertsListByDepartment_563790, schemes: {Scheme.Https})
type
  Call_AlertsGetByDepartment_564107 = ref object of OpenApiRestCall_563566
proc url_AlertsGetByDepartment_564109(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetByDepartment_564108(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert for a department by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564110 = path.getOrDefault("alertId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "alertId", valid_564110
  var valid_564111 = path.getOrDefault("departmentId")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "departmentId", valid_564111
  var valid_564112 = path.getOrDefault("billingAccountId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "billingAccountId", valid_564112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564113 = query.getOrDefault("api-version")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "api-version", valid_564113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_AlertsGetByDepartment_564107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for a department by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564114.validator(path, query, header, formData, body)
  let scheme = call_564114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564114.url(scheme.get, call_564114.host, call_564114.base,
                         call_564114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564114, url, valid)

proc call*(call_564115: Call_AlertsGetByDepartment_564107; alertId: string;
          apiVersion: string; departmentId: string; billingAccountId: string): Recallable =
  ## alertsGetByDepartment
  ## Gets the alert for a department by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_564116 = newJObject()
  var query_564117 = newJObject()
  add(path_564116, "alertId", newJString(alertId))
  add(query_564117, "api-version", newJString(apiVersion))
  add(path_564116, "departmentId", newJString(departmentId))
  add(path_564116, "billingAccountId", newJString(billingAccountId))
  result = call_564115.call(path_564116, query_564117, nil, nil, nil)

var alertsGetByDepartment* = Call_AlertsGetByDepartment_564107(
    name: "alertsGetByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByDepartment_564108, base: "",
    url: url_AlertsGetByDepartment_564109, schemes: {Scheme.Https})
type
  Call_AlertsUpdateDepartmentsAlertStatus_564118 = ref object of OpenApiRestCall_563566
proc url_AlertsUpdateDepartmentsAlertStatus_564120(protocol: Scheme; host: string;
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

proc validate_AlertsUpdateDepartmentsAlertStatus_564119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update alerts status for a department.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564121 = path.getOrDefault("alertId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "alertId", valid_564121
  var valid_564122 = path.getOrDefault("departmentId")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "departmentId", valid_564122
  var valid_564123 = path.getOrDefault("billingAccountId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "billingAccountId", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564124 = query.getOrDefault("api-version")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "api-version", valid_564124
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

proc call*(call_564126: Call_AlertsUpdateDepartmentsAlertStatus_564118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for a department.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_AlertsUpdateDepartmentsAlertStatus_564118;
          alertId: string; apiVersion: string; departmentId: string;
          billingAccountId: string; parameters: JsonNode): Recallable =
  ## alertsUpdateDepartmentsAlertStatus
  ## Update alerts status for a department.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  var body_564130 = newJObject()
  add(path_564128, "alertId", newJString(alertId))
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "departmentId", newJString(departmentId))
  add(path_564128, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_564130 = parameters
  result = call_564127.call(path_564128, query_564129, nil, nil, body_564130)

var alertsUpdateDepartmentsAlertStatus* = Call_AlertsUpdateDepartmentsAlertStatus_564118(
    name: "alertsUpdateDepartmentsAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateDepartmentsAlertStatus_564119, base: "",
    url: url_AlertsUpdateDepartmentsAlertStatus_564120, schemes: {Scheme.Https})
type
  Call_AlertsListByAccount_564131 = ref object of OpenApiRestCall_563566
proc url_AlertsListByAccount_564133(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsListByAccount_564132(path: JsonNode; query: JsonNode;
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
  var valid_564134 = path.getOrDefault("enrollmentAccountId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "enrollmentAccountId", valid_564134
  var valid_564135 = path.getOrDefault("billingAccountId")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "billingAccountId", valid_564135
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
  var valid_564136 = query.getOrDefault("api-version")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "api-version", valid_564136
  var valid_564137 = query.getOrDefault("$top")
  valid_564137 = validateParameter(valid_564137, JInt, required = false, default = nil)
  if valid_564137 != nil:
    section.add "$top", valid_564137
  var valid_564138 = query.getOrDefault("$skiptoken")
  valid_564138 = validateParameter(valid_564138, JString, required = false,
                                 default = nil)
  if valid_564138 != nil:
    section.add "$skiptoken", valid_564138
  var valid_564139 = query.getOrDefault("$filter")
  valid_564139 = validateParameter(valid_564139, JString, required = false,
                                 default = nil)
  if valid_564139 != nil:
    section.add "$filter", valid_564139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_AlertsListByAccount_564131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for an account.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_AlertsListByAccount_564131; apiVersion: string;
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
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(query_564143, "api-version", newJString(apiVersion))
  add(query_564143, "$top", newJInt(Top))
  add(query_564143, "$skiptoken", newJString(Skiptoken))
  add(path_564142, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_564142, "billingAccountId", newJString(billingAccountId))
  add(query_564143, "$filter", newJString(Filter))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var alertsListByAccount* = Call_AlertsListByAccount_564131(
    name: "alertsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByAccount_564132, base: "",
    url: url_AlertsListByAccount_564133, schemes: {Scheme.Https})
type
  Call_AlertsGetByAccount_564144 = ref object of OpenApiRestCall_563566
proc url_AlertsGetByAccount_564146(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetByAccount_564145(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the alert for an account by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   enrollmentAccountId: JString (required)
  ##                      : Enrollment Account Id
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564147 = path.getOrDefault("alertId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "alertId", valid_564147
  var valid_564148 = path.getOrDefault("enrollmentAccountId")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "enrollmentAccountId", valid_564148
  var valid_564149 = path.getOrDefault("billingAccountId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "billingAccountId", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "api-version", valid_564150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564151: Call_AlertsGetByAccount_564144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for an account by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564151.validator(path, query, header, formData, body)
  let scheme = call_564151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564151.url(scheme.get, call_564151.host, call_564151.base,
                         call_564151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564151, url, valid)

proc call*(call_564152: Call_AlertsGetByAccount_564144; alertId: string;
          apiVersion: string; enrollmentAccountId: string; billingAccountId: string): Recallable =
  ## alertsGetByAccount
  ## Gets the alert for an account by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   enrollmentAccountId: string (required)
  ##                      : Enrollment Account Id
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_564153 = newJObject()
  var query_564154 = newJObject()
  add(path_564153, "alertId", newJString(alertId))
  add(query_564154, "api-version", newJString(apiVersion))
  add(path_564153, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_564153, "billingAccountId", newJString(billingAccountId))
  result = call_564152.call(path_564153, query_564154, nil, nil, nil)

var alertsGetByAccount* = Call_AlertsGetByAccount_564144(
    name: "alertsGetByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByAccount_564145, base: "",
    url: url_AlertsGetByAccount_564146, schemes: {Scheme.Https})
type
  Call_AlertsUpdateEnrollmentAccountAlertStatus_564155 = ref object of OpenApiRestCall_563566
proc url_AlertsUpdateEnrollmentAccountAlertStatus_564157(protocol: Scheme;
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

proc validate_AlertsUpdateEnrollmentAccountAlertStatus_564156(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update alerts status for an enrollment account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   enrollmentAccountId: JString (required)
  ##                      : Enrollment Account Id
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564158 = path.getOrDefault("alertId")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "alertId", valid_564158
  var valid_564159 = path.getOrDefault("enrollmentAccountId")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "enrollmentAccountId", valid_564159
  var valid_564160 = path.getOrDefault("billingAccountId")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "billingAccountId", valid_564160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "api-version", valid_564161
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

proc call*(call_564163: Call_AlertsUpdateEnrollmentAccountAlertStatus_564155;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for an enrollment account.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_AlertsUpdateEnrollmentAccountAlertStatus_564155;
          alertId: string; apiVersion: string; enrollmentAccountId: string;
          billingAccountId: string; parameters: JsonNode): Recallable =
  ## alertsUpdateEnrollmentAccountAlertStatus
  ## Update alerts status for an enrollment account.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   enrollmentAccountId: string (required)
  ##                      : Enrollment Account Id
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  var body_564167 = newJObject()
  add(path_564165, "alertId", newJString(alertId))
  add(query_564166, "api-version", newJString(apiVersion))
  add(path_564165, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_564165, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_564167 = parameters
  result = call_564164.call(path_564165, query_564166, nil, nil, body_564167)

var alertsUpdateEnrollmentAccountAlertStatus* = Call_AlertsUpdateEnrollmentAccountAlertStatus_564155(
    name: "alertsUpdateEnrollmentAccountAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateEnrollmentAccountAlertStatus_564156, base: "",
    url: url_AlertsUpdateEnrollmentAccountAlertStatus_564157,
    schemes: {Scheme.Https})
type
  Call_QueryBillingAccount_564168 = ref object of OpenApiRestCall_563566
proc url_QueryBillingAccount_564170(protocol: Scheme; host: string; base: string;
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

proc validate_QueryBillingAccount_564169(path: JsonNode; query: JsonNode;
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
  var valid_564188 = path.getOrDefault("billingAccountId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "billingAccountId", valid_564188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564189 = query.getOrDefault("api-version")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "api-version", valid_564189
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

proc call*(call_564191: Call_QueryBillingAccount_564168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_QueryBillingAccount_564168; apiVersion: string;
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
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  var body_564195 = newJObject()
  add(query_564194, "api-version", newJString(apiVersion))
  add(path_564193, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_564195 = parameters
  result = call_564192.call(path_564193, query_564194, nil, nil, body_564195)

var queryBillingAccount* = Call_QueryBillingAccount_564168(
    name: "queryBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryBillingAccount_564169, base: "",
    url: url_QueryBillingAccount_564170, schemes: {Scheme.Https})
type
  Call_AlertsListByEnrollment_564196 = ref object of OpenApiRestCall_563566
proc url_AlertsListByEnrollment_564198(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsListByEnrollment_564197(path: JsonNode; query: JsonNode;
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
  var valid_564199 = path.getOrDefault("billingAccountId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "billingAccountId", valid_564199
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
  var valid_564200 = query.getOrDefault("api-version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "api-version", valid_564200
  var valid_564201 = query.getOrDefault("$top")
  valid_564201 = validateParameter(valid_564201, JInt, required = false, default = nil)
  if valid_564201 != nil:
    section.add "$top", valid_564201
  var valid_564202 = query.getOrDefault("$skiptoken")
  valid_564202 = validateParameter(valid_564202, JString, required = false,
                                 default = nil)
  if valid_564202 != nil:
    section.add "$skiptoken", valid_564202
  var valid_564203 = query.getOrDefault("$filter")
  valid_564203 = validateParameter(valid_564203, JString, required = false,
                                 default = nil)
  if valid_564203 != nil:
    section.add "$filter", valid_564203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_AlertsListByEnrollment_564196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for an enrollment.
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_AlertsListByEnrollment_564196; apiVersion: string;
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
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(query_564207, "api-version", newJString(apiVersion))
  add(query_564207, "$top", newJInt(Top))
  add(query_564207, "$skiptoken", newJString(Skiptoken))
  add(path_564206, "billingAccountId", newJString(billingAccountId))
  add(query_564207, "$filter", newJString(Filter))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var alertsListByEnrollment* = Call_AlertsListByEnrollment_564196(
    name: "alertsListByEnrollment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByEnrollment_564197, base: "",
    url: url_AlertsListByEnrollment_564198, schemes: {Scheme.Https})
type
  Call_AlertsGetByEnrollment_564208 = ref object of OpenApiRestCall_563566
proc url_AlertsGetByEnrollment_564210(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetByEnrollment_564209(path: JsonNode; query: JsonNode;
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
  var valid_564211 = path.getOrDefault("alertId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "alertId", valid_564211
  var valid_564212 = path.getOrDefault("billingAccountId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "billingAccountId", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "api-version", valid_564213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564214: Call_AlertsGetByEnrollment_564208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for an enrollment by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564214.validator(path, query, header, formData, body)
  let scheme = call_564214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564214.url(scheme.get, call_564214.host, call_564214.base,
                         call_564214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564214, url, valid)

proc call*(call_564215: Call_AlertsGetByEnrollment_564208; alertId: string;
          apiVersion: string; billingAccountId: string): Recallable =
  ## alertsGetByEnrollment
  ## Gets the alert for an enrollment by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_564216 = newJObject()
  var query_564217 = newJObject()
  add(path_564216, "alertId", newJString(alertId))
  add(query_564217, "api-version", newJString(apiVersion))
  add(path_564216, "billingAccountId", newJString(billingAccountId))
  result = call_564215.call(path_564216, query_564217, nil, nil, nil)

var alertsGetByEnrollment* = Call_AlertsGetByEnrollment_564208(
    name: "alertsGetByEnrollment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByEnrollment_564209, base: "",
    url: url_AlertsGetByEnrollment_564210, schemes: {Scheme.Https})
type
  Call_AlertsUpdateBillingAccountAlertStatus_564218 = ref object of OpenApiRestCall_563566
proc url_AlertsUpdateBillingAccountAlertStatus_564220(protocol: Scheme;
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

proc validate_AlertsUpdateBillingAccountAlertStatus_564219(path: JsonNode;
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
  var valid_564221 = path.getOrDefault("alertId")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "alertId", valid_564221
  var valid_564222 = path.getOrDefault("billingAccountId")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "billingAccountId", valid_564222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564223 = query.getOrDefault("api-version")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "api-version", valid_564223
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

proc call*(call_564225: Call_AlertsUpdateBillingAccountAlertStatus_564218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for billing account.
  ## 
  let valid = call_564225.validator(path, query, header, formData, body)
  let scheme = call_564225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564225.url(scheme.get, call_564225.host, call_564225.base,
                         call_564225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564225, url, valid)

proc call*(call_564226: Call_AlertsUpdateBillingAccountAlertStatus_564218;
          alertId: string; apiVersion: string; billingAccountId: string;
          parameters: JsonNode): Recallable =
  ## alertsUpdateBillingAccountAlertStatus
  ## Update alerts status for billing account.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  var path_564227 = newJObject()
  var query_564228 = newJObject()
  var body_564229 = newJObject()
  add(path_564227, "alertId", newJString(alertId))
  add(query_564228, "api-version", newJString(apiVersion))
  add(path_564227, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_564229 = parameters
  result = call_564226.call(path_564227, query_564228, nil, nil, body_564229)

var alertsUpdateBillingAccountAlertStatus* = Call_AlertsUpdateBillingAccountAlertStatus_564218(
    name: "alertsUpdateBillingAccountAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateBillingAccountAlertStatus_564219, base: "",
    url: url_AlertsUpdateBillingAccountAlertStatus_564220, schemes: {Scheme.Https})
type
  Call_BillingAccountDimensionsList_564230 = ref object of OpenApiRestCall_563566
proc url_BillingAccountDimensionsList_564232(protocol: Scheme; host: string;
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

proc validate_BillingAccountDimensionsList_564231(path: JsonNode; query: JsonNode;
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
  var valid_564233 = path.getOrDefault("billingAccountId")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "billingAccountId", valid_564233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var valid_564234 = query.getOrDefault("api-version")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "api-version", valid_564234
  var valid_564235 = query.getOrDefault("$top")
  valid_564235 = validateParameter(valid_564235, JInt, required = false, default = nil)
  if valid_564235 != nil:
    section.add "$top", valid_564235
  var valid_564236 = query.getOrDefault("$expand")
  valid_564236 = validateParameter(valid_564236, JString, required = false,
                                 default = nil)
  if valid_564236 != nil:
    section.add "$expand", valid_564236
  var valid_564237 = query.getOrDefault("$skiptoken")
  valid_564237 = validateParameter(valid_564237, JString, required = false,
                                 default = nil)
  if valid_564237 != nil:
    section.add "$skiptoken", valid_564237
  var valid_564238 = query.getOrDefault("$filter")
  valid_564238 = validateParameter(valid_564238, JString, required = false,
                                 default = nil)
  if valid_564238 != nil:
    section.add "$filter", valid_564238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564239: Call_BillingAccountDimensionsList_564230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by billingAccount Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564239.validator(path, query, header, formData, body)
  let scheme = call_564239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564239.url(scheme.get, call_564239.host, call_564239.base,
                         call_564239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564239, url, valid)

proc call*(call_564240: Call_BillingAccountDimensionsList_564230;
          apiVersion: string; billingAccountId: string; Top: int = 0;
          Expand: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## billingAccountDimensionsList
  ## Lists the dimensions by billingAccount Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var path_564241 = newJObject()
  var query_564242 = newJObject()
  add(query_564242, "api-version", newJString(apiVersion))
  add(query_564242, "$top", newJInt(Top))
  add(query_564242, "$expand", newJString(Expand))
  add(query_564242, "$skiptoken", newJString(Skiptoken))
  add(path_564241, "billingAccountId", newJString(billingAccountId))
  add(query_564242, "$filter", newJString(Filter))
  result = call_564240.call(path_564241, query_564242, nil, nil, nil)

var billingAccountDimensionsList* = Call_BillingAccountDimensionsList_564230(
    name: "billingAccountDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_BillingAccountDimensionsList_564231, base: "",
    url: url_BillingAccountDimensionsList_564232, schemes: {Scheme.Https})
type
  Call_ReportsListByBillingAccount_564243 = ref object of OpenApiRestCall_563566
proc url_ReportsListByBillingAccount_564245(protocol: Scheme; host: string;
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

proc validate_ReportsListByBillingAccount_564244(path: JsonNode; query: JsonNode;
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
  var valid_564246 = path.getOrDefault("billingAccountId")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "billingAccountId", valid_564246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564247 = query.getOrDefault("api-version")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "api-version", valid_564247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564248: Call_ReportsListByBillingAccount_564243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564248.validator(path, query, header, formData, body)
  let scheme = call_564248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564248.url(scheme.get, call_564248.host, call_564248.base,
                         call_564248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564248, url, valid)

proc call*(call_564249: Call_ReportsListByBillingAccount_564243;
          apiVersion: string; billingAccountId: string): Recallable =
  ## reportsListByBillingAccount
  ## Lists all reports for a billing account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_564250 = newJObject()
  var query_564251 = newJObject()
  add(query_564251, "api-version", newJString(apiVersion))
  add(path_564250, "billingAccountId", newJString(billingAccountId))
  result = call_564249.call(path_564250, query_564251, nil, nil, nil)

var reportsListByBillingAccount* = Call_ReportsListByBillingAccount_564243(
    name: "reportsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports",
    validator: validate_ReportsListByBillingAccount_564244, base: "",
    url: url_ReportsListByBillingAccount_564245, schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdateByBillingAccount_564262 = ref object of OpenApiRestCall_563566
proc url_ReportsCreateOrUpdateByBillingAccount_564264(protocol: Scheme;
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

proc validate_ReportsCreateOrUpdateByBillingAccount_564263(path: JsonNode;
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
  var valid_564265 = path.getOrDefault("reportName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "reportName", valid_564265
  var valid_564266 = path.getOrDefault("billingAccountId")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "billingAccountId", valid_564266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564267 = query.getOrDefault("api-version")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "api-version", valid_564267
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

proc call*(call_564269: Call_ReportsCreateOrUpdateByBillingAccount_564262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a report for billingAccount. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564269.validator(path, query, header, formData, body)
  let scheme = call_564269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564269.url(scheme.get, call_564269.host, call_564269.base,
                         call_564269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564269, url, valid)

proc call*(call_564270: Call_ReportsCreateOrUpdateByBillingAccount_564262;
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
  var path_564271 = newJObject()
  var query_564272 = newJObject()
  var body_564273 = newJObject()
  add(query_564272, "api-version", newJString(apiVersion))
  add(path_564271, "reportName", newJString(reportName))
  add(path_564271, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_564273 = parameters
  result = call_564270.call(path_564271, query_564272, nil, nil, body_564273)

var reportsCreateOrUpdateByBillingAccount* = Call_ReportsCreateOrUpdateByBillingAccount_564262(
    name: "reportsCreateOrUpdateByBillingAccount", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdateByBillingAccount_564263, base: "",
    url: url_ReportsCreateOrUpdateByBillingAccount_564264, schemes: {Scheme.Https})
type
  Call_ReportsGetByBillingAccount_564252 = ref object of OpenApiRestCall_563566
proc url_ReportsGetByBillingAccount_564254(protocol: Scheme; host: string;
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

proc validate_ReportsGetByBillingAccount_564253(path: JsonNode; query: JsonNode;
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
  var valid_564255 = path.getOrDefault("reportName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "reportName", valid_564255
  var valid_564256 = path.getOrDefault("billingAccountId")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "billingAccountId", valid_564256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "api-version", valid_564257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564258: Call_ReportsGetByBillingAccount_564252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a billing account by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564258.validator(path, query, header, formData, body)
  let scheme = call_564258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564258.url(scheme.get, call_564258.host, call_564258.base,
                         call_564258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564258, url, valid)

proc call*(call_564259: Call_ReportsGetByBillingAccount_564252; apiVersion: string;
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
  var path_564260 = newJObject()
  var query_564261 = newJObject()
  add(query_564261, "api-version", newJString(apiVersion))
  add(path_564260, "reportName", newJString(reportName))
  add(path_564260, "billingAccountId", newJString(billingAccountId))
  result = call_564259.call(path_564260, query_564261, nil, nil, nil)

var reportsGetByBillingAccount* = Call_ReportsGetByBillingAccount_564252(
    name: "reportsGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsGetByBillingAccount_564253, base: "",
    url: url_ReportsGetByBillingAccount_564254, schemes: {Scheme.Https})
type
  Call_ReportsDeleteByBillingAccount_564274 = ref object of OpenApiRestCall_563566
proc url_ReportsDeleteByBillingAccount_564276(protocol: Scheme; host: string;
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

proc validate_ReportsDeleteByBillingAccount_564275(path: JsonNode; query: JsonNode;
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
  var valid_564277 = path.getOrDefault("reportName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "reportName", valid_564277
  var valid_564278 = path.getOrDefault("billingAccountId")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "billingAccountId", valid_564278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564279 = query.getOrDefault("api-version")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "api-version", valid_564279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564280: Call_ReportsDeleteByBillingAccount_564274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a report for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564280.validator(path, query, header, formData, body)
  let scheme = call_564280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564280.url(scheme.get, call_564280.host, call_564280.base,
                         call_564280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564280, url, valid)

proc call*(call_564281: Call_ReportsDeleteByBillingAccount_564274;
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
  var path_564282 = newJObject()
  var query_564283 = newJObject()
  add(query_564283, "api-version", newJString(apiVersion))
  add(path_564282, "reportName", newJString(reportName))
  add(path_564282, "billingAccountId", newJString(billingAccountId))
  result = call_564281.call(path_564282, query_564283, nil, nil, nil)

var reportsDeleteByBillingAccount* = Call_ReportsDeleteByBillingAccount_564274(
    name: "reportsDeleteByBillingAccount", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDeleteByBillingAccount_564275, base: "",
    url: url_ReportsDeleteByBillingAccount_564276, schemes: {Scheme.Https})
type
  Call_ReportsExecuteByBillingAccount_564284 = ref object of OpenApiRestCall_563566
proc url_ReportsExecuteByBillingAccount_564286(protocol: Scheme; host: string;
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

proc validate_ReportsExecuteByBillingAccount_564285(path: JsonNode;
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
  var valid_564287 = path.getOrDefault("reportName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "reportName", valid_564287
  var valid_564288 = path.getOrDefault("billingAccountId")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "billingAccountId", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564289 = query.getOrDefault("api-version")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "api-version", valid_564289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564290: Call_ReportsExecuteByBillingAccount_564284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to execute a report by billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_ReportsExecuteByBillingAccount_564284;
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
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "reportName", newJString(reportName))
  add(path_564292, "billingAccountId", newJString(billingAccountId))
  result = call_564291.call(path_564292, query_564293, nil, nil, nil)

var reportsExecuteByBillingAccount* = Call_ReportsExecuteByBillingAccount_564284(
    name: "reportsExecuteByBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecuteByBillingAccount_564285, base: "",
    url: url_ReportsExecuteByBillingAccount_564286, schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistoryByBillingAccount_564294 = ref object of OpenApiRestCall_563566
proc url_ReportsGetExecutionHistoryByBillingAccount_564296(protocol: Scheme;
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

proc validate_ReportsGetExecutionHistoryByBillingAccount_564295(path: JsonNode;
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
  var valid_564297 = path.getOrDefault("reportName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "reportName", valid_564297
  var valid_564298 = path.getOrDefault("billingAccountId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "billingAccountId", valid_564298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564299 = query.getOrDefault("api-version")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "api-version", valid_564299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564300: Call_ReportsGetExecutionHistoryByBillingAccount_564294;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the execution history of a report for a billing account by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564300.validator(path, query, header, formData, body)
  let scheme = call_564300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564300.url(scheme.get, call_564300.host, call_564300.base,
                         call_564300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564300, url, valid)

proc call*(call_564301: Call_ReportsGetExecutionHistoryByBillingAccount_564294;
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
  var path_564302 = newJObject()
  var query_564303 = newJObject()
  add(query_564303, "api-version", newJString(apiVersion))
  add(path_564302, "reportName", newJString(reportName))
  add(path_564302, "billingAccountId", newJString(billingAccountId))
  result = call_564301.call(path_564302, query_564303, nil, nil, nil)

var reportsGetExecutionHistoryByBillingAccount* = Call_ReportsGetExecutionHistoryByBillingAccount_564294(
    name: "reportsGetExecutionHistoryByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistoryByBillingAccount_564295,
    base: "", url: url_ReportsGetExecutionHistoryByBillingAccount_564296,
    schemes: {Scheme.Https})
type
  Call_ReportsListByDepartment_564304 = ref object of OpenApiRestCall_563566
proc url_ReportsListByDepartment_564306(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByDepartment_564305(path: JsonNode; query: JsonNode;
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
  var valid_564307 = path.getOrDefault("departmentId")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "departmentId", valid_564307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564308 = query.getOrDefault("api-version")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "api-version", valid_564308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564309: Call_ReportsListByDepartment_564304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564309.validator(path, query, header, formData, body)
  let scheme = call_564309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564309.url(scheme.get, call_564309.host, call_564309.base,
                         call_564309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564309, url, valid)

proc call*(call_564310: Call_ReportsListByDepartment_564304; apiVersion: string;
          departmentId: string): Recallable =
  ## reportsListByDepartment
  ## Lists all reports for a department.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   departmentId: string (required)
  ##               : Department ID
  var path_564311 = newJObject()
  var query_564312 = newJObject()
  add(query_564312, "api-version", newJString(apiVersion))
  add(path_564311, "departmentId", newJString(departmentId))
  result = call_564310.call(path_564311, query_564312, nil, nil, nil)

var reportsListByDepartment* = Call_ReportsListByDepartment_564304(
    name: "reportsListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports",
    validator: validate_ReportsListByDepartment_564305, base: "",
    url: url_ReportsListByDepartment_564306, schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdateByDepartment_564323 = ref object of OpenApiRestCall_563566
proc url_ReportsCreateOrUpdateByDepartment_564325(protocol: Scheme; host: string;
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

proc validate_ReportsCreateOrUpdateByDepartment_564324(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a report for department. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564326 = path.getOrDefault("departmentId")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "departmentId", valid_564326
  var valid_564327 = path.getOrDefault("reportName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "reportName", valid_564327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564328 = query.getOrDefault("api-version")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "api-version", valid_564328
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

proc call*(call_564330: Call_ReportsCreateOrUpdateByDepartment_564323;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a report for department. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564330.validator(path, query, header, formData, body)
  let scheme = call_564330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564330.url(scheme.get, call_564330.host, call_564330.base,
                         call_564330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564330, url, valid)

proc call*(call_564331: Call_ReportsCreateOrUpdateByDepartment_564323;
          apiVersion: string; departmentId: string; reportName: string;
          parameters: JsonNode): Recallable =
  ## reportsCreateOrUpdateByDepartment
  ## The operation to create or update a report for department. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   reportName: string (required)
  ##             : Report Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  var path_564332 = newJObject()
  var query_564333 = newJObject()
  var body_564334 = newJObject()
  add(query_564333, "api-version", newJString(apiVersion))
  add(path_564332, "departmentId", newJString(departmentId))
  add(path_564332, "reportName", newJString(reportName))
  if parameters != nil:
    body_564334 = parameters
  result = call_564331.call(path_564332, query_564333, nil, nil, body_564334)

var reportsCreateOrUpdateByDepartment* = Call_ReportsCreateOrUpdateByDepartment_564323(
    name: "reportsCreateOrUpdateByDepartment", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdateByDepartment_564324, base: "",
    url: url_ReportsCreateOrUpdateByDepartment_564325, schemes: {Scheme.Https})
type
  Call_ReportsGetByDepartment_564313 = ref object of OpenApiRestCall_563566
proc url_ReportsGetByDepartment_564315(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsGetByDepartment_564314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the report for a department by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564316 = path.getOrDefault("departmentId")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "departmentId", valid_564316
  var valid_564317 = path.getOrDefault("reportName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "reportName", valid_564317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564318 = query.getOrDefault("api-version")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "api-version", valid_564318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564319: Call_ReportsGetByDepartment_564313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a department by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564319.validator(path, query, header, formData, body)
  let scheme = call_564319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564319.url(scheme.get, call_564319.host, call_564319.base,
                         call_564319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564319, url, valid)

proc call*(call_564320: Call_ReportsGetByDepartment_564313; apiVersion: string;
          departmentId: string; reportName: string): Recallable =
  ## reportsGetByDepartment
  ## Gets the report for a department by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   reportName: string (required)
  ##             : Report Name.
  var path_564321 = newJObject()
  var query_564322 = newJObject()
  add(query_564322, "api-version", newJString(apiVersion))
  add(path_564321, "departmentId", newJString(departmentId))
  add(path_564321, "reportName", newJString(reportName))
  result = call_564320.call(path_564321, query_564322, nil, nil, nil)

var reportsGetByDepartment* = Call_ReportsGetByDepartment_564313(
    name: "reportsGetByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsGetByDepartment_564314, base: "",
    url: url_ReportsGetByDepartment_564315, schemes: {Scheme.Https})
type
  Call_ReportsDeleteByDepartment_564335 = ref object of OpenApiRestCall_563566
proc url_ReportsDeleteByDepartment_564337(protocol: Scheme; host: string;
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

proc validate_ReportsDeleteByDepartment_564336(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a report for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564338 = path.getOrDefault("departmentId")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "departmentId", valid_564338
  var valid_564339 = path.getOrDefault("reportName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "reportName", valid_564339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564340 = query.getOrDefault("api-version")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "api-version", valid_564340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564341: Call_ReportsDeleteByDepartment_564335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a report for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564341.validator(path, query, header, formData, body)
  let scheme = call_564341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564341.url(scheme.get, call_564341.host, call_564341.base,
                         call_564341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564341, url, valid)

proc call*(call_564342: Call_ReportsDeleteByDepartment_564335; apiVersion: string;
          departmentId: string; reportName: string): Recallable =
  ## reportsDeleteByDepartment
  ## The operation to delete a report for department.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   reportName: string (required)
  ##             : Report Name.
  var path_564343 = newJObject()
  var query_564344 = newJObject()
  add(query_564344, "api-version", newJString(apiVersion))
  add(path_564343, "departmentId", newJString(departmentId))
  add(path_564343, "reportName", newJString(reportName))
  result = call_564342.call(path_564343, query_564344, nil, nil, nil)

var reportsDeleteByDepartment* = Call_ReportsDeleteByDepartment_564335(
    name: "reportsDeleteByDepartment", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDeleteByDepartment_564336, base: "",
    url: url_ReportsDeleteByDepartment_564337, schemes: {Scheme.Https})
type
  Call_ReportsExecuteByDepartment_564345 = ref object of OpenApiRestCall_563566
proc url_ReportsExecuteByDepartment_564347(protocol: Scheme; host: string;
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

proc validate_ReportsExecuteByDepartment_564346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to execute a report by department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564348 = path.getOrDefault("departmentId")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "departmentId", valid_564348
  var valid_564349 = path.getOrDefault("reportName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "reportName", valid_564349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564350 = query.getOrDefault("api-version")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "api-version", valid_564350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564351: Call_ReportsExecuteByDepartment_564345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to execute a report by department.
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

proc call*(call_564352: Call_ReportsExecuteByDepartment_564345; apiVersion: string;
          departmentId: string; reportName: string): Recallable =
  ## reportsExecuteByDepartment
  ## The operation to execute a report by department.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   reportName: string (required)
  ##             : Report Name.
  var path_564353 = newJObject()
  var query_564354 = newJObject()
  add(query_564354, "api-version", newJString(apiVersion))
  add(path_564353, "departmentId", newJString(departmentId))
  add(path_564353, "reportName", newJString(reportName))
  result = call_564352.call(path_564353, query_564354, nil, nil, nil)

var reportsExecuteByDepartment* = Call_ReportsExecuteByDepartment_564345(
    name: "reportsExecuteByDepartment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecuteByDepartment_564346, base: "",
    url: url_ReportsExecuteByDepartment_564347, schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistoryByDepartment_564355 = ref object of OpenApiRestCall_563566
proc url_ReportsGetExecutionHistoryByDepartment_564357(protocol: Scheme;
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

proc validate_ReportsGetExecutionHistoryByDepartment_564356(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the execution history of a report for a department by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   reportName: JString (required)
  ##             : Report Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564358 = path.getOrDefault("departmentId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "departmentId", valid_564358
  var valid_564359 = path.getOrDefault("reportName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "reportName", valid_564359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564360 = query.getOrDefault("api-version")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "api-version", valid_564360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564361: Call_ReportsGetExecutionHistoryByDepartment_564355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the execution history of a report for a department by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564361.validator(path, query, header, formData, body)
  let scheme = call_564361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564361.url(scheme.get, call_564361.host, call_564361.base,
                         call_564361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564361, url, valid)

proc call*(call_564362: Call_ReportsGetExecutionHistoryByDepartment_564355;
          apiVersion: string; departmentId: string; reportName: string): Recallable =
  ## reportsGetExecutionHistoryByDepartment
  ## Gets the execution history of a report for a department by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   reportName: string (required)
  ##             : Report Name.
  var path_564363 = newJObject()
  var query_564364 = newJObject()
  add(query_564364, "api-version", newJString(apiVersion))
  add(path_564363, "departmentId", newJString(departmentId))
  add(path_564363, "reportName", newJString(reportName))
  result = call_564362.call(path_564363, query_564364, nil, nil, nil)

var reportsGetExecutionHistoryByDepartment* = Call_ReportsGetExecutionHistoryByDepartment_564355(
    name: "reportsGetExecutionHistoryByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistoryByDepartment_564356, base: "",
    url: url_ReportsGetExecutionHistoryByDepartment_564357,
    schemes: {Scheme.Https})
type
  Call_OperationsList_564365 = ref object of OpenApiRestCall_563566
proc url_OperationsList_564367(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564366(path: JsonNode; query: JsonNode;
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
  var valid_564368 = query.getOrDefault("api-version")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "api-version", valid_564368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564369: Call_OperationsList_564365; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available cost management REST API operations.
  ## 
  let valid = call_564369.validator(path, query, header, formData, body)
  let scheme = call_564369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564369.url(scheme.get, call_564369.host, call_564369.base,
                         call_564369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564369, url, valid)

proc call*(call_564370: Call_OperationsList_564365; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available cost management REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  var query_564371 = newJObject()
  add(query_564371, "api-version", newJString(apiVersion))
  result = call_564370.call(nil, query_564371, nil, nil, nil)

var operationsList* = Call_OperationsList_564365(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/operations",
    validator: validate_OperationsList_564366, base: "", url: url_OperationsList_564367,
    schemes: {Scheme.Https})
type
  Call_AlertsListByManagementGroups_564372 = ref object of OpenApiRestCall_563566
proc url_AlertsListByManagementGroups_564374(protocol: Scheme; host: string;
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

proc validate_AlertsListByManagementGroups_564373(path: JsonNode; query: JsonNode;
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
  var valid_564375 = path.getOrDefault("managementGroupId")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "managementGroupId", valid_564375
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
  var valid_564376 = query.getOrDefault("api-version")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "api-version", valid_564376
  var valid_564377 = query.getOrDefault("$top")
  valid_564377 = validateParameter(valid_564377, JInt, required = false, default = nil)
  if valid_564377 != nil:
    section.add "$top", valid_564377
  var valid_564378 = query.getOrDefault("$skiptoken")
  valid_564378 = validateParameter(valid_564378, JString, required = false,
                                 default = nil)
  if valid_564378 != nil:
    section.add "$skiptoken", valid_564378
  var valid_564379 = query.getOrDefault("$filter")
  valid_564379 = validateParameter(valid_564379, JString, required = false,
                                 default = nil)
  if valid_564379 != nil:
    section.add "$filter", valid_564379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564380: Call_AlertsListByManagementGroups_564372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for Management Groups.
  ## 
  let valid = call_564380.validator(path, query, header, formData, body)
  let scheme = call_564380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564380.url(scheme.get, call_564380.host, call_564380.base,
                         call_564380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564380, url, valid)

proc call*(call_564381: Call_AlertsListByManagementGroups_564372;
          managementGroupId: string; apiVersion: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## alertsListByManagementGroups
  ## List all alerts for Management Groups.
  ##   managementGroupId: string (required)
  ##                    : Management Group ID
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N alerts.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_564382 = newJObject()
  var query_564383 = newJObject()
  add(path_564382, "managementGroupId", newJString(managementGroupId))
  add(query_564383, "api-version", newJString(apiVersion))
  add(query_564383, "$top", newJInt(Top))
  add(query_564383, "$skiptoken", newJString(Skiptoken))
  add(query_564383, "$filter", newJString(Filter))
  result = call_564381.call(path_564382, query_564383, nil, nil, nil)

var alertsListByManagementGroups* = Call_AlertsListByManagementGroups_564372(
    name: "alertsListByManagementGroups", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByManagementGroups_564373, base: "",
    url: url_AlertsListByManagementGroups_564374, schemes: {Scheme.Https})
type
  Call_AlertsGetAlertByManagementGroups_564384 = ref object of OpenApiRestCall_563566
proc url_AlertsGetAlertByManagementGroups_564386(protocol: Scheme; host: string;
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

proc validate_AlertsGetAlertByManagementGroups_564385(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an alert for Management Groups by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   managementGroupId: JString (required)
  ##                    : Management Group ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564387 = path.getOrDefault("alertId")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "alertId", valid_564387
  var valid_564388 = path.getOrDefault("managementGroupId")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "managementGroupId", valid_564388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564389 = query.getOrDefault("api-version")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "api-version", valid_564389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564390: Call_AlertsGetAlertByManagementGroups_564384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an alert for Management Groups by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564390.validator(path, query, header, formData, body)
  let scheme = call_564390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564390.url(scheme.get, call_564390.host, call_564390.base,
                         call_564390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564390, url, valid)

proc call*(call_564391: Call_AlertsGetAlertByManagementGroups_564384;
          alertId: string; managementGroupId: string; apiVersion: string): Recallable =
  ## alertsGetAlertByManagementGroups
  ## Gets an alert for Management Groups by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   managementGroupId: string (required)
  ##                    : Management Group ID
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  var path_564392 = newJObject()
  var query_564393 = newJObject()
  add(path_564392, "alertId", newJString(alertId))
  add(path_564392, "managementGroupId", newJString(managementGroupId))
  add(query_564393, "api-version", newJString(apiVersion))
  result = call_564391.call(path_564392, query_564393, nil, nil, nil)

var alertsGetAlertByManagementGroups* = Call_AlertsGetAlertByManagementGroups_564384(
    name: "alertsGetAlertByManagementGroups", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetAlertByManagementGroups_564385, base: "",
    url: url_AlertsGetAlertByManagementGroups_564386, schemes: {Scheme.Https})
type
  Call_AlertsUpdateManagementGroupAlertStatus_564394 = ref object of OpenApiRestCall_563566
proc url_AlertsUpdateManagementGroupAlertStatus_564396(protocol: Scheme;
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

proc validate_AlertsUpdateManagementGroupAlertStatus_564395(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update alerts status for management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   managementGroupId: JString (required)
  ##                    : Management Group ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564397 = path.getOrDefault("alertId")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "alertId", valid_564397
  var valid_564398 = path.getOrDefault("managementGroupId")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "managementGroupId", valid_564398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564399 = query.getOrDefault("api-version")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "api-version", valid_564399
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

proc call*(call_564401: Call_AlertsUpdateManagementGroupAlertStatus_564394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for management group.
  ## 
  let valid = call_564401.validator(path, query, header, formData, body)
  let scheme = call_564401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564401.url(scheme.get, call_564401.host, call_564401.base,
                         call_564401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564401, url, valid)

proc call*(call_564402: Call_AlertsUpdateManagementGroupAlertStatus_564394;
          alertId: string; managementGroupId: string; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## alertsUpdateManagementGroupAlertStatus
  ## Update alerts status for management group.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   managementGroupId: string (required)
  ##                    : Management Group ID
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  var path_564403 = newJObject()
  var query_564404 = newJObject()
  var body_564405 = newJObject()
  add(path_564403, "alertId", newJString(alertId))
  add(path_564403, "managementGroupId", newJString(managementGroupId))
  add(query_564404, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564405 = parameters
  result = call_564402.call(path_564403, query_564404, nil, nil, body_564405)

var alertsUpdateManagementGroupAlertStatus* = Call_AlertsUpdateManagementGroupAlertStatus_564394(
    name: "alertsUpdateManagementGroupAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/alerts/{alertId}/UpdateStatus",
    validator: validate_AlertsUpdateManagementGroupAlertStatus_564395, base: "",
    url: url_AlertsUpdateManagementGroupAlertStatus_564396,
    schemes: {Scheme.Https})
type
  Call_QuerySubscription_564406 = ref object of OpenApiRestCall_563566
proc url_QuerySubscription_564408(protocol: Scheme; host: string; base: string;
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

proc validate_QuerySubscription_564407(path: JsonNode; query: JsonNode;
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
  var valid_564409 = path.getOrDefault("subscriptionId")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "subscriptionId", valid_564409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564410 = query.getOrDefault("api-version")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "api-version", valid_564410
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

proc call*(call_564412: Call_QuerySubscription_564406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564412.validator(path, query, header, formData, body)
  let scheme = call_564412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564412.url(scheme.get, call_564412.host, call_564412.base,
                         call_564412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564412, url, valid)

proc call*(call_564413: Call_QuerySubscription_564406; apiVersion: string;
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
  var path_564414 = newJObject()
  var query_564415 = newJObject()
  var body_564416 = newJObject()
  add(query_564415, "api-version", newJString(apiVersion))
  add(path_564414, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564416 = parameters
  result = call_564413.call(path_564414, query_564415, nil, nil, body_564416)

var querySubscription* = Call_QuerySubscription_564406(name: "querySubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QuerySubscription_564407, base: "",
    url: url_QuerySubscription_564408, schemes: {Scheme.Https})
type
  Call_AlertsList_564417 = ref object of OpenApiRestCall_563566
proc url_AlertsList_564419(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AlertsList_564418(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564420 = path.getOrDefault("subscriptionId")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "subscriptionId", valid_564420
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
  var valid_564421 = query.getOrDefault("api-version")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "api-version", valid_564421
  var valid_564422 = query.getOrDefault("$top")
  valid_564422 = validateParameter(valid_564422, JInt, required = false, default = nil)
  if valid_564422 != nil:
    section.add "$top", valid_564422
  var valid_564423 = query.getOrDefault("$skiptoken")
  valid_564423 = validateParameter(valid_564423, JString, required = false,
                                 default = nil)
  if valid_564423 != nil:
    section.add "$skiptoken", valid_564423
  var valid_564424 = query.getOrDefault("$filter")
  valid_564424 = validateParameter(valid_564424, JString, required = false,
                                 default = nil)
  if valid_564424 != nil:
    section.add "$filter", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564425: Call_AlertsList_564417; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for a subscription.
  ## 
  let valid = call_564425.validator(path, query, header, formData, body)
  let scheme = call_564425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564425.url(scheme.get, call_564425.host, call_564425.base,
                         call_564425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564425, url, valid)

proc call*(call_564426: Call_AlertsList_564417; apiVersion: string;
          subscriptionId: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## alertsList
  ## List all alerts for a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N alerts.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_564427 = newJObject()
  var query_564428 = newJObject()
  add(query_564428, "api-version", newJString(apiVersion))
  add(query_564428, "$top", newJInt(Top))
  add(path_564427, "subscriptionId", newJString(subscriptionId))
  add(query_564428, "$skiptoken", newJString(Skiptoken))
  add(query_564428, "$filter", newJString(Filter))
  result = call_564426.call(path_564427, query_564428, nil, nil, nil)

var alertsList* = Call_AlertsList_564417(name: "alertsList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/alerts",
                                      validator: validate_AlertsList_564418,
                                      base: "", url: url_AlertsList_564419,
                                      schemes: {Scheme.Https})
type
  Call_AlertsGetBySubscription_564429 = ref object of OpenApiRestCall_563566
proc url_AlertsGetBySubscription_564431(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetBySubscription_564430(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert for a subscription by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564432 = path.getOrDefault("alertId")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "alertId", valid_564432
  var valid_564433 = path.getOrDefault("subscriptionId")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "subscriptionId", valid_564433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564434 = query.getOrDefault("api-version")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "api-version", valid_564434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564435: Call_AlertsGetBySubscription_564429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for a subscription by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564435.validator(path, query, header, formData, body)
  let scheme = call_564435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564435.url(scheme.get, call_564435.host, call_564435.base,
                         call_564435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564435, url, valid)

proc call*(call_564436: Call_AlertsGetBySubscription_564429; alertId: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## alertsGetBySubscription
  ## Gets the alert for a subscription by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_564437 = newJObject()
  var query_564438 = newJObject()
  add(path_564437, "alertId", newJString(alertId))
  add(query_564438, "api-version", newJString(apiVersion))
  add(path_564437, "subscriptionId", newJString(subscriptionId))
  result = call_564436.call(path_564437, query_564438, nil, nil, nil)

var alertsGetBySubscription* = Call_AlertsGetBySubscription_564429(
    name: "alertsGetBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetBySubscription_564430, base: "",
    url: url_AlertsGetBySubscription_564431, schemes: {Scheme.Https})
type
  Call_AlertsUpdateSubscriptionAlertStatus_564439 = ref object of OpenApiRestCall_563566
proc url_AlertsUpdateSubscriptionAlertStatus_564441(protocol: Scheme; host: string;
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

proc validate_AlertsUpdateSubscriptionAlertStatus_564440(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update alerts status for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564442 = path.getOrDefault("alertId")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "alertId", valid_564442
  var valid_564443 = path.getOrDefault("subscriptionId")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "subscriptionId", valid_564443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564444 = query.getOrDefault("api-version")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "api-version", valid_564444
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

proc call*(call_564446: Call_AlertsUpdateSubscriptionAlertStatus_564439;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for a subscription.
  ## 
  let valid = call_564446.validator(path, query, header, formData, body)
  let scheme = call_564446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564446.url(scheme.get, call_564446.host, call_564446.base,
                         call_564446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564446, url, valid)

proc call*(call_564447: Call_AlertsUpdateSubscriptionAlertStatus_564439;
          alertId: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## alertsUpdateSubscriptionAlertStatus
  ## Update alerts status for a subscription.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  var path_564448 = newJObject()
  var query_564449 = newJObject()
  var body_564450 = newJObject()
  add(path_564448, "alertId", newJString(alertId))
  add(query_564449, "api-version", newJString(apiVersion))
  add(path_564448, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564450 = parameters
  result = call_564447.call(path_564448, query_564449, nil, nil, body_564450)

var alertsUpdateSubscriptionAlertStatus* = Call_AlertsUpdateSubscriptionAlertStatus_564439(
    name: "alertsUpdateSubscriptionAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateSubscriptionAlertStatus_564440, base: "",
    url: url_AlertsUpdateSubscriptionAlertStatus_564441, schemes: {Scheme.Https})
type
  Call_ConnectorList_564451 = ref object of OpenApiRestCall_563566
proc url_ConnectorList_564453(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorList_564452(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564454 = path.getOrDefault("subscriptionId")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "subscriptionId", valid_564454
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564455 = query.getOrDefault("api-version")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "api-version", valid_564455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564456: Call_ConnectorList_564451; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all connector definitions for a subscription
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564456.validator(path, query, header, formData, body)
  let scheme = call_564456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564456.url(scheme.get, call_564456.host, call_564456.base,
                         call_564456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564456, url, valid)

proc call*(call_564457: Call_ConnectorList_564451; apiVersion: string;
          subscriptionId: string): Recallable =
  ## connectorList
  ## List all connector definitions for a subscription
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_564458 = newJObject()
  var query_564459 = newJObject()
  add(query_564459, "api-version", newJString(apiVersion))
  add(path_564458, "subscriptionId", newJString(subscriptionId))
  result = call_564457.call(path_564458, query_564459, nil, nil, nil)

var connectorList* = Call_ConnectorList_564451(name: "connectorList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/connectors",
    validator: validate_ConnectorList_564452, base: "", url: url_ConnectorList_564453,
    schemes: {Scheme.Https})
type
  Call_SubscriptionDimensionsList_564460 = ref object of OpenApiRestCall_563566
proc url_SubscriptionDimensionsList_564462(protocol: Scheme; host: string;
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

proc validate_SubscriptionDimensionsList_564461(path: JsonNode; query: JsonNode;
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
  var valid_564463 = path.getOrDefault("subscriptionId")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "subscriptionId", valid_564463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var valid_564464 = query.getOrDefault("api-version")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "api-version", valid_564464
  var valid_564465 = query.getOrDefault("$top")
  valid_564465 = validateParameter(valid_564465, JInt, required = false, default = nil)
  if valid_564465 != nil:
    section.add "$top", valid_564465
  var valid_564466 = query.getOrDefault("$expand")
  valid_564466 = validateParameter(valid_564466, JString, required = false,
                                 default = nil)
  if valid_564466 != nil:
    section.add "$expand", valid_564466
  var valid_564467 = query.getOrDefault("$skiptoken")
  valid_564467 = validateParameter(valid_564467, JString, required = false,
                                 default = nil)
  if valid_564467 != nil:
    section.add "$skiptoken", valid_564467
  var valid_564468 = query.getOrDefault("$filter")
  valid_564468 = validateParameter(valid_564468, JString, required = false,
                                 default = nil)
  if valid_564468 != nil:
    section.add "$filter", valid_564468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564469: Call_SubscriptionDimensionsList_564460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564469.validator(path, query, header, formData, body)
  let scheme = call_564469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564469.url(scheme.get, call_564469.host, call_564469.base,
                         call_564469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564469, url, valid)

proc call*(call_564470: Call_SubscriptionDimensionsList_564460; apiVersion: string;
          subscriptionId: string; Top: int = 0; Expand: string = "";
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## subscriptionDimensionsList
  ## Lists the dimensions by subscription Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var path_564471 = newJObject()
  var query_564472 = newJObject()
  add(query_564472, "api-version", newJString(apiVersion))
  add(query_564472, "$top", newJInt(Top))
  add(query_564472, "$expand", newJString(Expand))
  add(path_564471, "subscriptionId", newJString(subscriptionId))
  add(query_564472, "$skiptoken", newJString(Skiptoken))
  add(query_564472, "$filter", newJString(Filter))
  result = call_564470.call(path_564471, query_564472, nil, nil, nil)

var subscriptionDimensionsList* = Call_SubscriptionDimensionsList_564460(
    name: "subscriptionDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_SubscriptionDimensionsList_564461, base: "",
    url: url_SubscriptionDimensionsList_564462, schemes: {Scheme.Https})
type
  Call_ReportsList_564473 = ref object of OpenApiRestCall_563566
proc url_ReportsList_564475(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsList_564474(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564476 = path.getOrDefault("subscriptionId")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "subscriptionId", valid_564476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564477 = query.getOrDefault("api-version")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "api-version", valid_564477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564478: Call_ReportsList_564473; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564478.validator(path, query, header, formData, body)
  let scheme = call_564478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564478.url(scheme.get, call_564478.host, call_564478.base,
                         call_564478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564478, url, valid)

proc call*(call_564479: Call_ReportsList_564473; apiVersion: string;
          subscriptionId: string): Recallable =
  ## reportsList
  ## Lists all reports for a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_564480 = newJObject()
  var query_564481 = newJObject()
  add(query_564481, "api-version", newJString(apiVersion))
  add(path_564480, "subscriptionId", newJString(subscriptionId))
  result = call_564479.call(path_564480, query_564481, nil, nil, nil)

var reportsList* = Call_ReportsList_564473(name: "reportsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports",
                                        validator: validate_ReportsList_564474,
                                        base: "", url: url_ReportsList_564475,
                                        schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdate_564492 = ref object of OpenApiRestCall_563566
proc url_ReportsCreateOrUpdate_564494(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsCreateOrUpdate_564493(path: JsonNode; query: JsonNode;
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
  var valid_564495 = path.getOrDefault("subscriptionId")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "subscriptionId", valid_564495
  var valid_564496 = path.getOrDefault("reportName")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "reportName", valid_564496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564497 = query.getOrDefault("api-version")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "api-version", valid_564497
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

proc call*(call_564499: Call_ReportsCreateOrUpdate_564492; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a report. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564499.validator(path, query, header, formData, body)
  let scheme = call_564499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564499.url(scheme.get, call_564499.host, call_564499.base,
                         call_564499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564499, url, valid)

proc call*(call_564500: Call_ReportsCreateOrUpdate_564492; apiVersion: string;
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
  var path_564501 = newJObject()
  var query_564502 = newJObject()
  var body_564503 = newJObject()
  add(query_564502, "api-version", newJString(apiVersion))
  add(path_564501, "subscriptionId", newJString(subscriptionId))
  add(path_564501, "reportName", newJString(reportName))
  if parameters != nil:
    body_564503 = parameters
  result = call_564500.call(path_564501, query_564502, nil, nil, body_564503)

var reportsCreateOrUpdate* = Call_ReportsCreateOrUpdate_564492(
    name: "reportsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdate_564493, base: "",
    url: url_ReportsCreateOrUpdate_564494, schemes: {Scheme.Https})
type
  Call_ReportsGet_564482 = ref object of OpenApiRestCall_563566
proc url_ReportsGet_564484(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ReportsGet_564483(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564485 = path.getOrDefault("subscriptionId")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "subscriptionId", valid_564485
  var valid_564486 = path.getOrDefault("reportName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "reportName", valid_564486
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564487 = query.getOrDefault("api-version")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "api-version", valid_564487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564488: Call_ReportsGet_564482; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564488.validator(path, query, header, formData, body)
  let scheme = call_564488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564488.url(scheme.get, call_564488.host, call_564488.base,
                         call_564488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564488, url, valid)

proc call*(call_564489: Call_ReportsGet_564482; apiVersion: string;
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
  var path_564490 = newJObject()
  var query_564491 = newJObject()
  add(query_564491, "api-version", newJString(apiVersion))
  add(path_564490, "subscriptionId", newJString(subscriptionId))
  add(path_564490, "reportName", newJString(reportName))
  result = call_564489.call(path_564490, query_564491, nil, nil, nil)

var reportsGet* = Call_ReportsGet_564482(name: "reportsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}",
                                      validator: validate_ReportsGet_564483,
                                      base: "", url: url_ReportsGet_564484,
                                      schemes: {Scheme.Https})
type
  Call_ReportsDelete_564504 = ref object of OpenApiRestCall_563566
proc url_ReportsDelete_564506(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsDelete_564505(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564507 = path.getOrDefault("subscriptionId")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "subscriptionId", valid_564507
  var valid_564508 = path.getOrDefault("reportName")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "reportName", valid_564508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564509 = query.getOrDefault("api-version")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "api-version", valid_564509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564510: Call_ReportsDelete_564504; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564510.validator(path, query, header, formData, body)
  let scheme = call_564510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564510.url(scheme.get, call_564510.host, call_564510.base,
                         call_564510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564510, url, valid)

proc call*(call_564511: Call_ReportsDelete_564504; apiVersion: string;
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
  var path_564512 = newJObject()
  var query_564513 = newJObject()
  add(query_564513, "api-version", newJString(apiVersion))
  add(path_564512, "subscriptionId", newJString(subscriptionId))
  add(path_564512, "reportName", newJString(reportName))
  result = call_564511.call(path_564512, query_564513, nil, nil, nil)

var reportsDelete* = Call_ReportsDelete_564504(name: "reportsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDelete_564505, base: "", url: url_ReportsDelete_564506,
    schemes: {Scheme.Https})
type
  Call_ReportsExecute_564514 = ref object of OpenApiRestCall_563566
proc url_ReportsExecute_564516(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsExecute_564515(path: JsonNode; query: JsonNode;
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
  var valid_564517 = path.getOrDefault("subscriptionId")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "subscriptionId", valid_564517
  var valid_564518 = path.getOrDefault("reportName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "reportName", valid_564518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564519 = query.getOrDefault("api-version")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "api-version", valid_564519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564520: Call_ReportsExecute_564514; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to execute a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564520.validator(path, query, header, formData, body)
  let scheme = call_564520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564520.url(scheme.get, call_564520.host, call_564520.base,
                         call_564520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564520, url, valid)

proc call*(call_564521: Call_ReportsExecute_564514; apiVersion: string;
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
  var path_564522 = newJObject()
  var query_564523 = newJObject()
  add(query_564523, "api-version", newJString(apiVersion))
  add(path_564522, "subscriptionId", newJString(subscriptionId))
  add(path_564522, "reportName", newJString(reportName))
  result = call_564521.call(path_564522, query_564523, nil, nil, nil)

var reportsExecute* = Call_ReportsExecute_564514(name: "reportsExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecute_564515, base: "", url: url_ReportsExecute_564516,
    schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistory_564524 = ref object of OpenApiRestCall_563566
proc url_ReportsGetExecutionHistory_564526(protocol: Scheme; host: string;
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

proc validate_ReportsGetExecutionHistory_564525(path: JsonNode; query: JsonNode;
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
  var valid_564527 = path.getOrDefault("subscriptionId")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "subscriptionId", valid_564527
  var valid_564528 = path.getOrDefault("reportName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "reportName", valid_564528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564529 = query.getOrDefault("api-version")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "api-version", valid_564529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564530: Call_ReportsGetExecutionHistory_564524; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the execution history of a report for a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564530.validator(path, query, header, formData, body)
  let scheme = call_564530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564530.url(scheme.get, call_564530.host, call_564530.base,
                         call_564530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564530, url, valid)

proc call*(call_564531: Call_ReportsGetExecutionHistory_564524; apiVersion: string;
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
  var path_564532 = newJObject()
  var query_564533 = newJObject()
  add(query_564533, "api-version", newJString(apiVersion))
  add(path_564532, "subscriptionId", newJString(subscriptionId))
  add(path_564532, "reportName", newJString(reportName))
  result = call_564531.call(path_564532, query_564533, nil, nil, nil)

var reportsGetExecutionHistory* = Call_ReportsGetExecutionHistory_564524(
    name: "reportsGetExecutionHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistory_564525, base: "",
    url: url_ReportsGetExecutionHistory_564526, schemes: {Scheme.Https})
type
  Call_AlertsListByResourceGroupName_564534 = ref object of OpenApiRestCall_563566
proc url_AlertsListByResourceGroupName_564536(protocol: Scheme; host: string;
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

proc validate_AlertsListByResourceGroupName_564535(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all alerts for a resource group under a subscription.
  ## 
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
  var valid_564537 = path.getOrDefault("subscriptionId")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "subscriptionId", valid_564537
  var valid_564538 = path.getOrDefault("resourceGroupName")
  valid_564538 = validateParameter(valid_564538, JString, required = true,
                                 default = nil)
  if valid_564538 != nil:
    section.add "resourceGroupName", valid_564538
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
  var valid_564539 = query.getOrDefault("api-version")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "api-version", valid_564539
  var valid_564540 = query.getOrDefault("$top")
  valid_564540 = validateParameter(valid_564540, JInt, required = false, default = nil)
  if valid_564540 != nil:
    section.add "$top", valid_564540
  var valid_564541 = query.getOrDefault("$skiptoken")
  valid_564541 = validateParameter(valid_564541, JString, required = false,
                                 default = nil)
  if valid_564541 != nil:
    section.add "$skiptoken", valid_564541
  var valid_564542 = query.getOrDefault("$filter")
  valid_564542 = validateParameter(valid_564542, JString, required = false,
                                 default = nil)
  if valid_564542 != nil:
    section.add "$filter", valid_564542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564543: Call_AlertsListByResourceGroupName_564534; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for a resource group under a subscription.
  ## 
  let valid = call_564543.validator(path, query, header, formData, body)
  let scheme = call_564543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564543.url(scheme.get, call_564543.host, call_564543.base,
                         call_564543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564543, url, valid)

proc call*(call_564544: Call_AlertsListByResourceGroupName_564534;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## alertsListByResourceGroupName
  ## List all alerts for a resource group under a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N alerts.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   Filter: string
  ##         : May be used to filter alerts by properties/definition/type, properties/definition/category, properties/definition/criteria, properties/costEntityId, properties/creationTime, properties/closeTime, properties/status, properties/source. Supported operators are 'eq','lt', 'gt', 'le', 'ge'.
  var path_564545 = newJObject()
  var query_564546 = newJObject()
  add(query_564546, "api-version", newJString(apiVersion))
  add(query_564546, "$top", newJInt(Top))
  add(path_564545, "subscriptionId", newJString(subscriptionId))
  add(query_564546, "$skiptoken", newJString(Skiptoken))
  add(path_564545, "resourceGroupName", newJString(resourceGroupName))
  add(query_564546, "$filter", newJString(Filter))
  result = call_564544.call(path_564545, query_564546, nil, nil, nil)

var alertsListByResourceGroupName* = Call_AlertsListByResourceGroupName_564534(
    name: "alertsListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByResourceGroupName_564535, base: "",
    url: url_AlertsListByResourceGroupName_564536, schemes: {Scheme.Https})
type
  Call_AlertsGetByResourceGroupName_564547 = ref object of OpenApiRestCall_563566
proc url_AlertsGetByResourceGroupName_564549(protocol: Scheme; host: string;
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

proc validate_AlertsGetByResourceGroupName_564548(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert for a resource group under a subscription by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564550 = path.getOrDefault("alertId")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "alertId", valid_564550
  var valid_564551 = path.getOrDefault("subscriptionId")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "subscriptionId", valid_564551
  var valid_564552 = path.getOrDefault("resourceGroupName")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "resourceGroupName", valid_564552
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564553 = query.getOrDefault("api-version")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "api-version", valid_564553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564554: Call_AlertsGetByResourceGroupName_564547; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for a resource group under a subscription by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564554.validator(path, query, header, formData, body)
  let scheme = call_564554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564554.url(scheme.get, call_564554.host, call_564554.base,
                         call_564554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564554, url, valid)

proc call*(call_564555: Call_AlertsGetByResourceGroupName_564547; alertId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## alertsGetByResourceGroupName
  ## Gets the alert for a resource group under a subscription by alert ID.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564556 = newJObject()
  var query_564557 = newJObject()
  add(path_564556, "alertId", newJString(alertId))
  add(query_564557, "api-version", newJString(apiVersion))
  add(path_564556, "subscriptionId", newJString(subscriptionId))
  add(path_564556, "resourceGroupName", newJString(resourceGroupName))
  result = call_564555.call(path_564556, query_564557, nil, nil, nil)

var alertsGetByResourceGroupName* = Call_AlertsGetByResourceGroupName_564547(
    name: "alertsGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByResourceGroupName_564548, base: "",
    url: url_AlertsGetByResourceGroupName_564549, schemes: {Scheme.Https})
type
  Call_AlertsUpdateResourceGroupNameAlertStatus_564558 = ref object of OpenApiRestCall_563566
proc url_AlertsUpdateResourceGroupNameAlertStatus_564560(protocol: Scheme;
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

proc validate_AlertsUpdateResourceGroupNameAlertStatus_564559(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update alerts status for a resource group under a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert ID.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564561 = path.getOrDefault("alertId")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "alertId", valid_564561
  var valid_564562 = path.getOrDefault("subscriptionId")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "subscriptionId", valid_564562
  var valid_564563 = path.getOrDefault("resourceGroupName")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "resourceGroupName", valid_564563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564564 = query.getOrDefault("api-version")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "api-version", valid_564564
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

proc call*(call_564566: Call_AlertsUpdateResourceGroupNameAlertStatus_564558;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for a resource group under a subscription.
  ## 
  let valid = call_564566.validator(path, query, header, formData, body)
  let scheme = call_564566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564566.url(scheme.get, call_564566.host, call_564566.base,
                         call_564566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564566, url, valid)

proc call*(call_564567: Call_AlertsUpdateResourceGroupNameAlertStatus_564558;
          alertId: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## alertsUpdateResourceGroupNameAlertStatus
  ## Update alerts status for a resource group under a subscription.
  ##   alertId: string (required)
  ##          : Alert ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  var path_564568 = newJObject()
  var query_564569 = newJObject()
  var body_564570 = newJObject()
  add(path_564568, "alertId", newJString(alertId))
  add(query_564569, "api-version", newJString(apiVersion))
  add(path_564568, "subscriptionId", newJString(subscriptionId))
  add(path_564568, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564570 = parameters
  result = call_564567.call(path_564568, query_564569, nil, nil, body_564570)

var alertsUpdateResourceGroupNameAlertStatus* = Call_AlertsUpdateResourceGroupNameAlertStatus_564558(
    name: "alertsUpdateResourceGroupNameAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateResourceGroupNameAlertStatus_564559, base: "",
    url: url_AlertsUpdateResourceGroupNameAlertStatus_564560,
    schemes: {Scheme.Https})
type
  Call_ResourceGroupDimensionsList_564571 = ref object of OpenApiRestCall_563566
proc url_ResourceGroupDimensionsList_564573(protocol: Scheme; host: string;
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

proc validate_ResourceGroupDimensionsList_564572(path: JsonNode; query: JsonNode;
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
  var valid_564574 = path.getOrDefault("subscriptionId")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "subscriptionId", valid_564574
  var valid_564575 = path.getOrDefault("resourceGroupName")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "resourceGroupName", valid_564575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var valid_564576 = query.getOrDefault("api-version")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "api-version", valid_564576
  var valid_564577 = query.getOrDefault("$top")
  valid_564577 = validateParameter(valid_564577, JInt, required = false, default = nil)
  if valid_564577 != nil:
    section.add "$top", valid_564577
  var valid_564578 = query.getOrDefault("$expand")
  valid_564578 = validateParameter(valid_564578, JString, required = false,
                                 default = nil)
  if valid_564578 != nil:
    section.add "$expand", valid_564578
  var valid_564579 = query.getOrDefault("$skiptoken")
  valid_564579 = validateParameter(valid_564579, JString, required = false,
                                 default = nil)
  if valid_564579 != nil:
    section.add "$skiptoken", valid_564579
  var valid_564580 = query.getOrDefault("$filter")
  valid_564580 = validateParameter(valid_564580, JString, required = false,
                                 default = nil)
  if valid_564580 != nil:
    section.add "$filter", valid_564580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564581: Call_ResourceGroupDimensionsList_564571; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by resource group Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564581.validator(path, query, header, formData, body)
  let scheme = call_564581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564581.url(scheme.get, call_564581.host, call_564581.base,
                         call_564581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564581, url, valid)

proc call*(call_564582: Call_ResourceGroupDimensionsList_564571;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Expand: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## resourceGroupDimensionsList
  ## Lists the dimensions by resource group Id.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  var path_564583 = newJObject()
  var query_564584 = newJObject()
  add(query_564584, "api-version", newJString(apiVersion))
  add(query_564584, "$top", newJInt(Top))
  add(query_564584, "$expand", newJString(Expand))
  add(path_564583, "subscriptionId", newJString(subscriptionId))
  add(query_564584, "$skiptoken", newJString(Skiptoken))
  add(path_564583, "resourceGroupName", newJString(resourceGroupName))
  add(query_564584, "$filter", newJString(Filter))
  result = call_564582.call(path_564583, query_564584, nil, nil, nil)

var resourceGroupDimensionsList* = Call_ResourceGroupDimensionsList_564571(
    name: "resourceGroupDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_ResourceGroupDimensionsList_564572, base: "",
    url: url_ResourceGroupDimensionsList_564573, schemes: {Scheme.Https})
type
  Call_ReportsListByResourceGroupName_564585 = ref object of OpenApiRestCall_563566
proc url_ReportsListByResourceGroupName_564587(protocol: Scheme; host: string;
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

proc validate_ReportsListByResourceGroupName_564586(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all reports for a resource group under a subscription.
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
  var valid_564588 = path.getOrDefault("subscriptionId")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "subscriptionId", valid_564588
  var valid_564589 = path.getOrDefault("resourceGroupName")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "resourceGroupName", valid_564589
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564590 = query.getOrDefault("api-version")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "api-version", valid_564590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564591: Call_ReportsListByResourceGroupName_564585; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564591.validator(path, query, header, formData, body)
  let scheme = call_564591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564591.url(scheme.get, call_564591.host, call_564591.base,
                         call_564591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564591, url, valid)

proc call*(call_564592: Call_ReportsListByResourceGroupName_564585;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## reportsListByResourceGroupName
  ## Lists all reports for a resource group under a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564593 = newJObject()
  var query_564594 = newJObject()
  add(query_564594, "api-version", newJString(apiVersion))
  add(path_564593, "subscriptionId", newJString(subscriptionId))
  add(path_564593, "resourceGroupName", newJString(resourceGroupName))
  result = call_564592.call(path_564593, query_564594, nil, nil, nil)

var reportsListByResourceGroupName* = Call_ReportsListByResourceGroupName_564585(
    name: "reportsListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports",
    validator: validate_ReportsListByResourceGroupName_564586, base: "",
    url: url_ReportsListByResourceGroupName_564587, schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdateByResourceGroupName_564606 = ref object of OpenApiRestCall_563566
proc url_ReportsCreateOrUpdateByResourceGroupName_564608(protocol: Scheme;
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

proc validate_ReportsCreateOrUpdateByResourceGroupName_564607(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564609 = path.getOrDefault("subscriptionId")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "subscriptionId", valid_564609
  var valid_564610 = path.getOrDefault("reportName")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "reportName", valid_564610
  var valid_564611 = path.getOrDefault("resourceGroupName")
  valid_564611 = validateParameter(valid_564611, JString, required = true,
                                 default = nil)
  if valid_564611 != nil:
    section.add "resourceGroupName", valid_564611
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564612 = query.getOrDefault("api-version")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "api-version", valid_564612
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

proc call*(call_564614: Call_ReportsCreateOrUpdateByResourceGroupName_564606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a report. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564614.validator(path, query, header, formData, body)
  let scheme = call_564614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564614.url(scheme.get, call_564614.host, call_564614.base,
                         call_564614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564614, url, valid)

proc call*(call_564615: Call_ReportsCreateOrUpdateByResourceGroupName_564606;
          apiVersion: string; subscriptionId: string; reportName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## reportsCreateOrUpdateByResourceGroupName
  ## The operation to create or update a report. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  var path_564616 = newJObject()
  var query_564617 = newJObject()
  var body_564618 = newJObject()
  add(query_564617, "api-version", newJString(apiVersion))
  add(path_564616, "subscriptionId", newJString(subscriptionId))
  add(path_564616, "reportName", newJString(reportName))
  add(path_564616, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564618 = parameters
  result = call_564615.call(path_564616, query_564617, nil, nil, body_564618)

var reportsCreateOrUpdateByResourceGroupName* = Call_ReportsCreateOrUpdateByResourceGroupName_564606(
    name: "reportsCreateOrUpdateByResourceGroupName", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdateByResourceGroupName_564607, base: "",
    url: url_ReportsCreateOrUpdateByResourceGroupName_564608,
    schemes: {Scheme.Https})
type
  Call_ReportsGetByResourceGroupName_564595 = ref object of OpenApiRestCall_563566
proc url_ReportsGetByResourceGroupName_564597(protocol: Scheme; host: string;
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

proc validate_ReportsGetByResourceGroupName_564596(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the report for a resource group under a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564598 = path.getOrDefault("subscriptionId")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "subscriptionId", valid_564598
  var valid_564599 = path.getOrDefault("reportName")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "reportName", valid_564599
  var valid_564600 = path.getOrDefault("resourceGroupName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "resourceGroupName", valid_564600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564601 = query.getOrDefault("api-version")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "api-version", valid_564601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564602: Call_ReportsGetByResourceGroupName_564595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a resource group under a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564602.validator(path, query, header, formData, body)
  let scheme = call_564602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564602.url(scheme.get, call_564602.host, call_564602.base,
                         call_564602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564602, url, valid)

proc call*(call_564603: Call_ReportsGetByResourceGroupName_564595;
          apiVersion: string; subscriptionId: string; reportName: string;
          resourceGroupName: string): Recallable =
  ## reportsGetByResourceGroupName
  ## Gets the report for a resource group under a subscription by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564604 = newJObject()
  var query_564605 = newJObject()
  add(query_564605, "api-version", newJString(apiVersion))
  add(path_564604, "subscriptionId", newJString(subscriptionId))
  add(path_564604, "reportName", newJString(reportName))
  add(path_564604, "resourceGroupName", newJString(resourceGroupName))
  result = call_564603.call(path_564604, query_564605, nil, nil, nil)

var reportsGetByResourceGroupName* = Call_ReportsGetByResourceGroupName_564595(
    name: "reportsGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsGetByResourceGroupName_564596, base: "",
    url: url_ReportsGetByResourceGroupName_564597, schemes: {Scheme.Https})
type
  Call_ReportsDeleteByResourceGroupName_564619 = ref object of OpenApiRestCall_563566
proc url_ReportsDeleteByResourceGroupName_564621(protocol: Scheme; host: string;
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

proc validate_ReportsDeleteByResourceGroupName_564620(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564622 = path.getOrDefault("subscriptionId")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "subscriptionId", valid_564622
  var valid_564623 = path.getOrDefault("reportName")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "reportName", valid_564623
  var valid_564624 = path.getOrDefault("resourceGroupName")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "resourceGroupName", valid_564624
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564625 = query.getOrDefault("api-version")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "api-version", valid_564625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564626: Call_ReportsDeleteByResourceGroupName_564619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564626.validator(path, query, header, formData, body)
  let scheme = call_564626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564626.url(scheme.get, call_564626.host, call_564626.base,
                         call_564626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564626, url, valid)

proc call*(call_564627: Call_ReportsDeleteByResourceGroupName_564619;
          apiVersion: string; subscriptionId: string; reportName: string;
          resourceGroupName: string): Recallable =
  ## reportsDeleteByResourceGroupName
  ## The operation to delete a report.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564628 = newJObject()
  var query_564629 = newJObject()
  add(query_564629, "api-version", newJString(apiVersion))
  add(path_564628, "subscriptionId", newJString(subscriptionId))
  add(path_564628, "reportName", newJString(reportName))
  add(path_564628, "resourceGroupName", newJString(resourceGroupName))
  result = call_564627.call(path_564628, query_564629, nil, nil, nil)

var reportsDeleteByResourceGroupName* = Call_ReportsDeleteByResourceGroupName_564619(
    name: "reportsDeleteByResourceGroupName", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDeleteByResourceGroupName_564620, base: "",
    url: url_ReportsDeleteByResourceGroupName_564621, schemes: {Scheme.Https})
type
  Call_ReportsExecuteByResourceGroupName_564630 = ref object of OpenApiRestCall_563566
proc url_ReportsExecuteByResourceGroupName_564632(protocol: Scheme; host: string;
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

proc validate_ReportsExecuteByResourceGroupName_564631(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564633 = path.getOrDefault("subscriptionId")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "subscriptionId", valid_564633
  var valid_564634 = path.getOrDefault("reportName")
  valid_564634 = validateParameter(valid_564634, JString, required = true,
                                 default = nil)
  if valid_564634 != nil:
    section.add "reportName", valid_564634
  var valid_564635 = path.getOrDefault("resourceGroupName")
  valid_564635 = validateParameter(valid_564635, JString, required = true,
                                 default = nil)
  if valid_564635 != nil:
    section.add "resourceGroupName", valid_564635
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564636 = query.getOrDefault("api-version")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "api-version", valid_564636
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564637: Call_ReportsExecuteByResourceGroupName_564630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to execute a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564637.validator(path, query, header, formData, body)
  let scheme = call_564637.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564637.url(scheme.get, call_564637.host, call_564637.base,
                         call_564637.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564637, url, valid)

proc call*(call_564638: Call_ReportsExecuteByResourceGroupName_564630;
          apiVersion: string; subscriptionId: string; reportName: string;
          resourceGroupName: string): Recallable =
  ## reportsExecuteByResourceGroupName
  ## The operation to execute a report.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564639 = newJObject()
  var query_564640 = newJObject()
  add(query_564640, "api-version", newJString(apiVersion))
  add(path_564639, "subscriptionId", newJString(subscriptionId))
  add(path_564639, "reportName", newJString(reportName))
  add(path_564639, "resourceGroupName", newJString(resourceGroupName))
  result = call_564638.call(path_564639, query_564640, nil, nil, nil)

var reportsExecuteByResourceGroupName* = Call_ReportsExecuteByResourceGroupName_564630(
    name: "reportsExecuteByResourceGroupName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecuteByResourceGroupName_564631, base: "",
    url: url_ReportsExecuteByResourceGroupName_564632, schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistoryByResourceGroupName_564641 = ref object of OpenApiRestCall_563566
proc url_ReportsGetExecutionHistoryByResourceGroupName_564643(protocol: Scheme;
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

proc validate_ReportsGetExecutionHistoryByResourceGroupName_564642(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the execution history of a report for a resource group by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   reportName: JString (required)
  ##             : Report Name.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564644 = path.getOrDefault("subscriptionId")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "subscriptionId", valid_564644
  var valid_564645 = path.getOrDefault("reportName")
  valid_564645 = validateParameter(valid_564645, JString, required = true,
                                 default = nil)
  if valid_564645 != nil:
    section.add "reportName", valid_564645
  var valid_564646 = path.getOrDefault("resourceGroupName")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = nil)
  if valid_564646 != nil:
    section.add "resourceGroupName", valid_564646
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564647 = query.getOrDefault("api-version")
  valid_564647 = validateParameter(valid_564647, JString, required = true,
                                 default = nil)
  if valid_564647 != nil:
    section.add "api-version", valid_564647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564648: Call_ReportsGetExecutionHistoryByResourceGroupName_564641;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the execution history of a report for a resource group by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564648.validator(path, query, header, formData, body)
  let scheme = call_564648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564648.url(scheme.get, call_564648.host, call_564648.base,
                         call_564648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564648, url, valid)

proc call*(call_564649: Call_ReportsGetExecutionHistoryByResourceGroupName_564641;
          apiVersion: string; subscriptionId: string; reportName: string;
          resourceGroupName: string): Recallable =
  ## reportsGetExecutionHistoryByResourceGroupName
  ## Gets the execution history of a report for a resource group by report name.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   reportName: string (required)
  ##             : Report Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564650 = newJObject()
  var query_564651 = newJObject()
  add(query_564651, "api-version", newJString(apiVersion))
  add(path_564650, "subscriptionId", newJString(subscriptionId))
  add(path_564650, "reportName", newJString(reportName))
  add(path_564650, "resourceGroupName", newJString(resourceGroupName))
  result = call_564649.call(path_564650, query_564651, nil, nil, nil)

var reportsGetExecutionHistoryByResourceGroupName* = Call_ReportsGetExecutionHistoryByResourceGroupName_564641(
    name: "reportsGetExecutionHistoryByResourceGroupName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistoryByResourceGroupName_564642,
    base: "", url: url_ReportsGetExecutionHistoryByResourceGroupName_564643,
    schemes: {Scheme.Https})
type
  Call_QueryResourceGroup_564652 = ref object of OpenApiRestCall_563566
proc url_QueryResourceGroup_564654(protocol: Scheme; host: string; base: string;
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

proc validate_QueryResourceGroup_564653(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the usage data for subscriptionId and resource group.
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
  var valid_564655 = path.getOrDefault("subscriptionId")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "subscriptionId", valid_564655
  var valid_564656 = path.getOrDefault("resourceGroupName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "resourceGroupName", valid_564656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564657 = query.getOrDefault("api-version")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "api-version", valid_564657
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

proc call*(call_564659: Call_QueryResourceGroup_564652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564659.validator(path, query, header, formData, body)
  let scheme = call_564659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564659.url(scheme.get, call_564659.host, call_564659.base,
                         call_564659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564659, url, valid)

proc call*(call_564660: Call_QueryResourceGroup_564652; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## queryResourceGroup
  ## Lists the usage data for subscriptionId and resource group.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Report operation.
  var path_564661 = newJObject()
  var query_564662 = newJObject()
  var body_564663 = newJObject()
  add(query_564662, "api-version", newJString(apiVersion))
  add(path_564661, "subscriptionId", newJString(subscriptionId))
  add(path_564661, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564663 = parameters
  result = call_564660.call(path_564661, query_564662, nil, nil, body_564663)

var queryResourceGroup* = Call_QueryResourceGroup_564652(
    name: "queryResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryResourceGroup_564653, base: "",
    url: url_QueryResourceGroup_564654, schemes: {Scheme.Https})
type
  Call_ConnectorListByResourceGroupName_564664 = ref object of OpenApiRestCall_563566
proc url_ConnectorListByResourceGroupName_564666(protocol: Scheme; host: string;
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

proc validate_ConnectorListByResourceGroupName_564665(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all connector definitions for a resource group under a subscription.
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
  var valid_564667 = path.getOrDefault("subscriptionId")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "subscriptionId", valid_564667
  var valid_564668 = path.getOrDefault("resourceGroupName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "resourceGroupName", valid_564668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564669 = query.getOrDefault("api-version")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "api-version", valid_564669
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564670: Call_ConnectorListByResourceGroupName_564664;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all connector definitions for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564670.validator(path, query, header, formData, body)
  let scheme = call_564670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564670.url(scheme.get, call_564670.host, call_564670.base,
                         call_564670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564670, url, valid)

proc call*(call_564671: Call_ConnectorListByResourceGroupName_564664;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## connectorListByResourceGroupName
  ## List all connector definitions for a resource group under a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564672 = newJObject()
  var query_564673 = newJObject()
  add(query_564673, "api-version", newJString(apiVersion))
  add(path_564672, "subscriptionId", newJString(subscriptionId))
  add(path_564672, "resourceGroupName", newJString(resourceGroupName))
  result = call_564671.call(path_564672, query_564673, nil, nil, nil)

var connectorListByResourceGroupName* = Call_ConnectorListByResourceGroupName_564664(
    name: "connectorListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors",
    validator: validate_ConnectorListByResourceGroupName_564665, base: "",
    url: url_ConnectorListByResourceGroupName_564666, schemes: {Scheme.Https})
type
  Call_ConnectorCreateOrUpdate_564685 = ref object of OpenApiRestCall_563566
proc url_ConnectorCreateOrUpdate_564687(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorCreateOrUpdate_564686(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: JString (required)
  ##                : Connector Name.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564688 = path.getOrDefault("subscriptionId")
  valid_564688 = validateParameter(valid_564688, JString, required = true,
                                 default = nil)
  if valid_564688 != nil:
    section.add "subscriptionId", valid_564688
  var valid_564689 = path.getOrDefault("connectorName")
  valid_564689 = validateParameter(valid_564689, JString, required = true,
                                 default = nil)
  if valid_564689 != nil:
    section.add "connectorName", valid_564689
  var valid_564690 = path.getOrDefault("resourceGroupName")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = nil)
  if valid_564690 != nil:
    section.add "resourceGroupName", valid_564690
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564691 = query.getOrDefault("api-version")
  valid_564691 = validateParameter(valid_564691, JString, required = true,
                                 default = nil)
  if valid_564691 != nil:
    section.add "api-version", valid_564691
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

proc call*(call_564693: Call_ConnectorCreateOrUpdate_564685; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564693.validator(path, query, header, formData, body)
  let scheme = call_564693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564693.url(scheme.get, call_564693.host, call_564693.base,
                         call_564693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564693, url, valid)

proc call*(call_564694: Call_ConnectorCreateOrUpdate_564685; apiVersion: string;
          connector: JsonNode; subscriptionId: string; connectorName: string;
          resourceGroupName: string): Recallable =
  ## connectorCreateOrUpdate
  ## Create or update a connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   connector: JObject (required)
  ##            : Connector details
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: string (required)
  ##                : Connector Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564695 = newJObject()
  var query_564696 = newJObject()
  var body_564697 = newJObject()
  add(query_564696, "api-version", newJString(apiVersion))
  if connector != nil:
    body_564697 = connector
  add(path_564695, "subscriptionId", newJString(subscriptionId))
  add(path_564695, "connectorName", newJString(connectorName))
  add(path_564695, "resourceGroupName", newJString(resourceGroupName))
  result = call_564694.call(path_564695, query_564696, nil, nil, body_564697)

var connectorCreateOrUpdate* = Call_ConnectorCreateOrUpdate_564685(
    name: "connectorCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorCreateOrUpdate_564686, base: "",
    url: url_ConnectorCreateOrUpdate_564687, schemes: {Scheme.Https})
type
  Call_ConnectorGet_564674 = ref object of OpenApiRestCall_563566
proc url_ConnectorGet_564676(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorGet_564675(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: JString (required)
  ##                : Connector Name.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564677 = path.getOrDefault("subscriptionId")
  valid_564677 = validateParameter(valid_564677, JString, required = true,
                                 default = nil)
  if valid_564677 != nil:
    section.add "subscriptionId", valid_564677
  var valid_564678 = path.getOrDefault("connectorName")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "connectorName", valid_564678
  var valid_564679 = path.getOrDefault("resourceGroupName")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "resourceGroupName", valid_564679
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564680 = query.getOrDefault("api-version")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "api-version", valid_564680
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564681: Call_ConnectorGet_564674; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564681.validator(path, query, header, formData, body)
  let scheme = call_564681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564681.url(scheme.get, call_564681.host, call_564681.base,
                         call_564681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564681, url, valid)

proc call*(call_564682: Call_ConnectorGet_564674; apiVersion: string;
          subscriptionId: string; connectorName: string; resourceGroupName: string): Recallable =
  ## connectorGet
  ## Get a connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: string (required)
  ##                : Connector Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564683 = newJObject()
  var query_564684 = newJObject()
  add(query_564684, "api-version", newJString(apiVersion))
  add(path_564683, "subscriptionId", newJString(subscriptionId))
  add(path_564683, "connectorName", newJString(connectorName))
  add(path_564683, "resourceGroupName", newJString(resourceGroupName))
  result = call_564682.call(path_564683, query_564684, nil, nil, nil)

var connectorGet* = Call_ConnectorGet_564674(name: "connectorGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorGet_564675, base: "", url: url_ConnectorGet_564676,
    schemes: {Scheme.Https})
type
  Call_ConnectorUpdate_564709 = ref object of OpenApiRestCall_563566
proc url_ConnectorUpdate_564711(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorUpdate_564710(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Update a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: JString (required)
  ##                : Connector Name.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564712 = path.getOrDefault("subscriptionId")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "subscriptionId", valid_564712
  var valid_564713 = path.getOrDefault("connectorName")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "connectorName", valid_564713
  var valid_564714 = path.getOrDefault("resourceGroupName")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "resourceGroupName", valid_564714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564715 = query.getOrDefault("api-version")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "api-version", valid_564715
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

proc call*(call_564717: Call_ConnectorUpdate_564709; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564717.validator(path, query, header, formData, body)
  let scheme = call_564717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564717.url(scheme.get, call_564717.host, call_564717.base,
                         call_564717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564717, url, valid)

proc call*(call_564718: Call_ConnectorUpdate_564709; apiVersion: string;
          connector: JsonNode; subscriptionId: string; connectorName: string;
          resourceGroupName: string): Recallable =
  ## connectorUpdate
  ## Update a connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   connector: JObject (required)
  ##            : Connector details
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: string (required)
  ##                : Connector Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564719 = newJObject()
  var query_564720 = newJObject()
  var body_564721 = newJObject()
  add(query_564720, "api-version", newJString(apiVersion))
  if connector != nil:
    body_564721 = connector
  add(path_564719, "subscriptionId", newJString(subscriptionId))
  add(path_564719, "connectorName", newJString(connectorName))
  add(path_564719, "resourceGroupName", newJString(resourceGroupName))
  result = call_564718.call(path_564719, query_564720, nil, nil, body_564721)

var connectorUpdate* = Call_ConnectorUpdate_564709(name: "connectorUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorUpdate_564710, base: "", url: url_ConnectorUpdate_564711,
    schemes: {Scheme.Https})
type
  Call_ConnectorDelete_564698 = ref object of OpenApiRestCall_563566
proc url_ConnectorDelete_564700(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorDelete_564699(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: JString (required)
  ##                : Connector Name.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564701 = path.getOrDefault("subscriptionId")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = nil)
  if valid_564701 != nil:
    section.add "subscriptionId", valid_564701
  var valid_564702 = path.getOrDefault("connectorName")
  valid_564702 = validateParameter(valid_564702, JString, required = true,
                                 default = nil)
  if valid_564702 != nil:
    section.add "connectorName", valid_564702
  var valid_564703 = path.getOrDefault("resourceGroupName")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "resourceGroupName", valid_564703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564704 = query.getOrDefault("api-version")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "api-version", valid_564704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564705: Call_ConnectorDelete_564698; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_564705.validator(path, query, header, formData, body)
  let scheme = call_564705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564705.url(scheme.get, call_564705.host, call_564705.base,
                         call_564705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564705, url, valid)

proc call*(call_564706: Call_ConnectorDelete_564698; apiVersion: string;
          subscriptionId: string; connectorName: string; resourceGroupName: string): Recallable =
  ## connectorDelete
  ## Delete a connector definition
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   connectorName: string (required)
  ##                : Connector Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564707 = newJObject()
  var query_564708 = newJObject()
  add(query_564708, "api-version", newJString(apiVersion))
  add(path_564707, "subscriptionId", newJString(subscriptionId))
  add(path_564707, "connectorName", newJString(connectorName))
  add(path_564707, "resourceGroupName", newJString(resourceGroupName))
  result = call_564706.call(path_564707, query_564708, nil, nil, nil)

var connectorDelete* = Call_ConnectorDelete_564698(name: "connectorDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorDelete_564699, base: "", url: url_ConnectorDelete_564700,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
