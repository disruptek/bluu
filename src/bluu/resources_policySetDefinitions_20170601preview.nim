
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PolicyClient
## version: 2017-06-01-preview
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
  macServiceName = "resources-policySetDefinitions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicySetDefinitionsListBuiltIn_567863 = ref object of OpenApiRestCall_567641
proc url_PolicySetDefinitionsListBuiltIn_567865(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PolicySetDefinitionsListBuiltIn_567864(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the built in policy set definitions.
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

proc call*(call_568047: Call_PolicySetDefinitionsListBuiltIn_567863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the built in policy set definitions.
  ## 
  let valid = call_568047.validator(path, query, header, formData, body)
  let scheme = call_568047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568047.url(scheme.get, call_568047.host, call_568047.base,
                         call_568047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568047, url, valid)

proc call*(call_568118: Call_PolicySetDefinitionsListBuiltIn_567863;
          apiVersion: string): Recallable =
  ## policySetDefinitionsListBuiltIn
  ## Gets all the built in policy set definitions.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_568119 = newJObject()
  add(query_568119, "api-version", newJString(apiVersion))
  result = call_568118.call(nil, query_568119, nil, nil, nil)

var policySetDefinitionsListBuiltIn* = Call_PolicySetDefinitionsListBuiltIn_567863(
    name: "policySetDefinitionsListBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Authorization/policySetDefinitions",
    validator: validate_PolicySetDefinitionsListBuiltIn_567864, base: "",
    url: url_PolicySetDefinitionsListBuiltIn_567865, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsGetBuiltIn_568159 = ref object of OpenApiRestCall_567641
proc url_PolicySetDefinitionsGetBuiltIn_568161(protocol: Scheme; host: string;
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

proc validate_PolicySetDefinitionsGetBuiltIn_568160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the built in policy set definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policySetDefinitionName` field"
  var valid_568176 = path.getOrDefault("policySetDefinitionName")
  valid_568176 = validateParameter(valid_568176, JString, required = true,
                                 default = nil)
  if valid_568176 != nil:
    section.add "policySetDefinitionName", valid_568176
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

proc call*(call_568178: Call_PolicySetDefinitionsGetBuiltIn_568159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the built in policy set definition.
  ## 
  let valid = call_568178.validator(path, query, header, formData, body)
  let scheme = call_568178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568178.url(scheme.get, call_568178.host, call_568178.base,
                         call_568178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568178, url, valid)

proc call*(call_568179: Call_PolicySetDefinitionsGetBuiltIn_568159;
          policySetDefinitionName: string; apiVersion: string): Recallable =
  ## policySetDefinitionsGetBuiltIn
  ## Gets the built in policy set definition.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to get.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var path_568180 = newJObject()
  var query_568181 = newJObject()
  add(path_568180, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_568181, "api-version", newJString(apiVersion))
  result = call_568179.call(path_568180, query_568181, nil, nil, nil)

var policySetDefinitionsGetBuiltIn* = Call_PolicySetDefinitionsGetBuiltIn_568159(
    name: "policySetDefinitionsGetBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsGetBuiltIn_568160, base: "",
    url: url_PolicySetDefinitionsGetBuiltIn_568161, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsListByManagementGroup_568182 = ref object of OpenApiRestCall_567641
proc url_PolicySetDefinitionsListByManagementGroup_568184(protocol: Scheme;
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

proc validate_PolicySetDefinitionsListByManagementGroup_568183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the policy set definitions for a subscription at management group.
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

proc call*(call_568187: Call_PolicySetDefinitionsListByManagementGroup_568182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the policy set definitions for a subscription at management group.
  ## 
  let valid = call_568187.validator(path, query, header, formData, body)
  let scheme = call_568187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568187.url(scheme.get, call_568187.host, call_568187.base,
                         call_568187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568187, url, valid)

proc call*(call_568188: Call_PolicySetDefinitionsListByManagementGroup_568182;
          apiVersion: string; managementGroupId: string): Recallable =
  ## policySetDefinitionsListByManagementGroup
  ## Gets all the policy set definitions for a subscription at management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  var path_568189 = newJObject()
  var query_568190 = newJObject()
  add(query_568190, "api-version", newJString(apiVersion))
  add(path_568189, "managementGroupId", newJString(managementGroupId))
  result = call_568188.call(path_568189, query_568190, nil, nil, nil)

var policySetDefinitionsListByManagementGroup* = Call_PolicySetDefinitionsListByManagementGroup_568182(
    name: "policySetDefinitionsListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions",
    validator: validate_PolicySetDefinitionsListByManagementGroup_568183,
    base: "", url: url_PolicySetDefinitionsListByManagementGroup_568184,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_568201 = ref object of OpenApiRestCall_567641
proc url_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_568203(
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

proc validate_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_568202(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates a policy set definition at management group level.
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
  var valid_568221 = path.getOrDefault("policySetDefinitionName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "policySetDefinitionName", valid_568221
  var valid_568222 = path.getOrDefault("managementGroupId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "managementGroupId", valid_568222
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
  ##             : The policy set definition properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_568201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a policy set definition at management group level.
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_568201;
          policySetDefinitionName: string; apiVersion: string;
          managementGroupId: string; parameters: JsonNode): Recallable =
  ## policySetDefinitionsCreateOrUpdateAtManagementGroup
  ## Creates or updates a policy set definition at management group level.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to create.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   parameters: JObject (required)
  ##             : The policy set definition properties.
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  var body_568229 = newJObject()
  add(path_568227, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "managementGroupId", newJString(managementGroupId))
  if parameters != nil:
    body_568229 = parameters
  result = call_568226.call(path_568227, query_568228, nil, nil, body_568229)

var policySetDefinitionsCreateOrUpdateAtManagementGroup* = Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_568201(
    name: "policySetDefinitionsCreateOrUpdateAtManagementGroup",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_568202,
    base: "", url: url_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_568203,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsGetAtManagementGroup_568191 = ref object of OpenApiRestCall_567641
proc url_PolicySetDefinitionsGetAtManagementGroup_568193(protocol: Scheme;
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

proc validate_PolicySetDefinitionsGetAtManagementGroup_568192(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the policy set definition at management group level.
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
  var valid_568194 = path.getOrDefault("policySetDefinitionName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "policySetDefinitionName", valid_568194
  var valid_568195 = path.getOrDefault("managementGroupId")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "managementGroupId", valid_568195
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

proc call*(call_568197: Call_PolicySetDefinitionsGetAtManagementGroup_568191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the policy set definition at management group level.
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_PolicySetDefinitionsGetAtManagementGroup_568191;
          policySetDefinitionName: string; apiVersion: string;
          managementGroupId: string): Recallable =
  ## policySetDefinitionsGetAtManagementGroup
  ## Gets the policy set definition at management group level.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to get.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  add(path_568199, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "managementGroupId", newJString(managementGroupId))
  result = call_568198.call(path_568199, query_568200, nil, nil, nil)

var policySetDefinitionsGetAtManagementGroup* = Call_PolicySetDefinitionsGetAtManagementGroup_568191(
    name: "policySetDefinitionsGetAtManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsGetAtManagementGroup_568192, base: "",
    url: url_PolicySetDefinitionsGetAtManagementGroup_568193,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsDeleteAtManagementGroup_568230 = ref object of OpenApiRestCall_567641
proc url_PolicySetDefinitionsDeleteAtManagementGroup_568232(protocol: Scheme;
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

proc validate_PolicySetDefinitionsDeleteAtManagementGroup_568231(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a policy set definition at management group level.
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
  var valid_568233 = path.getOrDefault("policySetDefinitionName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "policySetDefinitionName", valid_568233
  var valid_568234 = path.getOrDefault("managementGroupId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "managementGroupId", valid_568234
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

proc call*(call_568236: Call_PolicySetDefinitionsDeleteAtManagementGroup_568230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a policy set definition at management group level.
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_PolicySetDefinitionsDeleteAtManagementGroup_568230;
          policySetDefinitionName: string; apiVersion: string;
          managementGroupId: string): Recallable =
  ## policySetDefinitionsDeleteAtManagementGroup
  ## Deletes a policy set definition at management group level.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to delete.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  add(path_568238, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "managementGroupId", newJString(managementGroupId))
  result = call_568237.call(path_568238, query_568239, nil, nil, nil)

var policySetDefinitionsDeleteAtManagementGroup* = Call_PolicySetDefinitionsDeleteAtManagementGroup_568230(
    name: "policySetDefinitionsDeleteAtManagementGroup",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsDeleteAtManagementGroup_568231,
    base: "", url: url_PolicySetDefinitionsDeleteAtManagementGroup_568232,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsList_568240 = ref object of OpenApiRestCall_567641
proc url_PolicySetDefinitionsList_568242(protocol: Scheme; host: string;
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

proc validate_PolicySetDefinitionsList_568241(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the policy set definitions for a subscription.
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

proc call*(call_568245: Call_PolicySetDefinitionsList_568240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the policy set definitions for a subscription.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_PolicySetDefinitionsList_568240; apiVersion: string;
          subscriptionId: string): Recallable =
  ## policySetDefinitionsList
  ## Gets all the policy set definitions for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  result = call_568246.call(path_568247, query_568248, nil, nil, nil)

var policySetDefinitionsList* = Call_PolicySetDefinitionsList_568240(
    name: "policySetDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions",
    validator: validate_PolicySetDefinitionsList_568241, base: "",
    url: url_PolicySetDefinitionsList_568242, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsCreateOrUpdate_568259 = ref object of OpenApiRestCall_567641
proc url_PolicySetDefinitionsCreateOrUpdate_568261(protocol: Scheme; host: string;
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

proc validate_PolicySetDefinitionsCreateOrUpdate_568260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a policy set definition.
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
  var valid_568262 = path.getOrDefault("policySetDefinitionName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "policySetDefinitionName", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
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
  ##             : The policy set definition properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_PolicySetDefinitionsCreateOrUpdate_568259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a policy set definition.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_PolicySetDefinitionsCreateOrUpdate_568259;
          policySetDefinitionName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## policySetDefinitionsCreateOrUpdate
  ## Creates or updates a policy set definition.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to create.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : The policy set definition properties.
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  var body_568270 = newJObject()
  add(path_568268, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568270 = parameters
  result = call_568267.call(path_568268, query_568269, nil, nil, body_568270)

var policySetDefinitionsCreateOrUpdate* = Call_PolicySetDefinitionsCreateOrUpdate_568259(
    name: "policySetDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsCreateOrUpdate_568260, base: "",
    url: url_PolicySetDefinitionsCreateOrUpdate_568261, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsGet_568249 = ref object of OpenApiRestCall_567641
proc url_PolicySetDefinitionsGet_568251(protocol: Scheme; host: string; base: string;
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

proc validate_PolicySetDefinitionsGet_568250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the policy set definition.
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
  var valid_568252 = path.getOrDefault("policySetDefinitionName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "policySetDefinitionName", valid_568252
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
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

proc call*(call_568255: Call_PolicySetDefinitionsGet_568249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the policy set definition.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_PolicySetDefinitionsGet_568249;
          policySetDefinitionName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## policySetDefinitionsGet
  ## Gets the policy set definition.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to get.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(path_568257, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var policySetDefinitionsGet* = Call_PolicySetDefinitionsGet_568249(
    name: "policySetDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsGet_568250, base: "",
    url: url_PolicySetDefinitionsGet_568251, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsDelete_568271 = ref object of OpenApiRestCall_567641
proc url_PolicySetDefinitionsDelete_568273(protocol: Scheme; host: string;
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

proc validate_PolicySetDefinitionsDelete_568272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a policy set definition.
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
  var valid_568274 = path.getOrDefault("policySetDefinitionName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "policySetDefinitionName", valid_568274
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
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

proc call*(call_568277: Call_PolicySetDefinitionsDelete_568271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a policy set definition.
  ## 
  let valid = call_568277.validator(path, query, header, formData, body)
  let scheme = call_568277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568277.url(scheme.get, call_568277.host, call_568277.base,
                         call_568277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568277, url, valid)

proc call*(call_568278: Call_PolicySetDefinitionsDelete_568271;
          policySetDefinitionName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## policySetDefinitionsDelete
  ## Deletes a policy set definition.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to delete.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568279 = newJObject()
  var query_568280 = newJObject()
  add(path_568279, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_568280, "api-version", newJString(apiVersion))
  add(path_568279, "subscriptionId", newJString(subscriptionId))
  result = call_568278.call(path_568279, query_568280, nil, nil, nil)

var policySetDefinitionsDelete* = Call_PolicySetDefinitionsDelete_568271(
    name: "policySetDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsDelete_568272, base: "",
    url: url_PolicySetDefinitionsDelete_568273, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
