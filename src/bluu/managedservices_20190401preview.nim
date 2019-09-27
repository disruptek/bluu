
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ManagedServicesClient
## version: 2019-04-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Specification for ManagedServices.
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "managedservices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593630 = ref object of OpenApiRestCall_593408
proc url_OperationsList_593632(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593631(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a list of the operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593814: Call_OperationsList_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the operations.
  ## 
  let valid = call_593814.validator(path, query, header, formData, body)
  let scheme = call_593814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593814.url(scheme.get, call_593814.host, call_593814.base,
                         call_593814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593814, url, valid)

proc call*(call_593885: Call_OperationsList_593630; apiVersion: string): Recallable =
  ## operationsList
  ## Gets a list of the operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_593886 = newJObject()
  add(query_593886, "api-version", newJString(apiVersion))
  result = call_593885.call(nil, query_593886, nil, nil, nil)

var operationsList* = Call_OperationsList_593630(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ManagedServices/operations",
    validator: validate_OperationsList_593631, base: "", url: url_OperationsList_593632,
    schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsList_593926 = ref object of OpenApiRestCall_593408
proc url_RegistrationAssignmentsList_593928(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedServices/registrationAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationAssignmentsList_593927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of the registration assignments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : Scope of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_593944 = path.getOrDefault("scope")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = nil)
  if valid_593944 != nil:
    section.add "scope", valid_593944
  result.add "path", section
  ## parameters in `query` object:
  ##   $expandRegistrationDefinition: JBool
  ##                                : Tells whether to return registration definition details also along with registration assignment details.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_593945 = query.getOrDefault("$expandRegistrationDefinition")
  valid_593945 = validateParameter(valid_593945, JBool, required = false, default = nil)
  if valid_593945 != nil:
    section.add "$expandRegistrationDefinition", valid_593945
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593946 = query.getOrDefault("api-version")
  valid_593946 = validateParameter(valid_593946, JString, required = true,
                                 default = nil)
  if valid_593946 != nil:
    section.add "api-version", valid_593946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593947: Call_RegistrationAssignmentsList_593926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the registration assignments.
  ## 
  let valid = call_593947.validator(path, query, header, formData, body)
  let scheme = call_593947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593947.url(scheme.get, call_593947.host, call_593947.base,
                         call_593947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593947, url, valid)

proc call*(call_593948: Call_RegistrationAssignmentsList_593926;
          apiVersion: string; scope: string;
          ExpandRegistrationDefinition: bool = false): Recallable =
  ## registrationAssignmentsList
  ## Gets a list of the registration assignments.
  ##   ExpandRegistrationDefinition: bool
  ##                               : Tells whether to return registration definition details also along with registration assignment details.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_593949 = newJObject()
  var query_593950 = newJObject()
  add(query_593950, "$expandRegistrationDefinition",
      newJBool(ExpandRegistrationDefinition))
  add(query_593950, "api-version", newJString(apiVersion))
  add(path_593949, "scope", newJString(scope))
  result = call_593948.call(path_593949, query_593950, nil, nil, nil)

var registrationAssignmentsList* = Call_RegistrationAssignmentsList_593926(
    name: "registrationAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments",
    validator: validate_RegistrationAssignmentsList_593927, base: "",
    url: url_RegistrationAssignmentsList_593928, schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsCreateOrUpdate_593962 = ref object of OpenApiRestCall_593408
proc url_RegistrationAssignmentsCreateOrUpdate_593964(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "registrationAssignmentId" in path,
        "`registrationAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedServices/registrationAssignments/"),
               (kind: VariableSegment, value: "registrationAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationAssignmentsCreateOrUpdate_593963(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a registration assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationAssignmentId: JString (required)
  ##                           : Guid of the registration assignment.
  ##   scope: JString (required)
  ##        : Scope of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `registrationAssignmentId` field"
  var valid_593965 = path.getOrDefault("registrationAssignmentId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "registrationAssignmentId", valid_593965
  var valid_593966 = path.getOrDefault("scope")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "scope", valid_593966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593967 = query.getOrDefault("api-version")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "api-version", valid_593967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   requestBody: JObject (required)
  ##              : The parameters required to create new registration assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_RegistrationAssignmentsCreateOrUpdate_593962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a registration assignment.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_RegistrationAssignmentsCreateOrUpdate_593962;
          apiVersion: string; registrationAssignmentId: string;
          requestBody: JsonNode; scope: string): Recallable =
  ## registrationAssignmentsCreateOrUpdate
  ## Creates or updates a registration assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   registrationAssignmentId: string (required)
  ##                           : Guid of the registration assignment.
  ##   requestBody: JObject (required)
  ##              : The parameters required to create new registration assignment.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  var body_593973 = newJObject()
  add(query_593972, "api-version", newJString(apiVersion))
  add(path_593971, "registrationAssignmentId",
      newJString(registrationAssignmentId))
  if requestBody != nil:
    body_593973 = requestBody
  add(path_593971, "scope", newJString(scope))
  result = call_593970.call(path_593971, query_593972, nil, nil, body_593973)

var registrationAssignmentsCreateOrUpdate* = Call_RegistrationAssignmentsCreateOrUpdate_593962(
    name: "registrationAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments/{registrationAssignmentId}",
    validator: validate_RegistrationAssignmentsCreateOrUpdate_593963, base: "",
    url: url_RegistrationAssignmentsCreateOrUpdate_593964, schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsGet_593951 = ref object of OpenApiRestCall_593408
proc url_RegistrationAssignmentsGet_593953(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "registrationAssignmentId" in path,
        "`registrationAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedServices/registrationAssignments/"),
               (kind: VariableSegment, value: "registrationAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationAssignmentsGet_593952(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of specified registration assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationAssignmentId: JString (required)
  ##                           : Guid of the registration assignment.
  ##   scope: JString (required)
  ##        : Scope of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `registrationAssignmentId` field"
  var valid_593954 = path.getOrDefault("registrationAssignmentId")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "registrationAssignmentId", valid_593954
  var valid_593955 = path.getOrDefault("scope")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "scope", valid_593955
  result.add "path", section
  ## parameters in `query` object:
  ##   $expandRegistrationDefinition: JBool
  ##                                : Tells whether to return registration definition details also along with registration assignment details.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_593956 = query.getOrDefault("$expandRegistrationDefinition")
  valid_593956 = validateParameter(valid_593956, JBool, required = false, default = nil)
  if valid_593956 != nil:
    section.add "$expandRegistrationDefinition", valid_593956
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593957 = query.getOrDefault("api-version")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "api-version", valid_593957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593958: Call_RegistrationAssignmentsGet_593951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of specified registration assignment.
  ## 
  let valid = call_593958.validator(path, query, header, formData, body)
  let scheme = call_593958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593958.url(scheme.get, call_593958.host, call_593958.base,
                         call_593958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593958, url, valid)

proc call*(call_593959: Call_RegistrationAssignmentsGet_593951; apiVersion: string;
          registrationAssignmentId: string; scope: string;
          ExpandRegistrationDefinition: bool = false): Recallable =
  ## registrationAssignmentsGet
  ## Gets the details of specified registration assignment.
  ##   ExpandRegistrationDefinition: bool
  ##                               : Tells whether to return registration definition details also along with registration assignment details.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   registrationAssignmentId: string (required)
  ##                           : Guid of the registration assignment.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_593960 = newJObject()
  var query_593961 = newJObject()
  add(query_593961, "$expandRegistrationDefinition",
      newJBool(ExpandRegistrationDefinition))
  add(query_593961, "api-version", newJString(apiVersion))
  add(path_593960, "registrationAssignmentId",
      newJString(registrationAssignmentId))
  add(path_593960, "scope", newJString(scope))
  result = call_593959.call(path_593960, query_593961, nil, nil, nil)

var registrationAssignmentsGet* = Call_RegistrationAssignmentsGet_593951(
    name: "registrationAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments/{registrationAssignmentId}",
    validator: validate_RegistrationAssignmentsGet_593952, base: "",
    url: url_RegistrationAssignmentsGet_593953, schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsDelete_593974 = ref object of OpenApiRestCall_593408
proc url_RegistrationAssignmentsDelete_593976(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "registrationAssignmentId" in path,
        "`registrationAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedServices/registrationAssignments/"),
               (kind: VariableSegment, value: "registrationAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationAssignmentsDelete_593975(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified registration assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationAssignmentId: JString (required)
  ##                           : Guid of the registration assignment.
  ##   scope: JString (required)
  ##        : Scope of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `registrationAssignmentId` field"
  var valid_593977 = path.getOrDefault("registrationAssignmentId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "registrationAssignmentId", valid_593977
  var valid_593978 = path.getOrDefault("scope")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "scope", valid_593978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593979 = query.getOrDefault("api-version")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "api-version", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_RegistrationAssignmentsDelete_593974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified registration assignment.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_RegistrationAssignmentsDelete_593974;
          apiVersion: string; registrationAssignmentId: string; scope: string): Recallable =
  ## registrationAssignmentsDelete
  ## Deletes the specified registration assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   registrationAssignmentId: string (required)
  ##                           : Guid of the registration assignment.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(query_593983, "api-version", newJString(apiVersion))
  add(path_593982, "registrationAssignmentId",
      newJString(registrationAssignmentId))
  add(path_593982, "scope", newJString(scope))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var registrationAssignmentsDelete* = Call_RegistrationAssignmentsDelete_593974(
    name: "registrationAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments/{registrationAssignmentId}",
    validator: validate_RegistrationAssignmentsDelete_593975, base: "",
    url: url_RegistrationAssignmentsDelete_593976, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsList_593984 = ref object of OpenApiRestCall_593408
proc url_RegistrationDefinitionsList_593986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedServices/registrationDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationDefinitionsList_593985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of the registration definitions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : Scope of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_593987 = path.getOrDefault("scope")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "scope", valid_593987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_RegistrationDefinitionsList_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the registration definitions.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_RegistrationDefinitionsList_593984;
          apiVersion: string; scope: string): Recallable =
  ## registrationDefinitionsList
  ## Gets a list of the registration definitions.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "scope", newJString(scope))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var registrationDefinitionsList* = Call_RegistrationDefinitionsList_593984(
    name: "registrationDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions",
    validator: validate_RegistrationDefinitionsList_593985, base: "",
    url: url_RegistrationDefinitionsList_593986, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsCreateOrUpdate_594003 = ref object of OpenApiRestCall_593408
proc url_RegistrationDefinitionsCreateOrUpdate_594005(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "registrationDefinitionId" in path,
        "`registrationDefinitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedServices/registrationDefinitions/"),
               (kind: VariableSegment, value: "registrationDefinitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationDefinitionsCreateOrUpdate_594004(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a registration definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationDefinitionId: JString (required)
  ##                           : Guid of the registration definition.
  ##   scope: JString (required)
  ##        : Scope of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `registrationDefinitionId` field"
  var valid_594006 = path.getOrDefault("registrationDefinitionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "registrationDefinitionId", valid_594006
  var valid_594007 = path.getOrDefault("scope")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "scope", valid_594007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594008 = query.getOrDefault("api-version")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "api-version", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   requestBody: JObject (required)
  ##              : The parameters required to create new registration definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594010: Call_RegistrationDefinitionsCreateOrUpdate_594003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a registration definition.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_RegistrationDefinitionsCreateOrUpdate_594003;
          apiVersion: string; registrationDefinitionId: string;
          requestBody: JsonNode; scope: string): Recallable =
  ## registrationDefinitionsCreateOrUpdate
  ## Creates or updates a registration definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   registrationDefinitionId: string (required)
  ##                           : Guid of the registration definition.
  ##   requestBody: JObject (required)
  ##              : The parameters required to create new registration definition.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  var body_594014 = newJObject()
  add(query_594013, "api-version", newJString(apiVersion))
  add(path_594012, "registrationDefinitionId",
      newJString(registrationDefinitionId))
  if requestBody != nil:
    body_594014 = requestBody
  add(path_594012, "scope", newJString(scope))
  result = call_594011.call(path_594012, query_594013, nil, nil, body_594014)

var registrationDefinitionsCreateOrUpdate* = Call_RegistrationDefinitionsCreateOrUpdate_594003(
    name: "registrationDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions/{registrationDefinitionId}",
    validator: validate_RegistrationDefinitionsCreateOrUpdate_594004, base: "",
    url: url_RegistrationDefinitionsCreateOrUpdate_594005, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsGet_593993 = ref object of OpenApiRestCall_593408
proc url_RegistrationDefinitionsGet_593995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "registrationDefinitionId" in path,
        "`registrationDefinitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedServices/registrationDefinitions/"),
               (kind: VariableSegment, value: "registrationDefinitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationDefinitionsGet_593994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the registration definition details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationDefinitionId: JString (required)
  ##                           : Guid of the registration definition.
  ##   scope: JString (required)
  ##        : Scope of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `registrationDefinitionId` field"
  var valid_593996 = path.getOrDefault("registrationDefinitionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "registrationDefinitionId", valid_593996
  var valid_593997 = path.getOrDefault("scope")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "scope", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "api-version", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_RegistrationDefinitionsGet_593993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the registration definition details.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_RegistrationDefinitionsGet_593993; apiVersion: string;
          registrationDefinitionId: string; scope: string): Recallable =
  ## registrationDefinitionsGet
  ## Gets the registration definition details.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   registrationDefinitionId: string (required)
  ##                           : Guid of the registration definition.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(query_594002, "api-version", newJString(apiVersion))
  add(path_594001, "registrationDefinitionId",
      newJString(registrationDefinitionId))
  add(path_594001, "scope", newJString(scope))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var registrationDefinitionsGet* = Call_RegistrationDefinitionsGet_593993(
    name: "registrationDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions/{registrationDefinitionId}",
    validator: validate_RegistrationDefinitionsGet_593994, base: "",
    url: url_RegistrationDefinitionsGet_593995, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsDelete_594015 = ref object of OpenApiRestCall_593408
proc url_RegistrationDefinitionsDelete_594017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "registrationDefinitionId" in path,
        "`registrationDefinitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedServices/registrationDefinitions/"),
               (kind: VariableSegment, value: "registrationDefinitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationDefinitionsDelete_594016(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the registration definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationDefinitionId: JString (required)
  ##                           : Guid of the registration definition.
  ##   scope: JString (required)
  ##        : Scope of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `registrationDefinitionId` field"
  var valid_594018 = path.getOrDefault("registrationDefinitionId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "registrationDefinitionId", valid_594018
  var valid_594019 = path.getOrDefault("scope")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "scope", valid_594019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594020 = query.getOrDefault("api-version")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "api-version", valid_594020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594021: Call_RegistrationDefinitionsDelete_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the registration definition.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_RegistrationDefinitionsDelete_594015;
          apiVersion: string; registrationDefinitionId: string; scope: string): Recallable =
  ## registrationDefinitionsDelete
  ## Deletes the registration definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   registrationDefinitionId: string (required)
  ##                           : Guid of the registration definition.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_594023 = newJObject()
  var query_594024 = newJObject()
  add(query_594024, "api-version", newJString(apiVersion))
  add(path_594023, "registrationDefinitionId",
      newJString(registrationDefinitionId))
  add(path_594023, "scope", newJString(scope))
  result = call_594022.call(path_594023, query_594024, nil, nil, nil)

var registrationDefinitionsDelete* = Call_RegistrationDefinitionsDelete_594015(
    name: "registrationDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions/{registrationDefinitionId}",
    validator: validate_RegistrationDefinitionsDelete_594016, base: "",
    url: url_RegistrationDefinitionsDelete_594017, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
