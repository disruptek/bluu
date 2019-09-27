
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title:  API Client
## version: 2018-02-01
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "web-ResourceProvider"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_UpdatePublishingUser_593942 = ref object of OpenApiRestCall_593424
proc url_UpdatePublishingUser_593944(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_UpdatePublishingUser_593943(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates publishing user
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593945 = query.getOrDefault("api-version")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = nil)
  if valid_593945 != nil:
    section.add "api-version", valid_593945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   userDetails: JObject (required)
  ##              : Details of publishing user
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593947: Call_UpdatePublishingUser_593942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates publishing user
  ## 
  let valid = call_593947.validator(path, query, header, formData, body)
  let scheme = call_593947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593947.url(scheme.get, call_593947.host, call_593947.base,
                         call_593947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593947, url, valid)

proc call*(call_593948: Call_UpdatePublishingUser_593942; apiVersion: string;
          userDetails: JsonNode): Recallable =
  ## updatePublishingUser
  ## Updates publishing user
  ##   apiVersion: string (required)
  ##             : API Version
  ##   userDetails: JObject (required)
  ##              : Details of publishing user
  var query_593949 = newJObject()
  var body_593950 = newJObject()
  add(query_593949, "api-version", newJString(apiVersion))
  if userDetails != nil:
    body_593950 = userDetails
  result = call_593948.call(nil, query_593949, nil, nil, body_593950)

var updatePublishingUser* = Call_UpdatePublishingUser_593942(
    name: "updatePublishingUser", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/Microsoft.Web/publishingUsers/web",
    validator: validate_UpdatePublishingUser_593943, base: "",
    url: url_UpdatePublishingUser_593944, schemes: {Scheme.Https})
type
  Call_GetPublishingUser_593646 = ref object of OpenApiRestCall_593424
proc url_GetPublishingUser_593648(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetPublishingUser_593647(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets publishing user
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_GetPublishingUser_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets publishing user
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_GetPublishingUser_593646; apiVersion: string): Recallable =
  ## getPublishingUser
  ## Gets publishing user
  ##   apiVersion: string (required)
  ##             : API Version
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var getPublishingUser* = Call_GetPublishingUser_593646(name: "getPublishingUser",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Web/publishingUsers/web",
    validator: validate_GetPublishingUser_593647, base: "",
    url: url_GetPublishingUser_593648, schemes: {Scheme.Https})
type
  Call_ListSourceControls_593951 = ref object of OpenApiRestCall_593424
proc url_ListSourceControls_593953(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListSourceControls_593952(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the source controls available for Azure websites.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593954 = query.getOrDefault("api-version")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "api-version", valid_593954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593955: Call_ListSourceControls_593951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the source controls available for Azure websites.
  ## 
  let valid = call_593955.validator(path, query, header, formData, body)
  let scheme = call_593955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593955.url(scheme.get, call_593955.host, call_593955.base,
                         call_593955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593955, url, valid)

proc call*(call_593956: Call_ListSourceControls_593951; apiVersion: string): Recallable =
  ## listSourceControls
  ## Gets the source controls available for Azure websites.
  ##   apiVersion: string (required)
  ##             : API Version
  var query_593957 = newJObject()
  add(query_593957, "api-version", newJString(apiVersion))
  result = call_593956.call(nil, query_593957, nil, nil, nil)

var listSourceControls* = Call_ListSourceControls_593951(
    name: "listSourceControls", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Web/sourcecontrols",
    validator: validate_ListSourceControls_593952, base: "",
    url: url_ListSourceControls_593953, schemes: {Scheme.Https})
type
  Call_UpdateSourceControl_593981 = ref object of OpenApiRestCall_593424
proc url_UpdateSourceControl_593983(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceControlType" in path,
        "`sourceControlType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Web/sourcecontrols/"),
               (kind: VariableSegment, value: "sourceControlType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateSourceControl_593982(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates source control token
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceControlType: JString (required)
  ##                    : Type of source control
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sourceControlType` field"
  var valid_593984 = path.getOrDefault("sourceControlType")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "sourceControlType", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   requestMessage: JObject (required)
  ##                 : Source control token information
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_UpdateSourceControl_593981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates source control token
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_UpdateSourceControl_593981; apiVersion: string;
          sourceControlType: string; requestMessage: JsonNode): Recallable =
  ## updateSourceControl
  ## Updates source control token
  ##   apiVersion: string (required)
  ##             : API Version
  ##   sourceControlType: string (required)
  ##                    : Type of source control
  ##   requestMessage: JObject (required)
  ##                 : Source control token information
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  var body_593991 = newJObject()
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "sourceControlType", newJString(sourceControlType))
  if requestMessage != nil:
    body_593991 = requestMessage
  result = call_593988.call(path_593989, query_593990, nil, nil, body_593991)

var updateSourceControl* = Call_UpdateSourceControl_593981(
    name: "updateSourceControl", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/Microsoft.Web/sourcecontrols/{sourceControlType}",
    validator: validate_UpdateSourceControl_593982, base: "",
    url: url_UpdateSourceControl_593983, schemes: {Scheme.Https})
type
  Call_GetSourceControl_593958 = ref object of OpenApiRestCall_593424
proc url_GetSourceControl_593960(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceControlType" in path,
        "`sourceControlType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Web/sourcecontrols/"),
               (kind: VariableSegment, value: "sourceControlType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetSourceControl_593959(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets source control token
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceControlType: JString (required)
  ##                    : Type of source control
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sourceControlType` field"
  var valid_593975 = path.getOrDefault("sourceControlType")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "sourceControlType", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_GetSourceControl_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets source control token
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_GetSourceControl_593958; apiVersion: string;
          sourceControlType: string): Recallable =
  ## getSourceControl
  ## Gets source control token
  ##   apiVersion: string (required)
  ##             : API Version
  ##   sourceControlType: string (required)
  ##                    : Type of source control
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(query_593980, "api-version", newJString(apiVersion))
  add(path_593979, "sourceControlType", newJString(sourceControlType))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var getSourceControl* = Call_GetSourceControl_593958(name: "getSourceControl",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Web/sourcecontrols/{sourceControlType}",
    validator: validate_GetSourceControl_593959, base: "",
    url: url_GetSourceControl_593960, schemes: {Scheme.Https})
type
  Call_ListBillingMeters_593992 = ref object of OpenApiRestCall_593424
proc url_ListBillingMeters_593994(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/billingMeters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListBillingMeters_593993(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a list of meters for a given location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593995 = path.getOrDefault("subscriptionId")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "subscriptionId", valid_593995
  result.add "path", section
  ## parameters in `query` object:
  ##   billingLocation: JString
  ##                  : Azure Location of billable resource
  ##   api-version: JString (required)
  ##              : API Version
  ##   osType: JString
  ##         : App Service OS type meters used for
  section = newJObject()
  var valid_593996 = query.getOrDefault("billingLocation")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "billingLocation", valid_593996
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  var valid_593998 = query.getOrDefault("osType")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "osType", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_ListBillingMeters_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of meters for a given location.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_ListBillingMeters_593992; apiVersion: string;
          subscriptionId: string; billingLocation: string = ""; osType: string = ""): Recallable =
  ## listBillingMeters
  ## Gets a list of meters for a given location.
  ##   billingLocation: string
  ##                  : Azure Location of billable resource
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   osType: string
  ##         : App Service OS type meters used for
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(query_594002, "billingLocation", newJString(billingLocation))
  add(query_594002, "api-version", newJString(apiVersion))
  add(path_594001, "subscriptionId", newJString(subscriptionId))
  add(query_594002, "osType", newJString(osType))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var listBillingMeters* = Call_ListBillingMeters_593992(name: "listBillingMeters",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/billingMeters",
    validator: validate_ListBillingMeters_593993, base: "",
    url: url_ListBillingMeters_593994, schemes: {Scheme.Https})
type
  Call_CheckNameAvailability_594003 = ref object of OpenApiRestCall_593424
proc url_CheckNameAvailability_594005(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Web/checknameavailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckNameAvailability_594004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check if a resource name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : Name availability request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_CheckNameAvailability_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if a resource name is available.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_CheckNameAvailability_594003; apiVersion: string;
          subscriptionId: string; request: JsonNode): Recallable =
  ## checkNameAvailability
  ## Check if a resource name is available.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   request: JObject (required)
  ##          : Name availability request.
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  var body_594013 = newJObject()
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_594013 = request
  result = call_594010.call(path_594011, query_594012, nil, nil, body_594013)

var checkNameAvailability* = Call_CheckNameAvailability_594003(
    name: "checkNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/checknameavailability",
    validator: validate_CheckNameAvailability_594004, base: "",
    url: url_CheckNameAvailability_594005, schemes: {Scheme.Https})
type
  Call_GetSubscriptionDeploymentLocations_594014 = ref object of OpenApiRestCall_593424
proc url_GetSubscriptionDeploymentLocations_594016(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/deploymentLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetSubscriptionDeploymentLocations_594015(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets list of available geo regions plus ministamps
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594017 = path.getOrDefault("subscriptionId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "subscriptionId", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "api-version", valid_594018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_GetSubscriptionDeploymentLocations_594014;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets list of available geo regions plus ministamps
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_GetSubscriptionDeploymentLocations_594014;
          apiVersion: string; subscriptionId: string): Recallable =
  ## getSubscriptionDeploymentLocations
  ## Gets list of available geo regions plus ministamps
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  add(query_594022, "api-version", newJString(apiVersion))
  add(path_594021, "subscriptionId", newJString(subscriptionId))
  result = call_594020.call(path_594021, query_594022, nil, nil, nil)

var getSubscriptionDeploymentLocations* = Call_GetSubscriptionDeploymentLocations_594014(
    name: "getSubscriptionDeploymentLocations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/deploymentLocations",
    validator: validate_GetSubscriptionDeploymentLocations_594015, base: "",
    url: url_GetSubscriptionDeploymentLocations_594016, schemes: {Scheme.Https})
type
  Call_ListGeoRegions_594023 = ref object of OpenApiRestCall_593424
proc url_ListGeoRegions_594025(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/geoRegions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListGeoRegions_594024(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get a list of available geographical regions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594026 = path.getOrDefault("subscriptionId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "subscriptionId", valid_594026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   linuxWorkersEnabled: JBool
  ##                      : Specify <code>true</code> if you want to filter to only regions that support Linux workers.
  ##   sku: JString
  ##      : Name of SKU used to filter the regions.
  ##   xenonWorkersEnabled: JBool
  ##                      : Specify <code>true</code> if you want to filter to only regions that support Xenon workers.
  ##   linuxDynamicWorkersEnabled: JBool
  ##                             : Specify <code>true</code> if you want to filter to only regions that support Linux Consumption Workers.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594027 = query.getOrDefault("api-version")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "api-version", valid_594027
  var valid_594028 = query.getOrDefault("linuxWorkersEnabled")
  valid_594028 = validateParameter(valid_594028, JBool, required = false, default = nil)
  if valid_594028 != nil:
    section.add "linuxWorkersEnabled", valid_594028
  var valid_594042 = query.getOrDefault("sku")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = newJString("Free"))
  if valid_594042 != nil:
    section.add "sku", valid_594042
  var valid_594043 = query.getOrDefault("xenonWorkersEnabled")
  valid_594043 = validateParameter(valid_594043, JBool, required = false, default = nil)
  if valid_594043 != nil:
    section.add "xenonWorkersEnabled", valid_594043
  var valid_594044 = query.getOrDefault("linuxDynamicWorkersEnabled")
  valid_594044 = validateParameter(valid_594044, JBool, required = false, default = nil)
  if valid_594044 != nil:
    section.add "linuxDynamicWorkersEnabled", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_ListGeoRegions_594023; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of available geographical regions.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_ListGeoRegions_594023; apiVersion: string;
          subscriptionId: string; linuxWorkersEnabled: bool = false;
          sku: string = "Free"; xenonWorkersEnabled: bool = false;
          linuxDynamicWorkersEnabled: bool = false): Recallable =
  ## listGeoRegions
  ## Get a list of available geographical regions.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   linuxWorkersEnabled: bool
  ##                      : Specify <code>true</code> if you want to filter to only regions that support Linux workers.
  ##   sku: string
  ##      : Name of SKU used to filter the regions.
  ##   xenonWorkersEnabled: bool
  ##                      : Specify <code>true</code> if you want to filter to only regions that support Xenon workers.
  ##   linuxDynamicWorkersEnabled: bool
  ##                             : Specify <code>true</code> if you want to filter to only regions that support Linux Consumption Workers.
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "subscriptionId", newJString(subscriptionId))
  add(query_594048, "linuxWorkersEnabled", newJBool(linuxWorkersEnabled))
  add(query_594048, "sku", newJString(sku))
  add(query_594048, "xenonWorkersEnabled", newJBool(xenonWorkersEnabled))
  add(query_594048, "linuxDynamicWorkersEnabled",
      newJBool(linuxDynamicWorkersEnabled))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var listGeoRegions* = Call_ListGeoRegions_594023(name: "listGeoRegions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/geoRegions",
    validator: validate_ListGeoRegions_594024, base: "", url: url_ListGeoRegions_594025,
    schemes: {Scheme.Https})
type
  Call_ListSiteIdentifiersAssignedToHostName_594049 = ref object of OpenApiRestCall_593424
proc url_ListSiteIdentifiersAssignedToHostName_594051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/listSitesAssignedToHostName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListSiteIdentifiersAssignedToHostName_594050(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all apps that are assigned to a hostname.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594052 = path.getOrDefault("subscriptionId")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "subscriptionId", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594053 = query.getOrDefault("api-version")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "api-version", valid_594053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nameIdentifier: JObject (required)
  ##                 : Hostname information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594055: Call_ListSiteIdentifiersAssignedToHostName_594049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all apps that are assigned to a hostname.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_ListSiteIdentifiersAssignedToHostName_594049;
          apiVersion: string; subscriptionId: string; nameIdentifier: JsonNode): Recallable =
  ## listSiteIdentifiersAssignedToHostName
  ## List all apps that are assigned to a hostname.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   nameIdentifier: JObject (required)
  ##                 : Hostname information.
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  var body_594059 = newJObject()
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "subscriptionId", newJString(subscriptionId))
  if nameIdentifier != nil:
    body_594059 = nameIdentifier
  result = call_594056.call(path_594057, query_594058, nil, nil, body_594059)

var listSiteIdentifiersAssignedToHostName* = Call_ListSiteIdentifiersAssignedToHostName_594049(
    name: "listSiteIdentifiersAssignedToHostName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/listSitesAssignedToHostName",
    validator: validate_ListSiteIdentifiersAssignedToHostName_594050, base: "",
    url: url_ListSiteIdentifiersAssignedToHostName_594051, schemes: {Scheme.Https})
type
  Call_ListPremierAddOnOffers_594060 = ref object of OpenApiRestCall_593424
proc url_ListPremierAddOnOffers_594062(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Web/premieraddonoffers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListPremierAddOnOffers_594061(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all premier add-on offers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594063 = path.getOrDefault("subscriptionId")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "subscriptionId", valid_594063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_ListPremierAddOnOffers_594060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all premier add-on offers.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_ListPremierAddOnOffers_594060; apiVersion: string;
          subscriptionId: string): Recallable =
  ## listPremierAddOnOffers
  ## List all premier add-on offers.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  add(query_594068, "api-version", newJString(apiVersion))
  add(path_594067, "subscriptionId", newJString(subscriptionId))
  result = call_594066.call(path_594067, query_594068, nil, nil, nil)

var listPremierAddOnOffers* = Call_ListPremierAddOnOffers_594060(
    name: "listPremierAddOnOffers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/premieraddonoffers",
    validator: validate_ListPremierAddOnOffers_594061, base: "",
    url: url_ListPremierAddOnOffers_594062, schemes: {Scheme.Https})
type
  Call_ListSkus_594069 = ref object of OpenApiRestCall_593424
proc url_ListSkus_594071(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/Microsoft.Web/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListSkus_594070(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## List all SKUs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594072 = path.getOrDefault("subscriptionId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "subscriptionId", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
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
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_ListSkus_594069; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all SKUs.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_ListSkus_594069; apiVersion: string;
          subscriptionId: string): Recallable =
  ## listSkus
  ## List all SKUs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "subscriptionId", newJString(subscriptionId))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var listSkus* = Call_ListSkus_594069(name: "listSkus", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/skus",
                                  validator: validate_ListSkus_594070, base: "",
                                  url: url_ListSkus_594071,
                                  schemes: {Scheme.Https})
type
  Call_VerifyHostingEnvironmentVnet_594078 = ref object of OpenApiRestCall_593424
proc url_VerifyHostingEnvironmentVnet_594080(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/verifyHostingEnvironmentVnet")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VerifyHostingEnvironmentVnet_594079(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies if this VNET is compatible with an App Service Environment by analyzing the Network Security Group rules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594081 = path.getOrDefault("subscriptionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "subscriptionId", valid_594081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594082 = query.getOrDefault("api-version")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "api-version", valid_594082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : VNET information
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594084: Call_VerifyHostingEnvironmentVnet_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies if this VNET is compatible with an App Service Environment by analyzing the Network Security Group rules.
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_VerifyHostingEnvironmentVnet_594078;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## verifyHostingEnvironmentVnet
  ## Verifies if this VNET is compatible with an App Service Environment by analyzing the Network Security Group rules.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   parameters: JObject (required)
  ##             : VNET information
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  var body_594088 = newJObject()
  add(query_594087, "api-version", newJString(apiVersion))
  add(path_594086, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594088 = parameters
  result = call_594085.call(path_594086, query_594087, nil, nil, body_594088)

var verifyHostingEnvironmentVnet* = Call_VerifyHostingEnvironmentVnet_594078(
    name: "verifyHostingEnvironmentVnet", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/verifyHostingEnvironmentVnet",
    validator: validate_VerifyHostingEnvironmentVnet_594079, base: "",
    url: url_VerifyHostingEnvironmentVnet_594080, schemes: {Scheme.Https})
type
  Call_Move_594089 = ref object of OpenApiRestCall_593424
proc url_Move_594091(protocol: Scheme; host: string; base: string; route: string;
                    path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/moveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Move_594090(path: JsonNode; query: JsonNode; header: JsonNode;
                         formData: JsonNode; body: JsonNode): JsonNode =
  ## Move resources between resource groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594092 = path.getOrDefault("resourceGroupName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "resourceGroupName", valid_594092
  var valid_594093 = path.getOrDefault("subscriptionId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "subscriptionId", valid_594093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
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
  ##   moveResourceEnvelope: JObject (required)
  ##                       : Object that represents the resource to move.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594096: Call_Move_594089; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Move resources between resource groups.
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_Move_594089; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; moveResourceEnvelope: JsonNode): Recallable =
  ## move
  ## Move resources between resource groups.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   moveResourceEnvelope: JObject (required)
  ##                       : Object that represents the resource to move.
  var path_594098 = newJObject()
  var query_594099 = newJObject()
  var body_594100 = newJObject()
  add(path_594098, "resourceGroupName", newJString(resourceGroupName))
  add(query_594099, "api-version", newJString(apiVersion))
  add(path_594098, "subscriptionId", newJString(subscriptionId))
  if moveResourceEnvelope != nil:
    body_594100 = moveResourceEnvelope
  result = call_594097.call(path_594098, query_594099, nil, nil, body_594100)

var move* = Call_Move_594089(name: "move", meth: HttpMethod.HttpPost,
                          host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/moveResources",
                          validator: validate_Move_594090, base: "", url: url_Move_594091,
                          schemes: {Scheme.Https})
type
  Call_Validate_594101 = ref object of OpenApiRestCall_593424
proc url_Validate_594103(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Web/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Validate_594102(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Validate if a resource can be created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594104 = path.getOrDefault("resourceGroupName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "resourceGroupName", valid_594104
  var valid_594105 = path.getOrDefault("subscriptionId")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "subscriptionId", valid_594105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594106 = query.getOrDefault("api-version")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "api-version", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   validateRequest: JObject (required)
  ##                  : Request with the resources to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594108: Call_Validate_594101; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validate if a resource can be created.
  ## 
  let valid = call_594108.validator(path, query, header, formData, body)
  let scheme = call_594108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594108.url(scheme.get, call_594108.host, call_594108.base,
                         call_594108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594108, url, valid)

proc call*(call_594109: Call_Validate_594101; resourceGroupName: string;
          apiVersion: string; validateRequest: JsonNode; subscriptionId: string): Recallable =
  ## validate
  ## Validate if a resource can be created.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   validateRequest: JObject (required)
  ##                  : Request with the resources to validate.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594110 = newJObject()
  var query_594111 = newJObject()
  var body_594112 = newJObject()
  add(path_594110, "resourceGroupName", newJString(resourceGroupName))
  add(query_594111, "api-version", newJString(apiVersion))
  if validateRequest != nil:
    body_594112 = validateRequest
  add(path_594110, "subscriptionId", newJString(subscriptionId))
  result = call_594109.call(path_594110, query_594111, nil, nil, body_594112)

var validate* = Call_Validate_594101(name: "validate", meth: HttpMethod.HttpPost,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/validate",
                                  validator: validate_Validate_594102, base: "",
                                  url: url_Validate_594103,
                                  schemes: {Scheme.Https})
type
  Call_ValidateContainerSettings_594113 = ref object of OpenApiRestCall_593424
proc url_ValidateContainerSettings_594115(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/validateContainerSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ValidateContainerSettings_594114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validate if the container settings are correct.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594116 = path.getOrDefault("resourceGroupName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "resourceGroupName", valid_594116
  var valid_594117 = path.getOrDefault("subscriptionId")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "subscriptionId", valid_594117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
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
  ## parameters in `body` object:
  ##   validateContainerSettingsRequest: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594120: Call_ValidateContainerSettings_594113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validate if the container settings are correct.
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_ValidateContainerSettings_594113;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          validateContainerSettingsRequest: JsonNode): Recallable =
  ## validateContainerSettings
  ## Validate if the container settings are correct.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   validateContainerSettingsRequest: JObject (required)
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  var body_594124 = newJObject()
  add(path_594122, "resourceGroupName", newJString(resourceGroupName))
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "subscriptionId", newJString(subscriptionId))
  if validateContainerSettingsRequest != nil:
    body_594124 = validateContainerSettingsRequest
  result = call_594121.call(path_594122, query_594123, nil, nil, body_594124)

var validateContainerSettings* = Call_ValidateContainerSettings_594113(
    name: "validateContainerSettings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/validateContainerSettings",
    validator: validate_ValidateContainerSettings_594114, base: "",
    url: url_ValidateContainerSettings_594115, schemes: {Scheme.Https})
type
  Call_ValidateMove_594125 = ref object of OpenApiRestCall_593424
proc url_ValidateMove_594127(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/validateMoveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ValidateMove_594126(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Validate whether a resource can be moved.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594128 = path.getOrDefault("resourceGroupName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceGroupName", valid_594128
  var valid_594129 = path.getOrDefault("subscriptionId")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "subscriptionId", valid_594129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594130 = query.getOrDefault("api-version")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "api-version", valid_594130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   moveResourceEnvelope: JObject (required)
  ##                       : Object that represents the resource to move.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594132: Call_ValidateMove_594125; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validate whether a resource can be moved.
  ## 
  let valid = call_594132.validator(path, query, header, formData, body)
  let scheme = call_594132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594132.url(scheme.get, call_594132.host, call_594132.base,
                         call_594132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594132, url, valid)

proc call*(call_594133: Call_ValidateMove_594125; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; moveResourceEnvelope: JsonNode): Recallable =
  ## validateMove
  ## Validate whether a resource can be moved.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   moveResourceEnvelope: JObject (required)
  ##                       : Object that represents the resource to move.
  var path_594134 = newJObject()
  var query_594135 = newJObject()
  var body_594136 = newJObject()
  add(path_594134, "resourceGroupName", newJString(resourceGroupName))
  add(query_594135, "api-version", newJString(apiVersion))
  add(path_594134, "subscriptionId", newJString(subscriptionId))
  if moveResourceEnvelope != nil:
    body_594136 = moveResourceEnvelope
  result = call_594133.call(path_594134, query_594135, nil, nil, body_594136)

var validateMove* = Call_ValidateMove_594125(name: "validateMove",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/validateMoveResources",
    validator: validate_ValidateMove_594126, base: "", url: url_ValidateMove_594127,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
