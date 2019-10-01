
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on tenant entity associated with your Azure API Management deployment. Using this entity you can manage properties and configuration that apply to the entire API Management service instance.
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

  OpenApiRestCall_596441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596441): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimtenant"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TenantAccessGet_596663 = ref object of OpenApiRestCall_596441
proc url_TenantAccessGet_596665(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGet_596664(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get tenant access information details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_596851 = path.getOrDefault("accessName")
  valid_596851 = validateParameter(valid_596851, JString, required = true,
                                 default = newJString("access"))
  if valid_596851 != nil:
    section.add "accessName", valid_596851
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596852 = query.getOrDefault("api-version")
  valid_596852 = validateParameter(valid_596852, JString, required = true,
                                 default = nil)
  if valid_596852 != nil:
    section.add "api-version", valid_596852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596875: Call_TenantAccessGet_596663; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tenant access information details.
  ## 
  let valid = call_596875.validator(path, query, header, formData, body)
  let scheme = call_596875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596875.url(scheme.get, call_596875.host, call_596875.base,
                         call_596875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596875, url, valid)

proc call*(call_596946: Call_TenantAccessGet_596663; apiVersion: string;
          accessName: string = "access"): Recallable =
  ## tenantAccessGet
  ## Get tenant access information details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_596947 = newJObject()
  var query_596949 = newJObject()
  add(query_596949, "api-version", newJString(apiVersion))
  add(path_596947, "accessName", newJString(accessName))
  result = call_596946.call(path_596947, query_596949, nil, nil, nil)

var tenantAccessGet* = Call_TenantAccessGet_596663(name: "tenantAccessGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/tenant/{accessName}",
    validator: validate_TenantAccessGet_596664, base: "", url: url_TenantAccessGet_596665,
    schemes: {Scheme.Https})
type
  Call_TenantAccessUpdate_596988 = ref object of OpenApiRestCall_596441
proc url_TenantAccessUpdate_596990(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessUpdate_596989(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update tenant access information details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_597008 = path.getOrDefault("accessName")
  valid_597008 = validateParameter(valid_597008, JString, required = true,
                                 default = newJString("access"))
  if valid_597008 != nil:
    section.add "accessName", valid_597008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597009 = query.getOrDefault("api-version")
  valid_597009 = validateParameter(valid_597009, JString, required = true,
                                 default = nil)
  if valid_597009 != nil:
    section.add "api-version", valid_597009
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the property to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597010 = header.getOrDefault("If-Match")
  valid_597010 = validateParameter(valid_597010, JString, required = true,
                                 default = nil)
  if valid_597010 != nil:
    section.add "If-Match", valid_597010
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to retrieve the Tenant Access Information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597012: Call_TenantAccessUpdate_596988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tenant access information details.
  ## 
  let valid = call_597012.validator(path, query, header, formData, body)
  let scheme = call_597012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597012.url(scheme.get, call_597012.host, call_597012.base,
                         call_597012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597012, url, valid)

proc call*(call_597013: Call_TenantAccessUpdate_596988; apiVersion: string;
          parameters: JsonNode; accessName: string = "access"): Recallable =
  ## tenantAccessUpdate
  ## Update tenant access information details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to retrieve the Tenant Access Information.
  var path_597014 = newJObject()
  var query_597015 = newJObject()
  var body_597016 = newJObject()
  add(query_597015, "api-version", newJString(apiVersion))
  add(path_597014, "accessName", newJString(accessName))
  if parameters != nil:
    body_597016 = parameters
  result = call_597013.call(path_597014, query_597015, nil, nil, body_597016)

var tenantAccessUpdate* = Call_TenantAccessUpdate_596988(
    name: "tenantAccessUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/tenant/{accessName}", validator: validate_TenantAccessUpdate_596989,
    base: "", url: url_TenantAccessUpdate_596990, schemes: {Scheme.Https})
type
  Call_TenantAccessGitGet_597017 = ref object of OpenApiRestCall_596441
proc url_TenantAccessGitGet_597019(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/git")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitGet_597018(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the Git access configuration for the tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_597020 = path.getOrDefault("accessName")
  valid_597020 = validateParameter(valid_597020, JString, required = true,
                                 default = newJString("access"))
  if valid_597020 != nil:
    section.add "accessName", valid_597020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597021 = query.getOrDefault("api-version")
  valid_597021 = validateParameter(valid_597021, JString, required = true,
                                 default = nil)
  if valid_597021 != nil:
    section.add "api-version", valid_597021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597022: Call_TenantAccessGitGet_597017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Git access configuration for the tenant.
  ## 
  let valid = call_597022.validator(path, query, header, formData, body)
  let scheme = call_597022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597022.url(scheme.get, call_597022.host, call_597022.base,
                         call_597022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597022, url, valid)

proc call*(call_597023: Call_TenantAccessGitGet_597017; apiVersion: string;
          accessName: string = "access"): Recallable =
  ## tenantAccessGitGet
  ## Gets the Git access configuration for the tenant.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_597024 = newJObject()
  var query_597025 = newJObject()
  add(query_597025, "api-version", newJString(apiVersion))
  add(path_597024, "accessName", newJString(accessName))
  result = call_597023.call(path_597024, query_597025, nil, nil, nil)

var tenantAccessGitGet* = Call_TenantAccessGitGet_597017(
    name: "tenantAccessGitGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/tenant/{accessName}/git", validator: validate_TenantAccessGitGet_597018,
    base: "", url: url_TenantAccessGitGet_597019, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegeneratePrimaryKey_597026 = ref object of OpenApiRestCall_596441
proc url_TenantAccessGitRegeneratePrimaryKey_597028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/git/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitRegeneratePrimaryKey_597027(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate primary access key for GIT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_597029 = path.getOrDefault("accessName")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = newJString("access"))
  if valid_597029 != nil:
    section.add "accessName", valid_597029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597030 = query.getOrDefault("api-version")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "api-version", valid_597030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597031: Call_TenantAccessGitRegeneratePrimaryKey_597026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key for GIT.
  ## 
  let valid = call_597031.validator(path, query, header, formData, body)
  let scheme = call_597031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597031.url(scheme.get, call_597031.host, call_597031.base,
                         call_597031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597031, url, valid)

proc call*(call_597032: Call_TenantAccessGitRegeneratePrimaryKey_597026;
          apiVersion: string; accessName: string = "access"): Recallable =
  ## tenantAccessGitRegeneratePrimaryKey
  ## Regenerate primary access key for GIT.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_597033 = newJObject()
  var query_597034 = newJObject()
  add(query_597034, "api-version", newJString(apiVersion))
  add(path_597033, "accessName", newJString(accessName))
  result = call_597032.call(path_597033, query_597034, nil, nil, nil)

var tenantAccessGitRegeneratePrimaryKey* = Call_TenantAccessGitRegeneratePrimaryKey_597026(
    name: "tenantAccessGitRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{accessName}/git/regeneratePrimaryKey",
    validator: validate_TenantAccessGitRegeneratePrimaryKey_597027, base: "",
    url: url_TenantAccessGitRegeneratePrimaryKey_597028, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegenerateSecondaryKey_597035 = ref object of OpenApiRestCall_596441
proc url_TenantAccessGitRegenerateSecondaryKey_597037(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/git/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitRegenerateSecondaryKey_597036(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate secondary access key for GIT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_597038 = path.getOrDefault("accessName")
  valid_597038 = validateParameter(valid_597038, JString, required = true,
                                 default = newJString("access"))
  if valid_597038 != nil:
    section.add "accessName", valid_597038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597039 = query.getOrDefault("api-version")
  valid_597039 = validateParameter(valid_597039, JString, required = true,
                                 default = nil)
  if valid_597039 != nil:
    section.add "api-version", valid_597039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597040: Call_TenantAccessGitRegenerateSecondaryKey_597035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key for GIT.
  ## 
  let valid = call_597040.validator(path, query, header, formData, body)
  let scheme = call_597040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597040.url(scheme.get, call_597040.host, call_597040.base,
                         call_597040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597040, url, valid)

proc call*(call_597041: Call_TenantAccessGitRegenerateSecondaryKey_597035;
          apiVersion: string; accessName: string = "access"): Recallable =
  ## tenantAccessGitRegenerateSecondaryKey
  ## Regenerate secondary access key for GIT.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_597042 = newJObject()
  var query_597043 = newJObject()
  add(query_597043, "api-version", newJString(apiVersion))
  add(path_597042, "accessName", newJString(accessName))
  result = call_597041.call(path_597042, query_597043, nil, nil, nil)

var tenantAccessGitRegenerateSecondaryKey* = Call_TenantAccessGitRegenerateSecondaryKey_597035(
    name: "tenantAccessGitRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{accessName}/git/regenerateSecondaryKey",
    validator: validate_TenantAccessGitRegenerateSecondaryKey_597036, base: "",
    url: url_TenantAccessGitRegenerateSecondaryKey_597037, schemes: {Scheme.Https})
type
  Call_TenantAccessRegeneratePrimaryKey_597044 = ref object of OpenApiRestCall_596441
proc url_TenantAccessRegeneratePrimaryKey_597046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessRegeneratePrimaryKey_597045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate primary access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_597047 = path.getOrDefault("accessName")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = newJString("access"))
  if valid_597047 != nil:
    section.add "accessName", valid_597047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597048 = query.getOrDefault("api-version")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "api-version", valid_597048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597049: Call_TenantAccessRegeneratePrimaryKey_597044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key.
  ## 
  let valid = call_597049.validator(path, query, header, formData, body)
  let scheme = call_597049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597049.url(scheme.get, call_597049.host, call_597049.base,
                         call_597049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597049, url, valid)

proc call*(call_597050: Call_TenantAccessRegeneratePrimaryKey_597044;
          apiVersion: string; accessName: string = "access"): Recallable =
  ## tenantAccessRegeneratePrimaryKey
  ## Regenerate primary access key.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_597051 = newJObject()
  var query_597052 = newJObject()
  add(query_597052, "api-version", newJString(apiVersion))
  add(path_597051, "accessName", newJString(accessName))
  result = call_597050.call(path_597051, query_597052, nil, nil, nil)

var tenantAccessRegeneratePrimaryKey* = Call_TenantAccessRegeneratePrimaryKey_597044(
    name: "tenantAccessRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{accessName}/regeneratePrimaryKey",
    validator: validate_TenantAccessRegeneratePrimaryKey_597045, base: "",
    url: url_TenantAccessRegeneratePrimaryKey_597046, schemes: {Scheme.Https})
type
  Call_TenantAccessRegenerateSecondaryKey_597053 = ref object of OpenApiRestCall_596441
proc url_TenantAccessRegenerateSecondaryKey_597055(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessRegenerateSecondaryKey_597054(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate secondary access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_597056 = path.getOrDefault("accessName")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = newJString("access"))
  if valid_597056 != nil:
    section.add "accessName", valid_597056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597057 = query.getOrDefault("api-version")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "api-version", valid_597057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597058: Call_TenantAccessRegenerateSecondaryKey_597053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key.
  ## 
  let valid = call_597058.validator(path, query, header, formData, body)
  let scheme = call_597058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597058.url(scheme.get, call_597058.host, call_597058.base,
                         call_597058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597058, url, valid)

proc call*(call_597059: Call_TenantAccessRegenerateSecondaryKey_597053;
          apiVersion: string; accessName: string = "access"): Recallable =
  ## tenantAccessRegenerateSecondaryKey
  ## Regenerate secondary access key.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_597060 = newJObject()
  var query_597061 = newJObject()
  add(query_597061, "api-version", newJString(apiVersion))
  add(path_597060, "accessName", newJString(accessName))
  result = call_597059.call(path_597060, query_597061, nil, nil, nil)

var tenantAccessRegenerateSecondaryKey* = Call_TenantAccessRegenerateSecondaryKey_597053(
    name: "tenantAccessRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{accessName}/regenerateSecondaryKey",
    validator: validate_TenantAccessRegenerateSecondaryKey_597054, base: "",
    url: url_TenantAccessRegenerateSecondaryKey_597055, schemes: {Scheme.Https})
type
  Call_TenantConfigurationDeploy_597062 = ref object of OpenApiRestCall_596441
proc url_TenantConfigurationDeploy_597064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/deploy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationDeploy_597063(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configurationName` field"
  var valid_597065 = path.getOrDefault("configurationName")
  valid_597065 = validateParameter(valid_597065, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597065 != nil:
    section.add "configurationName", valid_597065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597066 = query.getOrDefault("api-version")
  valid_597066 = validateParameter(valid_597066, JString, required = true,
                                 default = nil)
  if valid_597066 != nil:
    section.add "api-version", valid_597066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Deploy Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597068: Call_TenantConfigurationDeploy_597062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  let valid = call_597068.validator(path, query, header, formData, body)
  let scheme = call_597068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597068.url(scheme.get, call_597068.host, call_597068.base,
                         call_597068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597068, url, valid)

proc call*(call_597069: Call_TenantConfigurationDeploy_597062; apiVersion: string;
          parameters: JsonNode; configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationDeploy
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   parameters: JObject (required)
  ##             : Deploy Configuration parameters.
  var path_597070 = newJObject()
  var query_597071 = newJObject()
  var body_597072 = newJObject()
  add(query_597071, "api-version", newJString(apiVersion))
  add(path_597070, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597072 = parameters
  result = call_597069.call(path_597070, query_597071, nil, nil, body_597072)

var tenantConfigurationDeploy* = Call_TenantConfigurationDeploy_597062(
    name: "tenantConfigurationDeploy", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{configurationName}/deploy",
    validator: validate_TenantConfigurationDeploy_597063, base: "",
    url: url_TenantConfigurationDeploy_597064, schemes: {Scheme.Https})
type
  Call_TenantConfigurationSave_597073 = ref object of OpenApiRestCall_596441
proc url_TenantConfigurationSave_597075(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/save")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationSave_597074(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configurationName` field"
  var valid_597076 = path.getOrDefault("configurationName")
  valid_597076 = validateParameter(valid_597076, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597076 != nil:
    section.add "configurationName", valid_597076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597077 = query.getOrDefault("api-version")
  valid_597077 = validateParameter(valid_597077, JString, required = true,
                                 default = nil)
  if valid_597077 != nil:
    section.add "api-version", valid_597077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Save Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597079: Call_TenantConfigurationSave_597073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  let valid = call_597079.validator(path, query, header, formData, body)
  let scheme = call_597079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597079.url(scheme.get, call_597079.host, call_597079.base,
                         call_597079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597079, url, valid)

proc call*(call_597080: Call_TenantConfigurationSave_597073; apiVersion: string;
          parameters: JsonNode; configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationSave
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   parameters: JObject (required)
  ##             : Save Configuration parameters.
  var path_597081 = newJObject()
  var query_597082 = newJObject()
  var body_597083 = newJObject()
  add(query_597082, "api-version", newJString(apiVersion))
  add(path_597081, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597083 = parameters
  result = call_597080.call(path_597081, query_597082, nil, nil, body_597083)

var tenantConfigurationSave* = Call_TenantConfigurationSave_597073(
    name: "tenantConfigurationSave", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/tenant/{configurationName}/save",
    validator: validate_TenantConfigurationSave_597074, base: "",
    url: url_TenantConfigurationSave_597075, schemes: {Scheme.Https})
type
  Call_TenantConfigurationGetSyncState_597084 = ref object of OpenApiRestCall_596441
proc url_TenantConfigurationGetSyncState_597086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/syncState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationGetSyncState_597085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configurationName` field"
  var valid_597087 = path.getOrDefault("configurationName")
  valid_597087 = validateParameter(valid_597087, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597087 != nil:
    section.add "configurationName", valid_597087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597088 = query.getOrDefault("api-version")
  valid_597088 = validateParameter(valid_597088, JString, required = true,
                                 default = nil)
  if valid_597088 != nil:
    section.add "api-version", valid_597088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597089: Call_TenantConfigurationGetSyncState_597084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  let valid = call_597089.validator(path, query, header, formData, body)
  let scheme = call_597089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597089.url(scheme.get, call_597089.host, call_597089.base,
                         call_597089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597089, url, valid)

proc call*(call_597090: Call_TenantConfigurationGetSyncState_597084;
          apiVersion: string; configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationGetSyncState
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  var path_597091 = newJObject()
  var query_597092 = newJObject()
  add(query_597092, "api-version", newJString(apiVersion))
  add(path_597091, "configurationName", newJString(configurationName))
  result = call_597090.call(path_597091, query_597092, nil, nil, nil)

var tenantConfigurationGetSyncState* = Call_TenantConfigurationGetSyncState_597084(
    name: "tenantConfigurationGetSyncState", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/tenant/{configurationName}/syncState",
    validator: validate_TenantConfigurationGetSyncState_597085, base: "",
    url: url_TenantConfigurationGetSyncState_597086, schemes: {Scheme.Https})
type
  Call_TenantConfigurationValidate_597093 = ref object of OpenApiRestCall_596441
proc url_TenantConfigurationValidate_597095(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationValidate_597094(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configurationName` field"
  var valid_597096 = path.getOrDefault("configurationName")
  valid_597096 = validateParameter(valid_597096, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597096 != nil:
    section.add "configurationName", valid_597096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597097 = query.getOrDefault("api-version")
  valid_597097 = validateParameter(valid_597097, JString, required = true,
                                 default = nil)
  if valid_597097 != nil:
    section.add "api-version", valid_597097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Validate Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597099: Call_TenantConfigurationValidate_597093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  let valid = call_597099.validator(path, query, header, formData, body)
  let scheme = call_597099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597099.url(scheme.get, call_597099.host, call_597099.base,
                         call_597099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597099, url, valid)

proc call*(call_597100: Call_TenantConfigurationValidate_597093;
          apiVersion: string; parameters: JsonNode;
          configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationValidate
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   parameters: JObject (required)
  ##             : Validate Configuration parameters.
  var path_597101 = newJObject()
  var query_597102 = newJObject()
  var body_597103 = newJObject()
  add(query_597102, "api-version", newJString(apiVersion))
  add(path_597101, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597103 = parameters
  result = call_597100.call(path_597101, query_597102, nil, nil, body_597103)

var tenantConfigurationValidate* = Call_TenantConfigurationValidate_597093(
    name: "tenantConfigurationValidate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{configurationName}/validate",
    validator: validate_TenantConfigurationValidate_597094, base: "",
    url: url_TenantConfigurationValidate_597095, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
