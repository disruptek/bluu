
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: PolicyClient
## version: 2016-12-01
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
  macServiceName = "resources-policyDefinitions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyDefinitionsListBuiltIn_563761 = ref object of OpenApiRestCall_563539
proc url_PolicyDefinitionsListBuiltIn_563763(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PolicyDefinitionsListBuiltIn_563762(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the built in policy definitions.
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

proc call*(call_563947: Call_PolicyDefinitionsListBuiltIn_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the built in policy definitions.
  ## 
  let valid = call_563947.validator(path, query, header, formData, body)
  let scheme = call_563947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563947.url(scheme.get, call_563947.host, call_563947.base,
                         call_563947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563947, url, valid)

proc call*(call_564018: Call_PolicyDefinitionsListBuiltIn_563761;
          apiVersion: string): Recallable =
  ## policyDefinitionsListBuiltIn
  ## Gets all the built in policy definitions.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_564019 = newJObject()
  add(query_564019, "api-version", newJString(apiVersion))
  result = call_564018.call(nil, query_564019, nil, nil, nil)

var policyDefinitionsListBuiltIn* = Call_PolicyDefinitionsListBuiltIn_563761(
    name: "policyDefinitionsListBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Authorization/policyDefinitions",
    validator: validate_PolicyDefinitionsListBuiltIn_563762, base: "",
    url: url_PolicyDefinitionsListBuiltIn_563763, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGetBuiltIn_564059 = ref object of OpenApiRestCall_563539
proc url_PolicyDefinitionsGetBuiltIn_564061(protocol: Scheme; host: string;
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

proc validate_PolicyDefinitionsGetBuiltIn_564060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the built in policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the built in policy definition to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyDefinitionName` field"
  var valid_564076 = path.getOrDefault("policyDefinitionName")
  valid_564076 = validateParameter(valid_564076, JString, required = true,
                                 default = nil)
  if valid_564076 != nil:
    section.add "policyDefinitionName", valid_564076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564077 = query.getOrDefault("api-version")
  valid_564077 = validateParameter(valid_564077, JString, required = true,
                                 default = nil)
  if valid_564077 != nil:
    section.add "api-version", valid_564077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564078: Call_PolicyDefinitionsGetBuiltIn_564059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the built in policy definition.
  ## 
  let valid = call_564078.validator(path, query, header, formData, body)
  let scheme = call_564078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564078.url(scheme.get, call_564078.host, call_564078.base,
                         call_564078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564078, url, valid)

proc call*(call_564079: Call_PolicyDefinitionsGetBuiltIn_564059;
          apiVersion: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsGetBuiltIn
  ## Gets the built in policy definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the built in policy definition to get.
  var path_564080 = newJObject()
  var query_564081 = newJObject()
  add(query_564081, "api-version", newJString(apiVersion))
  add(path_564080, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_564079.call(path_564080, query_564081, nil, nil, nil)

var policyDefinitionsGetBuiltIn* = Call_PolicyDefinitionsGetBuiltIn_564059(
    name: "policyDefinitionsGetBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGetBuiltIn_564060, base: "",
    url: url_PolicyDefinitionsGetBuiltIn_564061, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsListByManagementGroup_564082 = ref object of OpenApiRestCall_563539
proc url_PolicyDefinitionsListByManagementGroup_564084(protocol: Scheme;
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

proc validate_PolicyDefinitionsListByManagementGroup_564083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the policy definitions for a subscription at management group level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564085 = path.getOrDefault("managementGroupId")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "managementGroupId", valid_564085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564086 = query.getOrDefault("api-version")
  valid_564086 = validateParameter(valid_564086, JString, required = true,
                                 default = nil)
  if valid_564086 != nil:
    section.add "api-version", valid_564086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564087: Call_PolicyDefinitionsListByManagementGroup_564082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the policy definitions for a subscription at management group level.
  ## 
  let valid = call_564087.validator(path, query, header, formData, body)
  let scheme = call_564087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564087.url(scheme.get, call_564087.host, call_564087.base,
                         call_564087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564087, url, valid)

proc call*(call_564088: Call_PolicyDefinitionsListByManagementGroup_564082;
          managementGroupId: string; apiVersion: string): Recallable =
  ## policyDefinitionsListByManagementGroup
  ## Gets all the policy definitions for a subscription at management group level.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var path_564089 = newJObject()
  var query_564090 = newJObject()
  add(path_564089, "managementGroupId", newJString(managementGroupId))
  add(query_564090, "api-version", newJString(apiVersion))
  result = call_564088.call(path_564089, query_564090, nil, nil, nil)

var policyDefinitionsListByManagementGroup* = Call_PolicyDefinitionsListByManagementGroup_564082(
    name: "policyDefinitionsListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions",
    validator: validate_PolicyDefinitionsListByManagementGroup_564083, base: "",
    url: url_PolicyDefinitionsListByManagementGroup_564084,
    schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_564101 = ref object of OpenApiRestCall_563539
proc url_PolicyDefinitionsCreateOrUpdateAtManagementGroup_564103(
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

proc validate_PolicyDefinitionsCreateOrUpdateAtManagementGroup_564102(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates a policy definition at management group level.
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
  var valid_564121 = path.getOrDefault("managementGroupId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "managementGroupId", valid_564121
  var valid_564122 = path.getOrDefault("policyDefinitionName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "policyDefinitionName", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
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

proc call*(call_564125: Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_564101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a policy definition at management group level.
  ## 
  let valid = call_564125.validator(path, query, header, formData, body)
  let scheme = call_564125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564125.url(scheme.get, call_564125.host, call_564125.base,
                         call_564125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564125, url, valid)

proc call*(call_564126: Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_564101;
          managementGroupId: string; apiVersion: string;
          policyDefinitionName: string; parameters: JsonNode): Recallable =
  ## policyDefinitionsCreateOrUpdateAtManagementGroup
  ## Creates or updates a policy definition at management group level.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to create.
  ##   parameters: JObject (required)
  ##             : The policy definition properties.
  var path_564127 = newJObject()
  var query_564128 = newJObject()
  var body_564129 = newJObject()
  add(path_564127, "managementGroupId", newJString(managementGroupId))
  add(query_564128, "api-version", newJString(apiVersion))
  add(path_564127, "policyDefinitionName", newJString(policyDefinitionName))
  if parameters != nil:
    body_564129 = parameters
  result = call_564126.call(path_564127, query_564128, nil, nil, body_564129)

var policyDefinitionsCreateOrUpdateAtManagementGroup* = Call_PolicyDefinitionsCreateOrUpdateAtManagementGroup_564101(
    name: "policyDefinitionsCreateOrUpdateAtManagementGroup",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsCreateOrUpdateAtManagementGroup_564102,
    base: "", url: url_PolicyDefinitionsCreateOrUpdateAtManagementGroup_564103,
    schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGetAtManagementGroup_564091 = ref object of OpenApiRestCall_563539
proc url_PolicyDefinitionsGetAtManagementGroup_564093(protocol: Scheme;
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

proc validate_PolicyDefinitionsGetAtManagementGroup_564092(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the policy definition at management group level.
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
  var valid_564094 = path.getOrDefault("managementGroupId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "managementGroupId", valid_564094
  var valid_564095 = path.getOrDefault("policyDefinitionName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "policyDefinitionName", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_PolicyDefinitionsGetAtManagementGroup_564091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the policy definition at management group level.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_PolicyDefinitionsGetAtManagementGroup_564091;
          managementGroupId: string; apiVersion: string;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsGetAtManagementGroup
  ## Gets the policy definition at management group level.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to get.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(path_564099, "managementGroupId", newJString(managementGroupId))
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var policyDefinitionsGetAtManagementGroup* = Call_PolicyDefinitionsGetAtManagementGroup_564091(
    name: "policyDefinitionsGetAtManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGetAtManagementGroup_564092, base: "",
    url: url_PolicyDefinitionsGetAtManagementGroup_564093, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsDeleteAtManagementGroup_564130 = ref object of OpenApiRestCall_563539
proc url_PolicyDefinitionsDeleteAtManagementGroup_564132(protocol: Scheme;
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

proc validate_PolicyDefinitionsDeleteAtManagementGroup_564131(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a policy definition at management group level.
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
  var valid_564133 = path.getOrDefault("managementGroupId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "managementGroupId", valid_564133
  var valid_564134 = path.getOrDefault("policyDefinitionName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "policyDefinitionName", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564136: Call_PolicyDefinitionsDeleteAtManagementGroup_564130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a policy definition at management group level.
  ## 
  let valid = call_564136.validator(path, query, header, formData, body)
  let scheme = call_564136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564136.url(scheme.get, call_564136.host, call_564136.base,
                         call_564136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564136, url, valid)

proc call*(call_564137: Call_PolicyDefinitionsDeleteAtManagementGroup_564130;
          managementGroupId: string; apiVersion: string;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsDeleteAtManagementGroup
  ## Deletes a policy definition at management group level.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to delete.
  var path_564138 = newJObject()
  var query_564139 = newJObject()
  add(path_564138, "managementGroupId", newJString(managementGroupId))
  add(query_564139, "api-version", newJString(apiVersion))
  add(path_564138, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_564137.call(path_564138, query_564139, nil, nil, nil)

var policyDefinitionsDeleteAtManagementGroup* = Call_PolicyDefinitionsDeleteAtManagementGroup_564130(
    name: "policyDefinitionsDeleteAtManagementGroup", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsDeleteAtManagementGroup_564131, base: "",
    url: url_PolicyDefinitionsDeleteAtManagementGroup_564132,
    schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsList_564140 = ref object of OpenApiRestCall_563539
proc url_PolicyDefinitionsList_564142(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyDefinitionsList_564141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the policy definitions for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564143 = path.getOrDefault("subscriptionId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "subscriptionId", valid_564143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564144 = query.getOrDefault("api-version")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "api-version", valid_564144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564145: Call_PolicyDefinitionsList_564140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the policy definitions for a subscription.
  ## 
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_PolicyDefinitionsList_564140; apiVersion: string;
          subscriptionId: string): Recallable =
  ## policyDefinitionsList
  ## Gets all the policy definitions for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  add(query_564148, "api-version", newJString(apiVersion))
  add(path_564147, "subscriptionId", newJString(subscriptionId))
  result = call_564146.call(path_564147, query_564148, nil, nil, nil)

var policyDefinitionsList* = Call_PolicyDefinitionsList_564140(
    name: "policyDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions",
    validator: validate_PolicyDefinitionsList_564141, base: "",
    url: url_PolicyDefinitionsList_564142, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsCreateOrUpdate_564159 = ref object of OpenApiRestCall_563539
proc url_PolicyDefinitionsCreateOrUpdate_564161(protocol: Scheme; host: string;
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

proc validate_PolicyDefinitionsCreateOrUpdate_564160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a policy definition.
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
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("policyDefinitionName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "policyDefinitionName", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
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

proc call*(call_564166: Call_PolicyDefinitionsCreateOrUpdate_564159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a policy definition.
  ## 
  let valid = call_564166.validator(path, query, header, formData, body)
  let scheme = call_564166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564166.url(scheme.get, call_564166.host, call_564166.base,
                         call_564166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564166, url, valid)

proc call*(call_564167: Call_PolicyDefinitionsCreateOrUpdate_564159;
          apiVersion: string; subscriptionId: string; policyDefinitionName: string;
          parameters: JsonNode): Recallable =
  ## policyDefinitionsCreateOrUpdate
  ## Creates or updates a policy definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to create.
  ##   parameters: JObject (required)
  ##             : The policy definition properties.
  var path_564168 = newJObject()
  var query_564169 = newJObject()
  var body_564170 = newJObject()
  add(query_564169, "api-version", newJString(apiVersion))
  add(path_564168, "subscriptionId", newJString(subscriptionId))
  add(path_564168, "policyDefinitionName", newJString(policyDefinitionName))
  if parameters != nil:
    body_564170 = parameters
  result = call_564167.call(path_564168, query_564169, nil, nil, body_564170)

var policyDefinitionsCreateOrUpdate* = Call_PolicyDefinitionsCreateOrUpdate_564159(
    name: "policyDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsCreateOrUpdate_564160, base: "",
    url: url_PolicyDefinitionsCreateOrUpdate_564161, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGet_564149 = ref object of OpenApiRestCall_563539
proc url_PolicyDefinitionsGet_564151(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyDefinitionsGet_564150(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the policy definition.
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
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  var valid_564153 = path.getOrDefault("policyDefinitionName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "policyDefinitionName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564155: Call_PolicyDefinitionsGet_564149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the policy definition.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_PolicyDefinitionsGet_564149; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsGet
  ## Gets the policy definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to get.
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_564156.call(path_564157, query_564158, nil, nil, nil)

var policyDefinitionsGet* = Call_PolicyDefinitionsGet_564149(
    name: "policyDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGet_564150, base: "",
    url: url_PolicyDefinitionsGet_564151, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsDelete_564171 = ref object of OpenApiRestCall_563539
proc url_PolicyDefinitionsDelete_564173(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyDefinitionsDelete_564172(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a policy definition.
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
  var valid_564174 = path.getOrDefault("subscriptionId")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "subscriptionId", valid_564174
  var valid_564175 = path.getOrDefault("policyDefinitionName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "policyDefinitionName", valid_564175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564176 = query.getOrDefault("api-version")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "api-version", valid_564176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564177: Call_PolicyDefinitionsDelete_564171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a policy definition.
  ## 
  let valid = call_564177.validator(path, query, header, formData, body)
  let scheme = call_564177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564177.url(scheme.get, call_564177.host, call_564177.base,
                         call_564177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564177, url, valid)

proc call*(call_564178: Call_PolicyDefinitionsDelete_564171; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsDelete
  ## Deletes a policy definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to delete.
  var path_564179 = newJObject()
  var query_564180 = newJObject()
  add(query_564180, "api-version", newJString(apiVersion))
  add(path_564179, "subscriptionId", newJString(subscriptionId))
  add(path_564179, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_564178.call(path_564179, query_564180, nil, nil, nil)

var policyDefinitionsDelete* = Call_PolicyDefinitionsDelete_564171(
    name: "policyDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsDelete_564172, base: "",
    url: url_PolicyDefinitionsDelete_564173, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
