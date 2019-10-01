
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ManagedLabsClient
## version: 2018-10-15
## termsOfService: (not provided)
## license: (not provided)
## 
## The Managed Labs Client.
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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  macServiceName = "labservices-ML"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProviderOperationsList_567888 = ref object of OpenApiRestCall_567666
proc url_ProviderOperationsList_567890(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsList_567889(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Result of the request to list REST API operations
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568062 = query.getOrDefault("api-version")
  valid_568062 = validateParameter(valid_568062, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568062 != nil:
    section.add "api-version", valid_568062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568085: Call_ProviderOperationsList_567888; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Result of the request to list REST API operations
  ## 
  let valid = call_568085.validator(path, query, header, formData, body)
  let scheme = call_568085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568085.url(scheme.get, call_568085.host, call_568085.base,
                         call_568085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568085, url, valid)

proc call*(call_568156: Call_ProviderOperationsList_567888;
          apiVersion: string = "2018-10-15"): Recallable =
  ## providerOperationsList
  ## Result of the request to list REST API operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_568157 = newJObject()
  add(query_568157, "api-version", newJString(apiVersion))
  result = call_568156.call(nil, query_568157, nil, nil, nil)

var providerOperationsList* = Call_ProviderOperationsList_567888(
    name: "providerOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/operations",
    validator: validate_ProviderOperationsList_567889, base: "",
    url: url_ProviderOperationsList_567890, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetEnvironment_568197 = ref object of OpenApiRestCall_567666
proc url_GlobalUsersGetEnvironment_568199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.LabServices/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/getEnvironment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalUsersGetEnvironment_568198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the virtual machine details
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userName` field"
  var valid_568215 = path.getOrDefault("userName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "userName", valid_568215
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=environment)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568216 = query.getOrDefault("$expand")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = nil)
  if valid_568216 != nil:
    section.add "$expand", valid_568216
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   environmentOperationsPayload: JObject (required)
  ##                               : Represents payload for any Environment operations like get, start, stop, connect
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_GlobalUsersGetEnvironment_568197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the virtual machine details
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_GlobalUsersGetEnvironment_568197; userName: string;
          environmentOperationsPayload: JsonNode; Expand: string = "";
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersGetEnvironment
  ## Gets the virtual machine details
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=environment)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  ##   environmentOperationsPayload: JObject (required)
  ##                               : Represents payload for any Environment operations like get, start, stop, connect
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  var body_568223 = newJObject()
  add(query_568222, "$expand", newJString(Expand))
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "userName", newJString(userName))
  if environmentOperationsPayload != nil:
    body_568223 = environmentOperationsPayload
  result = call_568220.call(path_568221, query_568222, nil, nil, body_568223)

var globalUsersGetEnvironment* = Call_GlobalUsersGetEnvironment_568197(
    name: "globalUsersGetEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/getEnvironment",
    validator: validate_GlobalUsersGetEnvironment_568198, base: "",
    url: url_GlobalUsersGetEnvironment_568199, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetOperationBatchStatus_568224 = ref object of OpenApiRestCall_567666
proc url_GlobalUsersGetOperationBatchStatus_568226(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.LabServices/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/getOperationBatchStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalUsersGetOperationBatchStatus_568225(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get batch operation status
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userName` field"
  var valid_568227 = path.getOrDefault("userName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "userName", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   operationBatchStatusPayload: JObject (required)
  ##                              : Payload to get the status of an operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568230: Call_GlobalUsersGetOperationBatchStatus_568224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get batch operation status
  ## 
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_GlobalUsersGetOperationBatchStatus_568224;
          userName: string; operationBatchStatusPayload: JsonNode;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersGetOperationBatchStatus
  ## Get batch operation status
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  ##   operationBatchStatusPayload: JObject (required)
  ##                              : Payload to get the status of an operation
  var path_568232 = newJObject()
  var query_568233 = newJObject()
  var body_568234 = newJObject()
  add(query_568233, "api-version", newJString(apiVersion))
  add(path_568232, "userName", newJString(userName))
  if operationBatchStatusPayload != nil:
    body_568234 = operationBatchStatusPayload
  result = call_568231.call(path_568232, query_568233, nil, nil, body_568234)

var globalUsersGetOperationBatchStatus* = Call_GlobalUsersGetOperationBatchStatus_568224(
    name: "globalUsersGetOperationBatchStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/getOperationBatchStatus",
    validator: validate_GlobalUsersGetOperationBatchStatus_568225, base: "",
    url: url_GlobalUsersGetOperationBatchStatus_568226, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetOperationStatus_568235 = ref object of OpenApiRestCall_567666
proc url_GlobalUsersGetOperationStatus_568237(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.LabServices/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/getOperationStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalUsersGetOperationStatus_568236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of long running operation
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userName` field"
  var valid_568238 = path.getOrDefault("userName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "userName", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   operationStatusPayload: JObject (required)
  ##                         : Payload to get the status of an operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568241: Call_GlobalUsersGetOperationStatus_568235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of long running operation
  ## 
  let valid = call_568241.validator(path, query, header, formData, body)
  let scheme = call_568241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568241.url(scheme.get, call_568241.host, call_568241.base,
                         call_568241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568241, url, valid)

proc call*(call_568242: Call_GlobalUsersGetOperationStatus_568235;
          operationStatusPayload: JsonNode; userName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersGetOperationStatus
  ## Gets the status of long running operation
  ##   operationStatusPayload: JObject (required)
  ##                         : Payload to get the status of an operation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_568243 = newJObject()
  var query_568244 = newJObject()
  var body_568245 = newJObject()
  if operationStatusPayload != nil:
    body_568245 = operationStatusPayload
  add(query_568244, "api-version", newJString(apiVersion))
  add(path_568243, "userName", newJString(userName))
  result = call_568242.call(path_568243, query_568244, nil, nil, body_568245)

var globalUsersGetOperationStatus* = Call_GlobalUsersGetOperationStatus_568235(
    name: "globalUsersGetOperationStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/getOperationStatus",
    validator: validate_GlobalUsersGetOperationStatus_568236, base: "",
    url: url_GlobalUsersGetOperationStatus_568237, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetPersonalPreferences_568246 = ref object of OpenApiRestCall_567666
proc url_GlobalUsersGetPersonalPreferences_568248(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.LabServices/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/getPersonalPreferences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalUsersGetPersonalPreferences_568247(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get personal preferences for a user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userName` field"
  var valid_568249 = path.getOrDefault("userName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "userName", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568250 != nil:
    section.add "api-version", valid_568250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   personalPreferencesOperationsPayload: JObject (required)
  ##                                       : Represents payload for any Environment operations like get, start, stop, connect
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568252: Call_GlobalUsersGetPersonalPreferences_568246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get personal preferences for a user
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_GlobalUsersGetPersonalPreferences_568246;
          personalPreferencesOperationsPayload: JsonNode; userName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersGetPersonalPreferences
  ## Get personal preferences for a user
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   personalPreferencesOperationsPayload: JObject (required)
  ##                                       : Represents payload for any Environment operations like get, start, stop, connect
  ##   userName: string (required)
  ##           : The name of the user.
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  var body_568256 = newJObject()
  add(query_568255, "api-version", newJString(apiVersion))
  if personalPreferencesOperationsPayload != nil:
    body_568256 = personalPreferencesOperationsPayload
  add(path_568254, "userName", newJString(userName))
  result = call_568253.call(path_568254, query_568255, nil, nil, body_568256)

var globalUsersGetPersonalPreferences* = Call_GlobalUsersGetPersonalPreferences_568246(
    name: "globalUsersGetPersonalPreferences", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/getPersonalPreferences",
    validator: validate_GlobalUsersGetPersonalPreferences_568247, base: "",
    url: url_GlobalUsersGetPersonalPreferences_568248, schemes: {Scheme.Https})
type
  Call_GlobalUsersListEnvironments_568257 = ref object of OpenApiRestCall_567666
proc url_GlobalUsersListEnvironments_568259(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.LabServices/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/listEnvironments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalUsersListEnvironments_568258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Environments for the user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userName` field"
  var valid_568260 = path.getOrDefault("userName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "userName", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listEnvironmentsPayload: JObject (required)
  ##                          : Represents the payload to list environments owned by a user
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_GlobalUsersListEnvironments_568257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Environments for the user
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_GlobalUsersListEnvironments_568257;
          listEnvironmentsPayload: JsonNode; userName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersListEnvironments
  ## List Environments for the user
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   listEnvironmentsPayload: JObject (required)
  ##                          : Represents the payload to list environments owned by a user
  ##   userName: string (required)
  ##           : The name of the user.
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  var body_568267 = newJObject()
  add(query_568266, "api-version", newJString(apiVersion))
  if listEnvironmentsPayload != nil:
    body_568267 = listEnvironmentsPayload
  add(path_568265, "userName", newJString(userName))
  result = call_568264.call(path_568265, query_568266, nil, nil, body_568267)

var globalUsersListEnvironments* = Call_GlobalUsersListEnvironments_568257(
    name: "globalUsersListEnvironments", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/listEnvironments",
    validator: validate_GlobalUsersListEnvironments_568258, base: "",
    url: url_GlobalUsersListEnvironments_568259, schemes: {Scheme.Https})
type
  Call_GlobalUsersListLabs_568268 = ref object of OpenApiRestCall_567666
proc url_GlobalUsersListLabs_568270(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.LabServices/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/listLabs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalUsersListLabs_568269(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List labs for the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userName` field"
  var valid_568271 = path.getOrDefault("userName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "userName", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_GlobalUsersListLabs_568268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs for the user.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_GlobalUsersListLabs_568268; userName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersListLabs
  ## List labs for the user.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  add(query_568276, "api-version", newJString(apiVersion))
  add(path_568275, "userName", newJString(userName))
  result = call_568274.call(path_568275, query_568276, nil, nil, nil)

var globalUsersListLabs* = Call_GlobalUsersListLabs_568268(
    name: "globalUsersListLabs", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/listLabs",
    validator: validate_GlobalUsersListLabs_568269, base: "",
    url: url_GlobalUsersListLabs_568270, schemes: {Scheme.Https})
type
  Call_GlobalUsersRegister_568277 = ref object of OpenApiRestCall_567666
proc url_GlobalUsersRegister_568279(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.LabServices/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/register")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalUsersRegister_568278(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Register a user to a managed lab
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userName` field"
  var valid_568280 = path.getOrDefault("userName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "userName", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568281 = query.getOrDefault("api-version")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568281 != nil:
    section.add "api-version", valid_568281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   registerPayload: JObject (required)
  ##                  : Represents payload for Register action.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_GlobalUsersRegister_568277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register a user to a managed lab
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_GlobalUsersRegister_568277; registerPayload: JsonNode;
          userName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersRegister
  ## Register a user to a managed lab
  ##   registerPayload: JObject (required)
  ##                  : Represents payload for Register action.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  var body_568287 = newJObject()
  if registerPayload != nil:
    body_568287 = registerPayload
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "userName", newJString(userName))
  result = call_568284.call(path_568285, query_568286, nil, nil, body_568287)

var globalUsersRegister* = Call_GlobalUsersRegister_568277(
    name: "globalUsersRegister", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/register",
    validator: validate_GlobalUsersRegister_568278, base: "",
    url: url_GlobalUsersRegister_568279, schemes: {Scheme.Https})
type
  Call_GlobalUsersResetPassword_568288 = ref object of OpenApiRestCall_567666
proc url_GlobalUsersResetPassword_568290(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.LabServices/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/resetPassword")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalUsersResetPassword_568289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets the user password on an environment This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userName` field"
  var valid_568291 = path.getOrDefault("userName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "userName", valid_568291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568292 = query.getOrDefault("api-version")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568292 != nil:
    section.add "api-version", valid_568292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resetPasswordPayload: JObject (required)
  ##                       : Represents the payload for resetting passwords.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_GlobalUsersResetPassword_568288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the user password on an environment This operation can take a while to complete
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_GlobalUsersResetPassword_568288; userName: string;
          resetPasswordPayload: JsonNode; apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersResetPassword
  ## Resets the user password on an environment This operation can take a while to complete
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  ##   resetPasswordPayload: JObject (required)
  ##                       : Represents the payload for resetting passwords.
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  var body_568298 = newJObject()
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "userName", newJString(userName))
  if resetPasswordPayload != nil:
    body_568298 = resetPasswordPayload
  result = call_568295.call(path_568296, query_568297, nil, nil, body_568298)

var globalUsersResetPassword* = Call_GlobalUsersResetPassword_568288(
    name: "globalUsersResetPassword", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/resetPassword",
    validator: validate_GlobalUsersResetPassword_568289, base: "",
    url: url_GlobalUsersResetPassword_568290, schemes: {Scheme.Https})
type
  Call_GlobalUsersStartEnvironment_568299 = ref object of OpenApiRestCall_567666
proc url_GlobalUsersStartEnvironment_568301(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.LabServices/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/startEnvironment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalUsersStartEnvironment_568300(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userName` field"
  var valid_568302 = path.getOrDefault("userName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "userName", valid_568302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568303 = query.getOrDefault("api-version")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568303 != nil:
    section.add "api-version", valid_568303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   environmentOperationsPayload: JObject (required)
  ##                               : Represents payload for any Environment operations like get, start, stop, connect
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_GlobalUsersStartEnvironment_568299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ## 
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_GlobalUsersStartEnvironment_568299; userName: string;
          environmentOperationsPayload: JsonNode;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersStartEnvironment
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  ##   environmentOperationsPayload: JObject (required)
  ##                               : Represents payload for any Environment operations like get, start, stop, connect
  var path_568307 = newJObject()
  var query_568308 = newJObject()
  var body_568309 = newJObject()
  add(query_568308, "api-version", newJString(apiVersion))
  add(path_568307, "userName", newJString(userName))
  if environmentOperationsPayload != nil:
    body_568309 = environmentOperationsPayload
  result = call_568306.call(path_568307, query_568308, nil, nil, body_568309)

var globalUsersStartEnvironment* = Call_GlobalUsersStartEnvironment_568299(
    name: "globalUsersStartEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/startEnvironment",
    validator: validate_GlobalUsersStartEnvironment_568300, base: "",
    url: url_GlobalUsersStartEnvironment_568301, schemes: {Scheme.Https})
type
  Call_GlobalUsersStopEnvironment_568310 = ref object of OpenApiRestCall_567666
proc url_GlobalUsersStopEnvironment_568312(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.LabServices/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/stopEnvironment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalUsersStopEnvironment_568311(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userName` field"
  var valid_568313 = path.getOrDefault("userName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "userName", valid_568313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568314 = query.getOrDefault("api-version")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568314 != nil:
    section.add "api-version", valid_568314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   environmentOperationsPayload: JObject (required)
  ##                               : Represents payload for any Environment operations like get, start, stop, connect
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568316: Call_GlobalUsersStopEnvironment_568310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_GlobalUsersStopEnvironment_568310; userName: string;
          environmentOperationsPayload: JsonNode;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersStopEnvironment
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  ##   environmentOperationsPayload: JObject (required)
  ##                               : Represents payload for any Environment operations like get, start, stop, connect
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  var body_568320 = newJObject()
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "userName", newJString(userName))
  if environmentOperationsPayload != nil:
    body_568320 = environmentOperationsPayload
  result = call_568317.call(path_568318, query_568319, nil, nil, body_568320)

var globalUsersStopEnvironment* = Call_GlobalUsersStopEnvironment_568310(
    name: "globalUsersStopEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/stopEnvironment",
    validator: validate_GlobalUsersStopEnvironment_568311, base: "",
    url: url_GlobalUsersStopEnvironment_568312, schemes: {Scheme.Https})
type
  Call_LabAccountsListBySubscription_568321 = ref object of OpenApiRestCall_567666
proc url_LabAccountsListBySubscription_568323(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.LabServices/labaccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabAccountsListBySubscription_568322(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List lab accounts in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568324 = path.getOrDefault("subscriptionId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "subscriptionId", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568325 = query.getOrDefault("$orderby")
  valid_568325 = validateParameter(valid_568325, JString, required = false,
                                 default = nil)
  if valid_568325 != nil:
    section.add "$orderby", valid_568325
  var valid_568326 = query.getOrDefault("$expand")
  valid_568326 = validateParameter(valid_568326, JString, required = false,
                                 default = nil)
  if valid_568326 != nil:
    section.add "$expand", valid_568326
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568327 = query.getOrDefault("api-version")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568327 != nil:
    section.add "api-version", valid_568327
  var valid_568328 = query.getOrDefault("$top")
  valid_568328 = validateParameter(valid_568328, JInt, required = false, default = nil)
  if valid_568328 != nil:
    section.add "$top", valid_568328
  var valid_568329 = query.getOrDefault("$filter")
  valid_568329 = validateParameter(valid_568329, JString, required = false,
                                 default = nil)
  if valid_568329 != nil:
    section.add "$filter", valid_568329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568330: Call_LabAccountsListBySubscription_568321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List lab accounts in a subscription.
  ## 
  let valid = call_568330.validator(path, query, header, formData, body)
  let scheme = call_568330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568330.url(scheme.get, call_568330.host, call_568330.base,
                         call_568330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568330, url, valid)

proc call*(call_568331: Call_LabAccountsListBySubscription_568321;
          subscriptionId: string; Orderby: string = ""; Expand: string = "";
          apiVersion: string = "2018-10-15"; Top: int = 0; Filter: string = ""): Recallable =
  ## labAccountsListBySubscription
  ## List lab accounts in a subscription.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568332 = newJObject()
  var query_568333 = newJObject()
  add(query_568333, "$orderby", newJString(Orderby))
  add(query_568333, "$expand", newJString(Expand))
  add(query_568333, "api-version", newJString(apiVersion))
  add(path_568332, "subscriptionId", newJString(subscriptionId))
  add(query_568333, "$top", newJInt(Top))
  add(query_568333, "$filter", newJString(Filter))
  result = call_568331.call(path_568332, query_568333, nil, nil, nil)

var labAccountsListBySubscription* = Call_LabAccountsListBySubscription_568321(
    name: "labAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.LabServices/labaccounts",
    validator: validate_LabAccountsListBySubscription_568322, base: "",
    url: url_LabAccountsListBySubscription_568323, schemes: {Scheme.Https})
type
  Call_OperationsGet_568334 = ref object of OpenApiRestCall_567666
proc url_OperationsGet_568336(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "operationName" in path, "`operationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsGet_568335(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get operation
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   locationName: JString (required)
  ##               : The name of the location.
  ##   operationName: JString (required)
  ##                : The name of the operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568337 = path.getOrDefault("subscriptionId")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "subscriptionId", valid_568337
  var valid_568338 = path.getOrDefault("locationName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "locationName", valid_568338
  var valid_568339 = path.getOrDefault("operationName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "operationName", valid_568339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568340 = query.getOrDefault("api-version")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568340 != nil:
    section.add "api-version", valid_568340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568341: Call_OperationsGet_568334; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get operation
  ## 
  let valid = call_568341.validator(path, query, header, formData, body)
  let scheme = call_568341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568341.url(scheme.get, call_568341.host, call_568341.base,
                         call_568341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568341, url, valid)

proc call*(call_568342: Call_OperationsGet_568334; subscriptionId: string;
          locationName: string; operationName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## operationsGet
  ## Get operation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   locationName: string (required)
  ##               : The name of the location.
  ##   operationName: string (required)
  ##                : The name of the operation.
  var path_568343 = newJObject()
  var query_568344 = newJObject()
  add(query_568344, "api-version", newJString(apiVersion))
  add(path_568343, "subscriptionId", newJString(subscriptionId))
  add(path_568343, "locationName", newJString(locationName))
  add(path_568343, "operationName", newJString(operationName))
  result = call_568342.call(path_568343, query_568344, nil, nil, nil)

var operationsGet* = Call_OperationsGet_568334(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.LabServices/locations/{locationName}/operations/{operationName}",
    validator: validate_OperationsGet_568335, base: "", url: url_OperationsGet_568336,
    schemes: {Scheme.Https})
type
  Call_LabAccountsListByResourceGroup_568345 = ref object of OpenApiRestCall_567666
proc url_LabAccountsListByResourceGroup_568347(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.LabServices/labaccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabAccountsListByResourceGroup_568346(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List lab accounts in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568348 = path.getOrDefault("resourceGroupName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "resourceGroupName", valid_568348
  var valid_568349 = path.getOrDefault("subscriptionId")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "subscriptionId", valid_568349
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568350 = query.getOrDefault("$orderby")
  valid_568350 = validateParameter(valid_568350, JString, required = false,
                                 default = nil)
  if valid_568350 != nil:
    section.add "$orderby", valid_568350
  var valid_568351 = query.getOrDefault("$expand")
  valid_568351 = validateParameter(valid_568351, JString, required = false,
                                 default = nil)
  if valid_568351 != nil:
    section.add "$expand", valid_568351
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568352 != nil:
    section.add "api-version", valid_568352
  var valid_568353 = query.getOrDefault("$top")
  valid_568353 = validateParameter(valid_568353, JInt, required = false, default = nil)
  if valid_568353 != nil:
    section.add "$top", valid_568353
  var valid_568354 = query.getOrDefault("$filter")
  valid_568354 = validateParameter(valid_568354, JString, required = false,
                                 default = nil)
  if valid_568354 != nil:
    section.add "$filter", valid_568354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568355: Call_LabAccountsListByResourceGroup_568345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List lab accounts in a resource group.
  ## 
  let valid = call_568355.validator(path, query, header, formData, body)
  let scheme = call_568355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568355.url(scheme.get, call_568355.host, call_568355.base,
                         call_568355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568355, url, valid)

proc call*(call_568356: Call_LabAccountsListByResourceGroup_568345;
          resourceGroupName: string; subscriptionId: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-10-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## labAccountsListByResourceGroup
  ## List lab accounts in a resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568357 = newJObject()
  var query_568358 = newJObject()
  add(query_568358, "$orderby", newJString(Orderby))
  add(path_568357, "resourceGroupName", newJString(resourceGroupName))
  add(query_568358, "$expand", newJString(Expand))
  add(query_568358, "api-version", newJString(apiVersion))
  add(path_568357, "subscriptionId", newJString(subscriptionId))
  add(query_568358, "$top", newJInt(Top))
  add(query_568358, "$filter", newJString(Filter))
  result = call_568356.call(path_568357, query_568358, nil, nil, nil)

var labAccountsListByResourceGroup* = Call_LabAccountsListByResourceGroup_568345(
    name: "labAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts",
    validator: validate_LabAccountsListByResourceGroup_568346, base: "",
    url: url_LabAccountsListByResourceGroup_568347, schemes: {Scheme.Https})
type
  Call_LabAccountsCreateOrUpdate_568371 = ref object of OpenApiRestCall_567666
proc url_LabAccountsCreateOrUpdate_568373(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabAccountsCreateOrUpdate_568372(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Lab Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568374 = path.getOrDefault("labAccountName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "labAccountName", valid_568374
  var valid_568375 = path.getOrDefault("resourceGroupName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "resourceGroupName", valid_568375
  var valid_568376 = path.getOrDefault("subscriptionId")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "subscriptionId", valid_568376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568377 = query.getOrDefault("api-version")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568377 != nil:
    section.add "api-version", valid_568377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labAccount: JObject (required)
  ##             : Represents a lab account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568379: Call_LabAccountsCreateOrUpdate_568371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Lab Account.
  ## 
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_LabAccountsCreateOrUpdate_568371;
          labAccountName: string; resourceGroupName: string; labAccount: JsonNode;
          subscriptionId: string; apiVersion: string = "2018-10-15"): Recallable =
  ## labAccountsCreateOrUpdate
  ## Create or replace an existing Lab Account.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   labAccount: JObject (required)
  ##             : Represents a lab account.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  var body_568383 = newJObject()
  add(path_568381, "labAccountName", newJString(labAccountName))
  add(path_568381, "resourceGroupName", newJString(resourceGroupName))
  if labAccount != nil:
    body_568383 = labAccount
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "subscriptionId", newJString(subscriptionId))
  result = call_568380.call(path_568381, query_568382, nil, nil, body_568383)

var labAccountsCreateOrUpdate* = Call_LabAccountsCreateOrUpdate_568371(
    name: "labAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsCreateOrUpdate_568372, base: "",
    url: url_LabAccountsCreateOrUpdate_568373, schemes: {Scheme.Https})
type
  Call_LabAccountsGet_568359 = ref object of OpenApiRestCall_567666
proc url_LabAccountsGet_568361(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabAccountsGet_568360(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get lab account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568362 = path.getOrDefault("labAccountName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "labAccountName", valid_568362
  var valid_568363 = path.getOrDefault("resourceGroupName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "resourceGroupName", valid_568363
  var valid_568364 = path.getOrDefault("subscriptionId")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "subscriptionId", valid_568364
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568365 = query.getOrDefault("$expand")
  valid_568365 = validateParameter(valid_568365, JString, required = false,
                                 default = nil)
  if valid_568365 != nil:
    section.add "$expand", valid_568365
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568367: Call_LabAccountsGet_568359; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab account
  ## 
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_LabAccountsGet_568359; labAccountName: string;
          resourceGroupName: string; subscriptionId: string; Expand: string = "";
          apiVersion: string = "2018-10-15"): Recallable =
  ## labAccountsGet
  ## Get lab account
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_568369 = newJObject()
  var query_568370 = newJObject()
  add(path_568369, "labAccountName", newJString(labAccountName))
  add(path_568369, "resourceGroupName", newJString(resourceGroupName))
  add(query_568370, "$expand", newJString(Expand))
  add(query_568370, "api-version", newJString(apiVersion))
  add(path_568369, "subscriptionId", newJString(subscriptionId))
  result = call_568368.call(path_568369, query_568370, nil, nil, nil)

var labAccountsGet* = Call_LabAccountsGet_568359(name: "labAccountsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsGet_568360, base: "", url: url_LabAccountsGet_568361,
    schemes: {Scheme.Https})
type
  Call_LabAccountsUpdate_568395 = ref object of OpenApiRestCall_567666
proc url_LabAccountsUpdate_568397(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabAccountsUpdate_568396(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Modify properties of lab accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568398 = path.getOrDefault("labAccountName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "labAccountName", valid_568398
  var valid_568399 = path.getOrDefault("resourceGroupName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "resourceGroupName", valid_568399
  var valid_568400 = path.getOrDefault("subscriptionId")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "subscriptionId", valid_568400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568401 = query.getOrDefault("api-version")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568401 != nil:
    section.add "api-version", valid_568401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labAccount: JObject (required)
  ##             : Represents a lab account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568403: Call_LabAccountsUpdate_568395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of lab accounts.
  ## 
  let valid = call_568403.validator(path, query, header, formData, body)
  let scheme = call_568403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568403.url(scheme.get, call_568403.host, call_568403.base,
                         call_568403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568403, url, valid)

proc call*(call_568404: Call_LabAccountsUpdate_568395; labAccountName: string;
          resourceGroupName: string; labAccount: JsonNode; subscriptionId: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labAccountsUpdate
  ## Modify properties of lab accounts.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   labAccount: JObject (required)
  ##             : Represents a lab account.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_568405 = newJObject()
  var query_568406 = newJObject()
  var body_568407 = newJObject()
  add(path_568405, "labAccountName", newJString(labAccountName))
  add(path_568405, "resourceGroupName", newJString(resourceGroupName))
  if labAccount != nil:
    body_568407 = labAccount
  add(query_568406, "api-version", newJString(apiVersion))
  add(path_568405, "subscriptionId", newJString(subscriptionId))
  result = call_568404.call(path_568405, query_568406, nil, nil, body_568407)

var labAccountsUpdate* = Call_LabAccountsUpdate_568395(name: "labAccountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsUpdate_568396, base: "",
    url: url_LabAccountsUpdate_568397, schemes: {Scheme.Https})
type
  Call_LabAccountsDelete_568384 = ref object of OpenApiRestCall_567666
proc url_LabAccountsDelete_568386(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabAccountsDelete_568385(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete lab account. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568387 = path.getOrDefault("labAccountName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "labAccountName", valid_568387
  var valid_568388 = path.getOrDefault("resourceGroupName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "resourceGroupName", valid_568388
  var valid_568389 = path.getOrDefault("subscriptionId")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "subscriptionId", valid_568389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568390 = query.getOrDefault("api-version")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568390 != nil:
    section.add "api-version", valid_568390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568391: Call_LabAccountsDelete_568384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab account. This operation can take a while to complete
  ## 
  let valid = call_568391.validator(path, query, header, formData, body)
  let scheme = call_568391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568391.url(scheme.get, call_568391.host, call_568391.base,
                         call_568391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568391, url, valid)

proc call*(call_568392: Call_LabAccountsDelete_568384; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labAccountsDelete
  ## Delete lab account. This operation can take a while to complete
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_568393 = newJObject()
  var query_568394 = newJObject()
  add(path_568393, "labAccountName", newJString(labAccountName))
  add(path_568393, "resourceGroupName", newJString(resourceGroupName))
  add(query_568394, "api-version", newJString(apiVersion))
  add(path_568393, "subscriptionId", newJString(subscriptionId))
  result = call_568392.call(path_568393, query_568394, nil, nil, nil)

var labAccountsDelete* = Call_LabAccountsDelete_568384(name: "labAccountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsDelete_568385, base: "",
    url: url_LabAccountsDelete_568386, schemes: {Scheme.Https})
type
  Call_LabAccountsCreateLab_568408 = ref object of OpenApiRestCall_567666
proc url_LabAccountsCreateLab_568410(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/createLab")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabAccountsCreateLab_568409(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a lab in a lab account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568411 = path.getOrDefault("labAccountName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "labAccountName", valid_568411
  var valid_568412 = path.getOrDefault("resourceGroupName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "resourceGroupName", valid_568412
  var valid_568413 = path.getOrDefault("subscriptionId")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "subscriptionId", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createLabProperties: JObject (required)
  ##                      : Properties for creating a managed lab and a default environment setting
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568416: Call_LabAccountsCreateLab_568408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a lab in a lab account.
  ## 
  let valid = call_568416.validator(path, query, header, formData, body)
  let scheme = call_568416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568416.url(scheme.get, call_568416.host, call_568416.base,
                         call_568416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568416, url, valid)

proc call*(call_568417: Call_LabAccountsCreateLab_568408; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          createLabProperties: JsonNode; apiVersion: string = "2018-10-15"): Recallable =
  ## labAccountsCreateLab
  ## Create a lab in a lab account.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   createLabProperties: JObject (required)
  ##                      : Properties for creating a managed lab and a default environment setting
  var path_568418 = newJObject()
  var query_568419 = newJObject()
  var body_568420 = newJObject()
  add(path_568418, "labAccountName", newJString(labAccountName))
  add(path_568418, "resourceGroupName", newJString(resourceGroupName))
  add(query_568419, "api-version", newJString(apiVersion))
  add(path_568418, "subscriptionId", newJString(subscriptionId))
  if createLabProperties != nil:
    body_568420 = createLabProperties
  result = call_568417.call(path_568418, query_568419, nil, nil, body_568420)

var labAccountsCreateLab* = Call_LabAccountsCreateLab_568408(
    name: "labAccountsCreateLab", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/createLab",
    validator: validate_LabAccountsCreateLab_568409, base: "",
    url: url_LabAccountsCreateLab_568410, schemes: {Scheme.Https})
type
  Call_GalleryImagesList_568421 = ref object of OpenApiRestCall_567666
proc url_GalleryImagesList_568423(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/galleryimages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImagesList_568422(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List gallery images in a given lab account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568424 = path.getOrDefault("labAccountName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "labAccountName", valid_568424
  var valid_568425 = path.getOrDefault("resourceGroupName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "resourceGroupName", valid_568425
  var valid_568426 = path.getOrDefault("subscriptionId")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "subscriptionId", valid_568426
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=author)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568427 = query.getOrDefault("$orderby")
  valid_568427 = validateParameter(valid_568427, JString, required = false,
                                 default = nil)
  if valid_568427 != nil:
    section.add "$orderby", valid_568427
  var valid_568428 = query.getOrDefault("$expand")
  valid_568428 = validateParameter(valid_568428, JString, required = false,
                                 default = nil)
  if valid_568428 != nil:
    section.add "$expand", valid_568428
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568429 = query.getOrDefault("api-version")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568429 != nil:
    section.add "api-version", valid_568429
  var valid_568430 = query.getOrDefault("$top")
  valid_568430 = validateParameter(valid_568430, JInt, required = false, default = nil)
  if valid_568430 != nil:
    section.add "$top", valid_568430
  var valid_568431 = query.getOrDefault("$filter")
  valid_568431 = validateParameter(valid_568431, JString, required = false,
                                 default = nil)
  if valid_568431 != nil:
    section.add "$filter", valid_568431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568432: Call_GalleryImagesList_568421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images in a given lab account.
  ## 
  let valid = call_568432.validator(path, query, header, formData, body)
  let scheme = call_568432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568432.url(scheme.get, call_568432.host, call_568432.base,
                         call_568432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568432, url, valid)

proc call*(call_568433: Call_GalleryImagesList_568421; labAccountName: string;
          resourceGroupName: string; subscriptionId: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-10-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## galleryImagesList
  ## List gallery images in a given lab account.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=author)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568434 = newJObject()
  var query_568435 = newJObject()
  add(path_568434, "labAccountName", newJString(labAccountName))
  add(path_568434, "resourceGroupName", newJString(resourceGroupName))
  add(query_568435, "$orderby", newJString(Orderby))
  add(query_568435, "$expand", newJString(Expand))
  add(query_568435, "api-version", newJString(apiVersion))
  add(path_568434, "subscriptionId", newJString(subscriptionId))
  add(query_568435, "$top", newJInt(Top))
  add(query_568435, "$filter", newJString(Filter))
  result = call_568433.call(path_568434, query_568435, nil, nil, nil)

var galleryImagesList* = Call_GalleryImagesList_568421(name: "galleryImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages",
    validator: validate_GalleryImagesList_568422, base: "",
    url: url_GalleryImagesList_568423, schemes: {Scheme.Https})
type
  Call_GalleryImagesCreateOrUpdate_568449 = ref object of OpenApiRestCall_567666
proc url_GalleryImagesCreateOrUpdate_568451(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "galleryImageName" in path,
        "`galleryImageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/galleryimages/"),
               (kind: VariableSegment, value: "galleryImageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImagesCreateOrUpdate_568450(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Gallery Image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568452 = path.getOrDefault("labAccountName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "labAccountName", valid_568452
  var valid_568453 = path.getOrDefault("resourceGroupName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "resourceGroupName", valid_568453
  var valid_568454 = path.getOrDefault("subscriptionId")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "subscriptionId", valid_568454
  var valid_568455 = path.getOrDefault("galleryImageName")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "galleryImageName", valid_568455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568456 = query.getOrDefault("api-version")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568456 != nil:
    section.add "api-version", valid_568456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   galleryImage: JObject (required)
  ##               : Represents an image from the Azure Marketplace
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568458: Call_GalleryImagesCreateOrUpdate_568449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Gallery Image.
  ## 
  let valid = call_568458.validator(path, query, header, formData, body)
  let scheme = call_568458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568458.url(scheme.get, call_568458.host, call_568458.base,
                         call_568458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568458, url, valid)

proc call*(call_568459: Call_GalleryImagesCreateOrUpdate_568449;
          labAccountName: string; resourceGroupName: string; subscriptionId: string;
          galleryImageName: string; galleryImage: JsonNode;
          apiVersion: string = "2018-10-15"): Recallable =
  ## galleryImagesCreateOrUpdate
  ## Create or replace an existing Gallery Image.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image.
  ##   galleryImage: JObject (required)
  ##               : Represents an image from the Azure Marketplace
  var path_568460 = newJObject()
  var query_568461 = newJObject()
  var body_568462 = newJObject()
  add(path_568460, "labAccountName", newJString(labAccountName))
  add(path_568460, "resourceGroupName", newJString(resourceGroupName))
  add(query_568461, "api-version", newJString(apiVersion))
  add(path_568460, "subscriptionId", newJString(subscriptionId))
  add(path_568460, "galleryImageName", newJString(galleryImageName))
  if galleryImage != nil:
    body_568462 = galleryImage
  result = call_568459.call(path_568460, query_568461, nil, nil, body_568462)

var galleryImagesCreateOrUpdate* = Call_GalleryImagesCreateOrUpdate_568449(
    name: "galleryImagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesCreateOrUpdate_568450, base: "",
    url: url_GalleryImagesCreateOrUpdate_568451, schemes: {Scheme.Https})
type
  Call_GalleryImagesGet_568436 = ref object of OpenApiRestCall_567666
proc url_GalleryImagesGet_568438(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "galleryImageName" in path,
        "`galleryImageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/galleryimages/"),
               (kind: VariableSegment, value: "galleryImageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImagesGet_568437(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get gallery image
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568439 = path.getOrDefault("labAccountName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "labAccountName", valid_568439
  var valid_568440 = path.getOrDefault("resourceGroupName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "resourceGroupName", valid_568440
  var valid_568441 = path.getOrDefault("subscriptionId")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "subscriptionId", valid_568441
  var valid_568442 = path.getOrDefault("galleryImageName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "galleryImageName", valid_568442
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=author)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568443 = query.getOrDefault("$expand")
  valid_568443 = validateParameter(valid_568443, JString, required = false,
                                 default = nil)
  if valid_568443 != nil:
    section.add "$expand", valid_568443
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568444 = query.getOrDefault("api-version")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568444 != nil:
    section.add "api-version", valid_568444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568445: Call_GalleryImagesGet_568436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get gallery image
  ## 
  let valid = call_568445.validator(path, query, header, formData, body)
  let scheme = call_568445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568445.url(scheme.get, call_568445.host, call_568445.base,
                         call_568445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568445, url, valid)

proc call*(call_568446: Call_GalleryImagesGet_568436; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          galleryImageName: string; Expand: string = "";
          apiVersion: string = "2018-10-15"): Recallable =
  ## galleryImagesGet
  ## Get gallery image
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=author)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image.
  var path_568447 = newJObject()
  var query_568448 = newJObject()
  add(path_568447, "labAccountName", newJString(labAccountName))
  add(path_568447, "resourceGroupName", newJString(resourceGroupName))
  add(query_568448, "$expand", newJString(Expand))
  add(query_568448, "api-version", newJString(apiVersion))
  add(path_568447, "subscriptionId", newJString(subscriptionId))
  add(path_568447, "galleryImageName", newJString(galleryImageName))
  result = call_568446.call(path_568447, query_568448, nil, nil, nil)

var galleryImagesGet* = Call_GalleryImagesGet_568436(name: "galleryImagesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesGet_568437, base: "",
    url: url_GalleryImagesGet_568438, schemes: {Scheme.Https})
type
  Call_GalleryImagesUpdate_568475 = ref object of OpenApiRestCall_567666
proc url_GalleryImagesUpdate_568477(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "galleryImageName" in path,
        "`galleryImageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/galleryimages/"),
               (kind: VariableSegment, value: "galleryImageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImagesUpdate_568476(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Modify properties of gallery images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568478 = path.getOrDefault("labAccountName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "labAccountName", valid_568478
  var valid_568479 = path.getOrDefault("resourceGroupName")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "resourceGroupName", valid_568479
  var valid_568480 = path.getOrDefault("subscriptionId")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "subscriptionId", valid_568480
  var valid_568481 = path.getOrDefault("galleryImageName")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "galleryImageName", valid_568481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568482 = query.getOrDefault("api-version")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568482 != nil:
    section.add "api-version", valid_568482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   galleryImage: JObject (required)
  ##               : Represents an image from the Azure Marketplace
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568484: Call_GalleryImagesUpdate_568475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of gallery images.
  ## 
  let valid = call_568484.validator(path, query, header, formData, body)
  let scheme = call_568484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568484.url(scheme.get, call_568484.host, call_568484.base,
                         call_568484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568484, url, valid)

proc call*(call_568485: Call_GalleryImagesUpdate_568475; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          galleryImageName: string; galleryImage: JsonNode;
          apiVersion: string = "2018-10-15"): Recallable =
  ## galleryImagesUpdate
  ## Modify properties of gallery images.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image.
  ##   galleryImage: JObject (required)
  ##               : Represents an image from the Azure Marketplace
  var path_568486 = newJObject()
  var query_568487 = newJObject()
  var body_568488 = newJObject()
  add(path_568486, "labAccountName", newJString(labAccountName))
  add(path_568486, "resourceGroupName", newJString(resourceGroupName))
  add(query_568487, "api-version", newJString(apiVersion))
  add(path_568486, "subscriptionId", newJString(subscriptionId))
  add(path_568486, "galleryImageName", newJString(galleryImageName))
  if galleryImage != nil:
    body_568488 = galleryImage
  result = call_568485.call(path_568486, query_568487, nil, nil, body_568488)

var galleryImagesUpdate* = Call_GalleryImagesUpdate_568475(
    name: "galleryImagesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesUpdate_568476, base: "",
    url: url_GalleryImagesUpdate_568477, schemes: {Scheme.Https})
type
  Call_GalleryImagesDelete_568463 = ref object of OpenApiRestCall_567666
proc url_GalleryImagesDelete_568465(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "galleryImageName" in path,
        "`galleryImageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/galleryimages/"),
               (kind: VariableSegment, value: "galleryImageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImagesDelete_568464(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete gallery image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568466 = path.getOrDefault("labAccountName")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "labAccountName", valid_568466
  var valid_568467 = path.getOrDefault("resourceGroupName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "resourceGroupName", valid_568467
  var valid_568468 = path.getOrDefault("subscriptionId")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "subscriptionId", valid_568468
  var valid_568469 = path.getOrDefault("galleryImageName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "galleryImageName", valid_568469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568470 = query.getOrDefault("api-version")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568470 != nil:
    section.add "api-version", valid_568470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568471: Call_GalleryImagesDelete_568463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete gallery image.
  ## 
  let valid = call_568471.validator(path, query, header, formData, body)
  let scheme = call_568471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568471.url(scheme.get, call_568471.host, call_568471.base,
                         call_568471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568471, url, valid)

proc call*(call_568472: Call_GalleryImagesDelete_568463; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          galleryImageName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## galleryImagesDelete
  ## Delete gallery image.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image.
  var path_568473 = newJObject()
  var query_568474 = newJObject()
  add(path_568473, "labAccountName", newJString(labAccountName))
  add(path_568473, "resourceGroupName", newJString(resourceGroupName))
  add(query_568474, "api-version", newJString(apiVersion))
  add(path_568473, "subscriptionId", newJString(subscriptionId))
  add(path_568473, "galleryImageName", newJString(galleryImageName))
  result = call_568472.call(path_568473, query_568474, nil, nil, nil)

var galleryImagesDelete* = Call_GalleryImagesDelete_568463(
    name: "galleryImagesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesDelete_568464, base: "",
    url: url_GalleryImagesDelete_568465, schemes: {Scheme.Https})
type
  Call_LabAccountsGetRegionalAvailability_568489 = ref object of OpenApiRestCall_567666
proc url_LabAccountsGetRegionalAvailability_568491(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/getRegionalAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabAccountsGetRegionalAvailability_568490(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get regional availability information for each size category configured under a lab account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568492 = path.getOrDefault("labAccountName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "labAccountName", valid_568492
  var valid_568493 = path.getOrDefault("resourceGroupName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "resourceGroupName", valid_568493
  var valid_568494 = path.getOrDefault("subscriptionId")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "subscriptionId", valid_568494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568495 = query.getOrDefault("api-version")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568495 != nil:
    section.add "api-version", valid_568495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568496: Call_LabAccountsGetRegionalAvailability_568489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get regional availability information for each size category configured under a lab account
  ## 
  let valid = call_568496.validator(path, query, header, formData, body)
  let scheme = call_568496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568496.url(scheme.get, call_568496.host, call_568496.base,
                         call_568496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568496, url, valid)

proc call*(call_568497: Call_LabAccountsGetRegionalAvailability_568489;
          labAccountName: string; resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labAccountsGetRegionalAvailability
  ## Get regional availability information for each size category configured under a lab account
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_568498 = newJObject()
  var query_568499 = newJObject()
  add(path_568498, "labAccountName", newJString(labAccountName))
  add(path_568498, "resourceGroupName", newJString(resourceGroupName))
  add(query_568499, "api-version", newJString(apiVersion))
  add(path_568498, "subscriptionId", newJString(subscriptionId))
  result = call_568497.call(path_568498, query_568499, nil, nil, nil)

var labAccountsGetRegionalAvailability* = Call_LabAccountsGetRegionalAvailability_568489(
    name: "labAccountsGetRegionalAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/getRegionalAvailability",
    validator: validate_LabAccountsGetRegionalAvailability_568490, base: "",
    url: url_LabAccountsGetRegionalAvailability_568491, schemes: {Scheme.Https})
type
  Call_LabsList_568500 = ref object of OpenApiRestCall_567666
proc url_LabsList_568502(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsList_568501(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs in a given lab account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568503 = path.getOrDefault("labAccountName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "labAccountName", valid_568503
  var valid_568504 = path.getOrDefault("resourceGroupName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "resourceGroupName", valid_568504
  var valid_568505 = path.getOrDefault("subscriptionId")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "subscriptionId", valid_568505
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=maxUsersInLab)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568506 = query.getOrDefault("$orderby")
  valid_568506 = validateParameter(valid_568506, JString, required = false,
                                 default = nil)
  if valid_568506 != nil:
    section.add "$orderby", valid_568506
  var valid_568507 = query.getOrDefault("$expand")
  valid_568507 = validateParameter(valid_568507, JString, required = false,
                                 default = nil)
  if valid_568507 != nil:
    section.add "$expand", valid_568507
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568508 = query.getOrDefault("api-version")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568508 != nil:
    section.add "api-version", valid_568508
  var valid_568509 = query.getOrDefault("$top")
  valid_568509 = validateParameter(valid_568509, JInt, required = false, default = nil)
  if valid_568509 != nil:
    section.add "$top", valid_568509
  var valid_568510 = query.getOrDefault("$filter")
  valid_568510 = validateParameter(valid_568510, JString, required = false,
                                 default = nil)
  if valid_568510 != nil:
    section.add "$filter", valid_568510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568511: Call_LabsList_568500; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a given lab account.
  ## 
  let valid = call_568511.validator(path, query, header, formData, body)
  let scheme = call_568511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568511.url(scheme.get, call_568511.host, call_568511.base,
                         call_568511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568511, url, valid)

proc call*(call_568512: Call_LabsList_568500; labAccountName: string;
          resourceGroupName: string; subscriptionId: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-10-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## labsList
  ## List labs in a given lab account.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=maxUsersInLab)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568513 = newJObject()
  var query_568514 = newJObject()
  add(path_568513, "labAccountName", newJString(labAccountName))
  add(path_568513, "resourceGroupName", newJString(resourceGroupName))
  add(query_568514, "$orderby", newJString(Orderby))
  add(query_568514, "$expand", newJString(Expand))
  add(query_568514, "api-version", newJString(apiVersion))
  add(path_568513, "subscriptionId", newJString(subscriptionId))
  add(query_568514, "$top", newJInt(Top))
  add(query_568514, "$filter", newJString(Filter))
  result = call_568512.call(path_568513, query_568514, nil, nil, nil)

var labsList* = Call_LabsList_568500(name: "labsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs",
                                  validator: validate_LabsList_568501, base: "",
                                  url: url_LabsList_568502,
                                  schemes: {Scheme.Https})
type
  Call_LabsCreateOrUpdate_568528 = ref object of OpenApiRestCall_567666
proc url_LabsCreateOrUpdate_568530(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsCreateOrUpdate_568529(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create or replace an existing Lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568531 = path.getOrDefault("labAccountName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "labAccountName", valid_568531
  var valid_568532 = path.getOrDefault("resourceGroupName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "resourceGroupName", valid_568532
  var valid_568533 = path.getOrDefault("subscriptionId")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "subscriptionId", valid_568533
  var valid_568534 = path.getOrDefault("labName")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "labName", valid_568534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568535 = query.getOrDefault("api-version")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568535 != nil:
    section.add "api-version", valid_568535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   lab: JObject (required)
  ##      : Represents a lab.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568537: Call_LabsCreateOrUpdate_568528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Lab.
  ## 
  let valid = call_568537.validator(path, query, header, formData, body)
  let scheme = call_568537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568537.url(scheme.get, call_568537.host, call_568537.base,
                         call_568537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568537, url, valid)

proc call*(call_568538: Call_LabsCreateOrUpdate_568528; labAccountName: string;
          resourceGroupName: string; subscriptionId: string; labName: string;
          lab: JsonNode; apiVersion: string = "2018-10-15"): Recallable =
  ## labsCreateOrUpdate
  ## Create or replace an existing Lab.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   lab: JObject (required)
  ##      : Represents a lab.
  var path_568539 = newJObject()
  var query_568540 = newJObject()
  var body_568541 = newJObject()
  add(path_568539, "labAccountName", newJString(labAccountName))
  add(path_568539, "resourceGroupName", newJString(resourceGroupName))
  add(query_568540, "api-version", newJString(apiVersion))
  add(path_568539, "subscriptionId", newJString(subscriptionId))
  add(path_568539, "labName", newJString(labName))
  if lab != nil:
    body_568541 = lab
  result = call_568538.call(path_568539, query_568540, nil, nil, body_568541)

var labsCreateOrUpdate* = Call_LabsCreateOrUpdate_568528(
    name: "labsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
    validator: validate_LabsCreateOrUpdate_568529, base: "",
    url: url_LabsCreateOrUpdate_568530, schemes: {Scheme.Https})
type
  Call_LabsGet_568515 = ref object of OpenApiRestCall_567666
proc url_LabsGet_568517(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsGet_568516(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Get lab
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568518 = path.getOrDefault("labAccountName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "labAccountName", valid_568518
  var valid_568519 = path.getOrDefault("resourceGroupName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "resourceGroupName", valid_568519
  var valid_568520 = path.getOrDefault("subscriptionId")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "subscriptionId", valid_568520
  var valid_568521 = path.getOrDefault("labName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "labName", valid_568521
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=maxUsersInLab)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568522 = query.getOrDefault("$expand")
  valid_568522 = validateParameter(valid_568522, JString, required = false,
                                 default = nil)
  if valid_568522 != nil:
    section.add "$expand", valid_568522
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568523 = query.getOrDefault("api-version")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568523 != nil:
    section.add "api-version", valid_568523
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568524: Call_LabsGet_568515; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab
  ## 
  let valid = call_568524.validator(path, query, header, formData, body)
  let scheme = call_568524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568524.url(scheme.get, call_568524.host, call_568524.base,
                         call_568524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568524, url, valid)

proc call*(call_568525: Call_LabsGet_568515; labAccountName: string;
          resourceGroupName: string; subscriptionId: string; labName: string;
          Expand: string = ""; apiVersion: string = "2018-10-15"): Recallable =
  ## labsGet
  ## Get lab
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=maxUsersInLab)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568526 = newJObject()
  var query_568527 = newJObject()
  add(path_568526, "labAccountName", newJString(labAccountName))
  add(path_568526, "resourceGroupName", newJString(resourceGroupName))
  add(query_568527, "$expand", newJString(Expand))
  add(query_568527, "api-version", newJString(apiVersion))
  add(path_568526, "subscriptionId", newJString(subscriptionId))
  add(path_568526, "labName", newJString(labName))
  result = call_568525.call(path_568526, query_568527, nil, nil, nil)

var labsGet* = Call_LabsGet_568515(name: "labsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
                                validator: validate_LabsGet_568516, base: "",
                                url: url_LabsGet_568517, schemes: {Scheme.Https})
type
  Call_LabsUpdate_568554 = ref object of OpenApiRestCall_567666
proc url_LabsUpdate_568556(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsUpdate_568555(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568557 = path.getOrDefault("labAccountName")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "labAccountName", valid_568557
  var valid_568558 = path.getOrDefault("resourceGroupName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "resourceGroupName", valid_568558
  var valid_568559 = path.getOrDefault("subscriptionId")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "subscriptionId", valid_568559
  var valid_568560 = path.getOrDefault("labName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "labName", valid_568560
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568561 = query.getOrDefault("api-version")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568561 != nil:
    section.add "api-version", valid_568561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   lab: JObject (required)
  ##      : Represents a lab.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568563: Call_LabsUpdate_568554; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of labs.
  ## 
  let valid = call_568563.validator(path, query, header, formData, body)
  let scheme = call_568563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568563.url(scheme.get, call_568563.host, call_568563.base,
                         call_568563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568563, url, valid)

proc call*(call_568564: Call_LabsUpdate_568554; labAccountName: string;
          resourceGroupName: string; subscriptionId: string; labName: string;
          lab: JsonNode; apiVersion: string = "2018-10-15"): Recallable =
  ## labsUpdate
  ## Modify properties of labs.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   lab: JObject (required)
  ##      : Represents a lab.
  var path_568565 = newJObject()
  var query_568566 = newJObject()
  var body_568567 = newJObject()
  add(path_568565, "labAccountName", newJString(labAccountName))
  add(path_568565, "resourceGroupName", newJString(resourceGroupName))
  add(query_568566, "api-version", newJString(apiVersion))
  add(path_568565, "subscriptionId", newJString(subscriptionId))
  add(path_568565, "labName", newJString(labName))
  if lab != nil:
    body_568567 = lab
  result = call_568564.call(path_568565, query_568566, nil, nil, body_568567)

var labsUpdate* = Call_LabsUpdate_568554(name: "labsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
                                      validator: validate_LabsUpdate_568555,
                                      base: "", url: url_LabsUpdate_568556,
                                      schemes: {Scheme.Https})
type
  Call_LabsDelete_568542 = ref object of OpenApiRestCall_567666
proc url_LabsDelete_568544(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsDelete_568543(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete lab. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568545 = path.getOrDefault("labAccountName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "labAccountName", valid_568545
  var valid_568546 = path.getOrDefault("resourceGroupName")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "resourceGroupName", valid_568546
  var valid_568547 = path.getOrDefault("subscriptionId")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "subscriptionId", valid_568547
  var valid_568548 = path.getOrDefault("labName")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "labName", valid_568548
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568549 = query.getOrDefault("api-version")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568549 != nil:
    section.add "api-version", valid_568549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568550: Call_LabsDelete_568542; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete
  ## 
  let valid = call_568550.validator(path, query, header, formData, body)
  let scheme = call_568550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568550.url(scheme.get, call_568550.host, call_568550.base,
                         call_568550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568550, url, valid)

proc call*(call_568551: Call_LabsDelete_568542; labAccountName: string;
          resourceGroupName: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labsDelete
  ## Delete lab. This operation can take a while to complete
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568552 = newJObject()
  var query_568553 = newJObject()
  add(path_568552, "labAccountName", newJString(labAccountName))
  add(path_568552, "resourceGroupName", newJString(resourceGroupName))
  add(query_568553, "api-version", newJString(apiVersion))
  add(path_568552, "subscriptionId", newJString(subscriptionId))
  add(path_568552, "labName", newJString(labName))
  result = call_568551.call(path_568552, query_568553, nil, nil, nil)

var labsDelete* = Call_LabsDelete_568542(name: "labsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
                                      validator: validate_LabsDelete_568543,
                                      base: "", url: url_LabsDelete_568544,
                                      schemes: {Scheme.Https})
type
  Call_LabsAddUsers_568568 = ref object of OpenApiRestCall_567666
proc url_LabsAddUsers_568570(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/addUsers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsAddUsers_568569(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Add users to a lab
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568571 = path.getOrDefault("labAccountName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "labAccountName", valid_568571
  var valid_568572 = path.getOrDefault("resourceGroupName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "resourceGroupName", valid_568572
  var valid_568573 = path.getOrDefault("subscriptionId")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "subscriptionId", valid_568573
  var valid_568574 = path.getOrDefault("labName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "labName", valid_568574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568575 = query.getOrDefault("api-version")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568575 != nil:
    section.add "api-version", valid_568575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   addUsersPayload: JObject (required)
  ##                  : Payload for Add Users operation on a Lab.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568577: Call_LabsAddUsers_568568; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add users to a lab
  ## 
  let valid = call_568577.validator(path, query, header, formData, body)
  let scheme = call_568577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568577.url(scheme.get, call_568577.host, call_568577.base,
                         call_568577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568577, url, valid)

proc call*(call_568578: Call_LabsAddUsers_568568; labAccountName: string;
          resourceGroupName: string; addUsersPayload: JsonNode;
          subscriptionId: string; labName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## labsAddUsers
  ## Add users to a lab
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   addUsersPayload: JObject (required)
  ##                  : Payload for Add Users operation on a Lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568579 = newJObject()
  var query_568580 = newJObject()
  var body_568581 = newJObject()
  add(path_568579, "labAccountName", newJString(labAccountName))
  add(path_568579, "resourceGroupName", newJString(resourceGroupName))
  add(query_568580, "api-version", newJString(apiVersion))
  if addUsersPayload != nil:
    body_568581 = addUsersPayload
  add(path_568579, "subscriptionId", newJString(subscriptionId))
  add(path_568579, "labName", newJString(labName))
  result = call_568578.call(path_568579, query_568580, nil, nil, body_568581)

var labsAddUsers* = Call_LabsAddUsers_568568(name: "labsAddUsers",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/addUsers",
    validator: validate_LabsAddUsers_568569, base: "", url: url_LabsAddUsers_568570,
    schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsList_568582 = ref object of OpenApiRestCall_567666
proc url_EnvironmentSettingsList_568584(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentSettingsList_568583(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List environment setting in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568585 = path.getOrDefault("labAccountName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "labAccountName", valid_568585
  var valid_568586 = path.getOrDefault("resourceGroupName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "resourceGroupName", valid_568586
  var valid_568587 = path.getOrDefault("subscriptionId")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "subscriptionId", valid_568587
  var valid_568588 = path.getOrDefault("labName")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "labName", valid_568588
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=publishingState)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568589 = query.getOrDefault("$orderby")
  valid_568589 = validateParameter(valid_568589, JString, required = false,
                                 default = nil)
  if valid_568589 != nil:
    section.add "$orderby", valid_568589
  var valid_568590 = query.getOrDefault("$expand")
  valid_568590 = validateParameter(valid_568590, JString, required = false,
                                 default = nil)
  if valid_568590 != nil:
    section.add "$expand", valid_568590
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568591 = query.getOrDefault("api-version")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568591 != nil:
    section.add "api-version", valid_568591
  var valid_568592 = query.getOrDefault("$top")
  valid_568592 = validateParameter(valid_568592, JInt, required = false, default = nil)
  if valid_568592 != nil:
    section.add "$top", valid_568592
  var valid_568593 = query.getOrDefault("$filter")
  valid_568593 = validateParameter(valid_568593, JString, required = false,
                                 default = nil)
  if valid_568593 != nil:
    section.add "$filter", valid_568593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568594: Call_EnvironmentSettingsList_568582; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environment setting in a given lab.
  ## 
  let valid = call_568594.validator(path, query, header, formData, body)
  let scheme = call_568594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568594.url(scheme.get, call_568594.host, call_568594.base,
                         call_568594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568594, url, valid)

proc call*(call_568595: Call_EnvironmentSettingsList_568582;
          labAccountName: string; resourceGroupName: string; subscriptionId: string;
          labName: string; Orderby: string = ""; Expand: string = "";
          apiVersion: string = "2018-10-15"; Top: int = 0; Filter: string = ""): Recallable =
  ## environmentSettingsList
  ## List environment setting in a given lab.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=publishingState)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568596 = newJObject()
  var query_568597 = newJObject()
  add(path_568596, "labAccountName", newJString(labAccountName))
  add(path_568596, "resourceGroupName", newJString(resourceGroupName))
  add(query_568597, "$orderby", newJString(Orderby))
  add(query_568597, "$expand", newJString(Expand))
  add(query_568597, "api-version", newJString(apiVersion))
  add(path_568596, "subscriptionId", newJString(subscriptionId))
  add(query_568597, "$top", newJInt(Top))
  add(path_568596, "labName", newJString(labName))
  add(query_568597, "$filter", newJString(Filter))
  result = call_568595.call(path_568596, query_568597, nil, nil, nil)

var environmentSettingsList* = Call_EnvironmentSettingsList_568582(
    name: "environmentSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings",
    validator: validate_EnvironmentSettingsList_568583, base: "",
    url: url_EnvironmentSettingsList_568584, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsCreateOrUpdate_568612 = ref object of OpenApiRestCall_567666
proc url_EnvironmentSettingsCreateOrUpdate_568614(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentSettingsCreateOrUpdate_568613(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Environment Setting. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568615 = path.getOrDefault("labAccountName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "labAccountName", valid_568615
  var valid_568616 = path.getOrDefault("resourceGroupName")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "resourceGroupName", valid_568616
  var valid_568617 = path.getOrDefault("subscriptionId")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "subscriptionId", valid_568617
  var valid_568618 = path.getOrDefault("environmentSettingName")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "environmentSettingName", valid_568618
  var valid_568619 = path.getOrDefault("labName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "labName", valid_568619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568620 = query.getOrDefault("api-version")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568620 != nil:
    section.add "api-version", valid_568620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   environmentSetting: JObject (required)
  ##                     : Represents settings of an environment, from which environment instances would be created
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568622: Call_EnvironmentSettingsCreateOrUpdate_568612;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing Environment Setting. This operation can take a while to complete
  ## 
  let valid = call_568622.validator(path, query, header, formData, body)
  let scheme = call_568622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568622.url(scheme.get, call_568622.host, call_568622.base,
                         call_568622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568622, url, valid)

proc call*(call_568623: Call_EnvironmentSettingsCreateOrUpdate_568612;
          labAccountName: string; resourceGroupName: string; subscriptionId: string;
          environmentSetting: JsonNode; environmentSettingName: string;
          labName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsCreateOrUpdate
  ## Create or replace an existing Environment Setting. This operation can take a while to complete
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSetting: JObject (required)
  ##                     : Represents settings of an environment, from which environment instances would be created
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568624 = newJObject()
  var query_568625 = newJObject()
  var body_568626 = newJObject()
  add(path_568624, "labAccountName", newJString(labAccountName))
  add(path_568624, "resourceGroupName", newJString(resourceGroupName))
  add(query_568625, "api-version", newJString(apiVersion))
  add(path_568624, "subscriptionId", newJString(subscriptionId))
  if environmentSetting != nil:
    body_568626 = environmentSetting
  add(path_568624, "environmentSettingName", newJString(environmentSettingName))
  add(path_568624, "labName", newJString(labName))
  result = call_568623.call(path_568624, query_568625, nil, nil, body_568626)

var environmentSettingsCreateOrUpdate* = Call_EnvironmentSettingsCreateOrUpdate_568612(
    name: "environmentSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsCreateOrUpdate_568613, base: "",
    url: url_EnvironmentSettingsCreateOrUpdate_568614, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsGet_568598 = ref object of OpenApiRestCall_567666
proc url_EnvironmentSettingsGet_568600(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentSettingsGet_568599(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get environment setting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568601 = path.getOrDefault("labAccountName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "labAccountName", valid_568601
  var valid_568602 = path.getOrDefault("resourceGroupName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "resourceGroupName", valid_568602
  var valid_568603 = path.getOrDefault("subscriptionId")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "subscriptionId", valid_568603
  var valid_568604 = path.getOrDefault("environmentSettingName")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "environmentSettingName", valid_568604
  var valid_568605 = path.getOrDefault("labName")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "labName", valid_568605
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=publishingState)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568606 = query.getOrDefault("$expand")
  valid_568606 = validateParameter(valid_568606, JString, required = false,
                                 default = nil)
  if valid_568606 != nil:
    section.add "$expand", valid_568606
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568607 = query.getOrDefault("api-version")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568607 != nil:
    section.add "api-version", valid_568607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568608: Call_EnvironmentSettingsGet_568598; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment setting
  ## 
  let valid = call_568608.validator(path, query, header, formData, body)
  let scheme = call_568608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568608.url(scheme.get, call_568608.host, call_568608.base,
                         call_568608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568608, url, valid)

proc call*(call_568609: Call_EnvironmentSettingsGet_568598; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsGet
  ## Get environment setting
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=publishingState)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568610 = newJObject()
  var query_568611 = newJObject()
  add(path_568610, "labAccountName", newJString(labAccountName))
  add(path_568610, "resourceGroupName", newJString(resourceGroupName))
  add(query_568611, "$expand", newJString(Expand))
  add(query_568611, "api-version", newJString(apiVersion))
  add(path_568610, "subscriptionId", newJString(subscriptionId))
  add(path_568610, "environmentSettingName", newJString(environmentSettingName))
  add(path_568610, "labName", newJString(labName))
  result = call_568609.call(path_568610, query_568611, nil, nil, nil)

var environmentSettingsGet* = Call_EnvironmentSettingsGet_568598(
    name: "environmentSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsGet_568599, base: "",
    url: url_EnvironmentSettingsGet_568600, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsUpdate_568640 = ref object of OpenApiRestCall_567666
proc url_EnvironmentSettingsUpdate_568642(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentSettingsUpdate_568641(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of environment setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568643 = path.getOrDefault("labAccountName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "labAccountName", valid_568643
  var valid_568644 = path.getOrDefault("resourceGroupName")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "resourceGroupName", valid_568644
  var valid_568645 = path.getOrDefault("subscriptionId")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "subscriptionId", valid_568645
  var valid_568646 = path.getOrDefault("environmentSettingName")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "environmentSettingName", valid_568646
  var valid_568647 = path.getOrDefault("labName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "labName", valid_568647
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568648 = query.getOrDefault("api-version")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568648 != nil:
    section.add "api-version", valid_568648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   environmentSetting: JObject (required)
  ##                     : Represents settings of an environment, from which environment instances would be created
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568650: Call_EnvironmentSettingsUpdate_568640; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of environment setting.
  ## 
  let valid = call_568650.validator(path, query, header, formData, body)
  let scheme = call_568650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568650.url(scheme.get, call_568650.host, call_568650.base,
                         call_568650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568650, url, valid)

proc call*(call_568651: Call_EnvironmentSettingsUpdate_568640;
          labAccountName: string; resourceGroupName: string; subscriptionId: string;
          environmentSetting: JsonNode; environmentSettingName: string;
          labName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsUpdate
  ## Modify properties of environment setting.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSetting: JObject (required)
  ##                     : Represents settings of an environment, from which environment instances would be created
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568652 = newJObject()
  var query_568653 = newJObject()
  var body_568654 = newJObject()
  add(path_568652, "labAccountName", newJString(labAccountName))
  add(path_568652, "resourceGroupName", newJString(resourceGroupName))
  add(query_568653, "api-version", newJString(apiVersion))
  add(path_568652, "subscriptionId", newJString(subscriptionId))
  if environmentSetting != nil:
    body_568654 = environmentSetting
  add(path_568652, "environmentSettingName", newJString(environmentSettingName))
  add(path_568652, "labName", newJString(labName))
  result = call_568651.call(path_568652, query_568653, nil, nil, body_568654)

var environmentSettingsUpdate* = Call_EnvironmentSettingsUpdate_568640(
    name: "environmentSettingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsUpdate_568641, base: "",
    url: url_EnvironmentSettingsUpdate_568642, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsDelete_568627 = ref object of OpenApiRestCall_567666
proc url_EnvironmentSettingsDelete_568629(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentSettingsDelete_568628(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete environment setting. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568630 = path.getOrDefault("labAccountName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "labAccountName", valid_568630
  var valid_568631 = path.getOrDefault("resourceGroupName")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "resourceGroupName", valid_568631
  var valid_568632 = path.getOrDefault("subscriptionId")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "subscriptionId", valid_568632
  var valid_568633 = path.getOrDefault("environmentSettingName")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "environmentSettingName", valid_568633
  var valid_568634 = path.getOrDefault("labName")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "labName", valid_568634
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568635 = query.getOrDefault("api-version")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568635 != nil:
    section.add "api-version", valid_568635
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568636: Call_EnvironmentSettingsDelete_568627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment setting. This operation can take a while to complete
  ## 
  let valid = call_568636.validator(path, query, header, formData, body)
  let scheme = call_568636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568636.url(scheme.get, call_568636.host, call_568636.base,
                         call_568636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568636, url, valid)

proc call*(call_568637: Call_EnvironmentSettingsDelete_568627;
          labAccountName: string; resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; labName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsDelete
  ## Delete environment setting. This operation can take a while to complete
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568638 = newJObject()
  var query_568639 = newJObject()
  add(path_568638, "labAccountName", newJString(labAccountName))
  add(path_568638, "resourceGroupName", newJString(resourceGroupName))
  add(query_568639, "api-version", newJString(apiVersion))
  add(path_568638, "subscriptionId", newJString(subscriptionId))
  add(path_568638, "environmentSettingName", newJString(environmentSettingName))
  add(path_568638, "labName", newJString(labName))
  result = call_568637.call(path_568638, query_568639, nil, nil, nil)

var environmentSettingsDelete* = Call_EnvironmentSettingsDelete_568627(
    name: "environmentSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsDelete_568628, base: "",
    url: url_EnvironmentSettingsDelete_568629, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsClaimAny_568655 = ref object of OpenApiRestCall_567666
proc url_EnvironmentSettingsClaimAny_568657(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/claimAny")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentSettingsClaimAny_568656(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Claims a random environment for a user in an environment settings
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568658 = path.getOrDefault("labAccountName")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "labAccountName", valid_568658
  var valid_568659 = path.getOrDefault("resourceGroupName")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "resourceGroupName", valid_568659
  var valid_568660 = path.getOrDefault("subscriptionId")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "subscriptionId", valid_568660
  var valid_568661 = path.getOrDefault("environmentSettingName")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "environmentSettingName", valid_568661
  var valid_568662 = path.getOrDefault("labName")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "labName", valid_568662
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568663 = query.getOrDefault("api-version")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568663 != nil:
    section.add "api-version", valid_568663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568664: Call_EnvironmentSettingsClaimAny_568655; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims a random environment for a user in an environment settings
  ## 
  let valid = call_568664.validator(path, query, header, formData, body)
  let scheme = call_568664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568664.url(scheme.get, call_568664.host, call_568664.base,
                         call_568664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568664, url, valid)

proc call*(call_568665: Call_EnvironmentSettingsClaimAny_568655;
          labAccountName: string; resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; labName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsClaimAny
  ## Claims a random environment for a user in an environment settings
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568666 = newJObject()
  var query_568667 = newJObject()
  add(path_568666, "labAccountName", newJString(labAccountName))
  add(path_568666, "resourceGroupName", newJString(resourceGroupName))
  add(query_568667, "api-version", newJString(apiVersion))
  add(path_568666, "subscriptionId", newJString(subscriptionId))
  add(path_568666, "environmentSettingName", newJString(environmentSettingName))
  add(path_568666, "labName", newJString(labName))
  result = call_568665.call(path_568666, query_568667, nil, nil, nil)

var environmentSettingsClaimAny* = Call_EnvironmentSettingsClaimAny_568655(
    name: "environmentSettingsClaimAny", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/claimAny",
    validator: validate_EnvironmentSettingsClaimAny_568656, base: "",
    url: url_EnvironmentSettingsClaimAny_568657, schemes: {Scheme.Https})
type
  Call_EnvironmentsList_568668 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsList_568670(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/environments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsList_568669(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List environments in a given environment setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568671 = path.getOrDefault("labAccountName")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "labAccountName", valid_568671
  var valid_568672 = path.getOrDefault("resourceGroupName")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "resourceGroupName", valid_568672
  var valid_568673 = path.getOrDefault("subscriptionId")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "subscriptionId", valid_568673
  var valid_568674 = path.getOrDefault("environmentSettingName")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "environmentSettingName", valid_568674
  var valid_568675 = path.getOrDefault("labName")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "labName", valid_568675
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=networkInterface)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568676 = query.getOrDefault("$orderby")
  valid_568676 = validateParameter(valid_568676, JString, required = false,
                                 default = nil)
  if valid_568676 != nil:
    section.add "$orderby", valid_568676
  var valid_568677 = query.getOrDefault("$expand")
  valid_568677 = validateParameter(valid_568677, JString, required = false,
                                 default = nil)
  if valid_568677 != nil:
    section.add "$expand", valid_568677
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568678 = query.getOrDefault("api-version")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568678 != nil:
    section.add "api-version", valid_568678
  var valid_568679 = query.getOrDefault("$top")
  valid_568679 = validateParameter(valid_568679, JInt, required = false, default = nil)
  if valid_568679 != nil:
    section.add "$top", valid_568679
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

proc call*(call_568681: Call_EnvironmentsList_568668; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environments in a given environment setting.
  ## 
  let valid = call_568681.validator(path, query, header, formData, body)
  let scheme = call_568681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568681.url(scheme.get, call_568681.host, call_568681.base,
                         call_568681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568681, url, valid)

proc call*(call_568682: Call_EnvironmentsList_568668; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-10-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## environmentsList
  ## List environments in a given environment setting.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=networkInterface)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568683 = newJObject()
  var query_568684 = newJObject()
  add(path_568683, "labAccountName", newJString(labAccountName))
  add(path_568683, "resourceGroupName", newJString(resourceGroupName))
  add(query_568684, "$orderby", newJString(Orderby))
  add(query_568684, "$expand", newJString(Expand))
  add(query_568684, "api-version", newJString(apiVersion))
  add(path_568683, "subscriptionId", newJString(subscriptionId))
  add(query_568684, "$top", newJInt(Top))
  add(path_568683, "environmentSettingName", newJString(environmentSettingName))
  add(path_568683, "labName", newJString(labName))
  add(query_568684, "$filter", newJString(Filter))
  result = call_568682.call(path_568683, query_568684, nil, nil, nil)

var environmentsList* = Call_EnvironmentsList_568668(name: "environmentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments",
    validator: validate_EnvironmentsList_568669, base: "",
    url: url_EnvironmentsList_568670, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_568700 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsCreateOrUpdate_568702(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsCreateOrUpdate_568701(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568703 = path.getOrDefault("labAccountName")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "labAccountName", valid_568703
  var valid_568704 = path.getOrDefault("resourceGroupName")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "resourceGroupName", valid_568704
  var valid_568705 = path.getOrDefault("subscriptionId")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "subscriptionId", valid_568705
  var valid_568706 = path.getOrDefault("environmentSettingName")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "environmentSettingName", valid_568706
  var valid_568707 = path.getOrDefault("environmentName")
  valid_568707 = validateParameter(valid_568707, JString, required = true,
                                 default = nil)
  if valid_568707 != nil:
    section.add "environmentName", valid_568707
  var valid_568708 = path.getOrDefault("labName")
  valid_568708 = validateParameter(valid_568708, JString, required = true,
                                 default = nil)
  if valid_568708 != nil:
    section.add "labName", valid_568708
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568709 = query.getOrDefault("api-version")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568709 != nil:
    section.add "api-version", valid_568709
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   environment: JObject (required)
  ##              : Represents an environment instance
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568711: Call_EnvironmentsCreateOrUpdate_568700; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Environment.
  ## 
  let valid = call_568711.validator(path, query, header, formData, body)
  let scheme = call_568711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568711.url(scheme.get, call_568711.host, call_568711.base,
                         call_568711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568711, url, valid)

proc call*(call_568712: Call_EnvironmentsCreateOrUpdate_568700;
          labAccountName: string; resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; environmentName: string; labName: string;
          environment: JsonNode; apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsCreateOrUpdate
  ## Create or replace an existing Environment.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   environment: JObject (required)
  ##              : Represents an environment instance
  var path_568713 = newJObject()
  var query_568714 = newJObject()
  var body_568715 = newJObject()
  add(path_568713, "labAccountName", newJString(labAccountName))
  add(path_568713, "resourceGroupName", newJString(resourceGroupName))
  add(query_568714, "api-version", newJString(apiVersion))
  add(path_568713, "subscriptionId", newJString(subscriptionId))
  add(path_568713, "environmentSettingName", newJString(environmentSettingName))
  add(path_568713, "environmentName", newJString(environmentName))
  add(path_568713, "labName", newJString(labName))
  if environment != nil:
    body_568715 = environment
  result = call_568712.call(path_568713, query_568714, nil, nil, body_568715)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_568700(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsCreateOrUpdate_568701, base: "",
    url: url_EnvironmentsCreateOrUpdate_568702, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_568685 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsGet_568687(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsGet_568686(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get environment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568688 = path.getOrDefault("labAccountName")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "labAccountName", valid_568688
  var valid_568689 = path.getOrDefault("resourceGroupName")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "resourceGroupName", valid_568689
  var valid_568690 = path.getOrDefault("subscriptionId")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "subscriptionId", valid_568690
  var valid_568691 = path.getOrDefault("environmentSettingName")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "environmentSettingName", valid_568691
  var valid_568692 = path.getOrDefault("environmentName")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "environmentName", valid_568692
  var valid_568693 = path.getOrDefault("labName")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "labName", valid_568693
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=networkInterface)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568694 = query.getOrDefault("$expand")
  valid_568694 = validateParameter(valid_568694, JString, required = false,
                                 default = nil)
  if valid_568694 != nil:
    section.add "$expand", valid_568694
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568695 = query.getOrDefault("api-version")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568695 != nil:
    section.add "api-version", valid_568695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568696: Call_EnvironmentsGet_568685; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment
  ## 
  let valid = call_568696.validator(path, query, header, formData, body)
  let scheme = call_568696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568696.url(scheme.get, call_568696.host, call_568696.base,
                         call_568696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568696, url, valid)

proc call*(call_568697: Call_EnvironmentsGet_568685; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; environmentName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsGet
  ## Get environment
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=networkInterface)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568698 = newJObject()
  var query_568699 = newJObject()
  add(path_568698, "labAccountName", newJString(labAccountName))
  add(path_568698, "resourceGroupName", newJString(resourceGroupName))
  add(query_568699, "$expand", newJString(Expand))
  add(query_568699, "api-version", newJString(apiVersion))
  add(path_568698, "subscriptionId", newJString(subscriptionId))
  add(path_568698, "environmentSettingName", newJString(environmentSettingName))
  add(path_568698, "environmentName", newJString(environmentName))
  add(path_568698, "labName", newJString(labName))
  result = call_568697.call(path_568698, query_568699, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_568685(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsGet_568686, base: "", url: url_EnvironmentsGet_568687,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsUpdate_568730 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsUpdate_568732(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsUpdate_568731(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Modify properties of environments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568733 = path.getOrDefault("labAccountName")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "labAccountName", valid_568733
  var valid_568734 = path.getOrDefault("resourceGroupName")
  valid_568734 = validateParameter(valid_568734, JString, required = true,
                                 default = nil)
  if valid_568734 != nil:
    section.add "resourceGroupName", valid_568734
  var valid_568735 = path.getOrDefault("subscriptionId")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "subscriptionId", valid_568735
  var valid_568736 = path.getOrDefault("environmentSettingName")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "environmentSettingName", valid_568736
  var valid_568737 = path.getOrDefault("environmentName")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "environmentName", valid_568737
  var valid_568738 = path.getOrDefault("labName")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "labName", valid_568738
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568739 = query.getOrDefault("api-version")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568739 != nil:
    section.add "api-version", valid_568739
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   environment: JObject (required)
  ##              : Represents an environment instance
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568741: Call_EnvironmentsUpdate_568730; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of environments.
  ## 
  let valid = call_568741.validator(path, query, header, formData, body)
  let scheme = call_568741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568741.url(scheme.get, call_568741.host, call_568741.base,
                         call_568741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568741, url, valid)

proc call*(call_568742: Call_EnvironmentsUpdate_568730; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; environmentName: string; labName: string;
          environment: JsonNode; apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsUpdate
  ## Modify properties of environments.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   environment: JObject (required)
  ##              : Represents an environment instance
  var path_568743 = newJObject()
  var query_568744 = newJObject()
  var body_568745 = newJObject()
  add(path_568743, "labAccountName", newJString(labAccountName))
  add(path_568743, "resourceGroupName", newJString(resourceGroupName))
  add(query_568744, "api-version", newJString(apiVersion))
  add(path_568743, "subscriptionId", newJString(subscriptionId))
  add(path_568743, "environmentSettingName", newJString(environmentSettingName))
  add(path_568743, "environmentName", newJString(environmentName))
  add(path_568743, "labName", newJString(labName))
  if environment != nil:
    body_568745 = environment
  result = call_568742.call(path_568743, query_568744, nil, nil, body_568745)

var environmentsUpdate* = Call_EnvironmentsUpdate_568730(
    name: "environmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsUpdate_568731, base: "",
    url: url_EnvironmentsUpdate_568732, schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_568716 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsDelete_568718(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsDelete_568717(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete environment. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568719 = path.getOrDefault("labAccountName")
  valid_568719 = validateParameter(valid_568719, JString, required = true,
                                 default = nil)
  if valid_568719 != nil:
    section.add "labAccountName", valid_568719
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
  var valid_568722 = path.getOrDefault("environmentSettingName")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "environmentSettingName", valid_568722
  var valid_568723 = path.getOrDefault("environmentName")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "environmentName", valid_568723
  var valid_568724 = path.getOrDefault("labName")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "labName", valid_568724
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568725 = query.getOrDefault("api-version")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568725 != nil:
    section.add "api-version", valid_568725
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568726: Call_EnvironmentsDelete_568716; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment. This operation can take a while to complete
  ## 
  let valid = call_568726.validator(path, query, header, formData, body)
  let scheme = call_568726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568726.url(scheme.get, call_568726.host, call_568726.base,
                         call_568726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568726, url, valid)

proc call*(call_568727: Call_EnvironmentsDelete_568716; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; environmentName: string; labName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsDelete
  ## Delete environment. This operation can take a while to complete
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568728 = newJObject()
  var query_568729 = newJObject()
  add(path_568728, "labAccountName", newJString(labAccountName))
  add(path_568728, "resourceGroupName", newJString(resourceGroupName))
  add(query_568729, "api-version", newJString(apiVersion))
  add(path_568728, "subscriptionId", newJString(subscriptionId))
  add(path_568728, "environmentSettingName", newJString(environmentSettingName))
  add(path_568728, "environmentName", newJString(environmentName))
  add(path_568728, "labName", newJString(labName))
  result = call_568727.call(path_568728, query_568729, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_568716(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsDelete_568717, base: "",
    url: url_EnvironmentsDelete_568718, schemes: {Scheme.Https})
type
  Call_EnvironmentsClaim_568746 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsClaim_568748(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/claim")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsClaim_568747(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Claims the environment and assigns it to the user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568749 = path.getOrDefault("labAccountName")
  valid_568749 = validateParameter(valid_568749, JString, required = true,
                                 default = nil)
  if valid_568749 != nil:
    section.add "labAccountName", valid_568749
  var valid_568750 = path.getOrDefault("resourceGroupName")
  valid_568750 = validateParameter(valid_568750, JString, required = true,
                                 default = nil)
  if valid_568750 != nil:
    section.add "resourceGroupName", valid_568750
  var valid_568751 = path.getOrDefault("subscriptionId")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "subscriptionId", valid_568751
  var valid_568752 = path.getOrDefault("environmentSettingName")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "environmentSettingName", valid_568752
  var valid_568753 = path.getOrDefault("environmentName")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "environmentName", valid_568753
  var valid_568754 = path.getOrDefault("labName")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "labName", valid_568754
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568755 = query.getOrDefault("api-version")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568755 != nil:
    section.add "api-version", valid_568755
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568756: Call_EnvironmentsClaim_568746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the environment and assigns it to the user
  ## 
  let valid = call_568756.validator(path, query, header, formData, body)
  let scheme = call_568756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568756.url(scheme.get, call_568756.host, call_568756.base,
                         call_568756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568756, url, valid)

proc call*(call_568757: Call_EnvironmentsClaim_568746; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; environmentName: string; labName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsClaim
  ## Claims the environment and assigns it to the user
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568758 = newJObject()
  var query_568759 = newJObject()
  add(path_568758, "labAccountName", newJString(labAccountName))
  add(path_568758, "resourceGroupName", newJString(resourceGroupName))
  add(query_568759, "api-version", newJString(apiVersion))
  add(path_568758, "subscriptionId", newJString(subscriptionId))
  add(path_568758, "environmentSettingName", newJString(environmentSettingName))
  add(path_568758, "environmentName", newJString(environmentName))
  add(path_568758, "labName", newJString(labName))
  result = call_568757.call(path_568758, query_568759, nil, nil, nil)

var environmentsClaim* = Call_EnvironmentsClaim_568746(name: "environmentsClaim",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/claim",
    validator: validate_EnvironmentsClaim_568747, base: "",
    url: url_EnvironmentsClaim_568748, schemes: {Scheme.Https})
type
  Call_EnvironmentsResetPassword_568760 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsResetPassword_568762(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/resetPassword")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsResetPassword_568761(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets the user password on an environment This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568763 = path.getOrDefault("labAccountName")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "labAccountName", valid_568763
  var valid_568764 = path.getOrDefault("resourceGroupName")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "resourceGroupName", valid_568764
  var valid_568765 = path.getOrDefault("subscriptionId")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "subscriptionId", valid_568765
  var valid_568766 = path.getOrDefault("environmentSettingName")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "environmentSettingName", valid_568766
  var valid_568767 = path.getOrDefault("environmentName")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "environmentName", valid_568767
  var valid_568768 = path.getOrDefault("labName")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "labName", valid_568768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568769 = query.getOrDefault("api-version")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568769 != nil:
    section.add "api-version", valid_568769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resetPasswordPayload: JObject (required)
  ##                       : Represents the payload for resetting passwords.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568771: Call_EnvironmentsResetPassword_568760; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the user password on an environment This operation can take a while to complete
  ## 
  let valid = call_568771.validator(path, query, header, formData, body)
  let scheme = call_568771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568771.url(scheme.get, call_568771.host, call_568771.base,
                         call_568771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568771, url, valid)

proc call*(call_568772: Call_EnvironmentsResetPassword_568760;
          labAccountName: string; resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; environmentName: string; labName: string;
          resetPasswordPayload: JsonNode; apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsResetPassword
  ## Resets the user password on an environment This operation can take a while to complete
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   resetPasswordPayload: JObject (required)
  ##                       : Represents the payload for resetting passwords.
  var path_568773 = newJObject()
  var query_568774 = newJObject()
  var body_568775 = newJObject()
  add(path_568773, "labAccountName", newJString(labAccountName))
  add(path_568773, "resourceGroupName", newJString(resourceGroupName))
  add(query_568774, "api-version", newJString(apiVersion))
  add(path_568773, "subscriptionId", newJString(subscriptionId))
  add(path_568773, "environmentSettingName", newJString(environmentSettingName))
  add(path_568773, "environmentName", newJString(environmentName))
  add(path_568773, "labName", newJString(labName))
  if resetPasswordPayload != nil:
    body_568775 = resetPasswordPayload
  result = call_568772.call(path_568773, query_568774, nil, nil, body_568775)

var environmentsResetPassword* = Call_EnvironmentsResetPassword_568760(
    name: "environmentsResetPassword", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/resetPassword",
    validator: validate_EnvironmentsResetPassword_568761, base: "",
    url: url_EnvironmentsResetPassword_568762, schemes: {Scheme.Https})
type
  Call_EnvironmentsStart_568776 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsStart_568778(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsStart_568777(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568779 = path.getOrDefault("labAccountName")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "labAccountName", valid_568779
  var valid_568780 = path.getOrDefault("resourceGroupName")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "resourceGroupName", valid_568780
  var valid_568781 = path.getOrDefault("subscriptionId")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "subscriptionId", valid_568781
  var valid_568782 = path.getOrDefault("environmentSettingName")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "environmentSettingName", valid_568782
  var valid_568783 = path.getOrDefault("environmentName")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = nil)
  if valid_568783 != nil:
    section.add "environmentName", valid_568783
  var valid_568784 = path.getOrDefault("labName")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = nil)
  if valid_568784 != nil:
    section.add "labName", valid_568784
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568785 = query.getOrDefault("api-version")
  valid_568785 = validateParameter(valid_568785, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568785 != nil:
    section.add "api-version", valid_568785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568786: Call_EnvironmentsStart_568776; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ## 
  let valid = call_568786.validator(path, query, header, formData, body)
  let scheme = call_568786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568786.url(scheme.get, call_568786.host, call_568786.base,
                         call_568786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568786, url, valid)

proc call*(call_568787: Call_EnvironmentsStart_568776; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; environmentName: string; labName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsStart
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568788 = newJObject()
  var query_568789 = newJObject()
  add(path_568788, "labAccountName", newJString(labAccountName))
  add(path_568788, "resourceGroupName", newJString(resourceGroupName))
  add(query_568789, "api-version", newJString(apiVersion))
  add(path_568788, "subscriptionId", newJString(subscriptionId))
  add(path_568788, "environmentSettingName", newJString(environmentSettingName))
  add(path_568788, "environmentName", newJString(environmentName))
  add(path_568788, "labName", newJString(labName))
  result = call_568787.call(path_568788, query_568789, nil, nil, nil)

var environmentsStart* = Call_EnvironmentsStart_568776(name: "environmentsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/start",
    validator: validate_EnvironmentsStart_568777, base: "",
    url: url_EnvironmentsStart_568778, schemes: {Scheme.Https})
type
  Call_EnvironmentsStop_568790 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsStop_568792(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsStop_568791(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568793 = path.getOrDefault("labAccountName")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "labAccountName", valid_568793
  var valid_568794 = path.getOrDefault("resourceGroupName")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "resourceGroupName", valid_568794
  var valid_568795 = path.getOrDefault("subscriptionId")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "subscriptionId", valid_568795
  var valid_568796 = path.getOrDefault("environmentSettingName")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = nil)
  if valid_568796 != nil:
    section.add "environmentSettingName", valid_568796
  var valid_568797 = path.getOrDefault("environmentName")
  valid_568797 = validateParameter(valid_568797, JString, required = true,
                                 default = nil)
  if valid_568797 != nil:
    section.add "environmentName", valid_568797
  var valid_568798 = path.getOrDefault("labName")
  valid_568798 = validateParameter(valid_568798, JString, required = true,
                                 default = nil)
  if valid_568798 != nil:
    section.add "labName", valid_568798
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568799 = query.getOrDefault("api-version")
  valid_568799 = validateParameter(valid_568799, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568799 != nil:
    section.add "api-version", valid_568799
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568800: Call_EnvironmentsStop_568790; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ## 
  let valid = call_568800.validator(path, query, header, formData, body)
  let scheme = call_568800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568800.url(scheme.get, call_568800.host, call_568800.base,
                         call_568800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568800, url, valid)

proc call*(call_568801: Call_EnvironmentsStop_568790; labAccountName: string;
          resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; environmentName: string; labName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsStop
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568802 = newJObject()
  var query_568803 = newJObject()
  add(path_568802, "labAccountName", newJString(labAccountName))
  add(path_568802, "resourceGroupName", newJString(resourceGroupName))
  add(query_568803, "api-version", newJString(apiVersion))
  add(path_568802, "subscriptionId", newJString(subscriptionId))
  add(path_568802, "environmentSettingName", newJString(environmentSettingName))
  add(path_568802, "environmentName", newJString(environmentName))
  add(path_568802, "labName", newJString(labName))
  result = call_568801.call(path_568802, query_568803, nil, nil, nil)

var environmentsStop* = Call_EnvironmentsStop_568790(name: "environmentsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/stop",
    validator: validate_EnvironmentsStop_568791, base: "",
    url: url_EnvironmentsStop_568792, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsPublish_568804 = ref object of OpenApiRestCall_567666
proc url_EnvironmentSettingsPublish_568806(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/publish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentSettingsPublish_568805(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions/deprovisions required resources for an environment setting based on current state of the lab/environment setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568807 = path.getOrDefault("labAccountName")
  valid_568807 = validateParameter(valid_568807, JString, required = true,
                                 default = nil)
  if valid_568807 != nil:
    section.add "labAccountName", valid_568807
  var valid_568808 = path.getOrDefault("resourceGroupName")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "resourceGroupName", valid_568808
  var valid_568809 = path.getOrDefault("subscriptionId")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "subscriptionId", valid_568809
  var valid_568810 = path.getOrDefault("environmentSettingName")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "environmentSettingName", valid_568810
  var valid_568811 = path.getOrDefault("labName")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "labName", valid_568811
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568812 = query.getOrDefault("api-version")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568812 != nil:
    section.add "api-version", valid_568812
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   publishPayload: JObject (required)
  ##                 : Payload for Publish operation on EnvironmentSetting.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568814: Call_EnvironmentSettingsPublish_568804; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions/deprovisions required resources for an environment setting based on current state of the lab/environment setting.
  ## 
  let valid = call_568814.validator(path, query, header, formData, body)
  let scheme = call_568814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568814.url(scheme.get, call_568814.host, call_568814.base,
                         call_568814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568814, url, valid)

proc call*(call_568815: Call_EnvironmentSettingsPublish_568804;
          labAccountName: string; resourceGroupName: string;
          publishPayload: JsonNode; subscriptionId: string;
          environmentSettingName: string; labName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsPublish
  ## Provisions/deprovisions required resources for an environment setting based on current state of the lab/environment setting.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   publishPayload: JObject (required)
  ##                 : Payload for Publish operation on EnvironmentSetting.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568816 = newJObject()
  var query_568817 = newJObject()
  var body_568818 = newJObject()
  add(path_568816, "labAccountName", newJString(labAccountName))
  add(path_568816, "resourceGroupName", newJString(resourceGroupName))
  add(query_568817, "api-version", newJString(apiVersion))
  if publishPayload != nil:
    body_568818 = publishPayload
  add(path_568816, "subscriptionId", newJString(subscriptionId))
  add(path_568816, "environmentSettingName", newJString(environmentSettingName))
  add(path_568816, "labName", newJString(labName))
  result = call_568815.call(path_568816, query_568817, nil, nil, body_568818)

var environmentSettingsPublish* = Call_EnvironmentSettingsPublish_568804(
    name: "environmentSettingsPublish", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/publish",
    validator: validate_EnvironmentSettingsPublish_568805, base: "",
    url: url_EnvironmentSettingsPublish_568806, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsStart_568819 = ref object of OpenApiRestCall_567666
proc url_EnvironmentSettingsStart_568821(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentSettingsStart_568820(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568822 = path.getOrDefault("labAccountName")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "labAccountName", valid_568822
  var valid_568823 = path.getOrDefault("resourceGroupName")
  valid_568823 = validateParameter(valid_568823, JString, required = true,
                                 default = nil)
  if valid_568823 != nil:
    section.add "resourceGroupName", valid_568823
  var valid_568824 = path.getOrDefault("subscriptionId")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "subscriptionId", valid_568824
  var valid_568825 = path.getOrDefault("environmentSettingName")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "environmentSettingName", valid_568825
  var valid_568826 = path.getOrDefault("labName")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "labName", valid_568826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568827 = query.getOrDefault("api-version")
  valid_568827 = validateParameter(valid_568827, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568827 != nil:
    section.add "api-version", valid_568827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568828: Call_EnvironmentSettingsStart_568819; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ## 
  let valid = call_568828.validator(path, query, header, formData, body)
  let scheme = call_568828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568828.url(scheme.get, call_568828.host, call_568828.base,
                         call_568828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568828, url, valid)

proc call*(call_568829: Call_EnvironmentSettingsStart_568819;
          labAccountName: string; resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; labName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsStart
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568830 = newJObject()
  var query_568831 = newJObject()
  add(path_568830, "labAccountName", newJString(labAccountName))
  add(path_568830, "resourceGroupName", newJString(resourceGroupName))
  add(query_568831, "api-version", newJString(apiVersion))
  add(path_568830, "subscriptionId", newJString(subscriptionId))
  add(path_568830, "environmentSettingName", newJString(environmentSettingName))
  add(path_568830, "labName", newJString(labName))
  result = call_568829.call(path_568830, query_568831, nil, nil, nil)

var environmentSettingsStart* = Call_EnvironmentSettingsStart_568819(
    name: "environmentSettingsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/start",
    validator: validate_EnvironmentSettingsStart_568820, base: "",
    url: url_EnvironmentSettingsStart_568821, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsStop_568832 = ref object of OpenApiRestCall_567666
proc url_EnvironmentSettingsStop_568834(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "environmentSettingName" in path,
        "`environmentSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/environmentsettings/"),
               (kind: VariableSegment, value: "environmentSettingName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentSettingsStop_568833(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568835 = path.getOrDefault("labAccountName")
  valid_568835 = validateParameter(valid_568835, JString, required = true,
                                 default = nil)
  if valid_568835 != nil:
    section.add "labAccountName", valid_568835
  var valid_568836 = path.getOrDefault("resourceGroupName")
  valid_568836 = validateParameter(valid_568836, JString, required = true,
                                 default = nil)
  if valid_568836 != nil:
    section.add "resourceGroupName", valid_568836
  var valid_568837 = path.getOrDefault("subscriptionId")
  valid_568837 = validateParameter(valid_568837, JString, required = true,
                                 default = nil)
  if valid_568837 != nil:
    section.add "subscriptionId", valid_568837
  var valid_568838 = path.getOrDefault("environmentSettingName")
  valid_568838 = validateParameter(valid_568838, JString, required = true,
                                 default = nil)
  if valid_568838 != nil:
    section.add "environmentSettingName", valid_568838
  var valid_568839 = path.getOrDefault("labName")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "labName", valid_568839
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568840 = query.getOrDefault("api-version")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568840 != nil:
    section.add "api-version", valid_568840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568841: Call_EnvironmentSettingsStop_568832; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ## 
  let valid = call_568841.validator(path, query, header, formData, body)
  let scheme = call_568841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568841.url(scheme.get, call_568841.host, call_568841.base,
                         call_568841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568841, url, valid)

proc call*(call_568842: Call_EnvironmentSettingsStop_568832;
          labAccountName: string; resourceGroupName: string; subscriptionId: string;
          environmentSettingName: string; labName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsStop
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568843 = newJObject()
  var query_568844 = newJObject()
  add(path_568843, "labAccountName", newJString(labAccountName))
  add(path_568843, "resourceGroupName", newJString(resourceGroupName))
  add(query_568844, "api-version", newJString(apiVersion))
  add(path_568843, "subscriptionId", newJString(subscriptionId))
  add(path_568843, "environmentSettingName", newJString(environmentSettingName))
  add(path_568843, "labName", newJString(labName))
  result = call_568842.call(path_568843, query_568844, nil, nil, nil)

var environmentSettingsStop* = Call_EnvironmentSettingsStop_568832(
    name: "environmentSettingsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/stop",
    validator: validate_EnvironmentSettingsStop_568833, base: "",
    url: url_EnvironmentSettingsStop_568834, schemes: {Scheme.Https})
type
  Call_LabsRegister_568845 = ref object of OpenApiRestCall_567666
proc url_LabsRegister_568847(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/register")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsRegister_568846(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Register to managed lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568848 = path.getOrDefault("labAccountName")
  valid_568848 = validateParameter(valid_568848, JString, required = true,
                                 default = nil)
  if valid_568848 != nil:
    section.add "labAccountName", valid_568848
  var valid_568849 = path.getOrDefault("resourceGroupName")
  valid_568849 = validateParameter(valid_568849, JString, required = true,
                                 default = nil)
  if valid_568849 != nil:
    section.add "resourceGroupName", valid_568849
  var valid_568850 = path.getOrDefault("subscriptionId")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "subscriptionId", valid_568850
  var valid_568851 = path.getOrDefault("labName")
  valid_568851 = validateParameter(valid_568851, JString, required = true,
                                 default = nil)
  if valid_568851 != nil:
    section.add "labName", valid_568851
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568852 = query.getOrDefault("api-version")
  valid_568852 = validateParameter(valid_568852, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568852 != nil:
    section.add "api-version", valid_568852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568853: Call_LabsRegister_568845; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register to managed lab.
  ## 
  let valid = call_568853.validator(path, query, header, formData, body)
  let scheme = call_568853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568853.url(scheme.get, call_568853.host, call_568853.base,
                         call_568853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568853, url, valid)

proc call*(call_568854: Call_LabsRegister_568845; labAccountName: string;
          resourceGroupName: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labsRegister
  ## Register to managed lab.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568855 = newJObject()
  var query_568856 = newJObject()
  add(path_568855, "labAccountName", newJString(labAccountName))
  add(path_568855, "resourceGroupName", newJString(resourceGroupName))
  add(query_568856, "api-version", newJString(apiVersion))
  add(path_568855, "subscriptionId", newJString(subscriptionId))
  add(path_568855, "labName", newJString(labName))
  result = call_568854.call(path_568855, query_568856, nil, nil, nil)

var labsRegister* = Call_LabsRegister_568845(name: "labsRegister",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/register",
    validator: validate_LabsRegister_568846, base: "", url: url_LabsRegister_568847,
    schemes: {Scheme.Https})
type
  Call_UsersList_568857 = ref object of OpenApiRestCall_567666
proc url_UsersList_568859(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersList_568858(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List users in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568860 = path.getOrDefault("labAccountName")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "labAccountName", valid_568860
  var valid_568861 = path.getOrDefault("resourceGroupName")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "resourceGroupName", valid_568861
  var valid_568862 = path.getOrDefault("subscriptionId")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "subscriptionId", valid_568862
  var valid_568863 = path.getOrDefault("labName")
  valid_568863 = validateParameter(valid_568863, JString, required = true,
                                 default = nil)
  if valid_568863 != nil:
    section.add "labName", valid_568863
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=email)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568864 = query.getOrDefault("$orderby")
  valid_568864 = validateParameter(valid_568864, JString, required = false,
                                 default = nil)
  if valid_568864 != nil:
    section.add "$orderby", valid_568864
  var valid_568865 = query.getOrDefault("$expand")
  valid_568865 = validateParameter(valid_568865, JString, required = false,
                                 default = nil)
  if valid_568865 != nil:
    section.add "$expand", valid_568865
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568866 = query.getOrDefault("api-version")
  valid_568866 = validateParameter(valid_568866, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568866 != nil:
    section.add "api-version", valid_568866
  var valid_568867 = query.getOrDefault("$top")
  valid_568867 = validateParameter(valid_568867, JInt, required = false, default = nil)
  if valid_568867 != nil:
    section.add "$top", valid_568867
  var valid_568868 = query.getOrDefault("$filter")
  valid_568868 = validateParameter(valid_568868, JString, required = false,
                                 default = nil)
  if valid_568868 != nil:
    section.add "$filter", valid_568868
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568869: Call_UsersList_568857; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List users in a given lab.
  ## 
  let valid = call_568869.validator(path, query, header, formData, body)
  let scheme = call_568869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568869.url(scheme.get, call_568869.host, call_568869.base,
                         call_568869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568869, url, valid)

proc call*(call_568870: Call_UsersList_568857; labAccountName: string;
          resourceGroupName: string; subscriptionId: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-10-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## usersList
  ## List users in a given lab.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=email)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568871 = newJObject()
  var query_568872 = newJObject()
  add(path_568871, "labAccountName", newJString(labAccountName))
  add(path_568871, "resourceGroupName", newJString(resourceGroupName))
  add(query_568872, "$orderby", newJString(Orderby))
  add(query_568872, "$expand", newJString(Expand))
  add(query_568872, "api-version", newJString(apiVersion))
  add(path_568871, "subscriptionId", newJString(subscriptionId))
  add(query_568872, "$top", newJInt(Top))
  add(path_568871, "labName", newJString(labName))
  add(query_568872, "$filter", newJString(Filter))
  result = call_568870.call(path_568871, query_568872, nil, nil, nil)

var usersList* = Call_UsersList_568857(name: "usersList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users",
                                    validator: validate_UsersList_568858,
                                    base: "", url: url_UsersList_568859,
                                    schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_568887 = ref object of OpenApiRestCall_567666
proc url_UsersCreateOrUpdate_568889(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersCreateOrUpdate_568888(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing User.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568890 = path.getOrDefault("labAccountName")
  valid_568890 = validateParameter(valid_568890, JString, required = true,
                                 default = nil)
  if valid_568890 != nil:
    section.add "labAccountName", valid_568890
  var valid_568891 = path.getOrDefault("resourceGroupName")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = nil)
  if valid_568891 != nil:
    section.add "resourceGroupName", valid_568891
  var valid_568892 = path.getOrDefault("subscriptionId")
  valid_568892 = validateParameter(valid_568892, JString, required = true,
                                 default = nil)
  if valid_568892 != nil:
    section.add "subscriptionId", valid_568892
  var valid_568893 = path.getOrDefault("userName")
  valid_568893 = validateParameter(valid_568893, JString, required = true,
                                 default = nil)
  if valid_568893 != nil:
    section.add "userName", valid_568893
  var valid_568894 = path.getOrDefault("labName")
  valid_568894 = validateParameter(valid_568894, JString, required = true,
                                 default = nil)
  if valid_568894 != nil:
    section.add "labName", valid_568894
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568895 = query.getOrDefault("api-version")
  valid_568895 = validateParameter(valid_568895, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568895 != nil:
    section.add "api-version", valid_568895
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   user: JObject (required)
  ##       : The User registered to a lab
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568897: Call_UsersCreateOrUpdate_568887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing User.
  ## 
  let valid = call_568897.validator(path, query, header, formData, body)
  let scheme = call_568897.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568897.url(scheme.get, call_568897.host, call_568897.base,
                         call_568897.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568897, url, valid)

proc call*(call_568898: Call_UsersCreateOrUpdate_568887; labAccountName: string;
          resourceGroupName: string; user: JsonNode; subscriptionId: string;
          userName: string; labName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## usersCreateOrUpdate
  ## Create or replace an existing User.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   user: JObject (required)
  ##       : The User registered to a lab
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568899 = newJObject()
  var query_568900 = newJObject()
  var body_568901 = newJObject()
  add(path_568899, "labAccountName", newJString(labAccountName))
  add(path_568899, "resourceGroupName", newJString(resourceGroupName))
  add(query_568900, "api-version", newJString(apiVersion))
  if user != nil:
    body_568901 = user
  add(path_568899, "subscriptionId", newJString(subscriptionId))
  add(path_568899, "userName", newJString(userName))
  add(path_568899, "labName", newJString(labName))
  result = call_568898.call(path_568899, query_568900, nil, nil, body_568901)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_568887(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
    validator: validate_UsersCreateOrUpdate_568888, base: "",
    url: url_UsersCreateOrUpdate_568889, schemes: {Scheme.Https})
type
  Call_UsersGet_568873 = ref object of OpenApiRestCall_567666
proc url_UsersGet_568875(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersGet_568874(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568876 = path.getOrDefault("labAccountName")
  valid_568876 = validateParameter(valid_568876, JString, required = true,
                                 default = nil)
  if valid_568876 != nil:
    section.add "labAccountName", valid_568876
  var valid_568877 = path.getOrDefault("resourceGroupName")
  valid_568877 = validateParameter(valid_568877, JString, required = true,
                                 default = nil)
  if valid_568877 != nil:
    section.add "resourceGroupName", valid_568877
  var valid_568878 = path.getOrDefault("subscriptionId")
  valid_568878 = validateParameter(valid_568878, JString, required = true,
                                 default = nil)
  if valid_568878 != nil:
    section.add "subscriptionId", valid_568878
  var valid_568879 = path.getOrDefault("userName")
  valid_568879 = validateParameter(valid_568879, JString, required = true,
                                 default = nil)
  if valid_568879 != nil:
    section.add "userName", valid_568879
  var valid_568880 = path.getOrDefault("labName")
  valid_568880 = validateParameter(valid_568880, JString, required = true,
                                 default = nil)
  if valid_568880 != nil:
    section.add "labName", valid_568880
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=email)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568881 = query.getOrDefault("$expand")
  valid_568881 = validateParameter(valid_568881, JString, required = false,
                                 default = nil)
  if valid_568881 != nil:
    section.add "$expand", valid_568881
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568882 = query.getOrDefault("api-version")
  valid_568882 = validateParameter(valid_568882, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568882 != nil:
    section.add "api-version", valid_568882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568883: Call_UsersGet_568873; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get user
  ## 
  let valid = call_568883.validator(path, query, header, formData, body)
  let scheme = call_568883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568883.url(scheme.get, call_568883.host, call_568883.base,
                         call_568883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568883, url, valid)

proc call*(call_568884: Call_UsersGet_568873; labAccountName: string;
          resourceGroupName: string; subscriptionId: string; userName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2018-10-15"): Recallable =
  ## usersGet
  ## Get user
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=email)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568885 = newJObject()
  var query_568886 = newJObject()
  add(path_568885, "labAccountName", newJString(labAccountName))
  add(path_568885, "resourceGroupName", newJString(resourceGroupName))
  add(query_568886, "$expand", newJString(Expand))
  add(query_568886, "api-version", newJString(apiVersion))
  add(path_568885, "subscriptionId", newJString(subscriptionId))
  add(path_568885, "userName", newJString(userName))
  add(path_568885, "labName", newJString(labName))
  result = call_568884.call(path_568885, query_568886, nil, nil, nil)

var usersGet* = Call_UsersGet_568873(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
                                  validator: validate_UsersGet_568874, base: "",
                                  url: url_UsersGet_568875,
                                  schemes: {Scheme.Https})
type
  Call_UsersUpdate_568915 = ref object of OpenApiRestCall_567666
proc url_UsersUpdate_568917(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersUpdate_568916(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of users.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568918 = path.getOrDefault("labAccountName")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "labAccountName", valid_568918
  var valid_568919 = path.getOrDefault("resourceGroupName")
  valid_568919 = validateParameter(valid_568919, JString, required = true,
                                 default = nil)
  if valid_568919 != nil:
    section.add "resourceGroupName", valid_568919
  var valid_568920 = path.getOrDefault("subscriptionId")
  valid_568920 = validateParameter(valid_568920, JString, required = true,
                                 default = nil)
  if valid_568920 != nil:
    section.add "subscriptionId", valid_568920
  var valid_568921 = path.getOrDefault("userName")
  valid_568921 = validateParameter(valid_568921, JString, required = true,
                                 default = nil)
  if valid_568921 != nil:
    section.add "userName", valid_568921
  var valid_568922 = path.getOrDefault("labName")
  valid_568922 = validateParameter(valid_568922, JString, required = true,
                                 default = nil)
  if valid_568922 != nil:
    section.add "labName", valid_568922
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568923 = query.getOrDefault("api-version")
  valid_568923 = validateParameter(valid_568923, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568923 != nil:
    section.add "api-version", valid_568923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   user: JObject (required)
  ##       : The User registered to a lab
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568925: Call_UsersUpdate_568915; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of users.
  ## 
  let valid = call_568925.validator(path, query, header, formData, body)
  let scheme = call_568925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568925.url(scheme.get, call_568925.host, call_568925.base,
                         call_568925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568925, url, valid)

proc call*(call_568926: Call_UsersUpdate_568915; labAccountName: string;
          resourceGroupName: string; user: JsonNode; subscriptionId: string;
          userName: string; labName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## usersUpdate
  ## Modify properties of users.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   user: JObject (required)
  ##       : The User registered to a lab
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568927 = newJObject()
  var query_568928 = newJObject()
  var body_568929 = newJObject()
  add(path_568927, "labAccountName", newJString(labAccountName))
  add(path_568927, "resourceGroupName", newJString(resourceGroupName))
  add(query_568928, "api-version", newJString(apiVersion))
  if user != nil:
    body_568929 = user
  add(path_568927, "subscriptionId", newJString(subscriptionId))
  add(path_568927, "userName", newJString(userName))
  add(path_568927, "labName", newJString(labName))
  result = call_568926.call(path_568927, query_568928, nil, nil, body_568929)

var usersUpdate* = Call_UsersUpdate_568915(name: "usersUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
                                        validator: validate_UsersUpdate_568916,
                                        base: "", url: url_UsersUpdate_568917,
                                        schemes: {Scheme.Https})
type
  Call_UsersDelete_568902 = ref object of OpenApiRestCall_567666
proc url_UsersDelete_568904(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labAccountName" in path, "`labAccountName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.LabServices/labaccounts/"),
               (kind: VariableSegment, value: "labAccountName"),
               (kind: ConstantSegment, value: "/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersDelete_568903(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete user. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `labAccountName` field"
  var valid_568905 = path.getOrDefault("labAccountName")
  valid_568905 = validateParameter(valid_568905, JString, required = true,
                                 default = nil)
  if valid_568905 != nil:
    section.add "labAccountName", valid_568905
  var valid_568906 = path.getOrDefault("resourceGroupName")
  valid_568906 = validateParameter(valid_568906, JString, required = true,
                                 default = nil)
  if valid_568906 != nil:
    section.add "resourceGroupName", valid_568906
  var valid_568907 = path.getOrDefault("subscriptionId")
  valid_568907 = validateParameter(valid_568907, JString, required = true,
                                 default = nil)
  if valid_568907 != nil:
    section.add "subscriptionId", valid_568907
  var valid_568908 = path.getOrDefault("userName")
  valid_568908 = validateParameter(valid_568908, JString, required = true,
                                 default = nil)
  if valid_568908 != nil:
    section.add "userName", valid_568908
  var valid_568909 = path.getOrDefault("labName")
  valid_568909 = validateParameter(valid_568909, JString, required = true,
                                 default = nil)
  if valid_568909 != nil:
    section.add "labName", valid_568909
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568910 = query.getOrDefault("api-version")
  valid_568910 = validateParameter(valid_568910, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_568910 != nil:
    section.add "api-version", valid_568910
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568911: Call_UsersDelete_568902; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user. This operation can take a while to complete
  ## 
  let valid = call_568911.validator(path, query, header, formData, body)
  let scheme = call_568911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568911.url(scheme.get, call_568911.host, call_568911.base,
                         call_568911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568911, url, valid)

proc call*(call_568912: Call_UsersDelete_568902; labAccountName: string;
          resourceGroupName: string; subscriptionId: string; userName: string;
          labName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## usersDelete
  ## Delete user. This operation can take a while to complete
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568913 = newJObject()
  var query_568914 = newJObject()
  add(path_568913, "labAccountName", newJString(labAccountName))
  add(path_568913, "resourceGroupName", newJString(resourceGroupName))
  add(query_568914, "api-version", newJString(apiVersion))
  add(path_568913, "subscriptionId", newJString(subscriptionId))
  add(path_568913, "userName", newJString(userName))
  add(path_568913, "labName", newJString(labName))
  result = call_568912.call(path_568913, query_568914, nil, nil, nil)

var usersDelete* = Call_UsersDelete_568902(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
                                        validator: validate_UsersDelete_568903,
                                        base: "", url: url_UsersDelete_568904,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
