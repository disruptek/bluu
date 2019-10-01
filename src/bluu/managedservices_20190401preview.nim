
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "managedservices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567863 = ref object of OpenApiRestCall_567641
proc url_OperationsList_567865(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567864(path: JsonNode; query: JsonNode;
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
  var valid_568024 = query.getOrDefault("api-version")
  valid_568024 = validateParameter(valid_568024, JString, required = true,
                                 default = nil)
  if valid_568024 != nil:
    section.add "api-version", valid_568024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568047: Call_OperationsList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the operations.
  ## 
  let valid = call_568047.validator(path, query, header, formData, body)
  let scheme = call_568047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568047.url(scheme.get, call_568047.host, call_568047.base,
                         call_568047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568047, url, valid)

proc call*(call_568118: Call_OperationsList_567863; apiVersion: string): Recallable =
  ## operationsList
  ## Gets a list of the operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_568119 = newJObject()
  add(query_568119, "api-version", newJString(apiVersion))
  result = call_568118.call(nil, query_568119, nil, nil, nil)

var operationsList* = Call_OperationsList_567863(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ManagedServices/operations",
    validator: validate_OperationsList_567864, base: "", url: url_OperationsList_567865,
    schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsList_568159 = ref object of OpenApiRestCall_567641
proc url_RegistrationAssignmentsList_568161(protocol: Scheme; host: string;
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

proc validate_RegistrationAssignmentsList_568160(path: JsonNode; query: JsonNode;
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
  var valid_568177 = path.getOrDefault("scope")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = nil)
  if valid_568177 != nil:
    section.add "scope", valid_568177
  result.add "path", section
  ## parameters in `query` object:
  ##   $expandRegistrationDefinition: JBool
  ##                                : Tells whether to return registration definition details also along with registration assignment details.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_568178 = query.getOrDefault("$expandRegistrationDefinition")
  valid_568178 = validateParameter(valid_568178, JBool, required = false, default = nil)
  if valid_568178 != nil:
    section.add "$expandRegistrationDefinition", valid_568178
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568179 = query.getOrDefault("api-version")
  valid_568179 = validateParameter(valid_568179, JString, required = true,
                                 default = nil)
  if valid_568179 != nil:
    section.add "api-version", valid_568179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568180: Call_RegistrationAssignmentsList_568159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the registration assignments.
  ## 
  let valid = call_568180.validator(path, query, header, formData, body)
  let scheme = call_568180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568180.url(scheme.get, call_568180.host, call_568180.base,
                         call_568180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568180, url, valid)

proc call*(call_568181: Call_RegistrationAssignmentsList_568159;
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
  var path_568182 = newJObject()
  var query_568183 = newJObject()
  add(query_568183, "$expandRegistrationDefinition",
      newJBool(ExpandRegistrationDefinition))
  add(query_568183, "api-version", newJString(apiVersion))
  add(path_568182, "scope", newJString(scope))
  result = call_568181.call(path_568182, query_568183, nil, nil, nil)

var registrationAssignmentsList* = Call_RegistrationAssignmentsList_568159(
    name: "registrationAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments",
    validator: validate_RegistrationAssignmentsList_568160, base: "",
    url: url_RegistrationAssignmentsList_568161, schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsCreateOrUpdate_568195 = ref object of OpenApiRestCall_567641
proc url_RegistrationAssignmentsCreateOrUpdate_568197(protocol: Scheme;
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

proc validate_RegistrationAssignmentsCreateOrUpdate_568196(path: JsonNode;
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
  var valid_568198 = path.getOrDefault("registrationAssignmentId")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "registrationAssignmentId", valid_568198
  var valid_568199 = path.getOrDefault("scope")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "scope", valid_568199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568200 = query.getOrDefault("api-version")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "api-version", valid_568200
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

proc call*(call_568202: Call_RegistrationAssignmentsCreateOrUpdate_568195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a registration assignment.
  ## 
  let valid = call_568202.validator(path, query, header, formData, body)
  let scheme = call_568202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568202.url(scheme.get, call_568202.host, call_568202.base,
                         call_568202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568202, url, valid)

proc call*(call_568203: Call_RegistrationAssignmentsCreateOrUpdate_568195;
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
  var path_568204 = newJObject()
  var query_568205 = newJObject()
  var body_568206 = newJObject()
  add(query_568205, "api-version", newJString(apiVersion))
  add(path_568204, "registrationAssignmentId",
      newJString(registrationAssignmentId))
  if requestBody != nil:
    body_568206 = requestBody
  add(path_568204, "scope", newJString(scope))
  result = call_568203.call(path_568204, query_568205, nil, nil, body_568206)

var registrationAssignmentsCreateOrUpdate* = Call_RegistrationAssignmentsCreateOrUpdate_568195(
    name: "registrationAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments/{registrationAssignmentId}",
    validator: validate_RegistrationAssignmentsCreateOrUpdate_568196, base: "",
    url: url_RegistrationAssignmentsCreateOrUpdate_568197, schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsGet_568184 = ref object of OpenApiRestCall_567641
proc url_RegistrationAssignmentsGet_568186(protocol: Scheme; host: string;
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

proc validate_RegistrationAssignmentsGet_568185(path: JsonNode; query: JsonNode;
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
  var valid_568187 = path.getOrDefault("registrationAssignmentId")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "registrationAssignmentId", valid_568187
  var valid_568188 = path.getOrDefault("scope")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "scope", valid_568188
  result.add "path", section
  ## parameters in `query` object:
  ##   $expandRegistrationDefinition: JBool
  ##                                : Tells whether to return registration definition details also along with registration assignment details.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_568189 = query.getOrDefault("$expandRegistrationDefinition")
  valid_568189 = validateParameter(valid_568189, JBool, required = false, default = nil)
  if valid_568189 != nil:
    section.add "$expandRegistrationDefinition", valid_568189
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568190 = query.getOrDefault("api-version")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "api-version", valid_568190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568191: Call_RegistrationAssignmentsGet_568184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of specified registration assignment.
  ## 
  let valid = call_568191.validator(path, query, header, formData, body)
  let scheme = call_568191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568191.url(scheme.get, call_568191.host, call_568191.base,
                         call_568191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568191, url, valid)

proc call*(call_568192: Call_RegistrationAssignmentsGet_568184; apiVersion: string;
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
  var path_568193 = newJObject()
  var query_568194 = newJObject()
  add(query_568194, "$expandRegistrationDefinition",
      newJBool(ExpandRegistrationDefinition))
  add(query_568194, "api-version", newJString(apiVersion))
  add(path_568193, "registrationAssignmentId",
      newJString(registrationAssignmentId))
  add(path_568193, "scope", newJString(scope))
  result = call_568192.call(path_568193, query_568194, nil, nil, nil)

var registrationAssignmentsGet* = Call_RegistrationAssignmentsGet_568184(
    name: "registrationAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments/{registrationAssignmentId}",
    validator: validate_RegistrationAssignmentsGet_568185, base: "",
    url: url_RegistrationAssignmentsGet_568186, schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsDelete_568207 = ref object of OpenApiRestCall_567641
proc url_RegistrationAssignmentsDelete_568209(protocol: Scheme; host: string;
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

proc validate_RegistrationAssignmentsDelete_568208(path: JsonNode; query: JsonNode;
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
  var valid_568210 = path.getOrDefault("registrationAssignmentId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "registrationAssignmentId", valid_568210
  var valid_568211 = path.getOrDefault("scope")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "scope", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568212 = query.getOrDefault("api-version")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "api-version", valid_568212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_RegistrationAssignmentsDelete_568207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified registration assignment.
  ## 
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_RegistrationAssignmentsDelete_568207;
          apiVersion: string; registrationAssignmentId: string; scope: string): Recallable =
  ## registrationAssignmentsDelete
  ## Deletes the specified registration assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   registrationAssignmentId: string (required)
  ##                           : Guid of the registration assignment.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "registrationAssignmentId",
      newJString(registrationAssignmentId))
  add(path_568215, "scope", newJString(scope))
  result = call_568214.call(path_568215, query_568216, nil, nil, nil)

var registrationAssignmentsDelete* = Call_RegistrationAssignmentsDelete_568207(
    name: "registrationAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments/{registrationAssignmentId}",
    validator: validate_RegistrationAssignmentsDelete_568208, base: "",
    url: url_RegistrationAssignmentsDelete_568209, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsList_568217 = ref object of OpenApiRestCall_567641
proc url_RegistrationDefinitionsList_568219(protocol: Scheme; host: string;
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

proc validate_RegistrationDefinitionsList_568218(path: JsonNode; query: JsonNode;
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
  var valid_568220 = path.getOrDefault("scope")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "scope", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_RegistrationDefinitionsList_568217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the registration definitions.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_RegistrationDefinitionsList_568217;
          apiVersion: string; scope: string): Recallable =
  ## registrationDefinitionsList
  ## Gets a list of the registration definitions.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "scope", newJString(scope))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var registrationDefinitionsList* = Call_RegistrationDefinitionsList_568217(
    name: "registrationDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions",
    validator: validate_RegistrationDefinitionsList_568218, base: "",
    url: url_RegistrationDefinitionsList_568219, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsCreateOrUpdate_568236 = ref object of OpenApiRestCall_567641
proc url_RegistrationDefinitionsCreateOrUpdate_568238(protocol: Scheme;
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

proc validate_RegistrationDefinitionsCreateOrUpdate_568237(path: JsonNode;
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
  var valid_568239 = path.getOrDefault("registrationDefinitionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "registrationDefinitionId", valid_568239
  var valid_568240 = path.getOrDefault("scope")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "scope", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
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

proc call*(call_568243: Call_RegistrationDefinitionsCreateOrUpdate_568236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a registration definition.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_RegistrationDefinitionsCreateOrUpdate_568236;
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
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  var body_568247 = newJObject()
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "registrationDefinitionId",
      newJString(registrationDefinitionId))
  if requestBody != nil:
    body_568247 = requestBody
  add(path_568245, "scope", newJString(scope))
  result = call_568244.call(path_568245, query_568246, nil, nil, body_568247)

var registrationDefinitionsCreateOrUpdate* = Call_RegistrationDefinitionsCreateOrUpdate_568236(
    name: "registrationDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions/{registrationDefinitionId}",
    validator: validate_RegistrationDefinitionsCreateOrUpdate_568237, base: "",
    url: url_RegistrationDefinitionsCreateOrUpdate_568238, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsGet_568226 = ref object of OpenApiRestCall_567641
proc url_RegistrationDefinitionsGet_568228(protocol: Scheme; host: string;
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

proc validate_RegistrationDefinitionsGet_568227(path: JsonNode; query: JsonNode;
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
  var valid_568229 = path.getOrDefault("registrationDefinitionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "registrationDefinitionId", valid_568229
  var valid_568230 = path.getOrDefault("scope")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "scope", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_RegistrationDefinitionsGet_568226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the registration definition details.
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_RegistrationDefinitionsGet_568226; apiVersion: string;
          registrationDefinitionId: string; scope: string): Recallable =
  ## registrationDefinitionsGet
  ## Gets the registration definition details.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   registrationDefinitionId: string (required)
  ##                           : Guid of the registration definition.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "registrationDefinitionId",
      newJString(registrationDefinitionId))
  add(path_568234, "scope", newJString(scope))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var registrationDefinitionsGet* = Call_RegistrationDefinitionsGet_568226(
    name: "registrationDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions/{registrationDefinitionId}",
    validator: validate_RegistrationDefinitionsGet_568227, base: "",
    url: url_RegistrationDefinitionsGet_568228, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsDelete_568248 = ref object of OpenApiRestCall_567641
proc url_RegistrationDefinitionsDelete_568250(protocol: Scheme; host: string;
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

proc validate_RegistrationDefinitionsDelete_568249(path: JsonNode; query: JsonNode;
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
  var valid_568251 = path.getOrDefault("registrationDefinitionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "registrationDefinitionId", valid_568251
  var valid_568252 = path.getOrDefault("scope")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "scope", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_RegistrationDefinitionsDelete_568248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the registration definition.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_RegistrationDefinitionsDelete_568248;
          apiVersion: string; registrationDefinitionId: string; scope: string): Recallable =
  ## registrationDefinitionsDelete
  ## Deletes the registration definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   registrationDefinitionId: string (required)
  ##                           : Guid of the registration definition.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "registrationDefinitionId",
      newJString(registrationDefinitionId))
  add(path_568256, "scope", newJString(scope))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var registrationDefinitionsDelete* = Call_RegistrationDefinitionsDelete_568248(
    name: "registrationDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions/{registrationDefinitionId}",
    validator: validate_RegistrationDefinitionsDelete_568249, base: "",
    url: url_RegistrationDefinitionsDelete_568250, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
