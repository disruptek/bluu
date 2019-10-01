
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ConsumptionManagementClient
## version: 2018-08-31
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
  macServiceName = "consumption"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ChargesListForBillingPeriodByDepartment_567890 = ref object of OpenApiRestCall_567668
proc url_ChargesListForBillingPeriodByDepartment_567892(protocol: Scheme;
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

proc validate_ChargesListForBillingPeriodByDepartment_567891(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the charges based on departmentId by billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_568066 = path.getOrDefault("billingPeriodName")
  valid_568066 = validateParameter(valid_568066, JString, required = true,
                                 default = nil)
  if valid_568066 != nil:
    section.add "billingPeriodName", valid_568066
  var valid_568067 = path.getOrDefault("billingAccountId")
  valid_568067 = validateParameter(valid_568067, JString, required = true,
                                 default = nil)
  if valid_568067 != nil:
    section.add "billingAccountId", valid_568067
  var valid_568068 = path.getOrDefault("departmentId")
  valid_568068 = validateParameter(valid_568068, JString, required = true,
                                 default = nil)
  if valid_568068 != nil:
    section.add "departmentId", valid_568068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $filter: JString
  ##          : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568069 = query.getOrDefault("api-version")
  valid_568069 = validateParameter(valid_568069, JString, required = true,
                                 default = nil)
  if valid_568069 != nil:
    section.add "api-version", valid_568069
  var valid_568070 = query.getOrDefault("$filter")
  valid_568070 = validateParameter(valid_568070, JString, required = false,
                                 default = nil)
  if valid_568070 != nil:
    section.add "$filter", valid_568070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568093: Call_ChargesListForBillingPeriodByDepartment_567890;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the charges based on departmentId by billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568093.validator(path, query, header, formData, body)
  let scheme = call_568093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568093.url(scheme.get, call_568093.host, call_568093.base,
                         call_568093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568093, url, valid)

proc call*(call_568164: Call_ChargesListForBillingPeriodByDepartment_567890;
          apiVersion: string; billingPeriodName: string; billingAccountId: string;
          departmentId: string; Filter: string = ""): Recallable =
  ## chargesListForBillingPeriodByDepartment
  ## Lists the charges based on departmentId by billing period.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Filter: string
  ##         : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568165 = newJObject()
  var query_568167 = newJObject()
  add(query_568167, "api-version", newJString(apiVersion))
  add(path_568165, "billingPeriodName", newJString(billingPeriodName))
  add(path_568165, "billingAccountId", newJString(billingAccountId))
  add(path_568165, "departmentId", newJString(departmentId))
  add(query_568167, "$filter", newJString(Filter))
  result = call_568164.call(path_568165, query_568167, nil, nil, nil)

var chargesListForBillingPeriodByDepartment* = Call_ChargesListForBillingPeriodByDepartment_567890(
    name: "chargesListForBillingPeriodByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesListForBillingPeriodByDepartment_567891, base: "",
    url: url_ChargesListForBillingPeriodByDepartment_567892,
    schemes: {Scheme.Https})
type
  Call_ChargesListByDepartment_568206 = ref object of OpenApiRestCall_567668
proc url_ChargesListByDepartment_568208(protocol: Scheme; host: string; base: string;
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

proc validate_ChargesListByDepartment_568207(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the charges by departmentId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
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
  var valid_568209 = path.getOrDefault("billingAccountId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "billingAccountId", valid_568209
  var valid_568210 = path.getOrDefault("departmentId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "departmentId", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $filter: JString
  ##          : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  var valid_568212 = query.getOrDefault("$filter")
  valid_568212 = validateParameter(valid_568212, JString, required = false,
                                 default = nil)
  if valid_568212 != nil:
    section.add "$filter", valid_568212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_ChargesListByDepartment_568206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by departmentId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_ChargesListByDepartment_568206; apiVersion: string;
          billingAccountId: string; departmentId: string; Filter: string = ""): Recallable =
  ## chargesListByDepartment
  ## Lists the charges by departmentId.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Filter: string
  ##         : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "billingAccountId", newJString(billingAccountId))
  add(path_568215, "departmentId", newJString(departmentId))
  add(query_568216, "$filter", newJString(Filter))
  result = call_568214.call(path_568215, query_568216, nil, nil, nil)

var chargesListByDepartment* = Call_ChargesListByDepartment_568206(
    name: "chargesListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/departments/{departmentId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesListByDepartment_568207, base: "",
    url: url_ChargesListByDepartment_568208, schemes: {Scheme.Https})
type
  Call_ChargesListForBillingPeriodByEnrollmentAccount_568217 = ref object of OpenApiRestCall_567668
proc url_ChargesListForBillingPeriodByEnrollmentAccount_568219(protocol: Scheme;
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

proc validate_ChargesListForBillingPeriodByEnrollmentAccount_568218(
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
  var valid_568220 = path.getOrDefault("enrollmentAccountId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "enrollmentAccountId", valid_568220
  var valid_568221 = path.getOrDefault("billingPeriodName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "billingPeriodName", valid_568221
  var valid_568222 = path.getOrDefault("billingAccountId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "billingAccountId", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $filter: JString
  ##          : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  var valid_568224 = query.getOrDefault("$filter")
  valid_568224 = validateParameter(valid_568224, JString, required = false,
                                 default = nil)
  if valid_568224 != nil:
    section.add "$filter", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_ChargesListForBillingPeriodByEnrollmentAccount_568217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the charges based on enrollmentAccountId by billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_ChargesListForBillingPeriodByEnrollmentAccount_568217;
          apiVersion: string; enrollmentAccountId: string;
          billingPeriodName: string; billingAccountId: string; Filter: string = ""): Recallable =
  ## chargesListForBillingPeriodByEnrollmentAccount
  ## Lists the charges based on enrollmentAccountId by billing period.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568227, "billingPeriodName", newJString(billingPeriodName))
  add(path_568227, "billingAccountId", newJString(billingAccountId))
  add(query_568228, "$filter", newJString(Filter))
  result = call_568226.call(path_568227, query_568228, nil, nil, nil)

var chargesListForBillingPeriodByEnrollmentAccount* = Call_ChargesListForBillingPeriodByEnrollmentAccount_568217(
    name: "chargesListForBillingPeriodByEnrollmentAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesListForBillingPeriodByEnrollmentAccount_568218,
    base: "", url: url_ChargesListForBillingPeriodByEnrollmentAccount_568219,
    schemes: {Scheme.Https})
type
  Call_ChargesListByEnrollmentAccount_568229 = ref object of OpenApiRestCall_567668
proc url_ChargesListByEnrollmentAccount_568231(protocol: Scheme; host: string;
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

proc validate_ChargesListByEnrollmentAccount_568230(path: JsonNode;
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
  var valid_568232 = path.getOrDefault("enrollmentAccountId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "enrollmentAccountId", valid_568232
  var valid_568233 = path.getOrDefault("billingAccountId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "billingAccountId", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $filter: JString
  ##          : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  var valid_568235 = query.getOrDefault("$filter")
  valid_568235 = validateParameter(valid_568235, JString, required = false,
                                 default = nil)
  if valid_568235 != nil:
    section.add "$filter", valid_568235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_ChargesListByEnrollmentAccount_568229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by enrollmentAccountId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_ChargesListByEnrollmentAccount_568229;
          apiVersion: string; enrollmentAccountId: string; billingAccountId: string;
          Filter: string = ""): Recallable =
  ## chargesListByEnrollmentAccount
  ## Lists the charges by enrollmentAccountId.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter charges by properties/usageEnd (Utc time), properties/usageStart (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568238, "billingAccountId", newJString(billingAccountId))
  add(query_568239, "$filter", newJString(Filter))
  result = call_568237.call(path_568238, query_568239, nil, nil, nil)

var chargesListByEnrollmentAccount* = Call_ChargesListByEnrollmentAccount_568229(
    name: "chargesListByEnrollmentAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesListByEnrollmentAccount_568230, base: "",
    url: url_ChargesListByEnrollmentAccount_568231, schemes: {Scheme.Https})
type
  Call_BalancesGetForBillingPeriodByBillingAccount_568240 = ref object of OpenApiRestCall_567668
proc url_BalancesGetForBillingPeriodByBillingAccount_568242(protocol: Scheme;
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

proc validate_BalancesGetForBillingPeriodByBillingAccount_568241(path: JsonNode;
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
  var valid_568243 = path.getOrDefault("billingPeriodName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "billingPeriodName", valid_568243
  var valid_568244 = path.getOrDefault("billingAccountId")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "billingAccountId", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568246: Call_BalancesGetForBillingPeriodByBillingAccount_568240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568246.validator(path, query, header, formData, body)
  let scheme = call_568246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568246.url(scheme.get, call_568246.host, call_568246.base,
                         call_568246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568246, url, valid)

proc call*(call_568247: Call_BalancesGetForBillingPeriodByBillingAccount_568240;
          apiVersion: string; billingPeriodName: string; billingAccountId: string): Recallable =
  ## balancesGetForBillingPeriodByBillingAccount
  ## Gets the balances for a scope by billing period and billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568248 = newJObject()
  var query_568249 = newJObject()
  add(query_568249, "api-version", newJString(apiVersion))
  add(path_568248, "billingPeriodName", newJString(billingPeriodName))
  add(path_568248, "billingAccountId", newJString(billingAccountId))
  result = call_568247.call(path_568248, query_568249, nil, nil, nil)

var balancesGetForBillingPeriodByBillingAccount* = Call_BalancesGetForBillingPeriodByBillingAccount_568240(
    name: "balancesGetForBillingPeriodByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/balances",
    validator: validate_BalancesGetForBillingPeriodByBillingAccount_568241,
    base: "", url: url_BalancesGetForBillingPeriodByBillingAccount_568242,
    schemes: {Scheme.Https})
type
  Call_MarketplacesListForBillingPeriodByBillingAccount_568250 = ref object of OpenApiRestCall_567668
proc url_MarketplacesListForBillingPeriodByBillingAccount_568252(
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

proc validate_MarketplacesListForBillingPeriodByBillingAccount_568251(
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
  var valid_568253 = path.getOrDefault("billingPeriodName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "billingPeriodName", valid_568253
  var valid_568254 = path.getOrDefault("billingAccountId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "billingAccountId", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  var valid_568256 = query.getOrDefault("$top")
  valid_568256 = validateParameter(valid_568256, JInt, required = false, default = nil)
  if valid_568256 != nil:
    section.add "$top", valid_568256
  var valid_568257 = query.getOrDefault("$skiptoken")
  valid_568257 = validateParameter(valid_568257, JString, required = false,
                                 default = nil)
  if valid_568257 != nil:
    section.add "$skiptoken", valid_568257
  var valid_568258 = query.getOrDefault("$filter")
  valid_568258 = validateParameter(valid_568258, JString, required = false,
                                 default = nil)
  if valid_568258 != nil:
    section.add "$filter", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_MarketplacesListForBillingPeriodByBillingAccount_568250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and billingAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_MarketplacesListForBillingPeriodByBillingAccount_568250;
          apiVersion: string; billingPeriodName: string; billingAccountId: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListForBillingPeriodByBillingAccount
  ## Lists the marketplaces for a scope by billing period and billingAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(query_568262, "api-version", newJString(apiVersion))
  add(query_568262, "$top", newJInt(Top))
  add(query_568262, "$skiptoken", newJString(Skiptoken))
  add(path_568261, "billingPeriodName", newJString(billingPeriodName))
  add(path_568261, "billingAccountId", newJString(billingAccountId))
  add(query_568262, "$filter", newJString(Filter))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var marketplacesListForBillingPeriodByBillingAccount* = Call_MarketplacesListForBillingPeriodByBillingAccount_568250(
    name: "marketplacesListForBillingPeriodByBillingAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListForBillingPeriodByBillingAccount_568251,
    base: "", url: url_MarketplacesListForBillingPeriodByBillingAccount_568252,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsListForBillingPeriodByBillingAccount_568263 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsListForBillingPeriodByBillingAccount_568265(
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

proc validate_UsageDetailsListForBillingPeriodByBillingAccount_568264(
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
  var valid_568266 = path.getOrDefault("billingPeriodName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "billingPeriodName", valid_568266
  var valid_568267 = path.getOrDefault("billingAccountId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "billingAccountId", valid_568267
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568268 = query.getOrDefault("$expand")
  valid_568268 = validateParameter(valid_568268, JString, required = false,
                                 default = nil)
  if valid_568268 != nil:
    section.add "$expand", valid_568268
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  var valid_568270 = query.getOrDefault("$top")
  valid_568270 = validateParameter(valid_568270, JInt, required = false, default = nil)
  if valid_568270 != nil:
    section.add "$top", valid_568270
  var valid_568271 = query.getOrDefault("$skiptoken")
  valid_568271 = validateParameter(valid_568271, JString, required = false,
                                 default = nil)
  if valid_568271 != nil:
    section.add "$skiptoken", valid_568271
  var valid_568272 = query.getOrDefault("$apply")
  valid_568272 = validateParameter(valid_568272, JString, required = false,
                                 default = nil)
  if valid_568272 != nil:
    section.add "$apply", valid_568272
  var valid_568273 = query.getOrDefault("$filter")
  valid_568273 = validateParameter(valid_568273, JString, required = false,
                                 default = nil)
  if valid_568273 != nil:
    section.add "$filter", valid_568273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_UsageDetailsListForBillingPeriodByBillingAccount_568263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details based on billingAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_UsageDetailsListForBillingPeriodByBillingAccount_568263;
          apiVersion: string; billingPeriodName: string; billingAccountId: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListForBillingPeriodByBillingAccount
  ## Lists the usage details based on billingAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(query_568277, "$expand", newJString(Expand))
  add(query_568277, "api-version", newJString(apiVersion))
  add(query_568277, "$top", newJInt(Top))
  add(query_568277, "$skiptoken", newJString(Skiptoken))
  add(path_568276, "billingPeriodName", newJString(billingPeriodName))
  add(path_568276, "billingAccountId", newJString(billingAccountId))
  add(query_568277, "$apply", newJString(Apply))
  add(query_568277, "$filter", newJString(Filter))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var usageDetailsListForBillingPeriodByBillingAccount* = Call_UsageDetailsListForBillingPeriodByBillingAccount_568263(
    name: "usageDetailsListForBillingPeriodByBillingAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListForBillingPeriodByBillingAccount_568264,
    base: "", url: url_UsageDetailsListForBillingPeriodByBillingAccount_568265,
    schemes: {Scheme.Https})
type
  Call_BalancesGetByBillingAccount_568278 = ref object of OpenApiRestCall_567668
proc url_BalancesGetByBillingAccount_568280(protocol: Scheme; host: string;
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

proc validate_BalancesGetByBillingAccount_568279(path: JsonNode; query: JsonNode;
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
  var valid_568281 = path.getOrDefault("billingAccountId")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "billingAccountId", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_BalancesGetByBillingAccount_568278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_BalancesGetByBillingAccount_568278;
          apiVersion: string; billingAccountId: string): Recallable =
  ## balancesGetByBillingAccount
  ## Gets the balances for a scope by billingAccountId. Balances are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "billingAccountId", newJString(billingAccountId))
  result = call_568284.call(path_568285, query_568286, nil, nil, nil)

var balancesGetByBillingAccount* = Call_BalancesGetByBillingAccount_568278(
    name: "balancesGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/balances",
    validator: validate_BalancesGetByBillingAccount_568279, base: "",
    url: url_BalancesGetByBillingAccount_568280, schemes: {Scheme.Https})
type
  Call_MarketplacesListByBillingAccount_568287 = ref object of OpenApiRestCall_567668
proc url_MarketplacesListByBillingAccount_568289(protocol: Scheme; host: string;
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

proc validate_MarketplacesListByBillingAccount_568288(path: JsonNode;
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
  var valid_568290 = path.getOrDefault("billingAccountId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "billingAccountId", valid_568290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568291 = query.getOrDefault("api-version")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "api-version", valid_568291
  var valid_568292 = query.getOrDefault("$top")
  valid_568292 = validateParameter(valid_568292, JInt, required = false, default = nil)
  if valid_568292 != nil:
    section.add "$top", valid_568292
  var valid_568293 = query.getOrDefault("$skiptoken")
  valid_568293 = validateParameter(valid_568293, JString, required = false,
                                 default = nil)
  if valid_568293 != nil:
    section.add "$skiptoken", valid_568293
  var valid_568294 = query.getOrDefault("$filter")
  valid_568294 = validateParameter(valid_568294, JString, required = false,
                                 default = nil)
  if valid_568294 != nil:
    section.add "$filter", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_MarketplacesListByBillingAccount_568287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billingAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_MarketplacesListByBillingAccount_568287;
          apiVersion: string; billingAccountId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListByBillingAccount
  ## Lists the marketplaces for a scope by billingAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(query_568298, "api-version", newJString(apiVersion))
  add(query_568298, "$top", newJInt(Top))
  add(query_568298, "$skiptoken", newJString(Skiptoken))
  add(path_568297, "billingAccountId", newJString(billingAccountId))
  add(query_568298, "$filter", newJString(Filter))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var marketplacesListByBillingAccount* = Call_MarketplacesListByBillingAccount_568287(
    name: "marketplacesListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByBillingAccount_568288, base: "",
    url: url_MarketplacesListByBillingAccount_568289, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByBillingAccount_568299 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsListByBillingAccount_568301(protocol: Scheme; host: string;
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

proc validate_UsageDetailsListByBillingAccount_568300(path: JsonNode;
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
  var valid_568302 = path.getOrDefault("billingAccountId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "billingAccountId", valid_568302
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568303 = query.getOrDefault("$expand")
  valid_568303 = validateParameter(valid_568303, JString, required = false,
                                 default = nil)
  if valid_568303 != nil:
    section.add "$expand", valid_568303
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  var valid_568305 = query.getOrDefault("$top")
  valid_568305 = validateParameter(valid_568305, JInt, required = false, default = nil)
  if valid_568305 != nil:
    section.add "$top", valid_568305
  var valid_568306 = query.getOrDefault("$skiptoken")
  valid_568306 = validateParameter(valid_568306, JString, required = false,
                                 default = nil)
  if valid_568306 != nil:
    section.add "$skiptoken", valid_568306
  var valid_568307 = query.getOrDefault("$apply")
  valid_568307 = validateParameter(valid_568307, JString, required = false,
                                 default = nil)
  if valid_568307 != nil:
    section.add "$apply", valid_568307
  var valid_568308 = query.getOrDefault("$filter")
  valid_568308 = validateParameter(valid_568308, JString, required = false,
                                 default = nil)
  if valid_568308 != nil:
    section.add "$filter", valid_568308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568309: Call_UsageDetailsListByBillingAccount_568299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details by billingAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568309.validator(path, query, header, formData, body)
  let scheme = call_568309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568309.url(scheme.get, call_568309.host, call_568309.base,
                         call_568309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568309, url, valid)

proc call*(call_568310: Call_UsageDetailsListByBillingAccount_568299;
          apiVersion: string; billingAccountId: string; Expand: string = "";
          Top: int = 0; Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsListByBillingAccount
  ## Lists the usage details by billingAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568311 = newJObject()
  var query_568312 = newJObject()
  add(query_568312, "$expand", newJString(Expand))
  add(query_568312, "api-version", newJString(apiVersion))
  add(query_568312, "$top", newJInt(Top))
  add(query_568312, "$skiptoken", newJString(Skiptoken))
  add(path_568311, "billingAccountId", newJString(billingAccountId))
  add(query_568312, "$apply", newJString(Apply))
  add(query_568312, "$filter", newJString(Filter))
  result = call_568310.call(path_568311, query_568312, nil, nil, nil)

var usageDetailsListByBillingAccount* = Call_UsageDetailsListByBillingAccount_568299(
    name: "usageDetailsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByBillingAccount_568300, base: "",
    url: url_UsageDetailsListByBillingAccount_568301, schemes: {Scheme.Https})
type
  Call_MarketplacesListForBillingPeriodByDepartment_568313 = ref object of OpenApiRestCall_567668
proc url_MarketplacesListForBillingPeriodByDepartment_568315(protocol: Scheme;
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

proc validate_MarketplacesListForBillingPeriodByDepartment_568314(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the marketplaces for a scope by billing period and departmentId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_568316 = path.getOrDefault("billingPeriodName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "billingPeriodName", valid_568316
  var valid_568317 = path.getOrDefault("departmentId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "departmentId", valid_568317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568318 = query.getOrDefault("api-version")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "api-version", valid_568318
  var valid_568319 = query.getOrDefault("$top")
  valid_568319 = validateParameter(valid_568319, JInt, required = false, default = nil)
  if valid_568319 != nil:
    section.add "$top", valid_568319
  var valid_568320 = query.getOrDefault("$skiptoken")
  valid_568320 = validateParameter(valid_568320, JString, required = false,
                                 default = nil)
  if valid_568320 != nil:
    section.add "$skiptoken", valid_568320
  var valid_568321 = query.getOrDefault("$filter")
  valid_568321 = validateParameter(valid_568321, JString, required = false,
                                 default = nil)
  if valid_568321 != nil:
    section.add "$filter", valid_568321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_MarketplacesListForBillingPeriodByDepartment_568313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and departmentId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_MarketplacesListForBillingPeriodByDepartment_568313;
          apiVersion: string; billingPeriodName: string; departmentId: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListForBillingPeriodByDepartment
  ## Lists the marketplaces for a scope by billing period and departmentId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  add(query_568325, "api-version", newJString(apiVersion))
  add(query_568325, "$top", newJInt(Top))
  add(query_568325, "$skiptoken", newJString(Skiptoken))
  add(path_568324, "billingPeriodName", newJString(billingPeriodName))
  add(path_568324, "departmentId", newJString(departmentId))
  add(query_568325, "$filter", newJString(Filter))
  result = call_568323.call(path_568324, query_568325, nil, nil, nil)

var marketplacesListForBillingPeriodByDepartment* = Call_MarketplacesListForBillingPeriodByDepartment_568313(
    name: "marketplacesListForBillingPeriodByDepartment",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListForBillingPeriodByDepartment_568314,
    base: "", url: url_MarketplacesListForBillingPeriodByDepartment_568315,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsListForBillingPeriodByDepartment_568326 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsListForBillingPeriodByDepartment_568328(protocol: Scheme;
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

proc validate_UsageDetailsListForBillingPeriodByDepartment_568327(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the usage details based on departmentId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingPeriodName: JString (required)
  ##                    : Billing Period Name.
  ##   departmentId: JString (required)
  ##               : Department ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingPeriodName` field"
  var valid_568329 = path.getOrDefault("billingPeriodName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "billingPeriodName", valid_568329
  var valid_568330 = path.getOrDefault("departmentId")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "departmentId", valid_568330
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568331 = query.getOrDefault("$expand")
  valid_568331 = validateParameter(valid_568331, JString, required = false,
                                 default = nil)
  if valid_568331 != nil:
    section.add "$expand", valid_568331
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
  var valid_568333 = query.getOrDefault("$top")
  valid_568333 = validateParameter(valid_568333, JInt, required = false, default = nil)
  if valid_568333 != nil:
    section.add "$top", valid_568333
  var valid_568334 = query.getOrDefault("$skiptoken")
  valid_568334 = validateParameter(valid_568334, JString, required = false,
                                 default = nil)
  if valid_568334 != nil:
    section.add "$skiptoken", valid_568334
  var valid_568335 = query.getOrDefault("$apply")
  valid_568335 = validateParameter(valid_568335, JString, required = false,
                                 default = nil)
  if valid_568335 != nil:
    section.add "$apply", valid_568335
  var valid_568336 = query.getOrDefault("$filter")
  valid_568336 = validateParameter(valid_568336, JString, required = false,
                                 default = nil)
  if valid_568336 != nil:
    section.add "$filter", valid_568336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_UsageDetailsListForBillingPeriodByDepartment_568326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details based on departmentId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_UsageDetailsListForBillingPeriodByDepartment_568326;
          apiVersion: string; billingPeriodName: string; departmentId: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListForBillingPeriodByDepartment
  ## Lists the usage details based on departmentId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  add(query_568340, "$expand", newJString(Expand))
  add(query_568340, "api-version", newJString(apiVersion))
  add(query_568340, "$top", newJInt(Top))
  add(query_568340, "$skiptoken", newJString(Skiptoken))
  add(path_568339, "billingPeriodName", newJString(billingPeriodName))
  add(path_568339, "departmentId", newJString(departmentId))
  add(query_568340, "$apply", newJString(Apply))
  add(query_568340, "$filter", newJString(Filter))
  result = call_568338.call(path_568339, query_568340, nil, nil, nil)

var usageDetailsListForBillingPeriodByDepartment* = Call_UsageDetailsListForBillingPeriodByDepartment_568326(
    name: "usageDetailsListForBillingPeriodByDepartment",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListForBillingPeriodByDepartment_568327,
    base: "", url: url_UsageDetailsListForBillingPeriodByDepartment_568328,
    schemes: {Scheme.Https})
type
  Call_MarketplacesListByDepartment_568341 = ref object of OpenApiRestCall_567668
proc url_MarketplacesListByDepartment_568343(protocol: Scheme; host: string;
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

proc validate_MarketplacesListByDepartment_568342(path: JsonNode; query: JsonNode;
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
  var valid_568344 = path.getOrDefault("departmentId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "departmentId", valid_568344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568345 = query.getOrDefault("api-version")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "api-version", valid_568345
  var valid_568346 = query.getOrDefault("$top")
  valid_568346 = validateParameter(valid_568346, JInt, required = false, default = nil)
  if valid_568346 != nil:
    section.add "$top", valid_568346
  var valid_568347 = query.getOrDefault("$skiptoken")
  valid_568347 = validateParameter(valid_568347, JString, required = false,
                                 default = nil)
  if valid_568347 != nil:
    section.add "$skiptoken", valid_568347
  var valid_568348 = query.getOrDefault("$filter")
  valid_568348 = validateParameter(valid_568348, JString, required = false,
                                 default = nil)
  if valid_568348 != nil:
    section.add "$filter", valid_568348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_MarketplacesListByDepartment_568341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by departmentId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_MarketplacesListByDepartment_568341;
          apiVersion: string; departmentId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListByDepartment
  ## Lists the marketplaces for a scope by departmentId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568351 = newJObject()
  var query_568352 = newJObject()
  add(query_568352, "api-version", newJString(apiVersion))
  add(query_568352, "$top", newJInt(Top))
  add(query_568352, "$skiptoken", newJString(Skiptoken))
  add(path_568351, "departmentId", newJString(departmentId))
  add(query_568352, "$filter", newJString(Filter))
  result = call_568350.call(path_568351, query_568352, nil, nil, nil)

var marketplacesListByDepartment* = Call_MarketplacesListByDepartment_568341(
    name: "marketplacesListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByDepartment_568342, base: "",
    url: url_MarketplacesListByDepartment_568343, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByDepartment_568353 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsListByDepartment_568355(protocol: Scheme; host: string;
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

proc validate_UsageDetailsListByDepartment_568354(path: JsonNode; query: JsonNode;
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
  var valid_568356 = path.getOrDefault("departmentId")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "departmentId", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568357 = query.getOrDefault("$expand")
  valid_568357 = validateParameter(valid_568357, JString, required = false,
                                 default = nil)
  if valid_568357 != nil:
    section.add "$expand", valid_568357
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568358 = query.getOrDefault("api-version")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "api-version", valid_568358
  var valid_568359 = query.getOrDefault("$top")
  valid_568359 = validateParameter(valid_568359, JInt, required = false, default = nil)
  if valid_568359 != nil:
    section.add "$top", valid_568359
  var valid_568360 = query.getOrDefault("$skiptoken")
  valid_568360 = validateParameter(valid_568360, JString, required = false,
                                 default = nil)
  if valid_568360 != nil:
    section.add "$skiptoken", valid_568360
  var valid_568361 = query.getOrDefault("$apply")
  valid_568361 = validateParameter(valid_568361, JString, required = false,
                                 default = nil)
  if valid_568361 != nil:
    section.add "$apply", valid_568361
  var valid_568362 = query.getOrDefault("$filter")
  valid_568362 = validateParameter(valid_568362, JString, required = false,
                                 default = nil)
  if valid_568362 != nil:
    section.add "$filter", valid_568362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568363: Call_UsageDetailsListByDepartment_568353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details by departmentId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568363.validator(path, query, header, formData, body)
  let scheme = call_568363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568363.url(scheme.get, call_568363.host, call_568363.base,
                         call_568363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568363, url, valid)

proc call*(call_568364: Call_UsageDetailsListByDepartment_568353;
          apiVersion: string; departmentId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsListByDepartment
  ## Lists the usage details by departmentId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   departmentId: string (required)
  ##               : Department ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568365 = newJObject()
  var query_568366 = newJObject()
  add(query_568366, "$expand", newJString(Expand))
  add(query_568366, "api-version", newJString(apiVersion))
  add(query_568366, "$top", newJInt(Top))
  add(query_568366, "$skiptoken", newJString(Skiptoken))
  add(path_568365, "departmentId", newJString(departmentId))
  add(query_568366, "$apply", newJString(Apply))
  add(query_568366, "$filter", newJString(Filter))
  result = call_568364.call(path_568365, query_568366, nil, nil, nil)

var usageDetailsListByDepartment* = Call_UsageDetailsListByDepartment_568353(
    name: "usageDetailsListByDepartment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/departments/{departmentId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByDepartment_568354, base: "",
    url: url_UsageDetailsListByDepartment_568355, schemes: {Scheme.Https})
type
  Call_MarketplacesListForBillingPeriodByEnrollmentAccount_568367 = ref object of OpenApiRestCall_567668
proc url_MarketplacesListForBillingPeriodByEnrollmentAccount_568369(
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

proc validate_MarketplacesListForBillingPeriodByEnrollmentAccount_568368(
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
  var valid_568370 = path.getOrDefault("enrollmentAccountId")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "enrollmentAccountId", valid_568370
  var valid_568371 = path.getOrDefault("billingPeriodName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "billingPeriodName", valid_568371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568372 = query.getOrDefault("api-version")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "api-version", valid_568372
  var valid_568373 = query.getOrDefault("$top")
  valid_568373 = validateParameter(valid_568373, JInt, required = false, default = nil)
  if valid_568373 != nil:
    section.add "$top", valid_568373
  var valid_568374 = query.getOrDefault("$skiptoken")
  valid_568374 = validateParameter(valid_568374, JString, required = false,
                                 default = nil)
  if valid_568374 != nil:
    section.add "$skiptoken", valid_568374
  var valid_568375 = query.getOrDefault("$filter")
  valid_568375 = validateParameter(valid_568375, JString, required = false,
                                 default = nil)
  if valid_568375 != nil:
    section.add "$filter", valid_568375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568376: Call_MarketplacesListForBillingPeriodByEnrollmentAccount_568367;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and enrollmentAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568376.validator(path, query, header, formData, body)
  let scheme = call_568376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568376.url(scheme.get, call_568376.host, call_568376.base,
                         call_568376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568376, url, valid)

proc call*(call_568377: Call_MarketplacesListForBillingPeriodByEnrollmentAccount_568367;
          apiVersion: string; enrollmentAccountId: string;
          billingPeriodName: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## marketplacesListForBillingPeriodByEnrollmentAccount
  ## Lists the marketplaces for a scope by billing period and enrollmentAccountId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568378 = newJObject()
  var query_568379 = newJObject()
  add(query_568379, "api-version", newJString(apiVersion))
  add(query_568379, "$top", newJInt(Top))
  add(query_568379, "$skiptoken", newJString(Skiptoken))
  add(path_568378, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568378, "billingPeriodName", newJString(billingPeriodName))
  add(query_568379, "$filter", newJString(Filter))
  result = call_568377.call(path_568378, query_568379, nil, nil, nil)

var marketplacesListForBillingPeriodByEnrollmentAccount* = Call_MarketplacesListForBillingPeriodByEnrollmentAccount_568367(
    name: "marketplacesListForBillingPeriodByEnrollmentAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListForBillingPeriodByEnrollmentAccount_568368,
    base: "", url: url_MarketplacesListForBillingPeriodByEnrollmentAccount_568369,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsListForBillingPeriodByEnrollmentAccount_568380 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsListForBillingPeriodByEnrollmentAccount_568382(
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

proc validate_UsageDetailsListForBillingPeriodByEnrollmentAccount_568381(
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
  var valid_568383 = path.getOrDefault("enrollmentAccountId")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "enrollmentAccountId", valid_568383
  var valid_568384 = path.getOrDefault("billingPeriodName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "billingPeriodName", valid_568384
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568385 = query.getOrDefault("$expand")
  valid_568385 = validateParameter(valid_568385, JString, required = false,
                                 default = nil)
  if valid_568385 != nil:
    section.add "$expand", valid_568385
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568386 = query.getOrDefault("api-version")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "api-version", valid_568386
  var valid_568387 = query.getOrDefault("$top")
  valid_568387 = validateParameter(valid_568387, JInt, required = false, default = nil)
  if valid_568387 != nil:
    section.add "$top", valid_568387
  var valid_568388 = query.getOrDefault("$skiptoken")
  valid_568388 = validateParameter(valid_568388, JString, required = false,
                                 default = nil)
  if valid_568388 != nil:
    section.add "$skiptoken", valid_568388
  var valid_568389 = query.getOrDefault("$apply")
  valid_568389 = validateParameter(valid_568389, JString, required = false,
                                 default = nil)
  if valid_568389 != nil:
    section.add "$apply", valid_568389
  var valid_568390 = query.getOrDefault("$filter")
  valid_568390 = validateParameter(valid_568390, JString, required = false,
                                 default = nil)
  if valid_568390 != nil:
    section.add "$filter", valid_568390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568391: Call_UsageDetailsListForBillingPeriodByEnrollmentAccount_568380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details based on enrollmentAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568391.validator(path, query, header, formData, body)
  let scheme = call_568391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568391.url(scheme.get, call_568391.host, call_568391.base,
                         call_568391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568391, url, valid)

proc call*(call_568392: Call_UsageDetailsListForBillingPeriodByEnrollmentAccount_568380;
          apiVersion: string; enrollmentAccountId: string;
          billingPeriodName: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsListForBillingPeriodByEnrollmentAccount
  ## Lists the usage details based on enrollmentAccountId for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568393 = newJObject()
  var query_568394 = newJObject()
  add(query_568394, "$expand", newJString(Expand))
  add(query_568394, "api-version", newJString(apiVersion))
  add(query_568394, "$top", newJInt(Top))
  add(query_568394, "$skiptoken", newJString(Skiptoken))
  add(path_568393, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(path_568393, "billingPeriodName", newJString(billingPeriodName))
  add(query_568394, "$apply", newJString(Apply))
  add(query_568394, "$filter", newJString(Filter))
  result = call_568392.call(path_568393, query_568394, nil, nil, nil)

var usageDetailsListForBillingPeriodByEnrollmentAccount* = Call_UsageDetailsListForBillingPeriodByEnrollmentAccount_568380(
    name: "usageDetailsListForBillingPeriodByEnrollmentAccount",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListForBillingPeriodByEnrollmentAccount_568381,
    base: "", url: url_UsageDetailsListForBillingPeriodByEnrollmentAccount_568382,
    schemes: {Scheme.Https})
type
  Call_MarketplacesListByEnrollmentAccount_568395 = ref object of OpenApiRestCall_567668
proc url_MarketplacesListByEnrollmentAccount_568397(protocol: Scheme; host: string;
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

proc validate_MarketplacesListByEnrollmentAccount_568396(path: JsonNode;
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
  var valid_568398 = path.getOrDefault("enrollmentAccountId")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "enrollmentAccountId", valid_568398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568399 = query.getOrDefault("api-version")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "api-version", valid_568399
  var valid_568400 = query.getOrDefault("$top")
  valid_568400 = validateParameter(valid_568400, JInt, required = false, default = nil)
  if valid_568400 != nil:
    section.add "$top", valid_568400
  var valid_568401 = query.getOrDefault("$skiptoken")
  valid_568401 = validateParameter(valid_568401, JString, required = false,
                                 default = nil)
  if valid_568401 != nil:
    section.add "$skiptoken", valid_568401
  var valid_568402 = query.getOrDefault("$filter")
  valid_568402 = validateParameter(valid_568402, JString, required = false,
                                 default = nil)
  if valid_568402 != nil:
    section.add "$filter", valid_568402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568403: Call_MarketplacesListByEnrollmentAccount_568395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by enrollmentAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568403.validator(path, query, header, formData, body)
  let scheme = call_568403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568403.url(scheme.get, call_568403.host, call_568403.base,
                         call_568403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568403, url, valid)

proc call*(call_568404: Call_MarketplacesListByEnrollmentAccount_568395;
          apiVersion: string; enrollmentAccountId: string; Top: int = 0;
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListByEnrollmentAccount
  ## Lists the marketplaces for a scope by enrollmentAccountId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568405 = newJObject()
  var query_568406 = newJObject()
  add(query_568406, "api-version", newJString(apiVersion))
  add(query_568406, "$top", newJInt(Top))
  add(query_568406, "$skiptoken", newJString(Skiptoken))
  add(path_568405, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(query_568406, "$filter", newJString(Filter))
  result = call_568404.call(path_568405, query_568406, nil, nil, nil)

var marketplacesListByEnrollmentAccount* = Call_MarketplacesListByEnrollmentAccount_568395(
    name: "marketplacesListByEnrollmentAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByEnrollmentAccount_568396, base: "",
    url: url_MarketplacesListByEnrollmentAccount_568397, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByEnrollmentAccount_568407 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsListByEnrollmentAccount_568409(protocol: Scheme; host: string;
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

proc validate_UsageDetailsListByEnrollmentAccount_568408(path: JsonNode;
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
  var valid_568410 = path.getOrDefault("enrollmentAccountId")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "enrollmentAccountId", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568411 = query.getOrDefault("$expand")
  valid_568411 = validateParameter(valid_568411, JString, required = false,
                                 default = nil)
  if valid_568411 != nil:
    section.add "$expand", valid_568411
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568412 = query.getOrDefault("api-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "api-version", valid_568412
  var valid_568413 = query.getOrDefault("$top")
  valid_568413 = validateParameter(valid_568413, JInt, required = false, default = nil)
  if valid_568413 != nil:
    section.add "$top", valid_568413
  var valid_568414 = query.getOrDefault("$skiptoken")
  valid_568414 = validateParameter(valid_568414, JString, required = false,
                                 default = nil)
  if valid_568414 != nil:
    section.add "$skiptoken", valid_568414
  var valid_568415 = query.getOrDefault("$apply")
  valid_568415 = validateParameter(valid_568415, JString, required = false,
                                 default = nil)
  if valid_568415 != nil:
    section.add "$apply", valid_568415
  var valid_568416 = query.getOrDefault("$filter")
  valid_568416 = validateParameter(valid_568416, JString, required = false,
                                 default = nil)
  if valid_568416 != nil:
    section.add "$filter", valid_568416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568417: Call_UsageDetailsListByEnrollmentAccount_568407;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details by enrollmentAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568417.validator(path, query, header, formData, body)
  let scheme = call_568417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568417.url(scheme.get, call_568417.host, call_568417.base,
                         call_568417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568417, url, valid)

proc call*(call_568418: Call_UsageDetailsListByEnrollmentAccount_568407;
          apiVersion: string; enrollmentAccountId: string; Expand: string = "";
          Top: int = 0; Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsListByEnrollmentAccount
  ## Lists the usage details by enrollmentAccountId for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   enrollmentAccountId: string (required)
  ##                      : EnrollmentAccount ID
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568419 = newJObject()
  var query_568420 = newJObject()
  add(query_568420, "$expand", newJString(Expand))
  add(query_568420, "api-version", newJString(apiVersion))
  add(query_568420, "$top", newJInt(Top))
  add(query_568420, "$skiptoken", newJString(Skiptoken))
  add(path_568419, "enrollmentAccountId", newJString(enrollmentAccountId))
  add(query_568420, "$apply", newJString(Apply))
  add(query_568420, "$filter", newJString(Filter))
  result = call_568418.call(path_568419, query_568420, nil, nil, nil)

var usageDetailsListByEnrollmentAccount* = Call_UsageDetailsListByEnrollmentAccount_568407(
    name: "usageDetailsListByEnrollmentAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByEnrollmentAccount_568408, base: "",
    url: url_UsageDetailsListByEnrollmentAccount_568409, schemes: {Scheme.Https})
type
  Call_ReservationsDetailsListByReservationOrder_568421 = ref object of OpenApiRestCall_567668
proc url_ReservationsDetailsListByReservationOrder_568423(protocol: Scheme;
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

proc validate_ReservationsDetailsListByReservationOrder_568422(path: JsonNode;
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
  var valid_568424 = path.getOrDefault("reservationOrderId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "reservationOrderId", valid_568424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568425 = query.getOrDefault("api-version")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "api-version", valid_568425
  var valid_568426 = query.getOrDefault("$filter")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "$filter", valid_568426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568427: Call_ReservationsDetailsListByReservationOrder_568421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_ReservationsDetailsListByReservationOrder_568421;
          apiVersion: string; reservationOrderId: string; Filter: string): Recallable =
  ## reservationsDetailsListByReservationOrder
  ## Lists the reservations details for provided date range.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string (required)
  ##         : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  add(query_568430, "api-version", newJString(apiVersion))
  add(path_568429, "reservationOrderId", newJString(reservationOrderId))
  add(query_568430, "$filter", newJString(Filter))
  result = call_568428.call(path_568429, query_568430, nil, nil, nil)

var reservationsDetailsListByReservationOrder* = Call_ReservationsDetailsListByReservationOrder_568421(
    name: "reservationsDetailsListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationDetails",
    validator: validate_ReservationsDetailsListByReservationOrder_568422,
    base: "", url: url_ReservationsDetailsListByReservationOrder_568423,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrder_568431 = ref object of OpenApiRestCall_567668
proc url_ReservationsSummariesListByReservationOrder_568433(protocol: Scheme;
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

proc validate_ReservationsSummariesListByReservationOrder_568432(path: JsonNode;
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
  var valid_568434 = path.getOrDefault("reservationOrderId")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "reservationOrderId", valid_568434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $filter: JString
  ##          : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: JString (required)
  ##        : Can be daily or monthly
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568435 = query.getOrDefault("api-version")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "api-version", valid_568435
  var valid_568436 = query.getOrDefault("$filter")
  valid_568436 = validateParameter(valid_568436, JString, required = false,
                                 default = nil)
  if valid_568436 != nil:
    section.add "$filter", valid_568436
  var valid_568450 = query.getOrDefault("grain")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = newJString("daily"))
  if valid_568450 != nil:
    section.add "grain", valid_568450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_ReservationsSummariesListByReservationOrder_568431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_ReservationsSummariesListByReservationOrder_568431;
          apiVersion: string; reservationOrderId: string; Filter: string = "";
          grain: string = "daily"): Recallable =
  ## reservationsSummariesListByReservationOrder
  ## Lists the reservations summaries for daily or monthly grain.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   Filter: string
  ##         : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: string (required)
  ##        : Can be daily or monthly
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(query_568454, "api-version", newJString(apiVersion))
  add(path_568453, "reservationOrderId", newJString(reservationOrderId))
  add(query_568454, "$filter", newJString(Filter))
  add(query_568454, "grain", newJString(grain))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var reservationsSummariesListByReservationOrder* = Call_ReservationsSummariesListByReservationOrder_568431(
    name: "reservationsSummariesListByReservationOrder", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/providers/Microsoft.Consumption/reservationSummaries",
    validator: validate_ReservationsSummariesListByReservationOrder_568432,
    base: "", url: url_ReservationsSummariesListByReservationOrder_568433,
    schemes: {Scheme.Https})
type
  Call_ReservationsDetailsListByReservationOrderAndReservation_568455 = ref object of OpenApiRestCall_567668
proc url_ReservationsDetailsListByReservationOrderAndReservation_568457(
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

proc validate_ReservationsDetailsListByReservationOrderAndReservation_568456(
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
  var valid_568458 = path.getOrDefault("reservationOrderId")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "reservationOrderId", valid_568458
  var valid_568459 = path.getOrDefault("reservationId")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "reservationId", valid_568459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $filter: JString (required)
  ##          : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568460 = query.getOrDefault("api-version")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "api-version", valid_568460
  var valid_568461 = query.getOrDefault("$filter")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "$filter", valid_568461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568462: Call_ReservationsDetailsListByReservationOrderAndReservation_568455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations details for provided date range.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568462.validator(path, query, header, formData, body)
  let scheme = call_568462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568462.url(scheme.get, call_568462.host, call_568462.base,
                         call_568462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568462, url, valid)

proc call*(call_568463: Call_ReservationsDetailsListByReservationOrderAndReservation_568455;
          apiVersion: string; reservationOrderId: string; reservationId: string;
          Filter: string): Recallable =
  ## reservationsDetailsListByReservationOrderAndReservation
  ## Lists the reservations details for provided date range.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the reservation
  ##   Filter: string (required)
  ##         : Filter reservation details by date range. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge' 
  var path_568464 = newJObject()
  var query_568465 = newJObject()
  add(query_568465, "api-version", newJString(apiVersion))
  add(path_568464, "reservationOrderId", newJString(reservationOrderId))
  add(path_568464, "reservationId", newJString(reservationId))
  add(query_568465, "$filter", newJString(Filter))
  result = call_568463.call(path_568464, query_568465, nil, nil, nil)

var reservationsDetailsListByReservationOrderAndReservation* = Call_ReservationsDetailsListByReservationOrderAndReservation_568455(
    name: "reservationsDetailsListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationDetails", validator: validate_ReservationsDetailsListByReservationOrderAndReservation_568456,
    base: "", url: url_ReservationsDetailsListByReservationOrderAndReservation_568457,
    schemes: {Scheme.Https})
type
  Call_ReservationsSummariesListByReservationOrderAndReservation_568466 = ref object of OpenApiRestCall_567668
proc url_ReservationsSummariesListByReservationOrderAndReservation_568468(
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

proc validate_ReservationsSummariesListByReservationOrderAndReservation_568467(
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
  var valid_568469 = path.getOrDefault("reservationOrderId")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "reservationOrderId", valid_568469
  var valid_568470 = path.getOrDefault("reservationId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "reservationId", valid_568470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $filter: JString
  ##          : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: JString (required)
  ##        : Can be daily or monthly
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568471 = query.getOrDefault("api-version")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "api-version", valid_568471
  var valid_568472 = query.getOrDefault("$filter")
  valid_568472 = validateParameter(valid_568472, JString, required = false,
                                 default = nil)
  if valid_568472 != nil:
    section.add "$filter", valid_568472
  var valid_568473 = query.getOrDefault("grain")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = newJString("daily"))
  if valid_568473 != nil:
    section.add "grain", valid_568473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568474: Call_ReservationsSummariesListByReservationOrderAndReservation_568466;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the reservations summaries for daily or monthly grain.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568474.validator(path, query, header, formData, body)
  let scheme = call_568474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568474.url(scheme.get, call_568474.host, call_568474.base,
                         call_568474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568474, url, valid)

proc call*(call_568475: Call_ReservationsSummariesListByReservationOrderAndReservation_568466;
          apiVersion: string; reservationOrderId: string; reservationId: string;
          Filter: string = ""; grain: string = "daily"): Recallable =
  ## reservationsSummariesListByReservationOrderAndReservation
  ## Lists the reservations summaries for daily or monthly grain.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   reservationOrderId: string (required)
  ##                     : Order Id of the reservation
  ##   reservationId: string (required)
  ##                : Id of the reservation
  ##   Filter: string
  ##         : Required only for daily grain. The properties/UsageDate for start date and end date. The filter supports 'le' and  'ge'
  ##   grain: string (required)
  ##        : Can be daily or monthly
  var path_568476 = newJObject()
  var query_568477 = newJObject()
  add(query_568477, "api-version", newJString(apiVersion))
  add(path_568476, "reservationOrderId", newJString(reservationOrderId))
  add(path_568476, "reservationId", newJString(reservationId))
  add(query_568477, "$filter", newJString(Filter))
  add(query_568477, "grain", newJString(grain))
  result = call_568475.call(path_568476, query_568477, nil, nil, nil)

var reservationsSummariesListByReservationOrderAndReservation* = Call_ReservationsSummariesListByReservationOrderAndReservation_568466(
    name: "reservationsSummariesListByReservationOrderAndReservation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Capacity/reservationorders/{reservationOrderId}/reservations/{reservationId}/providers/Microsoft.Consumption/reservationSummaries", validator: validate_ReservationsSummariesListByReservationOrderAndReservation_568467,
    base: "", url: url_ReservationsSummariesListByReservationOrderAndReservation_568468,
    schemes: {Scheme.Https})
type
  Call_OperationsList_568478 = ref object of OpenApiRestCall_567668
proc url_OperationsList_568480(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568479(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568481 = query.getOrDefault("api-version")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "api-version", valid_568481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568482: Call_OperationsList_568478; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_568482.validator(path, query, header, formData, body)
  let scheme = call_568482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568482.url(scheme.get, call_568482.host, call_568482.base,
                         call_568482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568482, url, valid)

proc call*(call_568483: Call_OperationsList_568478; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  var query_568484 = newJObject()
  add(query_568484, "api-version", newJString(apiVersion))
  result = call_568483.call(nil, query_568484, nil, nil, nil)

var operationsList* = Call_OperationsList_568478(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Consumption/operations",
    validator: validate_OperationsList_568479, base: "", url: url_OperationsList_568480,
    schemes: {Scheme.Https})
type
  Call_TagsGet_568485 = ref object of OpenApiRestCall_567668
proc url_TagsGet_568487(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TagsGet_568486(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568488 = path.getOrDefault("billingAccountId")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "billingAccountId", valid_568488
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
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

proc call*(call_568490: Call_TagsGet_568485; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all available tag keys for a billing account.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568490.validator(path, query, header, formData, body)
  let scheme = call_568490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568490.url(scheme.get, call_568490.host, call_568490.base,
                         call_568490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568490, url, valid)

proc call*(call_568491: Call_TagsGet_568485; apiVersion: string;
          billingAccountId: string): Recallable =
  ## tagsGet
  ## Get all available tag keys for a billing account.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  var path_568492 = newJObject()
  var query_568493 = newJObject()
  add(query_568493, "api-version", newJString(apiVersion))
  add(path_568492, "billingAccountId", newJString(billingAccountId))
  result = call_568491.call(path_568492, query_568493, nil, nil, nil)

var tagsGet* = Call_TagsGet_568485(name: "tagsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/providers/Microsoft.CostManagement/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/tags",
                                validator: validate_TagsGet_568486, base: "",
                                url: url_TagsGet_568487, schemes: {Scheme.Https})
type
  Call_AggregatedCostGetForBillingPeriodByManagementGroup_568494 = ref object of OpenApiRestCall_567668
proc url_AggregatedCostGetForBillingPeriodByManagementGroup_568496(
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

proc validate_AggregatedCostGetForBillingPeriodByManagementGroup_568495(
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
  var valid_568497 = path.getOrDefault("managementGroupId")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "managementGroupId", valid_568497
  var valid_568498 = path.getOrDefault("billingPeriodName")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "billingPeriodName", valid_568498
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
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
  if body != nil:
    result.add "body", body

proc call*(call_568500: Call_AggregatedCostGetForBillingPeriodByManagementGroup_568494;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the aggregate cost of a management group and all child management groups by specified billing period
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568500.validator(path, query, header, formData, body)
  let scheme = call_568500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568500.url(scheme.get, call_568500.host, call_568500.base,
                         call_568500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568500, url, valid)

proc call*(call_568501: Call_AggregatedCostGetForBillingPeriodByManagementGroup_568494;
          apiVersion: string; managementGroupId: string; billingPeriodName: string): Recallable =
  ## aggregatedCostGetForBillingPeriodByManagementGroup
  ## Provides the aggregate cost of a management group and all child management groups by specified billing period
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  var path_568502 = newJObject()
  var query_568503 = newJObject()
  add(query_568503, "api-version", newJString(apiVersion))
  add(path_568502, "managementGroupId", newJString(managementGroupId))
  add(path_568502, "billingPeriodName", newJString(billingPeriodName))
  result = call_568501.call(path_568502, query_568503, nil, nil, nil)

var aggregatedCostGetForBillingPeriodByManagementGroup* = Call_AggregatedCostGetForBillingPeriodByManagementGroup_568494(
    name: "aggregatedCostGetForBillingPeriodByManagementGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/Microsoft.Consumption/aggregatedcost",
    validator: validate_AggregatedCostGetForBillingPeriodByManagementGroup_568495,
    base: "", url: url_AggregatedCostGetForBillingPeriodByManagementGroup_568496,
    schemes: {Scheme.Https})
type
  Call_UsageDetailsListForBillingPeriodByManagementGroup_568504 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsListForBillingPeriodByManagementGroup_568506(
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

proc validate_UsageDetailsListForBillingPeriodByManagementGroup_568505(
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
  var valid_568507 = path.getOrDefault("managementGroupId")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "managementGroupId", valid_568507
  var valid_568508 = path.getOrDefault("billingPeriodName")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "billingPeriodName", valid_568508
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568509 = query.getOrDefault("$expand")
  valid_568509 = validateParameter(valid_568509, JString, required = false,
                                 default = nil)
  if valid_568509 != nil:
    section.add "$expand", valid_568509
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568510 = query.getOrDefault("api-version")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "api-version", valid_568510
  var valid_568511 = query.getOrDefault("$top")
  valid_568511 = validateParameter(valid_568511, JInt, required = false, default = nil)
  if valid_568511 != nil:
    section.add "$top", valid_568511
  var valid_568512 = query.getOrDefault("$skiptoken")
  valid_568512 = validateParameter(valid_568512, JString, required = false,
                                 default = nil)
  if valid_568512 != nil:
    section.add "$skiptoken", valid_568512
  var valid_568513 = query.getOrDefault("$apply")
  valid_568513 = validateParameter(valid_568513, JString, required = false,
                                 default = nil)
  if valid_568513 != nil:
    section.add "$apply", valid_568513
  var valid_568514 = query.getOrDefault("$filter")
  valid_568514 = validateParameter(valid_568514, JString, required = false,
                                 default = nil)
  if valid_568514 != nil:
    section.add "$filter", valid_568514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568515: Call_UsageDetailsListForBillingPeriodByManagementGroup_568504;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage detail records for all subscriptions belonging to a management group scope by specified billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568515.validator(path, query, header, formData, body)
  let scheme = call_568515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568515.url(scheme.get, call_568515.host, call_568515.base,
                         call_568515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568515, url, valid)

proc call*(call_568516: Call_UsageDetailsListForBillingPeriodByManagementGroup_568504;
          apiVersion: string; managementGroupId: string; billingPeriodName: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListForBillingPeriodByManagementGroup
  ## Lists the usage detail records for all subscriptions belonging to a management group scope by specified billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568517 = newJObject()
  var query_568518 = newJObject()
  add(query_568518, "$expand", newJString(Expand))
  add(query_568518, "api-version", newJString(apiVersion))
  add(path_568517, "managementGroupId", newJString(managementGroupId))
  add(query_568518, "$top", newJInt(Top))
  add(query_568518, "$skiptoken", newJString(Skiptoken))
  add(path_568517, "billingPeriodName", newJString(billingPeriodName))
  add(query_568518, "$apply", newJString(Apply))
  add(query_568518, "$filter", newJString(Filter))
  result = call_568516.call(path_568517, query_568518, nil, nil, nil)

var usageDetailsListForBillingPeriodByManagementGroup* = Call_UsageDetailsListForBillingPeriodByManagementGroup_568504(
    name: "usageDetailsListForBillingPeriodByManagementGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListForBillingPeriodByManagementGroup_568505,
    base: "", url: url_UsageDetailsListForBillingPeriodByManagementGroup_568506,
    schemes: {Scheme.Https})
type
  Call_AggregatedCostGetByManagementGroup_568519 = ref object of OpenApiRestCall_567668
proc url_AggregatedCostGetByManagementGroup_568521(protocol: Scheme; host: string;
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

proc validate_AggregatedCostGetByManagementGroup_568520(path: JsonNode;
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
  var valid_568522 = path.getOrDefault("managementGroupId")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "managementGroupId", valid_568522
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $filter: JString
  ##          : May be used to filter aggregated cost by properties/usageStart (Utc time), properties/usageEnd (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568523 = query.getOrDefault("api-version")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "api-version", valid_568523
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

proc call*(call_568525: Call_AggregatedCostGetByManagementGroup_568519;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the aggregate cost of a management group and all child management groups by current billing period.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568525.validator(path, query, header, formData, body)
  let scheme = call_568525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568525.url(scheme.get, call_568525.host, call_568525.base,
                         call_568525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568525, url, valid)

proc call*(call_568526: Call_AggregatedCostGetByManagementGroup_568519;
          apiVersion: string; managementGroupId: string; Filter: string = ""): Recallable =
  ## aggregatedCostGetByManagementGroup
  ## Provides the aggregate cost of a management group and all child management groups by current billing period.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   Filter: string
  ##         : May be used to filter aggregated cost by properties/usageStart (Utc time), properties/usageEnd (Utc time). The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568527 = newJObject()
  var query_568528 = newJObject()
  add(query_568528, "api-version", newJString(apiVersion))
  add(path_568527, "managementGroupId", newJString(managementGroupId))
  add(query_568528, "$filter", newJString(Filter))
  result = call_568526.call(path_568527, query_568528, nil, nil, nil)

var aggregatedCostGetByManagementGroup* = Call_AggregatedCostGetByManagementGroup_568519(
    name: "aggregatedCostGetByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Consumption/aggregatedcost",
    validator: validate_AggregatedCostGetByManagementGroup_568520, base: "",
    url: url_AggregatedCostGetByManagementGroup_568521, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByManagementGroup_568529 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsListByManagementGroup_568531(protocol: Scheme; host: string;
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

proc validate_UsageDetailsListByManagementGroup_568530(path: JsonNode;
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
  var valid_568532 = path.getOrDefault("managementGroupId")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "managementGroupId", valid_568532
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568533 = query.getOrDefault("$expand")
  valid_568533 = validateParameter(valid_568533, JString, required = false,
                                 default = nil)
  if valid_568533 != nil:
    section.add "$expand", valid_568533
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568534 = query.getOrDefault("api-version")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "api-version", valid_568534
  var valid_568535 = query.getOrDefault("$top")
  valid_568535 = validateParameter(valid_568535, JInt, required = false, default = nil)
  if valid_568535 != nil:
    section.add "$top", valid_568535
  var valid_568536 = query.getOrDefault("$skiptoken")
  valid_568536 = validateParameter(valid_568536, JString, required = false,
                                 default = nil)
  if valid_568536 != nil:
    section.add "$skiptoken", valid_568536
  var valid_568537 = query.getOrDefault("$apply")
  valid_568537 = validateParameter(valid_568537, JString, required = false,
                                 default = nil)
  if valid_568537 != nil:
    section.add "$apply", valid_568537
  var valid_568538 = query.getOrDefault("$filter")
  valid_568538 = validateParameter(valid_568538, JString, required = false,
                                 default = nil)
  if valid_568538 != nil:
    section.add "$filter", valid_568538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568539: Call_UsageDetailsListByManagementGroup_568529;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage detail records for all subscriptions belonging to a management group scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568539.validator(path, query, header, formData, body)
  let scheme = call_568539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568539.url(scheme.get, call_568539.host, call_568539.base,
                         call_568539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568539, url, valid)

proc call*(call_568540: Call_UsageDetailsListByManagementGroup_568529;
          apiVersion: string; managementGroupId: string; Expand: string = "";
          Top: int = 0; Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsListByManagementGroup
  ## Lists the usage detail records for all subscriptions belonging to a management group scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   managementGroupId: string (required)
  ##                    : Azure Management Group ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568541 = newJObject()
  var query_568542 = newJObject()
  add(query_568542, "$expand", newJString(Expand))
  add(query_568542, "api-version", newJString(apiVersion))
  add(path_568541, "managementGroupId", newJString(managementGroupId))
  add(query_568542, "$top", newJInt(Top))
  add(query_568542, "$skiptoken", newJString(Skiptoken))
  add(query_568542, "$apply", newJString(Apply))
  add(query_568542, "$filter", newJString(Filter))
  result = call_568540.call(path_568541, query_568542, nil, nil, nil)

var usageDetailsListByManagementGroup* = Call_UsageDetailsListByManagementGroup_568529(
    name: "usageDetailsListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByManagementGroup_568530, base: "",
    url: url_UsageDetailsListByManagementGroup_568531, schemes: {Scheme.Https})
type
  Call_MarketplacesListByBillingPeriod_568543 = ref object of OpenApiRestCall_567668
proc url_MarketplacesListByBillingPeriod_568545(protocol: Scheme; host: string;
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

proc validate_MarketplacesListByBillingPeriod_568544(path: JsonNode;
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
  var valid_568546 = path.getOrDefault("subscriptionId")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "subscriptionId", valid_568546
  var valid_568547 = path.getOrDefault("billingPeriodName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "billingPeriodName", valid_568547
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568548 = query.getOrDefault("api-version")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "api-version", valid_568548
  var valid_568549 = query.getOrDefault("$top")
  valid_568549 = validateParameter(valid_568549, JInt, required = false, default = nil)
  if valid_568549 != nil:
    section.add "$top", valid_568549
  var valid_568550 = query.getOrDefault("$skiptoken")
  valid_568550 = validateParameter(valid_568550, JString, required = false,
                                 default = nil)
  if valid_568550 != nil:
    section.add "$skiptoken", valid_568550
  var valid_568551 = query.getOrDefault("$filter")
  valid_568551 = validateParameter(valid_568551, JString, required = false,
                                 default = nil)
  if valid_568551 != nil:
    section.add "$filter", valid_568551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568552: Call_MarketplacesListByBillingPeriod_568543;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568552.validator(path, query, header, formData, body)
  let scheme = call_568552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568552.url(scheme.get, call_568552.host, call_568552.base,
                         call_568552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568552, url, valid)

proc call*(call_568553: Call_MarketplacesListByBillingPeriod_568543;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Top: int = 0; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## marketplacesListByBillingPeriod
  ## Lists the marketplaces for a scope by billing period and subscriptionId. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568554 = newJObject()
  var query_568555 = newJObject()
  add(query_568555, "api-version", newJString(apiVersion))
  add(path_568554, "subscriptionId", newJString(subscriptionId))
  add(query_568555, "$top", newJInt(Top))
  add(query_568555, "$skiptoken", newJString(Skiptoken))
  add(path_568554, "billingPeriodName", newJString(billingPeriodName))
  add(query_568555, "$filter", newJString(Filter))
  result = call_568553.call(path_568554, query_568555, nil, nil, nil)

var marketplacesListByBillingPeriod* = Call_MarketplacesListByBillingPeriod_568543(
    name: "marketplacesListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesListByBillingPeriod_568544, base: "",
    url: url_MarketplacesListByBillingPeriod_568545, schemes: {Scheme.Https})
type
  Call_PriceSheetGetByBillingPeriod_568556 = ref object of OpenApiRestCall_567668
proc url_PriceSheetGetByBillingPeriod_568558(protocol: Scheme; host: string;
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

proc validate_PriceSheetGetByBillingPeriod_568557(path: JsonNode; query: JsonNode;
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
  var valid_568559 = path.getOrDefault("subscriptionId")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "subscriptionId", valid_568559
  var valid_568560 = path.getOrDefault("billingPeriodName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "billingPeriodName", valid_568560
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the top N results.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  var valid_568561 = query.getOrDefault("$expand")
  valid_568561 = validateParameter(valid_568561, JString, required = false,
                                 default = nil)
  if valid_568561 != nil:
    section.add "$expand", valid_568561
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568562 = query.getOrDefault("api-version")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "api-version", valid_568562
  var valid_568563 = query.getOrDefault("$top")
  valid_568563 = validateParameter(valid_568563, JInt, required = false, default = nil)
  if valid_568563 != nil:
    section.add "$top", valid_568563
  var valid_568564 = query.getOrDefault("$skiptoken")
  valid_568564 = validateParameter(valid_568564, JString, required = false,
                                 default = nil)
  if valid_568564 != nil:
    section.add "$skiptoken", valid_568564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568565: Call_PriceSheetGetByBillingPeriod_568556; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568565.validator(path, query, header, formData, body)
  let scheme = call_568565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568565.url(scheme.get, call_568565.host, call_568565.base,
                         call_568565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568565, url, valid)

proc call*(call_568566: Call_PriceSheetGetByBillingPeriod_568556;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""): Recallable =
  ## priceSheetGetByBillingPeriod
  ## Get the price sheet for a scope by subscriptionId and billing period. Price sheet is available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the top N results.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  var path_568567 = newJObject()
  var query_568568 = newJObject()
  add(query_568568, "$expand", newJString(Expand))
  add(query_568568, "api-version", newJString(apiVersion))
  add(path_568567, "subscriptionId", newJString(subscriptionId))
  add(query_568568, "$top", newJInt(Top))
  add(query_568568, "$skiptoken", newJString(Skiptoken))
  add(path_568567, "billingPeriodName", newJString(billingPeriodName))
  result = call_568566.call(path_568567, query_568568, nil, nil, nil)

var priceSheetGetByBillingPeriod* = Call_PriceSheetGetByBillingPeriod_568556(
    name: "priceSheetGetByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGetByBillingPeriod_568557, base: "",
    url: url_PriceSheetGetByBillingPeriod_568558, schemes: {Scheme.Https})
type
  Call_UsageDetailsListByBillingPeriod_568569 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsListByBillingPeriod_568571(protocol: Scheme; host: string;
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

proc validate_UsageDetailsListByBillingPeriod_568570(path: JsonNode;
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
  var valid_568572 = path.getOrDefault("subscriptionId")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "subscriptionId", valid_568572
  var valid_568573 = path.getOrDefault("billingPeriodName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "billingPeriodName", valid_568573
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568574 = query.getOrDefault("$expand")
  valid_568574 = validateParameter(valid_568574, JString, required = false,
                                 default = nil)
  if valid_568574 != nil:
    section.add "$expand", valid_568574
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568575 = query.getOrDefault("api-version")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "api-version", valid_568575
  var valid_568576 = query.getOrDefault("$top")
  valid_568576 = validateParameter(valid_568576, JInt, required = false, default = nil)
  if valid_568576 != nil:
    section.add "$top", valid_568576
  var valid_568577 = query.getOrDefault("$skiptoken")
  valid_568577 = validateParameter(valid_568577, JString, required = false,
                                 default = nil)
  if valid_568577 != nil:
    section.add "$skiptoken", valid_568577
  var valid_568578 = query.getOrDefault("$apply")
  valid_568578 = validateParameter(valid_568578, JString, required = false,
                                 default = nil)
  if valid_568578 != nil:
    section.add "$apply", valid_568578
  var valid_568579 = query.getOrDefault("$filter")
  valid_568579 = validateParameter(valid_568579, JString, required = false,
                                 default = nil)
  if valid_568579 != nil:
    section.add "$filter", valid_568579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568580: Call_UsageDetailsListByBillingPeriod_568569;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568580.validator(path, query, header, formData, body)
  let scheme = call_568580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568580.url(scheme.get, call_568580.host, call_568580.base,
                         call_568580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568580, url, valid)

proc call*(call_568581: Call_UsageDetailsListByBillingPeriod_568569;
          apiVersion: string; subscriptionId: string; billingPeriodName: string;
          Expand: string = ""; Top: int = 0; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## usageDetailsListByBillingPeriod
  ## Lists the usage details for a scope by billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   billingPeriodName: string (required)
  ##                    : Billing Period Name.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart) for specified billing period
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568582 = newJObject()
  var query_568583 = newJObject()
  add(query_568583, "$expand", newJString(Expand))
  add(query_568583, "api-version", newJString(apiVersion))
  add(path_568582, "subscriptionId", newJString(subscriptionId))
  add(query_568583, "$top", newJInt(Top))
  add(query_568583, "$skiptoken", newJString(Skiptoken))
  add(path_568582, "billingPeriodName", newJString(billingPeriodName))
  add(query_568583, "$apply", newJString(Apply))
  add(query_568583, "$filter", newJString(Filter))
  result = call_568581.call(path_568582, query_568583, nil, nil, nil)

var usageDetailsListByBillingPeriod* = Call_UsageDetailsListByBillingPeriod_568569(
    name: "usageDetailsListByBillingPeriod", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingPeriods/{billingPeriodName}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsListByBillingPeriod_568570, base: "",
    url: url_UsageDetailsListByBillingPeriod_568571, schemes: {Scheme.Https})
type
  Call_BudgetsList_568584 = ref object of OpenApiRestCall_567668
proc url_BudgetsList_568586(protocol: Scheme; host: string; base: string;
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

proc validate_BudgetsList_568585(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568587 = path.getOrDefault("subscriptionId")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "subscriptionId", valid_568587
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568588 = query.getOrDefault("api-version")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "api-version", valid_568588
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568589: Call_BudgetsList_568584; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568589.validator(path, query, header, formData, body)
  let scheme = call_568589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568589.url(scheme.get, call_568589.host, call_568589.base,
                         call_568589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568589, url, valid)

proc call*(call_568590: Call_BudgetsList_568584; apiVersion: string;
          subscriptionId: string): Recallable =
  ## budgetsList
  ## Lists all budgets for a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568591 = newJObject()
  var query_568592 = newJObject()
  add(query_568592, "api-version", newJString(apiVersion))
  add(path_568591, "subscriptionId", newJString(subscriptionId))
  result = call_568590.call(path_568591, query_568592, nil, nil, nil)

var budgetsList* = Call_BudgetsList_568584(name: "budgetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets",
                                        validator: validate_BudgetsList_568585,
                                        base: "", url: url_BudgetsList_568586,
                                        schemes: {Scheme.Https})
type
  Call_BudgetsCreateOrUpdate_568603 = ref object of OpenApiRestCall_567668
proc url_BudgetsCreateOrUpdate_568605(protocol: Scheme; host: string; base: string;
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

proc validate_BudgetsCreateOrUpdate_568604(path: JsonNode; query: JsonNode;
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
  var valid_568606 = path.getOrDefault("subscriptionId")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "subscriptionId", valid_568606
  var valid_568607 = path.getOrDefault("budgetName")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "budgetName", valid_568607
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568608 = query.getOrDefault("api-version")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "api-version", valid_568608
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

proc call*(call_568610: Call_BudgetsCreateOrUpdate_568603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568610.validator(path, query, header, formData, body)
  let scheme = call_568610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568610.url(scheme.get, call_568610.host, call_568610.base,
                         call_568610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568610, url, valid)

proc call*(call_568611: Call_BudgetsCreateOrUpdate_568603; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; budgetName: string): Recallable =
  ## budgetsCreateOrUpdate
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568612 = newJObject()
  var query_568613 = newJObject()
  var body_568614 = newJObject()
  add(query_568613, "api-version", newJString(apiVersion))
  add(path_568612, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568614 = parameters
  add(path_568612, "budgetName", newJString(budgetName))
  result = call_568611.call(path_568612, query_568613, nil, nil, body_568614)

var budgetsCreateOrUpdate* = Call_BudgetsCreateOrUpdate_568603(
    name: "budgetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsCreateOrUpdate_568604, base: "",
    url: url_BudgetsCreateOrUpdate_568605, schemes: {Scheme.Https})
type
  Call_BudgetsGet_568593 = ref object of OpenApiRestCall_567668
proc url_BudgetsGet_568595(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BudgetsGet_568594(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568596 = path.getOrDefault("subscriptionId")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "subscriptionId", valid_568596
  var valid_568597 = path.getOrDefault("budgetName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "budgetName", valid_568597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568598 = query.getOrDefault("api-version")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "api-version", valid_568598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568599: Call_BudgetsGet_568593; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568599.validator(path, query, header, formData, body)
  let scheme = call_568599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568599.url(scheme.get, call_568599.host, call_568599.base,
                         call_568599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568599, url, valid)

proc call*(call_568600: Call_BudgetsGet_568593; apiVersion: string;
          subscriptionId: string; budgetName: string): Recallable =
  ## budgetsGet
  ## Gets the budget for a subscription by budget name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568601 = newJObject()
  var query_568602 = newJObject()
  add(query_568602, "api-version", newJString(apiVersion))
  add(path_568601, "subscriptionId", newJString(subscriptionId))
  add(path_568601, "budgetName", newJString(budgetName))
  result = call_568600.call(path_568601, query_568602, nil, nil, nil)

var budgetsGet* = Call_BudgetsGet_568593(name: "budgetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
                                      validator: validate_BudgetsGet_568594,
                                      base: "", url: url_BudgetsGet_568595,
                                      schemes: {Scheme.Https})
type
  Call_BudgetsDelete_568615 = ref object of OpenApiRestCall_567668
proc url_BudgetsDelete_568617(protocol: Scheme; host: string; base: string;
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

proc validate_BudgetsDelete_568616(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568618 = path.getOrDefault("subscriptionId")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "subscriptionId", valid_568618
  var valid_568619 = path.getOrDefault("budgetName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "budgetName", valid_568619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568620 = query.getOrDefault("api-version")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "api-version", valid_568620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568621: Call_BudgetsDelete_568615; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568621.validator(path, query, header, formData, body)
  let scheme = call_568621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568621.url(scheme.get, call_568621.host, call_568621.base,
                         call_568621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568621, url, valid)

proc call*(call_568622: Call_BudgetsDelete_568615; apiVersion: string;
          subscriptionId: string; budgetName: string): Recallable =
  ## budgetsDelete
  ## The operation to delete a budget.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568623 = newJObject()
  var query_568624 = newJObject()
  add(query_568624, "api-version", newJString(apiVersion))
  add(path_568623, "subscriptionId", newJString(subscriptionId))
  add(path_568623, "budgetName", newJString(budgetName))
  result = call_568622.call(path_568623, query_568624, nil, nil, nil)

var budgetsDelete* = Call_BudgetsDelete_568615(name: "budgetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsDelete_568616, base: "", url: url_BudgetsDelete_568617,
    schemes: {Scheme.Https})
type
  Call_ForecastsList_568625 = ref object of OpenApiRestCall_567668
proc url_ForecastsList_568627(protocol: Scheme; host: string; base: string;
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

proc validate_ForecastsList_568626(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568628 = path.getOrDefault("subscriptionId")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "subscriptionId", valid_568628
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $filter: JString
  ##          : May be used to filter forecasts by properties/usageDate (Utc time), properties/chargeType or properties/grain. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568629 = query.getOrDefault("api-version")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "api-version", valid_568629
  var valid_568630 = query.getOrDefault("$filter")
  valid_568630 = validateParameter(valid_568630, JString, required = false,
                                 default = nil)
  if valid_568630 != nil:
    section.add "$filter", valid_568630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568631: Call_ForecastsList_568625; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the forecast charges by subscriptionId.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568631.validator(path, query, header, formData, body)
  let scheme = call_568631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568631.url(scheme.get, call_568631.host, call_568631.base,
                         call_568631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568631, url, valid)

proc call*(call_568632: Call_ForecastsList_568625; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## forecastsList
  ## Lists the forecast charges by subscriptionId.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Filter: string
  ##         : May be used to filter forecasts by properties/usageDate (Utc time), properties/chargeType or properties/grain. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568633 = newJObject()
  var query_568634 = newJObject()
  add(query_568634, "api-version", newJString(apiVersion))
  add(path_568633, "subscriptionId", newJString(subscriptionId))
  add(query_568634, "$filter", newJString(Filter))
  result = call_568632.call(path_568633, query_568634, nil, nil, nil)

var forecastsList* = Call_ForecastsList_568625(name: "forecastsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/forecasts",
    validator: validate_ForecastsList_568626, base: "", url: url_ForecastsList_568627,
    schemes: {Scheme.Https})
type
  Call_MarketplacesList_568635 = ref object of OpenApiRestCall_567668
proc url_MarketplacesList_568637(protocol: Scheme; host: string; base: string;
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

proc validate_MarketplacesList_568636(path: JsonNode; query: JsonNode;
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
  var valid_568638 = path.getOrDefault("subscriptionId")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "subscriptionId", valid_568638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N marketplaces.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
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

proc call*(call_568643: Call_MarketplacesList_568635; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the marketplaces for a scope by subscriptionId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568643.validator(path, query, header, formData, body)
  let scheme = call_568643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568643.url(scheme.get, call_568643.host, call_568643.base,
                         call_568643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568643, url, valid)

proc call*(call_568644: Call_MarketplacesList_568635; apiVersion: string;
          subscriptionId: string; Top: int = 0; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## marketplacesList
  ## Lists the marketplaces for a scope by subscriptionId and current billing period. Marketplaces are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N marketplaces.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter marketplaces by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName or properties/instanceId. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'.
  var path_568645 = newJObject()
  var query_568646 = newJObject()
  add(query_568646, "api-version", newJString(apiVersion))
  add(path_568645, "subscriptionId", newJString(subscriptionId))
  add(query_568646, "$top", newJInt(Top))
  add(query_568646, "$skiptoken", newJString(Skiptoken))
  add(query_568646, "$filter", newJString(Filter))
  result = call_568644.call(path_568645, query_568646, nil, nil, nil)

var marketplacesList* = Call_MarketplacesList_568635(name: "marketplacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/marketplaces",
    validator: validate_MarketplacesList_568636, base: "",
    url: url_MarketplacesList_568637, schemes: {Scheme.Https})
type
  Call_PriceSheetGet_568647 = ref object of OpenApiRestCall_567668
proc url_PriceSheetGet_568649(protocol: Scheme; host: string; base: string;
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

proc validate_PriceSheetGet_568648(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568650 = path.getOrDefault("subscriptionId")
  valid_568650 = validateParameter(valid_568650, JString, required = true,
                                 default = nil)
  if valid_568650 != nil:
    section.add "subscriptionId", valid_568650
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the top N results.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  var valid_568651 = query.getOrDefault("$expand")
  valid_568651 = validateParameter(valid_568651, JString, required = false,
                                 default = nil)
  if valid_568651 != nil:
    section.add "$expand", valid_568651
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568652 = query.getOrDefault("api-version")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "api-version", valid_568652
  var valid_568653 = query.getOrDefault("$top")
  valid_568653 = validateParameter(valid_568653, JInt, required = false, default = nil)
  if valid_568653 != nil:
    section.add "$top", valid_568653
  var valid_568654 = query.getOrDefault("$skiptoken")
  valid_568654 = validateParameter(valid_568654, JString, required = false,
                                 default = nil)
  if valid_568654 != nil:
    section.add "$skiptoken", valid_568654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568655: Call_PriceSheetGet_568647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568655.validator(path, query, header, formData, body)
  let scheme = call_568655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568655.url(scheme.get, call_568655.host, call_568655.base,
                         call_568655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568655, url, valid)

proc call*(call_568656: Call_PriceSheetGet_568647; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""): Recallable =
  ## priceSheetGet
  ## Gets the price sheet for a scope by subscriptionId. Price sheet is available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/meterDetails within a price sheet. By default, these fields are not included when returning price sheet.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the top N results.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  var path_568657 = newJObject()
  var query_568658 = newJObject()
  add(query_568658, "$expand", newJString(Expand))
  add(query_568658, "api-version", newJString(apiVersion))
  add(path_568657, "subscriptionId", newJString(subscriptionId))
  add(query_568658, "$top", newJInt(Top))
  add(query_568658, "$skiptoken", newJString(Skiptoken))
  result = call_568656.call(path_568657, query_568658, nil, nil, nil)

var priceSheetGet* = Call_PriceSheetGet_568647(name: "priceSheetGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/pricesheets/default",
    validator: validate_PriceSheetGet_568648, base: "", url: url_PriceSheetGet_568649,
    schemes: {Scheme.Https})
type
  Call_ReservationRecommendationsList_568659 = ref object of OpenApiRestCall_567668
proc url_ReservationRecommendationsList_568661(protocol: Scheme; host: string;
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

proc validate_ReservationRecommendationsList_568660(path: JsonNode;
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
  var valid_568662 = path.getOrDefault("subscriptionId")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "subscriptionId", valid_568662
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $filter: JString
  ##          : May be used to filter reservationRecommendations by properties/scope and properties/lookBackPeriod.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568663 = query.getOrDefault("api-version")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "api-version", valid_568663
  var valid_568664 = query.getOrDefault("$filter")
  valid_568664 = validateParameter(valid_568664, JString, required = false,
                                 default = nil)
  if valid_568664 != nil:
    section.add "$filter", valid_568664
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568665: Call_ReservationRecommendationsList_568659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of recommendations for purchasing reserved instances.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568665.validator(path, query, header, formData, body)
  let scheme = call_568665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568665.url(scheme.get, call_568665.host, call_568665.base,
                         call_568665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568665, url, valid)

proc call*(call_568666: Call_ReservationRecommendationsList_568659;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## reservationRecommendationsList
  ## List of recommendations for purchasing reserved instances.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Filter: string
  ##         : May be used to filter reservationRecommendations by properties/scope and properties/lookBackPeriod.
  var path_568667 = newJObject()
  var query_568668 = newJObject()
  add(query_568668, "api-version", newJString(apiVersion))
  add(path_568667, "subscriptionId", newJString(subscriptionId))
  add(query_568668, "$filter", newJString(Filter))
  result = call_568666.call(path_568667, query_568668, nil, nil, nil)

var reservationRecommendationsList* = Call_ReservationRecommendationsList_568659(
    name: "reservationRecommendationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/reservationRecommendations",
    validator: validate_ReservationRecommendationsList_568660, base: "",
    url: url_ReservationRecommendationsList_568661, schemes: {Scheme.Https})
type
  Call_UsageDetailsList_568669 = ref object of OpenApiRestCall_567668
proc url_UsageDetailsList_568671(protocol: Scheme; host: string; base: string;
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

proc validate_UsageDetailsList_568670(path: JsonNode; query: JsonNode;
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
  var valid_568672 = path.getOrDefault("subscriptionId")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "subscriptionId", valid_568672
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $apply: JString
  ##         : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   $filter: JString
  ##          : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  var valid_568673 = query.getOrDefault("$expand")
  valid_568673 = validateParameter(valid_568673, JString, required = false,
                                 default = nil)
  if valid_568673 != nil:
    section.add "$expand", valid_568673
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568674 = query.getOrDefault("api-version")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "api-version", valid_568674
  var valid_568675 = query.getOrDefault("$top")
  valid_568675 = validateParameter(valid_568675, JInt, required = false, default = nil)
  if valid_568675 != nil:
    section.add "$top", valid_568675
  var valid_568676 = query.getOrDefault("$skiptoken")
  valid_568676 = validateParameter(valid_568676, JString, required = false,
                                 default = nil)
  if valid_568676 != nil:
    section.add "$skiptoken", valid_568676
  var valid_568677 = query.getOrDefault("$apply")
  valid_568677 = validateParameter(valid_568677, JString, required = false,
                                 default = nil)
  if valid_568677 != nil:
    section.add "$apply", valid_568677
  var valid_568678 = query.getOrDefault("$filter")
  valid_568678 = validateParameter(valid_568678, JString, required = false,
                                 default = nil)
  if valid_568678 != nil:
    section.add "$filter", valid_568678
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568679: Call_UsageDetailsList_568669; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the usage details for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568679.validator(path, query, header, formData, body)
  let scheme = call_568679.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568679.url(scheme.get, call_568679.host, call_568679.base,
                         call_568679.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568679, url, valid)

proc call*(call_568680: Call_UsageDetailsList_568669; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0;
          Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## usageDetailsList
  ## Lists the usage details for a scope by current billing period. Usage details are available via this API only for May 1, 2014 or later.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   Expand: string
  ##         : May be used to expand the properties/additionalProperties or properties/meterDetails within a list of usage details. By default, these fields are not included when listing usage details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Apply: string
  ##        : OData apply expression to aggregate usageDetails by tags or (tags and properties/usageStart)
  ##   Filter: string
  ##         : May be used to filter usageDetails by properties/usageEnd (Utc time), properties/usageStart (Utc time), properties/resourceGroup, properties/instanceName, properties/instanceId or tags. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_568681 = newJObject()
  var query_568682 = newJObject()
  add(query_568682, "$expand", newJString(Expand))
  add(query_568682, "api-version", newJString(apiVersion))
  add(path_568681, "subscriptionId", newJString(subscriptionId))
  add(query_568682, "$top", newJInt(Top))
  add(query_568682, "$skiptoken", newJString(Skiptoken))
  add(query_568682, "$apply", newJString(Apply))
  add(query_568682, "$filter", newJString(Filter))
  result = call_568680.call(path_568681, query_568682, nil, nil, nil)

var usageDetailsList* = Call_UsageDetailsList_568669(name: "usageDetailsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/usageDetails",
    validator: validate_UsageDetailsList_568670, base: "",
    url: url_UsageDetailsList_568671, schemes: {Scheme.Https})
type
  Call_BudgetsListByResourceGroupName_568683 = ref object of OpenApiRestCall_567668
proc url_BudgetsListByResourceGroupName_568685(protocol: Scheme; host: string;
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

proc validate_BudgetsListByResourceGroupName_568684(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all budgets for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
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
  var valid_568686 = path.getOrDefault("resourceGroupName")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "resourceGroupName", valid_568686
  var valid_568687 = path.getOrDefault("subscriptionId")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "subscriptionId", valid_568687
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568688 = query.getOrDefault("api-version")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "api-version", valid_568688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568689: Call_BudgetsListByResourceGroupName_568683; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all budgets for a resource group under a subscription.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568689.validator(path, query, header, formData, body)
  let scheme = call_568689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568689.url(scheme.get, call_568689.host, call_568689.base,
                         call_568689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568689, url, valid)

proc call*(call_568690: Call_BudgetsListByResourceGroupName_568683;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## budgetsListByResourceGroupName
  ## Lists all budgets for a resource group under a subscription.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568691 = newJObject()
  var query_568692 = newJObject()
  add(path_568691, "resourceGroupName", newJString(resourceGroupName))
  add(query_568692, "api-version", newJString(apiVersion))
  add(path_568691, "subscriptionId", newJString(subscriptionId))
  result = call_568690.call(path_568691, query_568692, nil, nil, nil)

var budgetsListByResourceGroupName* = Call_BudgetsListByResourceGroupName_568683(
    name: "budgetsListByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets",
    validator: validate_BudgetsListByResourceGroupName_568684, base: "",
    url: url_BudgetsListByResourceGroupName_568685, schemes: {Scheme.Https})
type
  Call_BudgetsCreateOrUpdateByResourceGroupName_568704 = ref object of OpenApiRestCall_567668
proc url_BudgetsCreateOrUpdateByResourceGroupName_568706(protocol: Scheme;
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

proc validate_BudgetsCreateOrUpdateByResourceGroupName_568705(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568707 = path.getOrDefault("resourceGroupName")
  valid_568707 = validateParameter(valid_568707, JString, required = true,
                                 default = nil)
  if valid_568707 != nil:
    section.add "resourceGroupName", valid_568707
  var valid_568708 = path.getOrDefault("subscriptionId")
  valid_568708 = validateParameter(valid_568708, JString, required = true,
                                 default = nil)
  if valid_568708 != nil:
    section.add "subscriptionId", valid_568708
  var valid_568709 = path.getOrDefault("budgetName")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "budgetName", valid_568709
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568710 = query.getOrDefault("api-version")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "api-version", valid_568710
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

proc call*(call_568712: Call_BudgetsCreateOrUpdateByResourceGroupName_568704;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568712.validator(path, query, header, formData, body)
  let scheme = call_568712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568712.url(scheme.get, call_568712.host, call_568712.base,
                         call_568712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568712, url, valid)

proc call*(call_568713: Call_BudgetsCreateOrUpdateByResourceGroupName_568704;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; budgetName: string): Recallable =
  ## budgetsCreateOrUpdateByResourceGroupName
  ## The operation to create or update a budget. Update operation requires latest eTag to be set in the request mandatorily. You may obtain the latest eTag by performing a get operation. Create operation does not require eTag.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Budget operation.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568714 = newJObject()
  var query_568715 = newJObject()
  var body_568716 = newJObject()
  add(path_568714, "resourceGroupName", newJString(resourceGroupName))
  add(query_568715, "api-version", newJString(apiVersion))
  add(path_568714, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568716 = parameters
  add(path_568714, "budgetName", newJString(budgetName))
  result = call_568713.call(path_568714, query_568715, nil, nil, body_568716)

var budgetsCreateOrUpdateByResourceGroupName* = Call_BudgetsCreateOrUpdateByResourceGroupName_568704(
    name: "budgetsCreateOrUpdateByResourceGroupName", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsCreateOrUpdateByResourceGroupName_568705, base: "",
    url: url_BudgetsCreateOrUpdateByResourceGroupName_568706,
    schemes: {Scheme.Https})
type
  Call_BudgetsGetByResourceGroupName_568693 = ref object of OpenApiRestCall_567668
proc url_BudgetsGetByResourceGroupName_568695(protocol: Scheme; host: string;
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

proc validate_BudgetsGetByResourceGroupName_568694(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the budget for a resource group under a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568696 = path.getOrDefault("resourceGroupName")
  valid_568696 = validateParameter(valid_568696, JString, required = true,
                                 default = nil)
  if valid_568696 != nil:
    section.add "resourceGroupName", valid_568696
  var valid_568697 = path.getOrDefault("subscriptionId")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "subscriptionId", valid_568697
  var valid_568698 = path.getOrDefault("budgetName")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "budgetName", valid_568698
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568699 = query.getOrDefault("api-version")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "api-version", valid_568699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568700: Call_BudgetsGetByResourceGroupName_568693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the budget for a resource group under a subscription by budget name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568700.validator(path, query, header, formData, body)
  let scheme = call_568700.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568700.url(scheme.get, call_568700.host, call_568700.base,
                         call_568700.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568700, url, valid)

proc call*(call_568701: Call_BudgetsGetByResourceGroupName_568693;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          budgetName: string): Recallable =
  ## budgetsGetByResourceGroupName
  ## Gets the budget for a resource group under a subscription by budget name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568702 = newJObject()
  var query_568703 = newJObject()
  add(path_568702, "resourceGroupName", newJString(resourceGroupName))
  add(query_568703, "api-version", newJString(apiVersion))
  add(path_568702, "subscriptionId", newJString(subscriptionId))
  add(path_568702, "budgetName", newJString(budgetName))
  result = call_568701.call(path_568702, query_568703, nil, nil, nil)

var budgetsGetByResourceGroupName* = Call_BudgetsGetByResourceGroupName_568693(
    name: "budgetsGetByResourceGroupName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsGetByResourceGroupName_568694, base: "",
    url: url_BudgetsGetByResourceGroupName_568695, schemes: {Scheme.Https})
type
  Call_BudgetsDeleteByResourceGroupName_568717 = ref object of OpenApiRestCall_567668
proc url_BudgetsDeleteByResourceGroupName_568719(protocol: Scheme; host: string;
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

proc validate_BudgetsDeleteByResourceGroupName_568718(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure Resource Group Name.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: JString (required)
  ##             : Budget Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568720 = path.getOrDefault("resourceGroupName")
  valid_568720 = validateParameter(valid_568720, JString, required = true,
                                 default = nil)
  if valid_568720 != nil:
    section.add "resourceGroupName", valid_568720
  var valid_568721 = path.getOrDefault("subscriptionId")
  valid_568721 = validateParameter(valid_568721, JString, required = true,
                                 default = nil)
  if valid_568721 != nil:
    section.add "subscriptionId", valid_568721
  var valid_568722 = path.getOrDefault("budgetName")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "budgetName", valid_568722
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-08-31.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568723 = query.getOrDefault("api-version")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "api-version", valid_568723
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568724: Call_BudgetsDeleteByResourceGroupName_568717;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a budget.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568724.validator(path, query, header, formData, body)
  let scheme = call_568724.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568724.url(scheme.get, call_568724.host, call_568724.base,
                         call_568724.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568724, url, valid)

proc call*(call_568725: Call_BudgetsDeleteByResourceGroupName_568717;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          budgetName: string): Recallable =
  ## budgetsDeleteByResourceGroupName
  ## The operation to delete a budget.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   resourceGroupName: string (required)
  ##                    : Azure Resource Group Name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-08-31.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   budgetName: string (required)
  ##             : Budget Name.
  var path_568726 = newJObject()
  var query_568727 = newJObject()
  add(path_568726, "resourceGroupName", newJString(resourceGroupName))
  add(query_568727, "api-version", newJString(apiVersion))
  add(path_568726, "subscriptionId", newJString(subscriptionId))
  add(path_568726, "budgetName", newJString(budgetName))
  result = call_568725.call(path_568726, query_568727, nil, nil, nil)

var budgetsDeleteByResourceGroupName* = Call_BudgetsDeleteByResourceGroupName_568717(
    name: "budgetsDeleteByResourceGroupName", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Consumption/budgets/{budgetName}",
    validator: validate_BudgetsDeleteByResourceGroupName_568718, base: "",
    url: url_BudgetsDeleteByResourceGroupName_568719, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
