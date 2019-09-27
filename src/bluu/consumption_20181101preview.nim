
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593426 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593426](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593426): Option[Scheme] {.used.} =
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
  macServiceName = "consumption"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ChargesByBillingProfileList_593648 = ref object of OpenApiRestCall_593426
proc url_ChargesByBillingProfileList_593650(protocol: Scheme; host: string;
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

proc validate_ChargesByBillingProfileList_593649(path: JsonNode; query: JsonNode;
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
  var valid_593823 = path.getOrDefault("billingAccountId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "billingAccountId", valid_593823
  var valid_593824 = path.getOrDefault("billingProfileId")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "billingProfileId", valid_593824
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
  var valid_593825 = query.getOrDefault("api-version")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = nil)
  if valid_593825 != nil:
    section.add "api-version", valid_593825
  var valid_593826 = query.getOrDefault("endDate")
  valid_593826 = validateParameter(valid_593826, JString, required = true,
                                 default = nil)
  if valid_593826 != nil:
    section.add "endDate", valid_593826
  var valid_593827 = query.getOrDefault("startDate")
  valid_593827 = validateParameter(valid_593827, JString, required = true,
                                 default = nil)
  if valid_593827 != nil:
    section.add "startDate", valid_593827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593850: Call_ChargesByBillingProfileList_593648; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by billing profile id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_593850.validator(path, query, header, formData, body)
  let scheme = call_593850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593850.url(scheme.get, call_593850.host, call_593850.base,
                         call_593850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593850, url, valid)

proc call*(call_593921: Call_ChargesByBillingProfileList_593648;
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
  var path_593922 = newJObject()
  var query_593924 = newJObject()
  add(query_593924, "api-version", newJString(apiVersion))
  add(query_593924, "endDate", newJString(endDate))
  add(query_593924, "startDate", newJString(startDate))
  add(path_593922, "billingAccountId", newJString(billingAccountId))
  add(path_593922, "billingProfileId", newJString(billingProfileId))
  result = call_593921.call(path_593922, query_593924, nil, nil, nil)

var chargesByBillingProfileList* = Call_ChargesByBillingProfileList_593648(
    name: "chargesByBillingProfileList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesByBillingProfileList_593649, base: "",
    url: url_ChargesByBillingProfileList_593650, schemes: {Scheme.Https})
type
  Call_CreditSummaryByBillingProfileGet_593963 = ref object of OpenApiRestCall_593426
proc url_CreditSummaryByBillingProfileGet_593965(protocol: Scheme; host: string;
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

proc validate_CreditSummaryByBillingProfileGet_593964(path: JsonNode;
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
  var valid_593966 = path.getOrDefault("billingAccountId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "billingAccountId", valid_593966
  var valid_593967 = path.getOrDefault("billingProfileId")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "billingProfileId", valid_593967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593968 = query.getOrDefault("api-version")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "api-version", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_CreditSummaryByBillingProfileGet_593963;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The credit summary by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_CreditSummaryByBillingProfileGet_593963;
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
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(query_593972, "api-version", newJString(apiVersion))
  add(path_593971, "billingAccountId", newJString(billingAccountId))
  add(path_593971, "billingProfileId", newJString(billingProfileId))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var creditSummaryByBillingProfileGet* = Call_CreditSummaryByBillingProfileGet_593963(
    name: "creditSummaryByBillingProfileGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/credits/balanceSummary",
    validator: validate_CreditSummaryByBillingProfileGet_593964, base: "",
    url: url_CreditSummaryByBillingProfileGet_593965, schemes: {Scheme.Https})
type
  Call_EventsByBillingProfileList_593973 = ref object of OpenApiRestCall_593426
proc url_EventsByBillingProfileList_593975(protocol: Scheme; host: string;
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

proc validate_EventsByBillingProfileList_593974(path: JsonNode; query: JsonNode;
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
  var valid_593976 = path.getOrDefault("billingAccountId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "billingAccountId", valid_593976
  var valid_593977 = path.getOrDefault("billingProfileId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "billingProfileId", valid_593977
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
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  var valid_593979 = query.getOrDefault("endDate")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "endDate", valid_593979
  var valid_593980 = query.getOrDefault("startDate")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "startDate", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_EventsByBillingProfileList_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the events by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_EventsByBillingProfileList_593973; apiVersion: string;
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
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  add(query_593984, "api-version", newJString(apiVersion))
  add(query_593984, "endDate", newJString(endDate))
  add(query_593984, "startDate", newJString(startDate))
  add(path_593983, "billingAccountId", newJString(billingAccountId))
  add(path_593983, "billingProfileId", newJString(billingProfileId))
  result = call_593982.call(path_593983, query_593984, nil, nil, nil)

var eventsByBillingProfileList* = Call_EventsByBillingProfileList_593973(
    name: "eventsByBillingProfileList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/events",
    validator: validate_EventsByBillingProfileList_593974, base: "",
    url: url_EventsByBillingProfileList_593975, schemes: {Scheme.Https})
type
  Call_LotsByBillingProfileList_593985 = ref object of OpenApiRestCall_593426
proc url_LotsByBillingProfileList_593987(protocol: Scheme; host: string;
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

proc validate_LotsByBillingProfileList_593986(path: JsonNode; query: JsonNode;
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
  var valid_593988 = path.getOrDefault("billingAccountId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "billingAccountId", valid_593988
  var valid_593989 = path.getOrDefault("billingProfileId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "billingProfileId", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_LotsByBillingProfileList_593985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the lots by billingAccountId and billingProfileId for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_LotsByBillingProfileList_593985; apiVersion: string;
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
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "billingAccountId", newJString(billingAccountId))
  add(path_593993, "billingProfileId", newJString(billingProfileId))
  result = call_593992.call(path_593993, query_593994, nil, nil, nil)

var lotsByBillingProfileList* = Call_LotsByBillingProfileList_593985(
    name: "lotsByBillingProfileList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/providers/Microsoft.Consumption/lots",
    validator: validate_LotsByBillingProfileList_593986, base: "",
    url: url_LotsByBillingProfileList_593987, schemes: {Scheme.Https})
type
  Call_ChargesByInvoiceSectionList_593995 = ref object of OpenApiRestCall_593426
proc url_ChargesByInvoiceSectionList_593997(protocol: Scheme; host: string;
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

proc validate_ChargesByInvoiceSectionList_593996(path: JsonNode; query: JsonNode;
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
  var valid_593999 = path.getOrDefault("billingAccountId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "billingAccountId", valid_593999
  var valid_594000 = path.getOrDefault("invoiceSectionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "invoiceSectionId", valid_594000
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
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  var valid_594002 = query.getOrDefault("endDate")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "endDate", valid_594002
  var valid_594003 = query.getOrDefault("startDate")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "startDate", valid_594003
  var valid_594004 = query.getOrDefault("$apply")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "$apply", valid_594004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594005: Call_ChargesByInvoiceSectionList_593995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by invoice section id for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_ChargesByInvoiceSectionList_593995;
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
  var path_594007 = newJObject()
  var query_594008 = newJObject()
  add(query_594008, "api-version", newJString(apiVersion))
  add(query_594008, "endDate", newJString(endDate))
  add(query_594008, "startDate", newJString(startDate))
  add(path_594007, "billingAccountId", newJString(billingAccountId))
  add(query_594008, "$apply", newJString(Apply))
  add(path_594007, "invoiceSectionId", newJString(invoiceSectionId))
  result = call_594006.call(path_594007, query_594008, nil, nil, nil)

var chargesByInvoiceSectionList* = Call_ChargesByInvoiceSectionList_593995(
    name: "chargesByInvoiceSectionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/invoiceSections/{invoiceSectionId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesByInvoiceSectionList_593996, base: "",
    url: url_ChargesByInvoiceSectionList_593997, schemes: {Scheme.Https})
type
  Call_ChargesByBillingAccountList_594009 = ref object of OpenApiRestCall_593426
proc url_ChargesByBillingAccountList_594011(protocol: Scheme; host: string;
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

proc validate_ChargesByBillingAccountList_594010(path: JsonNode; query: JsonNode;
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
  var valid_594012 = path.getOrDefault("billingAccountId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "billingAccountId", valid_594012
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
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "api-version", valid_594013
  var valid_594014 = query.getOrDefault("endDate")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "endDate", valid_594014
  var valid_594015 = query.getOrDefault("startDate")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "startDate", valid_594015
  var valid_594016 = query.getOrDefault("$apply")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "$apply", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_ChargesByBillingAccountList_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the charges by billingAccountId for given start and end date. Start and end date are used to determine the billing period. For current month, the data will be provided from month to date. If there are no charges for a month then that month will show all zeroes.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_ChargesByBillingAccountList_594009;
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
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(query_594020, "api-version", newJString(apiVersion))
  add(query_594020, "endDate", newJString(endDate))
  add(query_594020, "startDate", newJString(startDate))
  add(path_594019, "billingAccountId", newJString(billingAccountId))
  add(query_594020, "$apply", newJString(Apply))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var chargesByBillingAccountList* = Call_ChargesByBillingAccountList_594009(
    name: "chargesByBillingAccountList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountId}/providers/Microsoft.Consumption/charges",
    validator: validate_ChargesByBillingAccountList_594010, base: "",
    url: url_ChargesByBillingAccountList_594011, schemes: {Scheme.Https})
type
  Call_BillingProfilePricesheetDownload_594021 = ref object of OpenApiRestCall_593426
proc url_BillingProfilePricesheetDownload_594023(protocol: Scheme; host: string;
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

proc validate_BillingProfilePricesheetDownload_594022(path: JsonNode;
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
  var valid_594024 = path.getOrDefault("billingAccountId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "billingAccountId", valid_594024
  var valid_594025 = path.getOrDefault("billingProfileId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "billingProfileId", valid_594025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_BillingProfilePricesheetDownload_594021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get pricesheet data for invoice id (invoiceName).
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_BillingProfilePricesheetDownload_594021;
          apiVersion: string; billingAccountId: string; billingProfileId: string): Recallable =
  ## billingProfilePricesheetDownload
  ## Get pricesheet data for invoice id (invoiceName).
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountId: string (required)
  ##                   : Azure Billing Account Id.
  ##   billingProfileId: string (required)
  ##                   : Azure Billing Profile Id.
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "billingAccountId", newJString(billingAccountId))
  add(path_594029, "billingProfileId", newJString(billingProfileId))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var billingProfilePricesheetDownload* = Call_BillingProfilePricesheetDownload_594021(
    name: "billingProfilePricesheetDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Consumption/billingAccounts/{billingAccountId}/billingProfiles/{billingProfileId}/pricesheet/default/download",
    validator: validate_BillingProfilePricesheetDownload_594022, base: "",
    url: url_BillingProfilePricesheetDownload_594023, schemes: {Scheme.Https})
type
  Call_InvoicePricesheetDownload_594031 = ref object of OpenApiRestCall_593426
proc url_InvoicePricesheetDownload_594033(protocol: Scheme; host: string;
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

proc validate_InvoicePricesheetDownload_594032(path: JsonNode; query: JsonNode;
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
  var valid_594034 = path.getOrDefault("invoiceName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "invoiceName", valid_594034
  var valid_594035 = path.getOrDefault("billingAccountId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "billingAccountId", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_InvoicePricesheetDownload_594031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get pricesheet data for invoice id (invoiceName).
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_InvoicePricesheetDownload_594031; apiVersion: string;
          invoiceName: string; billingAccountId: string): Recallable =
  ## invoicePricesheetDownload
  ## Get pricesheet data for invoice id (invoiceName).
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   invoiceName: string (required)
  ##              : The name of an invoice resource.
  ##   billingAccountId: string (required)
  ##                   : Azure Billing Account Id.
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "invoiceName", newJString(invoiceName))
  add(path_594039, "billingAccountId", newJString(billingAccountId))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var invoicePricesheetDownload* = Call_InvoicePricesheetDownload_594031(
    name: "invoicePricesheetDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Consumption/billingAccounts/{billingAccountId}/invoices/{invoiceName}/pricesheet/default/download",
    validator: validate_InvoicePricesheetDownload_594032, base: "",
    url: url_InvoicePricesheetDownload_594033, schemes: {Scheme.Https})
type
  Call_OperationsList_594041 = ref object of OpenApiRestCall_593426
proc url_OperationsList_594043(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_594042(path: JsonNode; query: JsonNode;
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
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "api-version", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_OperationsList_594041; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available consumption REST API operations.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_OperationsList_594041; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available consumption REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  var query_594047 = newJObject()
  add(query_594047, "api-version", newJString(apiVersion))
  result = call_594046.call(nil, query_594047, nil, nil, nil)

var operationsList* = Call_OperationsList_594041(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Consumption/operations",
    validator: validate_OperationsList_594042, base: "", url: url_OperationsList_594043,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
