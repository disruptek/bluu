
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ConsumptionManagementClient
## version: 2018-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Consumption management client provides access to consumption resources for Azure Enterprise Subscriptions.
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
  macServiceName = "consumption"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TenantsGet_563788 = ref object of OpenApiRestCall_563566
proc url_TenantsGet_563790(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "billingProfileId" in path,
        "`billingProfileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/tenants")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantsGet_563789(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Tenant Properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : Billing Account Id.
  ##   billingProfileId: JString (required)
  ##                   : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_563965 = path.getOrDefault("billingAccountId")
  valid_563965 = validateParameter(valid_563965, JString, required = true,
                                 default = nil)
  if valid_563965 != nil:
    section.add "billingAccountId", valid_563965
  var valid_563966 = path.getOrDefault("billingProfileId")
  valid_563966 = validateParameter(valid_563966, JString, required = true,
                                 default = nil)
  if valid_563966 != nil:
    section.add "billingProfileId", valid_563966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563967 = query.getOrDefault("api-version")
  valid_563967 = validateParameter(valid_563967, JString, required = true,
                                 default = nil)
  if valid_563967 != nil:
    section.add "api-version", valid_563967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563990: Call_TenantsGet_563788; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Tenant Properties.
  ## 
  let valid = call_563990.validator(path, query, header, formData, body)
  let scheme = call_563990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563990.url(scheme.get, call_563990.host, call_563990.base,
                         call_563990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563990, url, valid)

proc call*(call_564061: Call_TenantsGet_563788; apiVersion: string;
          billingAccountId: string; billingProfileId: string): Recallable =
  ## tenantsGet
  ## Gets a Tenant Properties.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   billingAccountId: string (required)
  ##                   : Billing Account Id.
  ##   billingProfileId: string (required)
  ##                   : Billing Profile Id.
  var path_564062 = newJObject()
  var query_564064 = newJObject()
  add(query_564064, "api-version", newJString(apiVersion))
  add(path_564062, "billingAccountId", newJString(billingAccountId))
  add(path_564062, "billingProfileId", newJString(billingProfileId))
  result = call_564061.call(path_564062, query_564064, nil, nil, nil)

var tenantsGet* = Call_TenantsGet_563788(name: "tenantsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/tenants",
                                      validator: validate_TenantsGet_563789,
                                      base: "", url: url_TenantsGet_563790,
                                      schemes: {Scheme.Https})
type
  Call_ChargesListForBillingPeriodByDepartment_564103 = ref object of OpenApiRestCall_563566
proc url_ChargesListForBillingPeriodByDepartment_564105(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/charges")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChargesListForBillingPeriodByDepartment_564104(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the charges based on departmentId by billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564107 = path.getOrDefault("departmentId")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "departmentId", valid_564107
  var valid_564108 = path.getOrDefault("billingPeriodName")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "billingPeriodName", valid_564108
  var valid_564109 = path.getOrDefault("billingAccountId")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "billingAccountId", valid_564109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $filter: JString
  ##          : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564110 = query.getOrDefault("api-version")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "api-version", valid_564110
  var valid_564111 = query.getOrDefault("$filter")
  valid_564111 = validateParameter(valid_564111, JString, required = false,
                                 default = nil)
  if valid_564111 != nil:
    section.add "$filter", valid_564111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564112: Call_ChargesListForBillingPeriodByDepartment_564103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the charges based on departmentId by billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564112.validator(path, query, header, formData, body)
  let scheme = call_564112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564112.url(scheme.get, call_564112.host, call_564112.base,
                         call_564112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564112, url, valid)

proc call*(call_564113: Call_ChargesListForBillingPeriodByDepartment_564103;
          apiVersion: string; departmentId: string; billingPeriodName: string;
          billingAccountId: string; Filter: string = ""): Recallable =
  ## chargesListForBillingPeriodByDepartment
  ## Lists the charges based on departmentId by billing period.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564114 = newJObject()
  var query_564115 = newJObject()
  add(query_564115, "api-version", newJString(apiVersion))
  add(path_564114, "departmentId", newJString(departmentId))
  add(path_564114, "billingPeriodName", newJString(billingPeriodName))
  add(path_564114, "billingAccountId", newJString(billingAccountId))
  add(query_564115, "$filter", newJString(Filter))
  result = call_564113.call(path_564114, query_564115, nil, nil, nil)

var chargesListForBillingPeriodByDepartment* = Call_ChargesListForBillingPeriodByDepartment_564103(
    name: "chargesListForBillingPeriodByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesListForBillingPeriodByDepartment_564104, base: "",
    url: url_ChargesListForBillingPeriodByDepartment_564105,
    schemes: {Scheme.Https})
type
  Call_ChargesListByDepartment_564116 = ref object of OpenApiRestCall_563566
proc url_ChargesListByDepartment_564118(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/charges")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChargesListByDepartment_564117(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the charges by departmentId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
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
  var valid_564119 = path.getOrDefault("departmentId")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "departmentId", valid_564119
  var valid_564120 = path.getOrDefault("billingAccountId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "billingAccountId", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $filter: JString
  ##          : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
  var valid_564122 = query.getOrDefault("$filter")
  valid_564122 = validateParameter(valid_564122, JString, required = false,
                                 default = nil)
  if valid_564122 != nil:
    section.add "$filter", valid_564122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564123: Call_ChargesListByDepartment_564116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by departmentId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564123.validator(path, query, header, formData, body)
  let scheme = call_564123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564123.url(scheme.get, call_564123.host, call_564123.base,
                         call_564123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564123, url, valid)

proc call*(call_564124: Call_ChargesListByDepartment_564116; apiVersion: string;
          departmentId: string; billingAccountId: string; Filter: string = ""): Recallable =
  ## chargesListByDepartment
  ## Lists the charges by departmentId.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564125 = newJObject()
  var query_564126 = newJObject()
  add(query_564126, "api-version", newJString(apiVersion))
  add(path_564125, "departmentId", newJString(departmentId))
  add(path_564125, "billingAccountId", newJString(billingAccountId))
  add(query_564126, "$filter", newJString(Filter))
  result = call_564124.call(path_564125, query_564126, nil, nil, nil)

var chargesListByDepartment* = Call_ChargesListByDepartment_564116(
    name: "chargesListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesListByDepartment_564117, base: "",
    url: url_ChargesListByDepartment_564118, schemes: {Scheme.Https})
type
  Call_ChargesListForBillingPeriodByEnrollmentAccount_564127 = ref object of OpenApiRestCall_563566
proc url_ChargesListForBillingPeriodByEnrollmentAccount_564129(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/charges")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChargesListForBillingPeriodByEnrollmentAccount_564128(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the charges based on enrollmentAccountId by billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_564130 = path.getOrDefault("enrollmentAccountId")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "enrollmentAccountId", valid_564130
  var valid_564131 = path.getOrDefault("billingPeriodName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "billingPeriodName", valid_564131
  var valid_564132 = path.getOrDefault("billingAccountId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "billingAccountId", valid_564132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $filter: JString
  ##          : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564133 = query.getOrDefault("api-version")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "api-version", valid_564133
  var valid_564134 = query.getOrDefault("$filter")
  valid_564134 = validateParameter(valid_564134, JString, required = false,
                                 default = nil)
  if valid_564134 != nil:
    section.add "$filter", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_ChargesListForBillingPeriodByEnrollmentAccount_564127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the charges based on enrollmentAccountId by billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_ChargesListForBillingPeriodByEnrollmentAccount_564127;
          apiVersion: string; enrollmentAccountId: string;
          billingPeriodName: string; billingAccountId: string; Filter: string = ""): Recallable =
  ## chargesListForBillingPeriodByEnrollmentAccount
  ## Lists the charges based on enrollmentAccountId by billing period.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_564137, "billingPeriodName", newJString(billingPeriodName))
  add(path_564137, "billingAccountId", newJString(billingAccountId))
  add(query_564138, "$filter", newJString(Filter))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var chargesListForBillingPeriodByEnrollmentAccount* = Call_ChargesListForBillingPeriodByEnrollmentAccount_564127(
    name: "chargesListForBillingPeriodByEnrollmentAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesListForBillingPeriodByEnrollmentAccount_564128,
    base: "", url: url_ChargesListForBillingPeriodByEnrollmentAccount_564129,
    schemes: {Scheme.Https})
type
  Call_ChargesListByEnrollmentAccount_564139 = ref object of OpenApiRestCall_563566
proc url_ChargesListByEnrollmentAccount_564141(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/charges")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChargesListByEnrollmentAccount_564140(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the charges by enrollmentAccountId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : EnrollmentAccount ID
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_564142 = path.getOrDefault("enrollmentAccountId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "enrollmentAccountId", valid_564142
  var valid_564143 = path.getOrDefault("billingAccountId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "billingAccountId", valid_564143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $filter: JString
  ##          : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564144 = query.getOrDefault("api-version")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "api-version", valid_564144
  var valid_564145 = query.getOrDefault("$filter")
  valid_564145 = validateParameter(valid_564145, JString, required = false,
                                 default = nil)
  if valid_564145 != nil:
    section.add "$filter", valid_564145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564146: Call_ChargesListByEnrollmentAccount_564139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by enrollmentAccountId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_ChargesListByEnrollmentAccount_564139;
          apiVersion: string; enrollmentAccountId: string; billingAccountId: string;
          Filter: string = ""): Recallable =
  ## chargesListByEnrollmentAccount
  ## Lists the charges by enrollmentAccountId.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564148 = newJObject()
  var query_564149 = newJObject()
  add(query_564149, "api-version", newJString(apiVersion))
  add(path_564148, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_564148, "billingAccountId", newJString(billingAccountId))
  add(query_564149, "$filter", newJString(Filter))
  result = call_564147.call(path_564148, query_564149, nil, nil, nil)

var chargesListByEnrollmentAccount* = Call_ChargesListByEnrollmentAccount_564139(
    name: "chargesListByEnrollmentAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesListByEnrollmentAccount_564140, base: "",
    url: url_ChargesListByEnrollmentAccount_564141, schemes: {Scheme.Https})
type
  Call_BalancesGetForBillingPeriodByBillingAccount_564150 = ref object of OpenApiRestCall_563566
proc url_BalancesGetForBillingPeriodByBillingAccount_564152(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/balances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BalancesGetForBillingPeriodByBillingAccount_564151(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_564153 = path.getOrDefault("billingPeriodName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "billingPeriodName", valid_564153
  var valid_564154 = path.getOrDefault("billingAccountId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "billingAccountId", valid_564154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_BalancesGetForBillingPeriodByBillingAccount_564150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_BalancesGetForBillingPeriodByBillingAccount_564150;
          apiVersion: string; billingPeriodName: string; billingAccountId: string): Recallable =
  ## balancesGetForBillingPeriodByBillingAccount
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "billingPeriodName", newJString(billingPeriodName))
  add(path_564158, "billingAccountId", newJString(billingAccountId))
  result = call_564157.call(path_564158, query_564159, nil, nil, nil)

var balancesGetForBillingPeriodByBillingAccount* = Call_BalancesGetForBillingPeriodByBillingAccount_564150(
    name: "balancesGetForBillingPeriodByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/balances",
    validator: validate_BalancesGetForBillingPeriodByBillingAccount_564151,
    base: "", url: url_BalancesGetForBillingPeriodByBillingAccount_564152,
    schemes: {Scheme.Https})
type
  Call_MarketplacesListForBillingPeriodByBillingAccount_564160 = ref object of OpenApiRestCall_563566
proc url_MarketplacesListForBillingPeriodByBillingAccount_564162(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesListForBillingPeriodByBillingAccount_564161(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billing period and billingAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_564163 = path.getOrDefault("billingPeriodName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "billingPeriodName", valid_564163
  var valid_564164 = path.getOrDefault("billingAccountId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "billingAccountId", valid_564164
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_564165 = query.getOrDefault("$top")
  valid_564165 = validateParameter(valid_564165, JInt, required = false, default = nil)
  if valid_564165 != nil:
    section.add "$top", valid_564165
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  var valid_564167 = query.getOrDefault("$skiptoken")
  valid_564167 = validateParameter(valid_564167, JString, required = false,
                                 default = nil)
  if valid_564167 != nil:
    section.add "$skiptoken", valid_564167
  var valid_564168 = query.getOrDefault("$filter")
  valid_564168 = validateParameter(valid_564168, JString, required = false,
                                 default = nil)
  if valid_564168 != nil:
    section.add "$filter", valid_564168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564169: Call_MarketplacesListForBillingPeriodByBillingAccount_564160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and billingAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_MarketplacesListForBillingPeriodByBillingAccount_564160;
          apiVersion: string; billingPeriodName: string; billingAccountId: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListForBillingPeriodByBillingAccount
  ## Lists the marketplaces for a scope by billing period and billingAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  add(query_564172, "$top", newJInt(Top))
  add(query_564172, "api-version", newJString(apiVersion))
  add(query_564172, "$skiptoken", newJString(Skiptoken))
  add(path_564171, "billingPeriodName", newJString(billingPeriodName))
  add(query_564172, "$filter", newJString(Filter))
  add(path_564171, "billingAccountId", newJString(billingAccountId))
  result = call_564170.call(path_564171, query_564172, nil, nil, nil)

var marketplacesListForBillingPeriodByBillingAccount* = Call_MarketplacesListForBillingPeriodByBillingAccount_564160(
    name: "marketplacesListForBillingPeriodByBillingAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListForBillingPeriodByBillingAccount_564161,
    base: "", url: url_MarketplacesListForBillingPeriodByBillingAccount_564162,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsListForBillingPeriodByBillingAccount_564173 = ref object of OpenApiRestCall_563566
proc url_UsageDetailsListForBillingPeriodByBillingAccount_564175(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsListForBillingPeriodByBillingAccount_564174(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the usage details based on billingAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_564176 = path.getOrDefault("billingPeriodName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "billingPeriodName", valid_564176
  var valid_564177 = path.getOrDefault("billingAccountId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "billingAccountId", valid_564177
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_564178 = query.getOrDefault("$top")
  valid_564178 = validateParameter(valid_564178, JInt, required = false, default = nil)
  if valid_564178 != nil:
    section.add "$top", valid_564178
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564179 = query.getOrDefault("api-version")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "api-version", valid_564179
  var valid_564180 = query.getOrDefault("$expand")
  valid_564180 = validateParameter(valid_564180, JString, required = false,
                                 default = nil)
  if valid_564180 != nil:
    section.add "$expand", valid_564180
  var valid_564181 = query.getOrDefault("$apply")
  valid_564181 = validateParameter(valid_564181, JString, required = false,
                                 default = nil)
  if valid_564181 != nil:
    section.add "$apply", valid_564181
  var valid_564182 = query.getOrDefault("$skiptoken")
  valid_564182 = validateParameter(valid_564182, JString, required = false,
                                 default = nil)
  if valid_564182 != nil:
    section.add "$skiptoken", valid_564182
  var valid_564183 = query.getOrDefault("$filter")
  valid_564183 = validateParameter(valid_564183, JString, required = false,
                                 default = nil)
  if valid_564183 != nil:
    section.add "$filter", valid_564183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_UsageDetailsListForBillingPeriodByBillingAccount_564173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details based on billingAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_UsageDetailsListForBillingPeriodByBillingAccount_564173;
          apiVersion: string; billingPeriodName: string; billingAccountId: string;
          Top: int = 0; Expand: string = ""; Apply: string = ""; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListForBillingPeriodByBillingAccount
  ## Lists the usage details based on billingAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  add(query_564187, "$top", newJInt(Top))
  add(query_564187, "api-version", newJString(apiVersion))
  add(query_564187, "$expand", newJString(Expand))
  add(query_564187, "$apply", newJString(Apply))
  add(query_564187, "$skiptoken", newJString(Skiptoken))
  add(path_564186, "billingPeriodName", newJString(billingPeriodName))
  add(path_564186, "billingAccountId", newJString(billingAccountId))
  add(query_564187, "$filter", newJString(Filter))
  result = call_564185.call(path_564186, query_564187, nil, nil, nil)

var usageDetailsListForBillingPeriodByBillingAccount* = Call_UsageDetailsListForBillingPeriodByBillingAccount_564173(
    name: "usageDetailsListForBillingPeriodByBillingAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListForBillingPeriodByBillingAccount_564174,
    base: "", url: url_UsageDetailsListForBillingPeriodByBillingAccount_564175,
    schemes: {Scheme.Https})
type
  Call_BalancesGetByBillingAccount_564188 = ref object of OpenApiRestCall_563566
proc url_BalancesGetByBillingAccount_564190(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/balances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BalancesGetByBillingAccount_564189(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_564191 = path.getOrDefault("billingAccountId")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "billingAccountId", valid_564191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564192 = query.getOrDefault("api-version")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "api-version", valid_564192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564193: Call_BalancesGetByBillingAccount_564188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_BalancesGetByBillingAccount_564188;
          apiVersion: string; billingAccountId: string): Recallable =
  ## balancesGetByBillingAccount
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_564195 = newJObject()
  var query_564196 = newJObject()
  add(query_564196, "api-version", newJString(apiVersion))
  add(path_564195, "billingAccountId", newJString(billingAccountId))
  result = call_564194.call(path_564195, query_564196, nil, nil, nil)

var balancesGetByBillingAccount* = Call_BalancesGetByBillingAccount_564188(
    name: "balancesGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/balances",
    validator: validate_BalancesGetByBillingAccount_564189, base: "",
    url: url_BalancesGetByBillingAccount_564190, schemes: {Scheme.Https})
type
  Call_MarketplacesListByBillingAccount_564197 = ref object of OpenApiRestCall_563566
proc url_MarketplacesListByBillingAccount_564199(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesListByBillingAccount_564198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billingAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_564200 = path.getOrDefault("billingAccountId")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "billingAccountId", valid_564200
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_564201 = query.getOrDefault("$top")
  valid_564201 = validateParameter(valid_564201, JInt, required = false, default = nil)
  if valid_564201 != nil:
    section.add "$top", valid_564201
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  var valid_564203 = query.getOrDefault("$skiptoken")
  valid_564203 = validateParameter(valid_564203, JString, required = false,
                                 default = nil)
  if valid_564203 != nil:
    section.add "$skiptoken", valid_564203
  var valid_564204 = query.getOrDefault("$filter")
  valid_564204 = validateParameter(valid_564204, JString, required = false,
                                 default = nil)
  if valid_564204 != nil:
    section.add "$filter", valid_564204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564205: Call_MarketplacesListByBillingAccount_564197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billingAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_MarketplacesListByBillingAccount_564197;
          apiVersion: string; billingAccountId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListByBillingAccount
  ## Lists the marketplaces for a scope by billingAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  add(query_564208, "$top", newJInt(Top))
  add(query_564208, "api-version", newJString(apiVersion))
  add(query_564208, "$skiptoken", newJString(Skiptoken))
  add(query_564208, "$filter", newJString(Filter))
  add(path_564207, "billingAccountId", newJString(billingAccountId))
  result = call_564206.call(path_564207, query_564208, nil, nil, nil)

var marketplacesListByBillingAccount* = Call_MarketplacesListByBillingAccount_564197(
    name: "marketplacesListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByBillingAccount_564198, base: "",
    url: url_MarketplacesListByBillingAccount_564199, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByBillingAccount_564209 = ref object of OpenApiRestCall_563566
proc url_UsageDetailsListByBillingAccount_564211(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsListByBillingAccount_564210(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details by billingAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
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
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_564213 = query.getOrDefault("$top")
  valid_564213 = validateParameter(valid_564213, JInt, required = false, default = nil)
  if valid_564213 != nil:
    section.add "$top", valid_564213
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "api-version", valid_564214
  var valid_564215 = query.getOrDefault("$expand")
  valid_564215 = validateParameter(valid_564215, JString, required = false,
                                 default = nil)
  if valid_564215 != nil:
    section.add "$expand", valid_564215
  var valid_564216 = query.getOrDefault("$apply")
  valid_564216 = validateParameter(valid_564216, JString, required = false,
                                 default = nil)
  if valid_564216 != nil:
    section.add "$apply", valid_564216
  var valid_564217 = query.getOrDefault("$skiptoken")
  valid_564217 = validateParameter(valid_564217, JString, required = false,
                                 default = nil)
  if valid_564217 != nil:
    section.add "$skiptoken", valid_564217
  var valid_564218 = query.getOrDefault("$filter")
  valid_564218 = validateParameter(valid_564218, JString, required = false,
                                 default = nil)
  if valid_564218 != nil:
    section.add "$filter", valid_564218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564219: Call_UsageDetailsListByBillingAccount_564209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details by billingAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564219.validator(path, query, header, formData, body)
  let scheme = call_564219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564219.url(scheme.get, call_564219.host, call_564219.base,
                         call_564219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564219, url, valid)

proc call*(call_564220: Call_UsageDetailsListByBillingAccount_564209;
          apiVersion: string; billingAccountId: string; Top: int = 0;
          Expand: string = ""; Apply: string = ""; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListByBillingAccount
  ## Lists the usage details by billingAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564221 = newJObject()
  var query_564222 = newJObject()
  add(query_564222, "$top", newJInt(Top))
  add(query_564222, "api-version", newJString(apiVersion))
  add(query_564222, "$expand", newJString(Expand))
  add(query_564222, "$apply", newJString(Apply))
  add(query_564222, "$skiptoken", newJString(Skiptoken))
  add(path_564221, "billingAccountId", newJString(billingAccountId))
  add(query_564222, "$filter", newJString(Filter))
  result = call_564220.call(path_564221, query_564222, nil, nil, nil)

var usageDetailsListByBillingAccount* = Call_UsageDetailsListByBillingAccount_564209(
    name: "usageDetailsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByBillingAccount_564210, base: "",
    url: url_UsageDetailsListByBillingAccount_564211, schemes: {Scheme.Https})
type
  Call_MarketplacesListForBillingPeriodByDepartment_564223 = ref object of OpenApiRestCall_563566
proc url_MarketplacesListForBillingPeriodByDepartment_564225(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesListForBillingPeriodByDepartment_564224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billing period and departmentId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564226 = path.getOrDefault("departmentId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "departmentId", valid_564226
  var valid_564227 = path.getOrDefault("billingPeriodName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "billingPeriodName", valid_564227
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_564228 = query.getOrDefault("$top")
  valid_564228 = validateParameter(valid_564228, JInt, required = false, default = nil)
  if valid_564228 != nil:
    section.add "$top", valid_564228
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "api-version", valid_564229
  var valid_564230 = query.getOrDefault("$skiptoken")
  valid_564230 = validateParameter(valid_564230, JString, required = false,
                                 default = nil)
  if valid_564230 != nil:
    section.add "$skiptoken", valid_564230
  var valid_564231 = query.getOrDefault("$filter")
  valid_564231 = validateParameter(valid_564231, JString, required = false,
                                 default = nil)
  if valid_564231 != nil:
    section.add "$filter", valid_564231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564232: Call_MarketplacesListForBillingPeriodByDepartment_564223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and departmentId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564232.validator(path, query, header, formData, body)
  let scheme = call_564232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564232.url(scheme.get, call_564232.host, call_564232.base,
                         call_564232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564232, url, valid)

proc call*(call_564233: Call_MarketplacesListForBillingPeriodByDepartment_564223;
          apiVersion: string; departmentId: string; billingPeriodName: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListForBillingPeriodByDepartment
  ## Lists the marketplaces for a scope by billing period and departmentId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_564234 = newJObject()
  var query_564235 = newJObject()
  add(query_564235, "$top", newJInt(Top))
  add(query_564235, "api-version", newJString(apiVersion))
  add(path_564234, "departmentId", newJString(departmentId))
  add(query_564235, "$skiptoken", newJString(Skiptoken))
  add(path_564234, "billingPeriodName", newJString(billingPeriodName))
  add(query_564235, "$filter", newJString(Filter))
  result = call_564233.call(path_564234, query_564235, nil, nil, nil)

var marketplacesListForBillingPeriodByDepartment* = Call_MarketplacesListForBillingPeriodByDepartment_564223(
    name: "marketplacesListForBillingPeriodByDepartment",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListForBillingPeriodByDepartment_564224,
    base: "", url: url_MarketplacesListForBillingPeriodByDepartment_564225,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsListForBillingPeriodByDepartment_564236 = ref object of OpenApiRestCall_563566
proc url_UsageDetailsListForBillingPeriodByDepartment_564238(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "departmentId" in path, "`departmentId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/departments/"),
               (kind: VariableSegment, value: "departmentId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsListForBillingPeriodByDepartment_564237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details based on departmentId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564239 = path.getOrDefault("departmentId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "departmentId", valid_564239
  var valid_564240 = path.getOrDefault("billingPeriodName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "billingPeriodName", valid_564240
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_564241 = query.getOrDefault("$top")
  valid_564241 = validateParameter(valid_564241, JInt, required = false, default = nil)
  if valid_564241 != nil:
    section.add "$top", valid_564241
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564242 = query.getOrDefault("api-version")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "api-version", valid_564242
  var valid_564243 = query.getOrDefault("$expand")
  valid_564243 = validateParameter(valid_564243, JString, required = false,
                                 default = nil)
  if valid_564243 != nil:
    section.add "$expand", valid_564243
  var valid_564244 = query.getOrDefault("$apply")
  valid_564244 = validateParameter(valid_564244, JString, required = false,
                                 default = nil)
  if valid_564244 != nil:
    section.add "$apply", valid_564244
  var valid_564245 = query.getOrDefault("$skiptoken")
  valid_564245 = validateParameter(valid_564245, JString, required = false,
                                 default = nil)
  if valid_564245 != nil:
    section.add "$skiptoken", valid_564245
  var valid_564246 = query.getOrDefault("$filter")
  valid_564246 = validateParameter(valid_564246, JString, required = false,
                                 default = nil)
  if valid_564246 != nil:
    section.add "$filter", valid_564246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564247: Call_UsageDetailsListForBillingPeriodByDepartment_564236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details based on departmentId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564247.validator(path, query, header, formData, body)
  let scheme = call_564247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564247.url(scheme.get, call_564247.host, call_564247.base,
                         call_564247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564247, url, valid)

proc call*(call_564248: Call_UsageDetailsListForBillingPeriodByDepartment_564236;
          apiVersion: string; departmentId: string; billingPeriodName: string;
          Top: int = 0; Expand: string = ""; Apply: string = ""; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListForBillingPeriodByDepartment
  ## Lists the usage details based on departmentId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564249 = newJObject()
  var query_564250 = newJObject()
  add(query_564250, "$top", newJInt(Top))
  add(query_564250, "api-version", newJString(apiVersion))
  add(query_564250, "$expand", newJString(Expand))
  add(path_564249, "departmentId", newJString(departmentId))
  add(query_564250, "$apply", newJString(Apply))
  add(query_564250, "$skiptoken", newJString(Skiptoken))
  add(path_564249, "billingPeriodName", newJString(billingPeriodName))
  add(query_564250, "$filter", newJString(Filter))
  result = call_564248.call(path_564249, query_564250, nil, nil, nil)

var usageDetailsListForBillingPeriodByDepartment* = Call_UsageDetailsListForBillingPeriodByDepartment_564236(
    name: "usageDetailsListForBillingPeriodByDepartment",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListForBillingPeriodByDepartment_564237,
    base: "", url: url_UsageDetailsListForBillingPeriodByDepartment_564238,
    schemes: {Scheme.Https})
type
  Call_MarketplacesListByDepartment_564251 = ref object of OpenApiRestCall_563566
proc url_MarketplacesListByDepartment_564253(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesListByDepartment_564252(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by departmentId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564254 = path.getOrDefault("departmentId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "departmentId", valid_564254
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_564255 = query.getOrDefault("$top")
  valid_564255 = validateParameter(valid_564255, JInt, required = false, default = nil)
  if valid_564255 != nil:
    section.add "$top", valid_564255
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564256 = query.getOrDefault("api-version")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "api-version", valid_564256
  var valid_564257 = query.getOrDefault("$skiptoken")
  valid_564257 = validateParameter(valid_564257, JString, required = false,
                                 default = nil)
  if valid_564257 != nil:
    section.add "$skiptoken", valid_564257
  var valid_564258 = query.getOrDefault("$filter")
  valid_564258 = validateParameter(valid_564258, JString, required = false,
                                 default = nil)
  if valid_564258 != nil:
    section.add "$filter", valid_564258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564259: Call_MarketplacesListByDepartment_564251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by departmentId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564259.validator(path, query, header, formData, body)
  let scheme = call_564259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564259.url(scheme.get, call_564259.host, call_564259.base,
                         call_564259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564259, url, valid)

proc call*(call_564260: Call_MarketplacesListByDepartment_564251;
          apiVersion: string; departmentId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListByDepartment
  ## Lists the marketplaces for a scope by departmentId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_564261 = newJObject()
  var query_564262 = newJObject()
  add(query_564262, "$top", newJInt(Top))
  add(query_564262, "api-version", newJString(apiVersion))
  add(path_564261, "departmentId", newJString(departmentId))
  add(query_564262, "$skiptoken", newJString(Skiptoken))
  add(query_564262, "$filter", newJString(Filter))
  result = call_564260.call(path_564261, query_564262, nil, nil, nil)

var marketplacesListByDepartment* = Call_MarketplacesListByDepartment_564251(
    name: "marketplacesListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByDepartment_564252, base: "",
    url: url_MarketplacesListByDepartment_564253, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByDepartment_564263 = ref object of OpenApiRestCall_563566
proc url_UsageDetailsListByDepartment_564265(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsListByDepartment_564264(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details by departmentId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `departmentId` field"
  var valid_564266 = path.getOrDefault("departmentId")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "departmentId", valid_564266
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_564267 = query.getOrDefault("$top")
  valid_564267 = validateParameter(valid_564267, JInt, required = false, default = nil)
  if valid_564267 != nil:
    section.add "$top", valid_564267
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564268 = query.getOrDefault("api-version")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "api-version", valid_564268
  var valid_564269 = query.getOrDefault("$expand")
  valid_564269 = validateParameter(valid_564269, JString, required = false,
                                 default = nil)
  if valid_564269 != nil:
    section.add "$expand", valid_564269
  var valid_564270 = query.getOrDefault("$apply")
  valid_564270 = validateParameter(valid_564270, JString, required = false,
                                 default = nil)
  if valid_564270 != nil:
    section.add "$apply", valid_564270
  var valid_564271 = query.getOrDefault("$skiptoken")
  valid_564271 = validateParameter(valid_564271, JString, required = false,
                                 default = nil)
  if valid_564271 != nil:
    section.add "$skiptoken", valid_564271
  var valid_564272 = query.getOrDefault("$filter")
  valid_564272 = validateParameter(valid_564272, JString, required = false,
                                 default = nil)
  if valid_564272 != nil:
    section.add "$filter", valid_564272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564273: Call_UsageDetailsListByDepartment_564263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details by departmentId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564273.validator(path, query, header, formData, body)
  let scheme = call_564273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564273.url(scheme.get, call_564273.host, call_564273.base,
                         call_564273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564273, url, valid)

proc call*(call_564274: Call_UsageDetailsListByDepartment_564263;
          apiVersion: string; departmentId: string; Top: int = 0; Expand: string = "";
          Apply: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsListByDepartment
  ## Lists the usage details by departmentId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564275 = newJObject()
  var query_564276 = newJObject()
  add(query_564276, "$top", newJInt(Top))
  add(query_564276, "api-version", newJString(apiVersion))
  add(query_564276, "$expand", newJString(Expand))
  add(path_564275, "departmentId", newJString(departmentId))
  add(query_564276, "$apply", newJString(Apply))
  add(query_564276, "$skiptoken", newJString(Skiptoken))
  add(query_564276, "$filter", newJString(Filter))
  result = call_564274.call(path_564275, query_564276, nil, nil, nil)

var usageDetailsListByDepartment* = Call_UsageDetailsListByDepartment_564263(
    name: "usageDetailsListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByDepartment_564264, base: "",
    url: url_UsageDetailsListByDepartment_564265, schemes: {Scheme.Https})
type
  Call_MarketplacesListForBillingPeriodByEnrollmentAccount_564277 = ref object of OpenApiRestCall_563566
proc url_MarketplacesListForBillingPeriodByEnrollmentAccount_564279(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesListForBillingPeriodByEnrollmentAccount_564278(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billing period and enrollmentAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_564280 = path.getOrDefault("enrollmentAccountId")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "enrollmentAccountId", valid_564280
  var valid_564281 = path.getOrDefault("billingPeriodName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "billingPeriodName", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_564282 = query.getOrDefault("$top")
  valid_564282 = validateParameter(valid_564282, JInt, required = false, default = nil)
  if valid_564282 != nil:
    section.add "$top", valid_564282
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564283 = query.getOrDefault("api-version")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "api-version", valid_564283
  var valid_564284 = query.getOrDefault("$skiptoken")
  valid_564284 = validateParameter(valid_564284, JString, required = false,
                                 default = nil)
  if valid_564284 != nil:
    section.add "$skiptoken", valid_564284
  var valid_564285 = query.getOrDefault("$filter")
  valid_564285 = validateParameter(valid_564285, JString, required = false,
                                 default = nil)
  if valid_564285 != nil:
    section.add "$filter", valid_564285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564286: Call_MarketplacesListForBillingPeriodByEnrollmentAccount_564277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and enrollmentAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564286.validator(path, query, header, formData, body)
  let scheme = call_564286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564286.url(scheme.get, call_564286.host, call_564286.base,
                         call_564286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564286, url, valid)

proc call*(call_564287: Call_MarketplacesListForBillingPeriodByEnrollmentAccount_564277;
          apiVersion: string; enrollmentAccountId: string;
          billingPeriodName: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## marketplacesListForBillingPeriodByEnrollmentAccount
  ## Lists the marketplaces for a scope by billing period and enrollmentAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_564288 = newJObject()
  var query_564289 = newJObject()
  add(query_564289, "$top", newJInt(Top))
  add(query_564289, "api-version", newJString(apiVersion))
  add(query_564289, "$skiptoken", newJString(Skiptoken))
  add(path_564288, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_564288, "billingPeriodName", newJString(billingPeriodName))
  add(query_564289, "$filter", newJString(Filter))
  result = call_564287.call(path_564288, query_564289, nil, nil, nil)

var marketplacesListForBillingPeriodByEnrollmentAccount* = Call_MarketplacesListForBillingPeriodByEnrollmentAccount_564277(
    name: "marketplacesListForBillingPeriodByEnrollmentAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListForBillingPeriodByEnrollmentAccount_564278,
    base: "", url: url_MarketplacesListForBillingPeriodByEnrollmentAccount_564279,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsListForBillingPeriodByEnrollmentAccount_564290 = ref object of OpenApiRestCall_563566
proc url_UsageDetailsListForBillingPeriodByEnrollmentAccount_564292(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsListForBillingPeriodByEnrollmentAccount_564291(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the usage details based on enrollmentAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_564293 = path.getOrDefault("enrollmentAccountId")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "enrollmentAccountId", valid_564293
  var valid_564294 = path.getOrDefault("billingPeriodName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "billingPeriodName", valid_564294
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_564295 = query.getOrDefault("$top")
  valid_564295 = validateParameter(valid_564295, JInt, required = false, default = nil)
  if valid_564295 != nil:
    section.add "$top", valid_564295
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564296 = query.getOrDefault("api-version")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "api-version", valid_564296
  var valid_564297 = query.getOrDefault("$expand")
  valid_564297 = validateParameter(valid_564297, JString, required = false,
                                 default = nil)
  if valid_564297 != nil:
    section.add "$expand", valid_564297
  var valid_564298 = query.getOrDefault("$apply")
  valid_564298 = validateParameter(valid_564298, JString, required = false,
                                 default = nil)
  if valid_564298 != nil:
    section.add "$apply", valid_564298
  var valid_564299 = query.getOrDefault("$skiptoken")
  valid_564299 = validateParameter(valid_564299, JString, required = false,
                                 default = nil)
  if valid_564299 != nil:
    section.add "$skiptoken", valid_564299
  var valid_564300 = query.getOrDefault("$filter")
  valid_564300 = validateParameter(valid_564300, JString, required = false,
                                 default = nil)
  if valid_564300 != nil:
    section.add "$filter", valid_564300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564301: Call_UsageDetailsListForBillingPeriodByEnrollmentAccount_564290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details based on enrollmentAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_UsageDetailsListForBillingPeriodByEnrollmentAccount_564290;
          apiVersion: string; enrollmentAccountId: string;
          billingPeriodName: string; Top: int = 0; Expand: string = "";
          Apply: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsListForBillingPeriodByEnrollmentAccount
  ## Lists the usage details based on enrollmentAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  add(query_564304, "$top", newJInt(Top))
  add(query_564304, "api-version", newJString(apiVersion))
  add(query_564304, "$expand", newJString(Expand))
  add(query_564304, "$apply", newJString(Apply))
  add(query_564304, "$skiptoken", newJString(Skiptoken))
  add(path_564303, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_564303, "billingPeriodName", newJString(billingPeriodName))
  add(query_564304, "$filter", newJString(Filter))
  result = call_564302.call(path_564303, query_564304, nil, nil, nil)

var usageDetailsListForBillingPeriodByEnrollmentAccount* = Call_UsageDetailsListForBillingPeriodByEnrollmentAccount_564290(
    name: "usageDetailsListForBillingPeriodByEnrollmentAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListForBillingPeriodByEnrollmentAccount_564291,
    base: "", url: url_UsageDetailsListForBillingPeriodByEnrollmentAccount_564292,
    schemes: {Scheme.Https})
type
  Call_MarketplacesListByEnrollmentAccount_564305 = ref object of OpenApiRestCall_563566
proc url_MarketplacesListByEnrollmentAccount_564307(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesListByEnrollmentAccount_564306(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by enrollmentAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : EnrollmentAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_564308 = path.getOrDefault("enrollmentAccountId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "enrollmentAccountId", valid_564308
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_564309 = query.getOrDefault("$top")
  valid_564309 = validateParameter(valid_564309, JInt, required = false, default = nil)
  if valid_564309 != nil:
    section.add "$top", valid_564309
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564310 = query.getOrDefault("api-version")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "api-version", valid_564310
  var valid_564311 = query.getOrDefault("$skiptoken")
  valid_564311 = validateParameter(valid_564311, JString, required = false,
                                 default = nil)
  if valid_564311 != nil:
    section.add "$skiptoken", valid_564311
  var valid_564312 = query.getOrDefault("$filter")
  valid_564312 = validateParameter(valid_564312, JString, required = false,
                                 default = nil)
  if valid_564312 != nil:
    section.add "$filter", valid_564312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564313: Call_MarketplacesListByEnrollmentAccount_564305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by enrollmentAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564313.validator(path, query, header, formData, body)
  let scheme = call_564313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564313.url(scheme.get, call_564313.host, call_564313.base,
                         call_564313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564313, url, valid)

proc call*(call_564314: Call_MarketplacesListByEnrollmentAccount_564305;
          apiVersion: string; enrollmentAccountId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListByEnrollmentAccount
  ## Lists the marketplaces for a scope by enrollmentAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_564315 = newJObject()
  var query_564316 = newJObject()
  add(query_564316, "$top", newJInt(Top))
  add(query_564316, "api-version", newJString(apiVersion))
  add(query_564316, "$skiptoken", newJString(Skiptoken))
  add(path_564315, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(query_564316, "$filter", newJString(Filter))
  result = call_564314.call(path_564315, query_564316, nil, nil, nil)

var marketplacesListByEnrollmentAccount* = Call_MarketplacesListByEnrollmentAccount_564305(
    name: "marketplacesListByEnrollmentAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByEnrollmentAccount_564306, base: "",
    url: url_MarketplacesListByEnrollmentAccount_564307, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByEnrollmentAccount_564317 = ref object of OpenApiRestCall_563566
proc url_UsageDetailsListByEnrollmentAccount_564319(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enrollmentAccountId" in path,
        "`enrollmentAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsListByEnrollmentAccount_564318(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details by enrollmentAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountId: JString (required)
  ##                      : EnrollmentAccount ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountId` field"
  var valid_564320 = path.getOrDefault("enrollmentAccountId")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "enrollmentAccountId", valid_564320
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_564321 = query.getOrDefault("$top")
  valid_564321 = validateParameter(valid_564321, JInt, required = false, default = nil)
  if valid_564321 != nil:
    section.add "$top", valid_564321
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564322 = query.getOrDefault("api-version")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "api-version", valid_564322
  var valid_564323 = query.getOrDefault("$expand")
  valid_564323 = validateParameter(valid_564323, JString, required = false,
                                 default = nil)
  if valid_564323 != nil:
    section.add "$expand", valid_564323
  var valid_564324 = query.getOrDefault("$apply")
  valid_564324 = validateParameter(valid_564324, JString, required = false,
                                 default = nil)
  if valid_564324 != nil:
    section.add "$apply", valid_564324
  var valid_564325 = query.getOrDefault("$skiptoken")
  valid_564325 = validateParameter(valid_564325, JString, required = false,
                                 default = nil)
  if valid_564325 != nil:
    section.add "$skiptoken", valid_564325
  var valid_564326 = query.getOrDefault("$filter")
  valid_564326 = validateParameter(valid_564326, JString, required = false,
                                 default = nil)
  if valid_564326 != nil:
    section.add "$filter", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_UsageDetailsListByEnrollmentAccount_564317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details by enrollmentAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_UsageDetailsListByEnrollmentAccount_564317;
          apiVersion: string; enrollmentAccountId: string; Top: int = 0;
          Expand: string = ""; Apply: string = ""; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListByEnrollmentAccount
  ## Lists the usage details by enrollmentAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  add(query_564330, "$top", newJInt(Top))
  add(query_564330, "api-version", newJString(apiVersion))
  add(query_564330, "$expand", newJString(Expand))
  add(query_564330, "$apply", newJString(Apply))
  add(query_564330, "$skiptoken", newJString(Skiptoken))
  add(path_564329, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(query_564330, "$filter", newJString(Filter))
  result = call_564328.call(path_564329, query_564330, nil, nil, nil)

var usageDetailsListByEnrollmentAccount* = Call_UsageDetailsListByEnrollmentAccount_564317(
    name: "usageDetailsListByEnrollmentAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByEnrollmentAccount_564318, base: "",
    url: url_UsageDetailsListByEnrollmentAccount_564319, schemes: {Scheme.Https})
type
  Call_ReservationsDetailsListByReservationOrder_564331 = ref object of OpenApiRestCall_563566
proc url_ReservationsDetailsListByReservationOrder_564333(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsDetailsListByReservationOrder_564332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_564334 = path.getOrDefault("reservationOrderId")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "reservationOrderId", valid_564334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564335 = query.getOrDefault("api-version")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "api-version", valid_564335
  var valid_564336 = query.getOrDefault("$filter")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "$filter", valid_564336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564337: Call_ReservationsDetailsListByReservationOrder_564331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564337.validator(path, query, header, formData, body)
  let scheme = call_564337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564337.url(scheme.get, call_564337.host, call_564337.base,
                         call_564337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564337, url, valid)

proc call*(call_564338: Call_ReservationsDetailsListByReservationOrder_564331;
          apiVersion: string; reservationOrderId: string; Filter: string): Recallable =
  ## reservationsDetailsListByReservationOrder
  ## Lists the reservations details for provided date range.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string (required)
  ##         : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  var path_564339 = newJObject()
  var query_564340 = newJObject()
  add(query_564340, "api-version", newJString(apiVersion))
  add(path_564339, "reservationOrderId", newJString(reservationOrderId))
  add(query_564340, "$filter", newJString(Filter))
  result = call_564338.call(path_564339, query_564340, nil, nil, nil)

var reservationsDetailsListByReservationOrder* = Call_ReservationsDetailsListByReservationOrder_564331(
    name: "reservationsDetailsListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationDetails",
    validator: validate_ReservationsDetailsListByReservationOrder_564332,
    base: "", url: url_ReservationsDetailsListByReservationOrder_564333,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrder_564341 = ref object of OpenApiRestCall_563566
proc url_ReservationsSummariesListByReservationOrder_564343(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationSummaries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsSummariesListByReservationOrder_564342(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_564344 = path.getOrDefault("reservationOrderId")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "reservationOrderId", valid_564344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $filter: JString
  ##          : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: JString (required)
  ##        : Can be daily or monthly
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564345 = query.getOrDefault("api-version")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "api-version", valid_564345
  var valid_564346 = query.getOrDefault("$filter")
  valid_564346 = validateParameter(valid_564346, JString, required = false,
                                 default = nil)
  if valid_564346 != nil:
    section.add "$filter", valid_564346
  var valid_564360 = query.getOrDefault("grain")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = newJString("daily"))
  if valid_564360 != nil:
    section.add "grain", valid_564360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564361: Call_ReservationsSummariesListByReservationOrder_564341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564361.validator(path, query, header, formData, body)
  let scheme = call_564361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564361.url(scheme.get, call_564361.host, call_564361.base,
                         call_564361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564361, url, valid)

proc call*(call_564362: Call_ReservationsSummariesListByReservationOrder_564341;
          apiVersion: string; reservationOrderId: string; Filter: string = "";
          grain: string = "daily"): Recallable =
  ## reservationsSummariesListByReservationOrder
  ## Lists the reservations summaries for daily or monthly grain.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string
  ##         : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: string (required)
  ##        : Can be daily or monthly
  var path_564363 = newJObject()
  var query_564364 = newJObject()
  add(query_564364, "api-version", newJString(apiVersion))
  add(path_564363, "reservationOrderId", newJString(reservationOrderId))
  add(query_564364, "$filter", newJString(Filter))
  add(query_564364, "grain", newJString(grain))
  result = call_564362.call(path_564363, query_564364, nil, nil, nil)

var reservationsSummariesListByReservationOrder* = Call_ReservationsSummariesListByReservationOrder_564341(
    name: "reservationsSummariesListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationSummaries",
    validator: validate_ReservationsSummariesListByReservationOrder_564342,
    base: "", url: url_ReservationsSummariesListByReservationOrder_564343,
    schemes: {Scheme.Https})
type
  Call_ReservationsDetailsListByReservationOrderAndReservation_564365 = ref object of OpenApiRestCall_563566
proc url_ReservationsDetailsListByReservationOrderAndReservation_564367(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  assert "reservationId" in path, "`reservationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/reservations/"),
               (kind: VariableSegment, value: "reservationId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsDetailsListByReservationOrderAndReservation_564366(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  ##   reservationId: JString (required)
  ##                : Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_564368 = path.getOrDefault("reservationOrderId")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "reservationOrderId", valid_564368
  var valid_564369 = path.getOrDefault("reservationId")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "reservationId", valid_564369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564370 = query.getOrDefault("api-version")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "api-version", valid_564370
  var valid_564371 = query.getOrDefault("$filter")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "$filter", valid_564371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564372: Call_ReservationsDetailsListByReservationOrderAndReservation_564365;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564372.validator(path, query, header, formData, body)
  let scheme = call_564372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564372.url(scheme.get, call_564372.host, call_564372.base,
                         call_564372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564372, url, valid)

proc call*(call_564373: Call_ReservationsDetailsListByReservationOrderAndReservation_564365;
          apiVersion: string; reservationOrderId: string; Filter: string;
          reservationId: string): Recallable =
  ## reservationsDetailsListByReservationOrderAndReservation
  ## Lists the reservations details for provided date range.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string (required)
  ##         : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  ##   reservationId: string (required)
  ##                : Id of the reservation
  var path_564374 = newJObject()
  var query_564375 = newJObject()
  add(query_564375, "api-version", newJString(apiVersion))
  add(path_564374, "reservationOrderId", newJString(reservationOrderId))
  add(query_564375, "$filter", newJString(Filter))
  add(path_564374, "reservationId", newJString(reservationId))
  result = call_564373.call(path_564374, query_564375, nil, nil, nil)

var reservationsDetailsListByReservationOrderAndReservation* = Call_ReservationsDetailsListByReservationOrderAndReservation_564365(
    name: "reservationsDetailsListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationDetails", validator: validate_ReservationsDetailsListByReservationOrderAndReservation_564366,
    base: "", url: url_ReservationsDetailsListByReservationOrderAndReservation_564367,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrderAndReservation_564376 = ref object of OpenApiRestCall_563566
proc url_ReservationsSummariesListByReservationOrderAndReservation_564378(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reservationOrderId" in path,
        "`reservationOrderId` is a required path parameter"
  assert "reservationId" in path, "`reservationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Capacity/reservationorders/"),
               (kind: VariableSegment, value: "reservationOrderId"),
               (kind: ConstantSegment, value: "/reservations/"),
               (kind: VariableSegment, value: "reservationId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/reservationSummaries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationsSummariesListByReservationOrderAndReservation_564377(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reservationOrderId: JString (required)
  ##                     : Order Id of the reservation
  ##   reservationId: JString (required)
  ##                : Id of the reservation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reservationOrderId` field"
  var valid_564379 = path.getOrDefault("reservationOrderId")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "reservationOrderId", valid_564379
  var valid_564380 = path.getOrDefault("reservationId")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "reservationId", valid_564380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $filter: JString
  ##          : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: JString (required)
  ##        : Can be daily or monthly
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564381 = query.getOrDefault("api-version")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "api-version", valid_564381
  var valid_564382 = query.getOrDefault("$filter")
  valid_564382 = validateParameter(valid_564382, JString, required = false,
                                 default = nil)
  if valid_564382 != nil:
    section.add "$filter", valid_564382
  var valid_564383 = query.getOrDefault("grain")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = newJString("daily"))
  if valid_564383 != nil:
    section.add "grain", valid_564383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564384: Call_ReservationsSummariesListByReservationOrderAndReservation_564376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564384.validator(path, query, header, formData, body)
  let scheme = call_564384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564384.url(scheme.get, call_564384.host, call_564384.base,
                         call_564384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564384, url, valid)

proc call*(call_564385: Call_ReservationsSummariesListByReservationOrderAndReservation_564376;
          apiVersion: string; reservationOrderId: string; reservationId: string;
          Filter: string = ""; grain: string = "daily"): Recallable =
  ## reservationsSummariesListByReservationOrderAndReservation
  ## Lists the reservations summaries for daily or monthly grain.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string
  ##         : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: string (required)
  ##        : Can be daily or monthly
  ##   reservationId: string (required)
  ##                : Id of the reservation
  var path_564386 = newJObject()
  var query_564387 = newJObject()
  add(query_564387, "api-version", newJString(apiVersion))
  add(path_564386, "reservationOrderId", newJString(reservationOrderId))
  add(query_564387, "$filter", newJString(Filter))
  add(query_564387, "grain", newJString(grain))
  add(path_564386, "reservationId", newJString(reservationId))
  result = call_564385.call(path_564386, query_564387, nil, nil, nil)

var reservationsSummariesListByReservationOrderAndReservation* = Call_ReservationsSummariesListByReservationOrderAndReservation_564376(
    name: "reservationsSummariesListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationSummaries", validator: validate_ReservationsSummariesListByReservationOrderAndReservation_564377,
    base: "", url: url_ReservationsSummariesListByReservationOrderAndReservation_564378,
    schemes: {Scheme.Https})
type
  Call_OperationsList_564388 = ref object of OpenApiRestCall_563566
proc url_OperationsList_564390(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564389(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564391 = query.getOrDefault("api-version")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "api-version", valid_564391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564392: Call_OperationsList_564388; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_564392.validator(path, query, header, formData, body)
  let scheme = call_564392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564392.url(scheme.get, call_564392.host, call_564392.base,
                         call_564392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564392, url, valid)

proc call*(call_564393: Call_OperationsList_564388; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  var query_564394 = newJObject()
  add(query_564394, "api-version", newJString(apiVersion))
  result = call_564393.call(nil, query_564394, nil, nil, nil)

var operationsList* = Call_OperationsList_564388(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Consumption/operations",
    validator: validate_OperationsList_564389, base: "", url: url_OperationsList_564390,
    schemes: {Scheme.Https})
type
  Call_TagsGet_564395 = ref object of OpenApiRestCall_563566
proc url_TagsGet_564397(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.CostManagement/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsGet_564396(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all available tag keys for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_564398 = path.getOrDefault("billingAccountId")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "billingAccountId", valid_564398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
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
  if body != nil:
    result.add "body", body

proc call*(call_564400: Call_TagsGet_564395; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all available tag keys for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564400.validator(path, query, header, formData, body)
  let scheme = call_564400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564400.url(scheme.get, call_564400.host, call_564400.base,
                         call_564400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564400, url, valid)

proc call*(call_564401: Call_TagsGet_564395; apiVersion: string;
          billingAccountId: string): Recallable =
  ## tagsGet
  ## Get all available tag keys for a billing account.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_564402 = newJObject()
  var query_564403 = newJObject()
  add(query_564403, "api-version", newJString(apiVersion))
  add(path_564402, "billingAccountId", newJString(billingAccountId))
  result = call_564401.call(path_564402, query_564403, nil, nil, nil)

var tagsGet* = Call_TagsGet_564395(name: "tagsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/providers/Microsoft.CostManagement/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/tags",
                                validator: validate_TagsGet_564396, base: "",
                                url: url_TagsGet_564397, schemes: {Scheme.Https})
type
  Call_AggregatedCostGetForBillingPeriodByManagementGroup_564404 = ref object of OpenApiRestCall_563566
proc url_AggregatedCostGetForBillingPeriodByManagementGroup_564406(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment, value: "/Microsoft.Consumption/aggregatedcost")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AggregatedCostGetForBillingPeriodByManagementGroup_564405(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Provides the aggregate cost of a management group and all child management groups by specified billing period
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Azure Management Group ID.
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564407 = path.getOrDefault("managementGroupId")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "managementGroupId", valid_564407
  var valid_564408 = path.getOrDefault("billingPeriodName")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "billingPeriodName", valid_564408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564409 = query.getOrDefault("api-version")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "api-version", valid_564409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564410: Call_AggregatedCostGetForBillingPeriodByManagementGroup_564404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the aggregate cost of a management group and all child management groups by specified billing period
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564410.validator(path, query, header, formData, body)
  let scheme = call_564410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564410.url(scheme.get, call_564410.host, call_564410.base,
                         call_564410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564410, url, valid)

proc call*(call_564411: Call_AggregatedCostGetForBillingPeriodByManagementGroup_564404;
          managementGroupId: string; apiVersion: string; billingPeriodName: string): Recallable =
  ## aggregatedCostGetForBillingPeriodByManagementGroup
  ## Provides the aggregate cost of a management group and all child management groups by specified billing period
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  var path_564412 = newJObject()
  var query_564413 = newJObject()
  add(path_564412, "managementGroupId", newJString(managementGroupId))
  add(query_564413, "api-version", newJString(apiVersion))
  add(path_564412, "billingPeriodName", newJString(billingPeriodName))
  result = call_564411.call(path_564412, query_564413, nil, nil, nil)

var aggregatedCostGetForBillingPeriodByManagementGroup* = Call_AggregatedCostGetForBillingPeriodByManagementGroup_564404(
    name: "aggregatedCostGetForBillingPeriodByManagementGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/Microsoft.Consumption/aggregatedcost",
    validator: validate_AggregatedCostGetForBillingPeriodByManagementGroup_564405,
    base: "", url: url_AggregatedCostGetForBillingPeriodByManagementGroup_564406,
    schemes: {Scheme.Https})
type
  Call_MarketplacesListForBillingPeriodByManagementGroup_564414 = ref object of OpenApiRestCall_563566
proc url_MarketplacesListForBillingPeriodByManagementGroup_564416(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesListForBillingPeriodByManagementGroup_564415(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the marketplace records for all subscriptions belonging to a management group scope by specified billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Azure Management Group ID.
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564417 = path.getOrDefault("managementGroupId")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "managementGroupId", valid_564417
  var valid_564418 = path.getOrDefault("billingPeriodName")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "billingPeriodName", valid_564418
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_564419 = query.getOrDefault("$top")
  valid_564419 = validateParameter(valid_564419, JInt, required = false, default = nil)
  if valid_564419 != nil:
    section.add "$top", valid_564419
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564420 = query.getOrDefault("api-version")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "api-version", valid_564420
  var valid_564421 = query.getOrDefault("$skiptoken")
  valid_564421 = validateParameter(valid_564421, JString, required = false,
                                 default = nil)
  if valid_564421 != nil:
    section.add "$skiptoken", valid_564421
  var valid_564422 = query.getOrDefault("$filter")
  valid_564422 = validateParameter(valid_564422, JString, required = false,
                                 default = nil)
  if valid_564422 != nil:
    section.add "$filter", valid_564422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564423: Call_MarketplacesListForBillingPeriodByManagementGroup_564414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplace records for all subscriptions belonging to a management group scope by specified billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564423.validator(path, query, header, formData, body)
  let scheme = call_564423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564423.url(scheme.get, call_564423.host, call_564423.base,
                         call_564423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564423, url, valid)

proc call*(call_564424: Call_MarketplacesListForBillingPeriodByManagementGroup_564414;
          managementGroupId: string; apiVersion: string; billingPeriodName: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListForBillingPeriodByManagementGroup
  ## Lists the marketplace records for all subscriptions belonging to a management group scope by specified billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_564425 = newJObject()
  var query_564426 = newJObject()
  add(path_564425, "managementGroupId", newJString(managementGroupId))
  add(query_564426, "$top", newJInt(Top))
  add(query_564426, "api-version", newJString(apiVersion))
  add(query_564426, "$skiptoken", newJString(Skiptoken))
  add(path_564425, "billingPeriodName", newJString(billingPeriodName))
  add(query_564426, "$filter", newJString(Filter))
  result = call_564424.call(path_564425, query_564426, nil, nil, nil)

var marketplacesListForBillingPeriodByManagementGroup* = Call_MarketplacesListForBillingPeriodByManagementGroup_564414(
    name: "marketplacesListForBillingPeriodByManagementGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListForBillingPeriodByManagementGroup_564415,
    base: "", url: url_MarketplacesListForBillingPeriodByManagementGroup_564416,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsListForBillingPeriodByManagementGroup_564427 = ref object of OpenApiRestCall_563566
proc url_UsageDetailsListForBillingPeriodByManagementGroup_564429(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "billingPeriodName" in path,
        "`billingPeriodName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPeriods/"),
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsListForBillingPeriodByManagementGroup_564428(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the usage detail records for all subscriptions belonging to a management group scope by specified billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Azure Management Group ID.
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564430 = path.getOrDefault("managementGroupId")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "managementGroupId", valid_564430
  var valid_564431 = path.getOrDefault("billingPeriodName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "billingPeriodName", valid_564431
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_564432 = query.getOrDefault("$top")
  valid_564432 = validateParameter(valid_564432, JInt, required = false, default = nil)
  if valid_564432 != nil:
    section.add "$top", valid_564432
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564433 = query.getOrDefault("api-version")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "api-version", valid_564433
  var valid_564434 = query.getOrDefault("$expand")
  valid_564434 = validateParameter(valid_564434, JString, required = false,
                                 default = nil)
  if valid_564434 != nil:
    section.add "$expand", valid_564434
  var valid_564435 = query.getOrDefault("$apply")
  valid_564435 = validateParameter(valid_564435, JString, required = false,
                                 default = nil)
  if valid_564435 != nil:
    section.add "$apply", valid_564435
  var valid_564436 = query.getOrDefault("$skiptoken")
  valid_564436 = validateParameter(valid_564436, JString, required = false,
                                 default = nil)
  if valid_564436 != nil:
    section.add "$skiptoken", valid_564436
  var valid_564437 = query.getOrDefault("$filter")
  valid_564437 = validateParameter(valid_564437, JString, required = false,
                                 default = nil)
  if valid_564437 != nil:
    section.add "$filter", valid_564437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564438: Call_UsageDetailsListForBillingPeriodByManagementGroup_564427;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage detail records for all subscriptions belonging to a management group scope by specified billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564438.validator(path, query, header, formData, body)
  let scheme = call_564438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564438.url(scheme.get, call_564438.host, call_564438.base,
                         call_564438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564438, url, valid)

proc call*(call_564439: Call_UsageDetailsListForBillingPeriodByManagementGroup_564427;
          managementGroupId: string; apiVersion: string; billingPeriodName: string;
          Top: int = 0; Expand: string = ""; Apply: string = ""; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListForBillingPeriodByManagementGroup
  ## Lists the usage detail records for all subscriptions belonging to a management group scope by specified billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564440 = newJObject()
  var query_564441 = newJObject()
  add(path_564440, "managementGroupId", newJString(managementGroupId))
  add(query_564441, "$top", newJInt(Top))
  add(query_564441, "api-version", newJString(apiVersion))
  add(query_564441, "$expand", newJString(Expand))
  add(query_564441, "$apply", newJString(Apply))
  add(query_564441, "$skiptoken", newJString(Skiptoken))
  add(path_564440, "billingPeriodName", newJString(billingPeriodName))
  add(query_564441, "$filter", newJString(Filter))
  result = call_564439.call(path_564440, query_564441, nil, nil, nil)

var usageDetailsListForBillingPeriodByManagementGroup* = Call_UsageDetailsListForBillingPeriodByManagementGroup_564427(
    name: "usageDetailsListForBillingPeriodByManagementGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListForBillingPeriodByManagementGroup_564428,
    base: "", url: url_UsageDetailsListForBillingPeriodByManagementGroup_564429,
    schemes: {Scheme.Https})
type
  Call_AggregatedCostGetByManagementGroup_564442 = ref object of OpenApiRestCall_563566
proc url_AggregatedCostGetByManagementGroup_564444(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/aggregatedcost")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AggregatedCostGetByManagementGroup_564443(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the aggregate cost of a management group and all child management groups by current billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Azure Management Group ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564445 = path.getOrDefault("managementGroupId")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "managementGroupId", valid_564445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $filter: JString
  ##          : May be used to filter aggregated cost by properties/usageStart (Utc time), properties/usageEnd (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564446 = query.getOrDefault("api-version")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "api-version", valid_564446
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

proc call*(call_564448: Call_AggregatedCostGetByManagementGroup_564442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the aggregate cost of a management group and all child management groups by current billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564448.validator(path, query, header, formData, body)
  let scheme = call_564448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564448.url(scheme.get, call_564448.host, call_564448.base,
                         call_564448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564448, url, valid)

proc call*(call_564449: Call_AggregatedCostGetByManagementGroup_564442;
          managementGroupId: string; apiVersion: string; Filter: string = ""): Recallable =
  ## aggregatedCostGetByManagementGroup
  ## Provides the aggregate cost of a management group and all child management groups by current billing period.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Filter: string
  ##         : May be used to filter aggregated cost by properties/usageStart (Utc time), properties/usageEnd (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564450 = newJObject()
  var query_564451 = newJObject()
  add(path_564450, "managementGroupId", newJString(managementGroupId))
  add(query_564451, "api-version", newJString(apiVersion))
  add(query_564451, "$filter", newJString(Filter))
  result = call_564449.call(path_564450, query_564451, nil, nil, nil)

var aggregatedCostGetByManagementGroup* = Call_AggregatedCostGetByManagementGroup_564442(
    name: "aggregatedCostGetByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Consumption/aggregatedcost",
    validator: validate_AggregatedCostGetByManagementGroup_564443, base: "",
    url: url_AggregatedCostGetByManagementGroup_564444, schemes: {Scheme.Https})
type
  Call_MarketplacesListByManagementGroup_564452 = ref object of OpenApiRestCall_563566
proc url_MarketplacesListByManagementGroup_564454(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesListByManagementGroup_564453(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplace records for all subscriptions belonging to a management group scope by current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Azure Management Group ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564455 = path.getOrDefault("managementGroupId")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "managementGroupId", valid_564455
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_564456 = query.getOrDefault("$top")
  valid_564456 = validateParameter(valid_564456, JInt, required = false, default = nil)
  if valid_564456 != nil:
    section.add "$top", valid_564456
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564457 = query.getOrDefault("api-version")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "api-version", valid_564457
  var valid_564458 = query.getOrDefault("$skiptoken")
  valid_564458 = validateParameter(valid_564458, JString, required = false,
                                 default = nil)
  if valid_564458 != nil:
    section.add "$skiptoken", valid_564458
  var valid_564459 = query.getOrDefault("$filter")
  valid_564459 = validateParameter(valid_564459, JString, required = false,
                                 default = nil)
  if valid_564459 != nil:
    section.add "$filter", valid_564459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564460: Call_MarketplacesListByManagementGroup_564452;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplace records for all subscriptions belonging to a management group scope by current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564460.validator(path, query, header, formData, body)
  let scheme = call_564460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564460.url(scheme.get, call_564460.host, call_564460.base,
                         call_564460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564460, url, valid)

proc call*(call_564461: Call_MarketplacesListByManagementGroup_564452;
          managementGroupId: string; apiVersion: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListByManagementGroup
  ## Lists the marketplace records for all subscriptions belonging to a management group scope by current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_564462 = newJObject()
  var query_564463 = newJObject()
  add(path_564462, "managementGroupId", newJString(managementGroupId))
  add(query_564463, "$top", newJInt(Top))
  add(query_564463, "api-version", newJString(apiVersion))
  add(query_564463, "$skiptoken", newJString(Skiptoken))
  add(query_564463, "$filter", newJString(Filter))
  result = call_564461.call(path_564462, query_564463, nil, nil, nil)

var marketplacesListByManagementGroup* = Call_MarketplacesListByManagementGroup_564452(
    name: "marketplacesListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByManagementGroup_564453, base: "",
    url: url_MarketplacesListByManagementGroup_564454, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByManagementGroup_564464 = ref object of OpenApiRestCall_563566
proc url_UsageDetailsListByManagementGroup_564466(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsListByManagementGroup_564465(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage detail records for all subscriptions belonging to a management group scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Azure Management Group ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564467 = path.getOrDefault("managementGroupId")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "managementGroupId", valid_564467
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_564468 = query.getOrDefault("$top")
  valid_564468 = validateParameter(valid_564468, JInt, required = false, default = nil)
  if valid_564468 != nil:
    section.add "$top", valid_564468
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564469 = query.getOrDefault("api-version")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "api-version", valid_564469
  var valid_564470 = query.getOrDefault("$expand")
  valid_564470 = validateParameter(valid_564470, JString, required = false,
                                 default = nil)
  if valid_564470 != nil:
    section.add "$expand", valid_564470
  var valid_564471 = query.getOrDefault("$apply")
  valid_564471 = validateParameter(valid_564471, JString, required = false,
                                 default = nil)
  if valid_564471 != nil:
    section.add "$apply", valid_564471
  var valid_564472 = query.getOrDefault("$skiptoken")
  valid_564472 = validateParameter(valid_564472, JString, required = false,
                                 default = nil)
  if valid_564472 != nil:
    section.add "$skiptoken", valid_564472
  var valid_564473 = query.getOrDefault("$filter")
  valid_564473 = validateParameter(valid_564473, JString, required = false,
                                 default = nil)
  if valid_564473 != nil:
    section.add "$filter", valid_564473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564474: Call_UsageDetailsListByManagementGroup_564464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage detail records for all subscriptions belonging to a management group scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564474.validator(path, query, header, formData, body)
  let scheme = call_564474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564474.url(scheme.get, call_564474.host, call_564474.base,
                         call_564474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564474, url, valid)

proc call*(call_564475: Call_UsageDetailsListByManagementGroup_564464;
          managementGroupId: string; apiVersion: string; Top: int = 0;
          Expand: string = ""; Apply: string = ""; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListByManagementGroup
  ## Lists the usage detail records for all subscriptions belonging to a management group scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564476 = newJObject()
  var query_564477 = newJObject()
  add(path_564476, "managementGroupId", newJString(managementGroupId))
  add(query_564477, "$top", newJInt(Top))
  add(query_564477, "api-version", newJString(apiVersion))
  add(query_564477, "$expand", newJString(Expand))
  add(query_564477, "$apply", newJString(Apply))
  add(query_564477, "$skiptoken", newJString(Skiptoken))
  add(query_564477, "$filter", newJString(Filter))
  result = call_564475.call(path_564476, query_564477, nil, nil, nil)

var usageDetailsListByManagementGroup* = Call_UsageDetailsListByManagementGroup_564464(
    name: "usageDetailsListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByManagementGroup_564465, base: "",
    url: url_UsageDetailsListByManagementGroup_564466, schemes: {Scheme.Https})
type
  Call_MarketplacesListByBillingPeriod_564478 = ref object of OpenApiRestCall_563566
proc url_MarketplacesListByBillingPeriod_564480(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesListByBillingPeriod_564479(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564481 = path.getOrDefault("subscriptionId")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "subscriptionId", valid_564481
  var valid_564482 = path.getOrDefault("billingPeriodName")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "billingPeriodName", valid_564482
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_564483 = query.getOrDefault("$top")
  valid_564483 = validateParameter(valid_564483, JInt, required = false, default = nil)
  if valid_564483 != nil:
    section.add "$top", valid_564483
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564484 = query.getOrDefault("api-version")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "api-version", valid_564484
  var valid_564485 = query.getOrDefault("$skiptoken")
  valid_564485 = validateParameter(valid_564485, JString, required = false,
                                 default = nil)
  if valid_564485 != nil:
    section.add "$skiptoken", valid_564485
  var valid_564486 = query.getOrDefault("$filter")
  valid_564486 = validateParameter(valid_564486, JString, required = false,
                                 default = nil)
  if valid_564486 != nil:
    section.add "$filter", valid_564486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564487: Call_MarketplacesListByBillingPeriod_564478;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564487.validator(path, query, header, formData, body)
  let scheme = call_564487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564487.url(scheme.get, call_564487.host, call_564487.base,
                         call_564487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564487, url, valid)

proc call*(call_564488: Call_MarketplacesListByBillingPeriod_564478;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListByBillingPeriod
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_564489 = newJObject()
  var query_564490 = newJObject()
  add(query_564490, "$top", newJInt(Top))
  add(query_564490, "api-version", newJString(apiVersion))
  add(path_564489, "subscriptionId", newJString(subscriptionId))
  add(query_564490, "$skiptoken", newJString(Skiptoken))
  add(path_564489, "billingPeriodName", newJString(billingPeriodName))
  add(query_564490, "$filter", newJString(Filter))
  result = call_564488.call(path_564489, query_564490, nil, nil, nil)

var marketplacesListByBillingPeriod* = Call_MarketplacesListByBillingPeriod_564478(
    name: "marketplacesListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByBillingPeriod_564479, base: "",
    url: url_MarketplacesListByBillingPeriod_564480, schemes: {Scheme.Https})
type
  Call_PriceSheetGetByBillingPeriod_564491 = ref object of OpenApiRestCall_563566
proc url_PriceSheetGetByBillingPeriod_564493(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/pricesheets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PriceSheetGetByBillingPeriod_564492(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564494 = path.getOrDefault("subscriptionId")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "subscriptionId", valid_564494
  var valid_564495 = path.getOrDefault("billingPeriodName")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "billingPeriodName", valid_564495
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the top N results.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  var valid_564496 = query.getOrDefault("$top")
  valid_564496 = validateParameter(valid_564496, JInt, required = false, default = nil)
  if valid_564496 != nil:
    section.add "$top", valid_564496
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564497 = query.getOrDefault("api-version")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "api-version", valid_564497
  var valid_564498 = query.getOrDefault("$expand")
  valid_564498 = validateParameter(valid_564498, JString, required = false,
                                 default = nil)
  if valid_564498 != nil:
    section.add "$expand", valid_564498
  var valid_564499 = query.getOrDefault("$skiptoken")
  valid_564499 = validateParameter(valid_564499, JString, required = false,
                                 default = nil)
  if valid_564499 != nil:
    section.add "$skiptoken", valid_564499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564500: Call_PriceSheetGetByBillingPeriod_564491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564500.validator(path, query, header, formData, body)
  let scheme = call_564500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564500.url(scheme.get, call_564500.host, call_564500.base,
                         call_564500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564500, url, valid)

proc call*(call_564501: Call_PriceSheetGetByBillingPeriod_564491;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Top: int = 0; Expand: string = ""; Skiptoken: string = ""): Recallable =
  ## priceSheetGetByBillingPeriod
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the top N results.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  var path_564502 = newJObject()
  var query_564503 = newJObject()
  add(query_564503, "$top", newJInt(Top))
  add(query_564503, "api-version", newJString(apiVersion))
  add(query_564503, "$expand", newJString(Expand))
  add(path_564502, "subscriptionId", newJString(subscriptionId))
  add(query_564503, "$skiptoken", newJString(Skiptoken))
  add(path_564502, "billingPeriodName", newJString(billingPeriodName))
  result = call_564501.call(path_564502, query_564503, nil, nil, nil)

var priceSheetGetByBillingPeriod* = Call_PriceSheetGetByBillingPeriod_564491(
    name: "priceSheetGetByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGetByBillingPeriod_564492, base: "",
    url: url_PriceSheetGetByBillingPeriod_564493, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByBillingPeriod_564504 = ref object of OpenApiRestCall_563566
proc url_UsageDetailsListByBillingPeriod_564506(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "billingPeriodName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsListByBillingPeriod_564505(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564507 = path.getOrDefault("subscriptionId")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "subscriptionId", valid_564507
  var valid_564508 = path.getOrDefault("billingPeriodName")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "billingPeriodName", valid_564508
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_564509 = query.getOrDefault("$top")
  valid_564509 = validateParameter(valid_564509, JInt, required = false, default = nil)
  if valid_564509 != nil:
    section.add "$top", valid_564509
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564510 = query.getOrDefault("api-version")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "api-version", valid_564510
  var valid_564511 = query.getOrDefault("$expand")
  valid_564511 = validateParameter(valid_564511, JString, required = false,
                                 default = nil)
  if valid_564511 != nil:
    section.add "$expand", valid_564511
  var valid_564512 = query.getOrDefault("$apply")
  valid_564512 = validateParameter(valid_564512, JString, required = false,
                                 default = nil)
  if valid_564512 != nil:
    section.add "$apply", valid_564512
  var valid_564513 = query.getOrDefault("$skiptoken")
  valid_564513 = validateParameter(valid_564513, JString, required = false,
                                 default = nil)
  if valid_564513 != nil:
    section.add "$skiptoken", valid_564513
  var valid_564514 = query.getOrDefault("$filter")
  valid_564514 = validateParameter(valid_564514, JString, required = false,
                                 default = nil)
  if valid_564514 != nil:
    section.add "$filter", valid_564514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564515: Call_UsageDetailsListByBillingPeriod_564504;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564515.validator(path, query, header, formData, body)
  let scheme = call_564515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564515.url(scheme.get, call_564515.host, call_564515.base,
                         call_564515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564515, url, valid)

proc call*(call_564516: Call_UsageDetailsListByBillingPeriod_564504;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Top: int = 0; Expand: string = ""; Apply: string = ""; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListByBillingPeriod
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564517 = newJObject()
  var query_564518 = newJObject()
  add(query_564518, "$top", newJInt(Top))
  add(query_564518, "api-version", newJString(apiVersion))
  add(query_564518, "$expand", newJString(Expand))
  add(path_564517, "subscriptionId", newJString(subscriptionId))
  add(query_564518, "$apply", newJString(Apply))
  add(query_564518, "$skiptoken", newJString(Skiptoken))
  add(path_564517, "billingPeriodName", newJString(billingPeriodName))
  add(query_564518, "$filter", newJString(Filter))
  result = call_564516.call(path_564517, query_564518, nil, nil, nil)

var usageDetailsListByBillingPeriod* = Call_UsageDetailsListByBillingPeriod_564504(
    name: "usageDetailsListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByBillingPeriod_564505, base: "",
    url: url_UsageDetailsListByBillingPeriod_564506, schemes: {Scheme.Https})
type
  Call_BudgetsList_564519 = ref object of OpenApiRestCall_563566
proc url_BudgetsList_564521(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsList_564520(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all budgets for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564522 = path.getOrDefault("subscriptionId")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "subscriptionId", valid_564522
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564523 = query.getOrDefault("api-version")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = nil)
  if valid_564523 != nil:
    section.add "api-version", valid_564523
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564524: Call_BudgetsList_564519; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564524.validator(path, query, header, formData, body)
  let scheme = call_564524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564524.url(scheme.get, call_564524.host, call_564524.base,
                         call_564524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564524, url, valid)

proc call*(call_564525: Call_BudgetsList_564519; apiVersion: string;
          subscriptionId: string): Recallable =
  ## budgetsList
  ## Lists all budgets for a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_564526 = newJObject()
  var query_564527 = newJObject()
  add(query_564527, "api-version", newJString(apiVersion))
  add(path_564526, "subscriptionId", newJString(subscriptionId))
  result = call_564525.call(path_564526, query_564527, nil, nil, nil)

var budgetsList* = Call_BudgetsList_564519(name: "budgetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets",
                                        validator: validate_BudgetsList_564520,
                                        base: "", url: url_BudgetsList_564521,
                                        schemes: {Scheme.Https})
type
  Call_BudgetsCreateOrUpdate_564538 = ref object of OpenApiRestCall_563566
proc url_BudgetsCreateOrUpdate_564540(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsCreateOrUpdate_564539(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564541 = path.getOrDefault("subscriptionId")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "subscriptionId", valid_564541
  var valid_564542 = path.getOrDefault("budgetName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "budgetName", valid_564542
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564543 = query.getOrDefault("api-version")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "api-version", valid_564543
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564545: Call_BudgetsCreateOrUpdate_564538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564545.validator(path, query, header, formData, body)
  let scheme = call_564545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564545.url(scheme.get, call_564545.host, call_564545.base,
                         call_564545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564545, url, valid)

proc call*(call_564546: Call_BudgetsCreateOrUpdate_564538; apiVersion: string;
          subscriptionId: string; budgetName: string; parameters: JsonNode): Recallable =
  ## budgetsCreateOrUpdate
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  var path_564547 = newJObject()
  var query_564548 = newJObject()
  var body_564549 = newJObject()
  add(query_564548, "api-version", newJString(apiVersion))
  add(path_564547, "subscriptionId", newJString(subscriptionId))
  add(path_564547, "budgetName", newJString(budgetName))
  if parameters != nil:
    body_564549 = parameters
  result = call_564546.call(path_564547, query_564548, nil, nil, body_564549)

var budgetsCreateOrUpdate* = Call_BudgetsCreateOrUpdate_564538(
    name: "budgetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsCreateOrUpdate_564539, base: "",
    url: url_BudgetsCreateOrUpdate_564540, schemes: {Scheme.Https})
type
  Call_BudgetsGet_564528 = ref object of OpenApiRestCall_563566
proc url_BudgetsGet_564530(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsGet_564529(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the budget for a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564531 = path.getOrDefault("subscriptionId")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "subscriptionId", valid_564531
  var valid_564532 = path.getOrDefault("budgetName")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "budgetName", valid_564532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564533 = query.getOrDefault("api-version")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "api-version", valid_564533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564534: Call_BudgetsGet_564528; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564534.validator(path, query, header, formData, body)
  let scheme = call_564534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564534.url(scheme.get, call_564534.host, call_564534.base,
                         call_564534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564534, url, valid)

proc call*(call_564535: Call_BudgetsGet_564528; apiVersion: string;
          subscriptionId: string; budgetName: string): Recallable =
  ## budgetsGet
  ## Gets the budget for a subscription by budget name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_564536 = newJObject()
  var query_564537 = newJObject()
  add(query_564537, "api-version", newJString(apiVersion))
  add(path_564536, "subscriptionId", newJString(subscriptionId))
  add(path_564536, "budgetName", newJString(budgetName))
  result = call_564535.call(path_564536, query_564537, nil, nil, nil)

var budgetsGet* = Call_BudgetsGet_564528(name: "budgetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
                                      validator: validate_BudgetsGet_564529,
                                      base: "", url: url_BudgetsGet_564530,
                                      schemes: {Scheme.Https})
type
  Call_BudgetsDelete_564550 = ref object of OpenApiRestCall_563566
proc url_BudgetsDelete_564552(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsDelete_564551(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564553 = path.getOrDefault("subscriptionId")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "subscriptionId", valid_564553
  var valid_564554 = path.getOrDefault("budgetName")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "budgetName", valid_564554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564555 = query.getOrDefault("api-version")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "api-version", valid_564555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564556: Call_BudgetsDelete_564550; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564556.validator(path, query, header, formData, body)
  let scheme = call_564556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564556.url(scheme.get, call_564556.host, call_564556.base,
                         call_564556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564556, url, valid)

proc call*(call_564557: Call_BudgetsDelete_564550; apiVersion: string;
          subscriptionId: string; budgetName: string): Recallable =
  ## budgetsDelete
  ## The operation to delete a budget.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_564558 = newJObject()
  var query_564559 = newJObject()
  add(query_564559, "api-version", newJString(apiVersion))
  add(path_564558, "subscriptionId", newJString(subscriptionId))
  add(path_564558, "budgetName", newJString(budgetName))
  result = call_564557.call(path_564558, query_564559, nil, nil, nil)

var budgetsDelete* = Call_BudgetsDelete_564550(name: "budgetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsDelete_564551, base: "", url: url_BudgetsDelete_564552,
    schemes: {Scheme.Https})
type
  Call_ForecastsList_564560 = ref object of OpenApiRestCall_563566
proc url_ForecastsList_564562(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/forecasts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ForecastsList_564561(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the forecast charges by subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564563 = path.getOrDefault("subscriptionId")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "subscriptionId", valid_564563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $filter: JString
  ##          : May be used to filter forecasts by properties/usageDate (Utc time), properties/chargeType or properties/grain. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564564 = query.getOrDefault("api-version")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "api-version", valid_564564
  var valid_564565 = query.getOrDefault("$filter")
  valid_564565 = validateParameter(valid_564565, JString, required = false,
                                 default = nil)
  if valid_564565 != nil:
    section.add "$filter", valid_564565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564566: Call_ForecastsList_564560; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the forecast charges by subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564566.validator(path, query, header, formData, body)
  let scheme = call_564566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564566.url(scheme.get, call_564566.host, call_564566.base,
                         call_564566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564566, url, valid)

proc call*(call_564567: Call_ForecastsList_564560; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## forecastsList
  ## Lists the forecast charges by subscriptionId.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Filter: string
  ##         : May be used to filter forecasts by properties/usageDate (Utc time), properties/chargeType or properties/grain. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_564568 = newJObject()
  var query_564569 = newJObject()
  add(query_564569, "api-version", newJString(apiVersion))
  add(path_564568, "subscriptionId", newJString(subscriptionId))
  add(query_564569, "$filter", newJString(Filter))
  result = call_564567.call(path_564568, query_564569, nil, nil, nil)

var forecastsList* = Call_ForecastsList_564560(name: "forecastsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/forecasts",
    validator: validate_ForecastsList_564561, base: "", url: url_ForecastsList_564562,
    schemes: {Scheme.Https})
type
  Call_MarketplacesList_564570 = ref object of OpenApiRestCall_563566
proc url_MarketplacesList_564572(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Consumption/marketplaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplacesList_564571(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by subscriptionId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564573 = path.getOrDefault("subscriptionId")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "subscriptionId", valid_564573
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  var valid_564574 = query.getOrDefault("$top")
  valid_564574 = validateParameter(valid_564574, JInt, required = false, default = nil)
  if valid_564574 != nil:
    section.add "$top", valid_564574
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564575 = query.getOrDefault("api-version")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "api-version", valid_564575
  var valid_564576 = query.getOrDefault("$skiptoken")
  valid_564576 = validateParameter(valid_564576, JString, required = false,
                                 default = nil)
  if valid_564576 != nil:
    section.add "$skiptoken", valid_564576
  var valid_564577 = query.getOrDefault("$filter")
  valid_564577 = validateParameter(valid_564577, JString, required = false,
                                 default = nil)
  if valid_564577 != nil:
    section.add "$filter", valid_564577
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564578: Call_MarketplacesList_564570; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by subscriptionId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564578.validator(path, query, header, formData, body)
  let scheme = call_564578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564578.url(scheme.get, call_564578.host, call_564578.base,
                         call_564578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564578, url, valid)

proc call*(call_564579: Call_MarketplacesList_564570; apiVersion: string;
          subscriptionId: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## marketplacesList
  ## Lists the marketplaces for a scope by subscriptionId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_564580 = newJObject()
  var query_564581 = newJObject()
  add(query_564581, "$top", newJInt(Top))
  add(query_564581, "api-version", newJString(apiVersion))
  add(path_564580, "subscriptionId", newJString(subscriptionId))
  add(query_564581, "$skiptoken", newJString(Skiptoken))
  add(query_564581, "$filter", newJString(Filter))
  result = call_564579.call(path_564580, query_564581, nil, nil, nil)

var marketplacesList* = Call_MarketplacesList_564570(name: "marketplacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesList_564571, base: "",
    url: url_MarketplacesList_564572, schemes: {Scheme.Https})
type
  Call_PriceSheetGet_564582 = ref object of OpenApiRestCall_563566
proc url_PriceSheetGet_564584(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Consumption/pricesheets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PriceSheetGet_564583(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564585 = path.getOrDefault("subscriptionId")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "subscriptionId", valid_564585
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the top N results.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  var valid_564586 = query.getOrDefault("$top")
  valid_564586 = validateParameter(valid_564586, JInt, required = false, default = nil)
  if valid_564586 != nil:
    section.add "$top", valid_564586
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564587 = query.getOrDefault("api-version")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "api-version", valid_564587
  var valid_564588 = query.getOrDefault("$expand")
  valid_564588 = validateParameter(valid_564588, JString, required = false,
                                 default = nil)
  if valid_564588 != nil:
    section.add "$expand", valid_564588
  var valid_564589 = query.getOrDefault("$skiptoken")
  valid_564589 = validateParameter(valid_564589, JString, required = false,
                                 default = nil)
  if valid_564589 != nil:
    section.add "$skiptoken", valid_564589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564590: Call_PriceSheetGet_564582; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564590.validator(path, query, header, formData, body)
  let scheme = call_564590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564590.url(scheme.get, call_564590.host, call_564590.base,
                         call_564590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564590, url, valid)

proc call*(call_564591: Call_PriceSheetGet_564582; apiVersion: string;
          subscriptionId: string; Top: int = 0; Expand: string = "";
          Skiptoken: string = ""): Recallable =
  ## priceSheetGet
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the top N results.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  var path_564592 = newJObject()
  var query_564593 = newJObject()
  add(query_564593, "$top", newJInt(Top))
  add(query_564593, "api-version", newJString(apiVersion))
  add(query_564593, "$expand", newJString(Expand))
  add(path_564592, "subscriptionId", newJString(subscriptionId))
  add(query_564593, "$skiptoken", newJString(Skiptoken))
  result = call_564591.call(path_564592, query_564593, nil, nil, nil)

var priceSheetGet* = Call_PriceSheetGet_564582(name: "priceSheetGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGet_564583, base: "", url: url_PriceSheetGet_564584,
    schemes: {Scheme.Https})
type
  Call_ReservationRecommendationsList_564594 = ref object of OpenApiRestCall_563566
proc url_ReservationRecommendationsList_564596(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Consumption/reservationRecommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReservationRecommendationsList_564595(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of recommendations for purchasing reserved instances.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564597 = path.getOrDefault("subscriptionId")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "subscriptionId", valid_564597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $filter: JString
  ##          : May be used to filter reservationRecommendations by properties/scope and properties/lookBackPeriod.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564598 = query.getOrDefault("api-version")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "api-version", valid_564598
  var valid_564599 = query.getOrDefault("$filter")
  valid_564599 = validateParameter(valid_564599, JString, required = false,
                                 default = nil)
  if valid_564599 != nil:
    section.add "$filter", valid_564599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564600: Call_ReservationRecommendationsList_564594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of recommendations for purchasing reserved instances.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564600.validator(path, query, header, formData, body)
  let scheme = call_564600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564600.url(scheme.get, call_564600.host, call_564600.base,
                         call_564600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564600, url, valid)

proc call*(call_564601: Call_ReservationRecommendationsList_564594;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## reservationRecommendationsList
  ## List of recommendations for purchasing reserved instances.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Filter: string
  ##         : May be used to filter reservationRecommendations by properties/scope and properties/lookBackPeriod.
  var path_564602 = newJObject()
  var query_564603 = newJObject()
  add(query_564603, "api-version", newJString(apiVersion))
  add(path_564602, "subscriptionId", newJString(subscriptionId))
  add(query_564603, "$filter", newJString(Filter))
  result = call_564601.call(path_564602, query_564603, nil, nil, nil)

var reservationRecommendationsList* = Call_ReservationRecommendationsList_564594(
    name: "reservationRecommendationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/reservationRecommendations",
    validator: validate_ReservationRecommendationsList_564595, base: "",
    url: url_ReservationRecommendationsList_564596, schemes: {Scheme.Https})
type
  Call_UsageDetailsList_564604 = ref object of OpenApiRestCall_563566
proc url_UsageDetailsList_564606(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Consumption/usageDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageDetailsList_564605(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the usage details for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564607 = path.getOrDefault("subscriptionId")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "subscriptionId", valid_564607
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_564608 = query.getOrDefault("$top")
  valid_564608 = validateParameter(valid_564608, JInt, required = false, default = nil)
  if valid_564608 != nil:
    section.add "$top", valid_564608
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564609 = query.getOrDefault("api-version")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "api-version", valid_564609
  var valid_564610 = query.getOrDefault("$expand")
  valid_564610 = validateParameter(valid_564610, JString, required = false,
                                 default = nil)
  if valid_564610 != nil:
    section.add "$expand", valid_564610
  var valid_564611 = query.getOrDefault("$apply")
  valid_564611 = validateParameter(valid_564611, JString, required = false,
                                 default = nil)
  if valid_564611 != nil:
    section.add "$apply", valid_564611
  var valid_564612 = query.getOrDefault("$skiptoken")
  valid_564612 = validateParameter(valid_564612, JString, required = false,
                                 default = nil)
  if valid_564612 != nil:
    section.add "$skiptoken", valid_564612
  var valid_564613 = query.getOrDefault("$filter")
  valid_564613 = validateParameter(valid_564613, JString, required = false,
                                 default = nil)
  if valid_564613 != nil:
    section.add "$filter", valid_564613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564614: Call_UsageDetailsList_564604; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564614.validator(path, query, header, formData, body)
  let scheme = call_564614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564614.url(scheme.get, call_564614.host, call_564614.base,
                         call_564614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564614, url, valid)

proc call*(call_564615: Call_UsageDetailsList_564604; apiVersion: string;
          subscriptionId: string; Top: int = 0; Expand: string = ""; Apply: string = "";
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsList
  ## Lists the usage details for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_564616 = newJObject()
  var query_564617 = newJObject()
  add(query_564617, "$top", newJInt(Top))
  add(query_564617, "api-version", newJString(apiVersion))
  add(query_564617, "$expand", newJString(Expand))
  add(path_564616, "subscriptionId", newJString(subscriptionId))
  add(query_564617, "$apply", newJString(Apply))
  add(query_564617, "$skiptoken", newJString(Skiptoken))
  add(query_564617, "$filter", newJString(Filter))
  result = call_564615.call(path_564616, query_564617, nil, nil, nil)

var usageDetailsList* = Call_UsageDetailsList_564604(name: "usageDetailsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsList_564605, base: "",
    url: url_UsageDetailsList_564606, schemes: {Scheme.Https})
type
  Call_BudgetsListByResourceGroupName_564618 = ref object of OpenApiRestCall_563566
proc url_BudgetsListByResourceGroupName_564620(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsListByResourceGroupName_564619(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all budgets for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
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
  var valid_564621 = path.getOrDefault("subscriptionId")
  valid_564621 = validateParameter(valid_564621, JString, required = true,
                                 default = nil)
  if valid_564621 != nil:
    section.add "subscriptionId", valid_564621
  var valid_564622 = path.getOrDefault("resourceGroupName")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "resourceGroupName", valid_564622
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564623 = query.getOrDefault("api-version")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "api-version", valid_564623
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564624: Call_BudgetsListByResourceGroupName_564618; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564624.validator(path, query, header, formData, body)
  let scheme = call_564624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564624.url(scheme.get, call_564624.host, call_564624.base,
                         call_564624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564624, url, valid)

proc call*(call_564625: Call_BudgetsListByResourceGroupName_564618;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## budgetsListByResourceGroupName
  ## Lists all budgets for a resource group under a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564626 = newJObject()
  var query_564627 = newJObject()
  add(query_564627, "api-version", newJString(apiVersion))
  add(path_564626, "subscriptionId", newJString(subscriptionId))
  add(path_564626, "resourceGroupName", newJString(resourceGroupName))
  result = call_564625.call(path_564626, query_564627, nil, nil, nil)

var budgetsListByResourceGroupName* = Call_BudgetsListByResourceGroupName_564618(
    name: "budgetsListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets",
    validator: validate_BudgetsListByResourceGroupName_564619, base: "",
    url: url_BudgetsListByResourceGroupName_564620, schemes: {Scheme.Https})
type
  Call_BudgetsCreateOrUpdateByResourceGroupName_564639 = ref object of OpenApiRestCall_563566
proc url_BudgetsCreateOrUpdateByResourceGroupName_564641(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsCreateOrUpdateByResourceGroupName_564640(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564642 = path.getOrDefault("subscriptionId")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "subscriptionId", valid_564642
  var valid_564643 = path.getOrDefault("budgetName")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "budgetName", valid_564643
  var valid_564644 = path.getOrDefault("resourceGroupName")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "resourceGroupName", valid_564644
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564645 = query.getOrDefault("api-version")
  valid_564645 = validateParameter(valid_564645, JString, required = true,
                                 default = nil)
  if valid_564645 != nil:
    section.add "api-version", valid_564645
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564647: Call_BudgetsCreateOrUpdateByResourceGroupName_564639;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564647.validator(path, query, header, formData, body)
  let scheme = call_564647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564647.url(scheme.get, call_564647.host, call_564647.base,
                         call_564647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564647, url, valid)

proc call*(call_564648: Call_BudgetsCreateOrUpdateByResourceGroupName_564639;
          apiVersion: string; subscriptionId: string; budgetName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## budgetsCreateOrUpdateByResourceGroupName
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  var path_564649 = newJObject()
  var query_564650 = newJObject()
  var body_564651 = newJObject()
  add(query_564650, "api-version", newJString(apiVersion))
  add(path_564649, "subscriptionId", newJString(subscriptionId))
  add(path_564649, "budgetName", newJString(budgetName))
  add(path_564649, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564651 = parameters
  result = call_564648.call(path_564649, query_564650, nil, nil, body_564651)

var budgetsCreateOrUpdateByResourceGroupName* = Call_BudgetsCreateOrUpdateByResourceGroupName_564639(
    name: "budgetsCreateOrUpdateByResourceGroupName", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsCreateOrUpdateByResourceGroupName_564640, base: "",
    url: url_BudgetsCreateOrUpdateByResourceGroupName_564641,
    schemes: {Scheme.Https})
type
  Call_BudgetsGetByResourceGroupName_564628 = ref object of OpenApiRestCall_563566
proc url_BudgetsGetByResourceGroupName_564630(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsGetByResourceGroupName_564629(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the budget for a resource group under a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564631 = path.getOrDefault("subscriptionId")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "subscriptionId", valid_564631
  var valid_564632 = path.getOrDefault("budgetName")
  valid_564632 = validateParameter(valid_564632, JString, required = true,
                                 default = nil)
  if valid_564632 != nil:
    section.add "budgetName", valid_564632
  var valid_564633 = path.getOrDefault("resourceGroupName")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "resourceGroupName", valid_564633
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564634 = query.getOrDefault("api-version")
  valid_564634 = validateParameter(valid_564634, JString, required = true,
                                 default = nil)
  if valid_564634 != nil:
    section.add "api-version", valid_564634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564635: Call_BudgetsGetByResourceGroupName_564628; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for a resource group under a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564635.validator(path, query, header, formData, body)
  let scheme = call_564635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564635.url(scheme.get, call_564635.host, call_564635.base,
                         call_564635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564635, url, valid)

proc call*(call_564636: Call_BudgetsGetByResourceGroupName_564628;
          apiVersion: string; subscriptionId: string; budgetName: string;
          resourceGroupName: string): Recallable =
  ## budgetsGetByResourceGroupName
  ## Gets the budget for a resource group under a subscription by budget name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564637 = newJObject()
  var query_564638 = newJObject()
  add(query_564638, "api-version", newJString(apiVersion))
  add(path_564637, "subscriptionId", newJString(subscriptionId))
  add(path_564637, "budgetName", newJString(budgetName))
  add(path_564637, "resourceGroupName", newJString(resourceGroupName))
  result = call_564636.call(path_564637, query_564638, nil, nil, nil)

var budgetsGetByResourceGroupName* = Call_BudgetsGetByResourceGroupName_564628(
    name: "budgetsGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsGetByResourceGroupName_564629, base: "",
    url: url_BudgetsGetByResourceGroupName_564630, schemes: {Scheme.Https})
type
  Call_BudgetsDeleteByResourceGroupName_564652 = ref object of OpenApiRestCall_563566
proc url_BudgetsDeleteByResourceGroupName_564654(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "budgetName" in path, "`budgetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/budgets/"),
               (kind: VariableSegment, value: "budgetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BudgetsDeleteByResourceGroupName_564653(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
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
  var valid_564656 = path.getOrDefault("budgetName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "budgetName", valid_564656
  var valid_564657 = path.getOrDefault("resourceGroupName")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "resourceGroupName", valid_564657
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-10-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564658 = query.getOrDefault("api-version")
  valid_564658 = validateParameter(valid_564658, JString, required = true,
                                 default = nil)
  if valid_564658 != nil:
    section.add "api-version", valid_564658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564659: Call_BudgetsDeleteByResourceGroupName_564652;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564659.validator(path, query, header, formData, body)
  let scheme = call_564659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564659.url(scheme.get, call_564659.host, call_564659.base,
                         call_564659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564659, url, valid)

proc call*(call_564660: Call_BudgetsDeleteByResourceGroupName_564652;
          apiVersion: string; subscriptionId: string; budgetName: string;
          resourceGroupName: string): Recallable =
  ## budgetsDeleteByResourceGroupName
  ## The operation to delete a budget.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-10-01.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  var path_564661 = newJObject()
  var query_564662 = newJObject()
  add(query_564662, "api-version", newJString(apiVersion))
  add(path_564661, "subscriptionId", newJString(subscriptionId))
  add(path_564661, "budgetName", newJString(budgetName))
  add(path_564661, "resourceGroupName", newJString(resourceGroupName))
  result = call_564660.call(path_564661, query_564662, nil, nil, nil)

var budgetsDeleteByResourceGroupName* = Call_BudgetsDeleteByResourceGroupName_564652(
    name: "budgetsDeleteByResourceGroupName", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsDeleteByResourceGroupName_564653, base: "",
    url: url_BudgetsDeleteByResourceGroupName_564654, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
