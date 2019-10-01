
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "web-ResourceProvider"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_UpdatePublishingUser_568175 = ref object of OpenApiRestCall_567657
proc url_UpdatePublishingUser_568177(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_UpdatePublishingUser_568176(path: JsonNode; query: JsonNode;
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
  var valid_568178 = query.getOrDefault("api-version")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "api-version", valid_568178
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

proc call*(call_568180: Call_UpdatePublishingUser_568175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates publishing user
  ## 
  let valid = call_568180.validator(path, query, header, formData, body)
  let scheme = call_568180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568180.url(scheme.get, call_568180.host, call_568180.base,
                         call_568180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568180, url, valid)

proc call*(call_568181: Call_UpdatePublishingUser_568175; apiVersion: string;
          userDetails: JsonNode): Recallable =
  ## updatePublishingUser
  ## Updates publishing user
  ##   apiVersion: string (required)
  ##             : API Version
  ##   userDetails: JObject (required)
  ##              : Details of publishing user
  var query_568182 = newJObject()
  var body_568183 = newJObject()
  add(query_568182, "api-version", newJString(apiVersion))
  if userDetails != nil:
    body_568183 = userDetails
  result = call_568181.call(nil, query_568182, nil, nil, body_568183)

var updatePublishingUser* = Call_UpdatePublishingUser_568175(
    name: "updatePublishingUser", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/Microsoft.Web/publishingUsers/web",
    validator: validate_UpdatePublishingUser_568176, base: "",
    url: url_UpdatePublishingUser_568177, schemes: {Scheme.Https})
type
  Call_GetPublishingUser_567879 = ref object of OpenApiRestCall_567657
proc url_GetPublishingUser_567881(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetPublishingUser_567880(path: JsonNode; query: JsonNode;
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
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_GetPublishingUser_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets publishing user
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_GetPublishingUser_567879; apiVersion: string): Recallable =
  ## getPublishingUser
  ## Gets publishing user
  ##   apiVersion: string (required)
  ##             : API Version
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var getPublishingUser* = Call_GetPublishingUser_567879(name: "getPublishingUser",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Web/publishingUsers/web",
    validator: validate_GetPublishingUser_567880, base: "",
    url: url_GetPublishingUser_567881, schemes: {Scheme.Https})
type
  Call_ListSourceControls_568184 = ref object of OpenApiRestCall_567657
proc url_ListSourceControls_568186(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListSourceControls_568185(path: JsonNode; query: JsonNode;
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
  var valid_568187 = query.getOrDefault("api-version")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "api-version", valid_568187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568188: Call_ListSourceControls_568184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the source controls available for Azure websites.
  ## 
  let valid = call_568188.validator(path, query, header, formData, body)
  let scheme = call_568188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568188.url(scheme.get, call_568188.host, call_568188.base,
                         call_568188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568188, url, valid)

proc call*(call_568189: Call_ListSourceControls_568184; apiVersion: string): Recallable =
  ## listSourceControls
  ## Gets the source controls available for Azure websites.
  ##   apiVersion: string (required)
  ##             : API Version
  var query_568190 = newJObject()
  add(query_568190, "api-version", newJString(apiVersion))
  result = call_568189.call(nil, query_568190, nil, nil, nil)

var listSourceControls* = Call_ListSourceControls_568184(
    name: "listSourceControls", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Web/sourcecontrols",
    validator: validate_ListSourceControls_568185, base: "",
    url: url_ListSourceControls_568186, schemes: {Scheme.Https})
type
  Call_UpdateSourceControl_568214 = ref object of OpenApiRestCall_567657
proc url_UpdateSourceControl_568216(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateSourceControl_568215(path: JsonNode; query: JsonNode;
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
  var valid_568217 = path.getOrDefault("sourceControlType")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "sourceControlType", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
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

proc call*(call_568220: Call_UpdateSourceControl_568214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates source control token
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_UpdateSourceControl_568214; apiVersion: string;
          sourceControlType: string; requestMessage: JsonNode): Recallable =
  ## updateSourceControl
  ## Updates source control token
  ##   apiVersion: string (required)
  ##             : API Version
  ##   sourceControlType: string (required)
  ##                    : Type of source control
  ##   requestMessage: JObject (required)
  ##                 : Source control token information
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  var body_568224 = newJObject()
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "sourceControlType", newJString(sourceControlType))
  if requestMessage != nil:
    body_568224 = requestMessage
  result = call_568221.call(path_568222, query_568223, nil, nil, body_568224)

var updateSourceControl* = Call_UpdateSourceControl_568214(
    name: "updateSourceControl", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/Microsoft.Web/sourcecontrols/{sourceControlType}",
    validator: validate_UpdateSourceControl_568215, base: "",
    url: url_UpdateSourceControl_568216, schemes: {Scheme.Https})
type
  Call_GetSourceControl_568191 = ref object of OpenApiRestCall_567657
proc url_GetSourceControl_568193(protocol: Scheme; host: string; base: string;
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

proc validate_GetSourceControl_568192(path: JsonNode; query: JsonNode;
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
  var valid_568208 = path.getOrDefault("sourceControlType")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "sourceControlType", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568209 = query.getOrDefault("api-version")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "api-version", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_GetSourceControl_568191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets source control token
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_GetSourceControl_568191; apiVersion: string;
          sourceControlType: string): Recallable =
  ## getSourceControl
  ## Gets source control token
  ##   apiVersion: string (required)
  ##             : API Version
  ##   sourceControlType: string (required)
  ##                    : Type of source control
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "sourceControlType", newJString(sourceControlType))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var getSourceControl* = Call_GetSourceControl_568191(name: "getSourceControl",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Web/sourcecontrols/{sourceControlType}",
    validator: validate_GetSourceControl_568192, base: "",
    url: url_GetSourceControl_568193, schemes: {Scheme.Https})
type
  Call_ListBillingMeters_568225 = ref object of OpenApiRestCall_567657
proc url_ListBillingMeters_568227(protocol: Scheme; host: string; base: string;
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

proc validate_ListBillingMeters_568226(path: JsonNode; query: JsonNode;
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
  var valid_568228 = path.getOrDefault("subscriptionId")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "subscriptionId", valid_568228
  result.add "path", section
  ## parameters in `query` object:
  ##   billingLocation: JString
  ##                  : Azure Location of billable resource
  ##   api-version: JString (required)
  ##              : API Version
  ##   osType: JString
  ##         : App Service OS type meters used for
  section = newJObject()
  var valid_568229 = query.getOrDefault("billingLocation")
  valid_568229 = validateParameter(valid_568229, JString, required = false,
                                 default = nil)
  if valid_568229 != nil:
    section.add "billingLocation", valid_568229
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  var valid_568231 = query.getOrDefault("osType")
  valid_568231 = validateParameter(valid_568231, JString, required = false,
                                 default = nil)
  if valid_568231 != nil:
    section.add "osType", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_ListBillingMeters_568225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of meters for a given location.
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_ListBillingMeters_568225; apiVersion: string;
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
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(query_568235, "billingLocation", newJString(billingLocation))
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  add(query_568235, "osType", newJString(osType))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var listBillingMeters* = Call_ListBillingMeters_568225(name: "listBillingMeters",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/billingMeters",
    validator: validate_ListBillingMeters_568226, base: "",
    url: url_ListBillingMeters_568227, schemes: {Scheme.Https})
type
  Call_CheckNameAvailability_568236 = ref object of OpenApiRestCall_567657
proc url_CheckNameAvailability_568238(protocol: Scheme; host: string; base: string;
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

proc validate_CheckNameAvailability_568237(path: JsonNode; query: JsonNode;
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
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568240 = query.getOrDefault("api-version")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "api-version", valid_568240
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

proc call*(call_568242: Call_CheckNameAvailability_568236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if a resource name is available.
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_CheckNameAvailability_568236; apiVersion: string;
          subscriptionId: string; request: JsonNode): Recallable =
  ## checkNameAvailability
  ## Check if a resource name is available.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   request: JObject (required)
  ##          : Name availability request.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  var body_568246 = newJObject()
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_568246 = request
  result = call_568243.call(path_568244, query_568245, nil, nil, body_568246)

var checkNameAvailability* = Call_CheckNameAvailability_568236(
    name: "checkNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/checknameavailability",
    validator: validate_CheckNameAvailability_568237, base: "",
    url: url_CheckNameAvailability_568238, schemes: {Scheme.Https})
type
  Call_GetSubscriptionDeploymentLocations_568247 = ref object of OpenApiRestCall_567657
proc url_GetSubscriptionDeploymentLocations_568249(protocol: Scheme; host: string;
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

proc validate_GetSubscriptionDeploymentLocations_568248(path: JsonNode;
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
  var valid_568250 = path.getOrDefault("subscriptionId")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "subscriptionId", valid_568250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568251 = query.getOrDefault("api-version")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "api-version", valid_568251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568252: Call_GetSubscriptionDeploymentLocations_568247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets list of available geo regions plus ministamps
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_GetSubscriptionDeploymentLocations_568247;
          apiVersion: string; subscriptionId: string): Recallable =
  ## getSubscriptionDeploymentLocations
  ## Gets list of available geo regions plus ministamps
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "subscriptionId", newJString(subscriptionId))
  result = call_568253.call(path_568254, query_568255, nil, nil, nil)

var getSubscriptionDeploymentLocations* = Call_GetSubscriptionDeploymentLocations_568247(
    name: "getSubscriptionDeploymentLocations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/deploymentLocations",
    validator: validate_GetSubscriptionDeploymentLocations_568248, base: "",
    url: url_GetSubscriptionDeploymentLocations_568249, schemes: {Scheme.Https})
type
  Call_ListGeoRegions_568256 = ref object of OpenApiRestCall_567657
proc url_ListGeoRegions_568258(protocol: Scheme; host: string; base: string;
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

proc validate_ListGeoRegions_568257(path: JsonNode; query: JsonNode;
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
  var valid_568259 = path.getOrDefault("subscriptionId")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "subscriptionId", valid_568259
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
  var valid_568260 = query.getOrDefault("api-version")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "api-version", valid_568260
  var valid_568261 = query.getOrDefault("linuxWorkersEnabled")
  valid_568261 = validateParameter(valid_568261, JBool, required = false, default = nil)
  if valid_568261 != nil:
    section.add "linuxWorkersEnabled", valid_568261
  var valid_568275 = query.getOrDefault("sku")
  valid_568275 = validateParameter(valid_568275, JString, required = false,
                                 default = newJString("Free"))
  if valid_568275 != nil:
    section.add "sku", valid_568275
  var valid_568276 = query.getOrDefault("xenonWorkersEnabled")
  valid_568276 = validateParameter(valid_568276, JBool, required = false, default = nil)
  if valid_568276 != nil:
    section.add "xenonWorkersEnabled", valid_568276
  var valid_568277 = query.getOrDefault("linuxDynamicWorkersEnabled")
  valid_568277 = validateParameter(valid_568277, JBool, required = false, default = nil)
  if valid_568277 != nil:
    section.add "linuxDynamicWorkersEnabled", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_ListGeoRegions_568256; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of available geographical regions.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_ListGeoRegions_568256; apiVersion: string;
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
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "subscriptionId", newJString(subscriptionId))
  add(query_568281, "linuxWorkersEnabled", newJBool(linuxWorkersEnabled))
  add(query_568281, "sku", newJString(sku))
  add(query_568281, "xenonWorkersEnabled", newJBool(xenonWorkersEnabled))
  add(query_568281, "linuxDynamicWorkersEnabled",
      newJBool(linuxDynamicWorkersEnabled))
  result = call_568279.call(path_568280, query_568281, nil, nil, nil)

var listGeoRegions* = Call_ListGeoRegions_568256(name: "listGeoRegions",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/geoRegions",
    validator: validate_ListGeoRegions_568257, base: "", url: url_ListGeoRegions_568258,
    schemes: {Scheme.Https})
type
  Call_ListSiteIdentifiersAssignedToHostName_568282 = ref object of OpenApiRestCall_567657
proc url_ListSiteIdentifiersAssignedToHostName_568284(protocol: Scheme;
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

proc validate_ListSiteIdentifiersAssignedToHostName_568283(path: JsonNode;
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
  var valid_568285 = path.getOrDefault("subscriptionId")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "subscriptionId", valid_568285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568286 = query.getOrDefault("api-version")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "api-version", valid_568286
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

proc call*(call_568288: Call_ListSiteIdentifiersAssignedToHostName_568282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all apps that are assigned to a hostname.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_ListSiteIdentifiersAssignedToHostName_568282;
          apiVersion: string; subscriptionId: string; nameIdentifier: JsonNode): Recallable =
  ## listSiteIdentifiersAssignedToHostName
  ## List all apps that are assigned to a hostname.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   nameIdentifier: JObject (required)
  ##                 : Hostname information.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  var body_568292 = newJObject()
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  if nameIdentifier != nil:
    body_568292 = nameIdentifier
  result = call_568289.call(path_568290, query_568291, nil, nil, body_568292)

var listSiteIdentifiersAssignedToHostName* = Call_ListSiteIdentifiersAssignedToHostName_568282(
    name: "listSiteIdentifiersAssignedToHostName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/listSitesAssignedToHostName",
    validator: validate_ListSiteIdentifiersAssignedToHostName_568283, base: "",
    url: url_ListSiteIdentifiersAssignedToHostName_568284, schemes: {Scheme.Https})
type
  Call_ListPremierAddOnOffers_568293 = ref object of OpenApiRestCall_567657
proc url_ListPremierAddOnOffers_568295(protocol: Scheme; host: string; base: string;
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

proc validate_ListPremierAddOnOffers_568294(path: JsonNode; query: JsonNode;
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
  var valid_568296 = path.getOrDefault("subscriptionId")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "subscriptionId", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568298: Call_ListPremierAddOnOffers_568293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all premier add-on offers.
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_ListPremierAddOnOffers_568293; apiVersion: string;
          subscriptionId: string): Recallable =
  ## listPremierAddOnOffers
  ## List all premier add-on offers.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "subscriptionId", newJString(subscriptionId))
  result = call_568299.call(path_568300, query_568301, nil, nil, nil)

var listPremierAddOnOffers* = Call_ListPremierAddOnOffers_568293(
    name: "listPremierAddOnOffers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/premieraddonoffers",
    validator: validate_ListPremierAddOnOffers_568294, base: "",
    url: url_ListPremierAddOnOffers_568295, schemes: {Scheme.Https})
type
  Call_ListSkus_568302 = ref object of OpenApiRestCall_567657
proc url_ListSkus_568304(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ListSkus_568303(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568305 = path.getOrDefault("subscriptionId")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "subscriptionId", valid_568305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568306 = query.getOrDefault("api-version")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "api-version", valid_568306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568307: Call_ListSkus_568302; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all SKUs.
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_ListSkus_568302; apiVersion: string;
          subscriptionId: string): Recallable =
  ## listSkus
  ## List all SKUs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  add(query_568310, "api-version", newJString(apiVersion))
  add(path_568309, "subscriptionId", newJString(subscriptionId))
  result = call_568308.call(path_568309, query_568310, nil, nil, nil)

var listSkus* = Call_ListSkus_568302(name: "listSkus", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/skus",
                                  validator: validate_ListSkus_568303, base: "",
                                  url: url_ListSkus_568304,
                                  schemes: {Scheme.Https})
type
  Call_VerifyHostingEnvironmentVnet_568311 = ref object of OpenApiRestCall_567657
proc url_VerifyHostingEnvironmentVnet_568313(protocol: Scheme; host: string;
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

proc validate_VerifyHostingEnvironmentVnet_568312(path: JsonNode; query: JsonNode;
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
  var valid_568314 = path.getOrDefault("subscriptionId")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "subscriptionId", valid_568314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568315 = query.getOrDefault("api-version")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "api-version", valid_568315
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

proc call*(call_568317: Call_VerifyHostingEnvironmentVnet_568311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies if this VNET is compatible with an App Service Environment by analyzing the Network Security Group rules.
  ## 
  let valid = call_568317.validator(path, query, header, formData, body)
  let scheme = call_568317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568317.url(scheme.get, call_568317.host, call_568317.base,
                         call_568317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568317, url, valid)

proc call*(call_568318: Call_VerifyHostingEnvironmentVnet_568311;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## verifyHostingEnvironmentVnet
  ## Verifies if this VNET is compatible with an App Service Environment by analyzing the Network Security Group rules.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   parameters: JObject (required)
  ##             : VNET information
  var path_568319 = newJObject()
  var query_568320 = newJObject()
  var body_568321 = newJObject()
  add(query_568320, "api-version", newJString(apiVersion))
  add(path_568319, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568321 = parameters
  result = call_568318.call(path_568319, query_568320, nil, nil, body_568321)

var verifyHostingEnvironmentVnet* = Call_VerifyHostingEnvironmentVnet_568311(
    name: "verifyHostingEnvironmentVnet", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/verifyHostingEnvironmentVnet",
    validator: validate_VerifyHostingEnvironmentVnet_568312, base: "",
    url: url_VerifyHostingEnvironmentVnet_568313, schemes: {Scheme.Https})
type
  Call_Move_568322 = ref object of OpenApiRestCall_567657
proc url_Move_568324(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Move_568323(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568325 = path.getOrDefault("resourceGroupName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "resourceGroupName", valid_568325
  var valid_568326 = path.getOrDefault("subscriptionId")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "subscriptionId", valid_568326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568327 = query.getOrDefault("api-version")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "api-version", valid_568327
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

proc call*(call_568329: Call_Move_568322; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Move resources between resource groups.
  ## 
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_Move_568322; resourceGroupName: string;
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
  var path_568331 = newJObject()
  var query_568332 = newJObject()
  var body_568333 = newJObject()
  add(path_568331, "resourceGroupName", newJString(resourceGroupName))
  add(query_568332, "api-version", newJString(apiVersion))
  add(path_568331, "subscriptionId", newJString(subscriptionId))
  if moveResourceEnvelope != nil:
    body_568333 = moveResourceEnvelope
  result = call_568330.call(path_568331, query_568332, nil, nil, body_568333)

var move* = Call_Move_568322(name: "move", meth: HttpMethod.HttpPost,
                          host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/moveResources",
                          validator: validate_Move_568323, base: "", url: url_Move_568324,
                          schemes: {Scheme.Https})
type
  Call_Validate_568334 = ref object of OpenApiRestCall_567657
proc url_Validate_568336(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Validate_568335(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568337 = path.getOrDefault("resourceGroupName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "resourceGroupName", valid_568337
  var valid_568338 = path.getOrDefault("subscriptionId")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "subscriptionId", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "api-version", valid_568339
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

proc call*(call_568341: Call_Validate_568334; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validate if a resource can be created.
  ## 
  let valid = call_568341.validator(path, query, header, formData, body)
  let scheme = call_568341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568341.url(scheme.get, call_568341.host, call_568341.base,
                         call_568341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568341, url, valid)

proc call*(call_568342: Call_Validate_568334; resourceGroupName: string;
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
  var path_568343 = newJObject()
  var query_568344 = newJObject()
  var body_568345 = newJObject()
  add(path_568343, "resourceGroupName", newJString(resourceGroupName))
  add(query_568344, "api-version", newJString(apiVersion))
  if validateRequest != nil:
    body_568345 = validateRequest
  add(path_568343, "subscriptionId", newJString(subscriptionId))
  result = call_568342.call(path_568343, query_568344, nil, nil, body_568345)

var validate* = Call_Validate_568334(name: "validate", meth: HttpMethod.HttpPost,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/validate",
                                  validator: validate_Validate_568335, base: "",
                                  url: url_Validate_568336,
                                  schemes: {Scheme.Https})
type
  Call_ValidateContainerSettings_568346 = ref object of OpenApiRestCall_567657
proc url_ValidateContainerSettings_568348(protocol: Scheme; host: string;
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

proc validate_ValidateContainerSettings_568347(path: JsonNode; query: JsonNode;
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
  var valid_568349 = path.getOrDefault("resourceGroupName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "resourceGroupName", valid_568349
  var valid_568350 = path.getOrDefault("subscriptionId")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "subscriptionId", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
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

proc call*(call_568353: Call_ValidateContainerSettings_568346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validate if the container settings are correct.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_ValidateContainerSettings_568346;
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
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  var body_568357 = newJObject()
  add(path_568355, "resourceGroupName", newJString(resourceGroupName))
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  if validateContainerSettingsRequest != nil:
    body_568357 = validateContainerSettingsRequest
  result = call_568354.call(path_568355, query_568356, nil, nil, body_568357)

var validateContainerSettings* = Call_ValidateContainerSettings_568346(
    name: "validateContainerSettings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/validateContainerSettings",
    validator: validate_ValidateContainerSettings_568347, base: "",
    url: url_ValidateContainerSettings_568348, schemes: {Scheme.Https})
type
  Call_ValidateMove_568358 = ref object of OpenApiRestCall_567657
proc url_ValidateMove_568360(protocol: Scheme; host: string; base: string;
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

proc validate_ValidateMove_568359(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568361 = path.getOrDefault("resourceGroupName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "resourceGroupName", valid_568361
  var valid_568362 = path.getOrDefault("subscriptionId")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "subscriptionId", valid_568362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568363 = query.getOrDefault("api-version")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "api-version", valid_568363
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

proc call*(call_568365: Call_ValidateMove_568358; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validate whether a resource can be moved.
  ## 
  let valid = call_568365.validator(path, query, header, formData, body)
  let scheme = call_568365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568365.url(scheme.get, call_568365.host, call_568365.base,
                         call_568365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568365, url, valid)

proc call*(call_568366: Call_ValidateMove_568358; resourceGroupName: string;
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
  var path_568367 = newJObject()
  var query_568368 = newJObject()
  var body_568369 = newJObject()
  add(path_568367, "resourceGroupName", newJString(resourceGroupName))
  add(query_568368, "api-version", newJString(apiVersion))
  add(path_568367, "subscriptionId", newJString(subscriptionId))
  if moveResourceEnvelope != nil:
    body_568369 = moveResourceEnvelope
  result = call_568366.call(path_568367, query_568368, nil, nil, body_568369)

var validateMove* = Call_ValidateMove_568358(name: "validateMove",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/validateMoveResources",
    validator: validate_ValidateMove_568359, base: "", url: url_ValidateMove_568360,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
