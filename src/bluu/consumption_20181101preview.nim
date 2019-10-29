
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563557 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563557](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563557): Option[Scheme] {.used.} =
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
  Call_ChargesByBillingProfileList_563779 = ref object of OpenApiRestCall_563557
proc url_ChargesByBillingProfileList_563781(protocol: Scheme; host: string;
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

proc validate_ChargesByBillingProfileList_563780(path: JsonNode; query: JsonNode;
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
  var valid_563956 = path.getOrDefault("billingAccountId")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "billingAccountId", valid_563956
  var valid_563957 = path.getOrDefault("billingProfileId")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "billingProfileId", valid_563957
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
  var valid_563958 = query.getOrDefault("api-version")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = nil)
  if valid_563958 != nil:
    section.add "api-version", valid_563958
  var valid_563959 = query.getOrDefault("endDate")
  valid_563959 = validateParameter(valid_563959, JString, required = true,
                                 default = nil)
  if valid_563959 != nil:
    section.add "endDate", valid_563959
  var valid_563960 = query.getOrDefault("startDate")
  valid_563960 = validateParameter(valid_563960, JString, required = true,
                                 default = nil)
  if valid_563960 != nil:
    section.add "startDate", valid_563960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563983: Call_ChargesByBillingProfileList_563779; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by billing profile id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_563983.validator(path, query, header, formData, body)
  let scheme = call_563983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563983.url(scheme.get, call_563983.host, call_563983.base,
                         call_563983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563983, url, valid)

proc call*(call_564054: Call_ChargesByBillingProfileList_563779;
          apiVersion: string; endDate: string; billingAccountId: string;
          startDate: string; billingProfileId: string): Recallable =
  ## chargesByBillingProfileList
  ## Lists the charges by billing profile id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   startDate: string (required)
  ##            : Start date
  ##   billingProfileId: string (required)
  ##                   : Billing Profile Id.
  var path_564055 = newJObject()
  var query_564057 = newJObject()
  add(query_564057, "api-version", newJString(apiVersion))
  add(query_564057, "endDate", newJString(endDate))
  add(path_564055, "billingAccountId", newJString(billingAccountId))
  add(query_564057, "startDate", newJString(startDate))
  add(path_564055, "billingProfileId", newJString(billingProfileId))
  result = call_564054.call(path_564055, query_564057, nil, nil, nil)

var chargesByBillingProfileList* = Call_ChargesByBillingProfileList_563779(
    name: "chargesByBillingProfileList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesByBillingProfileList_563780, base: "",
    url: url_ChargesByBillingProfileList_563781, schemes: {Scheme.Https})
type
  Call_CreditSummaryByBillingProfileGet_564096 = ref object of OpenApiRestCall_563557
proc url_CreditSummaryByBillingProfileGet_564098(protocol: Scheme; host: string;
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

proc validate_CreditSummaryByBillingProfileGet_564097(path: JsonNode;
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
  var valid_564099 = path.getOrDefault("billingAccountId")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "billingAccountId", valid_564099
  var valid_564100 = path.getOrDefault("billingProfileId")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "billingProfileId", valid_564100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564101 = query.getOrDefault("api-version")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "api-version", valid_564101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564102: Call_CreditSummaryByBillingProfileGet_564096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The credit summary by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564102.validator(path, query, header, formData, body)
  let scheme = call_564102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564102.url(scheme.get, call_564102.host, call_564102.base,
                         call_564102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564102, url, valid)

proc call*(call_564103: Call_CreditSummaryByBillingProfileGet_564096;
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
  var path_564104 = newJObject()
  var query_564105 = newJObject()
  add(query_564105, "api-version", newJString(apiVersion))
  add(path_564104, "billingAccountId", newJString(billingAccountId))
  add(path_564104, "billingProfileId", newJString(billingProfileId))
  result = call_564103.call(path_564104, query_564105, nil, nil, nil)

var creditSummaryByBillingProfileGet* = Call_CreditSummaryByBillingProfileGet_564096(
    name: "creditSummaryByBillingProfileGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/credits/balanceSummary",
    validator: validate_CreditSummaryByBillingProfileGet_564097, base: "",
    url: url_CreditSummaryByBillingProfileGet_564098, schemes: {Scheme.Https})
type
  Call_EventsByBillingProfileList_564106 = ref object of OpenApiRestCall_563557
proc url_EventsByBillingProfileList_564108(protocol: Scheme; host: string;
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

proc validate_EventsByBillingProfileList_564107(path: JsonNode; query: JsonNode;
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
  var valid_564109 = path.getOrDefault("billingAccountId")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "billingAccountId", valid_564109
  var valid_564110 = path.getOrDefault("billingProfileId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "billingProfileId", valid_564110
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
  var valid_564111 = query.getOrDefault("api-version")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "api-version", valid_564111
  var valid_564112 = query.getOrDefault("endDate")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "endDate", valid_564112
  var valid_564113 = query.getOrDefault("startDate")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "startDate", valid_564113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_EventsByBillingProfileList_564106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the events by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564114.validator(path, query, header, formData, body)
  let scheme = call_564114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564114.url(scheme.get, call_564114.host, call_564114.base,
                         call_564114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564114, url, valid)

proc call*(call_564115: Call_EventsByBillingProfileList_564106; apiVersion: string;
          endDate: string; billingAccountId: string; startDate: string;
          billingProfileId: string): Recallable =
  ## eventsByBillingProfileList
  ## Lists the events by billingAccountId and billingProfileId for given start and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   startDate: string (required)
  ##            : Start date
  ##   billingProfileId: string (required)
  ##                   : Billing Profile Id.
  var path_564116 = newJObject()
  var query_564117 = newJObject()
  add(query_564117, "api-version", newJString(apiVersion))
  add(query_564117, "endDate", newJString(endDate))
  add(path_564116, "billingAccountId", newJString(billingAccountId))
  add(query_564117, "startDate", newJString(startDate))
  add(path_564116, "billingProfileId", newJString(billingProfileId))
  result = call_564115.call(path_564116, query_564117, nil, nil, nil)

var eventsByBillingProfileList* = Call_EventsByBillingProfileList_564106(
    name: "eventsByBillingProfileList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/events",
    validator: validate_EventsByBillingProfileList_564107, base: "",
    url: url_EventsByBillingProfileList_564108, schemes: {Scheme.Https})
type
  Call_LotsByBillingProfileList_564118 = ref object of OpenApiRestCall_563557
proc url_LotsByBillingProfileList_564120(protocol: Scheme; host: string;
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

proc validate_LotsByBillingProfileList_564119(path: JsonNode; query: JsonNode;
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
  var valid_564121 = path.getOrDefault("billingAccountId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "billingAccountId", valid_564121
  var valid_564122 = path.getOrDefault("billingProfileId")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "billingProfileId", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_LotsByBillingProfileList_564118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the lots by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_LotsByBillingProfileList_564118; apiVersion: string;
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
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  add(query_564127, "api-version", newJString(apiVersion))
  add(path_564126, "billingAccountId", newJString(billingAccountId))
  add(path_564126, "billingProfileId", newJString(billingProfileId))
  result = call_564125.call(path_564126, query_564127, nil, nil, nil)

var lotsByBillingProfileList* = Call_LotsByBillingProfileList_564118(
    name: "lotsByBillingProfileList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/lots",
    validator: validate_LotsByBillingProfileList_564119, base: "",
    url: url_LotsByBillingProfileList_564120, schemes: {Scheme.Https})
type
  Call_ChargesByInvoiceSectionList_564128 = ref object of OpenApiRestCall_563557
proc url_ChargesByInvoiceSectionList_564130(protocol: Scheme; host: string;
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

proc validate_ChargesByInvoiceSectionList_564129(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the charges by invoice section id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   invoiceSectionId: JString (required)
  ##                   : Invoice Section Id.
  ##   billingAccountId: JString (required)
  ##                   : BillingAccount ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `invoiceSectionId` field"
  var valid_564132 = path.getOrDefault("invoiceSectionId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "invoiceSectionId", valid_564132
  var valid_564133 = path.getOrDefault("billingAccountId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "billingAccountId", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   $apply: JString
  ##         : May be used to group charges by properties/productName.
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  var valid_564135 = query.getOrDefault("endDate")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "endDate", valid_564135
  var valid_564136 = query.getOrDefault("$apply")
  valid_564136 = validateParameter(valid_564136, JString, required = false,
                                 default = nil)
  if valid_564136 != nil:
    section.add "$apply", valid_564136
  var valid_564137 = query.getOrDefault("startDate")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "startDate", valid_564137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564138: Call_ChargesByInvoiceSectionList_564128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by invoice section id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564138.validator(path, query, header, formData, body)
  let scheme = call_564138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564138.url(scheme.get, call_564138.host, call_564138.base,
                         call_564138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564138, url, valid)

proc call*(call_564139: Call_ChargesByInvoiceSectionList_564128;
          apiVersion: string; endDate: string; invoiceSectionId: string;
          billingAccountId: string; startDate: string; Apply: string = ""): Recallable =
  ## chargesByInvoiceSectionList
  ## Lists the charges by invoice section id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   Apply: string
  ##        : May be used to group charges by properties/productName.
  ##   invoiceSectionId: string (required)
  ##                   : Invoice Section Id.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   startDate: string (required)
  ##            : Start date
  var path_564140 = newJObject()
  var query_564141 = newJObject()
  add(query_564141, "api-version", newJString(apiVersion))
  add(query_564141, "endDate", newJString(endDate))
  add(query_564141, "$apply", newJString(Apply))
  add(path_564140, "invoiceSectionId", newJString(invoiceSectionId))
  add(path_564140, "billingAccountId", newJString(billingAccountId))
  add(query_564141, "startDate", newJString(startDate))
  result = call_564139.call(path_564140, query_564141, nil, nil, nil)

var chargesByInvoiceSectionList* = Call_ChargesByInvoiceSectionList_564128(
    name: "chargesByInvoiceSectionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesByInvoiceSectionList_564129, base: "",
    url: url_ChargesByInvoiceSectionList_564130, schemes: {Scheme.Https})
type
  Call_ChargesByBillingAccountList_564142 = ref object of OpenApiRestCall_563557
proc url_ChargesByBillingAccountList_564144(protocol: Scheme; host: string;
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

proc validate_ChargesByBillingAccountList_564143(path: JsonNode; query: JsonNode;
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
  var valid_564145 = path.getOrDefault("billingAccountId")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "billingAccountId", valid_564145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   $apply: JString
  ##         : May be used to group charges by properties/billingProfileId, or properties/invoiceSectionId.
  ##   startDate: JString (required)
  ##            : Start date
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564146 = query.getOrDefault("api-version")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "api-version", valid_564146
  var valid_564147 = query.getOrDefault("endDate")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "endDate", valid_564147
  var valid_564148 = query.getOrDefault("$apply")
  valid_564148 = validateParameter(valid_564148, JString, required = false,
                                 default = nil)
  if valid_564148 != nil:
    section.add "$apply", valid_564148
  var valid_564149 = query.getOrDefault("startDate")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "startDate", valid_564149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564150: Call_ChargesByBillingAccountList_564142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by billingAccountId for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_ChargesByBillingAccountList_564142;
          apiVersion: string; endDate: string; billingAccountId: string;
          startDate: string; Apply: string = ""): Recallable =
  ## chargesByBillingAccountList
  ## Lists the charges by billingAccountId for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   Apply: string
  ##        : May be used to group charges by properties/billingProfileId, or properties/invoiceSectionId.
  ##   billingAccountId: string (required)
  ##                   : BillingAccount ID
  ##   startDate: string (required)
  ##            : Start date
  var path_564152 = newJObject()
  var query_564153 = newJObject()
  add(query_564153, "api-version", newJString(apiVersion))
  add(query_564153, "endDate", newJString(endDate))
  add(query_564153, "$apply", newJString(Apply))
  add(path_564152, "billingAccountId", newJString(billingAccountId))
  add(query_564153, "startDate", newJString(startDate))
  result = call_564151.call(path_564152, query_564153, nil, nil, nil)

var chargesByBillingAccountList* = Call_ChargesByBillingAccountList_564142(
    name: "chargesByBillingAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesByBillingAccountList_564143, base: "",
    url: url_ChargesByBillingAccountList_564144, schemes: {Scheme.Https})
type
  Call_BillingProfilePricesheetDownload_564154 = ref object of OpenApiRestCall_563557
proc url_BillingProfilePricesheetDownload_564156(protocol: Scheme; host: string;
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

proc validate_BillingProfilePricesheetDownload_564155(path: JsonNode;
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
  var valid_564157 = path.getOrDefault("billingAccountId")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "billingAccountId", valid_564157
  var valid_564158 = path.getOrDefault("billingProfileId")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "billingProfileId", valid_564158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564159 = query.getOrDefault("api-version")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "api-version", valid_564159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564160: Call_BillingProfilePricesheetDownload_564154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get pricesheet data for invoice id (invoiceName).
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_BillingProfilePricesheetDownload_564154;
          apiVersion: string; billingAccountId: string; billingProfileId: string): Recallable =
  ## billingProfilePricesheetDownload
  ## Get pricesheet data for invoice id (invoiceName).
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountId: string (required)
  ##                   : Azure Billing Account Id.
  ##   billingProfileId: string (required)
  ##                   : Azure Billing Profile Id.
  var path_564162 = newJObject()
  var query_564163 = newJObject()
  add(query_564163, "api-version", newJString(apiVersion))
  add(path_564162, "billingAccountId", newJString(billingAccountId))
  add(path_564162, "billingProfileId", newJString(billingProfileId))
  result = call_564161.call(path_564162, query_564163, nil, nil, nil)

var billingProfilePricesheetDownload* = Call_BillingProfilePricesheetDownload_564154(
    name: "billingProfilePricesheetDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Consumption/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/pricesheet/default/download",
    validator: validate_BillingProfilePricesheetDownload_564155, base: "",
    url: url_BillingProfilePricesheetDownload_564156, schemes: {Scheme.Https})
type
  Call_InvoicePricesheetDownload_564164 = ref object of OpenApiRestCall_563557
proc url_InvoicePricesheetDownload_564166(protocol: Scheme; host: string;
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

proc validate_InvoicePricesheetDownload_564165(path: JsonNode; query: JsonNode;
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
  var valid_564167 = path.getOrDefault("invoiceName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "invoiceName", valid_564167
  var valid_564168 = path.getOrDefault("billingAccountId")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "billingAccountId", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564170: Call_InvoicePricesheetDownload_564164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get pricesheet data for invoice id (invoiceName).
  ## 
  let valid = call_564170.validator(path, query, header, formData, body)
  let scheme = call_564170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564170.url(scheme.get, call_564170.host, call_564170.base,
                         call_564170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564170, url, valid)

proc call*(call_564171: Call_InvoicePricesheetDownload_564164; apiVersion: string;
          invoiceName: string; billingAccountId: string): Recallable =
  ## invoicePricesheetDownload
  ## Get pricesheet data for invoice id (invoiceName).
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   invoiceName: string (required)
  ##              : The name of an invoice resource.
  ##   billingAccountId: string (required)
  ##                   : Azure Billing Account Id.
  var path_564172 = newJObject()
  var query_564173 = newJObject()
  add(query_564173, "api-version", newJString(apiVersion))
  add(path_564172, "invoiceName", newJString(invoiceName))
  add(path_564172, "billingAccountId", newJString(billingAccountId))
  result = call_564171.call(path_564172, query_564173, nil, nil, nil)

var invoicePricesheetDownload* = Call_InvoicePricesheetDownload_564164(
    name: "invoicePricesheetDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Consumption/billingAccounts/{billingAccountId}/invoices/{invoiceName}/pricesheet/default/download",
    validator: validate_InvoicePricesheetDownload_564165, base: "",
    url: url_InvoicePricesheetDownload_564166, schemes: {Scheme.Https})
type
  Call_OperationsList_564174 = ref object of OpenApiRestCall_563557
proc url_OperationsList_564176(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564175(path: JsonNode; query: JsonNode;
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
  var valid_564177 = query.getOrDefault("api-version")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "api-version", valid_564177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564178: Call_OperationsList_564174; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_564178.validator(path, query, header, formData, body)
  let scheme = call_564178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564178.url(scheme.get, call_564178.host, call_564178.base,
                         call_564178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564178, url, valid)

proc call*(call_564179: Call_OperationsList_564174; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  var query_564180 = newJObject()
  add(query_564180, "api-version", newJString(apiVersion))
  result = call_564179.call(nil, query_564180, nil, nil, nil)

var operationsList* = Call_OperationsList_564174(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Consumption/operations",
    validator: validate_OperationsList_564175, base: "", url: url_OperationsList_564176,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
