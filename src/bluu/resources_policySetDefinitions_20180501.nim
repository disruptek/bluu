
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: PolicyClient
## version: 2018-05-01
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
  macServiceName = "resources-policySetDefinitions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicySetDefinitionsListBuiltIn_563761 = ref object of OpenApiRestCall_563539
proc url_PolicySetDefinitionsListBuiltIn_563763(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PolicySetDefinitionsListBuiltIn_563762(path: JsonNode;
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

proc call*(call_563947: Call_PolicySetDefinitionsListBuiltIn_563761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of all the built-in policy set definitions.
  ## 
  let valid = call_563947.validator(path, query, header, formData, body)
  let scheme = call_563947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563947.url(scheme.get, call_563947.host, call_563947.base,
                         call_563947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563947, url, valid)

proc call*(call_564018: Call_PolicySetDefinitionsListBuiltIn_563761;
          apiVersion: string): Recallable =
  ## policySetDefinitionsListBuiltIn
  ## This operation retrieves a list of all the built-in policy set definitions.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_564019 = newJObject()
  add(query_564019, "api-version", newJString(apiVersion))
  result = call_564018.call(nil, query_564019, nil, nil, nil)

var policySetDefinitionsListBuiltIn* = Call_PolicySetDefinitionsListBuiltIn_563761(
    name: "policySetDefinitionsListBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Authorization/policySetDefinitions",
    validator: validate_PolicySetDefinitionsListBuiltIn_563762, base: "",
    url: url_PolicySetDefinitionsListBuiltIn_563763, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsGetBuiltIn_564059 = ref object of OpenApiRestCall_563539
proc url_PolicySetDefinitionsGetBuiltIn_564061(protocol: Scheme; host: string;
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

proc validate_PolicySetDefinitionsGetBuiltIn_564060(path: JsonNode;
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
  var valid_564076 = path.getOrDefault("policySetDefinitionName")
  valid_564076 = validateParameter(valid_564076, JString, required = true,
                                 default = nil)
  if valid_564076 != nil:
    section.add "policySetDefinitionName", valid_564076
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

proc call*(call_564078: Call_PolicySetDefinitionsGetBuiltIn_564059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves the built-in policy set definition with the given name.
  ## 
  let valid = call_564078.validator(path, query, header, formData, body)
  let scheme = call_564078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564078.url(scheme.get, call_564078.host, call_564078.base,
                         call_564078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564078, url, valid)

proc call*(call_564079: Call_PolicySetDefinitionsGetBuiltIn_564059;
          apiVersion: string; policySetDefinitionName: string): Recallable =
  ## policySetDefinitionsGetBuiltIn
  ## This operation retrieves the built-in policy set definition with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to get.
  var path_564080 = newJObject()
  var query_564081 = newJObject()
  add(query_564081, "api-version", newJString(apiVersion))
  add(path_564080, "policySetDefinitionName", newJString(policySetDefinitionName))
  result = call_564079.call(path_564080, query_564081, nil, nil, nil)

var policySetDefinitionsGetBuiltIn* = Call_PolicySetDefinitionsGetBuiltIn_564059(
    name: "policySetDefinitionsGetBuiltIn", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsGetBuiltIn_564060, base: "",
    url: url_PolicySetDefinitionsGetBuiltIn_564061, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsListByManagementGroup_564082 = ref object of OpenApiRestCall_563539
proc url_PolicySetDefinitionsListByManagementGroup_564084(protocol: Scheme;
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

proc validate_PolicySetDefinitionsListByManagementGroup_564083(path: JsonNode;
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

proc call*(call_564087: Call_PolicySetDefinitionsListByManagementGroup_564082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of all the a policy set definition in the given management group.
  ## 
  let valid = call_564087.validator(path, query, header, formData, body)
  let scheme = call_564087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564087.url(scheme.get, call_564087.host, call_564087.base,
                         call_564087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564087, url, valid)

proc call*(call_564088: Call_PolicySetDefinitionsListByManagementGroup_564082;
          managementGroupId: string; apiVersion: string): Recallable =
  ## policySetDefinitionsListByManagementGroup
  ## This operation retrieves a list of all the a policy set definition in the given management group.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var path_564089 = newJObject()
  var query_564090 = newJObject()
  add(path_564089, "managementGroupId", newJString(managementGroupId))
  add(query_564090, "api-version", newJString(apiVersion))
  result = call_564088.call(path_564089, query_564090, nil, nil, nil)

var policySetDefinitionsListByManagementGroup* = Call_PolicySetDefinitionsListByManagementGroup_564082(
    name: "policySetDefinitionsListByManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions",
    validator: validate_PolicySetDefinitionsListByManagementGroup_564083,
    base: "", url: url_PolicySetDefinitionsListByManagementGroup_564084,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_564101 = ref object of OpenApiRestCall_563539
proc url_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_564103(
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

proc validate_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_564102(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## This operation creates or updates a policy set definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to create.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564121 = path.getOrDefault("managementGroupId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "managementGroupId", valid_564121
  var valid_564122 = path.getOrDefault("policySetDefinitionName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "policySetDefinitionName", valid_564122
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
  ##             : The policy set definition properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564125: Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_564101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation creates or updates a policy set definition in the given management group with the given name.
  ## 
  let valid = call_564125.validator(path, query, header, formData, body)
  let scheme = call_564125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564125.url(scheme.get, call_564125.host, call_564125.base,
                         call_564125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564125, url, valid)

proc call*(call_564126: Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_564101;
          managementGroupId: string; apiVersion: string;
          policySetDefinitionName: string; parameters: JsonNode): Recallable =
  ## policySetDefinitionsCreateOrUpdateAtManagementGroup
  ## This operation creates or updates a policy set definition in the given management group with the given name.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to create.
  ##   parameters: JObject (required)
  ##             : The policy set definition properties.
  var path_564127 = newJObject()
  var query_564128 = newJObject()
  var body_564129 = newJObject()
  add(path_564127, "managementGroupId", newJString(managementGroupId))
  add(query_564128, "api-version", newJString(apiVersion))
  add(path_564127, "policySetDefinitionName", newJString(policySetDefinitionName))
  if parameters != nil:
    body_564129 = parameters
  result = call_564126.call(path_564127, query_564128, nil, nil, body_564129)

var policySetDefinitionsCreateOrUpdateAtManagementGroup* = Call_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_564101(
    name: "policySetDefinitionsCreateOrUpdateAtManagementGroup",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_564102,
    base: "", url: url_PolicySetDefinitionsCreateOrUpdateAtManagementGroup_564103,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsGetAtManagementGroup_564091 = ref object of OpenApiRestCall_563539
proc url_PolicySetDefinitionsGetAtManagementGroup_564093(protocol: Scheme;
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

proc validate_PolicySetDefinitionsGetAtManagementGroup_564092(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the policy set definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564094 = path.getOrDefault("managementGroupId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "managementGroupId", valid_564094
  var valid_564095 = path.getOrDefault("policySetDefinitionName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "policySetDefinitionName", valid_564095
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

proc call*(call_564097: Call_PolicySetDefinitionsGetAtManagementGroup_564091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves the policy set definition in the given management group with the given name.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_PolicySetDefinitionsGetAtManagementGroup_564091;
          managementGroupId: string; apiVersion: string;
          policySetDefinitionName: string): Recallable =
  ## policySetDefinitionsGetAtManagementGroup
  ## This operation retrieves the policy set definition in the given management group with the given name.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to get.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(path_564099, "managementGroupId", newJString(managementGroupId))
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "policySetDefinitionName", newJString(policySetDefinitionName))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var policySetDefinitionsGetAtManagementGroup* = Call_PolicySetDefinitionsGetAtManagementGroup_564091(
    name: "policySetDefinitionsGetAtManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsGetAtManagementGroup_564092, base: "",
    url: url_PolicySetDefinitionsGetAtManagementGroup_564093,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsDeleteAtManagementGroup_564130 = ref object of OpenApiRestCall_563539
proc url_PolicySetDefinitionsDeleteAtManagementGroup_564132(protocol: Scheme;
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

proc validate_PolicySetDefinitionsDeleteAtManagementGroup_564131(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation deletes the policy set definition in the given management group with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : The ID of the management group.
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564133 = path.getOrDefault("managementGroupId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "managementGroupId", valid_564133
  var valid_564134 = path.getOrDefault("policySetDefinitionName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "policySetDefinitionName", valid_564134
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

proc call*(call_564136: Call_PolicySetDefinitionsDeleteAtManagementGroup_564130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation deletes the policy set definition in the given management group with the given name.
  ## 
  let valid = call_564136.validator(path, query, header, formData, body)
  let scheme = call_564136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564136.url(scheme.get, call_564136.host, call_564136.base,
                         call_564136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564136, url, valid)

proc call*(call_564137: Call_PolicySetDefinitionsDeleteAtManagementGroup_564130;
          managementGroupId: string; apiVersion: string;
          policySetDefinitionName: string): Recallable =
  ## policySetDefinitionsDeleteAtManagementGroup
  ## This operation deletes the policy set definition in the given management group with the given name.
  ##   managementGroupId: string (required)
  ##                    : The ID of the management group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to delete.
  var path_564138 = newJObject()
  var query_564139 = newJObject()
  add(path_564138, "managementGroupId", newJString(managementGroupId))
  add(query_564139, "api-version", newJString(apiVersion))
  add(path_564138, "policySetDefinitionName", newJString(policySetDefinitionName))
  result = call_564137.call(path_564138, query_564139, nil, nil, nil)

var policySetDefinitionsDeleteAtManagementGroup* = Call_PolicySetDefinitionsDeleteAtManagementGroup_564130(
    name: "policySetDefinitionsDeleteAtManagementGroup",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Management/managementgroups/{managementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsDeleteAtManagementGroup_564131,
    base: "", url: url_PolicySetDefinitionsDeleteAtManagementGroup_564132,
    schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsList_564140 = ref object of OpenApiRestCall_563539
proc url_PolicySetDefinitionsList_564142(protocol: Scheme; host: string;
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

proc validate_PolicySetDefinitionsList_564141(path: JsonNode; query: JsonNode;
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

proc call*(call_564145: Call_PolicySetDefinitionsList_564140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves a list of all the policy set definitions in the given subscription.
  ## 
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_PolicySetDefinitionsList_564140; apiVersion: string;
          subscriptionId: string): Recallable =
  ## policySetDefinitionsList
  ## This operation retrieves a list of all the policy set definitions in the given subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  add(query_564148, "api-version", newJString(apiVersion))
  add(path_564147, "subscriptionId", newJString(subscriptionId))
  result = call_564146.call(path_564147, query_564148, nil, nil, nil)

var policySetDefinitionsList* = Call_PolicySetDefinitionsList_564140(
    name: "policySetDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions",
    validator: validate_PolicySetDefinitionsList_564141, base: "",
    url: url_PolicySetDefinitionsList_564142, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsCreateOrUpdate_564159 = ref object of OpenApiRestCall_563539
proc url_PolicySetDefinitionsCreateOrUpdate_564161(protocol: Scheme; host: string;
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

proc validate_PolicySetDefinitionsCreateOrUpdate_564160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation creates or updates a policy set definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to create.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("policySetDefinitionName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "policySetDefinitionName", valid_564163
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
  ##             : The policy set definition properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564166: Call_PolicySetDefinitionsCreateOrUpdate_564159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation creates or updates a policy set definition in the given subscription with the given name.
  ## 
  let valid = call_564166.validator(path, query, header, formData, body)
  let scheme = call_564166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564166.url(scheme.get, call_564166.host, call_564166.base,
                         call_564166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564166, url, valid)

proc call*(call_564167: Call_PolicySetDefinitionsCreateOrUpdate_564159;
          apiVersion: string; subscriptionId: string;
          policySetDefinitionName: string; parameters: JsonNode): Recallable =
  ## policySetDefinitionsCreateOrUpdate
  ## This operation creates or updates a policy set definition in the given subscription with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to create.
  ##   parameters: JObject (required)
  ##             : The policy set definition properties.
  var path_564168 = newJObject()
  var query_564169 = newJObject()
  var body_564170 = newJObject()
  add(query_564169, "api-version", newJString(apiVersion))
  add(path_564168, "subscriptionId", newJString(subscriptionId))
  add(path_564168, "policySetDefinitionName", newJString(policySetDefinitionName))
  if parameters != nil:
    body_564170 = parameters
  result = call_564167.call(path_564168, query_564169, nil, nil, body_564170)

var policySetDefinitionsCreateOrUpdate* = Call_PolicySetDefinitionsCreateOrUpdate_564159(
    name: "policySetDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsCreateOrUpdate_564160, base: "",
    url: url_PolicySetDefinitionsCreateOrUpdate_564161, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsGet_564149 = ref object of OpenApiRestCall_563539
proc url_PolicySetDefinitionsGet_564151(protocol: Scheme; host: string; base: string;
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

proc validate_PolicySetDefinitionsGet_564150(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the policy set definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  var valid_564153 = path.getOrDefault("policySetDefinitionName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "policySetDefinitionName", valid_564153
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

proc call*(call_564155: Call_PolicySetDefinitionsGet_564149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves the policy set definition in the given subscription with the given name.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_PolicySetDefinitionsGet_564149; apiVersion: string;
          subscriptionId: string; policySetDefinitionName: string): Recallable =
  ## policySetDefinitionsGet
  ## This operation retrieves the policy set definition in the given subscription with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to get.
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "policySetDefinitionName", newJString(policySetDefinitionName))
  result = call_564156.call(path_564157, query_564158, nil, nil, nil)

var policySetDefinitionsGet* = Call_PolicySetDefinitionsGet_564149(
    name: "policySetDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsGet_564150, base: "",
    url: url_PolicySetDefinitionsGet_564151, schemes: {Scheme.Https})
type
  Call_PolicySetDefinitionsDelete_564171 = ref object of OpenApiRestCall_563539
proc url_PolicySetDefinitionsDelete_564173(protocol: Scheme; host: string;
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

proc validate_PolicySetDefinitionsDelete_564172(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation deletes the policy set definition in the given subscription with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policySetDefinitionName: JString (required)
  ##                          : The name of the policy set definition to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564174 = path.getOrDefault("subscriptionId")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "subscriptionId", valid_564174
  var valid_564175 = path.getOrDefault("policySetDefinitionName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "policySetDefinitionName", valid_564175
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

proc call*(call_564177: Call_PolicySetDefinitionsDelete_564171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation deletes the policy set definition in the given subscription with the given name.
  ## 
  let valid = call_564177.validator(path, query, header, formData, body)
  let scheme = call_564177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564177.url(scheme.get, call_564177.host, call_564177.base,
                         call_564177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564177, url, valid)

proc call*(call_564178: Call_PolicySetDefinitionsDelete_564171; apiVersion: string;
          subscriptionId: string; policySetDefinitionName: string): Recallable =
  ## policySetDefinitionsDelete
  ## This operation deletes the policy set definition in the given subscription with the given name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policySetDefinitionName: string (required)
  ##                          : The name of the policy set definition to delete.
  var path_564179 = newJObject()
  var query_564180 = newJObject()
  add(query_564180, "api-version", newJString(apiVersion))
  add(path_564179, "subscriptionId", newJString(subscriptionId))
  add(path_564179, "policySetDefinitionName", newJString(policySetDefinitionName))
  result = call_564178.call(path_564179, query_564180, nil, nil, nil)

var policySetDefinitionsDelete* = Call_PolicySetDefinitionsDelete_564171(
    name: "policySetDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/{policySetDefinitionName}",
    validator: validate_PolicySetDefinitionsDelete_564172, base: "",
    url: url_PolicySetDefinitionsDelete_564173, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
