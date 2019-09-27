
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
  macServiceName = "labservices-ML"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProviderOperationsList_593659 = ref object of OpenApiRestCall_593437
proc url_ProviderOperationsList_593661(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsList_593660(path: JsonNode; query: JsonNode;
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
  var valid_593833 = query.getOrDefault("api-version")
  valid_593833 = validateParameter(valid_593833, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_593833 != nil:
    section.add "api-version", valid_593833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593856: Call_ProviderOperationsList_593659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Result of the request to list REST API operations
  ## 
  let valid = call_593856.validator(path, query, header, formData, body)
  let scheme = call_593856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593856.url(scheme.get, call_593856.host, call_593856.base,
                         call_593856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593856, url, valid)

proc call*(call_593927: Call_ProviderOperationsList_593659;
          apiVersion: string = "2018-10-15"): Recallable =
  ## providerOperationsList
  ## Result of the request to list REST API operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_593928 = newJObject()
  add(query_593928, "api-version", newJString(apiVersion))
  result = call_593927.call(nil, query_593928, nil, nil, nil)

var providerOperationsList* = Call_ProviderOperationsList_593659(
    name: "providerOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/operations",
    validator: validate_ProviderOperationsList_593660, base: "",
    url: url_ProviderOperationsList_593661, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetEnvironment_593968 = ref object of OpenApiRestCall_593437
proc url_GlobalUsersGetEnvironment_593970(protocol: Scheme; host: string;
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

proc validate_GlobalUsersGetEnvironment_593969(path: JsonNode; query: JsonNode;
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
  var valid_593986 = path.getOrDefault("userName")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "userName", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=environment)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_593987 = query.getOrDefault("$expand")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "$expand", valid_593987
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_593988 != nil:
    section.add "api-version", valid_593988
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

proc call*(call_593990: Call_GlobalUsersGetEnvironment_593968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the virtual machine details
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_GlobalUsersGetEnvironment_593968; userName: string;
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
  var path_593992 = newJObject()
  var query_593993 = newJObject()
  var body_593994 = newJObject()
  add(query_593993, "$expand", newJString(Expand))
  add(query_593993, "api-version", newJString(apiVersion))
  add(path_593992, "userName", newJString(userName))
  if environmentOperationsPayload != nil:
    body_593994 = environmentOperationsPayload
  result = call_593991.call(path_593992, query_593993, nil, nil, body_593994)

var globalUsersGetEnvironment* = Call_GlobalUsersGetEnvironment_593968(
    name: "globalUsersGetEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/getEnvironment",
    validator: validate_GlobalUsersGetEnvironment_593969, base: "",
    url: url_GlobalUsersGetEnvironment_593970, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetOperationBatchStatus_593995 = ref object of OpenApiRestCall_593437
proc url_GlobalUsersGetOperationBatchStatus_593997(protocol: Scheme; host: string;
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

proc validate_GlobalUsersGetOperationBatchStatus_593996(path: JsonNode;
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
  var valid_593998 = path.getOrDefault("userName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "userName", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_593999 != nil:
    section.add "api-version", valid_593999
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

proc call*(call_594001: Call_GlobalUsersGetOperationBatchStatus_593995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get batch operation status
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_GlobalUsersGetOperationBatchStatus_593995;
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
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  var body_594005 = newJObject()
  add(query_594004, "api-version", newJString(apiVersion))
  add(path_594003, "userName", newJString(userName))
  if operationBatchStatusPayload != nil:
    body_594005 = operationBatchStatusPayload
  result = call_594002.call(path_594003, query_594004, nil, nil, body_594005)

var globalUsersGetOperationBatchStatus* = Call_GlobalUsersGetOperationBatchStatus_593995(
    name: "globalUsersGetOperationBatchStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/getOperationBatchStatus",
    validator: validate_GlobalUsersGetOperationBatchStatus_593996, base: "",
    url: url_GlobalUsersGetOperationBatchStatus_593997, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetOperationStatus_594006 = ref object of OpenApiRestCall_593437
proc url_GlobalUsersGetOperationStatus_594008(protocol: Scheme; host: string;
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

proc validate_GlobalUsersGetOperationStatus_594007(path: JsonNode; query: JsonNode;
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
  var valid_594009 = path.getOrDefault("userName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "userName", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594010 != nil:
    section.add "api-version", valid_594010
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

proc call*(call_594012: Call_GlobalUsersGetOperationStatus_594006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of long running operation
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_GlobalUsersGetOperationStatus_594006;
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
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  var body_594016 = newJObject()
  if operationStatusPayload != nil:
    body_594016 = operationStatusPayload
  add(query_594015, "api-version", newJString(apiVersion))
  add(path_594014, "userName", newJString(userName))
  result = call_594013.call(path_594014, query_594015, nil, nil, body_594016)

var globalUsersGetOperationStatus* = Call_GlobalUsersGetOperationStatus_594006(
    name: "globalUsersGetOperationStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/getOperationStatus",
    validator: validate_GlobalUsersGetOperationStatus_594007, base: "",
    url: url_GlobalUsersGetOperationStatus_594008, schemes: {Scheme.Https})
type
  Call_GlobalUsersGetPersonalPreferences_594017 = ref object of OpenApiRestCall_593437
proc url_GlobalUsersGetPersonalPreferences_594019(protocol: Scheme; host: string;
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

proc validate_GlobalUsersGetPersonalPreferences_594018(path: JsonNode;
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
  var valid_594020 = path.getOrDefault("userName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "userName", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594021 != nil:
    section.add "api-version", valid_594021
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

proc call*(call_594023: Call_GlobalUsersGetPersonalPreferences_594017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get personal preferences for a user
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_GlobalUsersGetPersonalPreferences_594017;
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
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  var body_594027 = newJObject()
  add(query_594026, "api-version", newJString(apiVersion))
  if personalPreferencesOperationsPayload != nil:
    body_594027 = personalPreferencesOperationsPayload
  add(path_594025, "userName", newJString(userName))
  result = call_594024.call(path_594025, query_594026, nil, nil, body_594027)

var globalUsersGetPersonalPreferences* = Call_GlobalUsersGetPersonalPreferences_594017(
    name: "globalUsersGetPersonalPreferences", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/getPersonalPreferences",
    validator: validate_GlobalUsersGetPersonalPreferences_594018, base: "",
    url: url_GlobalUsersGetPersonalPreferences_594019, schemes: {Scheme.Https})
type
  Call_GlobalUsersListEnvironments_594028 = ref object of OpenApiRestCall_593437
proc url_GlobalUsersListEnvironments_594030(protocol: Scheme; host: string;
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

proc validate_GlobalUsersListEnvironments_594029(path: JsonNode; query: JsonNode;
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
  var valid_594031 = path.getOrDefault("userName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "userName", valid_594031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594032 = query.getOrDefault("api-version")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594032 != nil:
    section.add "api-version", valid_594032
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

proc call*(call_594034: Call_GlobalUsersListEnvironments_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Environments for the user
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_GlobalUsersListEnvironments_594028;
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
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  var body_594038 = newJObject()
  add(query_594037, "api-version", newJString(apiVersion))
  if listEnvironmentsPayload != nil:
    body_594038 = listEnvironmentsPayload
  add(path_594036, "userName", newJString(userName))
  result = call_594035.call(path_594036, query_594037, nil, nil, body_594038)

var globalUsersListEnvironments* = Call_GlobalUsersListEnvironments_594028(
    name: "globalUsersListEnvironments", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/listEnvironments",
    validator: validate_GlobalUsersListEnvironments_594029, base: "",
    url: url_GlobalUsersListEnvironments_594030, schemes: {Scheme.Https})
type
  Call_GlobalUsersListLabs_594039 = ref object of OpenApiRestCall_593437
proc url_GlobalUsersListLabs_594041(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalUsersListLabs_594040(path: JsonNode; query: JsonNode;
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
  var valid_594042 = path.getOrDefault("userName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "userName", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_GlobalUsersListLabs_594039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs for the user.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_GlobalUsersListLabs_594039; userName: string;
          apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersListLabs
  ## List labs for the user.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(query_594047, "api-version", newJString(apiVersion))
  add(path_594046, "userName", newJString(userName))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var globalUsersListLabs* = Call_GlobalUsersListLabs_594039(
    name: "globalUsersListLabs", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/listLabs",
    validator: validate_GlobalUsersListLabs_594040, base: "",
    url: url_GlobalUsersListLabs_594041, schemes: {Scheme.Https})
type
  Call_GlobalUsersRegister_594048 = ref object of OpenApiRestCall_593437
proc url_GlobalUsersRegister_594050(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalUsersRegister_594049(path: JsonNode; query: JsonNode;
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
  var valid_594051 = path.getOrDefault("userName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "userName", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594052 = query.getOrDefault("api-version")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594052 != nil:
    section.add "api-version", valid_594052
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

proc call*(call_594054: Call_GlobalUsersRegister_594048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register a user to a managed lab
  ## 
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_GlobalUsersRegister_594048; registerPayload: JsonNode;
          userName: string; apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersRegister
  ## Register a user to a managed lab
  ##   registerPayload: JObject (required)
  ##                  : Represents payload for Register action.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  var body_594058 = newJObject()
  if registerPayload != nil:
    body_594058 = registerPayload
  add(query_594057, "api-version", newJString(apiVersion))
  add(path_594056, "userName", newJString(userName))
  result = call_594055.call(path_594056, query_594057, nil, nil, body_594058)

var globalUsersRegister* = Call_GlobalUsersRegister_594048(
    name: "globalUsersRegister", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/register",
    validator: validate_GlobalUsersRegister_594049, base: "",
    url: url_GlobalUsersRegister_594050, schemes: {Scheme.Https})
type
  Call_GlobalUsersResetPassword_594059 = ref object of OpenApiRestCall_593437
proc url_GlobalUsersResetPassword_594061(protocol: Scheme; host: string;
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

proc validate_GlobalUsersResetPassword_594060(path: JsonNode; query: JsonNode;
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
  var valid_594062 = path.getOrDefault("userName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "userName", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594063 != nil:
    section.add "api-version", valid_594063
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

proc call*(call_594065: Call_GlobalUsersResetPassword_594059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the user password on an environment This operation can take a while to complete
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_GlobalUsersResetPassword_594059; userName: string;
          resetPasswordPayload: JsonNode; apiVersion: string = "2018-10-15"): Recallable =
  ## globalUsersResetPassword
  ## Resets the user password on an environment This operation can take a while to complete
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   userName: string (required)
  ##           : The name of the user.
  ##   resetPasswordPayload: JObject (required)
  ##                       : Represents the payload for resetting passwords.
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  var body_594069 = newJObject()
  add(query_594068, "api-version", newJString(apiVersion))
  add(path_594067, "userName", newJString(userName))
  if resetPasswordPayload != nil:
    body_594069 = resetPasswordPayload
  result = call_594066.call(path_594067, query_594068, nil, nil, body_594069)

var globalUsersResetPassword* = Call_GlobalUsersResetPassword_594059(
    name: "globalUsersResetPassword", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/resetPassword",
    validator: validate_GlobalUsersResetPassword_594060, base: "",
    url: url_GlobalUsersResetPassword_594061, schemes: {Scheme.Https})
type
  Call_GlobalUsersStartEnvironment_594070 = ref object of OpenApiRestCall_593437
proc url_GlobalUsersStartEnvironment_594072(protocol: Scheme; host: string;
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

proc validate_GlobalUsersStartEnvironment_594071(path: JsonNode; query: JsonNode;
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
  var valid_594073 = path.getOrDefault("userName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "userName", valid_594073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594074 = query.getOrDefault("api-version")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594074 != nil:
    section.add "api-version", valid_594074
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

proc call*(call_594076: Call_GlobalUsersStartEnvironment_594070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_GlobalUsersStartEnvironment_594070; userName: string;
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
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  var body_594080 = newJObject()
  add(query_594079, "api-version", newJString(apiVersion))
  add(path_594078, "userName", newJString(userName))
  if environmentOperationsPayload != nil:
    body_594080 = environmentOperationsPayload
  result = call_594077.call(path_594078, query_594079, nil, nil, body_594080)

var globalUsersStartEnvironment* = Call_GlobalUsersStartEnvironment_594070(
    name: "globalUsersStartEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.LabServices/users/{userName}/startEnvironment",
    validator: validate_GlobalUsersStartEnvironment_594071, base: "",
    url: url_GlobalUsersStartEnvironment_594072, schemes: {Scheme.Https})
type
  Call_GlobalUsersStopEnvironment_594081 = ref object of OpenApiRestCall_593437
proc url_GlobalUsersStopEnvironment_594083(protocol: Scheme; host: string;
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

proc validate_GlobalUsersStopEnvironment_594082(path: JsonNode; query: JsonNode;
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
  var valid_594084 = path.getOrDefault("userName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "userName", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594085 != nil:
    section.add "api-version", valid_594085
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

proc call*(call_594087: Call_GlobalUsersStopEnvironment_594081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_GlobalUsersStopEnvironment_594081; userName: string;
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
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  var body_594091 = newJObject()
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "userName", newJString(userName))
  if environmentOperationsPayload != nil:
    body_594091 = environmentOperationsPayload
  result = call_594088.call(path_594089, query_594090, nil, nil, body_594091)

var globalUsersStopEnvironment* = Call_GlobalUsersStopEnvironment_594081(
    name: "globalUsersStopEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.LabServices/users/{userName}/stopEnvironment",
    validator: validate_GlobalUsersStopEnvironment_594082, base: "",
    url: url_GlobalUsersStopEnvironment_594083, schemes: {Scheme.Https})
type
  Call_LabAccountsListBySubscription_594092 = ref object of OpenApiRestCall_593437
proc url_LabAccountsListBySubscription_594094(protocol: Scheme; host: string;
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

proc validate_LabAccountsListBySubscription_594093(path: JsonNode; query: JsonNode;
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
  var valid_594095 = path.getOrDefault("subscriptionId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "subscriptionId", valid_594095
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
  var valid_594096 = query.getOrDefault("$orderby")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "$orderby", valid_594096
  var valid_594097 = query.getOrDefault("$expand")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "$expand", valid_594097
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594098 = query.getOrDefault("api-version")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594098 != nil:
    section.add "api-version", valid_594098
  var valid_594099 = query.getOrDefault("$top")
  valid_594099 = validateParameter(valid_594099, JInt, required = false, default = nil)
  if valid_594099 != nil:
    section.add "$top", valid_594099
  var valid_594100 = query.getOrDefault("$filter")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "$filter", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_LabAccountsListBySubscription_594092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List lab accounts in a subscription.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_LabAccountsListBySubscription_594092;
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
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(query_594104, "$orderby", newJString(Orderby))
  add(query_594104, "$expand", newJString(Expand))
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  add(query_594104, "$top", newJInt(Top))
  add(query_594104, "$filter", newJString(Filter))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var labAccountsListBySubscription* = Call_LabAccountsListBySubscription_594092(
    name: "labAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.LabServices/labaccounts",
    validator: validate_LabAccountsListBySubscription_594093, base: "",
    url: url_LabAccountsListBySubscription_594094, schemes: {Scheme.Https})
type
  Call_OperationsGet_594105 = ref object of OpenApiRestCall_593437
proc url_OperationsGet_594107(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsGet_594106(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594108 = path.getOrDefault("subscriptionId")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "subscriptionId", valid_594108
  var valid_594109 = path.getOrDefault("locationName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "locationName", valid_594109
  var valid_594110 = path.getOrDefault("operationName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "operationName", valid_594110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594111 = query.getOrDefault("api-version")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594111 != nil:
    section.add "api-version", valid_594111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594112: Call_OperationsGet_594105; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get operation
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_OperationsGet_594105; subscriptionId: string;
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
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  add(query_594115, "api-version", newJString(apiVersion))
  add(path_594114, "subscriptionId", newJString(subscriptionId))
  add(path_594114, "locationName", newJString(locationName))
  add(path_594114, "operationName", newJString(operationName))
  result = call_594113.call(path_594114, query_594115, nil, nil, nil)

var operationsGet* = Call_OperationsGet_594105(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.LabServices/locations/{locationName}/operations/{operationName}",
    validator: validate_OperationsGet_594106, base: "", url: url_OperationsGet_594107,
    schemes: {Scheme.Https})
type
  Call_LabAccountsListByResourceGroup_594116 = ref object of OpenApiRestCall_593437
proc url_LabAccountsListByResourceGroup_594118(protocol: Scheme; host: string;
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

proc validate_LabAccountsListByResourceGroup_594117(path: JsonNode;
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
  var valid_594119 = path.getOrDefault("resourceGroupName")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "resourceGroupName", valid_594119
  var valid_594120 = path.getOrDefault("subscriptionId")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "subscriptionId", valid_594120
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
  var valid_594121 = query.getOrDefault("$orderby")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "$orderby", valid_594121
  var valid_594122 = query.getOrDefault("$expand")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "$expand", valid_594122
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594123 = query.getOrDefault("api-version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594123 != nil:
    section.add "api-version", valid_594123
  var valid_594124 = query.getOrDefault("$top")
  valid_594124 = validateParameter(valid_594124, JInt, required = false, default = nil)
  if valid_594124 != nil:
    section.add "$top", valid_594124
  var valid_594125 = query.getOrDefault("$filter")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "$filter", valid_594125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594126: Call_LabAccountsListByResourceGroup_594116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List lab accounts in a resource group.
  ## 
  let valid = call_594126.validator(path, query, header, formData, body)
  let scheme = call_594126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594126.url(scheme.get, call_594126.host, call_594126.base,
                         call_594126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594126, url, valid)

proc call*(call_594127: Call_LabAccountsListByResourceGroup_594116;
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
  var path_594128 = newJObject()
  var query_594129 = newJObject()
  add(query_594129, "$orderby", newJString(Orderby))
  add(path_594128, "resourceGroupName", newJString(resourceGroupName))
  add(query_594129, "$expand", newJString(Expand))
  add(query_594129, "api-version", newJString(apiVersion))
  add(path_594128, "subscriptionId", newJString(subscriptionId))
  add(query_594129, "$top", newJInt(Top))
  add(query_594129, "$filter", newJString(Filter))
  result = call_594127.call(path_594128, query_594129, nil, nil, nil)

var labAccountsListByResourceGroup* = Call_LabAccountsListByResourceGroup_594116(
    name: "labAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts",
    validator: validate_LabAccountsListByResourceGroup_594117, base: "",
    url: url_LabAccountsListByResourceGroup_594118, schemes: {Scheme.Https})
type
  Call_LabAccountsCreateOrUpdate_594142 = ref object of OpenApiRestCall_593437
proc url_LabAccountsCreateOrUpdate_594144(protocol: Scheme; host: string;
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

proc validate_LabAccountsCreateOrUpdate_594143(path: JsonNode; query: JsonNode;
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
  var valid_594145 = path.getOrDefault("labAccountName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "labAccountName", valid_594145
  var valid_594146 = path.getOrDefault("resourceGroupName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "resourceGroupName", valid_594146
  var valid_594147 = path.getOrDefault("subscriptionId")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "subscriptionId", valid_594147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594148 = query.getOrDefault("api-version")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594148 != nil:
    section.add "api-version", valid_594148
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

proc call*(call_594150: Call_LabAccountsCreateOrUpdate_594142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Lab Account.
  ## 
  let valid = call_594150.validator(path, query, header, formData, body)
  let scheme = call_594150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594150.url(scheme.get, call_594150.host, call_594150.base,
                         call_594150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594150, url, valid)

proc call*(call_594151: Call_LabAccountsCreateOrUpdate_594142;
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
  var path_594152 = newJObject()
  var query_594153 = newJObject()
  var body_594154 = newJObject()
  add(path_594152, "labAccountName", newJString(labAccountName))
  add(path_594152, "resourceGroupName", newJString(resourceGroupName))
  if labAccount != nil:
    body_594154 = labAccount
  add(query_594153, "api-version", newJString(apiVersion))
  add(path_594152, "subscriptionId", newJString(subscriptionId))
  result = call_594151.call(path_594152, query_594153, nil, nil, body_594154)

var labAccountsCreateOrUpdate* = Call_LabAccountsCreateOrUpdate_594142(
    name: "labAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsCreateOrUpdate_594143, base: "",
    url: url_LabAccountsCreateOrUpdate_594144, schemes: {Scheme.Https})
type
  Call_LabAccountsGet_594130 = ref object of OpenApiRestCall_593437
proc url_LabAccountsGet_594132(protocol: Scheme; host: string; base: string;
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

proc validate_LabAccountsGet_594131(path: JsonNode; query: JsonNode;
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
  var valid_594133 = path.getOrDefault("labAccountName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "labAccountName", valid_594133
  var valid_594134 = path.getOrDefault("resourceGroupName")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "resourceGroupName", valid_594134
  var valid_594135 = path.getOrDefault("subscriptionId")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "subscriptionId", valid_594135
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=sizeConfiguration)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594136 = query.getOrDefault("$expand")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "$expand", valid_594136
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594137 = query.getOrDefault("api-version")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594137 != nil:
    section.add "api-version", valid_594137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594138: Call_LabAccountsGet_594130; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab account
  ## 
  let valid = call_594138.validator(path, query, header, formData, body)
  let scheme = call_594138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594138.url(scheme.get, call_594138.host, call_594138.base,
                         call_594138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594138, url, valid)

proc call*(call_594139: Call_LabAccountsGet_594130; labAccountName: string;
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
  var path_594140 = newJObject()
  var query_594141 = newJObject()
  add(path_594140, "labAccountName", newJString(labAccountName))
  add(path_594140, "resourceGroupName", newJString(resourceGroupName))
  add(query_594141, "$expand", newJString(Expand))
  add(query_594141, "api-version", newJString(apiVersion))
  add(path_594140, "subscriptionId", newJString(subscriptionId))
  result = call_594139.call(path_594140, query_594141, nil, nil, nil)

var labAccountsGet* = Call_LabAccountsGet_594130(name: "labAccountsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsGet_594131, base: "", url: url_LabAccountsGet_594132,
    schemes: {Scheme.Https})
type
  Call_LabAccountsUpdate_594166 = ref object of OpenApiRestCall_593437
proc url_LabAccountsUpdate_594168(protocol: Scheme; host: string; base: string;
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

proc validate_LabAccountsUpdate_594167(path: JsonNode; query: JsonNode;
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
  var valid_594169 = path.getOrDefault("labAccountName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "labAccountName", valid_594169
  var valid_594170 = path.getOrDefault("resourceGroupName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "resourceGroupName", valid_594170
  var valid_594171 = path.getOrDefault("subscriptionId")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "subscriptionId", valid_594171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594172 = query.getOrDefault("api-version")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594172 != nil:
    section.add "api-version", valid_594172
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

proc call*(call_594174: Call_LabAccountsUpdate_594166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of lab accounts.
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_LabAccountsUpdate_594166; labAccountName: string;
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
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  var body_594178 = newJObject()
  add(path_594176, "labAccountName", newJString(labAccountName))
  add(path_594176, "resourceGroupName", newJString(resourceGroupName))
  if labAccount != nil:
    body_594178 = labAccount
  add(query_594177, "api-version", newJString(apiVersion))
  add(path_594176, "subscriptionId", newJString(subscriptionId))
  result = call_594175.call(path_594176, query_594177, nil, nil, body_594178)

var labAccountsUpdate* = Call_LabAccountsUpdate_594166(name: "labAccountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsUpdate_594167, base: "",
    url: url_LabAccountsUpdate_594168, schemes: {Scheme.Https})
type
  Call_LabAccountsDelete_594155 = ref object of OpenApiRestCall_593437
proc url_LabAccountsDelete_594157(protocol: Scheme; host: string; base: string;
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

proc validate_LabAccountsDelete_594156(path: JsonNode; query: JsonNode;
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
  var valid_594158 = path.getOrDefault("labAccountName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "labAccountName", valid_594158
  var valid_594159 = path.getOrDefault("resourceGroupName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "resourceGroupName", valid_594159
  var valid_594160 = path.getOrDefault("subscriptionId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "subscriptionId", valid_594160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594161 = query.getOrDefault("api-version")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594161 != nil:
    section.add "api-version", valid_594161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594162: Call_LabAccountsDelete_594155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab account. This operation can take a while to complete
  ## 
  let valid = call_594162.validator(path, query, header, formData, body)
  let scheme = call_594162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594162.url(scheme.get, call_594162.host, call_594162.base,
                         call_594162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594162, url, valid)

proc call*(call_594163: Call_LabAccountsDelete_594155; labAccountName: string;
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
  var path_594164 = newJObject()
  var query_594165 = newJObject()
  add(path_594164, "labAccountName", newJString(labAccountName))
  add(path_594164, "resourceGroupName", newJString(resourceGroupName))
  add(query_594165, "api-version", newJString(apiVersion))
  add(path_594164, "subscriptionId", newJString(subscriptionId))
  result = call_594163.call(path_594164, query_594165, nil, nil, nil)

var labAccountsDelete* = Call_LabAccountsDelete_594155(name: "labAccountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}",
    validator: validate_LabAccountsDelete_594156, base: "",
    url: url_LabAccountsDelete_594157, schemes: {Scheme.Https})
type
  Call_LabAccountsCreateLab_594179 = ref object of OpenApiRestCall_593437
proc url_LabAccountsCreateLab_594181(protocol: Scheme; host: string; base: string;
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

proc validate_LabAccountsCreateLab_594180(path: JsonNode; query: JsonNode;
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
  var valid_594182 = path.getOrDefault("labAccountName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "labAccountName", valid_594182
  var valid_594183 = path.getOrDefault("resourceGroupName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "resourceGroupName", valid_594183
  var valid_594184 = path.getOrDefault("subscriptionId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "subscriptionId", valid_594184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594185 = query.getOrDefault("api-version")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594185 != nil:
    section.add "api-version", valid_594185
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

proc call*(call_594187: Call_LabAccountsCreateLab_594179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a lab in a lab account.
  ## 
  let valid = call_594187.validator(path, query, header, formData, body)
  let scheme = call_594187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594187.url(scheme.get, call_594187.host, call_594187.base,
                         call_594187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594187, url, valid)

proc call*(call_594188: Call_LabAccountsCreateLab_594179; labAccountName: string;
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
  var path_594189 = newJObject()
  var query_594190 = newJObject()
  var body_594191 = newJObject()
  add(path_594189, "labAccountName", newJString(labAccountName))
  add(path_594189, "resourceGroupName", newJString(resourceGroupName))
  add(query_594190, "api-version", newJString(apiVersion))
  add(path_594189, "subscriptionId", newJString(subscriptionId))
  if createLabProperties != nil:
    body_594191 = createLabProperties
  result = call_594188.call(path_594189, query_594190, nil, nil, body_594191)

var labAccountsCreateLab* = Call_LabAccountsCreateLab_594179(
    name: "labAccountsCreateLab", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/createLab",
    validator: validate_LabAccountsCreateLab_594180, base: "",
    url: url_LabAccountsCreateLab_594181, schemes: {Scheme.Https})
type
  Call_GalleryImagesList_594192 = ref object of OpenApiRestCall_593437
proc url_GalleryImagesList_594194(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesList_594193(path: JsonNode; query: JsonNode;
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
  var valid_594195 = path.getOrDefault("labAccountName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "labAccountName", valid_594195
  var valid_594196 = path.getOrDefault("resourceGroupName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "resourceGroupName", valid_594196
  var valid_594197 = path.getOrDefault("subscriptionId")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "subscriptionId", valid_594197
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
  var valid_594198 = query.getOrDefault("$orderby")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "$orderby", valid_594198
  var valid_594199 = query.getOrDefault("$expand")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "$expand", valid_594199
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594200 = query.getOrDefault("api-version")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594200 != nil:
    section.add "api-version", valid_594200
  var valid_594201 = query.getOrDefault("$top")
  valid_594201 = validateParameter(valid_594201, JInt, required = false, default = nil)
  if valid_594201 != nil:
    section.add "$top", valid_594201
  var valid_594202 = query.getOrDefault("$filter")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "$filter", valid_594202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594203: Call_GalleryImagesList_594192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images in a given lab account.
  ## 
  let valid = call_594203.validator(path, query, header, formData, body)
  let scheme = call_594203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594203.url(scheme.get, call_594203.host, call_594203.base,
                         call_594203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594203, url, valid)

proc call*(call_594204: Call_GalleryImagesList_594192; labAccountName: string;
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
  var path_594205 = newJObject()
  var query_594206 = newJObject()
  add(path_594205, "labAccountName", newJString(labAccountName))
  add(path_594205, "resourceGroupName", newJString(resourceGroupName))
  add(query_594206, "$orderby", newJString(Orderby))
  add(query_594206, "$expand", newJString(Expand))
  add(query_594206, "api-version", newJString(apiVersion))
  add(path_594205, "subscriptionId", newJString(subscriptionId))
  add(query_594206, "$top", newJInt(Top))
  add(query_594206, "$filter", newJString(Filter))
  result = call_594204.call(path_594205, query_594206, nil, nil, nil)

var galleryImagesList* = Call_GalleryImagesList_594192(name: "galleryImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages",
    validator: validate_GalleryImagesList_594193, base: "",
    url: url_GalleryImagesList_594194, schemes: {Scheme.Https})
type
  Call_GalleryImagesCreateOrUpdate_594220 = ref object of OpenApiRestCall_593437
proc url_GalleryImagesCreateOrUpdate_594222(protocol: Scheme; host: string;
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

proc validate_GalleryImagesCreateOrUpdate_594221(path: JsonNode; query: JsonNode;
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
  var valid_594223 = path.getOrDefault("labAccountName")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "labAccountName", valid_594223
  var valid_594224 = path.getOrDefault("resourceGroupName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "resourceGroupName", valid_594224
  var valid_594225 = path.getOrDefault("subscriptionId")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "subscriptionId", valid_594225
  var valid_594226 = path.getOrDefault("galleryImageName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "galleryImageName", valid_594226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594227 = query.getOrDefault("api-version")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594227 != nil:
    section.add "api-version", valid_594227
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

proc call*(call_594229: Call_GalleryImagesCreateOrUpdate_594220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Gallery Image.
  ## 
  let valid = call_594229.validator(path, query, header, formData, body)
  let scheme = call_594229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594229.url(scheme.get, call_594229.host, call_594229.base,
                         call_594229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594229, url, valid)

proc call*(call_594230: Call_GalleryImagesCreateOrUpdate_594220;
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
  var path_594231 = newJObject()
  var query_594232 = newJObject()
  var body_594233 = newJObject()
  add(path_594231, "labAccountName", newJString(labAccountName))
  add(path_594231, "resourceGroupName", newJString(resourceGroupName))
  add(query_594232, "api-version", newJString(apiVersion))
  add(path_594231, "subscriptionId", newJString(subscriptionId))
  add(path_594231, "galleryImageName", newJString(galleryImageName))
  if galleryImage != nil:
    body_594233 = galleryImage
  result = call_594230.call(path_594231, query_594232, nil, nil, body_594233)

var galleryImagesCreateOrUpdate* = Call_GalleryImagesCreateOrUpdate_594220(
    name: "galleryImagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesCreateOrUpdate_594221, base: "",
    url: url_GalleryImagesCreateOrUpdate_594222, schemes: {Scheme.Https})
type
  Call_GalleryImagesGet_594207 = ref object of OpenApiRestCall_593437
proc url_GalleryImagesGet_594209(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesGet_594208(path: JsonNode; query: JsonNode;
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
  var valid_594210 = path.getOrDefault("labAccountName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "labAccountName", valid_594210
  var valid_594211 = path.getOrDefault("resourceGroupName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "resourceGroupName", valid_594211
  var valid_594212 = path.getOrDefault("subscriptionId")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "subscriptionId", valid_594212
  var valid_594213 = path.getOrDefault("galleryImageName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "galleryImageName", valid_594213
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=author)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594214 = query.getOrDefault("$expand")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "$expand", valid_594214
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594215 = query.getOrDefault("api-version")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594215 != nil:
    section.add "api-version", valid_594215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594216: Call_GalleryImagesGet_594207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get gallery image
  ## 
  let valid = call_594216.validator(path, query, header, formData, body)
  let scheme = call_594216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594216.url(scheme.get, call_594216.host, call_594216.base,
                         call_594216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594216, url, valid)

proc call*(call_594217: Call_GalleryImagesGet_594207; labAccountName: string;
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
  var path_594218 = newJObject()
  var query_594219 = newJObject()
  add(path_594218, "labAccountName", newJString(labAccountName))
  add(path_594218, "resourceGroupName", newJString(resourceGroupName))
  add(query_594219, "$expand", newJString(Expand))
  add(query_594219, "api-version", newJString(apiVersion))
  add(path_594218, "subscriptionId", newJString(subscriptionId))
  add(path_594218, "galleryImageName", newJString(galleryImageName))
  result = call_594217.call(path_594218, query_594219, nil, nil, nil)

var galleryImagesGet* = Call_GalleryImagesGet_594207(name: "galleryImagesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesGet_594208, base: "",
    url: url_GalleryImagesGet_594209, schemes: {Scheme.Https})
type
  Call_GalleryImagesUpdate_594246 = ref object of OpenApiRestCall_593437
proc url_GalleryImagesUpdate_594248(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesUpdate_594247(path: JsonNode; query: JsonNode;
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
  var valid_594249 = path.getOrDefault("labAccountName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "labAccountName", valid_594249
  var valid_594250 = path.getOrDefault("resourceGroupName")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "resourceGroupName", valid_594250
  var valid_594251 = path.getOrDefault("subscriptionId")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "subscriptionId", valid_594251
  var valid_594252 = path.getOrDefault("galleryImageName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "galleryImageName", valid_594252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594253 = query.getOrDefault("api-version")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594253 != nil:
    section.add "api-version", valid_594253
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

proc call*(call_594255: Call_GalleryImagesUpdate_594246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of gallery images.
  ## 
  let valid = call_594255.validator(path, query, header, formData, body)
  let scheme = call_594255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594255.url(scheme.get, call_594255.host, call_594255.base,
                         call_594255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594255, url, valid)

proc call*(call_594256: Call_GalleryImagesUpdate_594246; labAccountName: string;
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
  var path_594257 = newJObject()
  var query_594258 = newJObject()
  var body_594259 = newJObject()
  add(path_594257, "labAccountName", newJString(labAccountName))
  add(path_594257, "resourceGroupName", newJString(resourceGroupName))
  add(query_594258, "api-version", newJString(apiVersion))
  add(path_594257, "subscriptionId", newJString(subscriptionId))
  add(path_594257, "galleryImageName", newJString(galleryImageName))
  if galleryImage != nil:
    body_594259 = galleryImage
  result = call_594256.call(path_594257, query_594258, nil, nil, body_594259)

var galleryImagesUpdate* = Call_GalleryImagesUpdate_594246(
    name: "galleryImagesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesUpdate_594247, base: "",
    url: url_GalleryImagesUpdate_594248, schemes: {Scheme.Https})
type
  Call_GalleryImagesDelete_594234 = ref object of OpenApiRestCall_593437
proc url_GalleryImagesDelete_594236(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesDelete_594235(path: JsonNode; query: JsonNode;
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
  var valid_594237 = path.getOrDefault("labAccountName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "labAccountName", valid_594237
  var valid_594238 = path.getOrDefault("resourceGroupName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "resourceGroupName", valid_594238
  var valid_594239 = path.getOrDefault("subscriptionId")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "subscriptionId", valid_594239
  var valid_594240 = path.getOrDefault("galleryImageName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "galleryImageName", valid_594240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594241 = query.getOrDefault("api-version")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594241 != nil:
    section.add "api-version", valid_594241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594242: Call_GalleryImagesDelete_594234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete gallery image.
  ## 
  let valid = call_594242.validator(path, query, header, formData, body)
  let scheme = call_594242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594242.url(scheme.get, call_594242.host, call_594242.base,
                         call_594242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594242, url, valid)

proc call*(call_594243: Call_GalleryImagesDelete_594234; labAccountName: string;
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
  var path_594244 = newJObject()
  var query_594245 = newJObject()
  add(path_594244, "labAccountName", newJString(labAccountName))
  add(path_594244, "resourceGroupName", newJString(resourceGroupName))
  add(query_594245, "api-version", newJString(apiVersion))
  add(path_594244, "subscriptionId", newJString(subscriptionId))
  add(path_594244, "galleryImageName", newJString(galleryImageName))
  result = call_594243.call(path_594244, query_594245, nil, nil, nil)

var galleryImagesDelete* = Call_GalleryImagesDelete_594234(
    name: "galleryImagesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/galleryimages/{galleryImageName}",
    validator: validate_GalleryImagesDelete_594235, base: "",
    url: url_GalleryImagesDelete_594236, schemes: {Scheme.Https})
type
  Call_LabAccountsGetRegionalAvailability_594260 = ref object of OpenApiRestCall_593437
proc url_LabAccountsGetRegionalAvailability_594262(protocol: Scheme; host: string;
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

proc validate_LabAccountsGetRegionalAvailability_594261(path: JsonNode;
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
  var valid_594263 = path.getOrDefault("labAccountName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "labAccountName", valid_594263
  var valid_594264 = path.getOrDefault("resourceGroupName")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "resourceGroupName", valid_594264
  var valid_594265 = path.getOrDefault("subscriptionId")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "subscriptionId", valid_594265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594266 = query.getOrDefault("api-version")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594266 != nil:
    section.add "api-version", valid_594266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594267: Call_LabAccountsGetRegionalAvailability_594260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get regional availability information for each size category configured under a lab account
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_LabAccountsGetRegionalAvailability_594260;
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
  var path_594269 = newJObject()
  var query_594270 = newJObject()
  add(path_594269, "labAccountName", newJString(labAccountName))
  add(path_594269, "resourceGroupName", newJString(resourceGroupName))
  add(query_594270, "api-version", newJString(apiVersion))
  add(path_594269, "subscriptionId", newJString(subscriptionId))
  result = call_594268.call(path_594269, query_594270, nil, nil, nil)

var labAccountsGetRegionalAvailability* = Call_LabAccountsGetRegionalAvailability_594260(
    name: "labAccountsGetRegionalAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/getRegionalAvailability",
    validator: validate_LabAccountsGetRegionalAvailability_594261, base: "",
    url: url_LabAccountsGetRegionalAvailability_594262, schemes: {Scheme.Https})
type
  Call_LabsList_594271 = ref object of OpenApiRestCall_593437
proc url_LabsList_594273(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsList_594272(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594274 = path.getOrDefault("labAccountName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "labAccountName", valid_594274
  var valid_594275 = path.getOrDefault("resourceGroupName")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "resourceGroupName", valid_594275
  var valid_594276 = path.getOrDefault("subscriptionId")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "subscriptionId", valid_594276
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
  var valid_594277 = query.getOrDefault("$orderby")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "$orderby", valid_594277
  var valid_594278 = query.getOrDefault("$expand")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "$expand", valid_594278
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594279 = query.getOrDefault("api-version")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594279 != nil:
    section.add "api-version", valid_594279
  var valid_594280 = query.getOrDefault("$top")
  valid_594280 = validateParameter(valid_594280, JInt, required = false, default = nil)
  if valid_594280 != nil:
    section.add "$top", valid_594280
  var valid_594281 = query.getOrDefault("$filter")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "$filter", valid_594281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594282: Call_LabsList_594271; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a given lab account.
  ## 
  let valid = call_594282.validator(path, query, header, formData, body)
  let scheme = call_594282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594282.url(scheme.get, call_594282.host, call_594282.base,
                         call_594282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594282, url, valid)

proc call*(call_594283: Call_LabsList_594271; labAccountName: string;
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
  var path_594284 = newJObject()
  var query_594285 = newJObject()
  add(path_594284, "labAccountName", newJString(labAccountName))
  add(path_594284, "resourceGroupName", newJString(resourceGroupName))
  add(query_594285, "$orderby", newJString(Orderby))
  add(query_594285, "$expand", newJString(Expand))
  add(query_594285, "api-version", newJString(apiVersion))
  add(path_594284, "subscriptionId", newJString(subscriptionId))
  add(query_594285, "$top", newJInt(Top))
  add(query_594285, "$filter", newJString(Filter))
  result = call_594283.call(path_594284, query_594285, nil, nil, nil)

var labsList* = Call_LabsList_594271(name: "labsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs",
                                  validator: validate_LabsList_594272, base: "",
                                  url: url_LabsList_594273,
                                  schemes: {Scheme.Https})
type
  Call_LabsCreateOrUpdate_594299 = ref object of OpenApiRestCall_593437
proc url_LabsCreateOrUpdate_594301(protocol: Scheme; host: string; base: string;
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

proc validate_LabsCreateOrUpdate_594300(path: JsonNode; query: JsonNode;
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
  var valid_594302 = path.getOrDefault("labAccountName")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "labAccountName", valid_594302
  var valid_594303 = path.getOrDefault("resourceGroupName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "resourceGroupName", valid_594303
  var valid_594304 = path.getOrDefault("subscriptionId")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "subscriptionId", valid_594304
  var valid_594305 = path.getOrDefault("labName")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "labName", valid_594305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594306 = query.getOrDefault("api-version")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594306 != nil:
    section.add "api-version", valid_594306
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

proc call*(call_594308: Call_LabsCreateOrUpdate_594299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Lab.
  ## 
  let valid = call_594308.validator(path, query, header, formData, body)
  let scheme = call_594308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594308.url(scheme.get, call_594308.host, call_594308.base,
                         call_594308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594308, url, valid)

proc call*(call_594309: Call_LabsCreateOrUpdate_594299; labAccountName: string;
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
  var path_594310 = newJObject()
  var query_594311 = newJObject()
  var body_594312 = newJObject()
  add(path_594310, "labAccountName", newJString(labAccountName))
  add(path_594310, "resourceGroupName", newJString(resourceGroupName))
  add(query_594311, "api-version", newJString(apiVersion))
  add(path_594310, "subscriptionId", newJString(subscriptionId))
  add(path_594310, "labName", newJString(labName))
  if lab != nil:
    body_594312 = lab
  result = call_594309.call(path_594310, query_594311, nil, nil, body_594312)

var labsCreateOrUpdate* = Call_LabsCreateOrUpdate_594299(
    name: "labsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
    validator: validate_LabsCreateOrUpdate_594300, base: "",
    url: url_LabsCreateOrUpdate_594301, schemes: {Scheme.Https})
type
  Call_LabsGet_594286 = ref object of OpenApiRestCall_593437
proc url_LabsGet_594288(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsGet_594287(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594289 = path.getOrDefault("labAccountName")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "labAccountName", valid_594289
  var valid_594290 = path.getOrDefault("resourceGroupName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "resourceGroupName", valid_594290
  var valid_594291 = path.getOrDefault("subscriptionId")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "subscriptionId", valid_594291
  var valid_594292 = path.getOrDefault("labName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "labName", valid_594292
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=maxUsersInLab)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594293 = query.getOrDefault("$expand")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "$expand", valid_594293
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594294 = query.getOrDefault("api-version")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594294 != nil:
    section.add "api-version", valid_594294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594295: Call_LabsGet_594286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab
  ## 
  let valid = call_594295.validator(path, query, header, formData, body)
  let scheme = call_594295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594295.url(scheme.get, call_594295.host, call_594295.base,
                         call_594295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594295, url, valid)

proc call*(call_594296: Call_LabsGet_594286; labAccountName: string;
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
  var path_594297 = newJObject()
  var query_594298 = newJObject()
  add(path_594297, "labAccountName", newJString(labAccountName))
  add(path_594297, "resourceGroupName", newJString(resourceGroupName))
  add(query_594298, "$expand", newJString(Expand))
  add(query_594298, "api-version", newJString(apiVersion))
  add(path_594297, "subscriptionId", newJString(subscriptionId))
  add(path_594297, "labName", newJString(labName))
  result = call_594296.call(path_594297, query_594298, nil, nil, nil)

var labsGet* = Call_LabsGet_594286(name: "labsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
                                validator: validate_LabsGet_594287, base: "",
                                url: url_LabsGet_594288, schemes: {Scheme.Https})
type
  Call_LabsUpdate_594325 = ref object of OpenApiRestCall_593437
proc url_LabsUpdate_594327(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsUpdate_594326(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594328 = path.getOrDefault("labAccountName")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "labAccountName", valid_594328
  var valid_594329 = path.getOrDefault("resourceGroupName")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "resourceGroupName", valid_594329
  var valid_594330 = path.getOrDefault("subscriptionId")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "subscriptionId", valid_594330
  var valid_594331 = path.getOrDefault("labName")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "labName", valid_594331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594332 = query.getOrDefault("api-version")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594332 != nil:
    section.add "api-version", valid_594332
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

proc call*(call_594334: Call_LabsUpdate_594325; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of labs.
  ## 
  let valid = call_594334.validator(path, query, header, formData, body)
  let scheme = call_594334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594334.url(scheme.get, call_594334.host, call_594334.base,
                         call_594334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594334, url, valid)

proc call*(call_594335: Call_LabsUpdate_594325; labAccountName: string;
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
  var path_594336 = newJObject()
  var query_594337 = newJObject()
  var body_594338 = newJObject()
  add(path_594336, "labAccountName", newJString(labAccountName))
  add(path_594336, "resourceGroupName", newJString(resourceGroupName))
  add(query_594337, "api-version", newJString(apiVersion))
  add(path_594336, "subscriptionId", newJString(subscriptionId))
  add(path_594336, "labName", newJString(labName))
  if lab != nil:
    body_594338 = lab
  result = call_594335.call(path_594336, query_594337, nil, nil, body_594338)

var labsUpdate* = Call_LabsUpdate_594325(name: "labsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
                                      validator: validate_LabsUpdate_594326,
                                      base: "", url: url_LabsUpdate_594327,
                                      schemes: {Scheme.Https})
type
  Call_LabsDelete_594313 = ref object of OpenApiRestCall_593437
proc url_LabsDelete_594315(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsDelete_594314(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594316 = path.getOrDefault("labAccountName")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "labAccountName", valid_594316
  var valid_594317 = path.getOrDefault("resourceGroupName")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "resourceGroupName", valid_594317
  var valid_594318 = path.getOrDefault("subscriptionId")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "subscriptionId", valid_594318
  var valid_594319 = path.getOrDefault("labName")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "labName", valid_594319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594320 = query.getOrDefault("api-version")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594320 != nil:
    section.add "api-version", valid_594320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594321: Call_LabsDelete_594313; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete
  ## 
  let valid = call_594321.validator(path, query, header, formData, body)
  let scheme = call_594321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594321.url(scheme.get, call_594321.host, call_594321.base,
                         call_594321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594321, url, valid)

proc call*(call_594322: Call_LabsDelete_594313; labAccountName: string;
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
  var path_594323 = newJObject()
  var query_594324 = newJObject()
  add(path_594323, "labAccountName", newJString(labAccountName))
  add(path_594323, "resourceGroupName", newJString(resourceGroupName))
  add(query_594324, "api-version", newJString(apiVersion))
  add(path_594323, "subscriptionId", newJString(subscriptionId))
  add(path_594323, "labName", newJString(labName))
  result = call_594322.call(path_594323, query_594324, nil, nil, nil)

var labsDelete* = Call_LabsDelete_594313(name: "labsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}",
                                      validator: validate_LabsDelete_594314,
                                      base: "", url: url_LabsDelete_594315,
                                      schemes: {Scheme.Https})
type
  Call_LabsAddUsers_594339 = ref object of OpenApiRestCall_593437
proc url_LabsAddUsers_594341(protocol: Scheme; host: string; base: string;
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

proc validate_LabsAddUsers_594340(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594342 = path.getOrDefault("labAccountName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "labAccountName", valid_594342
  var valid_594343 = path.getOrDefault("resourceGroupName")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "resourceGroupName", valid_594343
  var valid_594344 = path.getOrDefault("subscriptionId")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "subscriptionId", valid_594344
  var valid_594345 = path.getOrDefault("labName")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "labName", valid_594345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594346 = query.getOrDefault("api-version")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594346 != nil:
    section.add "api-version", valid_594346
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

proc call*(call_594348: Call_LabsAddUsers_594339; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add users to a lab
  ## 
  let valid = call_594348.validator(path, query, header, formData, body)
  let scheme = call_594348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594348.url(scheme.get, call_594348.host, call_594348.base,
                         call_594348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594348, url, valid)

proc call*(call_594349: Call_LabsAddUsers_594339; labAccountName: string;
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
  var path_594350 = newJObject()
  var query_594351 = newJObject()
  var body_594352 = newJObject()
  add(path_594350, "labAccountName", newJString(labAccountName))
  add(path_594350, "resourceGroupName", newJString(resourceGroupName))
  add(query_594351, "api-version", newJString(apiVersion))
  if addUsersPayload != nil:
    body_594352 = addUsersPayload
  add(path_594350, "subscriptionId", newJString(subscriptionId))
  add(path_594350, "labName", newJString(labName))
  result = call_594349.call(path_594350, query_594351, nil, nil, body_594352)

var labsAddUsers* = Call_LabsAddUsers_594339(name: "labsAddUsers",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/addUsers",
    validator: validate_LabsAddUsers_594340, base: "", url: url_LabsAddUsers_594341,
    schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsList_594353 = ref object of OpenApiRestCall_593437
proc url_EnvironmentSettingsList_594355(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentSettingsList_594354(path: JsonNode; query: JsonNode;
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
  var valid_594356 = path.getOrDefault("labAccountName")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "labAccountName", valid_594356
  var valid_594357 = path.getOrDefault("resourceGroupName")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "resourceGroupName", valid_594357
  var valid_594358 = path.getOrDefault("subscriptionId")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "subscriptionId", valid_594358
  var valid_594359 = path.getOrDefault("labName")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "labName", valid_594359
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
  var valid_594360 = query.getOrDefault("$orderby")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "$orderby", valid_594360
  var valid_594361 = query.getOrDefault("$expand")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "$expand", valid_594361
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594362 = query.getOrDefault("api-version")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594362 != nil:
    section.add "api-version", valid_594362
  var valid_594363 = query.getOrDefault("$top")
  valid_594363 = validateParameter(valid_594363, JInt, required = false, default = nil)
  if valid_594363 != nil:
    section.add "$top", valid_594363
  var valid_594364 = query.getOrDefault("$filter")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "$filter", valid_594364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594365: Call_EnvironmentSettingsList_594353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environment setting in a given lab.
  ## 
  let valid = call_594365.validator(path, query, header, formData, body)
  let scheme = call_594365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594365.url(scheme.get, call_594365.host, call_594365.base,
                         call_594365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594365, url, valid)

proc call*(call_594366: Call_EnvironmentSettingsList_594353;
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
  var path_594367 = newJObject()
  var query_594368 = newJObject()
  add(path_594367, "labAccountName", newJString(labAccountName))
  add(path_594367, "resourceGroupName", newJString(resourceGroupName))
  add(query_594368, "$orderby", newJString(Orderby))
  add(query_594368, "$expand", newJString(Expand))
  add(query_594368, "api-version", newJString(apiVersion))
  add(path_594367, "subscriptionId", newJString(subscriptionId))
  add(query_594368, "$top", newJInt(Top))
  add(path_594367, "labName", newJString(labName))
  add(query_594368, "$filter", newJString(Filter))
  result = call_594366.call(path_594367, query_594368, nil, nil, nil)

var environmentSettingsList* = Call_EnvironmentSettingsList_594353(
    name: "environmentSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings",
    validator: validate_EnvironmentSettingsList_594354, base: "",
    url: url_EnvironmentSettingsList_594355, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsCreateOrUpdate_594383 = ref object of OpenApiRestCall_593437
proc url_EnvironmentSettingsCreateOrUpdate_594385(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsCreateOrUpdate_594384(path: JsonNode;
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
  var valid_594386 = path.getOrDefault("labAccountName")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "labAccountName", valid_594386
  var valid_594387 = path.getOrDefault("resourceGroupName")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "resourceGroupName", valid_594387
  var valid_594388 = path.getOrDefault("subscriptionId")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "subscriptionId", valid_594388
  var valid_594389 = path.getOrDefault("environmentSettingName")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "environmentSettingName", valid_594389
  var valid_594390 = path.getOrDefault("labName")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "labName", valid_594390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594391 = query.getOrDefault("api-version")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594391 != nil:
    section.add "api-version", valid_594391
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

proc call*(call_594393: Call_EnvironmentSettingsCreateOrUpdate_594383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing Environment Setting. This operation can take a while to complete
  ## 
  let valid = call_594393.validator(path, query, header, formData, body)
  let scheme = call_594393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594393.url(scheme.get, call_594393.host, call_594393.base,
                         call_594393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594393, url, valid)

proc call*(call_594394: Call_EnvironmentSettingsCreateOrUpdate_594383;
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
  var path_594395 = newJObject()
  var query_594396 = newJObject()
  var body_594397 = newJObject()
  add(path_594395, "labAccountName", newJString(labAccountName))
  add(path_594395, "resourceGroupName", newJString(resourceGroupName))
  add(query_594396, "api-version", newJString(apiVersion))
  add(path_594395, "subscriptionId", newJString(subscriptionId))
  if environmentSetting != nil:
    body_594397 = environmentSetting
  add(path_594395, "environmentSettingName", newJString(environmentSettingName))
  add(path_594395, "labName", newJString(labName))
  result = call_594394.call(path_594395, query_594396, nil, nil, body_594397)

var environmentSettingsCreateOrUpdate* = Call_EnvironmentSettingsCreateOrUpdate_594383(
    name: "environmentSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsCreateOrUpdate_594384, base: "",
    url: url_EnvironmentSettingsCreateOrUpdate_594385, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsGet_594369 = ref object of OpenApiRestCall_593437
proc url_EnvironmentSettingsGet_594371(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentSettingsGet_594370(path: JsonNode; query: JsonNode;
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
  var valid_594372 = path.getOrDefault("labAccountName")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "labAccountName", valid_594372
  var valid_594373 = path.getOrDefault("resourceGroupName")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "resourceGroupName", valid_594373
  var valid_594374 = path.getOrDefault("subscriptionId")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "subscriptionId", valid_594374
  var valid_594375 = path.getOrDefault("environmentSettingName")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "environmentSettingName", valid_594375
  var valid_594376 = path.getOrDefault("labName")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "labName", valid_594376
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=publishingState)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594377 = query.getOrDefault("$expand")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = nil)
  if valid_594377 != nil:
    section.add "$expand", valid_594377
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594378 = query.getOrDefault("api-version")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594378 != nil:
    section.add "api-version", valid_594378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594379: Call_EnvironmentSettingsGet_594369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment setting
  ## 
  let valid = call_594379.validator(path, query, header, formData, body)
  let scheme = call_594379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594379.url(scheme.get, call_594379.host, call_594379.base,
                         call_594379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594379, url, valid)

proc call*(call_594380: Call_EnvironmentSettingsGet_594369; labAccountName: string;
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
  var path_594381 = newJObject()
  var query_594382 = newJObject()
  add(path_594381, "labAccountName", newJString(labAccountName))
  add(path_594381, "resourceGroupName", newJString(resourceGroupName))
  add(query_594382, "$expand", newJString(Expand))
  add(query_594382, "api-version", newJString(apiVersion))
  add(path_594381, "subscriptionId", newJString(subscriptionId))
  add(path_594381, "environmentSettingName", newJString(environmentSettingName))
  add(path_594381, "labName", newJString(labName))
  result = call_594380.call(path_594381, query_594382, nil, nil, nil)

var environmentSettingsGet* = Call_EnvironmentSettingsGet_594369(
    name: "environmentSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsGet_594370, base: "",
    url: url_EnvironmentSettingsGet_594371, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsUpdate_594411 = ref object of OpenApiRestCall_593437
proc url_EnvironmentSettingsUpdate_594413(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsUpdate_594412(path: JsonNode; query: JsonNode;
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
  var valid_594414 = path.getOrDefault("labAccountName")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "labAccountName", valid_594414
  var valid_594415 = path.getOrDefault("resourceGroupName")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "resourceGroupName", valid_594415
  var valid_594416 = path.getOrDefault("subscriptionId")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "subscriptionId", valid_594416
  var valid_594417 = path.getOrDefault("environmentSettingName")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "environmentSettingName", valid_594417
  var valid_594418 = path.getOrDefault("labName")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "labName", valid_594418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594419 = query.getOrDefault("api-version")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594419 != nil:
    section.add "api-version", valid_594419
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

proc call*(call_594421: Call_EnvironmentSettingsUpdate_594411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of environment setting.
  ## 
  let valid = call_594421.validator(path, query, header, formData, body)
  let scheme = call_594421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594421.url(scheme.get, call_594421.host, call_594421.base,
                         call_594421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594421, url, valid)

proc call*(call_594422: Call_EnvironmentSettingsUpdate_594411;
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
  var path_594423 = newJObject()
  var query_594424 = newJObject()
  var body_594425 = newJObject()
  add(path_594423, "labAccountName", newJString(labAccountName))
  add(path_594423, "resourceGroupName", newJString(resourceGroupName))
  add(query_594424, "api-version", newJString(apiVersion))
  add(path_594423, "subscriptionId", newJString(subscriptionId))
  if environmentSetting != nil:
    body_594425 = environmentSetting
  add(path_594423, "environmentSettingName", newJString(environmentSettingName))
  add(path_594423, "labName", newJString(labName))
  result = call_594422.call(path_594423, query_594424, nil, nil, body_594425)

var environmentSettingsUpdate* = Call_EnvironmentSettingsUpdate_594411(
    name: "environmentSettingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsUpdate_594412, base: "",
    url: url_EnvironmentSettingsUpdate_594413, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsDelete_594398 = ref object of OpenApiRestCall_593437
proc url_EnvironmentSettingsDelete_594400(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsDelete_594399(path: JsonNode; query: JsonNode;
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
  var valid_594401 = path.getOrDefault("labAccountName")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "labAccountName", valid_594401
  var valid_594402 = path.getOrDefault("resourceGroupName")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "resourceGroupName", valid_594402
  var valid_594403 = path.getOrDefault("subscriptionId")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "subscriptionId", valid_594403
  var valid_594404 = path.getOrDefault("environmentSettingName")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "environmentSettingName", valid_594404
  var valid_594405 = path.getOrDefault("labName")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "labName", valid_594405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594406 = query.getOrDefault("api-version")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594406 != nil:
    section.add "api-version", valid_594406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594407: Call_EnvironmentSettingsDelete_594398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment setting. This operation can take a while to complete
  ## 
  let valid = call_594407.validator(path, query, header, formData, body)
  let scheme = call_594407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594407.url(scheme.get, call_594407.host, call_594407.base,
                         call_594407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594407, url, valid)

proc call*(call_594408: Call_EnvironmentSettingsDelete_594398;
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
  var path_594409 = newJObject()
  var query_594410 = newJObject()
  add(path_594409, "labAccountName", newJString(labAccountName))
  add(path_594409, "resourceGroupName", newJString(resourceGroupName))
  add(query_594410, "api-version", newJString(apiVersion))
  add(path_594409, "subscriptionId", newJString(subscriptionId))
  add(path_594409, "environmentSettingName", newJString(environmentSettingName))
  add(path_594409, "labName", newJString(labName))
  result = call_594408.call(path_594409, query_594410, nil, nil, nil)

var environmentSettingsDelete* = Call_EnvironmentSettingsDelete_594398(
    name: "environmentSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}",
    validator: validate_EnvironmentSettingsDelete_594399, base: "",
    url: url_EnvironmentSettingsDelete_594400, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsClaimAny_594426 = ref object of OpenApiRestCall_593437
proc url_EnvironmentSettingsClaimAny_594428(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsClaimAny_594427(path: JsonNode; query: JsonNode;
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
  var valid_594429 = path.getOrDefault("labAccountName")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "labAccountName", valid_594429
  var valid_594430 = path.getOrDefault("resourceGroupName")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "resourceGroupName", valid_594430
  var valid_594431 = path.getOrDefault("subscriptionId")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "subscriptionId", valid_594431
  var valid_594432 = path.getOrDefault("environmentSettingName")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "environmentSettingName", valid_594432
  var valid_594433 = path.getOrDefault("labName")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "labName", valid_594433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594434 = query.getOrDefault("api-version")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594434 != nil:
    section.add "api-version", valid_594434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594435: Call_EnvironmentSettingsClaimAny_594426; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims a random environment for a user in an environment settings
  ## 
  let valid = call_594435.validator(path, query, header, formData, body)
  let scheme = call_594435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594435.url(scheme.get, call_594435.host, call_594435.base,
                         call_594435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594435, url, valid)

proc call*(call_594436: Call_EnvironmentSettingsClaimAny_594426;
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
  var path_594437 = newJObject()
  var query_594438 = newJObject()
  add(path_594437, "labAccountName", newJString(labAccountName))
  add(path_594437, "resourceGroupName", newJString(resourceGroupName))
  add(query_594438, "api-version", newJString(apiVersion))
  add(path_594437, "subscriptionId", newJString(subscriptionId))
  add(path_594437, "environmentSettingName", newJString(environmentSettingName))
  add(path_594437, "labName", newJString(labName))
  result = call_594436.call(path_594437, query_594438, nil, nil, nil)

var environmentSettingsClaimAny* = Call_EnvironmentSettingsClaimAny_594426(
    name: "environmentSettingsClaimAny", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/claimAny",
    validator: validate_EnvironmentSettingsClaimAny_594427, base: "",
    url: url_EnvironmentSettingsClaimAny_594428, schemes: {Scheme.Https})
type
  Call_EnvironmentsList_594439 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsList_594441(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsList_594440(path: JsonNode; query: JsonNode;
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
  var valid_594442 = path.getOrDefault("labAccountName")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "labAccountName", valid_594442
  var valid_594443 = path.getOrDefault("resourceGroupName")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "resourceGroupName", valid_594443
  var valid_594444 = path.getOrDefault("subscriptionId")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "subscriptionId", valid_594444
  var valid_594445 = path.getOrDefault("environmentSettingName")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "environmentSettingName", valid_594445
  var valid_594446 = path.getOrDefault("labName")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "labName", valid_594446
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
  var valid_594447 = query.getOrDefault("$orderby")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = nil)
  if valid_594447 != nil:
    section.add "$orderby", valid_594447
  var valid_594448 = query.getOrDefault("$expand")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = nil)
  if valid_594448 != nil:
    section.add "$expand", valid_594448
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594449 = query.getOrDefault("api-version")
  valid_594449 = validateParameter(valid_594449, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594449 != nil:
    section.add "api-version", valid_594449
  var valid_594450 = query.getOrDefault("$top")
  valid_594450 = validateParameter(valid_594450, JInt, required = false, default = nil)
  if valid_594450 != nil:
    section.add "$top", valid_594450
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

proc call*(call_594452: Call_EnvironmentsList_594439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environments in a given environment setting.
  ## 
  let valid = call_594452.validator(path, query, header, formData, body)
  let scheme = call_594452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594452.url(scheme.get, call_594452.host, call_594452.base,
                         call_594452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594452, url, valid)

proc call*(call_594453: Call_EnvironmentsList_594439; labAccountName: string;
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
  var path_594454 = newJObject()
  var query_594455 = newJObject()
  add(path_594454, "labAccountName", newJString(labAccountName))
  add(path_594454, "resourceGroupName", newJString(resourceGroupName))
  add(query_594455, "$orderby", newJString(Orderby))
  add(query_594455, "$expand", newJString(Expand))
  add(query_594455, "api-version", newJString(apiVersion))
  add(path_594454, "subscriptionId", newJString(subscriptionId))
  add(query_594455, "$top", newJInt(Top))
  add(path_594454, "environmentSettingName", newJString(environmentSettingName))
  add(path_594454, "labName", newJString(labName))
  add(query_594455, "$filter", newJString(Filter))
  result = call_594453.call(path_594454, query_594455, nil, nil, nil)

var environmentsList* = Call_EnvironmentsList_594439(name: "environmentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments",
    validator: validate_EnvironmentsList_594440, base: "",
    url: url_EnvironmentsList_594441, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_594471 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsCreateOrUpdate_594473(protocol: Scheme; host: string;
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

proc validate_EnvironmentsCreateOrUpdate_594472(path: JsonNode; query: JsonNode;
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
  var valid_594474 = path.getOrDefault("labAccountName")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "labAccountName", valid_594474
  var valid_594475 = path.getOrDefault("resourceGroupName")
  valid_594475 = validateParameter(valid_594475, JString, required = true,
                                 default = nil)
  if valid_594475 != nil:
    section.add "resourceGroupName", valid_594475
  var valid_594476 = path.getOrDefault("subscriptionId")
  valid_594476 = validateParameter(valid_594476, JString, required = true,
                                 default = nil)
  if valid_594476 != nil:
    section.add "subscriptionId", valid_594476
  var valid_594477 = path.getOrDefault("environmentSettingName")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "environmentSettingName", valid_594477
  var valid_594478 = path.getOrDefault("environmentName")
  valid_594478 = validateParameter(valid_594478, JString, required = true,
                                 default = nil)
  if valid_594478 != nil:
    section.add "environmentName", valid_594478
  var valid_594479 = path.getOrDefault("labName")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "labName", valid_594479
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594480 = query.getOrDefault("api-version")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594480 != nil:
    section.add "api-version", valid_594480
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

proc call*(call_594482: Call_EnvironmentsCreateOrUpdate_594471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Environment.
  ## 
  let valid = call_594482.validator(path, query, header, formData, body)
  let scheme = call_594482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594482.url(scheme.get, call_594482.host, call_594482.base,
                         call_594482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594482, url, valid)

proc call*(call_594483: Call_EnvironmentsCreateOrUpdate_594471;
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
  var path_594484 = newJObject()
  var query_594485 = newJObject()
  var body_594486 = newJObject()
  add(path_594484, "labAccountName", newJString(labAccountName))
  add(path_594484, "resourceGroupName", newJString(resourceGroupName))
  add(query_594485, "api-version", newJString(apiVersion))
  add(path_594484, "subscriptionId", newJString(subscriptionId))
  add(path_594484, "environmentSettingName", newJString(environmentSettingName))
  add(path_594484, "environmentName", newJString(environmentName))
  add(path_594484, "labName", newJString(labName))
  if environment != nil:
    body_594486 = environment
  result = call_594483.call(path_594484, query_594485, nil, nil, body_594486)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_594471(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsCreateOrUpdate_594472, base: "",
    url: url_EnvironmentsCreateOrUpdate_594473, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_594456 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsGet_594458(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsGet_594457(path: JsonNode; query: JsonNode;
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
  var valid_594459 = path.getOrDefault("labAccountName")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "labAccountName", valid_594459
  var valid_594460 = path.getOrDefault("resourceGroupName")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "resourceGroupName", valid_594460
  var valid_594461 = path.getOrDefault("subscriptionId")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "subscriptionId", valid_594461
  var valid_594462 = path.getOrDefault("environmentSettingName")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "environmentSettingName", valid_594462
  var valid_594463 = path.getOrDefault("environmentName")
  valid_594463 = validateParameter(valid_594463, JString, required = true,
                                 default = nil)
  if valid_594463 != nil:
    section.add "environmentName", valid_594463
  var valid_594464 = path.getOrDefault("labName")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "labName", valid_594464
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=networkInterface)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594465 = query.getOrDefault("$expand")
  valid_594465 = validateParameter(valid_594465, JString, required = false,
                                 default = nil)
  if valid_594465 != nil:
    section.add "$expand", valid_594465
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594466 = query.getOrDefault("api-version")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594466 != nil:
    section.add "api-version", valid_594466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594467: Call_EnvironmentsGet_594456; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment
  ## 
  let valid = call_594467.validator(path, query, header, formData, body)
  let scheme = call_594467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594467.url(scheme.get, call_594467.host, call_594467.base,
                         call_594467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594467, url, valid)

proc call*(call_594468: Call_EnvironmentsGet_594456; labAccountName: string;
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
  var path_594469 = newJObject()
  var query_594470 = newJObject()
  add(path_594469, "labAccountName", newJString(labAccountName))
  add(path_594469, "resourceGroupName", newJString(resourceGroupName))
  add(query_594470, "$expand", newJString(Expand))
  add(query_594470, "api-version", newJString(apiVersion))
  add(path_594469, "subscriptionId", newJString(subscriptionId))
  add(path_594469, "environmentSettingName", newJString(environmentSettingName))
  add(path_594469, "environmentName", newJString(environmentName))
  add(path_594469, "labName", newJString(labName))
  result = call_594468.call(path_594469, query_594470, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_594456(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsGet_594457, base: "", url: url_EnvironmentsGet_594458,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsUpdate_594501 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsUpdate_594503(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsUpdate_594502(path: JsonNode; query: JsonNode;
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
  var valid_594504 = path.getOrDefault("labAccountName")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "labAccountName", valid_594504
  var valid_594505 = path.getOrDefault("resourceGroupName")
  valid_594505 = validateParameter(valid_594505, JString, required = true,
                                 default = nil)
  if valid_594505 != nil:
    section.add "resourceGroupName", valid_594505
  var valid_594506 = path.getOrDefault("subscriptionId")
  valid_594506 = validateParameter(valid_594506, JString, required = true,
                                 default = nil)
  if valid_594506 != nil:
    section.add "subscriptionId", valid_594506
  var valid_594507 = path.getOrDefault("environmentSettingName")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "environmentSettingName", valid_594507
  var valid_594508 = path.getOrDefault("environmentName")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "environmentName", valid_594508
  var valid_594509 = path.getOrDefault("labName")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "labName", valid_594509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594510 = query.getOrDefault("api-version")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594510 != nil:
    section.add "api-version", valid_594510
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

proc call*(call_594512: Call_EnvironmentsUpdate_594501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of environments.
  ## 
  let valid = call_594512.validator(path, query, header, formData, body)
  let scheme = call_594512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594512.url(scheme.get, call_594512.host, call_594512.base,
                         call_594512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594512, url, valid)

proc call*(call_594513: Call_EnvironmentsUpdate_594501; labAccountName: string;
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
  var path_594514 = newJObject()
  var query_594515 = newJObject()
  var body_594516 = newJObject()
  add(path_594514, "labAccountName", newJString(labAccountName))
  add(path_594514, "resourceGroupName", newJString(resourceGroupName))
  add(query_594515, "api-version", newJString(apiVersion))
  add(path_594514, "subscriptionId", newJString(subscriptionId))
  add(path_594514, "environmentSettingName", newJString(environmentSettingName))
  add(path_594514, "environmentName", newJString(environmentName))
  add(path_594514, "labName", newJString(labName))
  if environment != nil:
    body_594516 = environment
  result = call_594513.call(path_594514, query_594515, nil, nil, body_594516)

var environmentsUpdate* = Call_EnvironmentsUpdate_594501(
    name: "environmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsUpdate_594502, base: "",
    url: url_EnvironmentsUpdate_594503, schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_594487 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsDelete_594489(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsDelete_594488(path: JsonNode; query: JsonNode;
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
  var valid_594490 = path.getOrDefault("labAccountName")
  valid_594490 = validateParameter(valid_594490, JString, required = true,
                                 default = nil)
  if valid_594490 != nil:
    section.add "labAccountName", valid_594490
  var valid_594491 = path.getOrDefault("resourceGroupName")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "resourceGroupName", valid_594491
  var valid_594492 = path.getOrDefault("subscriptionId")
  valid_594492 = validateParameter(valid_594492, JString, required = true,
                                 default = nil)
  if valid_594492 != nil:
    section.add "subscriptionId", valid_594492
  var valid_594493 = path.getOrDefault("environmentSettingName")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "environmentSettingName", valid_594493
  var valid_594494 = path.getOrDefault("environmentName")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "environmentName", valid_594494
  var valid_594495 = path.getOrDefault("labName")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "labName", valid_594495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594496 = query.getOrDefault("api-version")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594496 != nil:
    section.add "api-version", valid_594496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594497: Call_EnvironmentsDelete_594487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment. This operation can take a while to complete
  ## 
  let valid = call_594497.validator(path, query, header, formData, body)
  let scheme = call_594497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594497.url(scheme.get, call_594497.host, call_594497.base,
                         call_594497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594497, url, valid)

proc call*(call_594498: Call_EnvironmentsDelete_594487; labAccountName: string;
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
  var path_594499 = newJObject()
  var query_594500 = newJObject()
  add(path_594499, "labAccountName", newJString(labAccountName))
  add(path_594499, "resourceGroupName", newJString(resourceGroupName))
  add(query_594500, "api-version", newJString(apiVersion))
  add(path_594499, "subscriptionId", newJString(subscriptionId))
  add(path_594499, "environmentSettingName", newJString(environmentSettingName))
  add(path_594499, "environmentName", newJString(environmentName))
  add(path_594499, "labName", newJString(labName))
  result = call_594498.call(path_594499, query_594500, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_594487(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}",
    validator: validate_EnvironmentsDelete_594488, base: "",
    url: url_EnvironmentsDelete_594489, schemes: {Scheme.Https})
type
  Call_EnvironmentsClaim_594517 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsClaim_594519(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsClaim_594518(path: JsonNode; query: JsonNode;
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
  var valid_594520 = path.getOrDefault("labAccountName")
  valid_594520 = validateParameter(valid_594520, JString, required = true,
                                 default = nil)
  if valid_594520 != nil:
    section.add "labAccountName", valid_594520
  var valid_594521 = path.getOrDefault("resourceGroupName")
  valid_594521 = validateParameter(valid_594521, JString, required = true,
                                 default = nil)
  if valid_594521 != nil:
    section.add "resourceGroupName", valid_594521
  var valid_594522 = path.getOrDefault("subscriptionId")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "subscriptionId", valid_594522
  var valid_594523 = path.getOrDefault("environmentSettingName")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "environmentSettingName", valid_594523
  var valid_594524 = path.getOrDefault("environmentName")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "environmentName", valid_594524
  var valid_594525 = path.getOrDefault("labName")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "labName", valid_594525
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594526 = query.getOrDefault("api-version")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594526 != nil:
    section.add "api-version", valid_594526
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594527: Call_EnvironmentsClaim_594517; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claims the environment and assigns it to the user
  ## 
  let valid = call_594527.validator(path, query, header, formData, body)
  let scheme = call_594527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594527.url(scheme.get, call_594527.host, call_594527.base,
                         call_594527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594527, url, valid)

proc call*(call_594528: Call_EnvironmentsClaim_594517; labAccountName: string;
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
  var path_594529 = newJObject()
  var query_594530 = newJObject()
  add(path_594529, "labAccountName", newJString(labAccountName))
  add(path_594529, "resourceGroupName", newJString(resourceGroupName))
  add(query_594530, "api-version", newJString(apiVersion))
  add(path_594529, "subscriptionId", newJString(subscriptionId))
  add(path_594529, "environmentSettingName", newJString(environmentSettingName))
  add(path_594529, "environmentName", newJString(environmentName))
  add(path_594529, "labName", newJString(labName))
  result = call_594528.call(path_594529, query_594530, nil, nil, nil)

var environmentsClaim* = Call_EnvironmentsClaim_594517(name: "environmentsClaim",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/claim",
    validator: validate_EnvironmentsClaim_594518, base: "",
    url: url_EnvironmentsClaim_594519, schemes: {Scheme.Https})
type
  Call_EnvironmentsResetPassword_594531 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsResetPassword_594533(protocol: Scheme; host: string;
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

proc validate_EnvironmentsResetPassword_594532(path: JsonNode; query: JsonNode;
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
  var valid_594534 = path.getOrDefault("labAccountName")
  valid_594534 = validateParameter(valid_594534, JString, required = true,
                                 default = nil)
  if valid_594534 != nil:
    section.add "labAccountName", valid_594534
  var valid_594535 = path.getOrDefault("resourceGroupName")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "resourceGroupName", valid_594535
  var valid_594536 = path.getOrDefault("subscriptionId")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "subscriptionId", valid_594536
  var valid_594537 = path.getOrDefault("environmentSettingName")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "environmentSettingName", valid_594537
  var valid_594538 = path.getOrDefault("environmentName")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "environmentName", valid_594538
  var valid_594539 = path.getOrDefault("labName")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "labName", valid_594539
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594540 = query.getOrDefault("api-version")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594540 != nil:
    section.add "api-version", valid_594540
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

proc call*(call_594542: Call_EnvironmentsResetPassword_594531; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the user password on an environment This operation can take a while to complete
  ## 
  let valid = call_594542.validator(path, query, header, formData, body)
  let scheme = call_594542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594542.url(scheme.get, call_594542.host, call_594542.base,
                         call_594542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594542, url, valid)

proc call*(call_594543: Call_EnvironmentsResetPassword_594531;
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
  var path_594544 = newJObject()
  var query_594545 = newJObject()
  var body_594546 = newJObject()
  add(path_594544, "labAccountName", newJString(labAccountName))
  add(path_594544, "resourceGroupName", newJString(resourceGroupName))
  add(query_594545, "api-version", newJString(apiVersion))
  add(path_594544, "subscriptionId", newJString(subscriptionId))
  add(path_594544, "environmentSettingName", newJString(environmentSettingName))
  add(path_594544, "environmentName", newJString(environmentName))
  add(path_594544, "labName", newJString(labName))
  if resetPasswordPayload != nil:
    body_594546 = resetPasswordPayload
  result = call_594543.call(path_594544, query_594545, nil, nil, body_594546)

var environmentsResetPassword* = Call_EnvironmentsResetPassword_594531(
    name: "environmentsResetPassword", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/resetPassword",
    validator: validate_EnvironmentsResetPassword_594532, base: "",
    url: url_EnvironmentsResetPassword_594533, schemes: {Scheme.Https})
type
  Call_EnvironmentsStart_594547 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsStart_594549(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsStart_594548(path: JsonNode; query: JsonNode;
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
  var valid_594550 = path.getOrDefault("labAccountName")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "labAccountName", valid_594550
  var valid_594551 = path.getOrDefault("resourceGroupName")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "resourceGroupName", valid_594551
  var valid_594552 = path.getOrDefault("subscriptionId")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "subscriptionId", valid_594552
  var valid_594553 = path.getOrDefault("environmentSettingName")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "environmentSettingName", valid_594553
  var valid_594554 = path.getOrDefault("environmentName")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = nil)
  if valid_594554 != nil:
    section.add "environmentName", valid_594554
  var valid_594555 = path.getOrDefault("labName")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "labName", valid_594555
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594556 = query.getOrDefault("api-version")
  valid_594556 = validateParameter(valid_594556, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594556 != nil:
    section.add "api-version", valid_594556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594557: Call_EnvironmentsStart_594547; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an environment by starting all resources inside the environment. This operation can take a while to complete
  ## 
  let valid = call_594557.validator(path, query, header, formData, body)
  let scheme = call_594557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594557.url(scheme.get, call_594557.host, call_594557.base,
                         call_594557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594557, url, valid)

proc call*(call_594558: Call_EnvironmentsStart_594547; labAccountName: string;
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
  var path_594559 = newJObject()
  var query_594560 = newJObject()
  add(path_594559, "labAccountName", newJString(labAccountName))
  add(path_594559, "resourceGroupName", newJString(resourceGroupName))
  add(query_594560, "api-version", newJString(apiVersion))
  add(path_594559, "subscriptionId", newJString(subscriptionId))
  add(path_594559, "environmentSettingName", newJString(environmentSettingName))
  add(path_594559, "environmentName", newJString(environmentName))
  add(path_594559, "labName", newJString(labName))
  result = call_594558.call(path_594559, query_594560, nil, nil, nil)

var environmentsStart* = Call_EnvironmentsStart_594547(name: "environmentsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/start",
    validator: validate_EnvironmentsStart_594548, base: "",
    url: url_EnvironmentsStart_594549, schemes: {Scheme.Https})
type
  Call_EnvironmentsStop_594561 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsStop_594563(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsStop_594562(path: JsonNode; query: JsonNode;
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
  var valid_594564 = path.getOrDefault("labAccountName")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "labAccountName", valid_594564
  var valid_594565 = path.getOrDefault("resourceGroupName")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "resourceGroupName", valid_594565
  var valid_594566 = path.getOrDefault("subscriptionId")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "subscriptionId", valid_594566
  var valid_594567 = path.getOrDefault("environmentSettingName")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "environmentSettingName", valid_594567
  var valid_594568 = path.getOrDefault("environmentName")
  valid_594568 = validateParameter(valid_594568, JString, required = true,
                                 default = nil)
  if valid_594568 != nil:
    section.add "environmentName", valid_594568
  var valid_594569 = path.getOrDefault("labName")
  valid_594569 = validateParameter(valid_594569, JString, required = true,
                                 default = nil)
  if valid_594569 != nil:
    section.add "labName", valid_594569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594570 = query.getOrDefault("api-version")
  valid_594570 = validateParameter(valid_594570, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594570 != nil:
    section.add "api-version", valid_594570
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594571: Call_EnvironmentsStop_594561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an environment by stopping all resources inside the environment This operation can take a while to complete
  ## 
  let valid = call_594571.validator(path, query, header, formData, body)
  let scheme = call_594571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594571.url(scheme.get, call_594571.host, call_594571.base,
                         call_594571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594571, url, valid)

proc call*(call_594572: Call_EnvironmentsStop_594561; labAccountName: string;
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
  var path_594573 = newJObject()
  var query_594574 = newJObject()
  add(path_594573, "labAccountName", newJString(labAccountName))
  add(path_594573, "resourceGroupName", newJString(resourceGroupName))
  add(query_594574, "api-version", newJString(apiVersion))
  add(path_594573, "subscriptionId", newJString(subscriptionId))
  add(path_594573, "environmentSettingName", newJString(environmentSettingName))
  add(path_594573, "environmentName", newJString(environmentName))
  add(path_594573, "labName", newJString(labName))
  result = call_594572.call(path_594573, query_594574, nil, nil, nil)

var environmentsStop* = Call_EnvironmentsStop_594561(name: "environmentsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/environments/{environmentName}/stop",
    validator: validate_EnvironmentsStop_594562, base: "",
    url: url_EnvironmentsStop_594563, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsPublish_594575 = ref object of OpenApiRestCall_593437
proc url_EnvironmentSettingsPublish_594577(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsPublish_594576(path: JsonNode; query: JsonNode;
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
  var valid_594578 = path.getOrDefault("labAccountName")
  valid_594578 = validateParameter(valid_594578, JString, required = true,
                                 default = nil)
  if valid_594578 != nil:
    section.add "labAccountName", valid_594578
  var valid_594579 = path.getOrDefault("resourceGroupName")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "resourceGroupName", valid_594579
  var valid_594580 = path.getOrDefault("subscriptionId")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "subscriptionId", valid_594580
  var valid_594581 = path.getOrDefault("environmentSettingName")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "environmentSettingName", valid_594581
  var valid_594582 = path.getOrDefault("labName")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "labName", valid_594582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594583 = query.getOrDefault("api-version")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594583 != nil:
    section.add "api-version", valid_594583
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

proc call*(call_594585: Call_EnvironmentSettingsPublish_594575; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions/deprovisions required resources for an environment setting based on current state of the lab/environment setting.
  ## 
  let valid = call_594585.validator(path, query, header, formData, body)
  let scheme = call_594585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594585.url(scheme.get, call_594585.host, call_594585.base,
                         call_594585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594585, url, valid)

proc call*(call_594586: Call_EnvironmentSettingsPublish_594575;
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
  var path_594587 = newJObject()
  var query_594588 = newJObject()
  var body_594589 = newJObject()
  add(path_594587, "labAccountName", newJString(labAccountName))
  add(path_594587, "resourceGroupName", newJString(resourceGroupName))
  add(query_594588, "api-version", newJString(apiVersion))
  if publishPayload != nil:
    body_594589 = publishPayload
  add(path_594587, "subscriptionId", newJString(subscriptionId))
  add(path_594587, "environmentSettingName", newJString(environmentSettingName))
  add(path_594587, "labName", newJString(labName))
  result = call_594586.call(path_594587, query_594588, nil, nil, body_594589)

var environmentSettingsPublish* = Call_EnvironmentSettingsPublish_594575(
    name: "environmentSettingsPublish", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/publish",
    validator: validate_EnvironmentSettingsPublish_594576, base: "",
    url: url_EnvironmentSettingsPublish_594577, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsStart_594590 = ref object of OpenApiRestCall_593437
proc url_EnvironmentSettingsStart_594592(protocol: Scheme; host: string;
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

proc validate_EnvironmentSettingsStart_594591(path: JsonNode; query: JsonNode;
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
  var valid_594593 = path.getOrDefault("labAccountName")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "labAccountName", valid_594593
  var valid_594594 = path.getOrDefault("resourceGroupName")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "resourceGroupName", valid_594594
  var valid_594595 = path.getOrDefault("subscriptionId")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "subscriptionId", valid_594595
  var valid_594596 = path.getOrDefault("environmentSettingName")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "environmentSettingName", valid_594596
  var valid_594597 = path.getOrDefault("labName")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "labName", valid_594597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594598 = query.getOrDefault("api-version")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594598 != nil:
    section.add "api-version", valid_594598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594599: Call_EnvironmentSettingsStart_594590; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ## 
  let valid = call_594599.validator(path, query, header, formData, body)
  let scheme = call_594599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594599.url(scheme.get, call_594599.host, call_594599.base,
                         call_594599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594599, url, valid)

proc call*(call_594600: Call_EnvironmentSettingsStart_594590;
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
  var path_594601 = newJObject()
  var query_594602 = newJObject()
  add(path_594601, "labAccountName", newJString(labAccountName))
  add(path_594601, "resourceGroupName", newJString(resourceGroupName))
  add(query_594602, "api-version", newJString(apiVersion))
  add(path_594601, "subscriptionId", newJString(subscriptionId))
  add(path_594601, "environmentSettingName", newJString(environmentSettingName))
  add(path_594601, "labName", newJString(labName))
  result = call_594600.call(path_594601, query_594602, nil, nil, nil)

var environmentSettingsStart* = Call_EnvironmentSettingsStart_594590(
    name: "environmentSettingsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/start",
    validator: validate_EnvironmentSettingsStart_594591, base: "",
    url: url_EnvironmentSettingsStart_594592, schemes: {Scheme.Https})
type
  Call_EnvironmentSettingsStop_594603 = ref object of OpenApiRestCall_593437
proc url_EnvironmentSettingsStop_594605(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentSettingsStop_594604(path: JsonNode; query: JsonNode;
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
  var valid_594606 = path.getOrDefault("labAccountName")
  valid_594606 = validateParameter(valid_594606, JString, required = true,
                                 default = nil)
  if valid_594606 != nil:
    section.add "labAccountName", valid_594606
  var valid_594607 = path.getOrDefault("resourceGroupName")
  valid_594607 = validateParameter(valid_594607, JString, required = true,
                                 default = nil)
  if valid_594607 != nil:
    section.add "resourceGroupName", valid_594607
  var valid_594608 = path.getOrDefault("subscriptionId")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "subscriptionId", valid_594608
  var valid_594609 = path.getOrDefault("environmentSettingName")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "environmentSettingName", valid_594609
  var valid_594610 = path.getOrDefault("labName")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "labName", valid_594610
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594611 = query.getOrDefault("api-version")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594611 != nil:
    section.add "api-version", valid_594611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594612: Call_EnvironmentSettingsStop_594603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a template by starting all resources inside the template. This operation can take a while to complete
  ## 
  let valid = call_594612.validator(path, query, header, formData, body)
  let scheme = call_594612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594612.url(scheme.get, call_594612.host, call_594612.base,
                         call_594612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594612, url, valid)

proc call*(call_594613: Call_EnvironmentSettingsStop_594603;
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
  var path_594614 = newJObject()
  var query_594615 = newJObject()
  add(path_594614, "labAccountName", newJString(labAccountName))
  add(path_594614, "resourceGroupName", newJString(resourceGroupName))
  add(query_594615, "api-version", newJString(apiVersion))
  add(path_594614, "subscriptionId", newJString(subscriptionId))
  add(path_594614, "environmentSettingName", newJString(environmentSettingName))
  add(path_594614, "labName", newJString(labName))
  result = call_594613.call(path_594614, query_594615, nil, nil, nil)

var environmentSettingsStop* = Call_EnvironmentSettingsStop_594603(
    name: "environmentSettingsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/environmentsettings/{environmentSettingName}/stop",
    validator: validate_EnvironmentSettingsStop_594604, base: "",
    url: url_EnvironmentSettingsStop_594605, schemes: {Scheme.Https})
type
  Call_LabsRegister_594616 = ref object of OpenApiRestCall_593437
proc url_LabsRegister_594618(protocol: Scheme; host: string; base: string;
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

proc validate_LabsRegister_594617(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594619 = path.getOrDefault("labAccountName")
  valid_594619 = validateParameter(valid_594619, JString, required = true,
                                 default = nil)
  if valid_594619 != nil:
    section.add "labAccountName", valid_594619
  var valid_594620 = path.getOrDefault("resourceGroupName")
  valid_594620 = validateParameter(valid_594620, JString, required = true,
                                 default = nil)
  if valid_594620 != nil:
    section.add "resourceGroupName", valid_594620
  var valid_594621 = path.getOrDefault("subscriptionId")
  valid_594621 = validateParameter(valid_594621, JString, required = true,
                                 default = nil)
  if valid_594621 != nil:
    section.add "subscriptionId", valid_594621
  var valid_594622 = path.getOrDefault("labName")
  valid_594622 = validateParameter(valid_594622, JString, required = true,
                                 default = nil)
  if valid_594622 != nil:
    section.add "labName", valid_594622
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594623 = query.getOrDefault("api-version")
  valid_594623 = validateParameter(valid_594623, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594623 != nil:
    section.add "api-version", valid_594623
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594624: Call_LabsRegister_594616; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register to managed lab.
  ## 
  let valid = call_594624.validator(path, query, header, formData, body)
  let scheme = call_594624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594624.url(scheme.get, call_594624.host, call_594624.base,
                         call_594624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594624, url, valid)

proc call*(call_594625: Call_LabsRegister_594616; labAccountName: string;
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
  var path_594626 = newJObject()
  var query_594627 = newJObject()
  add(path_594626, "labAccountName", newJString(labAccountName))
  add(path_594626, "resourceGroupName", newJString(resourceGroupName))
  add(query_594627, "api-version", newJString(apiVersion))
  add(path_594626, "subscriptionId", newJString(subscriptionId))
  add(path_594626, "labName", newJString(labName))
  result = call_594625.call(path_594626, query_594627, nil, nil, nil)

var labsRegister* = Call_LabsRegister_594616(name: "labsRegister",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/register",
    validator: validate_LabsRegister_594617, base: "", url: url_LabsRegister_594618,
    schemes: {Scheme.Https})
type
  Call_UsersList_594628 = ref object of OpenApiRestCall_593437
proc url_UsersList_594630(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersList_594629(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594631 = path.getOrDefault("labAccountName")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "labAccountName", valid_594631
  var valid_594632 = path.getOrDefault("resourceGroupName")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "resourceGroupName", valid_594632
  var valid_594633 = path.getOrDefault("subscriptionId")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = nil)
  if valid_594633 != nil:
    section.add "subscriptionId", valid_594633
  var valid_594634 = path.getOrDefault("labName")
  valid_594634 = validateParameter(valid_594634, JString, required = true,
                                 default = nil)
  if valid_594634 != nil:
    section.add "labName", valid_594634
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
  var valid_594635 = query.getOrDefault("$orderby")
  valid_594635 = validateParameter(valid_594635, JString, required = false,
                                 default = nil)
  if valid_594635 != nil:
    section.add "$orderby", valid_594635
  var valid_594636 = query.getOrDefault("$expand")
  valid_594636 = validateParameter(valid_594636, JString, required = false,
                                 default = nil)
  if valid_594636 != nil:
    section.add "$expand", valid_594636
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594637 = query.getOrDefault("api-version")
  valid_594637 = validateParameter(valid_594637, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594637 != nil:
    section.add "api-version", valid_594637
  var valid_594638 = query.getOrDefault("$top")
  valid_594638 = validateParameter(valid_594638, JInt, required = false, default = nil)
  if valid_594638 != nil:
    section.add "$top", valid_594638
  var valid_594639 = query.getOrDefault("$filter")
  valid_594639 = validateParameter(valid_594639, JString, required = false,
                                 default = nil)
  if valid_594639 != nil:
    section.add "$filter", valid_594639
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594640: Call_UsersList_594628; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List users in a given lab.
  ## 
  let valid = call_594640.validator(path, query, header, formData, body)
  let scheme = call_594640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594640.url(scheme.get, call_594640.host, call_594640.base,
                         call_594640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594640, url, valid)

proc call*(call_594641: Call_UsersList_594628; labAccountName: string;
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
  var path_594642 = newJObject()
  var query_594643 = newJObject()
  add(path_594642, "labAccountName", newJString(labAccountName))
  add(path_594642, "resourceGroupName", newJString(resourceGroupName))
  add(query_594643, "$orderby", newJString(Orderby))
  add(query_594643, "$expand", newJString(Expand))
  add(query_594643, "api-version", newJString(apiVersion))
  add(path_594642, "subscriptionId", newJString(subscriptionId))
  add(query_594643, "$top", newJInt(Top))
  add(path_594642, "labName", newJString(labName))
  add(query_594643, "$filter", newJString(Filter))
  result = call_594641.call(path_594642, query_594643, nil, nil, nil)

var usersList* = Call_UsersList_594628(name: "usersList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users",
                                    validator: validate_UsersList_594629,
                                    base: "", url: url_UsersList_594630,
                                    schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_594658 = ref object of OpenApiRestCall_593437
proc url_UsersCreateOrUpdate_594660(protocol: Scheme; host: string; base: string;
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

proc validate_UsersCreateOrUpdate_594659(path: JsonNode; query: JsonNode;
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
  var valid_594661 = path.getOrDefault("labAccountName")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = nil)
  if valid_594661 != nil:
    section.add "labAccountName", valid_594661
  var valid_594662 = path.getOrDefault("resourceGroupName")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "resourceGroupName", valid_594662
  var valid_594663 = path.getOrDefault("subscriptionId")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "subscriptionId", valid_594663
  var valid_594664 = path.getOrDefault("userName")
  valid_594664 = validateParameter(valid_594664, JString, required = true,
                                 default = nil)
  if valid_594664 != nil:
    section.add "userName", valid_594664
  var valid_594665 = path.getOrDefault("labName")
  valid_594665 = validateParameter(valid_594665, JString, required = true,
                                 default = nil)
  if valid_594665 != nil:
    section.add "labName", valid_594665
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594666 = query.getOrDefault("api-version")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594666 != nil:
    section.add "api-version", valid_594666
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

proc call*(call_594668: Call_UsersCreateOrUpdate_594658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing User.
  ## 
  let valid = call_594668.validator(path, query, header, formData, body)
  let scheme = call_594668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594668.url(scheme.get, call_594668.host, call_594668.base,
                         call_594668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594668, url, valid)

proc call*(call_594669: Call_UsersCreateOrUpdate_594658; labAccountName: string;
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
  var path_594670 = newJObject()
  var query_594671 = newJObject()
  var body_594672 = newJObject()
  add(path_594670, "labAccountName", newJString(labAccountName))
  add(path_594670, "resourceGroupName", newJString(resourceGroupName))
  add(query_594671, "api-version", newJString(apiVersion))
  if user != nil:
    body_594672 = user
  add(path_594670, "subscriptionId", newJString(subscriptionId))
  add(path_594670, "userName", newJString(userName))
  add(path_594670, "labName", newJString(labName))
  result = call_594669.call(path_594670, query_594671, nil, nil, body_594672)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_594658(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
    validator: validate_UsersCreateOrUpdate_594659, base: "",
    url: url_UsersCreateOrUpdate_594660, schemes: {Scheme.Https})
type
  Call_UsersGet_594644 = ref object of OpenApiRestCall_593437
proc url_UsersGet_594646(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersGet_594645(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594647 = path.getOrDefault("labAccountName")
  valid_594647 = validateParameter(valid_594647, JString, required = true,
                                 default = nil)
  if valid_594647 != nil:
    section.add "labAccountName", valid_594647
  var valid_594648 = path.getOrDefault("resourceGroupName")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "resourceGroupName", valid_594648
  var valid_594649 = path.getOrDefault("subscriptionId")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "subscriptionId", valid_594649
  var valid_594650 = path.getOrDefault("userName")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "userName", valid_594650
  var valid_594651 = path.getOrDefault("labName")
  valid_594651 = validateParameter(valid_594651, JString, required = true,
                                 default = nil)
  if valid_594651 != nil:
    section.add "labName", valid_594651
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=email)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_594652 = query.getOrDefault("$expand")
  valid_594652 = validateParameter(valid_594652, JString, required = false,
                                 default = nil)
  if valid_594652 != nil:
    section.add "$expand", valid_594652
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594653 = query.getOrDefault("api-version")
  valid_594653 = validateParameter(valid_594653, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594653 != nil:
    section.add "api-version", valid_594653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594654: Call_UsersGet_594644; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get user
  ## 
  let valid = call_594654.validator(path, query, header, formData, body)
  let scheme = call_594654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594654.url(scheme.get, call_594654.host, call_594654.base,
                         call_594654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594654, url, valid)

proc call*(call_594655: Call_UsersGet_594644; labAccountName: string;
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
  var path_594656 = newJObject()
  var query_594657 = newJObject()
  add(path_594656, "labAccountName", newJString(labAccountName))
  add(path_594656, "resourceGroupName", newJString(resourceGroupName))
  add(query_594657, "$expand", newJString(Expand))
  add(query_594657, "api-version", newJString(apiVersion))
  add(path_594656, "subscriptionId", newJString(subscriptionId))
  add(path_594656, "userName", newJString(userName))
  add(path_594656, "labName", newJString(labName))
  result = call_594655.call(path_594656, query_594657, nil, nil, nil)

var usersGet* = Call_UsersGet_594644(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
                                  validator: validate_UsersGet_594645, base: "",
                                  url: url_UsersGet_594646,
                                  schemes: {Scheme.Https})
type
  Call_UsersUpdate_594686 = ref object of OpenApiRestCall_593437
proc url_UsersUpdate_594688(protocol: Scheme; host: string; base: string;
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

proc validate_UsersUpdate_594687(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594689 = path.getOrDefault("labAccountName")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "labAccountName", valid_594689
  var valid_594690 = path.getOrDefault("resourceGroupName")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "resourceGroupName", valid_594690
  var valid_594691 = path.getOrDefault("subscriptionId")
  valid_594691 = validateParameter(valid_594691, JString, required = true,
                                 default = nil)
  if valid_594691 != nil:
    section.add "subscriptionId", valid_594691
  var valid_594692 = path.getOrDefault("userName")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "userName", valid_594692
  var valid_594693 = path.getOrDefault("labName")
  valid_594693 = validateParameter(valid_594693, JString, required = true,
                                 default = nil)
  if valid_594693 != nil:
    section.add "labName", valid_594693
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594694 = query.getOrDefault("api-version")
  valid_594694 = validateParameter(valid_594694, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594694 != nil:
    section.add "api-version", valid_594694
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

proc call*(call_594696: Call_UsersUpdate_594686; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of users.
  ## 
  let valid = call_594696.validator(path, query, header, formData, body)
  let scheme = call_594696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594696.url(scheme.get, call_594696.host, call_594696.base,
                         call_594696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594696, url, valid)

proc call*(call_594697: Call_UsersUpdate_594686; labAccountName: string;
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
  var path_594698 = newJObject()
  var query_594699 = newJObject()
  var body_594700 = newJObject()
  add(path_594698, "labAccountName", newJString(labAccountName))
  add(path_594698, "resourceGroupName", newJString(resourceGroupName))
  add(query_594699, "api-version", newJString(apiVersion))
  if user != nil:
    body_594700 = user
  add(path_594698, "subscriptionId", newJString(subscriptionId))
  add(path_594698, "userName", newJString(userName))
  add(path_594698, "labName", newJString(labName))
  result = call_594697.call(path_594698, query_594699, nil, nil, body_594700)

var usersUpdate* = Call_UsersUpdate_594686(name: "usersUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
                                        validator: validate_UsersUpdate_594687,
                                        base: "", url: url_UsersUpdate_594688,
                                        schemes: {Scheme.Https})
type
  Call_UsersDelete_594673 = ref object of OpenApiRestCall_593437
proc url_UsersDelete_594675(protocol: Scheme; host: string; base: string;
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

proc validate_UsersDelete_594674(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594676 = path.getOrDefault("labAccountName")
  valid_594676 = validateParameter(valid_594676, JString, required = true,
                                 default = nil)
  if valid_594676 != nil:
    section.add "labAccountName", valid_594676
  var valid_594677 = path.getOrDefault("resourceGroupName")
  valid_594677 = validateParameter(valid_594677, JString, required = true,
                                 default = nil)
  if valid_594677 != nil:
    section.add "resourceGroupName", valid_594677
  var valid_594678 = path.getOrDefault("subscriptionId")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "subscriptionId", valid_594678
  var valid_594679 = path.getOrDefault("userName")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = nil)
  if valid_594679 != nil:
    section.add "userName", valid_594679
  var valid_594680 = path.getOrDefault("labName")
  valid_594680 = validateParameter(valid_594680, JString, required = true,
                                 default = nil)
  if valid_594680 != nil:
    section.add "labName", valid_594680
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594681 = query.getOrDefault("api-version")
  valid_594681 = validateParameter(valid_594681, JString, required = true,
                                 default = newJString("2018-10-15"))
  if valid_594681 != nil:
    section.add "api-version", valid_594681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594682: Call_UsersDelete_594673; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user. This operation can take a while to complete
  ## 
  let valid = call_594682.validator(path, query, header, formData, body)
  let scheme = call_594682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594682.url(scheme.get, call_594682.host, call_594682.base,
                         call_594682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594682, url, valid)

proc call*(call_594683: Call_UsersDelete_594673; labAccountName: string;
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
  var path_594684 = newJObject()
  var query_594685 = newJObject()
  add(path_594684, "labAccountName", newJString(labAccountName))
  add(path_594684, "resourceGroupName", newJString(resourceGroupName))
  add(query_594685, "api-version", newJString(apiVersion))
  add(path_594684, "subscriptionId", newJString(subscriptionId))
  add(path_594684, "userName", newJString(userName))
  add(path_594684, "labName", newJString(labName))
  result = call_594683.call(path_594684, query_594685, nil, nil, nil)

var usersDelete* = Call_UsersDelete_594673(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.LabServices/labaccounts/{labAccountName}/labs/{labName}/users/{userName}",
                                        validator: validate_UsersDelete_594674,
                                        base: "", url: url_UsersDelete_594675,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
