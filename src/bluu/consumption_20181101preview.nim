
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ConsumptionManagementClient
## version: 2018-11-01-preview
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

  OpenApiRestCall_567659 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567659](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567659): Option[Scheme] {.used.} =
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
  Call_ChargesByBillingProfileList_567881 = ref object of OpenApiRestCall_567659
proc url_ChargesByBillingProfileList_567883(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/charges")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChargesByBillingProfileList_567882(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the charges by billing profile id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  ##   billingProfileId: JString (required)
  ##                   : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568056 = path.getOrDefault("billingAccountId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "billingAccountId", valid_568056
  var valid_568057 = path.getOrDefault("billingProfileId")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "billingProfileId", valid_568057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568058 = query.getOrDefault("api-version")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "api-version", valid_568058
  var valid_568059 = query.getOrDefault("endDate")
  valid_568059 = validateParameter(valid_568059, JString, required = true,
                                 default = nil)
  if valid_568059 != nil:
    section.add "endDate", valid_568059
  var valid_568060 = query.getOrDefault("startDate")
  valid_568060 = validateParameter(valid_568060, JString, required = true,
                                 default = nil)
  if valid_568060 != nil:
    section.add "startDate", valid_568060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568083: Call_ChargesByBillingProfileList_567881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by billing profile id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568083.validator(path, query, header, formData, body)
  let scheme = call_568083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568083.url(scheme.get, call_568083.host, call_568083.base,
                         call_568083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568083, url, valid)

proc call*(call_568154: Call_ChargesByBillingProfileList_567881;
          apiVersion: string; endDate: string; startDate: string;
          billingAccountId: string; billingProfileId: string): Recallable =
  ## chargesByBillingProfileList
  ## Lists the charges by billing profile id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   startDate: string (required)
  ##            : Start date
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   billingProfileId: string (required)
  ##                   : Billing Profile Id.
  var path_568155 = newJObject()
  var query_568157 = newJObject()
  add(query_568157, "api-version", newJString(apiVersion))
  add(query_568157, "endDate", newJString(endDate))
  add(query_568157, "startDate", newJString(startDate))
  add(path_568155, "billingAccountId", newJString(billingAccountId))
  add(path_568155, "billingProfileId", newJString(billingProfileId))
  result = call_568154.call(path_568155, query_568157, nil, nil, nil)

var chargesByBillingProfileList* = Call_ChargesByBillingProfileList_567881(
    name: "chargesByBillingProfileList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesByBillingProfileList_567882, base: "",
    url: url_ChargesByBillingProfileList_567883, schemes: {Scheme.Https})
type
  Call_CreditSummaryByBillingProfileGet_568196 = ref object of OpenApiRestCall_567659
proc url_CreditSummaryByBillingProfileGet_568198(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Consumption/credits/balanceSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CreditSummaryByBillingProfileGet_568197(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The credit summary by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  ##   billingProfileId: JString (required)
  ##                   : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568199 = path.getOrDefault("billingAccountId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "billingAccountId", valid_568199
  var valid_568200 = path.getOrDefault("billingProfileId")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "billingProfileId", valid_568200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568201 = query.getOrDefault("api-version")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "api-version", valid_568201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568202: Call_CreditSummaryByBillingProfileGet_568196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The credit summary by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568202.validator(path, query, header, formData, body)
  let scheme = call_568202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568202.url(scheme.get, call_568202.host, call_568202.base,
                         call_568202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568202, url, valid)

proc call*(call_568203: Call_CreditSummaryByBillingProfileGet_568196;
          apiVersion: string; billingAccountId: string; billingProfileId: string): Recallable =
  ## creditSummaryByBillingProfileGet
  ## The credit summary by billingAccountId and billingProfileId for given start and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   billingProfileId: string (required)
  ##                   : Billing Profile Id.
  var path_568204 = newJObject()
  var query_568205 = newJObject()
  add(query_568205, "api-version", newJString(apiVersion))
  add(path_568204, "billingAccountId", newJString(billingAccountId))
  add(path_568204, "billingProfileId", newJString(billingProfileId))
  result = call_568203.call(path_568204, query_568205, nil, nil, nil)

var creditSummaryByBillingProfileGet* = Call_CreditSummaryByBillingProfileGet_568196(
    name: "creditSummaryByBillingProfileGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/credits/balanceSummary",
    validator: validate_CreditSummaryByBillingProfileGet_568197, base: "",
    url: url_CreditSummaryByBillingProfileGet_568198, schemes: {Scheme.Https})
type
  Call_EventsByBillingProfileList_568206 = ref object of OpenApiRestCall_567659
proc url_EventsByBillingProfileList_568208(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/events")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsByBillingProfileList_568207(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the events by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  ##   billingProfileId: JString (required)
  ##                   : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568209 = path.getOrDefault("billingAccountId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "billingAccountId", valid_568209
  var valid_568210 = path.getOrDefault("billingProfileId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "billingProfileId", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  var valid_568212 = query.getOrDefault("endDate")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "endDate", valid_568212
  var valid_568213 = query.getOrDefault("startDate")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "startDate", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_EventsByBillingProfileList_568206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the events by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_EventsByBillingProfileList_568206; apiVersion: string;
          endDate: string; startDate: string; billingAccountId: string;
          billingProfileId: string): Recallable =
  ## eventsByBillingProfileList
  ## Lists the events by billingAccountId and billingProfileId for given start and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   startDate: string (required)
  ##            : Start date
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   billingProfileId: string (required)
  ##                   : Billing Profile Id.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(query_568217, "api-version", newJString(apiVersion))
  add(query_568217, "endDate", newJString(endDate))
  add(query_568217, "startDate", newJString(startDate))
  add(path_568216, "billingAccountId", newJString(billingAccountId))
  add(path_568216, "billingProfileId", newJString(billingProfileId))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var eventsByBillingProfileList* = Call_EventsByBillingProfileList_568206(
    name: "eventsByBillingProfileList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/events",
    validator: validate_EventsByBillingProfileList_568207, base: "",
    url: url_EventsByBillingProfileList_568208, schemes: {Scheme.Https})
type
  Call_LotsByBillingProfileList_568218 = ref object of OpenApiRestCall_567659
proc url_LotsByBillingProfileList_568220(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/lots")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LotsByBillingProfileList_568219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the lots by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  ##   billingProfileId: JString (required)
  ##                   : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568221 = path.getOrDefault("billingAccountId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "billingAccountId", valid_568221
  var valid_568222 = path.getOrDefault("billingProfileId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "billingProfileId", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_LotsByBillingProfileList_568218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the lots by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_LotsByBillingProfileList_568218; apiVersion: string;
          billingAccountId: string; billingProfileId: string): Recallable =
  ## lotsByBillingProfileList
  ## Lists the lots by billingAccountId and billingProfileId for given start and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   billingProfileId: string (required)
  ##                   : Billing Profile Id.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "billingAccountId", newJString(billingAccountId))
  add(path_568226, "billingProfileId", newJString(billingProfileId))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var lotsByBillingProfileList* = Call_LotsByBillingProfileList_568218(
    name: "lotsByBillingProfileList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/lots",
    validator: validate_LotsByBillingProfileList_568219, base: "",
    url: url_LotsByBillingProfileList_568220, schemes: {Scheme.Https})
type
  Call_ChargesByInvoiceSectionList_568228 = ref object of OpenApiRestCall_567659
proc url_ChargesByInvoiceSectionList_568230(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "invoiceSectionId" in path,
        "`invoiceSectionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/charges")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChargesByInvoiceSectionList_568229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the charges by invoice section id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  ##   invoiceSectionId: JString (required)
  ##                   : Invoice Section Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568232 = path.getOrDefault("billingAccountId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "billingAccountId", valid_568232
  var valid_568233 = path.getOrDefault("invoiceSectionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "invoiceSectionId", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $apply: JString
  ##         : May be used to group charges by properties/productName.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  var valid_568235 = query.getOrDefault("endDate")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "endDate", valid_568235
  var valid_568236 = query.getOrDefault("startDate")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "startDate", valid_568236
  var valid_568237 = query.getOrDefault("$apply")
  valid_568237 = validateParameter(valid_568237, JString, required = false,
                                 default = nil)
  if valid_568237 != nil:
    section.add "$apply", valid_568237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568238: Call_ChargesByInvoiceSectionList_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by invoice section id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568238.validator(path, query, header, formData, body)
  let scheme = call_568238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568238.url(scheme.get, call_568238.host, call_568238.base,
                         call_568238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568238, url, valid)

proc call*(call_568239: Call_ChargesByInvoiceSectionList_568228;
          apiVersion: string; endDate: string; startDate: string;
          billingAccountId: string; invoiceSectionId: string; Apply: string = ""): Recallable =
  ## chargesByInvoiceSectionList
  ## Lists the charges by invoice section id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   startDate: string (required)
  ##            : Start date
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Apply: string
  ##        : May be used to group charges by properties/productName.
  ##   invoiceSectionId: string (required)
  ##                   : Invoice Section Id.
  var path_568240 = newJObject()
  var query_568241 = newJObject()
  add(query_568241, "api-version", newJString(apiVersion))
  add(query_568241, "endDate", newJString(endDate))
  add(query_568241, "startDate", newJString(startDate))
  add(path_568240, "billingAccountId", newJString(billingAccountId))
  add(query_568241, "$apply", newJString(Apply))
  add(path_568240, "invoiceSectionId", newJString(invoiceSectionId))
  result = call_568239.call(path_568240, query_568241, nil, nil, nil)

var chargesByInvoiceSectionList* = Call_ChargesByInvoiceSectionList_568228(
    name: "chargesByInvoiceSectionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesByInvoiceSectionList_568229, base: "",
    url: url_ChargesByInvoiceSectionList_568230, schemes: {Scheme.Https})
type
  Call_ChargesByBillingAccountList_568242 = ref object of OpenApiRestCall_567659
proc url_ChargesByBillingAccountList_568244(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Consumption/charges")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChargesByBillingAccountList_568243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the charges by billingAccountId for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
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
  var valid_568245 = path.getOrDefault("billingAccountId")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "billingAccountId", valid_568245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $apply: JString
  ##         : May be used to group charges by properties/billingProfileId, or properties/invoiceSectionId.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568246 = query.getOrDefault("api-version")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "api-version", valid_568246
  var valid_568247 = query.getOrDefault("endDate")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "endDate", valid_568247
  var valid_568248 = query.getOrDefault("startDate")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "startDate", valid_568248
  var valid_568249 = query.getOrDefault("$apply")
  valid_568249 = validateParameter(valid_568249, JString, required = false,
                                 default = nil)
  if valid_568249 != nil:
    section.add "$apply", valid_568249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568250: Call_ChargesByBillingAccountList_568242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by billingAccountId for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_ChargesByBillingAccountList_568242;
          apiVersion: string; endDate: string; startDate: string;
          billingAccountId: string; Apply: string = ""): Recallable =
  ## chargesByBillingAccountList
  ## Lists the charges by billingAccountId for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   startDate: string (required)
  ##            : Start date
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   Apply: string
  ##        : May be used to group charges by properties/billingProfileId, or properties/invoiceSectionId.
  var path_568252 = newJObject()
  var query_568253 = newJObject()
  add(query_568253, "api-version", newJString(apiVersion))
  add(query_568253, "endDate", newJString(endDate))
  add(query_568253, "startDate", newJString(startDate))
  add(path_568252, "billingAccountId", newJString(billingAccountId))
  add(query_568253, "$apply", newJString(Apply))
  result = call_568251.call(path_568252, query_568253, nil, nil, nil)

var chargesByBillingAccountList* = Call_ChargesByBillingAccountList_568242(
    name: "chargesByBillingAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesByBillingAccountList_568243, base: "",
    url: url_ChargesByBillingAccountList_568244, schemes: {Scheme.Https})
type
  Call_BillingProfilePricesheetDownload_568254 = ref object of OpenApiRestCall_567659
proc url_BillingProfilePricesheetDownload_568256(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
                value: "/providers/Microsoft.Consumption/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileId"),
               (kind: ConstantSegment, value: "/pricesheet/default/download")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingProfilePricesheetDownload_568255(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get pricesheet data for invoice id (invoiceName).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountId: JString (required)
  ##                   : Azure Billing Account Id.
  ##   billingProfileId: JString (required)
  ##                   : Azure Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountId` field"
  var valid_568257 = path.getOrDefault("billingAccountId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "billingAccountId", valid_568257
  var valid_568258 = path.getOrDefault("billingProfileId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "billingProfileId", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_BillingProfilePricesheetDownload_568254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get pricesheet data for invoice id (invoiceName).
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_BillingProfilePricesheetDownload_568254;
          apiVersion: string; billingAccountId: string; billingProfileId: string): Recallable =
  ## billingProfilePricesheetDownload
  ## Get pricesheet data for invoice id (invoiceName).
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountId: string (required)
  ##                   : Azure Billing Account Id.
  ##   billingProfileId: string (required)
  ##                   : Azure Billing Profile Id.
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "billingAccountId", newJString(billingAccountId))
  add(path_568262, "billingProfileId", newJString(billingProfileId))
  result = call_568261.call(path_568262, query_568263, nil, nil, nil)

var billingProfilePricesheetDownload* = Call_BillingProfilePricesheetDownload_568254(
    name: "billingProfilePricesheetDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Consumption/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/pricesheet/default/download",
    validator: validate_BillingProfilePricesheetDownload_568255, base: "",
    url: url_BillingProfilePricesheetDownload_568256, schemes: {Scheme.Https})
type
  Call_InvoicePricesheetDownload_568264 = ref object of OpenApiRestCall_567659
proc url_InvoicePricesheetDownload_568266(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountId" in path,
        "`billingAccountId` is a required path parameter"
  assert "invoiceName" in path, "`invoiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Consumption/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountId"),
               (kind: ConstantSegment, value: "/invoices/"),
               (kind: VariableSegment, value: "invoiceName"),
               (kind: ConstantSegment, value: "/pricesheet/default/download")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoicePricesheetDownload_568265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get pricesheet data for invoice id (invoiceName).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   invoiceName: JString (required)
  ##              : The name of an invoice resource.
  ##   billingAccountId: JString (required)
  ##                   : Azure Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `invoiceName` field"
  var valid_568267 = path.getOrDefault("invoiceName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "invoiceName", valid_568267
  var valid_568268 = path.getOrDefault("billingAccountId")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "billingAccountId", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_InvoicePricesheetDownload_568264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get pricesheet data for invoice id (invoiceName).
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_InvoicePricesheetDownload_568264; apiVersion: string;
          invoiceName: string; billingAccountId: string): Recallable =
  ## invoicePricesheetDownload
  ## Get pricesheet data for invoice id (invoiceName).
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   invoiceName: string (required)
  ##              : The name of an invoice resource.
  ##   billingAccountId: string (required)
  ##                   : Azure Billing Account Id.
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  add(query_568273, "api-version", newJString(apiVersion))
  add(path_568272, "invoiceName", newJString(invoiceName))
  add(path_568272, "billingAccountId", newJString(billingAccountId))
  result = call_568271.call(path_568272, query_568273, nil, nil, nil)

var invoicePricesheetDownload* = Call_InvoicePricesheetDownload_568264(
    name: "invoicePricesheetDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Consumption/billingAccounts/{billingAccountId}/invoices/{invoiceName}/pricesheet/default/download",
    validator: validate_InvoicePricesheetDownload_568265, base: "",
    url: url_InvoicePricesheetDownload_568266, schemes: {Scheme.Https})
type
  Call_OperationsList_568274 = ref object of OpenApiRestCall_567659
proc url_OperationsList_568276(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568275(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_OperationsList_568274; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_OperationsList_568274; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  var query_568280 = newJObject()
  add(query_568280, "api-version", newJString(apiVersion))
  result = call_568279.call(nil, query_568280, nil, nil, nil)

var operationsList* = Call_OperationsList_568274(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Consumption/operations",
    validator: validate_OperationsList_568275, base: "", url: url_OperationsList_568276,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
