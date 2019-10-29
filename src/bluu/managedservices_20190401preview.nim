
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "managedservices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563761 = ref object of OpenApiRestCall_563539
proc url_OperationsList_563763(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563762(path: JsonNode; query: JsonNode;
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
  var valid_563924 = query.getOrDefault("api-version")
  valid_563924 = validateParameter(valid_563924, JString, required = true,
                                 default = nil)
  if valid_563924 != nil:
    section.add "api-version", valid_563924
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563947: Call_OperationsList_563761; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the operations.
  ## 
  let valid = call_563947.validator(path, query, header, formData, body)
  let scheme = call_563947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563947.url(scheme.get, call_563947.host, call_563947.base,
                         call_563947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563947, url, valid)

proc call*(call_564018: Call_OperationsList_563761; apiVersion: string): Recallable =
  ## operationsList
  ## Gets a list of the operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_564019 = newJObject()
  add(query_564019, "api-version", newJString(apiVersion))
  result = call_564018.call(nil, query_564019, nil, nil, nil)

var operationsList* = Call_OperationsList_563761(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ManagedServices/operations",
    validator: validate_OperationsList_563762, base: "", url: url_OperationsList_563763,
    schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsList_564059 = ref object of OpenApiRestCall_563539
proc url_RegistrationAssignmentsList_564061(protocol: Scheme; host: string;
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

proc validate_RegistrationAssignmentsList_564060(path: JsonNode; query: JsonNode;
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
  var valid_564077 = path.getOrDefault("scope")
  valid_564077 = validateParameter(valid_564077, JString, required = true,
                                 default = nil)
  if valid_564077 != nil:
    section.add "scope", valid_564077
  result.add "path", section
  ## parameters in `query` object:
  ##   $expandRegistrationDefinition: JBool
  ##                                : Tells whether to return registration definition details also along with registration assignment details.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_564078 = query.getOrDefault("$expandRegistrationDefinition")
  valid_564078 = validateParameter(valid_564078, JBool, required = false, default = nil)
  if valid_564078 != nil:
    section.add "$expandRegistrationDefinition", valid_564078
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564079 = query.getOrDefault("api-version")
  valid_564079 = validateParameter(valid_564079, JString, required = true,
                                 default = nil)
  if valid_564079 != nil:
    section.add "api-version", valid_564079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564080: Call_RegistrationAssignmentsList_564059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the registration assignments.
  ## 
  let valid = call_564080.validator(path, query, header, formData, body)
  let scheme = call_564080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564080.url(scheme.get, call_564080.host, call_564080.base,
                         call_564080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564080, url, valid)

proc call*(call_564081: Call_RegistrationAssignmentsList_564059;
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
  var path_564082 = newJObject()
  var query_564083 = newJObject()
  add(query_564083, "$expandRegistrationDefinition",
      newJBool(ExpandRegistrationDefinition))
  add(query_564083, "api-version", newJString(apiVersion))
  add(path_564082, "scope", newJString(scope))
  result = call_564081.call(path_564082, query_564083, nil, nil, nil)

var registrationAssignmentsList* = Call_RegistrationAssignmentsList_564059(
    name: "registrationAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments",
    validator: validate_RegistrationAssignmentsList_564060, base: "",
    url: url_RegistrationAssignmentsList_564061, schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsCreateOrUpdate_564095 = ref object of OpenApiRestCall_563539
proc url_RegistrationAssignmentsCreateOrUpdate_564097(protocol: Scheme;
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

proc validate_RegistrationAssignmentsCreateOrUpdate_564096(path: JsonNode;
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
  var valid_564098 = path.getOrDefault("registrationAssignmentId")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "registrationAssignmentId", valid_564098
  var valid_564099 = path.getOrDefault("scope")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "scope", valid_564099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564100 = query.getOrDefault("api-version")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "api-version", valid_564100
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

proc call*(call_564102: Call_RegistrationAssignmentsCreateOrUpdate_564095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a registration assignment.
  ## 
  let valid = call_564102.validator(path, query, header, formData, body)
  let scheme = call_564102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564102.url(scheme.get, call_564102.host, call_564102.base,
                         call_564102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564102, url, valid)

proc call*(call_564103: Call_RegistrationAssignmentsCreateOrUpdate_564095;
          apiVersion: string; requestBody: JsonNode;
          registrationAssignmentId: string; scope: string): Recallable =
  ## registrationAssignmentsCreateOrUpdate
  ## Creates or updates a registration assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   requestBody: JObject (required)
  ##              : The parameters required to create new registration assignment.
  ##   registrationAssignmentId: string (required)
  ##                           : Guid of the registration assignment.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_564104 = newJObject()
  var query_564105 = newJObject()
  var body_564106 = newJObject()
  add(query_564105, "api-version", newJString(apiVersion))
  if requestBody != nil:
    body_564106 = requestBody
  add(path_564104, "registrationAssignmentId",
      newJString(registrationAssignmentId))
  add(path_564104, "scope", newJString(scope))
  result = call_564103.call(path_564104, query_564105, nil, nil, body_564106)

var registrationAssignmentsCreateOrUpdate* = Call_RegistrationAssignmentsCreateOrUpdate_564095(
    name: "registrationAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments/{registrationAssignmentId}",
    validator: validate_RegistrationAssignmentsCreateOrUpdate_564096, base: "",
    url: url_RegistrationAssignmentsCreateOrUpdate_564097, schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsGet_564084 = ref object of OpenApiRestCall_563539
proc url_RegistrationAssignmentsGet_564086(protocol: Scheme; host: string;
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

proc validate_RegistrationAssignmentsGet_564085(path: JsonNode; query: JsonNode;
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
  var valid_564087 = path.getOrDefault("registrationAssignmentId")
  valid_564087 = validateParameter(valid_564087, JString, required = true,
                                 default = nil)
  if valid_564087 != nil:
    section.add "registrationAssignmentId", valid_564087
  var valid_564088 = path.getOrDefault("scope")
  valid_564088 = validateParameter(valid_564088, JString, required = true,
                                 default = nil)
  if valid_564088 != nil:
    section.add "scope", valid_564088
  result.add "path", section
  ## parameters in `query` object:
  ##   $expandRegistrationDefinition: JBool
  ##                                : Tells whether to return registration definition details also along with registration assignment details.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_564089 = query.getOrDefault("$expandRegistrationDefinition")
  valid_564089 = validateParameter(valid_564089, JBool, required = false, default = nil)
  if valid_564089 != nil:
    section.add "$expandRegistrationDefinition", valid_564089
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564090 = query.getOrDefault("api-version")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "api-version", valid_564090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564091: Call_RegistrationAssignmentsGet_564084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of specified registration assignment.
  ## 
  let valid = call_564091.validator(path, query, header, formData, body)
  let scheme = call_564091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564091.url(scheme.get, call_564091.host, call_564091.base,
                         call_564091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564091, url, valid)

proc call*(call_564092: Call_RegistrationAssignmentsGet_564084; apiVersion: string;
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
  var path_564093 = newJObject()
  var query_564094 = newJObject()
  add(query_564094, "$expandRegistrationDefinition",
      newJBool(ExpandRegistrationDefinition))
  add(query_564094, "api-version", newJString(apiVersion))
  add(path_564093, "registrationAssignmentId",
      newJString(registrationAssignmentId))
  add(path_564093, "scope", newJString(scope))
  result = call_564092.call(path_564093, query_564094, nil, nil, nil)

var registrationAssignmentsGet* = Call_RegistrationAssignmentsGet_564084(
    name: "registrationAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments/{registrationAssignmentId}",
    validator: validate_RegistrationAssignmentsGet_564085, base: "",
    url: url_RegistrationAssignmentsGet_564086, schemes: {Scheme.Https})
type
  Call_RegistrationAssignmentsDelete_564107 = ref object of OpenApiRestCall_563539
proc url_RegistrationAssignmentsDelete_564109(protocol: Scheme; host: string;
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

proc validate_RegistrationAssignmentsDelete_564108(path: JsonNode; query: JsonNode;
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
  var valid_564110 = path.getOrDefault("registrationAssignmentId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "registrationAssignmentId", valid_564110
  var valid_564111 = path.getOrDefault("scope")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "scope", valid_564111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564112 = query.getOrDefault("api-version")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "api-version", valid_564112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564113: Call_RegistrationAssignmentsDelete_564107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified registration assignment.
  ## 
  let valid = call_564113.validator(path, query, header, formData, body)
  let scheme = call_564113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564113.url(scheme.get, call_564113.host, call_564113.base,
                         call_564113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564113, url, valid)

proc call*(call_564114: Call_RegistrationAssignmentsDelete_564107;
          apiVersion: string; registrationAssignmentId: string; scope: string): Recallable =
  ## registrationAssignmentsDelete
  ## Deletes the specified registration assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   registrationAssignmentId: string (required)
  ##                           : Guid of the registration assignment.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_564115 = newJObject()
  var query_564116 = newJObject()
  add(query_564116, "api-version", newJString(apiVersion))
  add(path_564115, "registrationAssignmentId",
      newJString(registrationAssignmentId))
  add(path_564115, "scope", newJString(scope))
  result = call_564114.call(path_564115, query_564116, nil, nil, nil)

var registrationAssignmentsDelete* = Call_RegistrationAssignmentsDelete_564107(
    name: "registrationAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationAssignments/{registrationAssignmentId}",
    validator: validate_RegistrationAssignmentsDelete_564108, base: "",
    url: url_RegistrationAssignmentsDelete_564109, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsList_564117 = ref object of OpenApiRestCall_563539
proc url_RegistrationDefinitionsList_564119(protocol: Scheme; host: string;
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

proc validate_RegistrationDefinitionsList_564118(path: JsonNode; query: JsonNode;
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
  var valid_564120 = path.getOrDefault("scope")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "scope", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_RegistrationDefinitionsList_564117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the registration definitions.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_RegistrationDefinitionsList_564117;
          apiVersion: string; scope: string): Recallable =
  ## registrationDefinitionsList
  ## Gets a list of the registration definitions.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "scope", newJString(scope))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var registrationDefinitionsList* = Call_RegistrationDefinitionsList_564117(
    name: "registrationDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions",
    validator: validate_RegistrationDefinitionsList_564118, base: "",
    url: url_RegistrationDefinitionsList_564119, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsCreateOrUpdate_564136 = ref object of OpenApiRestCall_563539
proc url_RegistrationDefinitionsCreateOrUpdate_564138(protocol: Scheme;
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

proc validate_RegistrationDefinitionsCreateOrUpdate_564137(path: JsonNode;
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
  var valid_564139 = path.getOrDefault("registrationDefinitionId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "registrationDefinitionId", valid_564139
  var valid_564140 = path.getOrDefault("scope")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "scope", valid_564140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564141 = query.getOrDefault("api-version")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "api-version", valid_564141
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

proc call*(call_564143: Call_RegistrationDefinitionsCreateOrUpdate_564136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a registration definition.
  ## 
  let valid = call_564143.validator(path, query, header, formData, body)
  let scheme = call_564143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564143.url(scheme.get, call_564143.host, call_564143.base,
                         call_564143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564143, url, valid)

proc call*(call_564144: Call_RegistrationDefinitionsCreateOrUpdate_564136;
          registrationDefinitionId: string; apiVersion: string;
          requestBody: JsonNode; scope: string): Recallable =
  ## registrationDefinitionsCreateOrUpdate
  ## Creates or updates a registration definition.
  ##   registrationDefinitionId: string (required)
  ##                           : Guid of the registration definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   requestBody: JObject (required)
  ##              : The parameters required to create new registration definition.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_564145 = newJObject()
  var query_564146 = newJObject()
  var body_564147 = newJObject()
  add(path_564145, "registrationDefinitionId",
      newJString(registrationDefinitionId))
  add(query_564146, "api-version", newJString(apiVersion))
  if requestBody != nil:
    body_564147 = requestBody
  add(path_564145, "scope", newJString(scope))
  result = call_564144.call(path_564145, query_564146, nil, nil, body_564147)

var registrationDefinitionsCreateOrUpdate* = Call_RegistrationDefinitionsCreateOrUpdate_564136(
    name: "registrationDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions/{registrationDefinitionId}",
    validator: validate_RegistrationDefinitionsCreateOrUpdate_564137, base: "",
    url: url_RegistrationDefinitionsCreateOrUpdate_564138, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsGet_564126 = ref object of OpenApiRestCall_563539
proc url_RegistrationDefinitionsGet_564128(protocol: Scheme; host: string;
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

proc validate_RegistrationDefinitionsGet_564127(path: JsonNode; query: JsonNode;
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
  var valid_564129 = path.getOrDefault("registrationDefinitionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "registrationDefinitionId", valid_564129
  var valid_564130 = path.getOrDefault("scope")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "scope", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564131 = query.getOrDefault("api-version")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "api-version", valid_564131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564132: Call_RegistrationDefinitionsGet_564126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the registration definition details.
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_RegistrationDefinitionsGet_564126;
          registrationDefinitionId: string; apiVersion: string; scope: string): Recallable =
  ## registrationDefinitionsGet
  ## Gets the registration definition details.
  ##   registrationDefinitionId: string (required)
  ##                           : Guid of the registration definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  add(path_564134, "registrationDefinitionId",
      newJString(registrationDefinitionId))
  add(query_564135, "api-version", newJString(apiVersion))
  add(path_564134, "scope", newJString(scope))
  result = call_564133.call(path_564134, query_564135, nil, nil, nil)

var registrationDefinitionsGet* = Call_RegistrationDefinitionsGet_564126(
    name: "registrationDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions/{registrationDefinitionId}",
    validator: validate_RegistrationDefinitionsGet_564127, base: "",
    url: url_RegistrationDefinitionsGet_564128, schemes: {Scheme.Https})
type
  Call_RegistrationDefinitionsDelete_564148 = ref object of OpenApiRestCall_563539
proc url_RegistrationDefinitionsDelete_564150(protocol: Scheme; host: string;
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

proc validate_RegistrationDefinitionsDelete_564149(path: JsonNode; query: JsonNode;
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
  var valid_564151 = path.getOrDefault("registrationDefinitionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "registrationDefinitionId", valid_564151
  var valid_564152 = path.getOrDefault("scope")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "scope", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "api-version", valid_564153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564154: Call_RegistrationDefinitionsDelete_564148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the registration definition.
  ## 
  let valid = call_564154.validator(path, query, header, formData, body)
  let scheme = call_564154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564154.url(scheme.get, call_564154.host, call_564154.base,
                         call_564154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564154, url, valid)

proc call*(call_564155: Call_RegistrationDefinitionsDelete_564148;
          registrationDefinitionId: string; apiVersion: string; scope: string): Recallable =
  ## registrationDefinitionsDelete
  ## Deletes the registration definition.
  ##   registrationDefinitionId: string (required)
  ##                           : Guid of the registration definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : Scope of the resource.
  var path_564156 = newJObject()
  var query_564157 = newJObject()
  add(path_564156, "registrationDefinitionId",
      newJString(registrationDefinitionId))
  add(query_564157, "api-version", newJString(apiVersion))
  add(path_564156, "scope", newJString(scope))
  result = call_564155.call(path_564156, query_564157, nil, nil, nil)

var registrationDefinitionsDelete* = Call_RegistrationDefinitionsDelete_564148(
    name: "registrationDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedServices/registrationDefinitions/{registrationDefinitionId}",
    validator: validate_RegistrationDefinitionsDelete_564149, base: "",
    url: url_RegistrationDefinitionsDelete_564150, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
