
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PolicyClient
## version: 2019-01-01
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
  macServiceName = "resources-policyDefinitions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyDefinitionsListBuiltIn_567863 = ref object of OpenApiRestCall_567641
proc url_PolicyDefinitionsListBuiltIn_567865(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PolicyDefinitionsListBuiltIn_567864(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a list of all the built-in policy definitions.
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

proc call*(call_568047: Call_PolicyDefinitionsListBuiltIn_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves a list of all the built-in policy definitions.
  ## 
  let valid = call_568047.validator(path, query, header, formData, body)
  let scheme = call_568047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568047.url(scheme.get, call_568047.host, call_568047.base,
                         call_568047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568047, url, valid)

proc call*(call_568118: Call_PolicyDefinitionsListBuiltIn_567863;
          apiVersion: string): Recallable =
  ## policyDefinitionsListBuiltIn
  ## This operation retrieves a list of all the built-in policy definitions.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_568119 = newJObject()
  add(query_568119, "api-version", newJString(apiVersion))
  result = call_568118.call(nil, query_568119, nil, nil, nil)

var policyDefinitionsListBuiltIn* = Call_PolicyDefinitionsListBuiltIn_567863(
    name: "policyDefinitionsListBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Authorization/policyDefinitions",
    validator: validate_PolicyDefinitionsListBuiltIn_567864, base: "",
    url: url_PolicyDefinitionsListBuiltIn_567865, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGetBuiltIn_568159 = ref object of OpenApiRestCall_567641
proc url_PolicyDefinitionsGetBuiltIn_568161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsGetBuiltIn_568160(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the built-in policy definition with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the built-in policy definition to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyDefinitionName` field"
  var valid_568176 = path.getOrDefault("policyDefinitionName")
  valid_568176 = validateParameter(valid_568176, JString, required = true,
                                 default = nil)
  if valid_568176 != nil:
    section.add "policyDefinitionName", valid_568176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568177 = query.getOrDefault("api-version")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = nil)
  if valid_568177 != nil:
    section.add "api-version", valid_568177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568178: Call_PolicyDefinitionsGetBuiltIn_568159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves the built-in policy definition with the given name.
  ## 
  let valid = call_568178.validator(path, query, header, formData, body)
  let scheme = call_568178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568178.url(scheme.get, call_568178.host, call_568178.base,
                         call_568178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568178, url, valid)

proc call*(call_568179: Call_PolicyDefinitionsGetBuiltIn_568159;
          apiVersion: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsGetBuiltIn
  ## This operation retrieves the built-in policy definition with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the built-in policy definition to get.
  var path_568180 = newJObject()
  var query_568181 = newJObject()
  add(query_568181, "api-version", newJString(apiVersion))
  add(path_568180, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568179.call(path_568180, query_568181, nil, nil, nil)

var policyDefinitionsGetBuiltIn* = Call_PolicyDefinitionsGetBuiltIn_568159(
    name: "policyDefinitionsGetBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGetBuiltIn_568160, base: "",
    url: url_PolicyDefinitionsGetBuiltIn_568161, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsListByManagementGroup_568182 = ref object of OpenApiRestCall_567641
proc url_PolicyDefinitionsListByManagementGroup_568184(protocol: Scheme;
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
        value: "/providers/Microsoft.Authorization/policyDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsListByManagementGroup_568183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a list of all the policy definitions in a given management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568185 = path.getOrDefault("managementGroupId")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "managementGroupId", valid_568185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568186 = query.getOrDefault("api-version")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "api-version", valid_568186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568187: Call_PolicyDefinitionsListByManagementGroup_568182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of all the policy definitions in a given management group.
  ## 
  let valid = call_568187.validator(path, query, header, formData, body)
  let scheme = call_568187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568187.url(scheme.get, call_568187.host, call_568187.base,
                         call_568187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568187, url, valid)

proc call*(call_568188: Call_PolicyDefinitionsListByManagementGroup_568182;
          apiVersion: string; managementGroupId: string): Recallable =
  ## policyDefinitionsListByManagementGroup
  ## This operation retrieves a list of all the policy definitions in a given management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  var path_568189 = newJObject()
  var query_568190 = newJObject()
  add(query_568190, "api-version", newJString(apiVersion))
  add(path_568189, "managementGroupId", newJString(managementGroupId))
  result = call_568188.call(path_568189, query_568190, nil, nil, nil)

var policyDefinitionsListByManagementGroup* = Call_PolicyDefinitionsListByManagementGroup_568182(
    name: "policyDefinitionsListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions",
    validator: validate_PolicyDefinitionsListByManagementGroup_568183, base: "",
    url: url_PolicyDefinitionsListByManagementGroup_568184,
    schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_568201 = ref object of OpenApiRestCall_567641
proc url_PolicyDefinitionsCreateOrUpdateAtManagementGroup_568203(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementgroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsCreateOrUpdateAtManagementGroup_568202(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## This operation creates or updates a policy definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to create.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568221 = path.getOrDefault("managementGroupId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "managementGroupId", valid_568221
  var valid_568222 = path.getOrDefault("policyDefinitionName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "policyDefinitionName", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy definition properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_568201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation creates or updates a policy definition in the given management group with the given name.
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_568201;
          apiVersion: string; managementGroupId: string; parameters: JsonNode;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsCreateOrUpdateAtManagementGroup
  ## This operation creates or updates a policy definition in the given management group with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   parameters: JObject (required)
  ##             : The policy definition properties.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to create.
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  var body_568229 = newJObject()
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "managementGroupId", newJString(managementGroupId))
  if parameters != nil:
    body_568229 = parameters
  add(path_568227, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568226.call(path_568227, query_568228, nil, nil, body_568229)

var policyDefinitionsCreateOrUpdateAtManagementGroup* = Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_568201(
    name: "policyDefinitionsCreateOrUpdateAtManagementGroup",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsCreateOrUpdateAtManagementGroup_568202,
    base: "", url: url_PolicyDefinitionsCreateOrUpdateAtManagementGroup_568203,
    schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGetAtManagementGroup_568191 = ref object of OpenApiRestCall_567641
proc url_PolicyDefinitionsGetAtManagementGroup_568193(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementgroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsGetAtManagementGroup_568192(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the policy definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568194 = path.getOrDefault("managementGroupId")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "managementGroupId", valid_568194
  var valid_568195 = path.getOrDefault("policyDefinitionName")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "policyDefinitionName", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568197: Call_PolicyDefinitionsGetAtManagementGroup_568191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves the policy definition in the given management group with the given name.
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_PolicyDefinitionsGetAtManagementGroup_568191;
          apiVersion: string; managementGroupId: string;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsGetAtManagementGroup
  ## This operation retrieves the policy definition in the given management group with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to get.
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "managementGroupId", newJString(managementGroupId))
  add(path_568199, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568198.call(path_568199, query_568200, nil, nil, nil)

var policyDefinitionsGetAtManagementGroup* = Call_PolicyDefinitionsGetAtManagementGroup_568191(
    name: "policyDefinitionsGetAtManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGetAtManagementGroup_568192, base: "",
    url: url_PolicyDefinitionsGetAtManagementGroup_568193, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsDeleteAtManagementGroup_568230 = ref object of OpenApiRestCall_567641
proc url_PolicyDefinitionsDeleteAtManagementGroup_568232(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementgroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsDeleteAtManagementGroup_568231(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation deletes the policy definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_568233 = path.getOrDefault("managementGroupId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "managementGroupId", valid_568233
  var valid_568234 = path.getOrDefault("policyDefinitionName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "policyDefinitionName", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "api-version", valid_568235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_PolicyDefinitionsDeleteAtManagementGroup_568230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation deletes the policy definition in the given management group with the given name.
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_PolicyDefinitionsDeleteAtManagementGroup_568230;
          apiVersion: string; managementGroupId: string;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsDeleteAtManagementGroup
  ## This operation deletes the policy definition in the given management group with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to delete.
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "managementGroupId", newJString(managementGroupId))
  add(path_568238, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568237.call(path_568238, query_568239, nil, nil, nil)

var policyDefinitionsDeleteAtManagementGroup* = Call_PolicyDefinitionsDeleteAtManagementGroup_568230(
    name: "policyDefinitionsDeleteAtManagementGroup", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsDeleteAtManagementGroup_568231, base: "",
    url: url_PolicyDefinitionsDeleteAtManagementGroup_568232,
    schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsList_568240 = ref object of OpenApiRestCall_567641
proc url_PolicyDefinitionsList_568242(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Authorization/policyDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsList_568241(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a list of all the policy definitions in a given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "api-version", valid_568244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_PolicyDefinitionsList_568240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves a list of all the policy definitions in a given subscription.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_PolicyDefinitionsList_568240; apiVersion: string;
          subscriptionId: string): Recallable =
  ## policyDefinitionsList
  ## This operation retrieves a list of all the policy definitions in a given subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  result = call_568246.call(path_568247, query_568248, nil, nil, nil)

var policyDefinitionsList* = Call_PolicyDefinitionsList_568240(
    name: "policyDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions",
    validator: validate_PolicyDefinitionsList_568241, base: "",
    url: url_PolicyDefinitionsList_568242, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsCreateOrUpdate_568259 = ref object of OpenApiRestCall_567641
proc url_PolicyDefinitionsCreateOrUpdate_568261(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsCreateOrUpdate_568260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation creates or updates a policy definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to create.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568262 = path.getOrDefault("subscriptionId")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "subscriptionId", valid_568262
  var valid_568263 = path.getOrDefault("policyDefinitionName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "policyDefinitionName", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568264 = query.getOrDefault("api-version")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "api-version", valid_568264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy definition properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_PolicyDefinitionsCreateOrUpdate_568259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation creates or updates a policy definition in the given subscription with the given name.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_PolicyDefinitionsCreateOrUpdate_568259;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsCreateOrUpdate
  ## This operation creates or updates a policy definition in the given subscription with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : The policy definition properties.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to create.
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  var body_568270 = newJObject()
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568270 = parameters
  add(path_568268, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568267.call(path_568268, query_568269, nil, nil, body_568270)

var policyDefinitionsCreateOrUpdate* = Call_PolicyDefinitionsCreateOrUpdate_568259(
    name: "policyDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsCreateOrUpdate_568260, base: "",
    url: url_PolicyDefinitionsCreateOrUpdate_568261, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGet_568249 = ref object of OpenApiRestCall_567641
proc url_PolicyDefinitionsGet_568251(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsGet_568250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the policy definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568252 = path.getOrDefault("subscriptionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "subscriptionId", valid_568252
  var valid_568253 = path.getOrDefault("policyDefinitionName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "policyDefinitionName", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_PolicyDefinitionsGet_568249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves the policy definition in the given subscription with the given name.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_PolicyDefinitionsGet_568249; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsGet
  ## This operation retrieves the policy definition in the given subscription with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to get.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  add(path_568257, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var policyDefinitionsGet* = Call_PolicyDefinitionsGet_568249(
    name: "policyDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGet_568250, base: "",
    url: url_PolicyDefinitionsGet_568251, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsDelete_568271 = ref object of OpenApiRestCall_567641
proc url_PolicyDefinitionsDelete_568273(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsDelete_568272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation deletes the policy definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568274 = path.getOrDefault("subscriptionId")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "subscriptionId", valid_568274
  var valid_568275 = path.getOrDefault("policyDefinitionName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "policyDefinitionName", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568277: Call_PolicyDefinitionsDelete_568271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation deletes the policy definition in the given subscription with the given name.
  ## 
  let valid = call_568277.validator(path, query, header, formData, body)
  let scheme = call_568277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568277.url(scheme.get, call_568277.host, call_568277.base,
                         call_568277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568277, url, valid)

proc call*(call_568278: Call_PolicyDefinitionsDelete_568271; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsDelete
  ## This operation deletes the policy definition in the given subscription with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to delete.
  var path_568279 = newJObject()
  var query_568280 = newJObject()
  add(query_568280, "api-version", newJString(apiVersion))
  add(path_568279, "subscriptionId", newJString(subscriptionId))
  add(path_568279, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568278.call(path_568279, query_568280, nil, nil, nil)

var policyDefinitionsDelete* = Call_PolicyDefinitionsDelete_568271(
    name: "policyDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsDelete_568272, base: "",
    url: url_PolicyDefinitionsDelete_568273, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
