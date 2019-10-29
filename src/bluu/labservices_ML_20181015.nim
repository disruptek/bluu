
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
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
  macServiceName = "labservices-ML"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProviderOperationsList_563786 = ref object of OpenApiRestCall_563564
proc url_ProviderOperationsList_563788(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsList_563787(path: JsonNode; query: JsonNode;
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
  var valid_563962 = query.getOrDefault("api-version")
  valid_563962 = validateParameter(valid_563962, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_563962 != nil:
    section.add "api-version", valid_563962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563985: Call_ProviderOperationsList_563786; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Result of the request to list REST API operations
  ## 
  let valid = call_563985.validator(path, query, header, formData, body)
  let scheme = call_563985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563985.url(scheme.get, call_563985.host, call_563985.base,
                         call_563985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563985, url, valid)

proc call*(call_564056: Call_ProviderOperationsList_563786;
          apiVersion: string = "2018-10-15"): Recallable =
  ## providerOperationsList
  ## Result of the request to list REST API operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_564057 = newJObject()
  add(query_564057, "api-version", newJString(apiVersion))
  result = call_564056.call(nil, query_564057, nil, nil, nil)

var providerOperationsList* = Call_ProviderOperationsList_563786(
    name: "providerOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/operations",
    validator: validate_ProviderOperationsList_563787, base: "",
    url: url_ProviderOperationsList_563788, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetEnvironment_564097 = ref object of OpenApiRestCall_563564
proc url_GlobalUsersGetEnvironment_564099(protocol: Scheme; host: string;
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

proc validate_GlobalUsersGetEnvironment_564098(path: JsonNode; query: JsonNode;
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
  var valid_564115 = path.getOrDefault("userName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "userName", valid_564115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=environment)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564116 = query.getOrDefault("api-version")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564116 != nil:
    section.add "api-version", valid_564116
  var valid_564117 = query.getOrDefault("$expand")
  valid_564117 = validateParameter(valid_564117, JString, required = false,
                                 default = nil)
  if valid_564117 != nil:
    section.add "$expand", valid_564117
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

proc call*(call_564119: Call_GlobalUsersGetEnvironment_564097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the virtual machine details
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_GlobalUsersGetEnvironment_564097; userName: string;
          environmentOperationsPayload: JsonNode;
          apiVersion: string = "2018-10-15"; Expand: string = ""): Recallable =
  ## globalUsersGetEnvironment
  ## Gets the virtual machine details
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=environment)'
  ##   userName: string (required)
  ##           : The name of the user.
  ##   environmentOperationsPayload: JObject (required)
  ##                               : Represents payload for any Environment operations like get, start, stop, connect
  var path_564121 = newJObject()
  var query_564122 = newJObject()
  var body_564123 = newJObject()
  add(query_564122, "api-version", newJString(apiVersion))
  add(query_564122, "$expand", newJString(Expand))
  add(path_564121, "userName", newJString(userName))
  if environmentOperationsPayload != nil:
    body_564123 = environmentOperationsPayload
  result = call_564120.call(path_564121, query_564122, nil, nil, body_564123)

var globalUsersGetEnvironment* = Call_GlobalUsersGetEnvironment_564097(
    name: "globalUsersGetEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/getEnvironment",
    validator: validate_GlobalUsersGetEnvironment_564098, base: "",
    url: url_GlobalUsersGetEnvironment_564099, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetOperationBatchStatus_564124 = ref object of OpenApiRestCall_563564
proc url_GlobalUsersGetOperationBatchStatus_564126(protocol: Scheme; host: string;
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

proc validate_GlobalUsersGetOperationBatchStatus_564125(path: JsonNode;
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
  var valid_564127 = path.getOrDefault("userName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "userName", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564128 != nil:
    section.add "api-version", valid_564128
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

proc call*(call_564130: Call_GlobalUsersGetOperationBatchStatus_564124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get batch operation status
  ## 
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_GlobalUsersGetOperationBatchStatus_564124;
          operationBatchStatusPayload: JsonNode; userName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersGetOperationBatchStatus
  ## Get batch operation status
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationBatchStatusPayload: JObject (required)
  ##                              : Payload to get the status of an operation
  ##   userName: string (required)
  ##           : The name of the user.
  var path_564132 = newJObject()
  var query_564133 = newJObject()
  var body_564134 = newJObject()
  add(query_564133, "api-version", newJString(apiVersion))
  if operationBatchStatusPayload != nil:
    body_564134 = operationBatchStatusPayload
  add(path_564132, "userName", newJString(userName))
  result = call_564131.call(path_564132, query_564133, nil, nil, body_564134)

var globalUsersGetOperationBatchStatus* = Call_GlobalUsersGetOperationBatchStatus_564124(
    name: "globalUsersGetOperationBatchStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/getOperationBatchStatus",
    validator: validate_GlobalUsersGetOperationBatchStatus_564125, base: "",
    url: url_GlobalUsersGetOperationBatchStatus_564126, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetOperationStatus_564135 = ref object of OpenApiRestCall_563564
proc url_GlobalUsersGetOperationStatus_564137(protocol: Scheme; host: string;
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

proc validate_GlobalUsersGetOperationStatus_564136(path: JsonNode; query: JsonNode;
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
  var valid_564138 = path.getOrDefault("userName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "userName", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564139 != nil:
    section.add "api-version", valid_564139
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

proc call*(call_564141: Call_GlobalUsersGetOperationStatus_564135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of long running operation
  ## 
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_GlobalUsersGetOperationStatus_564135;
          userName: string; operationStatusPayload: JsonNode;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersGetOperationStatus
  ## Gets the status of long running operation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  ##   operationStatusPayload: JObject (required)
  ##                         : Payload to get the status of an operation
  var path_564143 = newJObject()
  var query_564144 = newJObject()
  var body_564145 = newJObject()
  add(query_564144, "api-version", newJString(apiVersion))
  add(path_564143, "userName", newJString(userName))
  if operationStatusPayload != nil:
    body_564145 = operationStatusPayload
  result = call_564142.call(path_564143, query_564144, nil, nil, body_564145)

var globalUsersGetOperationStatus* = Call_GlobalUsersGetOperationStatus_564135(
    name: "globalUsersGetOperationStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/getOperationStatus",
    validator: validate_GlobalUsersGetOperationStatus_564136, base: "",
    url: url_GlobalUsersGetOperationStatus_564137, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetPersonalPreferences_564146 = ref object of OpenApiRestCall_563564
proc url_GlobalUsersGetPersonalPreferences_564148(protocol: Scheme; host: string;
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

proc validate_GlobalUsersGetPersonalPreferences_564147(path: JsonNode;
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
  var valid_564149 = path.getOrDefault("userName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "userName", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564150 != nil:
    section.add "api-version", valid_564150
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

proc call*(call_564152: Call_GlobalUsersGetPersonalPreferences_564146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get personal preferences for a user
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_GlobalUsersGetPersonalPreferences_564146;
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
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  var body_564156 = newJObject()
  add(query_564155, "api-version", newJString(apiVersion))
  if personalPreferencesOperationsPayload != nil:
    body_564156 = personalPreferencesOperationsPayload
  add(path_564154, "userName", newJString(userName))
  result = call_564153.call(path_564154, query_564155, nil, nil, body_564156)

var globalUsersGetPersonalPreferences* = Call_GlobalUsersGetPersonalPreferences_564146(
    name: "globalUsersGetPersonalPreferences", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/getPersonalPreferences",
    validator: validate_GlobalUsersGetPersonalPreferences_564147, base: "",
    url: url_GlobalUsersGetPersonalPreferences_564148, schemes: {Scheme.Https})
type
  Call_GlobalUsersListEnvironments_564157 = ref object of OpenApiRestCall_563564
proc url_GlobalUsersListEnvironments_564159(protocol: Scheme; host: string;
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

proc validate_GlobalUsersListEnvironments_564158(path: JsonNode; query: JsonNode;
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
  var valid_564160 = path.getOrDefault("userName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "userName", valid_564160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564161 != nil:
    section.add "api-version", valid_564161
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

proc call*(call_564163: Call_GlobalUsersListEnvironments_564157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Environments for the user
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_GlobalUsersListEnvironments_564157;
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
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  var body_564167 = newJObject()
  add(query_564166, "api-version", newJString(apiVersion))
  if listEnvironmentsPayload != nil:
    body_564167 = listEnvironmentsPayload
  add(path_564165, "userName", newJString(userName))
  result = call_564164.call(path_564165, query_564166, nil, nil, body_564167)

var globalUsersListEnvironments* = Call_GlobalUsersListEnvironments_564157(
    name: "globalUsersListEnvironments", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/listEnvironments",
    validator: validate_GlobalUsersListEnvironments_564158, base: "",
    url: url_GlobalUsersListEnvironments_564159, schemes: {Scheme.Https})
type
  Call_GlobalUsersListLabs_564168 = ref object of OpenApiRestCall_563564
proc url_GlobalUsersListLabs_564170(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalUsersListLabs_564169(path: JsonNode; query: JsonNode;
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
  var valid_564171 = path.getOrDefault("userName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "userName", valid_564171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564172 = query.getOrDefault("api-version")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564172 != nil:
    section.add "api-version", valid_564172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564173: Call_GlobalUsersListLabs_564168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs for the user.
  ## 
  let valid = call_564173.validator(path, query, header, formData, body)
  let scheme = call_564173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564173.url(scheme.get, call_564173.host, call_564173.base,
                         call_564173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564173, url, valid)

proc call*(call_564174: Call_GlobalUsersListLabs_564168; userName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersListLabs
  ## List labs for the user.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_564175 = newJObject()
  var query_564176 = newJObject()
  add(query_564176, "api-version", newJString(apiVersion))
  add(path_564175, "userName", newJString(userName))
  result = call_564174.call(path_564175, query_564176, nil, nil, nil)

var globalUsersListLabs* = Call_GlobalUsersListLabs_564168(
    name: "globalUsersListLabs", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/listLabs",
    validator: validate_GlobalUsersListLabs_564169, base: "",
    url: url_GlobalUsersListLabs_564170, schemes: {Scheme.Https})
type
  Call_GlobalUsersRegister_564177 = ref object of OpenApiRestCall_563564
proc url_GlobalUsersRegister_564179(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalUsersRegister_564178(path: JsonNode; query: JsonNode;
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
  var valid_564180 = path.getOrDefault("userName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "userName", valid_564180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564181 = query.getOrDefault("api-version")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564181 != nil:
    section.add "api-version", valid_564181
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

proc call*(call_564183: Call_GlobalUsersRegister_564177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register a user to a managed lab
  ## 
  let valid = call_564183.validator(path, query, header, formData, body)
  let scheme = call_564183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564183.url(scheme.get, call_564183.host, call_564183.base,
                         call_564183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564183, url, valid)

proc call*(call_564184: Call_GlobalUsersRegister_564177; registerPayload: JsonNode;
          userName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersRegister
  ## Register a user to a managed lab
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   registerPayload: JObject (required)
  ##                  : Represents payload for Register action.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_564185 = newJObject()
  var query_564186 = newJObject()
  var body_564187 = newJObject()
  add(query_564186, "api-version", newJString(apiVersion))
  if registerPayload != nil:
    body_564187 = registerPayload
  add(path_564185, "userName", newJString(userName))
  result = call_564184.call(path_564185, query_564186, nil, nil, body_564187)

var globalUsersRegister* = Call_GlobalUsersRegister_564177(
    name: "globalUsersRegister", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/register",
    validator: validate_GlobalUsersRegister_564178, base: "",
    url: url_GlobalUsersRegister_564179, schemes: {Scheme.Https})
type
  Call_GlobalUsersResetPassword_564188 = ref object of OpenApiRestCall_563564
proc url_GlobalUsersResetPassword_564190(protocol: Scheme; host: string;
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

proc validate_GlobalUsersResetPassword_564189(path: JsonNode; query: JsonNode;
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
  var valid_564191 = path.getOrDefault("userName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "userName", valid_564191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564192 = query.getOrDefault("api-version")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564192 != nil:
    section.add "api-version", valid_564192
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

proc call*(call_564194: Call_GlobalUsersResetPassword_564188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the user password on an environment This operation can take a while to complete
  ## 
  let valid = call_564194.validator(path, query, header, formData, body)
  let scheme = call_564194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564194.url(scheme.get, call_564194.host, call_564194.base,
                         call_564194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564194, url, valid)

proc call*(call_564195: Call_GlobalUsersResetPassword_564188;
          resetPasswordPayload: JsonNode; userName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersResetPassword
  ## Resets the user password on an environment This operation can take a while to complete
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   resetPasswordPayload: JObject (required)
  ##                       : Represents the payload for resetting passwords.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_564196 = newJObject()
  var query_564197 = newJObject()
  var body_564198 = newJObject()
  add(query_564197, "api-version", newJString(apiVersion))
  if resetPasswordPayload != nil:
    body_564198 = resetPasswordPayload
  add(path_564196, "userName", newJString(userName))
  result = call_564195.call(path_564196, query_564197, nil, nil, body_564198)

var globalUsersResetPassword* = Call_GlobalUsersResetPassword_564188(
    name: "globalUsersResetPassword", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/resetPassword",
    validator: validate_GlobalUsersResetPassword_564189, base: "",
    url: url_GlobalUsersResetPassword_564190, schemes: {Scheme.Https})
type
  Call_GlobalUsersStartEnvironment_564199 = ref object of OpenApiRestCall_563564
proc url_GlobalUsersStartEnvironment_564201(protocol: Scheme; host: string;
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

proc validate_GlobalUsersStartEnvironment_564200(path: JsonNode; query: JsonNode;
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
  var valid_564202 = path.getOrDefault("userName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "userName", valid_564202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564203 = query.getOrDefault("api-version")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564203 != nil:
    section.add "api-version", valid_564203
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

proc call*(call_564205: Call_GlobalUsersStartEnvironment_564199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_GlobalUsersStartEnvironment_564199; userName: string;
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
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  var body_564209 = newJObject()
  add(query_564208, "api-version", newJString(apiVersion))
  add(path_564207, "userName", newJString(userName))
  if environmentOperationsPayload != nil:
    body_564209 = environmentOperationsPayload
  result = call_564206.call(path_564207, query_564208, nil, nil, body_564209)

var globalUsersStartEnvironment* = Call_GlobalUsersStartEnvironment_564199(
    name: "globalUsersStartEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/startEnvironment",
    validator: validate_GlobalUsersStartEnvironment_564200, base: "",
    url: url_GlobalUsersStartEnvironment_564201, schemes: {Scheme.Https})
type
  Call_GlobalUsersStopEnvironment_564210 = ref object of OpenApiRestCall_563564
proc url_GlobalUsersStopEnvironment_564212(protocol: Scheme; host: string;
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

proc validate_GlobalUsersStopEnvironment_564211(path: JsonNode; query: JsonNode;
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
  var valid_564213 = path.getOrDefault("userName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "userName", valid_564213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564214 != nil:
    section.add "api-version", valid_564214
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

proc call*(call_564216: Call_GlobalUsersStopEnvironment_564210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ## 
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_GlobalUsersStopEnvironment_564210; userName: string;
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
  var path_564218 = newJObject()
  var query_564219 = newJObject()
  var body_564220 = newJObject()
  add(query_564219, "api-version", newJString(apiVersion))
  add(path_564218, "userName", newJString(userName))
  if environmentOperationsPayload != nil:
    body_564220 = environmentOperationsPayload
  result = call_564217.call(path_564218, query_564219, nil, nil, body_564220)

var globalUsersStopEnvironment* = Call_GlobalUsersStopEnvironment_564210(
    name: "globalUsersStopEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/stopEnvironment",
    validator: validate_GlobalUsersStopEnvironment_564211, base: "",
    url: url_GlobalUsersStopEnvironment_564212, schemes: {Scheme.Https})
type
  Call_LabAccountsListBySubscription_564221 = ref object of OpenApiRestCall_563564
proc url_LabAccountsListBySubscription_564223(protocol: Scheme; host: string;
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

proc validate_LabAccountsListBySubscription_564222(path: JsonNode; query: JsonNode;
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
  var valid_564224 = path.getOrDefault("subscriptionId")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "subscriptionId", valid_564224
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564225 = query.getOrDefault("$top")
  valid_564225 = validateParameter(valid_564225, JInt, required = false, default = nil)
  if valid_564225 != nil:
    section.add "$top", valid_564225
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  var valid_564227 = query.getOrDefault("$expand")
  valid_564227 = validateParameter(valid_564227, JString, required = false,
                                 default = nil)
  if valid_564227 != nil:
    section.add "$expand", valid_564227
  var valid_564228 = query.getOrDefault("$orderby")
  valid_564228 = validateParameter(valid_564228, JString, required = false,
                                 default = nil)
  if valid_564228 != nil:
    section.add "$orderby", valid_564228
  var valid_564229 = query.getOrDefault("$filter")
  valid_564229 = validateParameter(valid_564229, JString, required = false,
                                 default = nil)
  if valid_564229 != nil:
    section.add "$filter", valid_564229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564230: Call_LabAccountsListBySubscription_564221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List lab accounts in a subscription.
  ## 
  let valid = call_564230.validator(path, query, header, formData, body)
  let scheme = call_564230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564230.url(scheme.get, call_564230.host, call_564230.base,
                         call_564230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564230, url, valid)

proc call*(call_564231: Call_LabAccountsListBySubscription_564221;
          subscriptionId: string; Top: int = 0; apiVersion: string = "2018-10-15";
          Expand: string = ""; Orderby: string = ""; Filter: string = ""): Recallable =
  ## labAccountsListBySubscription
  ## List lab accounts in a subscription.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564232 = newJObject()
  var query_564233 = newJObject()
  add(query_564233, "$top", newJInt(Top))
  add(query_564233, "api-version", newJString(apiVersion))
  add(query_564233, "$expand", newJString(Expand))
  add(path_564232, "subscriptionId", newJString(subscriptionId))
  add(query_564233, "$orderby", newJString(Orderby))
  add(query_564233, "$filter", newJString(Filter))
  result = call_564231.call(path_564232, query_564233, nil, nil, nil)

var labAccountsListBySubscription* = Call_LabAccountsListBySubscription_564221(
    name: "labAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.LabServices/labaccounts",
    validator: validate_LabAccountsListBySubscription_564222, base: "",
    url: url_LabAccountsListBySubscription_564223, schemes: {Scheme.Https})
type
  Call_OperationsGet_564234 = ref object of OpenApiRestCall_563564
proc url_OperationsGet_564236(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsGet_564235(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get operation
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The name of the location.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   operationName: JString (required)
  ##                : The name of the operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564237 = path.getOrDefault("locationName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "locationName", valid_564237
  var valid_564238 = path.getOrDefault("subscriptionId")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "subscriptionId", valid_564238
  var valid_564239 = path.getOrDefault("operationName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "operationName", valid_564239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564240 = query.getOrDefault("api-version")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564240 != nil:
    section.add "api-version", valid_564240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564241: Call_OperationsGet_564234; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get operation
  ## 
  let valid = call_564241.validator(path, query, header, formData, body)
  let scheme = call_564241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564241.url(scheme.get, call_564241.host, call_564241.base,
                         call_564241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564241, url, valid)

proc call*(call_564242: Call_OperationsGet_564234; locationName: string;
          subscriptionId: string; operationName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## operationsGet
  ## Get operation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   locationName: string (required)
  ##               : The name of the location.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   operationName: string (required)
  ##                : The name of the operation.
  var path_564243 = newJObject()
  var query_564244 = newJObject()
  add(query_564244, "api-version", newJString(apiVersion))
  add(path_564243, "locationName", newJString(locationName))
  add(path_564243, "subscriptionId", newJString(subscriptionId))
  add(path_564243, "operationName", newJString(operationName))
  result = call_564242.call(path_564243, query_564244, nil, nil, nil)

var operationsGet* = Call_OperationsGet_564234(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.LabServices/locations/{locationName}/operations/{operationName}",
    validator: validate_OperationsGet_564235, base: "", url: url_OperationsGet_564236,
    schemes: {Scheme.Https})
type
  Call_LabAccountsListByResourceGroup_564245 = ref object of OpenApiRestCall_563564
proc url_LabAccountsListByResourceGroup_564247(protocol: Scheme; host: string;
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

proc validate_LabAccountsListByResourceGroup_564246(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List lab accounts in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564248 = path.getOrDefault("subscriptionId")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "subscriptionId", valid_564248
  var valid_564249 = path.getOrDefault("resourceGroupName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "resourceGroupName", valid_564249
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564250 = query.getOrDefault("$top")
  valid_564250 = validateParameter(valid_564250, JInt, required = false, default = nil)
  if valid_564250 != nil:
    section.add "$top", valid_564250
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564251 = query.getOrDefault("api-version")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564251 != nil:
    section.add "api-version", valid_564251
  var valid_564252 = query.getOrDefault("$expand")
  valid_564252 = validateParameter(valid_564252, JString, required = false,
                                 default = nil)
  if valid_564252 != nil:
    section.add "$expand", valid_564252
  var valid_564253 = query.getOrDefault("$orderby")
  valid_564253 = validateParameter(valid_564253, JString, required = false,
                                 default = nil)
  if valid_564253 != nil:
    section.add "$orderby", valid_564253
  var valid_564254 = query.getOrDefault("$filter")
  valid_564254 = validateParameter(valid_564254, JString, required = false,
                                 default = nil)
  if valid_564254 != nil:
    section.add "$filter", valid_564254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564255: Call_LabAccountsListByResourceGroup_564245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List lab accounts in a resource group.
  ## 
  let valid = call_564255.validator(path, query, header, formData, body)
  let scheme = call_564255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564255.url(scheme.get, call_564255.host, call_564255.base,
                         call_564255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564255, url, valid)

proc call*(call_564256: Call_LabAccountsListByResourceGroup_564245;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-10-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## labAccountsListByResourceGroup
  ## List lab accounts in a resource group.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564257 = newJObject()
  var query_564258 = newJObject()
  add(query_564258, "$top", newJInt(Top))
  add(query_564258, "api-version", newJString(apiVersion))
  add(query_564258, "$expand", newJString(Expand))
  add(path_564257, "subscriptionId", newJString(subscriptionId))
  add(query_564258, "$orderby", newJString(Orderby))
  add(path_564257, "resourceGroupName", newJString(resourceGroupName))
  add(query_564258, "$filter", newJString(Filter))
  result = call_564256.call(path_564257, query_564258, nil, nil, nil)

var labAccountsListByResourceGroup* = Call_LabAccountsListByResourceGroup_564245(
    name: "labAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts",
    validator: validate_LabAccountsListByResourceGroup_564246, base: "",
    url: url_LabAccountsListByResourceGroup_564247, schemes: {Scheme.Https})
type
  Call_LabAccountsCreateOrUpdate_564271 = ref object of OpenApiRestCall_563564
proc url_LabAccountsCreateOrUpdate_564273(protocol: Scheme; host: string;
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

proc validate_LabAccountsCreateOrUpdate_564272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Lab Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564274 = path.getOrDefault("subscriptionId")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "subscriptionId", valid_564274
  var valid_564275 = path.getOrDefault("labAccountName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "labAccountName", valid_564275
  var valid_564276 = path.getOrDefault("resourceGroupName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "resourceGroupName", valid_564276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564277 = query.getOrDefault("api-version")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564277 != nil:
    section.add "api-version", valid_564277
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

proc call*(call_564279: Call_LabAccountsCreateOrUpdate_564271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Lab Account.
  ## 
  let valid = call_564279.validator(path, query, header, formData, body)
  let scheme = call_564279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564279.url(scheme.get, call_564279.host, call_564279.base,
                         call_564279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564279, url, valid)

proc call*(call_564280: Call_LabAccountsCreateOrUpdate_564271;
          labAccount: JsonNode; subscriptionId: string; labAccountName: string;
          resourceGroupName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## labAccountsCreateOrUpdate
  ## Create or replace an existing Lab Account.
  ##   labAccount: JObject (required)
  ##             : Represents a lab account.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564281 = newJObject()
  var query_564282 = newJObject()
  var body_564283 = newJObject()
  if labAccount != nil:
    body_564283 = labAccount
  add(query_564282, "api-version", newJString(apiVersion))
  add(path_564281, "subscriptionId", newJString(subscriptionId))
  add(path_564281, "labAccountName", newJString(labAccountName))
  add(path_564281, "resourceGroupName", newJString(resourceGroupName))
  result = call_564280.call(path_564281, query_564282, nil, nil, body_564283)

var labAccountsCreateOrUpdate* = Call_LabAccountsCreateOrUpdate_564271(
    name: "labAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsCreateOrUpdate_564272, base: "",
    url: url_LabAccountsCreateOrUpdate_564273, schemes: {Scheme.Https})
type
  Call_LabAccountsGet_564259 = ref object of OpenApiRestCall_563564
proc url_LabAccountsGet_564261(protocol: Scheme; host: string; base: string;
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

proc validate_LabAccountsGet_564260(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get lab account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564262 = path.getOrDefault("subscriptionId")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "subscriptionId", valid_564262
  var valid_564263 = path.getOrDefault("labAccountName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "labAccountName", valid_564263
  var valid_564264 = path.getOrDefault("resourceGroupName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "resourceGroupName", valid_564264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564265 = query.getOrDefault("api-version")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564265 != nil:
    section.add "api-version", valid_564265
  var valid_564266 = query.getOrDefault("$expand")
  valid_564266 = validateParameter(valid_564266, JString, required = false,
                                 default = nil)
  if valid_564266 != nil:
    section.add "$expand", valid_564266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564267: Call_LabAccountsGet_564259; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab account
  ## 
  let valid = call_564267.validator(path, query, header, formData, body)
  let scheme = call_564267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564267.url(scheme.get, call_564267.host, call_564267.base,
                         call_564267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564267, url, valid)

proc call*(call_564268: Call_LabAccountsGet_564259; subscriptionId: string;
          labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"; Expand: string = ""): Recallable =
  ## labAccountsGet
  ## Get lab account
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564269 = newJObject()
  var query_564270 = newJObject()
  add(query_564270, "api-version", newJString(apiVersion))
  add(query_564270, "$expand", newJString(Expand))
  add(path_564269, "subscriptionId", newJString(subscriptionId))
  add(path_564269, "labAccountName", newJString(labAccountName))
  add(path_564269, "resourceGroupName", newJString(resourceGroupName))
  result = call_564268.call(path_564269, query_564270, nil, nil, nil)

var labAccountsGet* = Call_LabAccountsGet_564259(name: "labAccountsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsGet_564260, base: "", url: url_LabAccountsGet_564261,
    schemes: {Scheme.Https})
type
  Call_LabAccountsUpdate_564295 = ref object of OpenApiRestCall_563564
proc url_LabAccountsUpdate_564297(protocol: Scheme; host: string; base: string;
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

proc validate_LabAccountsUpdate_564296(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Modify properties of lab accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("labAccountName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "labAccountName", valid_564299
  var valid_564300 = path.getOrDefault("resourceGroupName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "resourceGroupName", valid_564300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564301 = query.getOrDefault("api-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564301 != nil:
    section.add "api-version", valid_564301
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

proc call*(call_564303: Call_LabAccountsUpdate_564295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of lab accounts.
  ## 
  let valid = call_564303.validator(path, query, header, formData, body)
  let scheme = call_564303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564303.url(scheme.get, call_564303.host, call_564303.base,
                         call_564303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564303, url, valid)

proc call*(call_564304: Call_LabAccountsUpdate_564295; labAccount: JsonNode;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labAccountsUpdate
  ## Modify properties of lab accounts.
  ##   labAccount: JObject (required)
  ##             : Represents a lab account.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564305 = newJObject()
  var query_564306 = newJObject()
  var body_564307 = newJObject()
  if labAccount != nil:
    body_564307 = labAccount
  add(query_564306, "api-version", newJString(apiVersion))
  add(path_564305, "subscriptionId", newJString(subscriptionId))
  add(path_564305, "labAccountName", newJString(labAccountName))
  add(path_564305, "resourceGroupName", newJString(resourceGroupName))
  result = call_564304.call(path_564305, query_564306, nil, nil, body_564307)

var labAccountsUpdate* = Call_LabAccountsUpdate_564295(name: "labAccountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsUpdate_564296, base: "",
    url: url_LabAccountsUpdate_564297, schemes: {Scheme.Https})
type
  Call_LabAccountsDelete_564284 = ref object of OpenApiRestCall_563564
proc url_LabAccountsDelete_564286(protocol: Scheme; host: string; base: string;
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

proc validate_LabAccountsDelete_564285(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete lab account. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564287 = path.getOrDefault("subscriptionId")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "subscriptionId", valid_564287
  var valid_564288 = path.getOrDefault("labAccountName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "labAccountName", valid_564288
  var valid_564289 = path.getOrDefault("resourceGroupName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "resourceGroupName", valid_564289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564290 = query.getOrDefault("api-version")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564290 != nil:
    section.add "api-version", valid_564290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564291: Call_LabAccountsDelete_564284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab account. This operation can take a while to complete
  ## 
  let valid = call_564291.validator(path, query, header, formData, body)
  let scheme = call_564291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564291.url(scheme.get, call_564291.host, call_564291.base,
                         call_564291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564291, url, valid)

proc call*(call_564292: Call_LabAccountsDelete_564284; subscriptionId: string;
          labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labAccountsDelete
  ## Delete lab account. This operation can take a while to complete
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564293 = newJObject()
  var query_564294 = newJObject()
  add(query_564294, "api-version", newJString(apiVersion))
  add(path_564293, "subscriptionId", newJString(subscriptionId))
  add(path_564293, "labAccountName", newJString(labAccountName))
  add(path_564293, "resourceGroupName", newJString(resourceGroupName))
  result = call_564292.call(path_564293, query_564294, nil, nil, nil)

var labAccountsDelete* = Call_LabAccountsDelete_564284(name: "labAccountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsDelete_564285, base: "",
    url: url_LabAccountsDelete_564286, schemes: {Scheme.Https})
type
  Call_LabAccountsCreateLab_564308 = ref object of OpenApiRestCall_563564
proc url_LabAccountsCreateLab_564310(protocol: Scheme; host: string; base: string;
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

proc validate_LabAccountsCreateLab_564309(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a lab in a lab account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564311 = path.getOrDefault("subscriptionId")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "subscriptionId", valid_564311
  var valid_564312 = path.getOrDefault("labAccountName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "labAccountName", valid_564312
  var valid_564313 = path.getOrDefault("resourceGroupName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "resourceGroupName", valid_564313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564314 = query.getOrDefault("api-version")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564314 != nil:
    section.add "api-version", valid_564314
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

proc call*(call_564316: Call_LabAccountsCreateLab_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a lab in a lab account.
  ## 
  let valid = call_564316.validator(path, query, header, formData, body)
  let scheme = call_564316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564316.url(scheme.get, call_564316.host, call_564316.base,
                         call_564316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564316, url, valid)

proc call*(call_564317: Call_LabAccountsCreateLab_564308;
          createLabProperties: JsonNode; subscriptionId: string;
          labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labAccountsCreateLab
  ## Create a lab in a lab account.
  ##   createLabProperties: JObject (required)
  ##                      : Properties for creating a managed lab and a default environment setting
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564318 = newJObject()
  var query_564319 = newJObject()
  var body_564320 = newJObject()
  if createLabProperties != nil:
    body_564320 = createLabProperties
  add(query_564319, "api-version", newJString(apiVersion))
  add(path_564318, "subscriptionId", newJString(subscriptionId))
  add(path_564318, "labAccountName", newJString(labAccountName))
  add(path_564318, "resourceGroupName", newJString(resourceGroupName))
  result = call_564317.call(path_564318, query_564319, nil, nil, body_564320)

var labAccountsCreateLab* = Call_LabAccountsCreateLab_564308(
    name: "labAccountsCreateLab", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/createLab",
    validator: validate_LabAccountsCreateLab_564309, base: "",
    url: url_LabAccountsCreateLab_564310, schemes: {Scheme.Https})
type
  Call_GalleryImagesList_564321 = ref object of OpenApiRestCall_563564
proc url_GalleryImagesList_564323(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesList_564322(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List gallery images in a given lab account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564324 = path.getOrDefault("subscriptionId")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "subscriptionId", valid_564324
  var valid_564325 = path.getOrDefault("labAccountName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "labAccountName", valid_564325
  var valid_564326 = path.getOrDefault("resourceGroupName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "resourceGroupName", valid_564326
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=author)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564327 = query.getOrDefault("$top")
  valid_564327 = validateParameter(valid_564327, JInt, required = false, default = nil)
  if valid_564327 != nil:
    section.add "$top", valid_564327
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564328 = query.getOrDefault("api-version")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564328 != nil:
    section.add "api-version", valid_564328
  var valid_564329 = query.getOrDefault("$expand")
  valid_564329 = validateParameter(valid_564329, JString, required = false,
                                 default = nil)
  if valid_564329 != nil:
    section.add "$expand", valid_564329
  var valid_564330 = query.getOrDefault("$orderby")
  valid_564330 = validateParameter(valid_564330, JString, required = false,
                                 default = nil)
  if valid_564330 != nil:
    section.add "$orderby", valid_564330
  var valid_564331 = query.getOrDefault("$filter")
  valid_564331 = validateParameter(valid_564331, JString, required = false,
                                 default = nil)
  if valid_564331 != nil:
    section.add "$filter", valid_564331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564332: Call_GalleryImagesList_564321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images in a given lab account.
  ## 
  let valid = call_564332.validator(path, query, header, formData, body)
  let scheme = call_564332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564332.url(scheme.get, call_564332.host, call_564332.base,
                         call_564332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564332, url, valid)

proc call*(call_564333: Call_GalleryImagesList_564321; subscriptionId: string;
          labAccountName: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-10-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## galleryImagesList
  ## List gallery images in a given lab account.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=author)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564334 = newJObject()
  var query_564335 = newJObject()
  add(query_564335, "$top", newJInt(Top))
  add(query_564335, "api-version", newJString(apiVersion))
  add(query_564335, "$expand", newJString(Expand))
  add(path_564334, "subscriptionId", newJString(subscriptionId))
  add(query_564335, "$orderby", newJString(Orderby))
  add(path_564334, "labAccountName", newJString(labAccountName))
  add(path_564334, "resourceGroupName", newJString(resourceGroupName))
  add(query_564335, "$filter", newJString(Filter))
  result = call_564333.call(path_564334, query_564335, nil, nil, nil)

var galleryImagesList* = Call_GalleryImagesList_564321(name: "galleryImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages",
    validator: validate_GalleryImagesList_564322, base: "",
    url: url_GalleryImagesList_564323, schemes: {Scheme.Https})
type
  Call_GalleryImagesCreateOrUpdate_564349 = ref object of OpenApiRestCall_563564
proc url_GalleryImagesCreateOrUpdate_564351(protocol: Scheme; host: string;
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

proc validate_GalleryImagesCreateOrUpdate_564350(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Gallery Image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564352 = path.getOrDefault("subscriptionId")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "subscriptionId", valid_564352
  var valid_564353 = path.getOrDefault("labAccountName")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "labAccountName", valid_564353
  var valid_564354 = path.getOrDefault("resourceGroupName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "resourceGroupName", valid_564354
  var valid_564355 = path.getOrDefault("galleryImageName")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "galleryImageName", valid_564355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564356 = query.getOrDefault("api-version")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564356 != nil:
    section.add "api-version", valid_564356
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

proc call*(call_564358: Call_GalleryImagesCreateOrUpdate_564349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Gallery Image.
  ## 
  let valid = call_564358.validator(path, query, header, formData, body)
  let scheme = call_564358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564358.url(scheme.get, call_564358.host, call_564358.base,
                         call_564358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564358, url, valid)

proc call*(call_564359: Call_GalleryImagesCreateOrUpdate_564349;
          galleryImage: JsonNode; subscriptionId: string; labAccountName: string;
          resourceGroupName: string; galleryImageName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## galleryImagesCreateOrUpdate
  ## Create or replace an existing Gallery Image.
  ##   galleryImage: JObject (required)
  ##               : Represents an image from the Azure Marketplace
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image.
  var path_564360 = newJObject()
  var query_564361 = newJObject()
  var body_564362 = newJObject()
  if galleryImage != nil:
    body_564362 = galleryImage
  add(query_564361, "api-version", newJString(apiVersion))
  add(path_564360, "subscriptionId", newJString(subscriptionId))
  add(path_564360, "labAccountName", newJString(labAccountName))
  add(path_564360, "resourceGroupName", newJString(resourceGroupName))
  add(path_564360, "galleryImageName", newJString(galleryImageName))
  result = call_564359.call(path_564360, query_564361, nil, nil, body_564362)

var galleryImagesCreateOrUpdate* = Call_GalleryImagesCreateOrUpdate_564349(
    name: "galleryImagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesCreateOrUpdate_564350, base: "",
    url: url_GalleryImagesCreateOrUpdate_564351, schemes: {Scheme.Https})
type
  Call_GalleryImagesGet_564336 = ref object of OpenApiRestCall_563564
proc url_GalleryImagesGet_564338(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesGet_564337(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get gallery image
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564339 = path.getOrDefault("subscriptionId")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "subscriptionId", valid_564339
  var valid_564340 = path.getOrDefault("labAccountName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "labAccountName", valid_564340
  var valid_564341 = path.getOrDefault("resourceGroupName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "resourceGroupName", valid_564341
  var valid_564342 = path.getOrDefault("galleryImageName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "galleryImageName", valid_564342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=author)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564343 = query.getOrDefault("api-version")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564343 != nil:
    section.add "api-version", valid_564343
  var valid_564344 = query.getOrDefault("$expand")
  valid_564344 = validateParameter(valid_564344, JString, required = false,
                                 default = nil)
  if valid_564344 != nil:
    section.add "$expand", valid_564344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564345: Call_GalleryImagesGet_564336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get gallery image
  ## 
  let valid = call_564345.validator(path, query, header, formData, body)
  let scheme = call_564345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564345.url(scheme.get, call_564345.host, call_564345.base,
                         call_564345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564345, url, valid)

proc call*(call_564346: Call_GalleryImagesGet_564336; subscriptionId: string;
          labAccountName: string; resourceGroupName: string;
          galleryImageName: string; apiVersion: string = "2018-10-15";
          Expand: string = ""): Recallable =
  ## galleryImagesGet
  ## Get gallery image
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=author)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image.
  var path_564347 = newJObject()
  var query_564348 = newJObject()
  add(query_564348, "api-version", newJString(apiVersion))
  add(query_564348, "$expand", newJString(Expand))
  add(path_564347, "subscriptionId", newJString(subscriptionId))
  add(path_564347, "labAccountName", newJString(labAccountName))
  add(path_564347, "resourceGroupName", newJString(resourceGroupName))
  add(path_564347, "galleryImageName", newJString(galleryImageName))
  result = call_564346.call(path_564347, query_564348, nil, nil, nil)

var galleryImagesGet* = Call_GalleryImagesGet_564336(name: "galleryImagesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesGet_564337, base: "",
    url: url_GalleryImagesGet_564338, schemes: {Scheme.Https})
type
  Call_GalleryImagesUpdate_564375 = ref object of OpenApiRestCall_563564
proc url_GalleryImagesUpdate_564377(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesUpdate_564376(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Modify properties of gallery images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564378 = path.getOrDefault("subscriptionId")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "subscriptionId", valid_564378
  var valid_564379 = path.getOrDefault("labAccountName")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "labAccountName", valid_564379
  var valid_564380 = path.getOrDefault("resourceGroupName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "resourceGroupName", valid_564380
  var valid_564381 = path.getOrDefault("galleryImageName")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "galleryImageName", valid_564381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564382 = query.getOrDefault("api-version")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564382 != nil:
    section.add "api-version", valid_564382
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

proc call*(call_564384: Call_GalleryImagesUpdate_564375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of gallery images.
  ## 
  let valid = call_564384.validator(path, query, header, formData, body)
  let scheme = call_564384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564384.url(scheme.get, call_564384.host, call_564384.base,
                         call_564384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564384, url, valid)

proc call*(call_564385: Call_GalleryImagesUpdate_564375; galleryImage: JsonNode;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          galleryImageName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## galleryImagesUpdate
  ## Modify properties of gallery images.
  ##   galleryImage: JObject (required)
  ##               : Represents an image from the Azure Marketplace
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image.
  var path_564386 = newJObject()
  var query_564387 = newJObject()
  var body_564388 = newJObject()
  if galleryImage != nil:
    body_564388 = galleryImage
  add(query_564387, "api-version", newJString(apiVersion))
  add(path_564386, "subscriptionId", newJString(subscriptionId))
  add(path_564386, "labAccountName", newJString(labAccountName))
  add(path_564386, "resourceGroupName", newJString(resourceGroupName))
  add(path_564386, "galleryImageName", newJString(galleryImageName))
  result = call_564385.call(path_564386, query_564387, nil, nil, body_564388)

var galleryImagesUpdate* = Call_GalleryImagesUpdate_564375(
    name: "galleryImagesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesUpdate_564376, base: "",
    url: url_GalleryImagesUpdate_564377, schemes: {Scheme.Https})
type
  Call_GalleryImagesDelete_564363 = ref object of OpenApiRestCall_563564
proc url_GalleryImagesDelete_564365(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesDelete_564364(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete gallery image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: JString (required)
  ##                   : The name of the gallery Image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564366 = path.getOrDefault("subscriptionId")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "subscriptionId", valid_564366
  var valid_564367 = path.getOrDefault("labAccountName")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "labAccountName", valid_564367
  var valid_564368 = path.getOrDefault("resourceGroupName")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "resourceGroupName", valid_564368
  var valid_564369 = path.getOrDefault("galleryImageName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "galleryImageName", valid_564369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564370 = query.getOrDefault("api-version")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564370 != nil:
    section.add "api-version", valid_564370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564371: Call_GalleryImagesDelete_564363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete gallery image.
  ## 
  let valid = call_564371.validator(path, query, header, formData, body)
  let scheme = call_564371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564371.url(scheme.get, call_564371.host, call_564371.base,
                         call_564371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564371, url, valid)

proc call*(call_564372: Call_GalleryImagesDelete_564363; subscriptionId: string;
          labAccountName: string; resourceGroupName: string;
          galleryImageName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## galleryImagesDelete
  ## Delete gallery image.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   galleryImageName: string (required)
  ##                   : The name of the gallery Image.
  var path_564373 = newJObject()
  var query_564374 = newJObject()
  add(query_564374, "api-version", newJString(apiVersion))
  add(path_564373, "subscriptionId", newJString(subscriptionId))
  add(path_564373, "labAccountName", newJString(labAccountName))
  add(path_564373, "resourceGroupName", newJString(resourceGroupName))
  add(path_564373, "galleryImageName", newJString(galleryImageName))
  result = call_564372.call(path_564373, query_564374, nil, nil, nil)

var galleryImagesDelete* = Call_GalleryImagesDelete_564363(
    name: "galleryImagesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesDelete_564364, base: "",
    url: url_GalleryImagesDelete_564365, schemes: {Scheme.Https})
type
  Call_LabAccountsGetRegionalAvailability_564389 = ref object of OpenApiRestCall_563564
proc url_LabAccountsGetRegionalAvailability_564391(protocol: Scheme; host: string;
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

proc validate_LabAccountsGetRegionalAvailability_564390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get regional availability information for each size category configured under a lab account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564392 = path.getOrDefault("subscriptionId")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "subscriptionId", valid_564392
  var valid_564393 = path.getOrDefault("labAccountName")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "labAccountName", valid_564393
  var valid_564394 = path.getOrDefault("resourceGroupName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "resourceGroupName", valid_564394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564395 = query.getOrDefault("api-version")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564395 != nil:
    section.add "api-version", valid_564395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564396: Call_LabAccountsGetRegionalAvailability_564389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get regional availability information for each size category configured under a lab account
  ## 
  let valid = call_564396.validator(path, query, header, formData, body)
  let scheme = call_564396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564396.url(scheme.get, call_564396.host, call_564396.base,
                         call_564396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564396, url, valid)

proc call*(call_564397: Call_LabAccountsGetRegionalAvailability_564389;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labAccountsGetRegionalAvailability
  ## Get regional availability information for each size category configured under a lab account
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564398 = newJObject()
  var query_564399 = newJObject()
  add(query_564399, "api-version", newJString(apiVersion))
  add(path_564398, "subscriptionId", newJString(subscriptionId))
  add(path_564398, "labAccountName", newJString(labAccountName))
  add(path_564398, "resourceGroupName", newJString(resourceGroupName))
  result = call_564397.call(path_564398, query_564399, nil, nil, nil)

var labAccountsGetRegionalAvailability* = Call_LabAccountsGetRegionalAvailability_564389(
    name: "labAccountsGetRegionalAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/getRegionalAvailability",
    validator: validate_LabAccountsGetRegionalAvailability_564390, base: "",
    url: url_LabAccountsGetRegionalAvailability_564391, schemes: {Scheme.Https})
type
  Call_LabsList_564400 = ref object of OpenApiRestCall_563564
proc url_LabsList_564402(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsList_564401(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs in a given lab account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564403 = path.getOrDefault("subscriptionId")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "subscriptionId", valid_564403
  var valid_564404 = path.getOrDefault("labAccountName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "labAccountName", valid_564404
  var valid_564405 = path.getOrDefault("resourceGroupName")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "resourceGroupName", valid_564405
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=maxUsersInLab)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564406 = query.getOrDefault("$top")
  valid_564406 = validateParameter(valid_564406, JInt, required = false, default = nil)
  if valid_564406 != nil:
    section.add "$top", valid_564406
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564407 = query.getOrDefault("api-version")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564407 != nil:
    section.add "api-version", valid_564407
  var valid_564408 = query.getOrDefault("$expand")
  valid_564408 = validateParameter(valid_564408, JString, required = false,
                                 default = nil)
  if valid_564408 != nil:
    section.add "$expand", valid_564408
  var valid_564409 = query.getOrDefault("$orderby")
  valid_564409 = validateParameter(valid_564409, JString, required = false,
                                 default = nil)
  if valid_564409 != nil:
    section.add "$orderby", valid_564409
  var valid_564410 = query.getOrDefault("$filter")
  valid_564410 = validateParameter(valid_564410, JString, required = false,
                                 default = nil)
  if valid_564410 != nil:
    section.add "$filter", valid_564410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564411: Call_LabsList_564400; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a given lab account.
  ## 
  let valid = call_564411.validator(path, query, header, formData, body)
  let scheme = call_564411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564411.url(scheme.get, call_564411.host, call_564411.base,
                         call_564411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564411, url, valid)

proc call*(call_564412: Call_LabsList_564400; subscriptionId: string;
          labAccountName: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-10-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## labsList
  ## List labs in a given lab account.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=maxUsersInLab)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564413 = newJObject()
  var query_564414 = newJObject()
  add(query_564414, "$top", newJInt(Top))
  add(query_564414, "api-version", newJString(apiVersion))
  add(query_564414, "$expand", newJString(Expand))
  add(path_564413, "subscriptionId", newJString(subscriptionId))
  add(query_564414, "$orderby", newJString(Orderby))
  add(path_564413, "labAccountName", newJString(labAccountName))
  add(path_564413, "resourceGroupName", newJString(resourceGroupName))
  add(query_564414, "$filter", newJString(Filter))
  result = call_564412.call(path_564413, query_564414, nil, nil, nil)

var labsList* = Call_LabsList_564400(name: "labsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs",
                                  validator: validate_LabsList_564401, base: "",
                                  url: url_LabsList_564402,
                                  schemes: {Scheme.Https})
type
  Call_LabsCreateOrUpdate_564428 = ref object of OpenApiRestCall_563564
proc url_LabsCreateOrUpdate_564430(protocol: Scheme; host: string; base: string;
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

proc validate_LabsCreateOrUpdate_564429(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create or replace an existing Lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564431 = path.getOrDefault("labName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "labName", valid_564431
  var valid_564432 = path.getOrDefault("subscriptionId")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "subscriptionId", valid_564432
  var valid_564433 = path.getOrDefault("labAccountName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "labAccountName", valid_564433
  var valid_564434 = path.getOrDefault("resourceGroupName")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "resourceGroupName", valid_564434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564435 = query.getOrDefault("api-version")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564435 != nil:
    section.add "api-version", valid_564435
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

proc call*(call_564437: Call_LabsCreateOrUpdate_564428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Lab.
  ## 
  let valid = call_564437.validator(path, query, header, formData, body)
  let scheme = call_564437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564437.url(scheme.get, call_564437.host, call_564437.base,
                         call_564437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564437, url, valid)

proc call*(call_564438: Call_LabsCreateOrUpdate_564428; lab: JsonNode;
          labName: string; subscriptionId: string; labAccountName: string;
          resourceGroupName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## labsCreateOrUpdate
  ## Create or replace an existing Lab.
  ##   lab: JObject (required)
  ##      : Represents a lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564439 = newJObject()
  var query_564440 = newJObject()
  var body_564441 = newJObject()
  if lab != nil:
    body_564441 = lab
  add(path_564439, "labName", newJString(labName))
  add(query_564440, "api-version", newJString(apiVersion))
  add(path_564439, "subscriptionId", newJString(subscriptionId))
  add(path_564439, "labAccountName", newJString(labAccountName))
  add(path_564439, "resourceGroupName", newJString(resourceGroupName))
  result = call_564438.call(path_564439, query_564440, nil, nil, body_564441)

var labsCreateOrUpdate* = Call_LabsCreateOrUpdate_564428(
    name: "labsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
    validator: validate_LabsCreateOrUpdate_564429, base: "",
    url: url_LabsCreateOrUpdate_564430, schemes: {Scheme.Https})
type
  Call_LabsGet_564415 = ref object of OpenApiRestCall_563564
proc url_LabsGet_564417(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsGet_564416(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Get lab
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564418 = path.getOrDefault("labName")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "labName", valid_564418
  var valid_564419 = path.getOrDefault("subscriptionId")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "subscriptionId", valid_564419
  var valid_564420 = path.getOrDefault("labAccountName")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "labAccountName", valid_564420
  var valid_564421 = path.getOrDefault("resourceGroupName")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "resourceGroupName", valid_564421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=maxUsersInLab)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564422 = query.getOrDefault("api-version")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564422 != nil:
    section.add "api-version", valid_564422
  var valid_564423 = query.getOrDefault("$expand")
  valid_564423 = validateParameter(valid_564423, JString, required = false,
                                 default = nil)
  if valid_564423 != nil:
    section.add "$expand", valid_564423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564424: Call_LabsGet_564415; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab
  ## 
  let valid = call_564424.validator(path, query, header, formData, body)
  let scheme = call_564424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564424.url(scheme.get, call_564424.host, call_564424.base,
                         call_564424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564424, url, valid)

proc call*(call_564425: Call_LabsGet_564415; labName: string; subscriptionId: string;
          labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"; Expand: string = ""): Recallable =
  ## labsGet
  ## Get lab
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=maxUsersInLab)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564426 = newJObject()
  var query_564427 = newJObject()
  add(path_564426, "labName", newJString(labName))
  add(query_564427, "api-version", newJString(apiVersion))
  add(query_564427, "$expand", newJString(Expand))
  add(path_564426, "subscriptionId", newJString(subscriptionId))
  add(path_564426, "labAccountName", newJString(labAccountName))
  add(path_564426, "resourceGroupName", newJString(resourceGroupName))
  result = call_564425.call(path_564426, query_564427, nil, nil, nil)

var labsGet* = Call_LabsGet_564415(name: "labsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
                                validator: validate_LabsGet_564416, base: "",
                                url: url_LabsGet_564417, schemes: {Scheme.Https})
type
  Call_LabsUpdate_564454 = ref object of OpenApiRestCall_563564
proc url_LabsUpdate_564456(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsUpdate_564455(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564457 = path.getOrDefault("labName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "labName", valid_564457
  var valid_564458 = path.getOrDefault("subscriptionId")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "subscriptionId", valid_564458
  var valid_564459 = path.getOrDefault("labAccountName")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "labAccountName", valid_564459
  var valid_564460 = path.getOrDefault("resourceGroupName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "resourceGroupName", valid_564460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564461 = query.getOrDefault("api-version")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564461 != nil:
    section.add "api-version", valid_564461
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

proc call*(call_564463: Call_LabsUpdate_564454; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of labs.
  ## 
  let valid = call_564463.validator(path, query, header, formData, body)
  let scheme = call_564463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564463.url(scheme.get, call_564463.host, call_564463.base,
                         call_564463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564463, url, valid)

proc call*(call_564464: Call_LabsUpdate_564454; lab: JsonNode; labName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labsUpdate
  ## Modify properties of labs.
  ##   lab: JObject (required)
  ##      : Represents a lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564465 = newJObject()
  var query_564466 = newJObject()
  var body_564467 = newJObject()
  if lab != nil:
    body_564467 = lab
  add(path_564465, "labName", newJString(labName))
  add(query_564466, "api-version", newJString(apiVersion))
  add(path_564465, "subscriptionId", newJString(subscriptionId))
  add(path_564465, "labAccountName", newJString(labAccountName))
  add(path_564465, "resourceGroupName", newJString(resourceGroupName))
  result = call_564464.call(path_564465, query_564466, nil, nil, body_564467)

var labsUpdate* = Call_LabsUpdate_564454(name: "labsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
                                      validator: validate_LabsUpdate_564455,
                                      base: "", url: url_LabsUpdate_564456,
                                      schemes: {Scheme.Https})
type
  Call_LabsDelete_564442 = ref object of OpenApiRestCall_563564
proc url_LabsDelete_564444(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsDelete_564443(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete lab. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564445 = path.getOrDefault("labName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "labName", valid_564445
  var valid_564446 = path.getOrDefault("subscriptionId")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "subscriptionId", valid_564446
  var valid_564447 = path.getOrDefault("labAccountName")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "labAccountName", valid_564447
  var valid_564448 = path.getOrDefault("resourceGroupName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "resourceGroupName", valid_564448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564449 = query.getOrDefault("api-version")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564449 != nil:
    section.add "api-version", valid_564449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564450: Call_LabsDelete_564442; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete
  ## 
  let valid = call_564450.validator(path, query, header, formData, body)
  let scheme = call_564450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564450.url(scheme.get, call_564450.host, call_564450.base,
                         call_564450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564450, url, valid)

proc call*(call_564451: Call_LabsDelete_564442; labName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labsDelete
  ## Delete lab. This operation can take a while to complete
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564452 = newJObject()
  var query_564453 = newJObject()
  add(path_564452, "labName", newJString(labName))
  add(query_564453, "api-version", newJString(apiVersion))
  add(path_564452, "subscriptionId", newJString(subscriptionId))
  add(path_564452, "labAccountName", newJString(labAccountName))
  add(path_564452, "resourceGroupName", newJString(resourceGroupName))
  result = call_564451.call(path_564452, query_564453, nil, nil, nil)

var labsDelete* = Call_LabsDelete_564442(name: "labsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
                                      validator: validate_LabsDelete_564443,
                                      base: "", url: url_LabsDelete_564444,
                                      schemes: {Scheme.Https})
type
  Call_LabsAddUsers_564468 = ref object of OpenApiRestCall_563564
proc url_LabsAddUsers_564470(protocol: Scheme; host: string; base: string;
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

proc validate_LabsAddUsers_564469(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Add users to a lab
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564471 = path.getOrDefault("labName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "labName", valid_564471
  var valid_564472 = path.getOrDefault("subscriptionId")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "subscriptionId", valid_564472
  var valid_564473 = path.getOrDefault("labAccountName")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "labAccountName", valid_564473
  var valid_564474 = path.getOrDefault("resourceGroupName")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "resourceGroupName", valid_564474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564475 = query.getOrDefault("api-version")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564475 != nil:
    section.add "api-version", valid_564475
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

proc call*(call_564477: Call_LabsAddUsers_564468; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add users to a lab
  ## 
  let valid = call_564477.validator(path, query, header, formData, body)
  let scheme = call_564477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564477.url(scheme.get, call_564477.host, call_564477.base,
                         call_564477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564477, url, valid)

proc call*(call_564478: Call_LabsAddUsers_564468; labName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          addUsersPayload: JsonNode; apiVersion: string = "2018-10-15"): Recallable =
  ## labsAddUsers
  ## Add users to a lab
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   addUsersPayload: JObject (required)
  ##                  : Payload for Add Users operation on a Lab.
  var path_564479 = newJObject()
  var query_564480 = newJObject()
  var body_564481 = newJObject()
  add(path_564479, "labName", newJString(labName))
  add(query_564480, "api-version", newJString(apiVersion))
  add(path_564479, "subscriptionId", newJString(subscriptionId))
  add(path_564479, "labAccountName", newJString(labAccountName))
  add(path_564479, "resourceGroupName", newJString(resourceGroupName))
  if addUsersPayload != nil:
    body_564481 = addUsersPayload
  result = call_564478.call(path_564479, query_564480, nil, nil, body_564481)

var labsAddUsers* = Call_LabsAddUsers_564468(name: "labsAddUsers",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/addUsers",
    validator: validate_LabsAddUsers_564469, base: "", url: url_LabsAddUsers_564470,
    schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsList_564482 = ref object of OpenApiRestCall_563564
proc url_EnvironmentSettingsList_564484(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentSettingsList_564483(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List environment setting in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564485 = path.getOrDefault("labName")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "labName", valid_564485
  var valid_564486 = path.getOrDefault("subscriptionId")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "subscriptionId", valid_564486
  var valid_564487 = path.getOrDefault("labAccountName")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "labAccountName", valid_564487
  var valid_564488 = path.getOrDefault("resourceGroupName")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "resourceGroupName", valid_564488
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=publishingState)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564489 = query.getOrDefault("$top")
  valid_564489 = validateParameter(valid_564489, JInt, required = false, default = nil)
  if valid_564489 != nil:
    section.add "$top", valid_564489
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564490 = query.getOrDefault("api-version")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564490 != nil:
    section.add "api-version", valid_564490
  var valid_564491 = query.getOrDefault("$expand")
  valid_564491 = validateParameter(valid_564491, JString, required = false,
                                 default = nil)
  if valid_564491 != nil:
    section.add "$expand", valid_564491
  var valid_564492 = query.getOrDefault("$orderby")
  valid_564492 = validateParameter(valid_564492, JString, required = false,
                                 default = nil)
  if valid_564492 != nil:
    section.add "$orderby", valid_564492
  var valid_564493 = query.getOrDefault("$filter")
  valid_564493 = validateParameter(valid_564493, JString, required = false,
                                 default = nil)
  if valid_564493 != nil:
    section.add "$filter", valid_564493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564494: Call_EnvironmentSettingsList_564482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environment setting in a given lab.
  ## 
  let valid = call_564494.validator(path, query, header, formData, body)
  let scheme = call_564494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564494.url(scheme.get, call_564494.host, call_564494.base,
                         call_564494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564494, url, valid)

proc call*(call_564495: Call_EnvironmentSettingsList_564482; labName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          Top: int = 0; apiVersion: string = "2018-10-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## environmentSettingsList
  ## List environment setting in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=publishingState)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564496 = newJObject()
  var query_564497 = newJObject()
  add(path_564496, "labName", newJString(labName))
  add(query_564497, "$top", newJInt(Top))
  add(query_564497, "api-version", newJString(apiVersion))
  add(query_564497, "$expand", newJString(Expand))
  add(path_564496, "subscriptionId", newJString(subscriptionId))
  add(query_564497, "$orderby", newJString(Orderby))
  add(path_564496, "labAccountName", newJString(labAccountName))
  add(path_564496, "resourceGroupName", newJString(resourceGroupName))
  add(query_564497, "$filter", newJString(Filter))
  result = call_564495.call(path_564496, query_564497, nil, nil, nil)

var environmentSettingsList* = Call_EnvironmentSettingsList_564482(
    name: "environmentSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings",
    validator: validate_EnvironmentSettingsList_564483, base: "",
    url: url_EnvironmentSettingsList_564484, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsCreateOrUpdate_564512 = ref object of OpenApiRestCall_563564
proc url_EnvironmentSettingsCreateOrUpdate_564514(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsCreateOrUpdate_564513(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Environment Setting. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564515 = path.getOrDefault("environmentSettingName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "environmentSettingName", valid_564515
  var valid_564516 = path.getOrDefault("labName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "labName", valid_564516
  var valid_564517 = path.getOrDefault("subscriptionId")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "subscriptionId", valid_564517
  var valid_564518 = path.getOrDefault("labAccountName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "labAccountName", valid_564518
  var valid_564519 = path.getOrDefault("resourceGroupName")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "resourceGroupName", valid_564519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564520 = query.getOrDefault("api-version")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564520 != nil:
    section.add "api-version", valid_564520
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

proc call*(call_564522: Call_EnvironmentSettingsCreateOrUpdate_564512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing Environment Setting. This operation can take a while to complete
  ## 
  let valid = call_564522.validator(path, query, header, formData, body)
  let scheme = call_564522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564522.url(scheme.get, call_564522.host, call_564522.base,
                         call_564522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564522, url, valid)

proc call*(call_564523: Call_EnvironmentSettingsCreateOrUpdate_564512;
          environmentSettingName: string; labName: string; subscriptionId: string;
          labAccountName: string; environmentSetting: JsonNode;
          resourceGroupName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsCreateOrUpdate
  ## Create or replace an existing Environment Setting. This operation can take a while to complete
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   environmentSetting: JObject (required)
  ##                     : Represents settings of an environment, from which environment instances would be created
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564524 = newJObject()
  var query_564525 = newJObject()
  var body_564526 = newJObject()
  add(path_564524, "environmentSettingName", newJString(environmentSettingName))
  add(path_564524, "labName", newJString(labName))
  add(query_564525, "api-version", newJString(apiVersion))
  add(path_564524, "subscriptionId", newJString(subscriptionId))
  add(path_564524, "labAccountName", newJString(labAccountName))
  if environmentSetting != nil:
    body_564526 = environmentSetting
  add(path_564524, "resourceGroupName", newJString(resourceGroupName))
  result = call_564523.call(path_564524, query_564525, nil, nil, body_564526)

var environmentSettingsCreateOrUpdate* = Call_EnvironmentSettingsCreateOrUpdate_564512(
    name: "environmentSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsCreateOrUpdate_564513, base: "",
    url: url_EnvironmentSettingsCreateOrUpdate_564514, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsGet_564498 = ref object of OpenApiRestCall_563564
proc url_EnvironmentSettingsGet_564500(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentSettingsGet_564499(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get environment setting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564501 = path.getOrDefault("environmentSettingName")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "environmentSettingName", valid_564501
  var valid_564502 = path.getOrDefault("labName")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "labName", valid_564502
  var valid_564503 = path.getOrDefault("subscriptionId")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "subscriptionId", valid_564503
  var valid_564504 = path.getOrDefault("labAccountName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "labAccountName", valid_564504
  var valid_564505 = path.getOrDefault("resourceGroupName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "resourceGroupName", valid_564505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=publishingState)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564506 = query.getOrDefault("api-version")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564506 != nil:
    section.add "api-version", valid_564506
  var valid_564507 = query.getOrDefault("$expand")
  valid_564507 = validateParameter(valid_564507, JString, required = false,
                                 default = nil)
  if valid_564507 != nil:
    section.add "$expand", valid_564507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564508: Call_EnvironmentSettingsGet_564498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment setting
  ## 
  let valid = call_564508.validator(path, query, header, formData, body)
  let scheme = call_564508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564508.url(scheme.get, call_564508.host, call_564508.base,
                         call_564508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564508, url, valid)

proc call*(call_564509: Call_EnvironmentSettingsGet_564498;
          environmentSettingName: string; labName: string; subscriptionId: string;
          labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"; Expand: string = ""): Recallable =
  ## environmentSettingsGet
  ## Get environment setting
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=publishingState)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564510 = newJObject()
  var query_564511 = newJObject()
  add(path_564510, "environmentSettingName", newJString(environmentSettingName))
  add(path_564510, "labName", newJString(labName))
  add(query_564511, "api-version", newJString(apiVersion))
  add(query_564511, "$expand", newJString(Expand))
  add(path_564510, "subscriptionId", newJString(subscriptionId))
  add(path_564510, "labAccountName", newJString(labAccountName))
  add(path_564510, "resourceGroupName", newJString(resourceGroupName))
  result = call_564509.call(path_564510, query_564511, nil, nil, nil)

var environmentSettingsGet* = Call_EnvironmentSettingsGet_564498(
    name: "environmentSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsGet_564499, base: "",
    url: url_EnvironmentSettingsGet_564500, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsUpdate_564540 = ref object of OpenApiRestCall_563564
proc url_EnvironmentSettingsUpdate_564542(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsUpdate_564541(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of environment setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564543 = path.getOrDefault("environmentSettingName")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "environmentSettingName", valid_564543
  var valid_564544 = path.getOrDefault("labName")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "labName", valid_564544
  var valid_564545 = path.getOrDefault("subscriptionId")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "subscriptionId", valid_564545
  var valid_564546 = path.getOrDefault("labAccountName")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "labAccountName", valid_564546
  var valid_564547 = path.getOrDefault("resourceGroupName")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "resourceGroupName", valid_564547
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564548 = query.getOrDefault("api-version")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564548 != nil:
    section.add "api-version", valid_564548
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

proc call*(call_564550: Call_EnvironmentSettingsUpdate_564540; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of environment setting.
  ## 
  let valid = call_564550.validator(path, query, header, formData, body)
  let scheme = call_564550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564550.url(scheme.get, call_564550.host, call_564550.base,
                         call_564550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564550, url, valid)

proc call*(call_564551: Call_EnvironmentSettingsUpdate_564540;
          environmentSettingName: string; labName: string; subscriptionId: string;
          labAccountName: string; environmentSetting: JsonNode;
          resourceGroupName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsUpdate
  ## Modify properties of environment setting.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   environmentSetting: JObject (required)
  ##                     : Represents settings of an environment, from which environment instances would be created
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564552 = newJObject()
  var query_564553 = newJObject()
  var body_564554 = newJObject()
  add(path_564552, "environmentSettingName", newJString(environmentSettingName))
  add(path_564552, "labName", newJString(labName))
  add(query_564553, "api-version", newJString(apiVersion))
  add(path_564552, "subscriptionId", newJString(subscriptionId))
  add(path_564552, "labAccountName", newJString(labAccountName))
  if environmentSetting != nil:
    body_564554 = environmentSetting
  add(path_564552, "resourceGroupName", newJString(resourceGroupName))
  result = call_564551.call(path_564552, query_564553, nil, nil, body_564554)

var environmentSettingsUpdate* = Call_EnvironmentSettingsUpdate_564540(
    name: "environmentSettingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsUpdate_564541, base: "",
    url: url_EnvironmentSettingsUpdate_564542, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsDelete_564527 = ref object of OpenApiRestCall_563564
proc url_EnvironmentSettingsDelete_564529(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsDelete_564528(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete environment setting. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564530 = path.getOrDefault("environmentSettingName")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "environmentSettingName", valid_564530
  var valid_564531 = path.getOrDefault("labName")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "labName", valid_564531
  var valid_564532 = path.getOrDefault("subscriptionId")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "subscriptionId", valid_564532
  var valid_564533 = path.getOrDefault("labAccountName")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "labAccountName", valid_564533
  var valid_564534 = path.getOrDefault("resourceGroupName")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "resourceGroupName", valid_564534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564535 = query.getOrDefault("api-version")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564535 != nil:
    section.add "api-version", valid_564535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564536: Call_EnvironmentSettingsDelete_564527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment setting. This operation can take a while to complete
  ## 
  let valid = call_564536.validator(path, query, header, formData, body)
  let scheme = call_564536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564536.url(scheme.get, call_564536.host, call_564536.base,
                         call_564536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564536, url, valid)

proc call*(call_564537: Call_EnvironmentSettingsDelete_564527;
          environmentSettingName: string; labName: string; subscriptionId: string;
          labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsDelete
  ## Delete environment setting. This operation can take a while to complete
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564538 = newJObject()
  var query_564539 = newJObject()
  add(path_564538, "environmentSettingName", newJString(environmentSettingName))
  add(path_564538, "labName", newJString(labName))
  add(query_564539, "api-version", newJString(apiVersion))
  add(path_564538, "subscriptionId", newJString(subscriptionId))
  add(path_564538, "labAccountName", newJString(labAccountName))
  add(path_564538, "resourceGroupName", newJString(resourceGroupName))
  result = call_564537.call(path_564538, query_564539, nil, nil, nil)

var environmentSettingsDelete* = Call_EnvironmentSettingsDelete_564527(
    name: "environmentSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsDelete_564528, base: "",
    url: url_EnvironmentSettingsDelete_564529, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsClaimAny_564555 = ref object of OpenApiRestCall_563564
proc url_EnvironmentSettingsClaimAny_564557(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsClaimAny_564556(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Claims a random environment for a user in an environment settings
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564558 = path.getOrDefault("environmentSettingName")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "environmentSettingName", valid_564558
  var valid_564559 = path.getOrDefault("labName")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "labName", valid_564559
  var valid_564560 = path.getOrDefault("subscriptionId")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "subscriptionId", valid_564560
  var valid_564561 = path.getOrDefault("labAccountName")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "labAccountName", valid_564561
  var valid_564562 = path.getOrDefault("resourceGroupName")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "resourceGroupName", valid_564562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564563 = query.getOrDefault("api-version")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564563 != nil:
    section.add "api-version", valid_564563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564564: Call_EnvironmentSettingsClaimAny_564555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims a random environment for a user in an environment settings
  ## 
  let valid = call_564564.validator(path, query, header, formData, body)
  let scheme = call_564564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564564.url(scheme.get, call_564564.host, call_564564.base,
                         call_564564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564564, url, valid)

proc call*(call_564565: Call_EnvironmentSettingsClaimAny_564555;
          environmentSettingName: string; labName: string; subscriptionId: string;
          labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsClaimAny
  ## Claims a random environment for a user in an environment settings
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564566 = newJObject()
  var query_564567 = newJObject()
  add(path_564566, "environmentSettingName", newJString(environmentSettingName))
  add(path_564566, "labName", newJString(labName))
  add(query_564567, "api-version", newJString(apiVersion))
  add(path_564566, "subscriptionId", newJString(subscriptionId))
  add(path_564566, "labAccountName", newJString(labAccountName))
  add(path_564566, "resourceGroupName", newJString(resourceGroupName))
  result = call_564565.call(path_564566, query_564567, nil, nil, nil)

var environmentSettingsClaimAny* = Call_EnvironmentSettingsClaimAny_564555(
    name: "environmentSettingsClaimAny", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/claimAny",
    validator: validate_EnvironmentSettingsClaimAny_564556, base: "",
    url: url_EnvironmentSettingsClaimAny_564557, schemes: {Scheme.Https})
type
  Call_EnvironmentsList_564568 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsList_564570(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsList_564569(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List environments in a given environment setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564571 = path.getOrDefault("environmentSettingName")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "environmentSettingName", valid_564571
  var valid_564572 = path.getOrDefault("labName")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "labName", valid_564572
  var valid_564573 = path.getOrDefault("subscriptionId")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "subscriptionId", valid_564573
  var valid_564574 = path.getOrDefault("labAccountName")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "labAccountName", valid_564574
  var valid_564575 = path.getOrDefault("resourceGroupName")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "resourceGroupName", valid_564575
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=networkInterface)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564576 = query.getOrDefault("$top")
  valid_564576 = validateParameter(valid_564576, JInt, required = false, default = nil)
  if valid_564576 != nil:
    section.add "$top", valid_564576
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564577 = query.getOrDefault("api-version")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564577 != nil:
    section.add "api-version", valid_564577
  var valid_564578 = query.getOrDefault("$expand")
  valid_564578 = validateParameter(valid_564578, JString, required = false,
                                 default = nil)
  if valid_564578 != nil:
    section.add "$expand", valid_564578
  var valid_564579 = query.getOrDefault("$orderby")
  valid_564579 = validateParameter(valid_564579, JString, required = false,
                                 default = nil)
  if valid_564579 != nil:
    section.add "$orderby", valid_564579
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

proc call*(call_564581: Call_EnvironmentsList_564568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environments in a given environment setting.
  ## 
  let valid = call_564581.validator(path, query, header, formData, body)
  let scheme = call_564581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564581.url(scheme.get, call_564581.host, call_564581.base,
                         call_564581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564581, url, valid)

proc call*(call_564582: Call_EnvironmentsList_564568;
          environmentSettingName: string; labName: string; subscriptionId: string;
          labAccountName: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-10-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## environmentsList
  ## List environments in a given environment setting.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=networkInterface)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564583 = newJObject()
  var query_564584 = newJObject()
  add(path_564583, "environmentSettingName", newJString(environmentSettingName))
  add(path_564583, "labName", newJString(labName))
  add(query_564584, "$top", newJInt(Top))
  add(query_564584, "api-version", newJString(apiVersion))
  add(query_564584, "$expand", newJString(Expand))
  add(path_564583, "subscriptionId", newJString(subscriptionId))
  add(query_564584, "$orderby", newJString(Orderby))
  add(path_564583, "labAccountName", newJString(labAccountName))
  add(path_564583, "resourceGroupName", newJString(resourceGroupName))
  add(query_564584, "$filter", newJString(Filter))
  result = call_564582.call(path_564583, query_564584, nil, nil, nil)

var environmentsList* = Call_EnvironmentsList_564568(name: "environmentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments",
    validator: validate_EnvironmentsList_564569, base: "",
    url: url_EnvironmentsList_564570, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_564600 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsCreateOrUpdate_564602(protocol: Scheme; host: string;
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

proc validate_EnvironmentsCreateOrUpdate_564601(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564603 = path.getOrDefault("environmentSettingName")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "environmentSettingName", valid_564603
  var valid_564604 = path.getOrDefault("labName")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "labName", valid_564604
  var valid_564605 = path.getOrDefault("environmentName")
  valid_564605 = validateParameter(valid_564605, JString, required = true,
                                 default = nil)
  if valid_564605 != nil:
    section.add "environmentName", valid_564605
  var valid_564606 = path.getOrDefault("subscriptionId")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "subscriptionId", valid_564606
  var valid_564607 = path.getOrDefault("labAccountName")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "labAccountName", valid_564607
  var valid_564608 = path.getOrDefault("resourceGroupName")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "resourceGroupName", valid_564608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564609 = query.getOrDefault("api-version")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564609 != nil:
    section.add "api-version", valid_564609
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

proc call*(call_564611: Call_EnvironmentsCreateOrUpdate_564600; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Environment.
  ## 
  let valid = call_564611.validator(path, query, header, formData, body)
  let scheme = call_564611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564611.url(scheme.get, call_564611.host, call_564611.base,
                         call_564611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564611, url, valid)

proc call*(call_564612: Call_EnvironmentsCreateOrUpdate_564600;
          environmentSettingName: string; labName: string; environmentName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          environment: JsonNode; apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsCreateOrUpdate
  ## Create or replace an existing Environment.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   environment: JObject (required)
  ##              : Represents an environment instance
  var path_564613 = newJObject()
  var query_564614 = newJObject()
  var body_564615 = newJObject()
  add(path_564613, "environmentSettingName", newJString(environmentSettingName))
  add(path_564613, "labName", newJString(labName))
  add(query_564614, "api-version", newJString(apiVersion))
  add(path_564613, "environmentName", newJString(environmentName))
  add(path_564613, "subscriptionId", newJString(subscriptionId))
  add(path_564613, "labAccountName", newJString(labAccountName))
  add(path_564613, "resourceGroupName", newJString(resourceGroupName))
  if environment != nil:
    body_564615 = environment
  result = call_564612.call(path_564613, query_564614, nil, nil, body_564615)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_564600(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsCreateOrUpdate_564601, base: "",
    url: url_EnvironmentsCreateOrUpdate_564602, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_564585 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsGet_564587(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsGet_564586(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get environment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564588 = path.getOrDefault("environmentSettingName")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "environmentSettingName", valid_564588
  var valid_564589 = path.getOrDefault("labName")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "labName", valid_564589
  var valid_564590 = path.getOrDefault("environmentName")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "environmentName", valid_564590
  var valid_564591 = path.getOrDefault("subscriptionId")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "subscriptionId", valid_564591
  var valid_564592 = path.getOrDefault("labAccountName")
  valid_564592 = validateParameter(valid_564592, JString, required = true,
                                 default = nil)
  if valid_564592 != nil:
    section.add "labAccountName", valid_564592
  var valid_564593 = path.getOrDefault("resourceGroupName")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "resourceGroupName", valid_564593
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=networkInterface)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564594 = query.getOrDefault("api-version")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564594 != nil:
    section.add "api-version", valid_564594
  var valid_564595 = query.getOrDefault("$expand")
  valid_564595 = validateParameter(valid_564595, JString, required = false,
                                 default = nil)
  if valid_564595 != nil:
    section.add "$expand", valid_564595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564596: Call_EnvironmentsGet_564585; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment
  ## 
  let valid = call_564596.validator(path, query, header, formData, body)
  let scheme = call_564596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564596.url(scheme.get, call_564596.host, call_564596.base,
                         call_564596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564596, url, valid)

proc call*(call_564597: Call_EnvironmentsGet_564585;
          environmentSettingName: string; labName: string; environmentName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"; Expand: string = ""): Recallable =
  ## environmentsGet
  ## Get environment
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=networkInterface)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564598 = newJObject()
  var query_564599 = newJObject()
  add(path_564598, "environmentSettingName", newJString(environmentSettingName))
  add(path_564598, "labName", newJString(labName))
  add(query_564599, "api-version", newJString(apiVersion))
  add(path_564598, "environmentName", newJString(environmentName))
  add(query_564599, "$expand", newJString(Expand))
  add(path_564598, "subscriptionId", newJString(subscriptionId))
  add(path_564598, "labAccountName", newJString(labAccountName))
  add(path_564598, "resourceGroupName", newJString(resourceGroupName))
  result = call_564597.call(path_564598, query_564599, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_564585(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsGet_564586, base: "", url: url_EnvironmentsGet_564587,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsUpdate_564630 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsUpdate_564632(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsUpdate_564631(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Modify properties of environments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564633 = path.getOrDefault("environmentSettingName")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "environmentSettingName", valid_564633
  var valid_564634 = path.getOrDefault("labName")
  valid_564634 = validateParameter(valid_564634, JString, required = true,
                                 default = nil)
  if valid_564634 != nil:
    section.add "labName", valid_564634
  var valid_564635 = path.getOrDefault("environmentName")
  valid_564635 = validateParameter(valid_564635, JString, required = true,
                                 default = nil)
  if valid_564635 != nil:
    section.add "environmentName", valid_564635
  var valid_564636 = path.getOrDefault("subscriptionId")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "subscriptionId", valid_564636
  var valid_564637 = path.getOrDefault("labAccountName")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "labAccountName", valid_564637
  var valid_564638 = path.getOrDefault("resourceGroupName")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "resourceGroupName", valid_564638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564639 = query.getOrDefault("api-version")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564639 != nil:
    section.add "api-version", valid_564639
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

proc call*(call_564641: Call_EnvironmentsUpdate_564630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of environments.
  ## 
  let valid = call_564641.validator(path, query, header, formData, body)
  let scheme = call_564641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564641.url(scheme.get, call_564641.host, call_564641.base,
                         call_564641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564641, url, valid)

proc call*(call_564642: Call_EnvironmentsUpdate_564630;
          environmentSettingName: string; labName: string; environmentName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          environment: JsonNode; apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsUpdate
  ## Modify properties of environments.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   environment: JObject (required)
  ##              : Represents an environment instance
  var path_564643 = newJObject()
  var query_564644 = newJObject()
  var body_564645 = newJObject()
  add(path_564643, "environmentSettingName", newJString(environmentSettingName))
  add(path_564643, "labName", newJString(labName))
  add(query_564644, "api-version", newJString(apiVersion))
  add(path_564643, "environmentName", newJString(environmentName))
  add(path_564643, "subscriptionId", newJString(subscriptionId))
  add(path_564643, "labAccountName", newJString(labAccountName))
  add(path_564643, "resourceGroupName", newJString(resourceGroupName))
  if environment != nil:
    body_564645 = environment
  result = call_564642.call(path_564643, query_564644, nil, nil, body_564645)

var environmentsUpdate* = Call_EnvironmentsUpdate_564630(
    name: "environmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsUpdate_564631, base: "",
    url: url_EnvironmentsUpdate_564632, schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_564616 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsDelete_564618(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsDelete_564617(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete environment. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564619 = path.getOrDefault("environmentSettingName")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "environmentSettingName", valid_564619
  var valid_564620 = path.getOrDefault("labName")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "labName", valid_564620
  var valid_564621 = path.getOrDefault("environmentName")
  valid_564621 = validateParameter(valid_564621, JString, required = true,
                                 default = nil)
  if valid_564621 != nil:
    section.add "environmentName", valid_564621
  var valid_564622 = path.getOrDefault("subscriptionId")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "subscriptionId", valid_564622
  var valid_564623 = path.getOrDefault("labAccountName")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "labAccountName", valid_564623
  var valid_564624 = path.getOrDefault("resourceGroupName")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "resourceGroupName", valid_564624
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564625 = query.getOrDefault("api-version")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564625 != nil:
    section.add "api-version", valid_564625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564626: Call_EnvironmentsDelete_564616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment. This operation can take a while to complete
  ## 
  let valid = call_564626.validator(path, query, header, formData, body)
  let scheme = call_564626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564626.url(scheme.get, call_564626.host, call_564626.base,
                         call_564626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564626, url, valid)

proc call*(call_564627: Call_EnvironmentsDelete_564616;
          environmentSettingName: string; labName: string; environmentName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsDelete
  ## Delete environment. This operation can take a while to complete
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564628 = newJObject()
  var query_564629 = newJObject()
  add(path_564628, "environmentSettingName", newJString(environmentSettingName))
  add(path_564628, "labName", newJString(labName))
  add(query_564629, "api-version", newJString(apiVersion))
  add(path_564628, "environmentName", newJString(environmentName))
  add(path_564628, "subscriptionId", newJString(subscriptionId))
  add(path_564628, "labAccountName", newJString(labAccountName))
  add(path_564628, "resourceGroupName", newJString(resourceGroupName))
  result = call_564627.call(path_564628, query_564629, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_564616(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsDelete_564617, base: "",
    url: url_EnvironmentsDelete_564618, schemes: {Scheme.Https})
type
  Call_EnvironmentsClaim_564646 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsClaim_564648(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsClaim_564647(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Claims the environment and assigns it to the user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564649 = path.getOrDefault("environmentSettingName")
  valid_564649 = validateParameter(valid_564649, JString, required = true,
                                 default = nil)
  if valid_564649 != nil:
    section.add "environmentSettingName", valid_564649
  var valid_564650 = path.getOrDefault("labName")
  valid_564650 = validateParameter(valid_564650, JString, required = true,
                                 default = nil)
  if valid_564650 != nil:
    section.add "labName", valid_564650
  var valid_564651 = path.getOrDefault("environmentName")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "environmentName", valid_564651
  var valid_564652 = path.getOrDefault("subscriptionId")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "subscriptionId", valid_564652
  var valid_564653 = path.getOrDefault("labAccountName")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "labAccountName", valid_564653
  var valid_564654 = path.getOrDefault("resourceGroupName")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "resourceGroupName", valid_564654
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564655 = query.getOrDefault("api-version")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564655 != nil:
    section.add "api-version", valid_564655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564656: Call_EnvironmentsClaim_564646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the environment and assigns it to the user
  ## 
  let valid = call_564656.validator(path, query, header, formData, body)
  let scheme = call_564656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564656.url(scheme.get, call_564656.host, call_564656.base,
                         call_564656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564656, url, valid)

proc call*(call_564657: Call_EnvironmentsClaim_564646;
          environmentSettingName: string; labName: string; environmentName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsClaim
  ## Claims the environment and assigns it to the user
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564658 = newJObject()
  var query_564659 = newJObject()
  add(path_564658, "environmentSettingName", newJString(environmentSettingName))
  add(path_564658, "labName", newJString(labName))
  add(query_564659, "api-version", newJString(apiVersion))
  add(path_564658, "environmentName", newJString(environmentName))
  add(path_564658, "subscriptionId", newJString(subscriptionId))
  add(path_564658, "labAccountName", newJString(labAccountName))
  add(path_564658, "resourceGroupName", newJString(resourceGroupName))
  result = call_564657.call(path_564658, query_564659, nil, nil, nil)

var environmentsClaim* = Call_EnvironmentsClaim_564646(name: "environmentsClaim",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/claim",
    validator: validate_EnvironmentsClaim_564647, base: "",
    url: url_EnvironmentsClaim_564648, schemes: {Scheme.Https})
type
  Call_EnvironmentsResetPassword_564660 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsResetPassword_564662(protocol: Scheme; host: string;
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

proc validate_EnvironmentsResetPassword_564661(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets the user password on an environment This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564663 = path.getOrDefault("environmentSettingName")
  valid_564663 = validateParameter(valid_564663, JString, required = true,
                                 default = nil)
  if valid_564663 != nil:
    section.add "environmentSettingName", valid_564663
  var valid_564664 = path.getOrDefault("labName")
  valid_564664 = validateParameter(valid_564664, JString, required = true,
                                 default = nil)
  if valid_564664 != nil:
    section.add "labName", valid_564664
  var valid_564665 = path.getOrDefault("environmentName")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "environmentName", valid_564665
  var valid_564666 = path.getOrDefault("subscriptionId")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "subscriptionId", valid_564666
  var valid_564667 = path.getOrDefault("labAccountName")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "labAccountName", valid_564667
  var valid_564668 = path.getOrDefault("resourceGroupName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "resourceGroupName", valid_564668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564669 = query.getOrDefault("api-version")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564669 != nil:
    section.add "api-version", valid_564669
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

proc call*(call_564671: Call_EnvironmentsResetPassword_564660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the user password on an environment This operation can take a while to complete
  ## 
  let valid = call_564671.validator(path, query, header, formData, body)
  let scheme = call_564671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564671.url(scheme.get, call_564671.host, call_564671.base,
                         call_564671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564671, url, valid)

proc call*(call_564672: Call_EnvironmentsResetPassword_564660;
          environmentSettingName: string; labName: string; environmentName: string;
          subscriptionId: string; labAccountName: string;
          resetPasswordPayload: JsonNode; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsResetPassword
  ## Resets the user password on an environment This operation can take a while to complete
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resetPasswordPayload: JObject (required)
  ##                       : Represents the payload for resetting passwords.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564673 = newJObject()
  var query_564674 = newJObject()
  var body_564675 = newJObject()
  add(path_564673, "environmentSettingName", newJString(environmentSettingName))
  add(path_564673, "labName", newJString(labName))
  add(query_564674, "api-version", newJString(apiVersion))
  add(path_564673, "environmentName", newJString(environmentName))
  add(path_564673, "subscriptionId", newJString(subscriptionId))
  add(path_564673, "labAccountName", newJString(labAccountName))
  if resetPasswordPayload != nil:
    body_564675 = resetPasswordPayload
  add(path_564673, "resourceGroupName", newJString(resourceGroupName))
  result = call_564672.call(path_564673, query_564674, nil, nil, body_564675)

var environmentsResetPassword* = Call_EnvironmentsResetPassword_564660(
    name: "environmentsResetPassword", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/resetPassword",
    validator: validate_EnvironmentsResetPassword_564661, base: "",
    url: url_EnvironmentsResetPassword_564662, schemes: {Scheme.Https})
type
  Call_EnvironmentsStart_564676 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsStart_564678(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsStart_564677(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564679 = path.getOrDefault("environmentSettingName")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "environmentSettingName", valid_564679
  var valid_564680 = path.getOrDefault("labName")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "labName", valid_564680
  var valid_564681 = path.getOrDefault("environmentName")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "environmentName", valid_564681
  var valid_564682 = path.getOrDefault("subscriptionId")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "subscriptionId", valid_564682
  var valid_564683 = path.getOrDefault("labAccountName")
  valid_564683 = validateParameter(valid_564683, JString, required = true,
                                 default = nil)
  if valid_564683 != nil:
    section.add "labAccountName", valid_564683
  var valid_564684 = path.getOrDefault("resourceGroupName")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "resourceGroupName", valid_564684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564685 = query.getOrDefault("api-version")
  valid_564685 = validateParameter(valid_564685, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564685 != nil:
    section.add "api-version", valid_564685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564686: Call_EnvironmentsStart_564676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ## 
  let valid = call_564686.validator(path, query, header, formData, body)
  let scheme = call_564686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564686.url(scheme.get, call_564686.host, call_564686.base,
                         call_564686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564686, url, valid)

proc call*(call_564687: Call_EnvironmentsStart_564676;
          environmentSettingName: string; labName: string; environmentName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsStart
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564688 = newJObject()
  var query_564689 = newJObject()
  add(path_564688, "environmentSettingName", newJString(environmentSettingName))
  add(path_564688, "labName", newJString(labName))
  add(query_564689, "api-version", newJString(apiVersion))
  add(path_564688, "environmentName", newJString(environmentName))
  add(path_564688, "subscriptionId", newJString(subscriptionId))
  add(path_564688, "labAccountName", newJString(labAccountName))
  add(path_564688, "resourceGroupName", newJString(resourceGroupName))
  result = call_564687.call(path_564688, query_564689, nil, nil, nil)

var environmentsStart* = Call_EnvironmentsStart_564676(name: "environmentsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/start",
    validator: validate_EnvironmentsStart_564677, base: "",
    url: url_EnvironmentsStart_564678, schemes: {Scheme.Https})
type
  Call_EnvironmentsStop_564690 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsStop_564692(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsStop_564691(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   environmentName: JString (required)
  ##                  : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564693 = path.getOrDefault("environmentSettingName")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "environmentSettingName", valid_564693
  var valid_564694 = path.getOrDefault("labName")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "labName", valid_564694
  var valid_564695 = path.getOrDefault("environmentName")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "environmentName", valid_564695
  var valid_564696 = path.getOrDefault("subscriptionId")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "subscriptionId", valid_564696
  var valid_564697 = path.getOrDefault("labAccountName")
  valid_564697 = validateParameter(valid_564697, JString, required = true,
                                 default = nil)
  if valid_564697 != nil:
    section.add "labAccountName", valid_564697
  var valid_564698 = path.getOrDefault("resourceGroupName")
  valid_564698 = validateParameter(valid_564698, JString, required = true,
                                 default = nil)
  if valid_564698 != nil:
    section.add "resourceGroupName", valid_564698
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564699 = query.getOrDefault("api-version")
  valid_564699 = validateParameter(valid_564699, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564699 != nil:
    section.add "api-version", valid_564699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564700: Call_EnvironmentsStop_564690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ## 
  let valid = call_564700.validator(path, query, header, formData, body)
  let scheme = call_564700.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564700.url(scheme.get, call_564700.host, call_564700.base,
                         call_564700.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564700, url, valid)

proc call*(call_564701: Call_EnvironmentsStop_564690;
          environmentSettingName: string; labName: string; environmentName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentsStop
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   environmentName: string (required)
  ##                  : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564702 = newJObject()
  var query_564703 = newJObject()
  add(path_564702, "environmentSettingName", newJString(environmentSettingName))
  add(path_564702, "labName", newJString(labName))
  add(query_564703, "api-version", newJString(apiVersion))
  add(path_564702, "environmentName", newJString(environmentName))
  add(path_564702, "subscriptionId", newJString(subscriptionId))
  add(path_564702, "labAccountName", newJString(labAccountName))
  add(path_564702, "resourceGroupName", newJString(resourceGroupName))
  result = call_564701.call(path_564702, query_564703, nil, nil, nil)

var environmentsStop* = Call_EnvironmentsStop_564690(name: "environmentsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/stop",
    validator: validate_EnvironmentsStop_564691, base: "",
    url: url_EnvironmentsStop_564692, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsPublish_564704 = ref object of OpenApiRestCall_563564
proc url_EnvironmentSettingsPublish_564706(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsPublish_564705(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions/deprovisions required resources for an environment setting based on current state of the lab/environment setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564707 = path.getOrDefault("environmentSettingName")
  valid_564707 = validateParameter(valid_564707, JString, required = true,
                                 default = nil)
  if valid_564707 != nil:
    section.add "environmentSettingName", valid_564707
  var valid_564708 = path.getOrDefault("labName")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "labName", valid_564708
  var valid_564709 = path.getOrDefault("subscriptionId")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "subscriptionId", valid_564709
  var valid_564710 = path.getOrDefault("labAccountName")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "labAccountName", valid_564710
  var valid_564711 = path.getOrDefault("resourceGroupName")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = nil)
  if valid_564711 != nil:
    section.add "resourceGroupName", valid_564711
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564712 = query.getOrDefault("api-version")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564712 != nil:
    section.add "api-version", valid_564712
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

proc call*(call_564714: Call_EnvironmentSettingsPublish_564704; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions/deprovisions required resources for an environment setting based on current state of the lab/environment setting.
  ## 
  let valid = call_564714.validator(path, query, header, formData, body)
  let scheme = call_564714.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564714.url(scheme.get, call_564714.host, call_564714.base,
                         call_564714.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564714, url, valid)

proc call*(call_564715: Call_EnvironmentSettingsPublish_564704;
          environmentSettingName: string; labName: string; subscriptionId: string;
          publishPayload: JsonNode; labAccountName: string;
          resourceGroupName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsPublish
  ## Provisions/deprovisions required resources for an environment setting based on current state of the lab/environment setting.
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   publishPayload: JObject (required)
  ##                 : Payload for Publish operation on EnvironmentSetting.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564716 = newJObject()
  var query_564717 = newJObject()
  var body_564718 = newJObject()
  add(path_564716, "environmentSettingName", newJString(environmentSettingName))
  add(path_564716, "labName", newJString(labName))
  add(query_564717, "api-version", newJString(apiVersion))
  add(path_564716, "subscriptionId", newJString(subscriptionId))
  if publishPayload != nil:
    body_564718 = publishPayload
  add(path_564716, "labAccountName", newJString(labAccountName))
  add(path_564716, "resourceGroupName", newJString(resourceGroupName))
  result = call_564715.call(path_564716, query_564717, nil, nil, body_564718)

var environmentSettingsPublish* = Call_EnvironmentSettingsPublish_564704(
    name: "environmentSettingsPublish", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/publish",
    validator: validate_EnvironmentSettingsPublish_564705, base: "",
    url: url_EnvironmentSettingsPublish_564706, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsStart_564719 = ref object of OpenApiRestCall_563564
proc url_EnvironmentSettingsStart_564721(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsStart_564720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564722 = path.getOrDefault("environmentSettingName")
  valid_564722 = validateParameter(valid_564722, JString, required = true,
                                 default = nil)
  if valid_564722 != nil:
    section.add "environmentSettingName", valid_564722
  var valid_564723 = path.getOrDefault("labName")
  valid_564723 = validateParameter(valid_564723, JString, required = true,
                                 default = nil)
  if valid_564723 != nil:
    section.add "labName", valid_564723
  var valid_564724 = path.getOrDefault("subscriptionId")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "subscriptionId", valid_564724
  var valid_564725 = path.getOrDefault("labAccountName")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "labAccountName", valid_564725
  var valid_564726 = path.getOrDefault("resourceGroupName")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "resourceGroupName", valid_564726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564727 = query.getOrDefault("api-version")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564727 != nil:
    section.add "api-version", valid_564727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564728: Call_EnvironmentSettingsStart_564719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ## 
  let valid = call_564728.validator(path, query, header, formData, body)
  let scheme = call_564728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564728.url(scheme.get, call_564728.host, call_564728.base,
                         call_564728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564728, url, valid)

proc call*(call_564729: Call_EnvironmentSettingsStart_564719;
          environmentSettingName: string; labName: string; subscriptionId: string;
          labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsStart
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564730 = newJObject()
  var query_564731 = newJObject()
  add(path_564730, "environmentSettingName", newJString(environmentSettingName))
  add(path_564730, "labName", newJString(labName))
  add(query_564731, "api-version", newJString(apiVersion))
  add(path_564730, "subscriptionId", newJString(subscriptionId))
  add(path_564730, "labAccountName", newJString(labAccountName))
  add(path_564730, "resourceGroupName", newJString(resourceGroupName))
  result = call_564729.call(path_564730, query_564731, nil, nil, nil)

var environmentSettingsStart* = Call_EnvironmentSettingsStart_564719(
    name: "environmentSettingsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/start",
    validator: validate_EnvironmentSettingsStart_564720, base: "",
    url: url_EnvironmentSettingsStart_564721, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsStop_564732 = ref object of OpenApiRestCall_563564
proc url_EnvironmentSettingsStop_564734(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentSettingsStop_564733(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentSettingName: JString (required)
  ##                         : The name of the environment Setting.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `environmentSettingName` field"
  var valid_564735 = path.getOrDefault("environmentSettingName")
  valid_564735 = validateParameter(valid_564735, JString, required = true,
                                 default = nil)
  if valid_564735 != nil:
    section.add "environmentSettingName", valid_564735
  var valid_564736 = path.getOrDefault("labName")
  valid_564736 = validateParameter(valid_564736, JString, required = true,
                                 default = nil)
  if valid_564736 != nil:
    section.add "labName", valid_564736
  var valid_564737 = path.getOrDefault("subscriptionId")
  valid_564737 = validateParameter(valid_564737, JString, required = true,
                                 default = nil)
  if valid_564737 != nil:
    section.add "subscriptionId", valid_564737
  var valid_564738 = path.getOrDefault("labAccountName")
  valid_564738 = validateParameter(valid_564738, JString, required = true,
                                 default = nil)
  if valid_564738 != nil:
    section.add "labAccountName", valid_564738
  var valid_564739 = path.getOrDefault("resourceGroupName")
  valid_564739 = validateParameter(valid_564739, JString, required = true,
                                 default = nil)
  if valid_564739 != nil:
    section.add "resourceGroupName", valid_564739
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564740 = query.getOrDefault("api-version")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564740 != nil:
    section.add "api-version", valid_564740
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564741: Call_EnvironmentSettingsStop_564732; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ## 
  let valid = call_564741.validator(path, query, header, formData, body)
  let scheme = call_564741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564741.url(scheme.get, call_564741.host, call_564741.base,
                         call_564741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564741, url, valid)

proc call*(call_564742: Call_EnvironmentSettingsStop_564732;
          environmentSettingName: string; labName: string; subscriptionId: string;
          labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## environmentSettingsStop
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ##   environmentSettingName: string (required)
  ##                         : The name of the environment Setting.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564743 = newJObject()
  var query_564744 = newJObject()
  add(path_564743, "environmentSettingName", newJString(environmentSettingName))
  add(path_564743, "labName", newJString(labName))
  add(query_564744, "api-version", newJString(apiVersion))
  add(path_564743, "subscriptionId", newJString(subscriptionId))
  add(path_564743, "labAccountName", newJString(labAccountName))
  add(path_564743, "resourceGroupName", newJString(resourceGroupName))
  result = call_564742.call(path_564743, query_564744, nil, nil, nil)

var environmentSettingsStop* = Call_EnvironmentSettingsStop_564732(
    name: "environmentSettingsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/stop",
    validator: validate_EnvironmentSettingsStop_564733, base: "",
    url: url_EnvironmentSettingsStop_564734, schemes: {Scheme.Https})
type
  Call_LabsRegister_564745 = ref object of OpenApiRestCall_563564
proc url_LabsRegister_564747(protocol: Scheme; host: string; base: string;
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

proc validate_LabsRegister_564746(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Register to managed lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564748 = path.getOrDefault("labName")
  valid_564748 = validateParameter(valid_564748, JString, required = true,
                                 default = nil)
  if valid_564748 != nil:
    section.add "labName", valid_564748
  var valid_564749 = path.getOrDefault("subscriptionId")
  valid_564749 = validateParameter(valid_564749, JString, required = true,
                                 default = nil)
  if valid_564749 != nil:
    section.add "subscriptionId", valid_564749
  var valid_564750 = path.getOrDefault("labAccountName")
  valid_564750 = validateParameter(valid_564750, JString, required = true,
                                 default = nil)
  if valid_564750 != nil:
    section.add "labAccountName", valid_564750
  var valid_564751 = path.getOrDefault("resourceGroupName")
  valid_564751 = validateParameter(valid_564751, JString, required = true,
                                 default = nil)
  if valid_564751 != nil:
    section.add "resourceGroupName", valid_564751
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564752 = query.getOrDefault("api-version")
  valid_564752 = validateParameter(valid_564752, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564752 != nil:
    section.add "api-version", valid_564752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564753: Call_LabsRegister_564745; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register to managed lab.
  ## 
  let valid = call_564753.validator(path, query, header, formData, body)
  let scheme = call_564753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564753.url(scheme.get, call_564753.host, call_564753.base,
                         call_564753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564753, url, valid)

proc call*(call_564754: Call_LabsRegister_564745; labName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## labsRegister
  ## Register to managed lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564755 = newJObject()
  var query_564756 = newJObject()
  add(path_564755, "labName", newJString(labName))
  add(query_564756, "api-version", newJString(apiVersion))
  add(path_564755, "subscriptionId", newJString(subscriptionId))
  add(path_564755, "labAccountName", newJString(labAccountName))
  add(path_564755, "resourceGroupName", newJString(resourceGroupName))
  result = call_564754.call(path_564755, query_564756, nil, nil, nil)

var labsRegister* = Call_LabsRegister_564745(name: "labsRegister",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/register",
    validator: validate_LabsRegister_564746, base: "", url: url_LabsRegister_564747,
    schemes: {Scheme.Https})
type
  Call_UsersList_564757 = ref object of OpenApiRestCall_563564
proc url_UsersList_564759(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersList_564758(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List users in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564760 = path.getOrDefault("labName")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = nil)
  if valid_564760 != nil:
    section.add "labName", valid_564760
  var valid_564761 = path.getOrDefault("subscriptionId")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "subscriptionId", valid_564761
  var valid_564762 = path.getOrDefault("labAccountName")
  valid_564762 = validateParameter(valid_564762, JString, required = true,
                                 default = nil)
  if valid_564762 != nil:
    section.add "labAccountName", valid_564762
  var valid_564763 = path.getOrDefault("resourceGroupName")
  valid_564763 = validateParameter(valid_564763, JString, required = true,
                                 default = nil)
  if valid_564763 != nil:
    section.add "resourceGroupName", valid_564763
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=email)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564764 = query.getOrDefault("$top")
  valid_564764 = validateParameter(valid_564764, JInt, required = false, default = nil)
  if valid_564764 != nil:
    section.add "$top", valid_564764
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564765 = query.getOrDefault("api-version")
  valid_564765 = validateParameter(valid_564765, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564765 != nil:
    section.add "api-version", valid_564765
  var valid_564766 = query.getOrDefault("$expand")
  valid_564766 = validateParameter(valid_564766, JString, required = false,
                                 default = nil)
  if valid_564766 != nil:
    section.add "$expand", valid_564766
  var valid_564767 = query.getOrDefault("$orderby")
  valid_564767 = validateParameter(valid_564767, JString, required = false,
                                 default = nil)
  if valid_564767 != nil:
    section.add "$orderby", valid_564767
  var valid_564768 = query.getOrDefault("$filter")
  valid_564768 = validateParameter(valid_564768, JString, required = false,
                                 default = nil)
  if valid_564768 != nil:
    section.add "$filter", valid_564768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564769: Call_UsersList_564757; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List users in a given lab.
  ## 
  let valid = call_564769.validator(path, query, header, formData, body)
  let scheme = call_564769.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564769.url(scheme.get, call_564769.host, call_564769.base,
                         call_564769.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564769, url, valid)

proc call*(call_564770: Call_UsersList_564757; labName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          Top: int = 0; apiVersion: string = "2018-10-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## usersList
  ## List users in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=email)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564771 = newJObject()
  var query_564772 = newJObject()
  add(path_564771, "labName", newJString(labName))
  add(query_564772, "$top", newJInt(Top))
  add(query_564772, "api-version", newJString(apiVersion))
  add(query_564772, "$expand", newJString(Expand))
  add(path_564771, "subscriptionId", newJString(subscriptionId))
  add(query_564772, "$orderby", newJString(Orderby))
  add(path_564771, "labAccountName", newJString(labAccountName))
  add(path_564771, "resourceGroupName", newJString(resourceGroupName))
  add(query_564772, "$filter", newJString(Filter))
  result = call_564770.call(path_564771, query_564772, nil, nil, nil)

var usersList* = Call_UsersList_564757(name: "usersList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users",
                                    validator: validate_UsersList_564758,
                                    base: "", url: url_UsersList_564759,
                                    schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_564787 = ref object of OpenApiRestCall_563564
proc url_UsersCreateOrUpdate_564789(protocol: Scheme; host: string; base: string;
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

proc validate_UsersCreateOrUpdate_564788(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing User.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564790 = path.getOrDefault("labName")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "labName", valid_564790
  var valid_564791 = path.getOrDefault("subscriptionId")
  valid_564791 = validateParameter(valid_564791, JString, required = true,
                                 default = nil)
  if valid_564791 != nil:
    section.add "subscriptionId", valid_564791
  var valid_564792 = path.getOrDefault("labAccountName")
  valid_564792 = validateParameter(valid_564792, JString, required = true,
                                 default = nil)
  if valid_564792 != nil:
    section.add "labAccountName", valid_564792
  var valid_564793 = path.getOrDefault("resourceGroupName")
  valid_564793 = validateParameter(valid_564793, JString, required = true,
                                 default = nil)
  if valid_564793 != nil:
    section.add "resourceGroupName", valid_564793
  var valid_564794 = path.getOrDefault("userName")
  valid_564794 = validateParameter(valid_564794, JString, required = true,
                                 default = nil)
  if valid_564794 != nil:
    section.add "userName", valid_564794
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564795 = query.getOrDefault("api-version")
  valid_564795 = validateParameter(valid_564795, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564795 != nil:
    section.add "api-version", valid_564795
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

proc call*(call_564797: Call_UsersCreateOrUpdate_564787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing User.
  ## 
  let valid = call_564797.validator(path, query, header, formData, body)
  let scheme = call_564797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564797.url(scheme.get, call_564797.host, call_564797.base,
                         call_564797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564797, url, valid)

proc call*(call_564798: Call_UsersCreateOrUpdate_564787; labName: string;
          subscriptionId: string; labAccountName: string; user: JsonNode;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## usersCreateOrUpdate
  ## Create or replace an existing User.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   user: JObject (required)
  ##       : The User registered to a lab
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_564799 = newJObject()
  var query_564800 = newJObject()
  var body_564801 = newJObject()
  add(path_564799, "labName", newJString(labName))
  add(query_564800, "api-version", newJString(apiVersion))
  add(path_564799, "subscriptionId", newJString(subscriptionId))
  add(path_564799, "labAccountName", newJString(labAccountName))
  if user != nil:
    body_564801 = user
  add(path_564799, "resourceGroupName", newJString(resourceGroupName))
  add(path_564799, "userName", newJString(userName))
  result = call_564798.call(path_564799, query_564800, nil, nil, body_564801)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_564787(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
    validator: validate_UsersCreateOrUpdate_564788, base: "",
    url: url_UsersCreateOrUpdate_564789, schemes: {Scheme.Https})
type
  Call_UsersGet_564773 = ref object of OpenApiRestCall_563564
proc url_UsersGet_564775(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersGet_564774(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564776 = path.getOrDefault("labName")
  valid_564776 = validateParameter(valid_564776, JString, required = true,
                                 default = nil)
  if valid_564776 != nil:
    section.add "labName", valid_564776
  var valid_564777 = path.getOrDefault("subscriptionId")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "subscriptionId", valid_564777
  var valid_564778 = path.getOrDefault("labAccountName")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "labAccountName", valid_564778
  var valid_564779 = path.getOrDefault("resourceGroupName")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "resourceGroupName", valid_564779
  var valid_564780 = path.getOrDefault("userName")
  valid_564780 = validateParameter(valid_564780, JString, required = true,
                                 default = nil)
  if valid_564780 != nil:
    section.add "userName", valid_564780
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=email)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564781 = query.getOrDefault("api-version")
  valid_564781 = validateParameter(valid_564781, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564781 != nil:
    section.add "api-version", valid_564781
  var valid_564782 = query.getOrDefault("$expand")
  valid_564782 = validateParameter(valid_564782, JString, required = false,
                                 default = nil)
  if valid_564782 != nil:
    section.add "$expand", valid_564782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564783: Call_UsersGet_564773; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get user
  ## 
  let valid = call_564783.validator(path, query, header, formData, body)
  let scheme = call_564783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564783.url(scheme.get, call_564783.host, call_564783.base,
                         call_564783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564783, url, valid)

proc call*(call_564784: Call_UsersGet_564773; labName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          userName: string; apiVersion: string = "2018-10-15"; Expand: string = ""): Recallable =
  ## usersGet
  ## Get user
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=email)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_564785 = newJObject()
  var query_564786 = newJObject()
  add(path_564785, "labName", newJString(labName))
  add(query_564786, "api-version", newJString(apiVersion))
  add(query_564786, "$expand", newJString(Expand))
  add(path_564785, "subscriptionId", newJString(subscriptionId))
  add(path_564785, "labAccountName", newJString(labAccountName))
  add(path_564785, "resourceGroupName", newJString(resourceGroupName))
  add(path_564785, "userName", newJString(userName))
  result = call_564784.call(path_564785, query_564786, nil, nil, nil)

var usersGet* = Call_UsersGet_564773(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
                                  validator: validate_UsersGet_564774, base: "",
                                  url: url_UsersGet_564775,
                                  schemes: {Scheme.Https})
type
  Call_UsersUpdate_564815 = ref object of OpenApiRestCall_563564
proc url_UsersUpdate_564817(protocol: Scheme; host: string; base: string;
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

proc validate_UsersUpdate_564816(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of users.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564818 = path.getOrDefault("labName")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "labName", valid_564818
  var valid_564819 = path.getOrDefault("subscriptionId")
  valid_564819 = validateParameter(valid_564819, JString, required = true,
                                 default = nil)
  if valid_564819 != nil:
    section.add "subscriptionId", valid_564819
  var valid_564820 = path.getOrDefault("labAccountName")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = nil)
  if valid_564820 != nil:
    section.add "labAccountName", valid_564820
  var valid_564821 = path.getOrDefault("resourceGroupName")
  valid_564821 = validateParameter(valid_564821, JString, required = true,
                                 default = nil)
  if valid_564821 != nil:
    section.add "resourceGroupName", valid_564821
  var valid_564822 = path.getOrDefault("userName")
  valid_564822 = validateParameter(valid_564822, JString, required = true,
                                 default = nil)
  if valid_564822 != nil:
    section.add "userName", valid_564822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564823 = query.getOrDefault("api-version")
  valid_564823 = validateParameter(valid_564823, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564823 != nil:
    section.add "api-version", valid_564823
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

proc call*(call_564825: Call_UsersUpdate_564815; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of users.
  ## 
  let valid = call_564825.validator(path, query, header, formData, body)
  let scheme = call_564825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564825.url(scheme.get, call_564825.host, call_564825.base,
                         call_564825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564825, url, valid)

proc call*(call_564826: Call_UsersUpdate_564815; labName: string;
          subscriptionId: string; labAccountName: string; user: JsonNode;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## usersUpdate
  ## Modify properties of users.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   user: JObject (required)
  ##       : The User registered to a lab
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_564827 = newJObject()
  var query_564828 = newJObject()
  var body_564829 = newJObject()
  add(path_564827, "labName", newJString(labName))
  add(query_564828, "api-version", newJString(apiVersion))
  add(path_564827, "subscriptionId", newJString(subscriptionId))
  add(path_564827, "labAccountName", newJString(labAccountName))
  if user != nil:
    body_564829 = user
  add(path_564827, "resourceGroupName", newJString(resourceGroupName))
  add(path_564827, "userName", newJString(userName))
  result = call_564826.call(path_564827, query_564828, nil, nil, body_564829)

var usersUpdate* = Call_UsersUpdate_564815(name: "usersUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
                                        validator: validate_UsersUpdate_564816,
                                        base: "", url: url_UsersUpdate_564817,
                                        schemes: {Scheme.Https})
type
  Call_UsersDelete_564802 = ref object of OpenApiRestCall_563564
proc url_UsersDelete_564804(protocol: Scheme; host: string; base: string;
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

proc validate_UsersDelete_564803(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete user. This operation can take a while to complete
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labAccountName: JString (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564805 = path.getOrDefault("labName")
  valid_564805 = validateParameter(valid_564805, JString, required = true,
                                 default = nil)
  if valid_564805 != nil:
    section.add "labName", valid_564805
  var valid_564806 = path.getOrDefault("subscriptionId")
  valid_564806 = validateParameter(valid_564806, JString, required = true,
                                 default = nil)
  if valid_564806 != nil:
    section.add "subscriptionId", valid_564806
  var valid_564807 = path.getOrDefault("labAccountName")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = nil)
  if valid_564807 != nil:
    section.add "labAccountName", valid_564807
  var valid_564808 = path.getOrDefault("resourceGroupName")
  valid_564808 = validateParameter(valid_564808, JString, required = true,
                                 default = nil)
  if valid_564808 != nil:
    section.add "resourceGroupName", valid_564808
  var valid_564809 = path.getOrDefault("userName")
  valid_564809 = validateParameter(valid_564809, JString, required = true,
                                 default = nil)
  if valid_564809 != nil:
    section.add "userName", valid_564809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564810 = query.getOrDefault("api-version")
  valid_564810 = validateParameter(valid_564810, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_564810 != nil:
    section.add "api-version", valid_564810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564811: Call_UsersDelete_564802; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user. This operation can take a while to complete
  ## 
  let valid = call_564811.validator(path, query, header, formData, body)
  let scheme = call_564811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564811.url(scheme.get, call_564811.host, call_564811.base,
                         call_564811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564811, url, valid)

proc call*(call_564812: Call_UsersDelete_564802; labName: string;
          subscriptionId: string; labAccountName: string; resourceGroupName: string;
          userName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## usersDelete
  ## Delete user. This operation can take a while to complete
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labAccountName: string (required)
  ##                 : The name of the lab Account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_564813 = newJObject()
  var query_564814 = newJObject()
  add(path_564813, "labName", newJString(labName))
  add(query_564814, "api-version", newJString(apiVersion))
  add(path_564813, "subscriptionId", newJString(subscriptionId))
  add(path_564813, "labAccountName", newJString(labAccountName))
  add(path_564813, "resourceGroupName", newJString(resourceGroupName))
  add(path_564813, "userName", newJString(userName))
  result = call_564812.call(path_564813, query_564814, nil, nil, nil)

var usersDelete* = Call_UsersDelete_564802(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
                                        validator: validate_UsersDelete_564803,
                                        base: "", url: url_UsersDelete_564804,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
