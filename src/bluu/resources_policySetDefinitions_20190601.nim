
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: PolicyClient
## version: 2019-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## To manage and control access to your resources, you can define customized policies and assign them at a scope.
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

  OpenApiRestCall_573641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573641): Option[Scheme] {.used.} =
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
  macServiceName = "resources-policySetDefinitions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicySetDefinitionsListBuiltIn_573863 = ref object of OpenApiRestCall_573641
proc url_PolicySetDefinitionsListBuiltIn_573865(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PolicySetDefinitionsListBuiltIn_573864(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a list of all the built-in policy set definitions.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574024 = query.getOrDefault("api-version")
  valid_574024 = validateParameter(valid_574024, JString, required = true,
                                 default = nil)
  if valid_574024 != nil:
    section.add "api-version", valid_574024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574047: Call_PolicySetDefinitionsListBuiltIn_573863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of all the built-in policy set definitions.
  ## 
  let valid = call_574047.validator(path, query, header, formData, body)
  let scheme = call_574047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574047.url(scheme.get, call_574047.host, call_574047.base,
                         call_574047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574047, url, valid)

proc call*(call_574118: Call_PolicySetDefinitionsListBuiltIn_573863;
          apiVersion: string): Recallable =
  ## policySetDefinitionsListBuiltIn
  ## This operation retrieves a list of all the built-in policy set definitions.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_574119 = newJObject()
  add(query_574119, "api-version", newJString(apiVersion))
  result = call_574118.call(nil, query_574119, nil, nil, nil)

var policySetDefinitionsListBuiltIn* = Call_PolicySetDefinitionsListBuiltIn_573863(
    name: "policySetDefinitionsListBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Authorization/policySetDefinitions",
    validator: validate_PolicySetDefinitionsListBuiltIn_573864, base: "",
    url: url_PolicySetDefinitionsListBuiltIn_573865, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsGetBuiltIn_574159 = ref object of OpenApiRestCall_573641
proc url_PolicySetDefinitionsGetBuiltIn_574161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policySetDefinitionName" in path,
        "`policySetDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.Authorization/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetDefinitionsGetBuiltIn_574160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the built-in policy set definition with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policySetDefinitionName` field"
  var valid_574176 = path.getOrDefault("policySetDefinitionName")
  valid_574176 = validateParameter(valid_574176, JString, required = true,
                                 default = nil)
  if valid_574176 != nil:
    section.add "policySetDefinitionName", valid_574176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574177 = query.getOrDefault("api-version")
  valid_574177 = validateParameter(valid_574177, JString, required = true,
                                 default = nil)
  if valid_574177 != nil:
    section.add "api-version", valid_574177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574178: Call_PolicySetDefinitionsGetBuiltIn_574159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves the built-in policy set definition with the given name.
  ## 
  let valid = call_574178.validator(path, query, header, formData, body)
  let scheme = call_574178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574178.url(scheme.get, call_574178.host, call_574178.base,
                         call_574178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574178, url, valid)

proc call*(call_574179: Call_PolicySetDefinitionsGetBuiltIn_574159;
          policySetDefinitionName: string; apiVersion: string): Recallable =
  ## policySetDefinitionsGetBuiltIn
  ## This operation retrieves the built-in policy set definition with the given name.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to get.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var path_574180 = newJObject()
  var query_574181 = newJObject()
  add(path_574180, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_574181, "api-version", newJString(apiVersion))
  result = call_574179.call(path_574180, query_574181, nil, nil, nil)

var policySetDefinitionsGetBuiltIn* = Call_PolicySetDefinitionsGetBuiltIn_574159(
    name: "policySetDefinitionsGetBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsGetBuiltIn_574160, base: "",
    url: url_PolicySetDefinitionsGetBuiltIn_574161, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsListByManagementGroup_574182 = ref object of OpenApiRestCall_573641
proc url_PolicySetDefinitionsListByManagementGroup_574184(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementgroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policySetDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetDefinitionsListByManagementGroup_574183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a list of all the a policy set definition in the given management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_574185 = path.getOrDefault("managementGroupId")
  valid_574185 = validateParameter(valid_574185, JString, required = true,
                                 default = nil)
  if valid_574185 != nil:
    section.add "managementGroupId", valid_574185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574186 = query.getOrDefault("api-version")
  valid_574186 = validateParameter(valid_574186, JString, required = true,
                                 default = nil)
  if valid_574186 != nil:
    section.add "api-version", valid_574186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574187: Call_PolicySetDefinitionsListByManagementGroup_574182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of all the a policy set definition in the given management group.
  ## 
  let valid = call_574187.validator(path, query, header, formData, body)
  let scheme = call_574187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574187.url(scheme.get, call_574187.host, call_574187.base,
                         call_574187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574187, url, valid)

proc call*(call_574188: Call_PolicySetDefinitionsListByManagementGroup_574182;
          apiVersion: string; managementGroupId: string): Recallable =
  ## policySetDefinitionsListByManagementGroup
  ## This operation retrieves a list of all the a policy set definition in the given management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  var path_574189 = newJObject()
  var query_574190 = newJObject()
  add(query_574190, "api-version", newJString(apiVersion))
  add(path_574189, "managementGroupId", newJString(managementGroupId))
  result = call_574188.call(path_574189, query_574190, nil, nil, nil)

var policySetDefinitionsListByManagementGroup* = Call_PolicySetDefinitionsListByManagementGroup_574182(
    name: "policySetDefinitionsListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions",
    validator: validate_PolicySetDefinitionsListByManagementGroup_574183,
    base: "", url: url_PolicySetDefinitionsListByManagementGroup_574184,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_574201 = ref object of OpenApiRestCall_573641
proc url_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_574203(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "policySetDefinitionName" in path,
        "`policySetDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementgroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_574202(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## This operation creates or updates a policy set definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to create.
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policySetDefinitionName` field"
  var valid_574221 = path.getOrDefault("policySetDefinitionName")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "policySetDefinitionName", valid_574221
  var valid_574222 = path.getOrDefault("managementGroupId")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "managementGroupId", valid_574222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574223 = query.getOrDefault("api-version")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "api-version", valid_574223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy set definition properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574225: Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_574201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation creates or updates a policy set definition in the given management group with the given name.
  ## 
  let valid = call_574225.validator(path, query, header, formData, body)
  let scheme = call_574225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574225.url(scheme.get, call_574225.host, call_574225.base,
                         call_574225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574225, url, valid)

proc call*(call_574226: Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_574201;
          policySetDefinitionName: string; apiVersion: string;
          managementGroupId: string; parameters: JsonNode): Recallable =
  ## policySetDefinitionsCreateOrUpdateAtManagementGroup
  ## This operation creates or updates a policy set definition in the given management group with the given name.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to create.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   parameters: JObject (required)
  ##             : The policy set definition properties.
  var path_574227 = newJObject()
  var query_574228 = newJObject()
  var body_574229 = newJObject()
  add(path_574227, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_574228, "api-version", newJString(apiVersion))
  add(path_574227, "managementGroupId", newJString(managementGroupId))
  if parameters != nil:
    body_574229 = parameters
  result = call_574226.call(path_574227, query_574228, nil, nil, body_574229)

var policySetDefinitionsCreateOrUpdateAtManagementGroup* = Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_574201(
    name: "policySetDefinitionsCreateOrUpdateAtManagementGroup",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_574202,
    base: "", url: url_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_574203,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsGetAtManagementGroup_574191 = ref object of OpenApiRestCall_573641
proc url_PolicySetDefinitionsGetAtManagementGroup_574193(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "policySetDefinitionName" in path,
        "`policySetDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementgroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetDefinitionsGetAtManagementGroup_574192(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the policy set definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to get.
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policySetDefinitionName` field"
  var valid_574194 = path.getOrDefault("policySetDefinitionName")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "policySetDefinitionName", valid_574194
  var valid_574195 = path.getOrDefault("managementGroupId")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "managementGroupId", valid_574195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574196 = query.getOrDefault("api-version")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "api-version", valid_574196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574197: Call_PolicySetDefinitionsGetAtManagementGroup_574191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves the policy set definition in the given management group with the given name.
  ## 
  let valid = call_574197.validator(path, query, header, formData, body)
  let scheme = call_574197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574197.url(scheme.get, call_574197.host, call_574197.base,
                         call_574197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574197, url, valid)

proc call*(call_574198: Call_PolicySetDefinitionsGetAtManagementGroup_574191;
          policySetDefinitionName: string; apiVersion: string;
          managementGroupId: string): Recallable =
  ## policySetDefinitionsGetAtManagementGroup
  ## This operation retrieves the policy set definition in the given management group with the given name.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to get.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  var path_574199 = newJObject()
  var query_574200 = newJObject()
  add(path_574199, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_574200, "api-version", newJString(apiVersion))
  add(path_574199, "managementGroupId", newJString(managementGroupId))
  result = call_574198.call(path_574199, query_574200, nil, nil, nil)

var policySetDefinitionsGetAtManagementGroup* = Call_PolicySetDefinitionsGetAtManagementGroup_574191(
    name: "policySetDefinitionsGetAtManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsGetAtManagementGroup_574192, base: "",
    url: url_PolicySetDefinitionsGetAtManagementGroup_574193,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsDeleteAtManagementGroup_574230 = ref object of OpenApiRestCall_573641
proc url_PolicySetDefinitionsDeleteAtManagementGroup_574232(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "policySetDefinitionName" in path,
        "`policySetDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementgroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetDefinitionsDeleteAtManagementGroup_574231(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation deletes the policy set definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to delete.
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policySetDefinitionName` field"
  var valid_574233 = path.getOrDefault("policySetDefinitionName")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "policySetDefinitionName", valid_574233
  var valid_574234 = path.getOrDefault("managementGroupId")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "managementGroupId", valid_574234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574235 = query.getOrDefault("api-version")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "api-version", valid_574235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574236: Call_PolicySetDefinitionsDeleteAtManagementGroup_574230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation deletes the policy set definition in the given management group with the given name.
  ## 
  let valid = call_574236.validator(path, query, header, formData, body)
  let scheme = call_574236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574236.url(scheme.get, call_574236.host, call_574236.base,
                         call_574236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574236, url, valid)

proc call*(call_574237: Call_PolicySetDefinitionsDeleteAtManagementGroup_574230;
          policySetDefinitionName: string; apiVersion: string;
          managementGroupId: string): Recallable =
  ## policySetDefinitionsDeleteAtManagementGroup
  ## This operation deletes the policy set definition in the given management group with the given name.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to delete.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  var path_574238 = newJObject()
  var query_574239 = newJObject()
  add(path_574238, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_574239, "api-version", newJString(apiVersion))
  add(path_574238, "managementGroupId", newJString(managementGroupId))
  result = call_574237.call(path_574238, query_574239, nil, nil, nil)

var policySetDefinitionsDeleteAtManagementGroup* = Call_PolicySetDefinitionsDeleteAtManagementGroup_574230(
    name: "policySetDefinitionsDeleteAtManagementGroup",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsDeleteAtManagementGroup_574231,
    base: "", url: url_PolicySetDefinitionsDeleteAtManagementGroup_574232,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsList_574240 = ref object of OpenApiRestCall_573641
proc url_PolicySetDefinitionsList_574242(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policySetDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetDefinitionsList_574241(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a list of all the policy set definitions in the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574243 = path.getOrDefault("subscriptionId")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "subscriptionId", valid_574243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574244 = query.getOrDefault("api-version")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "api-version", valid_574244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574245: Call_PolicySetDefinitionsList_574240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves a list of all the policy set definitions in the given subscription.
  ## 
  let valid = call_574245.validator(path, query, header, formData, body)
  let scheme = call_574245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574245.url(scheme.get, call_574245.host, call_574245.base,
                         call_574245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574245, url, valid)

proc call*(call_574246: Call_PolicySetDefinitionsList_574240; apiVersion: string;
          subscriptionId: string): Recallable =
  ## policySetDefinitionsList
  ## This operation retrieves a list of all the policy set definitions in the given subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574247 = newJObject()
  var query_574248 = newJObject()
  add(query_574248, "api-version", newJString(apiVersion))
  add(path_574247, "subscriptionId", newJString(subscriptionId))
  result = call_574246.call(path_574247, query_574248, nil, nil, nil)

var policySetDefinitionsList* = Call_PolicySetDefinitionsList_574240(
    name: "policySetDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions",
    validator: validate_PolicySetDefinitionsList_574241, base: "",
    url: url_PolicySetDefinitionsList_574242, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsCreateOrUpdate_574259 = ref object of OpenApiRestCall_573641
proc url_PolicySetDefinitionsCreateOrUpdate_574261(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policySetDefinitionName" in path,
        "`policySetDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetDefinitionsCreateOrUpdate_574260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation creates or updates a policy set definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to create.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policySetDefinitionName` field"
  var valid_574262 = path.getOrDefault("policySetDefinitionName")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "policySetDefinitionName", valid_574262
  var valid_574263 = path.getOrDefault("subscriptionId")
  valid_574263 = validateParameter(valid_574263, JString, required = true,
                                 default = nil)
  if valid_574263 != nil:
    section.add "subscriptionId", valid_574263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574264 = query.getOrDefault("api-version")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "api-version", valid_574264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy set definition properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574266: Call_PolicySetDefinitionsCreateOrUpdate_574259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation creates or updates a policy set definition in the given subscription with the given name.
  ## 
  let valid = call_574266.validator(path, query, header, formData, body)
  let scheme = call_574266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574266.url(scheme.get, call_574266.host, call_574266.base,
                         call_574266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574266, url, valid)

proc call*(call_574267: Call_PolicySetDefinitionsCreateOrUpdate_574259;
          policySetDefinitionName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## policySetDefinitionsCreateOrUpdate
  ## This operation creates or updates a policy set definition in the given subscription with the given name.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to create.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : The policy set definition properties.
  var path_574268 = newJObject()
  var query_574269 = newJObject()
  var body_574270 = newJObject()
  add(path_574268, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_574269, "api-version", newJString(apiVersion))
  add(path_574268, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574270 = parameters
  result = call_574267.call(path_574268, query_574269, nil, nil, body_574270)

var policySetDefinitionsCreateOrUpdate* = Call_PolicySetDefinitionsCreateOrUpdate_574259(
    name: "policySetDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsCreateOrUpdate_574260, base: "",
    url: url_PolicySetDefinitionsCreateOrUpdate_574261, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsGet_574249 = ref object of OpenApiRestCall_573641
proc url_PolicySetDefinitionsGet_574251(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policySetDefinitionName" in path,
        "`policySetDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetDefinitionsGet_574250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the policy set definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policySetDefinitionName` field"
  var valid_574252 = path.getOrDefault("policySetDefinitionName")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "policySetDefinitionName", valid_574252
  var valid_574253 = path.getOrDefault("subscriptionId")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "subscriptionId", valid_574253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574254 = query.getOrDefault("api-version")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "api-version", valid_574254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574255: Call_PolicySetDefinitionsGet_574249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves the policy set definition in the given subscription with the given name.
  ## 
  let valid = call_574255.validator(path, query, header, formData, body)
  let scheme = call_574255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574255.url(scheme.get, call_574255.host, call_574255.base,
                         call_574255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574255, url, valid)

proc call*(call_574256: Call_PolicySetDefinitionsGet_574249;
          policySetDefinitionName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## policySetDefinitionsGet
  ## This operation retrieves the policy set definition in the given subscription with the given name.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to get.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574257 = newJObject()
  var query_574258 = newJObject()
  add(path_574257, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_574258, "api-version", newJString(apiVersion))
  add(path_574257, "subscriptionId", newJString(subscriptionId))
  result = call_574256.call(path_574257, query_574258, nil, nil, nil)

var policySetDefinitionsGet* = Call_PolicySetDefinitionsGet_574249(
    name: "policySetDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsGet_574250, base: "",
    url: url_PolicySetDefinitionsGet_574251, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsDelete_574271 = ref object of OpenApiRestCall_573641
proc url_PolicySetDefinitionsDelete_574273(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policySetDefinitionName" in path,
        "`policySetDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetDefinitionsDelete_574272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation deletes the policy set definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to delete.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policySetDefinitionName` field"
  var valid_574274 = path.getOrDefault("policySetDefinitionName")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "policySetDefinitionName", valid_574274
  var valid_574275 = path.getOrDefault("subscriptionId")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "subscriptionId", valid_574275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574276 = query.getOrDefault("api-version")
  valid_574276 = validateParameter(valid_574276, JString, required = true,
                                 default = nil)
  if valid_574276 != nil:
    section.add "api-version", valid_574276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574277: Call_PolicySetDefinitionsDelete_574271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation deletes the policy set definition in the given subscription with the given name.
  ## 
  let valid = call_574277.validator(path, query, header, formData, body)
  let scheme = call_574277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574277.url(scheme.get, call_574277.host, call_574277.base,
                         call_574277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574277, url, valid)

proc call*(call_574278: Call_PolicySetDefinitionsDelete_574271;
          policySetDefinitionName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## policySetDefinitionsDelete
  ## This operation deletes the policy set definition in the given subscription with the given name.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to delete.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574279 = newJObject()
  var query_574280 = newJObject()
  add(path_574279, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_574280, "api-version", newJString(apiVersion))
  add(path_574279, "subscriptionId", newJString(subscriptionId))
  result = call_574278.call(path_574279, query_574280, nil, nil, nil)

var policySetDefinitionsDelete* = Call_PolicySetDefinitionsDelete_574271(
    name: "policySetDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsDelete_574272, base: "",
    url: url_PolicySetDefinitionsDelete_574273, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)