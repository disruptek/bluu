
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: InstanceMetadataClient
## version: 2019-03-11
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure Instance Metadata Client
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
  macServiceName = "imds"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AttestedGetDocument_593630 = ref object of OpenApiRestCall_593408
proc url_AttestedGetDocument_593632(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AttestedGetDocument_593631(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get Attested Data for the Virtual Machine.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  ##   nonce: JString
  ##        : This is a string of up to 32 random alphanumeric characters.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593804 = query.getOrDefault("api-version")
  valid_593804 = validateParameter(valid_593804, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593804 != nil:
    section.add "api-version", valid_593804
  var valid_593805 = query.getOrDefault("nonce")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = nil)
  if valid_593805 != nil:
    section.add "nonce", valid_593805
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_593806 = header.getOrDefault("Metadata")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = newJString("true"))
  if valid_593806 != nil:
    section.add "Metadata", valid_593806
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593829: Call_AttestedGetDocument_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Attested Data for the Virtual Machine.
  ## 
  let valid = call_593829.validator(path, query, header, formData, body)
  let scheme = call_593829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593829.url(scheme.get, call_593829.host, call_593829.base,
                         call_593829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593829, url, valid)

proc call*(call_593900: Call_AttestedGetDocument_593630;
          apiVersion: string = "2018-10-01"; nonce: string = ""): Recallable =
  ## attestedGetDocument
  ## Get Attested Data for the Virtual Machine.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  ##   nonce: string
  ##        : This is a string of up to 32 random alphanumeric characters.
  var query_593901 = newJObject()
  add(query_593901, "api-version", newJString(apiVersion))
  add(query_593901, "nonce", newJString(nonce))
  result = call_593900.call(nil, query_593901, nil, nil, nil)

var attestedGetDocument* = Call_AttestedGetDocument_593630(
    name: "attestedGetDocument", meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/attested/document", validator: validate_AttestedGetDocument_593631,
    base: "/metadata", url: url_AttestedGetDocument_593632, schemes: {Scheme.Https})
type
  Call_IdentityGetInfo_593941 = ref object of OpenApiRestCall_593408
proc url_IdentityGetInfo_593943(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityGetInfo_593942(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get information about AAD Metadata
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593944 = query.getOrDefault("api-version")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593944 != nil:
    section.add "api-version", valid_593944
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_593945 = header.getOrDefault("Metadata")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = newJString("true"))
  if valid_593945 != nil:
    section.add "Metadata", valid_593945
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593946: Call_IdentityGetInfo_593941; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about AAD Metadata
  ## 
  let valid = call_593946.validator(path, query, header, formData, body)
  let scheme = call_593946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593946.url(scheme.get, call_593946.host, call_593946.base,
                         call_593946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593946, url, valid)

proc call*(call_593947: Call_IdentityGetInfo_593941;
          apiVersion: string = "2018-10-01"): Recallable =
  ## identityGetInfo
  ## Get information about AAD Metadata
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  var query_593948 = newJObject()
  add(query_593948, "api-version", newJString(apiVersion))
  result = call_593947.call(nil, query_593948, nil, nil, nil)

var identityGetInfo* = Call_IdentityGetInfo_593941(name: "identityGetInfo",
    meth: HttpMethod.HttpGet, host: "169.254.169.254", route: "/identity/info",
    validator: validate_IdentityGetInfo_593942, base: "/metadata",
    url: url_IdentityGetInfo_593943, schemes: {Scheme.Https})
type
  Call_IdentityGetToken_593949 = ref object of OpenApiRestCall_593408
proc url_IdentityGetToken_593951(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityGetToken_593950(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get a Token from Azure AD
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   object_id: JString
  ##            : This identifies, by Azure AD object id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and msi_res_id.
  ##   client_id: JString
  ##            : This identifies, by Azure AD client id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with object_id and msi_res_id.
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  ##   resource: JString (required)
  ##           : This is the urlencoded identifier URI of the sink resource for the requested Azure AD token. The resulting token contains the corresponding aud for this resource.
  ##   bypass_cache: JString
  ##               : If provided, the value must be 'true'. This indicates to the server that the token must be retrieved from Azure AD and cannot be retrieved from an internal cache.
  ##   authority: JString
  ##            : This indicates the authority to request AAD tokens from. Defaults to the known authority of the identity to be used.
  ##   msi_res_id: JString
  ##             : This identifies, by urlencoded ARM resource id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and object_id.
  section = newJObject()
  var valid_593952 = query.getOrDefault("object_id")
  valid_593952 = validateParameter(valid_593952, JString, required = false,
                                 default = nil)
  if valid_593952 != nil:
    section.add "object_id", valid_593952
  var valid_593953 = query.getOrDefault("client_id")
  valid_593953 = validateParameter(valid_593953, JString, required = false,
                                 default = nil)
  if valid_593953 != nil:
    section.add "client_id", valid_593953
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593954 = query.getOrDefault("api-version")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593954 != nil:
    section.add "api-version", valid_593954
  var valid_593955 = query.getOrDefault("resource")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "resource", valid_593955
  var valid_593956 = query.getOrDefault("bypass_cache")
  valid_593956 = validateParameter(valid_593956, JString, required = false,
                                 default = newJString("true"))
  if valid_593956 != nil:
    section.add "bypass_cache", valid_593956
  var valid_593957 = query.getOrDefault("authority")
  valid_593957 = validateParameter(valid_593957, JString, required = false,
                                 default = nil)
  if valid_593957 != nil:
    section.add "authority", valid_593957
  var valid_593958 = query.getOrDefault("msi_res_id")
  valid_593958 = validateParameter(valid_593958, JString, required = false,
                                 default = nil)
  if valid_593958 != nil:
    section.add "msi_res_id", valid_593958
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_593959 = header.getOrDefault("Metadata")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = newJString("true"))
  if valid_593959 != nil:
    section.add "Metadata", valid_593959
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593960: Call_IdentityGetToken_593949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Token from Azure AD
  ## 
  let valid = call_593960.validator(path, query, header, formData, body)
  let scheme = call_593960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593960.url(scheme.get, call_593960.host, call_593960.base,
                         call_593960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593960, url, valid)

proc call*(call_593961: Call_IdentityGetToken_593949; resource: string;
          objectId: string = ""; clientId: string = "";
          apiVersion: string = "2018-10-01"; bypassCache: string = "true";
          authority: string = ""; msiResId: string = ""): Recallable =
  ## identityGetToken
  ## Get a Token from Azure AD
  ##   objectId: string
  ##           : This identifies, by Azure AD object id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and msi_res_id.
  ##   clientId: string
  ##           : This identifies, by Azure AD client id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with object_id and msi_res_id.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  ##   resource: string (required)
  ##           : This is the urlencoded identifier URI of the sink resource for the requested Azure AD token. The resulting token contains the corresponding aud for this resource.
  ##   bypassCache: string
  ##              : If provided, the value must be 'true'. This indicates to the server that the token must be retrieved from Azure AD and cannot be retrieved from an internal cache.
  ##   authority: string
  ##            : This indicates the authority to request AAD tokens from. Defaults to the known authority of the identity to be used.
  ##   msiResId: string
  ##           : This identifies, by urlencoded ARM resource id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and object_id.
  var query_593962 = newJObject()
  add(query_593962, "object_id", newJString(objectId))
  add(query_593962, "client_id", newJString(clientId))
  add(query_593962, "api-version", newJString(apiVersion))
  add(query_593962, "resource", newJString(resource))
  add(query_593962, "bypass_cache", newJString(bypassCache))
  add(query_593962, "authority", newJString(authority))
  add(query_593962, "msi_res_id", newJString(msiResId))
  result = call_593961.call(nil, query_593962, nil, nil, nil)

var identityGetToken* = Call_IdentityGetToken_593949(name: "identityGetToken",
    meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/identity/oauth2/token", validator: validate_IdentityGetToken_593950,
    base: "/metadata", url: url_IdentityGetToken_593951, schemes: {Scheme.Https})
type
  Call_InstancesGetMetadata_593963 = ref object of OpenApiRestCall_593408
proc url_InstancesGetMetadata_593965(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_InstancesGetMetadata_593964(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Instance Metadata for the Virtual Machine.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593966 = query.getOrDefault("api-version")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593966 != nil:
    section.add "api-version", valid_593966
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_593967 = header.getOrDefault("Metadata")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = newJString("true"))
  if valid_593967 != nil:
    section.add "Metadata", valid_593967
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593968: Call_InstancesGetMetadata_593963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Instance Metadata for the Virtual Machine.
  ## 
  let valid = call_593968.validator(path, query, header, formData, body)
  let scheme = call_593968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593968.url(scheme.get, call_593968.host, call_593968.base,
                         call_593968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593968, url, valid)

proc call*(call_593969: Call_InstancesGetMetadata_593963;
          apiVersion: string = "2018-10-01"): Recallable =
  ## instancesGetMetadata
  ## Get Instance Metadata for the Virtual Machine.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  var query_593970 = newJObject()
  add(query_593970, "api-version", newJString(apiVersion))
  result = call_593969.call(nil, query_593970, nil, nil, nil)

var instancesGetMetadata* = Call_InstancesGetMetadata_593963(
    name: "instancesGetMetadata", meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/instance", validator: validate_InstancesGetMetadata_593964,
    base: "/metadata", url: url_InstancesGetMetadata_593965, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
