
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  Call_AlertsListByDepartment_593661 = ref object of OpenApiRestCall_593439
proc url_AlertsListByDepartment_593663(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsListByDepartment_593662(path: JsonNode; query: JsonNode;
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
  var valid_593837 = path.getOrDefault("billingAccountId")
  valid_593837 = validateParameter(valid_593837, JString, required = true,
                                 default = nil)
  if valid_593837 != nil:
    section.add "billingAccountId", valid_593837
  var valid_593838 = path.getOrDefault("departmentId")
  valid_593838 = validateParameter(valid_593838, JString, required = true,
                                 default = nil)
  if valid_593838 != nil:
    section.add "departmentId", valid_593838
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
  var valid_593839 = query.getOrDefault("api-version")
  valid_593839 = validateParameter(valid_593839, JString, required = true,
                                 default = nil)
  if valid_593839 != nil:
    section.add "api-version", valid_593839
  var valid_593840 = query.getOrDefault("$top")
  valid_593840 = validateParameter(valid_593840, JInt, required = false, default = nil)
  if valid_593840 != nil:
    section.add "$top", valid_593840
  var valid_593841 = query.getOrDefault("$skiptoken")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = nil)
  if valid_593841 != nil:
    section.add "$skiptoken", valid_593841
  var valid_593842 = query.getOrDefault("$filter")
  valid_593842 = validateParameter(valid_593842, JString, required = false,
                                 default = nil)
  if valid_593842 != nil:
    section.add "$filter", valid_593842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593865: Call_AlertsListByDepartment_593661; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for a department.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_AlertsListByDepartment_593661; apiVersion: string;
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
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  add(query_593939, "api-version", newJString(apiVersion))
  add(query_593939, "$top", newJInt(Top))
  add(query_593939, "$skiptoken", newJString(Skiptoken))
  add(path_593937, "billingAccountId", newJString(billingAccountId))
  add(path_593937, "departmentId", newJString(departmentId))
  add(query_593939, "$filter", newJString(Filter))
  result = call_593936.call(path_593937, query_593939, nil, nil, nil)

var alertsListByDepartment* = Call_AlertsListByDepartment_593661(
    name: "alertsListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByDepartment_593662, base: "",
    url: url_AlertsListByDepartment_593663, schemes: {Scheme.Https})
type
  Call_AlertsGetByDepartment_593978 = ref object of OpenApiRestCall_593439
proc url_AlertsGetByDepartment_593980(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetByDepartment_593979(path: JsonNode; query: JsonNode;
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
  var valid_593981 = path.getOrDefault("alertId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "alertId", valid_593981
  var valid_593982 = path.getOrDefault("billingAccountId")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "billingAccountId", valid_593982
  var valid_593983 = path.getOrDefault("departmentId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "departmentId", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_AlertsGetByDepartment_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for a department by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_AlertsGetByDepartment_593978; apiVersion: string;
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
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "alertId", newJString(alertId))
  add(path_593987, "billingAccountId", newJString(billingAccountId))
  add(path_593987, "departmentId", newJString(departmentId))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var alertsGetByDepartment* = Call_AlertsGetByDepartment_593978(
    name: "alertsGetByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByDepartment_593979, base: "",
    url: url_AlertsGetByDepartment_593980, schemes: {Scheme.Https})
type
  Call_AlertsUpdateDepartmentsAlertStatus_593989 = ref object of OpenApiRestCall_593439
proc url_AlertsUpdateDepartmentsAlertStatus_593991(protocol: Scheme; host: string;
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

proc validate_AlertsUpdateDepartmentsAlertStatus_593990(path: JsonNode;
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
  var valid_593992 = path.getOrDefault("alertId")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "alertId", valid_593992
  var valid_593993 = path.getOrDefault("billingAccountId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "billingAccountId", valid_593993
  var valid_593994 = path.getOrDefault("departmentId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "departmentId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
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

proc call*(call_593997: Call_AlertsUpdateDepartmentsAlertStatus_593989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for a department.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_AlertsUpdateDepartmentsAlertStatus_593989;
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
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  var body_594001 = newJObject()
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "alertId", newJString(alertId))
  add(path_593999, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_594001 = parameters
  add(path_593999, "departmentId", newJString(departmentId))
  result = call_593998.call(path_593999, query_594000, nil, nil, body_594001)

var alertsUpdateDepartmentsAlertStatus* = Call_AlertsUpdateDepartmentsAlertStatus_593989(
    name: "alertsUpdateDepartmentsAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateDepartmentsAlertStatus_593990, base: "",
    url: url_AlertsUpdateDepartmentsAlertStatus_593991, schemes: {Scheme.Https})
type
  Call_AlertsListByAccount_594002 = ref object of OpenApiRestCall_593439
proc url_AlertsListByAccount_594004(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsListByAccount_594003(path: JsonNode; query: JsonNode;
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
  var valid_594005 = path.getOrDefault("enrollmentAccountId")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "enrollmentAccountId", valid_594005
  var valid_594006 = path.getOrDefault("billingAccountId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "billingAccountId", valid_594006
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
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  var valid_594008 = query.getOrDefault("$top")
  valid_594008 = validateParameter(valid_594008, JInt, required = false, default = nil)
  if valid_594008 != nil:
    section.add "$top", valid_594008
  var valid_594009 = query.getOrDefault("$skiptoken")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "$skiptoken", valid_594009
  var valid_594010 = query.getOrDefault("$filter")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "$filter", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_AlertsListByAccount_594002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for an account.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_AlertsListByAccount_594002; apiVersion: string;
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
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(query_594014, "api-version", newJString(apiVersion))
  add(query_594014, "$top", newJInt(Top))
  add(query_594014, "$skiptoken", newJString(Skiptoken))
  add(path_594013, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_594013, "billingAccountId", newJString(billingAccountId))
  add(query_594014, "$filter", newJString(Filter))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var alertsListByAccount* = Call_AlertsListByAccount_594002(
    name: "alertsListByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByAccount_594003, base: "",
    url: url_AlertsListByAccount_594004, schemes: {Scheme.Https})
type
  Call_AlertsGetByAccount_594015 = ref object of OpenApiRestCall_593439
proc url_AlertsGetByAccount_594017(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetByAccount_594016(path: JsonNode; query: JsonNode;
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
  var valid_594018 = path.getOrDefault("enrollmentAccountId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "enrollmentAccountId", valid_594018
  var valid_594019 = path.getOrDefault("alertId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "alertId", valid_594019
  var valid_594020 = path.getOrDefault("billingAccountId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "billingAccountId", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "api-version", valid_594021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_AlertsGetByAccount_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for an account by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_AlertsGetByAccount_594015; apiVersion: string;
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
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  add(query_594025, "api-version", newJString(apiVersion))
  add(path_594024, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_594024, "alertId", newJString(alertId))
  add(path_594024, "billingAccountId", newJString(billingAccountId))
  result = call_594023.call(path_594024, query_594025, nil, nil, nil)

var alertsGetByAccount* = Call_AlertsGetByAccount_594015(
    name: "alertsGetByAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByAccount_594016, base: "",
    url: url_AlertsGetByAccount_594017, schemes: {Scheme.Https})
type
  Call_AlertsUpdateEnrollmentAccountAlertStatus_594026 = ref object of OpenApiRestCall_593439
proc url_AlertsUpdateEnrollmentAccountAlertStatus_594028(protocol: Scheme;
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

proc validate_AlertsUpdateEnrollmentAccountAlertStatus_594027(path: JsonNode;
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
  var valid_594029 = path.getOrDefault("enrollmentAccountId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "enrollmentAccountId", valid_594029
  var valid_594030 = path.getOrDefault("alertId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "alertId", valid_594030
  var valid_594031 = path.getOrDefault("billingAccountId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "billingAccountId", valid_594031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594032 = query.getOrDefault("api-version")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "api-version", valid_594032
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

proc call*(call_594034: Call_AlertsUpdateEnrollmentAccountAlertStatus_594026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for an enrollment account.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_AlertsUpdateEnrollmentAccountAlertStatus_594026;
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
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  var body_594038 = newJObject()
  add(query_594037, "api-version", newJString(apiVersion))
  add(path_594036, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_594036, "alertId", newJString(alertId))
  add(path_594036, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_594038 = parameters
  result = call_594035.call(path_594036, query_594037, nil, nil, body_594038)

var alertsUpdateEnrollmentAccountAlertStatus* = Call_AlertsUpdateEnrollmentAccountAlertStatus_594026(
    name: "alertsUpdateEnrollmentAccountAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateEnrollmentAccountAlertStatus_594027, base: "",
    url: url_AlertsUpdateEnrollmentAccountAlertStatus_594028,
    schemes: {Scheme.Https})
type
  Call_QueryBillingAccount_594039 = ref object of OpenApiRestCall_593439
proc url_QueryBillingAccount_594041(protocol: Scheme; host: string; base: string;
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

proc validate_QueryBillingAccount_594040(path: JsonNode; query: JsonNode;
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
  var valid_594059 = path.getOrDefault("billingAccountId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "billingAccountId", valid_594059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594060 = query.getOrDefault("api-version")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "api-version", valid_594060
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

proc call*(call_594062: Call_QueryBillingAccount_594039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_QueryBillingAccount_594039; apiVersion: string;
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
  var path_594064 = newJObject()
  var query_594065 = newJObject()
  var body_594066 = newJObject()
  add(query_594065, "api-version", newJString(apiVersion))
  add(path_594064, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_594066 = parameters
  result = call_594063.call(path_594064, query_594065, nil, nil, body_594066)

var queryBillingAccount* = Call_QueryBillingAccount_594039(
    name: "queryBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryBillingAccount_594040, base: "",
    url: url_QueryBillingAccount_594041, schemes: {Scheme.Https})
type
  Call_AlertsListByEnrollment_594067 = ref object of OpenApiRestCall_593439
proc url_AlertsListByEnrollment_594069(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsListByEnrollment_594068(path: JsonNode; query: JsonNode;
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
  var valid_594070 = path.getOrDefault("billingAccountId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "billingAccountId", valid_594070
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
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "api-version", valid_594071
  var valid_594072 = query.getOrDefault("$top")
  valid_594072 = validateParameter(valid_594072, JInt, required = false, default = nil)
  if valid_594072 != nil:
    section.add "$top", valid_594072
  var valid_594073 = query.getOrDefault("$skiptoken")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "$skiptoken", valid_594073
  var valid_594074 = query.getOrDefault("$filter")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "$filter", valid_594074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594075: Call_AlertsListByEnrollment_594067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for an enrollment.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_AlertsListByEnrollment_594067; apiVersion: string;
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
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  add(query_594078, "api-version", newJString(apiVersion))
  add(query_594078, "$top", newJInt(Top))
  add(query_594078, "$skiptoken", newJString(Skiptoken))
  add(path_594077, "billingAccountId", newJString(billingAccountId))
  add(query_594078, "$filter", newJString(Filter))
  result = call_594076.call(path_594077, query_594078, nil, nil, nil)

var alertsListByEnrollment* = Call_AlertsListByEnrollment_594067(
    name: "alertsListByEnrollment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByEnrollment_594068, base: "",
    url: url_AlertsListByEnrollment_594069, schemes: {Scheme.Https})
type
  Call_AlertsGetByEnrollment_594079 = ref object of OpenApiRestCall_593439
proc url_AlertsGetByEnrollment_594081(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetByEnrollment_594080(path: JsonNode; query: JsonNode;
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
  var valid_594082 = path.getOrDefault("alertId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "alertId", valid_594082
  var valid_594083 = path.getOrDefault("billingAccountId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "billingAccountId", valid_594083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594085: Call_AlertsGetByEnrollment_594079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for an enrollment by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_AlertsGetByEnrollment_594079; apiVersion: string;
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
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  add(query_594088, "api-version", newJString(apiVersion))
  add(path_594087, "alertId", newJString(alertId))
  add(path_594087, "billingAccountId", newJString(billingAccountId))
  result = call_594086.call(path_594087, query_594088, nil, nil, nil)

var alertsGetByEnrollment* = Call_AlertsGetByEnrollment_594079(
    name: "alertsGetByEnrollment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByEnrollment_594080, base: "",
    url: url_AlertsGetByEnrollment_594081, schemes: {Scheme.Https})
type
  Call_AlertsUpdateBillingAccountAlertStatus_594089 = ref object of OpenApiRestCall_593439
proc url_AlertsUpdateBillingAccountAlertStatus_594091(protocol: Scheme;
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

proc validate_AlertsUpdateBillingAccountAlertStatus_594090(path: JsonNode;
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
  var valid_594092 = path.getOrDefault("alertId")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "alertId", valid_594092
  var valid_594093 = path.getOrDefault("billingAccountId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "billingAccountId", valid_594093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594094 = query.getOrDefault("api-version")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "api-version", valid_594094
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

proc call*(call_594096: Call_AlertsUpdateBillingAccountAlertStatus_594089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for billing account.
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_AlertsUpdateBillingAccountAlertStatus_594089;
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
  var path_594098 = newJObject()
  var query_594099 = newJObject()
  var body_594100 = newJObject()
  add(query_594099, "api-version", newJString(apiVersion))
  add(path_594098, "alertId", newJString(alertId))
  add(path_594098, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_594100 = parameters
  result = call_594097.call(path_594098, query_594099, nil, nil, body_594100)

var alertsUpdateBillingAccountAlertStatus* = Call_AlertsUpdateBillingAccountAlertStatus_594089(
    name: "alertsUpdateBillingAccountAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateBillingAccountAlertStatus_594090, base: "",
    url: url_AlertsUpdateBillingAccountAlertStatus_594091, schemes: {Scheme.Https})
type
  Call_BillingAccountDimensionsList_594101 = ref object of OpenApiRestCall_593439
proc url_BillingAccountDimensionsList_594103(protocol: Scheme; host: string;
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

proc validate_BillingAccountDimensionsList_594102(path: JsonNode; query: JsonNode;
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
  var valid_594104 = path.getOrDefault("billingAccountId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "billingAccountId", valid_594104
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
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "api-version", valid_594105
  var valid_594106 = query.getOrDefault("$expand")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "$expand", valid_594106
  var valid_594107 = query.getOrDefault("$top")
  valid_594107 = validateParameter(valid_594107, JInt, required = false, default = nil)
  if valid_594107 != nil:
    section.add "$top", valid_594107
  var valid_594108 = query.getOrDefault("$skiptoken")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "$skiptoken", valid_594108
  var valid_594109 = query.getOrDefault("$filter")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "$filter", valid_594109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594110: Call_BillingAccountDimensionsList_594101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by billingAccount Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_BillingAccountDimensionsList_594101;
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
  var path_594112 = newJObject()
  var query_594113 = newJObject()
  add(query_594113, "api-version", newJString(apiVersion))
  add(query_594113, "$expand", newJString(Expand))
  add(query_594113, "$top", newJInt(Top))
  add(query_594113, "$skiptoken", newJString(Skiptoken))
  add(path_594112, "billingAccountId", newJString(billingAccountId))
  add(query_594113, "$filter", newJString(Filter))
  result = call_594111.call(path_594112, query_594113, nil, nil, nil)

var billingAccountDimensionsList* = Call_BillingAccountDimensionsList_594101(
    name: "billingAccountDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_BillingAccountDimensionsList_594102, base: "",
    url: url_BillingAccountDimensionsList_594103, schemes: {Scheme.Https})
type
  Call_ReportsListByBillingAccount_594114 = ref object of OpenApiRestCall_593439
proc url_ReportsListByBillingAccount_594116(protocol: Scheme; host: string;
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

proc validate_ReportsListByBillingAccount_594115(path: JsonNode; query: JsonNode;
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
  var valid_594117 = path.getOrDefault("billingAccountId")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "billingAccountId", valid_594117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594118 = query.getOrDefault("api-version")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "api-version", valid_594118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594119: Call_ReportsListByBillingAccount_594114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594119.validator(path, query, header, formData, body)
  let scheme = call_594119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594119.url(scheme.get, call_594119.host, call_594119.base,
                         call_594119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594119, url, valid)

proc call*(call_594120: Call_ReportsListByBillingAccount_594114;
          apiVersion: string; billingAccountId: string): Recallable =
  ## reportsListByBillingAccount
  ## Lists all reports for a billing account.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_594121 = newJObject()
  var query_594122 = newJObject()
  add(query_594122, "api-version", newJString(apiVersion))
  add(path_594121, "billingAccountId", newJString(billingAccountId))
  result = call_594120.call(path_594121, query_594122, nil, nil, nil)

var reportsListByBillingAccount* = Call_ReportsListByBillingAccount_594114(
    name: "reportsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports",
    validator: validate_ReportsListByBillingAccount_594115, base: "",
    url: url_ReportsListByBillingAccount_594116, schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdateByBillingAccount_594133 = ref object of OpenApiRestCall_593439
proc url_ReportsCreateOrUpdateByBillingAccount_594135(protocol: Scheme;
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

proc validate_ReportsCreateOrUpdateByBillingAccount_594134(path: JsonNode;
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
  var valid_594136 = path.getOrDefault("reportName")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "reportName", valid_594136
  var valid_594137 = path.getOrDefault("billingAccountId")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "billingAccountId", valid_594137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594138 = query.getOrDefault("api-version")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "api-version", valid_594138
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

proc call*(call_594140: Call_ReportsCreateOrUpdateByBillingAccount_594133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a report for billingAccount. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_ReportsCreateOrUpdateByBillingAccount_594133;
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
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  var body_594144 = newJObject()
  add(query_594143, "api-version", newJString(apiVersion))
  add(path_594142, "reportName", newJString(reportName))
  add(path_594142, "billingAccountId", newJString(billingAccountId))
  if parameters != nil:
    body_594144 = parameters
  result = call_594141.call(path_594142, query_594143, nil, nil, body_594144)

var reportsCreateOrUpdateByBillingAccount* = Call_ReportsCreateOrUpdateByBillingAccount_594133(
    name: "reportsCreateOrUpdateByBillingAccount", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdateByBillingAccount_594134, base: "",
    url: url_ReportsCreateOrUpdateByBillingAccount_594135, schemes: {Scheme.Https})
type
  Call_ReportsGetByBillingAccount_594123 = ref object of OpenApiRestCall_593439
proc url_ReportsGetByBillingAccount_594125(protocol: Scheme; host: string;
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

proc validate_ReportsGetByBillingAccount_594124(path: JsonNode; query: JsonNode;
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
  var valid_594126 = path.getOrDefault("reportName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "reportName", valid_594126
  var valid_594127 = path.getOrDefault("billingAccountId")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "billingAccountId", valid_594127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594128 = query.getOrDefault("api-version")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "api-version", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_ReportsGetByBillingAccount_594123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a billing account by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_ReportsGetByBillingAccount_594123; apiVersion: string;
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
  var path_594131 = newJObject()
  var query_594132 = newJObject()
  add(query_594132, "api-version", newJString(apiVersion))
  add(path_594131, "reportName", newJString(reportName))
  add(path_594131, "billingAccountId", newJString(billingAccountId))
  result = call_594130.call(path_594131, query_594132, nil, nil, nil)

var reportsGetByBillingAccount* = Call_ReportsGetByBillingAccount_594123(
    name: "reportsGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsGetByBillingAccount_594124, base: "",
    url: url_ReportsGetByBillingAccount_594125, schemes: {Scheme.Https})
type
  Call_ReportsDeleteByBillingAccount_594145 = ref object of OpenApiRestCall_593439
proc url_ReportsDeleteByBillingAccount_594147(protocol: Scheme; host: string;
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

proc validate_ReportsDeleteByBillingAccount_594146(path: JsonNode; query: JsonNode;
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
  var valid_594148 = path.getOrDefault("reportName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "reportName", valid_594148
  var valid_594149 = path.getOrDefault("billingAccountId")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "billingAccountId", valid_594149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594150 = query.getOrDefault("api-version")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "api-version", valid_594150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594151: Call_ReportsDeleteByBillingAccount_594145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a report for billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594151.validator(path, query, header, formData, body)
  let scheme = call_594151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594151.url(scheme.get, call_594151.host, call_594151.base,
                         call_594151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594151, url, valid)

proc call*(call_594152: Call_ReportsDeleteByBillingAccount_594145;
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
  var path_594153 = newJObject()
  var query_594154 = newJObject()
  add(query_594154, "api-version", newJString(apiVersion))
  add(path_594153, "reportName", newJString(reportName))
  add(path_594153, "billingAccountId", newJString(billingAccountId))
  result = call_594152.call(path_594153, query_594154, nil, nil, nil)

var reportsDeleteByBillingAccount* = Call_ReportsDeleteByBillingAccount_594145(
    name: "reportsDeleteByBillingAccount", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDeleteByBillingAccount_594146, base: "",
    url: url_ReportsDeleteByBillingAccount_594147, schemes: {Scheme.Https})
type
  Call_ReportsExecuteByBillingAccount_594155 = ref object of OpenApiRestCall_593439
proc url_ReportsExecuteByBillingAccount_594157(protocol: Scheme; host: string;
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

proc validate_ReportsExecuteByBillingAccount_594156(path: JsonNode;
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
  var valid_594158 = path.getOrDefault("reportName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "reportName", valid_594158
  var valid_594159 = path.getOrDefault("billingAccountId")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "billingAccountId", valid_594159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594160 = query.getOrDefault("api-version")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "api-version", valid_594160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594161: Call_ReportsExecuteByBillingAccount_594155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to execute a report by billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_ReportsExecuteByBillingAccount_594155;
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
  var path_594163 = newJObject()
  var query_594164 = newJObject()
  add(query_594164, "api-version", newJString(apiVersion))
  add(path_594163, "reportName", newJString(reportName))
  add(path_594163, "billingAccountId", newJString(billingAccountId))
  result = call_594162.call(path_594163, query_594164, nil, nil, nil)

var reportsExecuteByBillingAccount* = Call_ReportsExecuteByBillingAccount_594155(
    name: "reportsExecuteByBillingAccount", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecuteByBillingAccount_594156, base: "",
    url: url_ReportsExecuteByBillingAccount_594157, schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistoryByBillingAccount_594165 = ref object of OpenApiRestCall_593439
proc url_ReportsGetExecutionHistoryByBillingAccount_594167(protocol: Scheme;
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

proc validate_ReportsGetExecutionHistoryByBillingAccount_594166(path: JsonNode;
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
  var valid_594168 = path.getOrDefault("reportName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "reportName", valid_594168
  var valid_594169 = path.getOrDefault("billingAccountId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "billingAccountId", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594170 = query.getOrDefault("api-version")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "api-version", valid_594170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594171: Call_ReportsGetExecutionHistoryByBillingAccount_594165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the execution history of a report for a billing account by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_ReportsGetExecutionHistoryByBillingAccount_594165;
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
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  add(query_594174, "api-version", newJString(apiVersion))
  add(path_594173, "reportName", newJString(reportName))
  add(path_594173, "billingAccountId", newJString(billingAccountId))
  result = call_594172.call(path_594173, query_594174, nil, nil, nil)

var reportsGetExecutionHistoryByBillingAccount* = Call_ReportsGetExecutionHistoryByBillingAccount_594165(
    name: "reportsGetExecutionHistoryByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistoryByBillingAccount_594166,
    base: "", url: url_ReportsGetExecutionHistoryByBillingAccount_594167,
    schemes: {Scheme.Https})
type
  Call_ReportsListByDepartment_594175 = ref object of OpenApiRestCall_593439
proc url_ReportsListByDepartment_594177(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByDepartment_594176(path: JsonNode; query: JsonNode;
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
  var valid_594178 = path.getOrDefault("departmentId")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "departmentId", valid_594178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594179 = query.getOrDefault("api-version")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "api-version", valid_594179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594180: Call_ReportsListByDepartment_594175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594180.validator(path, query, header, formData, body)
  let scheme = call_594180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594180.url(scheme.get, call_594180.host, call_594180.base,
                         call_594180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594180, url, valid)

proc call*(call_594181: Call_ReportsListByDepartment_594175; apiVersion: string;
          departmentId: string): Recallable =
  ## reportsListByDepartment
  ## Lists all reports for a department.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   departmentId: string (required)
  ##               : Department ID
  var path_594182 = newJObject()
  var query_594183 = newJObject()
  add(query_594183, "api-version", newJString(apiVersion))
  add(path_594182, "departmentId", newJString(departmentId))
  result = call_594181.call(path_594182, query_594183, nil, nil, nil)

var reportsListByDepartment* = Call_ReportsListByDepartment_594175(
    name: "reportsListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports",
    validator: validate_ReportsListByDepartment_594176, base: "",
    url: url_ReportsListByDepartment_594177, schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdateByDepartment_594194 = ref object of OpenApiRestCall_593439
proc url_ReportsCreateOrUpdateByDepartment_594196(protocol: Scheme; host: string;
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

proc validate_ReportsCreateOrUpdateByDepartment_594195(path: JsonNode;
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
  var valid_594197 = path.getOrDefault("reportName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "reportName", valid_594197
  var valid_594198 = path.getOrDefault("departmentId")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "departmentId", valid_594198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594199 = query.getOrDefault("api-version")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "api-version", valid_594199
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

proc call*(call_594201: Call_ReportsCreateOrUpdateByDepartment_594194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a report for department. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594201.validator(path, query, header, formData, body)
  let scheme = call_594201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594201.url(scheme.get, call_594201.host, call_594201.base,
                         call_594201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594201, url, valid)

proc call*(call_594202: Call_ReportsCreateOrUpdateByDepartment_594194;
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
  var path_594203 = newJObject()
  var query_594204 = newJObject()
  var body_594205 = newJObject()
  add(query_594204, "api-version", newJString(apiVersion))
  add(path_594203, "reportName", newJString(reportName))
  if parameters != nil:
    body_594205 = parameters
  add(path_594203, "departmentId", newJString(departmentId))
  result = call_594202.call(path_594203, query_594204, nil, nil, body_594205)

var reportsCreateOrUpdateByDepartment* = Call_ReportsCreateOrUpdateByDepartment_594194(
    name: "reportsCreateOrUpdateByDepartment", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdateByDepartment_594195, base: "",
    url: url_ReportsCreateOrUpdateByDepartment_594196, schemes: {Scheme.Https})
type
  Call_ReportsGetByDepartment_594184 = ref object of OpenApiRestCall_593439
proc url_ReportsGetByDepartment_594186(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsGetByDepartment_594185(path: JsonNode; query: JsonNode;
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
  var valid_594187 = path.getOrDefault("reportName")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "reportName", valid_594187
  var valid_594188 = path.getOrDefault("departmentId")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "departmentId", valid_594188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594189 = query.getOrDefault("api-version")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "api-version", valid_594189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594190: Call_ReportsGetByDepartment_594184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a department by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594190.validator(path, query, header, formData, body)
  let scheme = call_594190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594190.url(scheme.get, call_594190.host, call_594190.base,
                         call_594190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594190, url, valid)

proc call*(call_594191: Call_ReportsGetByDepartment_594184; apiVersion: string;
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
  var path_594192 = newJObject()
  var query_594193 = newJObject()
  add(query_594193, "api-version", newJString(apiVersion))
  add(path_594192, "reportName", newJString(reportName))
  add(path_594192, "departmentId", newJString(departmentId))
  result = call_594191.call(path_594192, query_594193, nil, nil, nil)

var reportsGetByDepartment* = Call_ReportsGetByDepartment_594184(
    name: "reportsGetByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsGetByDepartment_594185, base: "",
    url: url_ReportsGetByDepartment_594186, schemes: {Scheme.Https})
type
  Call_ReportsDeleteByDepartment_594206 = ref object of OpenApiRestCall_593439
proc url_ReportsDeleteByDepartment_594208(protocol: Scheme; host: string;
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

proc validate_ReportsDeleteByDepartment_594207(path: JsonNode; query: JsonNode;
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
  var valid_594209 = path.getOrDefault("reportName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "reportName", valid_594209
  var valid_594210 = path.getOrDefault("departmentId")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "departmentId", valid_594210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594211 = query.getOrDefault("api-version")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "api-version", valid_594211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594212: Call_ReportsDeleteByDepartment_594206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a report for department.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594212.validator(path, query, header, formData, body)
  let scheme = call_594212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594212.url(scheme.get, call_594212.host, call_594212.base,
                         call_594212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594212, url, valid)

proc call*(call_594213: Call_ReportsDeleteByDepartment_594206; apiVersion: string;
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
  var path_594214 = newJObject()
  var query_594215 = newJObject()
  add(query_594215, "api-version", newJString(apiVersion))
  add(path_594214, "reportName", newJString(reportName))
  add(path_594214, "departmentId", newJString(departmentId))
  result = call_594213.call(path_594214, query_594215, nil, nil, nil)

var reportsDeleteByDepartment* = Call_ReportsDeleteByDepartment_594206(
    name: "reportsDeleteByDepartment", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDeleteByDepartment_594207, base: "",
    url: url_ReportsDeleteByDepartment_594208, schemes: {Scheme.Https})
type
  Call_ReportsExecuteByDepartment_594216 = ref object of OpenApiRestCall_593439
proc url_ReportsExecuteByDepartment_594218(protocol: Scheme; host: string;
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

proc validate_ReportsExecuteByDepartment_594217(path: JsonNode; query: JsonNode;
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
  var valid_594219 = path.getOrDefault("reportName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "reportName", valid_594219
  var valid_594220 = path.getOrDefault("departmentId")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "departmentId", valid_594220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594221 = query.getOrDefault("api-version")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "api-version", valid_594221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594222: Call_ReportsExecuteByDepartment_594216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to execute a report by department.
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

proc call*(call_594223: Call_ReportsExecuteByDepartment_594216; apiVersion: string;
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
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  add(query_594225, "api-version", newJString(apiVersion))
  add(path_594224, "reportName", newJString(reportName))
  add(path_594224, "departmentId", newJString(departmentId))
  result = call_594223.call(path_594224, query_594225, nil, nil, nil)

var reportsExecuteByDepartment* = Call_ReportsExecuteByDepartment_594216(
    name: "reportsExecuteByDepartment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecuteByDepartment_594217, base: "",
    url: url_ReportsExecuteByDepartment_594218, schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistoryByDepartment_594226 = ref object of OpenApiRestCall_593439
proc url_ReportsGetExecutionHistoryByDepartment_594228(protocol: Scheme;
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

proc validate_ReportsGetExecutionHistoryByDepartment_594227(path: JsonNode;
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
  var valid_594229 = path.getOrDefault("reportName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "reportName", valid_594229
  var valid_594230 = path.getOrDefault("departmentId")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "departmentId", valid_594230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594231 = query.getOrDefault("api-version")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "api-version", valid_594231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594232: Call_ReportsGetExecutionHistoryByDepartment_594226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the execution history of a report for a department by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594232.validator(path, query, header, formData, body)
  let scheme = call_594232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594232.url(scheme.get, call_594232.host, call_594232.base,
                         call_594232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594232, url, valid)

proc call*(call_594233: Call_ReportsGetExecutionHistoryByDepartment_594226;
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
  var path_594234 = newJObject()
  var query_594235 = newJObject()
  add(query_594235, "api-version", newJString(apiVersion))
  add(path_594234, "reportName", newJString(reportName))
  add(path_594234, "departmentId", newJString(departmentId))
  result = call_594233.call(path_594234, query_594235, nil, nil, nil)

var reportsGetExecutionHistoryByDepartment* = Call_ReportsGetExecutionHistoryByDepartment_594226(
    name: "reportsGetExecutionHistoryByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistoryByDepartment_594227, base: "",
    url: url_ReportsGetExecutionHistoryByDepartment_594228,
    schemes: {Scheme.Https})
type
  Call_OperationsList_594236 = ref object of OpenApiRestCall_593439
proc url_OperationsList_594238(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_594237(path: JsonNode; query: JsonNode;
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
  var valid_594239 = query.getOrDefault("api-version")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "api-version", valid_594239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594240: Call_OperationsList_594236; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available cost management REST API operations.
  ## 
  let valid = call_594240.validator(path, query, header, formData, body)
  let scheme = call_594240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594240.url(scheme.get, call_594240.host, call_594240.base,
                         call_594240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594240, url, valid)

proc call*(call_594241: Call_OperationsList_594236; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available cost management REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  var query_594242 = newJObject()
  add(query_594242, "api-version", newJString(apiVersion))
  result = call_594241.call(nil, query_594242, nil, nil, nil)

var operationsList* = Call_OperationsList_594236(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CostManagement/operations",
    validator: validate_OperationsList_594237, base: "", url: url_OperationsList_594238,
    schemes: {Scheme.Https})
type
  Call_AlertsListByManagementGroups_594243 = ref object of OpenApiRestCall_593439
proc url_AlertsListByManagementGroups_594245(protocol: Scheme; host: string;
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

proc validate_AlertsListByManagementGroups_594244(path: JsonNode; query: JsonNode;
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
  var valid_594246 = path.getOrDefault("managementGroupId")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "managementGroupId", valid_594246
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
  var valid_594247 = query.getOrDefault("api-version")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "api-version", valid_594247
  var valid_594248 = query.getOrDefault("$top")
  valid_594248 = validateParameter(valid_594248, JInt, required = false, default = nil)
  if valid_594248 != nil:
    section.add "$top", valid_594248
  var valid_594249 = query.getOrDefault("$skiptoken")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "$skiptoken", valid_594249
  var valid_594250 = query.getOrDefault("$filter")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "$filter", valid_594250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594251: Call_AlertsListByManagementGroups_594243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for Management Groups.
  ## 
  let valid = call_594251.validator(path, query, header, formData, body)
  let scheme = call_594251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594251.url(scheme.get, call_594251.host, call_594251.base,
                         call_594251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594251, url, valid)

proc call*(call_594252: Call_AlertsListByManagementGroups_594243;
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
  var path_594253 = newJObject()
  var query_594254 = newJObject()
  add(query_594254, "api-version", newJString(apiVersion))
  add(path_594253, "managementGroupId", newJString(managementGroupId))
  add(query_594254, "$top", newJInt(Top))
  add(query_594254, "$skiptoken", newJString(Skiptoken))
  add(query_594254, "$filter", newJString(Filter))
  result = call_594252.call(path_594253, query_594254, nil, nil, nil)

var alertsListByManagementGroups* = Call_AlertsListByManagementGroups_594243(
    name: "alertsListByManagementGroups", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByManagementGroups_594244, base: "",
    url: url_AlertsListByManagementGroups_594245, schemes: {Scheme.Https})
type
  Call_AlertsGetAlertByManagementGroups_594255 = ref object of OpenApiRestCall_593439
proc url_AlertsGetAlertByManagementGroups_594257(protocol: Scheme; host: string;
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

proc validate_AlertsGetAlertByManagementGroups_594256(path: JsonNode;
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
  var valid_594258 = path.getOrDefault("managementGroupId")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "managementGroupId", valid_594258
  var valid_594259 = path.getOrDefault("alertId")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "alertId", valid_594259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594260 = query.getOrDefault("api-version")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "api-version", valid_594260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594261: Call_AlertsGetAlertByManagementGroups_594255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an alert for Management Groups by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594261.validator(path, query, header, formData, body)
  let scheme = call_594261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594261.url(scheme.get, call_594261.host, call_594261.base,
                         call_594261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594261, url, valid)

proc call*(call_594262: Call_AlertsGetAlertByManagementGroups_594255;
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
  var path_594263 = newJObject()
  var query_594264 = newJObject()
  add(query_594264, "api-version", newJString(apiVersion))
  add(path_594263, "managementGroupId", newJString(managementGroupId))
  add(path_594263, "alertId", newJString(alertId))
  result = call_594262.call(path_594263, query_594264, nil, nil, nil)

var alertsGetAlertByManagementGroups* = Call_AlertsGetAlertByManagementGroups_594255(
    name: "alertsGetAlertByManagementGroups", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetAlertByManagementGroups_594256, base: "",
    url: url_AlertsGetAlertByManagementGroups_594257, schemes: {Scheme.Https})
type
  Call_AlertsUpdateManagementGroupAlertStatus_594265 = ref object of OpenApiRestCall_593439
proc url_AlertsUpdateManagementGroupAlertStatus_594267(protocol: Scheme;
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

proc validate_AlertsUpdateManagementGroupAlertStatus_594266(path: JsonNode;
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
  var valid_594268 = path.getOrDefault("managementGroupId")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "managementGroupId", valid_594268
  var valid_594269 = path.getOrDefault("alertId")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "alertId", valid_594269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update alerts status operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594272: Call_AlertsUpdateManagementGroupAlertStatus_594265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for management group.
  ## 
  let valid = call_594272.validator(path, query, header, formData, body)
  let scheme = call_594272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594272.url(scheme.get, call_594272.host, call_594272.base,
                         call_594272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594272, url, valid)

proc call*(call_594273: Call_AlertsUpdateManagementGroupAlertStatus_594265;
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
  var path_594274 = newJObject()
  var query_594275 = newJObject()
  var body_594276 = newJObject()
  add(query_594275, "api-version", newJString(apiVersion))
  add(path_594274, "managementGroupId", newJString(managementGroupId))
  add(path_594274, "alertId", newJString(alertId))
  if parameters != nil:
    body_594276 = parameters
  result = call_594273.call(path_594274, query_594275, nil, nil, body_594276)

var alertsUpdateManagementGroupAlertStatus* = Call_AlertsUpdateManagementGroupAlertStatus_594265(
    name: "alertsUpdateManagementGroupAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.CostManagement/alerts/{alertId}/UpdateStatus",
    validator: validate_AlertsUpdateManagementGroupAlertStatus_594266, base: "",
    url: url_AlertsUpdateManagementGroupAlertStatus_594267,
    schemes: {Scheme.Https})
type
  Call_QuerySubscription_594277 = ref object of OpenApiRestCall_593439
proc url_QuerySubscription_594279(protocol: Scheme; host: string; base: string;
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

proc validate_QuerySubscription_594278(path: JsonNode; query: JsonNode;
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
  var valid_594280 = path.getOrDefault("subscriptionId")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "subscriptionId", valid_594280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594281 = query.getOrDefault("api-version")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "api-version", valid_594281
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

proc call*(call_594283: Call_QuerySubscription_594277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594283.validator(path, query, header, formData, body)
  let scheme = call_594283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594283.url(scheme.get, call_594283.host, call_594283.base,
                         call_594283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594283, url, valid)

proc call*(call_594284: Call_QuerySubscription_594277; apiVersion: string;
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
  var path_594285 = newJObject()
  var query_594286 = newJObject()
  var body_594287 = newJObject()
  add(query_594286, "api-version", newJString(apiVersion))
  add(path_594285, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594287 = parameters
  result = call_594284.call(path_594285, query_594286, nil, nil, body_594287)

var querySubscription* = Call_QuerySubscription_594277(name: "querySubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/Query",
    validator: validate_QuerySubscription_594278, base: "",
    url: url_QuerySubscription_594279, schemes: {Scheme.Https})
type
  Call_AlertsList_594288 = ref object of OpenApiRestCall_593439
proc url_AlertsList_594290(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AlertsList_594289(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594291 = path.getOrDefault("subscriptionId")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "subscriptionId", valid_594291
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
  var valid_594292 = query.getOrDefault("api-version")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "api-version", valid_594292
  var valid_594293 = query.getOrDefault("$top")
  valid_594293 = validateParameter(valid_594293, JInt, required = false, default = nil)
  if valid_594293 != nil:
    section.add "$top", valid_594293
  var valid_594294 = query.getOrDefault("$skiptoken")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "$skiptoken", valid_594294
  var valid_594295 = query.getOrDefault("$filter")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "$filter", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_AlertsList_594288; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for a subscription.
  ## 
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_AlertsList_594288; apiVersion: string;
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
  var path_594298 = newJObject()
  var query_594299 = newJObject()
  add(query_594299, "api-version", newJString(apiVersion))
  add(path_594298, "subscriptionId", newJString(subscriptionId))
  add(query_594299, "$top", newJInt(Top))
  add(query_594299, "$skiptoken", newJString(Skiptoken))
  add(query_594299, "$filter", newJString(Filter))
  result = call_594297.call(path_594298, query_594299, nil, nil, nil)

var alertsList* = Call_AlertsList_594288(name: "alertsList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/alerts",
                                      validator: validate_AlertsList_594289,
                                      base: "", url: url_AlertsList_594290,
                                      schemes: {Scheme.Https})
type
  Call_AlertsGetBySubscription_594300 = ref object of OpenApiRestCall_593439
proc url_AlertsGetBySubscription_594302(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetBySubscription_594301(path: JsonNode; query: JsonNode;
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
  var valid_594303 = path.getOrDefault("subscriptionId")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "subscriptionId", valid_594303
  var valid_594304 = path.getOrDefault("alertId")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "alertId", valid_594304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594305 = query.getOrDefault("api-version")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "api-version", valid_594305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594306: Call_AlertsGetBySubscription_594300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for a subscription by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594306.validator(path, query, header, formData, body)
  let scheme = call_594306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594306.url(scheme.get, call_594306.host, call_594306.base,
                         call_594306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594306, url, valid)

proc call*(call_594307: Call_AlertsGetBySubscription_594300; apiVersion: string;
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
  var path_594308 = newJObject()
  var query_594309 = newJObject()
  add(query_594309, "api-version", newJString(apiVersion))
  add(path_594308, "subscriptionId", newJString(subscriptionId))
  add(path_594308, "alertId", newJString(alertId))
  result = call_594307.call(path_594308, query_594309, nil, nil, nil)

var alertsGetBySubscription* = Call_AlertsGetBySubscription_594300(
    name: "alertsGetBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetBySubscription_594301, base: "",
    url: url_AlertsGetBySubscription_594302, schemes: {Scheme.Https})
type
  Call_AlertsUpdateSubscriptionAlertStatus_594310 = ref object of OpenApiRestCall_593439
proc url_AlertsUpdateSubscriptionAlertStatus_594312(protocol: Scheme; host: string;
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

proc validate_AlertsUpdateSubscriptionAlertStatus_594311(path: JsonNode;
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
  var valid_594313 = path.getOrDefault("subscriptionId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "subscriptionId", valid_594313
  var valid_594314 = path.getOrDefault("alertId")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "alertId", valid_594314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594315 = query.getOrDefault("api-version")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "api-version", valid_594315
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

proc call*(call_594317: Call_AlertsUpdateSubscriptionAlertStatus_594310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for a subscription.
  ## 
  let valid = call_594317.validator(path, query, header, formData, body)
  let scheme = call_594317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594317.url(scheme.get, call_594317.host, call_594317.base,
                         call_594317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594317, url, valid)

proc call*(call_594318: Call_AlertsUpdateSubscriptionAlertStatus_594310;
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
  var path_594319 = newJObject()
  var query_594320 = newJObject()
  var body_594321 = newJObject()
  add(query_594320, "api-version", newJString(apiVersion))
  add(path_594319, "subscriptionId", newJString(subscriptionId))
  add(path_594319, "alertId", newJString(alertId))
  if parameters != nil:
    body_594321 = parameters
  result = call_594318.call(path_594319, query_594320, nil, nil, body_594321)

var alertsUpdateSubscriptionAlertStatus* = Call_AlertsUpdateSubscriptionAlertStatus_594310(
    name: "alertsUpdateSubscriptionAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateSubscriptionAlertStatus_594311, base: "",
    url: url_AlertsUpdateSubscriptionAlertStatus_594312, schemes: {Scheme.Https})
type
  Call_ConnectorList_594322 = ref object of OpenApiRestCall_593439
proc url_ConnectorList_594324(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorList_594323(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594325 = path.getOrDefault("subscriptionId")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "subscriptionId", valid_594325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594326 = query.getOrDefault("api-version")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "api-version", valid_594326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594327: Call_ConnectorList_594322; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all connector definitions for a subscription
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594327.validator(path, query, header, formData, body)
  let scheme = call_594327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594327.url(scheme.get, call_594327.host, call_594327.base,
                         call_594327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594327, url, valid)

proc call*(call_594328: Call_ConnectorList_594322; apiVersion: string;
          subscriptionId: string): Recallable =
  ## connectorList
  ## List all connector definitions for a subscription
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594329 = newJObject()
  var query_594330 = newJObject()
  add(query_594330, "api-version", newJString(apiVersion))
  add(path_594329, "subscriptionId", newJString(subscriptionId))
  result = call_594328.call(path_594329, query_594330, nil, nil, nil)

var connectorList* = Call_ConnectorList_594322(name: "connectorList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/connectors",
    validator: validate_ConnectorList_594323, base: "", url: url_ConnectorList_594324,
    schemes: {Scheme.Https})
type
  Call_SubscriptionDimensionsList_594331 = ref object of OpenApiRestCall_593439
proc url_SubscriptionDimensionsList_594333(protocol: Scheme; host: string;
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

proc validate_SubscriptionDimensionsList_594332(path: JsonNode; query: JsonNode;
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
  var valid_594334 = path.getOrDefault("subscriptionId")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "subscriptionId", valid_594334
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
  var valid_594335 = query.getOrDefault("api-version")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "api-version", valid_594335
  var valid_594336 = query.getOrDefault("$expand")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "$expand", valid_594336
  var valid_594337 = query.getOrDefault("$top")
  valid_594337 = validateParameter(valid_594337, JInt, required = false, default = nil)
  if valid_594337 != nil:
    section.add "$top", valid_594337
  var valid_594338 = query.getOrDefault("$skiptoken")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "$skiptoken", valid_594338
  var valid_594339 = query.getOrDefault("$filter")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "$filter", valid_594339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594340: Call_SubscriptionDimensionsList_594331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594340.validator(path, query, header, formData, body)
  let scheme = call_594340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594340.url(scheme.get, call_594340.host, call_594340.base,
                         call_594340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594340, url, valid)

proc call*(call_594341: Call_SubscriptionDimensionsList_594331; apiVersion: string;
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
  var path_594342 = newJObject()
  var query_594343 = newJObject()
  add(query_594343, "api-version", newJString(apiVersion))
  add(query_594343, "$expand", newJString(Expand))
  add(path_594342, "subscriptionId", newJString(subscriptionId))
  add(query_594343, "$top", newJInt(Top))
  add(query_594343, "$skiptoken", newJString(Skiptoken))
  add(query_594343, "$filter", newJString(Filter))
  result = call_594341.call(path_594342, query_594343, nil, nil, nil)

var subscriptionDimensionsList* = Call_SubscriptionDimensionsList_594331(
    name: "subscriptionDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_SubscriptionDimensionsList_594332, base: "",
    url: url_SubscriptionDimensionsList_594333, schemes: {Scheme.Https})
type
  Call_ReportsList_594344 = ref object of OpenApiRestCall_593439
proc url_ReportsList_594346(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsList_594345(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594347 = path.getOrDefault("subscriptionId")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "subscriptionId", valid_594347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594348 = query.getOrDefault("api-version")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "api-version", valid_594348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594349: Call_ReportsList_594344; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594349.validator(path, query, header, formData, body)
  let scheme = call_594349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594349.url(scheme.get, call_594349.host, call_594349.base,
                         call_594349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594349, url, valid)

proc call*(call_594350: Call_ReportsList_594344; apiVersion: string;
          subscriptionId: string): Recallable =
  ## reportsList
  ## Lists all reports for a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594351 = newJObject()
  var query_594352 = newJObject()
  add(query_594352, "api-version", newJString(apiVersion))
  add(path_594351, "subscriptionId", newJString(subscriptionId))
  result = call_594350.call(path_594351, query_594352, nil, nil, nil)

var reportsList* = Call_ReportsList_594344(name: "reportsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports",
                                        validator: validate_ReportsList_594345,
                                        base: "", url: url_ReportsList_594346,
                                        schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdate_594363 = ref object of OpenApiRestCall_593439
proc url_ReportsCreateOrUpdate_594365(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsCreateOrUpdate_594364(path: JsonNode; query: JsonNode;
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
  var valid_594366 = path.getOrDefault("subscriptionId")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "subscriptionId", valid_594366
  var valid_594367 = path.getOrDefault("reportName")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "reportName", valid_594367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594368 = query.getOrDefault("api-version")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "api-version", valid_594368
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

proc call*(call_594370: Call_ReportsCreateOrUpdate_594363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a report. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594370.validator(path, query, header, formData, body)
  let scheme = call_594370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594370.url(scheme.get, call_594370.host, call_594370.base,
                         call_594370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594370, url, valid)

proc call*(call_594371: Call_ReportsCreateOrUpdate_594363; apiVersion: string;
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
  var path_594372 = newJObject()
  var query_594373 = newJObject()
  var body_594374 = newJObject()
  add(query_594373, "api-version", newJString(apiVersion))
  add(path_594372, "subscriptionId", newJString(subscriptionId))
  add(path_594372, "reportName", newJString(reportName))
  if parameters != nil:
    body_594374 = parameters
  result = call_594371.call(path_594372, query_594373, nil, nil, body_594374)

var reportsCreateOrUpdate* = Call_ReportsCreateOrUpdate_594363(
    name: "reportsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdate_594364, base: "",
    url: url_ReportsCreateOrUpdate_594365, schemes: {Scheme.Https})
type
  Call_ReportsGet_594353 = ref object of OpenApiRestCall_593439
proc url_ReportsGet_594355(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ReportsGet_594354(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594356 = path.getOrDefault("subscriptionId")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "subscriptionId", valid_594356
  var valid_594357 = path.getOrDefault("reportName")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "reportName", valid_594357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594358 = query.getOrDefault("api-version")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "api-version", valid_594358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594359: Call_ReportsGet_594353; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594359.validator(path, query, header, formData, body)
  let scheme = call_594359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594359.url(scheme.get, call_594359.host, call_594359.base,
                         call_594359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594359, url, valid)

proc call*(call_594360: Call_ReportsGet_594353; apiVersion: string;
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
  var path_594361 = newJObject()
  var query_594362 = newJObject()
  add(query_594362, "api-version", newJString(apiVersion))
  add(path_594361, "subscriptionId", newJString(subscriptionId))
  add(path_594361, "reportName", newJString(reportName))
  result = call_594360.call(path_594361, query_594362, nil, nil, nil)

var reportsGet* = Call_ReportsGet_594353(name: "reportsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}",
                                      validator: validate_ReportsGet_594354,
                                      base: "", url: url_ReportsGet_594355,
                                      schemes: {Scheme.Https})
type
  Call_ReportsDelete_594375 = ref object of OpenApiRestCall_593439
proc url_ReportsDelete_594377(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsDelete_594376(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594378 = path.getOrDefault("subscriptionId")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "subscriptionId", valid_594378
  var valid_594379 = path.getOrDefault("reportName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "reportName", valid_594379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594380 = query.getOrDefault("api-version")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "api-version", valid_594380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594381: Call_ReportsDelete_594375; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594381.validator(path, query, header, formData, body)
  let scheme = call_594381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594381.url(scheme.get, call_594381.host, call_594381.base,
                         call_594381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594381, url, valid)

proc call*(call_594382: Call_ReportsDelete_594375; apiVersion: string;
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
  var path_594383 = newJObject()
  var query_594384 = newJObject()
  add(query_594384, "api-version", newJString(apiVersion))
  add(path_594383, "subscriptionId", newJString(subscriptionId))
  add(path_594383, "reportName", newJString(reportName))
  result = call_594382.call(path_594383, query_594384, nil, nil, nil)

var reportsDelete* = Call_ReportsDelete_594375(name: "reportsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDelete_594376, base: "", url: url_ReportsDelete_594377,
    schemes: {Scheme.Https})
type
  Call_ReportsExecute_594385 = ref object of OpenApiRestCall_593439
proc url_ReportsExecute_594387(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsExecute_594386(path: JsonNode; query: JsonNode;
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
  var valid_594388 = path.getOrDefault("subscriptionId")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "subscriptionId", valid_594388
  var valid_594389 = path.getOrDefault("reportName")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "reportName", valid_594389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594390 = query.getOrDefault("api-version")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "api-version", valid_594390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594391: Call_ReportsExecute_594385; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to execute a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594391.validator(path, query, header, formData, body)
  let scheme = call_594391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594391.url(scheme.get, call_594391.host, call_594391.base,
                         call_594391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594391, url, valid)

proc call*(call_594392: Call_ReportsExecute_594385; apiVersion: string;
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
  var path_594393 = newJObject()
  var query_594394 = newJObject()
  add(query_594394, "api-version", newJString(apiVersion))
  add(path_594393, "subscriptionId", newJString(subscriptionId))
  add(path_594393, "reportName", newJString(reportName))
  result = call_594392.call(path_594393, query_594394, nil, nil, nil)

var reportsExecute* = Call_ReportsExecute_594385(name: "reportsExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecute_594386, base: "", url: url_ReportsExecute_594387,
    schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistory_594395 = ref object of OpenApiRestCall_593439
proc url_ReportsGetExecutionHistory_594397(protocol: Scheme; host: string;
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

proc validate_ReportsGetExecutionHistory_594396(path: JsonNode; query: JsonNode;
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
  var valid_594398 = path.getOrDefault("subscriptionId")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "subscriptionId", valid_594398
  var valid_594399 = path.getOrDefault("reportName")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "reportName", valid_594399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594400 = query.getOrDefault("api-version")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "api-version", valid_594400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594401: Call_ReportsGetExecutionHistory_594395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the execution history of a report for a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594401.validator(path, query, header, formData, body)
  let scheme = call_594401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594401.url(scheme.get, call_594401.host, call_594401.base,
                         call_594401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594401, url, valid)

proc call*(call_594402: Call_ReportsGetExecutionHistory_594395; apiVersion: string;
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
  var path_594403 = newJObject()
  var query_594404 = newJObject()
  add(query_594404, "api-version", newJString(apiVersion))
  add(path_594403, "subscriptionId", newJString(subscriptionId))
  add(path_594403, "reportName", newJString(reportName))
  result = call_594402.call(path_594403, query_594404, nil, nil, nil)

var reportsGetExecutionHistory* = Call_ReportsGetExecutionHistory_594395(
    name: "reportsGetExecutionHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistory_594396, base: "",
    url: url_ReportsGetExecutionHistory_594397, schemes: {Scheme.Https})
type
  Call_AlertsListByResourceGroupName_594405 = ref object of OpenApiRestCall_593439
proc url_AlertsListByResourceGroupName_594407(protocol: Scheme; host: string;
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

proc validate_AlertsListByResourceGroupName_594406(path: JsonNode; query: JsonNode;
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
  var valid_594408 = path.getOrDefault("resourceGroupName")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "resourceGroupName", valid_594408
  var valid_594409 = path.getOrDefault("subscriptionId")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "subscriptionId", valid_594409
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
  var valid_594410 = query.getOrDefault("api-version")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "api-version", valid_594410
  var valid_594411 = query.getOrDefault("$top")
  valid_594411 = validateParameter(valid_594411, JInt, required = false, default = nil)
  if valid_594411 != nil:
    section.add "$top", valid_594411
  var valid_594412 = query.getOrDefault("$skiptoken")
  valid_594412 = validateParameter(valid_594412, JString, required = false,
                                 default = nil)
  if valid_594412 != nil:
    section.add "$skiptoken", valid_594412
  var valid_594413 = query.getOrDefault("$filter")
  valid_594413 = validateParameter(valid_594413, JString, required = false,
                                 default = nil)
  if valid_594413 != nil:
    section.add "$filter", valid_594413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594414: Call_AlertsListByResourceGroupName_594405; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all alerts for a resource group under a subscription.
  ## 
  let valid = call_594414.validator(path, query, header, formData, body)
  let scheme = call_594414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594414.url(scheme.get, call_594414.host, call_594414.base,
                         call_594414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594414, url, valid)

proc call*(call_594415: Call_AlertsListByResourceGroupName_594405;
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
  var path_594416 = newJObject()
  var query_594417 = newJObject()
  add(path_594416, "resourceGroupName", newJString(resourceGroupName))
  add(query_594417, "api-version", newJString(apiVersion))
  add(path_594416, "subscriptionId", newJString(subscriptionId))
  add(query_594417, "$top", newJInt(Top))
  add(query_594417, "$skiptoken", newJString(Skiptoken))
  add(query_594417, "$filter", newJString(Filter))
  result = call_594415.call(path_594416, query_594417, nil, nil, nil)

var alertsListByResourceGroupName* = Call_AlertsListByResourceGroupName_594405(
    name: "alertsListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/alerts",
    validator: validate_AlertsListByResourceGroupName_594406, base: "",
    url: url_AlertsListByResourceGroupName_594407, schemes: {Scheme.Https})
type
  Call_AlertsGetByResourceGroupName_594418 = ref object of OpenApiRestCall_593439
proc url_AlertsGetByResourceGroupName_594420(protocol: Scheme; host: string;
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

proc validate_AlertsGetByResourceGroupName_594419(path: JsonNode; query: JsonNode;
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
  var valid_594421 = path.getOrDefault("resourceGroupName")
  valid_594421 = validateParameter(valid_594421, JString, required = true,
                                 default = nil)
  if valid_594421 != nil:
    section.add "resourceGroupName", valid_594421
  var valid_594422 = path.getOrDefault("subscriptionId")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "subscriptionId", valid_594422
  var valid_594423 = path.getOrDefault("alertId")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "alertId", valid_594423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594424 = query.getOrDefault("api-version")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "api-version", valid_594424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594425: Call_AlertsGetByResourceGroupName_594418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert for a resource group under a subscription by alert ID.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594425.validator(path, query, header, formData, body)
  let scheme = call_594425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594425.url(scheme.get, call_594425.host, call_594425.base,
                         call_594425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594425, url, valid)

proc call*(call_594426: Call_AlertsGetByResourceGroupName_594418;
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
  var path_594427 = newJObject()
  var query_594428 = newJObject()
  add(path_594427, "resourceGroupName", newJString(resourceGroupName))
  add(query_594428, "api-version", newJString(apiVersion))
  add(path_594427, "subscriptionId", newJString(subscriptionId))
  add(path_594427, "alertId", newJString(alertId))
  result = call_594426.call(path_594427, query_594428, nil, nil, nil)

var alertsGetByResourceGroupName* = Call_AlertsGetByResourceGroupName_594418(
    name: "alertsGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/alerts/{alertId}",
    validator: validate_AlertsGetByResourceGroupName_594419, base: "",
    url: url_AlertsGetByResourceGroupName_594420, schemes: {Scheme.Https})
type
  Call_AlertsUpdateResourceGroupNameAlertStatus_594429 = ref object of OpenApiRestCall_593439
proc url_AlertsUpdateResourceGroupNameAlertStatus_594431(protocol: Scheme;
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

proc validate_AlertsUpdateResourceGroupNameAlertStatus_594430(path: JsonNode;
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
  var valid_594432 = path.getOrDefault("resourceGroupName")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "resourceGroupName", valid_594432
  var valid_594433 = path.getOrDefault("subscriptionId")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "subscriptionId", valid_594433
  var valid_594434 = path.getOrDefault("alertId")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "alertId", valid_594434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594435 = query.getOrDefault("api-version")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "api-version", valid_594435
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

proc call*(call_594437: Call_AlertsUpdateResourceGroupNameAlertStatus_594429;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update alerts status for a resource group under a subscription.
  ## 
  let valid = call_594437.validator(path, query, header, formData, body)
  let scheme = call_594437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594437.url(scheme.get, call_594437.host, call_594437.base,
                         call_594437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594437, url, valid)

proc call*(call_594438: Call_AlertsUpdateResourceGroupNameAlertStatus_594429;
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
  var path_594439 = newJObject()
  var query_594440 = newJObject()
  var body_594441 = newJObject()
  add(path_594439, "resourceGroupName", newJString(resourceGroupName))
  add(query_594440, "api-version", newJString(apiVersion))
  add(path_594439, "subscriptionId", newJString(subscriptionId))
  add(path_594439, "alertId", newJString(alertId))
  if parameters != nil:
    body_594441 = parameters
  result = call_594438.call(path_594439, query_594440, nil, nil, body_594441)

var alertsUpdateResourceGroupNameAlertStatus* = Call_AlertsUpdateResourceGroupNameAlertStatus_594429(
    name: "alertsUpdateResourceGroupNameAlertStatus", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/alerts/{alertId}/updateStatus",
    validator: validate_AlertsUpdateResourceGroupNameAlertStatus_594430, base: "",
    url: url_AlertsUpdateResourceGroupNameAlertStatus_594431,
    schemes: {Scheme.Https})
type
  Call_ResourceGroupDimensionsList_594442 = ref object of OpenApiRestCall_593439
proc url_ResourceGroupDimensionsList_594444(protocol: Scheme; host: string;
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

proc validate_ResourceGroupDimensionsList_594443(path: JsonNode; query: JsonNode;
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
  var valid_594445 = path.getOrDefault("resourceGroupName")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "resourceGroupName", valid_594445
  var valid_594446 = path.getOrDefault("subscriptionId")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "subscriptionId", valid_594446
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
  var valid_594447 = query.getOrDefault("api-version")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "api-version", valid_594447
  var valid_594448 = query.getOrDefault("$expand")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = nil)
  if valid_594448 != nil:
    section.add "$expand", valid_594448
  var valid_594449 = query.getOrDefault("$top")
  valid_594449 = validateParameter(valid_594449, JInt, required = false, default = nil)
  if valid_594449 != nil:
    section.add "$top", valid_594449
  var valid_594450 = query.getOrDefault("$skiptoken")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = nil)
  if valid_594450 != nil:
    section.add "$skiptoken", valid_594450
  var valid_594451 = query.getOrDefault("$filter")
  valid_594451 = validateParameter(valid_594451, JString, required = false,
                                 default = nil)
  if valid_594451 != nil:
    section.add "$filter", valid_594451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594452: Call_ResourceGroupDimensionsList_594442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the dimensions by resource group Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594452.validator(path, query, header, formData, body)
  let scheme = call_594452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594452.url(scheme.get, call_594452.host, call_594452.base,
                         call_594452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594452, url, valid)

proc call*(call_594453: Call_ResourceGroupDimensionsList_594442;
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
  var path_594454 = newJObject()
  var query_594455 = newJObject()
  add(path_594454, "resourceGroupName", newJString(resourceGroupName))
  add(query_594455, "api-version", newJString(apiVersion))
  add(query_594455, "$expand", newJString(Expand))
  add(path_594454, "subscriptionId", newJString(subscriptionId))
  add(query_594455, "$top", newJInt(Top))
  add(query_594455, "$skiptoken", newJString(Skiptoken))
  add(query_594455, "$filter", newJString(Filter))
  result = call_594453.call(path_594454, query_594455, nil, nil, nil)

var resourceGroupDimensionsList* = Call_ResourceGroupDimensionsList_594442(
    name: "resourceGroupDimensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/dimensions",
    validator: validate_ResourceGroupDimensionsList_594443, base: "",
    url: url_ResourceGroupDimensionsList_594444, schemes: {Scheme.Https})
type
  Call_ReportsListByResourceGroupName_594456 = ref object of OpenApiRestCall_593439
proc url_ReportsListByResourceGroupName_594458(protocol: Scheme; host: string;
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

proc validate_ReportsListByResourceGroupName_594457(path: JsonNode;
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
  var valid_594459 = path.getOrDefault("resourceGroupName")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "resourceGroupName", valid_594459
  var valid_594460 = path.getOrDefault("subscriptionId")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "subscriptionId", valid_594460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594461 = query.getOrDefault("api-version")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "api-version", valid_594461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594462: Call_ReportsListByResourceGroupName_594456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all reports for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594462.validator(path, query, header, formData, body)
  let scheme = call_594462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594462.url(scheme.get, call_594462.host, call_594462.base,
                         call_594462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594462, url, valid)

proc call*(call_594463: Call_ReportsListByResourceGroupName_594456;
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
  var path_594464 = newJObject()
  var query_594465 = newJObject()
  add(path_594464, "resourceGroupName", newJString(resourceGroupName))
  add(query_594465, "api-version", newJString(apiVersion))
  add(path_594464, "subscriptionId", newJString(subscriptionId))
  result = call_594463.call(path_594464, query_594465, nil, nil, nil)

var reportsListByResourceGroupName* = Call_ReportsListByResourceGroupName_594456(
    name: "reportsListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports",
    validator: validate_ReportsListByResourceGroupName_594457, base: "",
    url: url_ReportsListByResourceGroupName_594458, schemes: {Scheme.Https})
type
  Call_ReportsCreateOrUpdateByResourceGroupName_594477 = ref object of OpenApiRestCall_593439
proc url_ReportsCreateOrUpdateByResourceGroupName_594479(protocol: Scheme;
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

proc validate_ReportsCreateOrUpdateByResourceGroupName_594478(path: JsonNode;
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
  var valid_594480 = path.getOrDefault("resourceGroupName")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "resourceGroupName", valid_594480
  var valid_594481 = path.getOrDefault("subscriptionId")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "subscriptionId", valid_594481
  var valid_594482 = path.getOrDefault("reportName")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "reportName", valid_594482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594483 = query.getOrDefault("api-version")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "api-version", valid_594483
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

proc call*(call_594485: Call_ReportsCreateOrUpdateByResourceGroupName_594477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a report. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594485.validator(path, query, header, formData, body)
  let scheme = call_594485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594485.url(scheme.get, call_594485.host, call_594485.base,
                         call_594485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594485, url, valid)

proc call*(call_594486: Call_ReportsCreateOrUpdateByResourceGroupName_594477;
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
  var path_594487 = newJObject()
  var query_594488 = newJObject()
  var body_594489 = newJObject()
  add(path_594487, "resourceGroupName", newJString(resourceGroupName))
  add(query_594488, "api-version", newJString(apiVersion))
  add(path_594487, "subscriptionId", newJString(subscriptionId))
  add(path_594487, "reportName", newJString(reportName))
  if parameters != nil:
    body_594489 = parameters
  result = call_594486.call(path_594487, query_594488, nil, nil, body_594489)

var reportsCreateOrUpdateByResourceGroupName* = Call_ReportsCreateOrUpdateByResourceGroupName_594477(
    name: "reportsCreateOrUpdateByResourceGroupName", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsCreateOrUpdateByResourceGroupName_594478, base: "",
    url: url_ReportsCreateOrUpdateByResourceGroupName_594479,
    schemes: {Scheme.Https})
type
  Call_ReportsGetByResourceGroupName_594466 = ref object of OpenApiRestCall_593439
proc url_ReportsGetByResourceGroupName_594468(protocol: Scheme; host: string;
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

proc validate_ReportsGetByResourceGroupName_594467(path: JsonNode; query: JsonNode;
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
  var valid_594469 = path.getOrDefault("resourceGroupName")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "resourceGroupName", valid_594469
  var valid_594470 = path.getOrDefault("subscriptionId")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "subscriptionId", valid_594470
  var valid_594471 = path.getOrDefault("reportName")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "reportName", valid_594471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594472 = query.getOrDefault("api-version")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "api-version", valid_594472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594473: Call_ReportsGetByResourceGroupName_594466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the report for a resource group under a subscription by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594473.validator(path, query, header, formData, body)
  let scheme = call_594473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594473.url(scheme.get, call_594473.host, call_594473.base,
                         call_594473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594473, url, valid)

proc call*(call_594474: Call_ReportsGetByResourceGroupName_594466;
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
  var path_594475 = newJObject()
  var query_594476 = newJObject()
  add(path_594475, "resourceGroupName", newJString(resourceGroupName))
  add(query_594476, "api-version", newJString(apiVersion))
  add(path_594475, "subscriptionId", newJString(subscriptionId))
  add(path_594475, "reportName", newJString(reportName))
  result = call_594474.call(path_594475, query_594476, nil, nil, nil)

var reportsGetByResourceGroupName* = Call_ReportsGetByResourceGroupName_594466(
    name: "reportsGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsGetByResourceGroupName_594467, base: "",
    url: url_ReportsGetByResourceGroupName_594468, schemes: {Scheme.Https})
type
  Call_ReportsDeleteByResourceGroupName_594490 = ref object of OpenApiRestCall_593439
proc url_ReportsDeleteByResourceGroupName_594492(protocol: Scheme; host: string;
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

proc validate_ReportsDeleteByResourceGroupName_594491(path: JsonNode;
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
  var valid_594493 = path.getOrDefault("resourceGroupName")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "resourceGroupName", valid_594493
  var valid_594494 = path.getOrDefault("subscriptionId")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "subscriptionId", valid_594494
  var valid_594495 = path.getOrDefault("reportName")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "reportName", valid_594495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594496 = query.getOrDefault("api-version")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "api-version", valid_594496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594497: Call_ReportsDeleteByResourceGroupName_594490;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594497.validator(path, query, header, formData, body)
  let scheme = call_594497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594497.url(scheme.get, call_594497.host, call_594497.base,
                         call_594497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594497, url, valid)

proc call*(call_594498: Call_ReportsDeleteByResourceGroupName_594490;
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
  var path_594499 = newJObject()
  var query_594500 = newJObject()
  add(path_594499, "resourceGroupName", newJString(resourceGroupName))
  add(query_594500, "api-version", newJString(apiVersion))
  add(path_594499, "subscriptionId", newJString(subscriptionId))
  add(path_594499, "reportName", newJString(reportName))
  result = call_594498.call(path_594499, query_594500, nil, nil, nil)

var reportsDeleteByResourceGroupName* = Call_ReportsDeleteByResourceGroupName_594490(
    name: "reportsDeleteByResourceGroupName", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}",
    validator: validate_ReportsDeleteByResourceGroupName_594491, base: "",
    url: url_ReportsDeleteByResourceGroupName_594492, schemes: {Scheme.Https})
type
  Call_ReportsExecuteByResourceGroupName_594501 = ref object of OpenApiRestCall_593439
proc url_ReportsExecuteByResourceGroupName_594503(protocol: Scheme; host: string;
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

proc validate_ReportsExecuteByResourceGroupName_594502(path: JsonNode;
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
  var valid_594504 = path.getOrDefault("resourceGroupName")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "resourceGroupName", valid_594504
  var valid_594505 = path.getOrDefault("subscriptionId")
  valid_594505 = validateParameter(valid_594505, JString, required = true,
                                 default = nil)
  if valid_594505 != nil:
    section.add "subscriptionId", valid_594505
  var valid_594506 = path.getOrDefault("reportName")
  valid_594506 = validateParameter(valid_594506, JString, required = true,
                                 default = nil)
  if valid_594506 != nil:
    section.add "reportName", valid_594506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594507 = query.getOrDefault("api-version")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "api-version", valid_594507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594508: Call_ReportsExecuteByResourceGroupName_594501;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to execute a report.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594508.validator(path, query, header, formData, body)
  let scheme = call_594508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594508.url(scheme.get, call_594508.host, call_594508.base,
                         call_594508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594508, url, valid)

proc call*(call_594509: Call_ReportsExecuteByResourceGroupName_594501;
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
  var path_594510 = newJObject()
  var query_594511 = newJObject()
  add(path_594510, "resourceGroupName", newJString(resourceGroupName))
  add(query_594511, "api-version", newJString(apiVersion))
  add(path_594510, "subscriptionId", newJString(subscriptionId))
  add(path_594510, "reportName", newJString(reportName))
  result = call_594509.call(path_594510, query_594511, nil, nil, nil)

var reportsExecuteByResourceGroupName* = Call_ReportsExecuteByResourceGroupName_594501(
    name: "reportsExecuteByResourceGroupName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}/run",
    validator: validate_ReportsExecuteByResourceGroupName_594502, base: "",
    url: url_ReportsExecuteByResourceGroupName_594503, schemes: {Scheme.Https})
type
  Call_ReportsGetExecutionHistoryByResourceGroupName_594512 = ref object of OpenApiRestCall_593439
proc url_ReportsGetExecutionHistoryByResourceGroupName_594514(protocol: Scheme;
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

proc validate_ReportsGetExecutionHistoryByResourceGroupName_594513(
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
  var valid_594515 = path.getOrDefault("resourceGroupName")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "resourceGroupName", valid_594515
  var valid_594516 = path.getOrDefault("subscriptionId")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = nil)
  if valid_594516 != nil:
    section.add "subscriptionId", valid_594516
  var valid_594517 = path.getOrDefault("reportName")
  valid_594517 = validateParameter(valid_594517, JString, required = true,
                                 default = nil)
  if valid_594517 != nil:
    section.add "reportName", valid_594517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594518 = query.getOrDefault("api-version")
  valid_594518 = validateParameter(valid_594518, JString, required = true,
                                 default = nil)
  if valid_594518 != nil:
    section.add "api-version", valid_594518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594519: Call_ReportsGetExecutionHistoryByResourceGroupName_594512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the execution history of a report for a resource group by report name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594519.validator(path, query, header, formData, body)
  let scheme = call_594519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594519.url(scheme.get, call_594519.host, call_594519.base,
                         call_594519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594519, url, valid)

proc call*(call_594520: Call_ReportsGetExecutionHistoryByResourceGroupName_594512;
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
  var path_594521 = newJObject()
  var query_594522 = newJObject()
  add(path_594521, "resourceGroupName", newJString(resourceGroupName))
  add(query_594522, "api-version", newJString(apiVersion))
  add(path_594521, "subscriptionId", newJString(subscriptionId))
  add(path_594521, "reportName", newJString(reportName))
  result = call_594520.call(path_594521, query_594522, nil, nil, nil)

var reportsGetExecutionHistoryByResourceGroupName* = Call_ReportsGetExecutionHistoryByResourceGroupName_594512(
    name: "reportsGetExecutionHistoryByResourceGroupName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CostManagement/reports/{reportName}/runHistory",
    validator: validate_ReportsGetExecutionHistoryByResourceGroupName_594513,
    base: "", url: url_ReportsGetExecutionHistoryByResourceGroupName_594514,
    schemes: {Scheme.Https})
type
  Call_QueryResourceGroup_594523 = ref object of OpenApiRestCall_593439
proc url_QueryResourceGroup_594525(protocol: Scheme; host: string; base: string;
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

proc validate_QueryResourceGroup_594524(path: JsonNode; query: JsonNode;
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
  var valid_594526 = path.getOrDefault("resourceGroupName")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "resourceGroupName", valid_594526
  var valid_594527 = path.getOrDefault("subscriptionId")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "subscriptionId", valid_594527
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594528 = query.getOrDefault("api-version")
  valid_594528 = validateParameter(valid_594528, JString, required = true,
                                 default = nil)
  if valid_594528 != nil:
    section.add "api-version", valid_594528
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

proc call*(call_594530: Call_QueryResourceGroup_594523; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage data for subscriptionId and resource group.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594530.validator(path, query, header, formData, body)
  let scheme = call_594530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594530.url(scheme.get, call_594530.host, call_594530.base,
                         call_594530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594530, url, valid)

proc call*(call_594531: Call_QueryResourceGroup_594523; resourceGroupName: string;
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
  var path_594532 = newJObject()
  var query_594533 = newJObject()
  var body_594534 = newJObject()
  add(path_594532, "resourceGroupName", newJString(resourceGroupName))
  add(query_594533, "api-version", newJString(apiVersion))
  add(path_594532, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594534 = parameters
  result = call_594531.call(path_594532, query_594533, nil, nil, body_594534)

var queryResourceGroup* = Call_QueryResourceGroup_594523(
    name: "queryResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/Query",
    validator: validate_QueryResourceGroup_594524, base: "",
    url: url_QueryResourceGroup_594525, schemes: {Scheme.Https})
type
  Call_ConnectorListByResourceGroupName_594535 = ref object of OpenApiRestCall_593439
proc url_ConnectorListByResourceGroupName_594537(protocol: Scheme; host: string;
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

proc validate_ConnectorListByResourceGroupName_594536(path: JsonNode;
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
  var valid_594538 = path.getOrDefault("resourceGroupName")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "resourceGroupName", valid_594538
  var valid_594539 = path.getOrDefault("subscriptionId")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "subscriptionId", valid_594539
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594540 = query.getOrDefault("api-version")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "api-version", valid_594540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594541: Call_ConnectorListByResourceGroupName_594535;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all connector definitions for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594541.validator(path, query, header, formData, body)
  let scheme = call_594541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594541.url(scheme.get, call_594541.host, call_594541.base,
                         call_594541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594541, url, valid)

proc call*(call_594542: Call_ConnectorListByResourceGroupName_594535;
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
  var path_594543 = newJObject()
  var query_594544 = newJObject()
  add(path_594543, "resourceGroupName", newJString(resourceGroupName))
  add(query_594544, "api-version", newJString(apiVersion))
  add(path_594543, "subscriptionId", newJString(subscriptionId))
  result = call_594542.call(path_594543, query_594544, nil, nil, nil)

var connectorListByResourceGroupName* = Call_ConnectorListByResourceGroupName_594535(
    name: "connectorListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors",
    validator: validate_ConnectorListByResourceGroupName_594536, base: "",
    url: url_ConnectorListByResourceGroupName_594537, schemes: {Scheme.Https})
type
  Call_ConnectorCreateOrUpdate_594556 = ref object of OpenApiRestCall_593439
proc url_ConnectorCreateOrUpdate_594558(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorCreateOrUpdate_594557(path: JsonNode; query: JsonNode;
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
  var valid_594559 = path.getOrDefault("resourceGroupName")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "resourceGroupName", valid_594559
  var valid_594560 = path.getOrDefault("subscriptionId")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "subscriptionId", valid_594560
  var valid_594561 = path.getOrDefault("connectorName")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = nil)
  if valid_594561 != nil:
    section.add "connectorName", valid_594561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594562 = query.getOrDefault("api-version")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = nil)
  if valid_594562 != nil:
    section.add "api-version", valid_594562
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

proc call*(call_594564: Call_ConnectorCreateOrUpdate_594556; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594564.validator(path, query, header, formData, body)
  let scheme = call_594564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594564.url(scheme.get, call_594564.host, call_594564.base,
                         call_594564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594564, url, valid)

proc call*(call_594565: Call_ConnectorCreateOrUpdate_594556;
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
  var path_594566 = newJObject()
  var query_594567 = newJObject()
  var body_594568 = newJObject()
  add(path_594566, "resourceGroupName", newJString(resourceGroupName))
  add(query_594567, "api-version", newJString(apiVersion))
  add(path_594566, "subscriptionId", newJString(subscriptionId))
  if connector != nil:
    body_594568 = connector
  add(path_594566, "connectorName", newJString(connectorName))
  result = call_594565.call(path_594566, query_594567, nil, nil, body_594568)

var connectorCreateOrUpdate* = Call_ConnectorCreateOrUpdate_594556(
    name: "connectorCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorCreateOrUpdate_594557, base: "",
    url: url_ConnectorCreateOrUpdate_594558, schemes: {Scheme.Https})
type
  Call_ConnectorGet_594545 = ref object of OpenApiRestCall_593439
proc url_ConnectorGet_594547(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorGet_594546(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594548 = path.getOrDefault("resourceGroupName")
  valid_594548 = validateParameter(valid_594548, JString, required = true,
                                 default = nil)
  if valid_594548 != nil:
    section.add "resourceGroupName", valid_594548
  var valid_594549 = path.getOrDefault("subscriptionId")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "subscriptionId", valid_594549
  var valid_594550 = path.getOrDefault("connectorName")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "connectorName", valid_594550
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594551 = query.getOrDefault("api-version")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "api-version", valid_594551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594552: Call_ConnectorGet_594545; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594552.validator(path, query, header, formData, body)
  let scheme = call_594552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594552.url(scheme.get, call_594552.host, call_594552.base,
                         call_594552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594552, url, valid)

proc call*(call_594553: Call_ConnectorGet_594545; resourceGroupName: string;
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
  var path_594554 = newJObject()
  var query_594555 = newJObject()
  add(path_594554, "resourceGroupName", newJString(resourceGroupName))
  add(query_594555, "api-version", newJString(apiVersion))
  add(path_594554, "subscriptionId", newJString(subscriptionId))
  add(path_594554, "connectorName", newJString(connectorName))
  result = call_594553.call(path_594554, query_594555, nil, nil, nil)

var connectorGet* = Call_ConnectorGet_594545(name: "connectorGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorGet_594546, base: "", url: url_ConnectorGet_594547,
    schemes: {Scheme.Https})
type
  Call_ConnectorUpdate_594580 = ref object of OpenApiRestCall_593439
proc url_ConnectorUpdate_594582(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorUpdate_594581(path: JsonNode; query: JsonNode;
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
  var valid_594583 = path.getOrDefault("resourceGroupName")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "resourceGroupName", valid_594583
  var valid_594584 = path.getOrDefault("subscriptionId")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "subscriptionId", valid_594584
  var valid_594585 = path.getOrDefault("connectorName")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = nil)
  if valid_594585 != nil:
    section.add "connectorName", valid_594585
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594586 = query.getOrDefault("api-version")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "api-version", valid_594586
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

proc call*(call_594588: Call_ConnectorUpdate_594580; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594588.validator(path, query, header, formData, body)
  let scheme = call_594588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594588.url(scheme.get, call_594588.host, call_594588.base,
                         call_594588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594588, url, valid)

proc call*(call_594589: Call_ConnectorUpdate_594580; resourceGroupName: string;
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
  var path_594590 = newJObject()
  var query_594591 = newJObject()
  var body_594592 = newJObject()
  add(path_594590, "resourceGroupName", newJString(resourceGroupName))
  add(query_594591, "api-version", newJString(apiVersion))
  add(path_594590, "subscriptionId", newJString(subscriptionId))
  if connector != nil:
    body_594592 = connector
  add(path_594590, "connectorName", newJString(connectorName))
  result = call_594589.call(path_594590, query_594591, nil, nil, body_594592)

var connectorUpdate* = Call_ConnectorUpdate_594580(name: "connectorUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorUpdate_594581, base: "", url: url_ConnectorUpdate_594582,
    schemes: {Scheme.Https})
type
  Call_ConnectorDelete_594569 = ref object of OpenApiRestCall_593439
proc url_ConnectorDelete_594571(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorDelete_594570(path: JsonNode; query: JsonNode;
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
  var valid_594572 = path.getOrDefault("resourceGroupName")
  valid_594572 = validateParameter(valid_594572, JString, required = true,
                                 default = nil)
  if valid_594572 != nil:
    section.add "resourceGroupName", valid_594572
  var valid_594573 = path.getOrDefault("subscriptionId")
  valid_594573 = validateParameter(valid_594573, JString, required = true,
                                 default = nil)
  if valid_594573 != nil:
    section.add "subscriptionId", valid_594573
  var valid_594574 = path.getOrDefault("connectorName")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "connectorName", valid_594574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594575 = query.getOrDefault("api-version")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "api-version", valid_594575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594576: Call_ConnectorDelete_594569; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a connector definition
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/costmanagement/
  let valid = call_594576.validator(path, query, header, formData, body)
  let scheme = call_594576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594576.url(scheme.get, call_594576.host, call_594576.base,
                         call_594576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594576, url, valid)

proc call*(call_594577: Call_ConnectorDelete_594569; resourceGroupName: string;
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
  var path_594578 = newJObject()
  var query_594579 = newJObject()
  add(path_594578, "resourceGroupName", newJString(resourceGroupName))
  add(query_594579, "api-version", newJString(apiVersion))
  add(path_594578, "subscriptionId", newJString(subscriptionId))
  add(path_594578, "connectorName", newJString(connectorName))
  result = call_594577.call(path_594578, query_594579, nil, nil, nil)

var connectorDelete* = Call_ConnectorDelete_594569(name: "connectorDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.CostManagement/connectors/{connectorName}",
    validator: validate_ConnectorDelete_594570, base: "", url: url_ConnectorDelete_594571,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
